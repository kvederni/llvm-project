//===- Transforms.cpp ---------------------------------------------- C++ --===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Mesh/Transforms/Transforms.h"
#include "TransformsDetail.h"
#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Affine/Utils.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Arith/Utils/Utils.h"
#include "mlir/Dialect/ControlFlow/IR/ControlFlow.h"
#include "mlir/Dialect/ControlFlow/IR/ControlFlowOps.h"
#include "mlir/Dialect/Mesh/IR/MeshDialect.h"
#include "mlir/Dialect/Mesh/IR/MeshOps.h"
#include "mlir/Dialect/Tensor/IR/Tensor.h"
#include "mlir/Dialect/Utils/StaticValueUtils.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/DialectRegistry.h"
#include "mlir/IR/OpDefinition.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/IR/Value.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include <iterator>
#include <numeric>

namespace mlir::mesh {

namespace {

/// Lower `mesh.process_multi_index` into expression using
/// `mesh.process_linear_index` and `mesh.mesh_shape`.
struct ProcessMultiIndexOpLowering
    : OpRewritePatternWithSymbolTableCollection<ProcessMultiIndexOp> {
  using OpRewritePatternWithSymbolTableCollection::
      OpRewritePatternWithSymbolTableCollection;

  LogicalResult matchAndRewrite(ProcessMultiIndexOp op,
                                PatternRewriter &rewriter) const override {
    MeshOp mesh = getMesh(op, symbolTableCollection);
    if (!mesh) {
      return failure();
    }

    ImplicitLocOpBuilder builder(op->getLoc(), rewriter);
    builder.setInsertionPointAfter(op.getOperation());
    Value linearIndex = ProcessLinearIndexOp::create(builder, mesh);
    ValueRange meshShape = MeshShapeOp::create(builder, mesh).getResults();
    SmallVector<Value> completeMultiIndex =
        affine::AffineDelinearizeIndexOp::create(builder, linearIndex,
                                                 meshShape)
            .getMultiIndex();
    SmallVector<Value> multiIndex;
    ArrayRef<MeshAxis> opMeshAxes = op.getAxes();
    SmallVector<MeshAxis> opAxesIota;
    if (opMeshAxes.empty()) {
      opAxesIota.resize(mesh.getRank());
      std::iota(opAxesIota.begin(), opAxesIota.end(), 0);
      opMeshAxes = opAxesIota;
    }
    llvm::transform(opMeshAxes, std::back_inserter(multiIndex),
                    [&completeMultiIndex](MeshAxis meshAxis) {
                      return completeMultiIndex[meshAxis];
                    });
    rewriter.replaceAllUsesWith(op.getResults(), multiIndex);
    return success();
  }
};

struct AllSliceOpLowering
    : OpRewritePatternWithSymbolTableCollection<AllSliceOp> {
  using OpRewritePatternWithSymbolTableCollection::
      OpRewritePatternWithSymbolTableCollection;

  LogicalResult matchAndRewrite(AllSliceOp op,
                                PatternRewriter &rewriter) const override {
    // 1. Compute the process linear index inside the process group from its
    // multi-index.
    //
    // 2. Extract a slice from the input tensor.
    // All axes except the slicing axis are not interesting and take the full
    // axis.
    // The slice axis is split into equisized parts with count
    // the number of processes in the collective process group induced by
    // the mesh axes.
    // The part for each process is determined by the corresponding
    // linear-index in the process group.
    //
    // There are no collectives that require communication.
    // Each process operates on its local tensor.

    MeshOp mesh = getMesh(op, symbolTableCollection);
    if (!mesh) {
      return failure();
    }

    ImplicitLocOpBuilder builder(op->getLoc(), rewriter);
    builder.setInsertionPointAfter(op.getOperation());

    Value zero = arith::ConstantOp::create(builder, builder.getIndexAttr(0));

    Operation::result_range processInGroupMultiIndex =
        ProcessMultiIndexOp::create(builder, mesh.getSymName(),
                                    op.getMeshAxes())
            .getResults();

    Operation::result_range processGroupShape =
        MeshShapeOp::create(builder, mesh.getSymName(), op.getMeshAxes())
            .getResult();
    Value processGroupSize =
        createCollectiveProcessGroupSize(mesh, op.getMeshAxes(), builder);

    int64_t sliceAxis = op.getSliceAxis().getSExtValue();
    Value operandSliceAxisSize =
        tensor::DimOp::create(builder, op.getOperand(), sliceAxis);
    Value operandSliceAxisSizeModProcessGroupSize =
        arith::RemUIOp::create(builder, operandSliceAxisSize, processGroupSize);
    Value isTargetShapeExactlyDivisible =
        arith::CmpIOp::create(builder, arith::CmpIPredicate::eq,
                              operandSliceAxisSizeModProcessGroupSize, zero);
    cf::AssertOp::create(builder, isTargetShapeExactlyDivisible,
                         "Slicing a tensor with axis size that is "
                         "not exactly divisible by the "
                         "mesh process group size is not supported.");
    Value resultSliceAxisSize =
        arith::DivUIOp::create(builder, operandSliceAxisSize, processGroupSize);
    OpFoldResult processInGroupLinearIndex = affine::linearizeIndex(
        llvm::to_vector_of<OpFoldResult>(processInGroupMultiIndex),
        llvm::to_vector_of<OpFoldResult>(processGroupShape), builder);

    // insert tensor.extract_slice
    RankedTensorType operandType =
        cast<RankedTensorType>(op.getOperand().getType());
    SmallVector<OpFoldResult> sizes;
    for (int64_t i = 0; i < operandType.getRank(); ++i) {
      if (i == sliceAxis) {
        sizes.emplace_back(resultSliceAxisSize);
      } else {
        Value dimSize = tensor::DimOp::create(builder, op.getOperand(), i);
        sizes.emplace_back(dimSize);
      }
    }
    SmallVector<OpFoldResult> offsets(
        operandType.getRank(), getAsIndexOpFoldResult(builder.getContext(), 0));
    offsets[sliceAxis] =
        ArithBuilder(builder, builder.getLoc())
            .mul(getValueOrCreateConstantIndexOp(builder, builder.getLoc(),
                                                 processInGroupLinearIndex),
                 resultSliceAxisSize);
    SmallVector<OpFoldResult> strides(
        operandType.getRank(), getAsIndexOpFoldResult(builder.getContext(), 1));
    Value slice = tensor::ExtractSliceOp::create(builder, op.getOperand(),
                                                 offsets, sizes, strides);
    Value newResult =
        tensor::CastOp::create(builder, op.getResult().getType(), slice);
    rewriter.replaceAllUsesWith(op.getResult(), newResult);

    return success();
  }
};

} // namespace

void populateProcessMultiIndexOpLoweringPatterns(
    RewritePatternSet &patterns, SymbolTableCollection &symbolTableCollection) {
  patterns.add<ProcessMultiIndexOpLowering>(symbolTableCollection,
                                            patterns.getContext());
}

void registerProcessMultiIndexOpLoweringDialects(DialectRegistry &registry) {
  registry.insert<affine::AffineDialect, mesh::MeshDialect>();
}

void populateAllSliceOpLoweringPatterns(
    RewritePatternSet &patterns, SymbolTableCollection &symbolTableCollection) {
  patterns.add<AllSliceOpLowering>(symbolTableCollection,
                                   patterns.getContext());
}

void registerAllSliceOpLoweringDialects(DialectRegistry &registry) {
  registry.insert<affine::AffineDialect, arith::ArithDialect,
                  cf::ControlFlowDialect, mesh::MeshDialect,
                  tensor::TensorDialect>();
}

void populateAllOpLoweringPatterns(
    RewritePatternSet &patterns, SymbolTableCollection &symbolTableCollection) {
  populateProcessMultiIndexOpLoweringPatterns(patterns, symbolTableCollection);
  populateAllSliceOpLoweringPatterns(patterns, symbolTableCollection);
}

void registerAllOpLoweringDialects(DialectRegistry &registry) {
  registerProcessMultiIndexOpLoweringDialects(registry);
  registerAllSliceOpLoweringDialects(registry);
}

TypedValue<IndexType>
createCollectiveProcessGroupSize(MeshOp mesh, ArrayRef<MeshAxis> axes,
                                 ImplicitLocOpBuilder &builder) {
  Operation::result_range meshShape =
      mesh::MeshShapeOp::create(builder, mesh, axes).getResults();
  return cast<TypedValue<IndexType>>(arith::createProduct(
      builder, builder.getLoc(), llvm::to_vector_of<Value>(meshShape),
      builder.getIndexType()));
}

TypedValue<IndexType>
createProcessLinearIndex(StringRef mesh, ValueRange processInGroupMultiIndex,
                         ArrayRef<MeshAxis> meshAxes,
                         ImplicitLocOpBuilder &builder) {
  Operation::result_range processGroupShape =
      MeshShapeOp::create(builder, mesh, meshAxes).getResult();
  OpFoldResult processInGroupLinearIndex = affine::linearizeIndex(
      llvm::to_vector_of<OpFoldResult>(processInGroupMultiIndex),
      llvm::to_vector_of<OpFoldResult>(processGroupShape), builder);
  auto res = dyn_cast<Value>(processInGroupLinearIndex);
  if (!res)
    res = arith::ConstantIndexOp::create(
        builder,
        cast<IntegerAttr>(cast<Attribute>(processInGroupLinearIndex)).getInt());
  return cast<TypedValue<IndexType>>(res);
}

TypedValue<IndexType> createProcessLinearIndex(StringRef mesh,
                                               ArrayRef<MeshAxis> meshAxes,
                                               ImplicitLocOpBuilder &builder) {
  return createProcessLinearIndex(
      mesh, ProcessMultiIndexOp::create(builder, mesh, meshAxes).getResults(),
      meshAxes, builder);
}
} // namespace mlir::mesh
