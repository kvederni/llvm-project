; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn -mcpu=gfx1200 < %s | FileCheck %s --check-prefix=GFX12

define amdgpu_ps void @test_wmma_f32_16x16x16_f16_imm(<8 x half> %A, <8 x half> %B, ptr addrspace(1) %out) {
; GFX12-LABEL: test_wmma_f32_16x16x16_f16_imm:
; GFX12:       ; %bb.0: ; %bb
; GFX12-NEXT:    v_wmma_f32_16x16x16_f16 v[10:17], v[0:3], v[4:7], 1.0
; GFX12-NEXT:    s_clause 0x1
; GFX12-NEXT:    global_store_b128 v[8:9], v[10:13], off
; GFX12-NEXT:    global_store_b128 v[8:9], v[14:17], off offset:16
; GFX12-NEXT:    s_endpgm
bb:
  %res = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.f16.v8f32.v8f16.v8f16.v8f32(<8 x half> %A, <8 x half> %B, <8 x float> <float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0>)
  store <8 x float> %res, ptr addrspace(1) %out
  ret void
}

define amdgpu_ps void @test_wmma_f32_16x16x16_f16_imm_non_inlineable(<8 x half> %A, <8 x half> %B, ptr addrspace(1) %out) {
; GFX12-LABEL: test_wmma_f32_16x16x16_f16_imm_non_inlineable:
; GFX12:       ; %bb.0: ; %bb
; GFX12-NEXT:    s_mov_b32 s0, 0x40400000
; GFX12-NEXT:    s_delay_alu instid0(SALU_CYCLE_1)
; GFX12-NEXT:    s_mov_b32 s7, s0
; GFX12-NEXT:    s_mov_b32 s1, s0
; GFX12-NEXT:    s_mov_b32 s2, s0
; GFX12-NEXT:    s_mov_b32 s3, s0
; GFX12-NEXT:    s_mov_b32 s4, s0
; GFX12-NEXT:    s_mov_b32 s5, s0
; GFX12-NEXT:    s_mov_b32 s6, s0
; GFX12-NEXT:    s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(VALU_DEP_1)
; GFX12-NEXT:    v_dual_mov_b32 v17, s7 :: v_dual_mov_b32 v16, s6
; GFX12-NEXT:    v_dual_mov_b32 v15, s5 :: v_dual_mov_b32 v14, s4
; GFX12-NEXT:    v_dual_mov_b32 v13, s3 :: v_dual_mov_b32 v12, s2
; GFX12-NEXT:    v_dual_mov_b32 v11, s1 :: v_dual_mov_b32 v10, s0
; GFX12-NEXT:    v_wmma_f32_16x16x16_f16 v[10:17], v[0:3], v[4:7], v[10:17]
; GFX12-NEXT:    s_clause 0x1
; GFX12-NEXT:    global_store_b128 v[8:9], v[10:13], off
; GFX12-NEXT:    global_store_b128 v[8:9], v[14:17], off offset:16
; GFX12-NEXT:    s_endpgm
bb:
  %res = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.f16.v8f32.v8f16.v8f16.v8f32(<8 x half> %A, <8 x half> %B, <8 x float> <float 3.0, float 3.0, float 3.0, float 3.0, float 3.0, float 3.0, float 3.0, float 3.0>)
  store <8 x float> %res, ptr addrspace(1) %out
  ret void
}

define amdgpu_ps void @test_wmma_f32_16x16x16_bf16_imm(<8 x i16> %A, <8 x i16> %B, ptr addrspace(1) %out) {
; GFX12-LABEL: test_wmma_f32_16x16x16_bf16_imm:
; GFX12:       ; %bb.0: ; %bb
; GFX12-NEXT:    v_wmma_f32_16x16x16_bf16 v[10:17], v[0:3], v[4:7], 1.0
; GFX12-NEXT:    s_clause 0x1
; GFX12-NEXT:    global_store_b128 v[8:9], v[10:13], off
; GFX12-NEXT:    global_store_b128 v[8:9], v[14:17], off offset:16
; GFX12-NEXT:    s_endpgm
bb:
  %res = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v8i16.v8i16.v8f32(<8 x i16> %A, <8 x i16> %B, <8 x float> <float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0>)
  store <8 x float> %res, ptr addrspace(1) %out
  ret void
}

define amdgpu_ps void @test_wmma_f32_16x16x16_bf16_imm_non_inlineable(<8 x i16> %A, <8 x i16> %B, ptr addrspace(1) %out) {
; GFX12-LABEL: test_wmma_f32_16x16x16_bf16_imm_non_inlineable:
; GFX12:       ; %bb.0: ; %bb
; GFX12-NEXT:    s_mov_b32 s0, 0x40400000
; GFX12-NEXT:    s_delay_alu instid0(SALU_CYCLE_1)
; GFX12-NEXT:    s_mov_b32 s7, s0
; GFX12-NEXT:    s_mov_b32 s1, s0
; GFX12-NEXT:    s_mov_b32 s2, s0
; GFX12-NEXT:    s_mov_b32 s3, s0
; GFX12-NEXT:    s_mov_b32 s4, s0
; GFX12-NEXT:    s_mov_b32 s5, s0
; GFX12-NEXT:    s_mov_b32 s6, s0
; GFX12-NEXT:    s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(VALU_DEP_1)
; GFX12-NEXT:    v_dual_mov_b32 v17, s7 :: v_dual_mov_b32 v16, s6
; GFX12-NEXT:    v_dual_mov_b32 v15, s5 :: v_dual_mov_b32 v14, s4
; GFX12-NEXT:    v_dual_mov_b32 v13, s3 :: v_dual_mov_b32 v12, s2
; GFX12-NEXT:    v_dual_mov_b32 v11, s1 :: v_dual_mov_b32 v10, s0
; GFX12-NEXT:    v_wmma_f32_16x16x16_bf16 v[10:17], v[0:3], v[4:7], v[10:17]
; GFX12-NEXT:    s_clause 0x1
; GFX12-NEXT:    global_store_b128 v[8:9], v[10:13], off
; GFX12-NEXT:    global_store_b128 v[8:9], v[14:17], off offset:16
; GFX12-NEXT:    s_endpgm
bb:
  %res = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v8i16.v8i16.v8f32(<8 x i16> %A, <8 x i16> %B, <8 x float> <float 3.0, float 3.0, float 3.0, float 3.0, float 3.0, float 3.0, float 3.0, float 3.0>)
  store <8 x float> %res, ptr addrspace(1) %out
  ret void
}

define amdgpu_ps void @test_wmma_f16_16x16x16_f16_imm(<8 x half> %A, <8 x half> %B, ptr addrspace(1) %out) {
; GFX12-LABEL: test_wmma_f16_16x16x16_f16_imm:
; GFX12:       ; %bb.0: ; %bb
; GFX12-NEXT:    v_wmma_f16_16x16x16_f16 v[10:13], v[0:3], v[4:7], 1.0
; GFX12-NEXT:    global_store_b128 v[8:9], v[10:13], off
; GFX12-NEXT:    s_endpgm
bb:
  %res = call <8 x half> @llvm.amdgcn.wmma.f16.16x16x16.f16.v8f16.v8f16.v8f16.v8f16(<8 x half> %A, <8 x half> %B, <8 x half> <half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0>, i1 0)
  store <8 x half> %res, ptr addrspace(1) %out
  ret void
}

define amdgpu_ps void @test_wmma_f16_16x16x16_f16_imm_non_inlineable(<8 x half> %A, <8 x half> %B, ptr addrspace(1) %out) {
; GFX12-LABEL: test_wmma_f16_16x16x16_f16_imm_non_inlineable:
; GFX12:       ; %bb.0: ; %bb
; GFX12-NEXT:    s_mov_b32 s0, 0x42004200
; GFX12-NEXT:    s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
; GFX12-NEXT:    s_mov_b32 s3, s0
; GFX12-NEXT:    s_mov_b32 s1, s0
; GFX12-NEXT:    s_mov_b32 s2, s0
; GFX12-NEXT:    v_dual_mov_b32 v13, s3 :: v_dual_mov_b32 v12, s2
; GFX12-NEXT:    v_dual_mov_b32 v11, s1 :: v_dual_mov_b32 v10, s0
; GFX12-NEXT:    s_delay_alu instid0(VALU_DEP_1)
; GFX12-NEXT:    v_wmma_f16_16x16x16_f16 v[10:13], v[0:3], v[4:7], v[10:13]
; GFX12-NEXT:    global_store_b128 v[8:9], v[10:13], off
; GFX12-NEXT:    s_endpgm
bb:
  %res = call <8 x half> @llvm.amdgcn.wmma.f16.16x16x16.f16.v8f16.v8f16.v8f16.v8f16(<8 x half> %A, <8 x half> %B, <8 x half> <half 3.0, half 3.0, half 3.0, half 3.0, half 3.0, half 3.0, half 3.0, half 3.0>, i1 0)
  store <8 x half> %res, ptr addrspace(1) %out
  ret void
}

define amdgpu_ps void @test_wmma_bf16_16x16x16_bf16_imm(<8 x i16> %A, <8 x i16> %B, ptr addrspace(1) %out) {
; GFX12-LABEL: test_wmma_bf16_16x16x16_bf16_imm:
; GFX12:       ; %bb.0: ; %bb
; GFX12-NEXT:    s_mov_b32 s0, 0x3f803f80
; GFX12-NEXT:    s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
; GFX12-NEXT:    s_mov_b32 s3, s0
; GFX12-NEXT:    s_mov_b32 s1, s0
; GFX12-NEXT:    s_mov_b32 s2, s0
; GFX12-NEXT:    v_dual_mov_b32 v13, s3 :: v_dual_mov_b32 v12, s2
; GFX12-NEXT:    v_dual_mov_b32 v11, s1 :: v_dual_mov_b32 v10, s0
; GFX12-NEXT:    s_delay_alu instid0(VALU_DEP_1)
; GFX12-NEXT:    v_wmma_bf16_16x16x16_bf16 v[10:13], v[0:3], v[4:7], v[10:13]
; GFX12-NEXT:    global_store_b128 v[8:9], v[10:13], off
; GFX12-NEXT:    s_endpgm
bb:
  %res = call <8 x i16> @llvm.amdgcn.wmma.bf16.16x16x16.bf16.v8i16.v8i16.v8i16.v8i16(<8 x i16> %A, <8 x i16> %B, <8 x i16> <i16 16256, i16 16256, i16 16256, i16 16256, i16 16256, i16 16256, i16 16256, i16 16256>, i1 0)
  store <8 x i16> %res, ptr addrspace(1) %out
  ret void
}

define amdgpu_ps void @test_wmma_bf16_16x16x16_bf16_imm_non_inlineable(<8 x i16> %A, <8 x i16> %B, ptr addrspace(1) %out) {
; GFX12-LABEL: test_wmma_bf16_16x16x16_bf16_imm_non_inlineable:
; GFX12:       ; %bb.0: ; %bb
; GFX12-NEXT:    s_mov_b32 s0, 0x3fc03fc0
; GFX12-NEXT:    s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
; GFX12-NEXT:    s_mov_b32 s3, s0
; GFX12-NEXT:    s_mov_b32 s1, s0
; GFX12-NEXT:    s_mov_b32 s2, s0
; GFX12-NEXT:    v_dual_mov_b32 v13, s3 :: v_dual_mov_b32 v12, s2
; GFX12-NEXT:    v_dual_mov_b32 v11, s1 :: v_dual_mov_b32 v10, s0
; GFX12-NEXT:    s_delay_alu instid0(VALU_DEP_1)
; GFX12-NEXT:    v_wmma_bf16_16x16x16_bf16 v[10:13], v[0:3], v[4:7], v[10:13]
; GFX12-NEXT:    global_store_b128 v[8:9], v[10:13], off
; GFX12-NEXT:    s_endpgm
bb:
  %res = call <8 x i16> @llvm.amdgcn.wmma.bf16.16x16x16.bf16.v8i16.v8i16.v8i16.v8i16(<8 x i16> %A, <8 x i16> %B, <8 x i16> <i16 16320, i16 16320, i16 16320, i16 16320, i16 16320, i16 16320, i16 16320, i16 16320>, i1 0)
  store <8 x i16> %res, ptr addrspace(1) %out
  ret void
}

define amdgpu_ps void @test_wmma_i32_16x16x16_iu8_imm(<2 x i32> %A, <2 x i32> %B, ptr addrspace(1) %out) {
; GFX12-LABEL: test_wmma_i32_16x16x16_iu8_imm:
; GFX12:       ; %bb.0: ; %bb
; GFX12-NEXT:    v_wmma_i32_16x16x16_iu8 v[6:13], v[0:1], v[2:3], 1
; GFX12-NEXT:    s_clause 0x1
; GFX12-NEXT:    global_store_b128 v[4:5], v[6:9], off
; GFX12-NEXT:    global_store_b128 v[4:5], v[10:13], off offset:16
; GFX12-NEXT:    s_endpgm
bb:
  %res = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu8.v8i32.v2i32.v2i32.v8i32(i1 0, <2 x i32> %A, i1 0, <2 x i32> %B, <8 x i32> <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>, i1 0)
  store <8 x i32> %res, ptr addrspace(1) %out
  ret void
}

define amdgpu_ps void @test_wmma_i32_16x16x16_iu8_imm_non_inlineable(<2 x i32> %A, <2 x i32> %B, ptr addrspace(1) %out) {
; GFX12-LABEL: test_wmma_i32_16x16x16_iu8_imm_non_inlineable:
; GFX12:       ; %bb.0: ; %bb
; GFX12-NEXT:    s_movk_i32 s0, 0x80
; GFX12-NEXT:    s_delay_alu instid0(SALU_CYCLE_1)
; GFX12-NEXT:    s_mov_b32 s7, s0
; GFX12-NEXT:    s_mov_b32 s1, s0
; GFX12-NEXT:    s_mov_b32 s2, s0
; GFX12-NEXT:    s_mov_b32 s3, s0
; GFX12-NEXT:    s_mov_b32 s4, s0
; GFX12-NEXT:    s_mov_b32 s5, s0
; GFX12-NEXT:    s_mov_b32 s6, s0
; GFX12-NEXT:    s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(VALU_DEP_1)
; GFX12-NEXT:    v_dual_mov_b32 v13, s7 :: v_dual_mov_b32 v12, s6
; GFX12-NEXT:    v_dual_mov_b32 v11, s5 :: v_dual_mov_b32 v10, s4
; GFX12-NEXT:    v_dual_mov_b32 v9, s3 :: v_dual_mov_b32 v8, s2
; GFX12-NEXT:    v_dual_mov_b32 v7, s1 :: v_dual_mov_b32 v6, s0
; GFX12-NEXT:    v_wmma_i32_16x16x16_iu8 v[6:13], v[0:1], v[2:3], v[6:13]
; GFX12-NEXT:    s_clause 0x1
; GFX12-NEXT:    global_store_b128 v[4:5], v[6:9], off
; GFX12-NEXT:    global_store_b128 v[4:5], v[10:13], off offset:16
; GFX12-NEXT:    s_endpgm
bb:
  %res = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu8.v8i32.v2i32.v2i32.v8i32(i1 0, <2 x i32> %A, i1 0, <2 x i32> %B, <8 x i32> <i32 128, i32 128, i32 128, i32 128, i32 128, i32 128, i32 128, i32 128>, i1 0)
  store <8 x i32> %res, ptr addrspace(1) %out
  ret void
}

define amdgpu_ps void @test_wmma_i32_16x16x16_iu4_imm(i32 %A, i32 %B, ptr addrspace(1) %out) {
; GFX12-LABEL: test_wmma_i32_16x16x16_iu4_imm:
; GFX12:       ; %bb.0: ; %bb
; GFX12-NEXT:    v_wmma_i32_16x16x16_iu4 v[4:11], v0, v1, 1
; GFX12-NEXT:    s_clause 0x1
; GFX12-NEXT:    global_store_b128 v[2:3], v[4:7], off
; GFX12-NEXT:    global_store_b128 v[2:3], v[8:11], off offset:16
; GFX12-NEXT:    s_endpgm
bb:
  %res = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu4.v8i32.i32.i32.v8i32(i1 0, i32 %A, i1 0, i32 %B, <8 x i32> <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>, i1 0)
  store <8 x i32> %res, ptr addrspace(1) %out
  ret void
}

define amdgpu_ps void @test_wmma_i32_16x16x16_iu4_imm_non_inlineable(i32 %A, i32 %B, ptr addrspace(1) %out) {
; GFX12-LABEL: test_wmma_i32_16x16x16_iu4_imm_non_inlineable:
; GFX12:       ; %bb.0: ; %bb
; GFX12-NEXT:    s_movk_i32 s0, 0x80
; GFX12-NEXT:    s_delay_alu instid0(SALU_CYCLE_1)
; GFX12-NEXT:    s_mov_b32 s7, s0
; GFX12-NEXT:    s_mov_b32 s1, s0
; GFX12-NEXT:    s_mov_b32 s2, s0
; GFX12-NEXT:    s_mov_b32 s3, s0
; GFX12-NEXT:    s_mov_b32 s4, s0
; GFX12-NEXT:    s_mov_b32 s5, s0
; GFX12-NEXT:    s_mov_b32 s6, s0
; GFX12-NEXT:    s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(VALU_DEP_1)
; GFX12-NEXT:    v_dual_mov_b32 v11, s7 :: v_dual_mov_b32 v10, s6
; GFX12-NEXT:    v_dual_mov_b32 v9, s5 :: v_dual_mov_b32 v8, s4
; GFX12-NEXT:    v_dual_mov_b32 v7, s3 :: v_dual_mov_b32 v6, s2
; GFX12-NEXT:    v_dual_mov_b32 v5, s1 :: v_dual_mov_b32 v4, s0
; GFX12-NEXT:    v_wmma_i32_16x16x16_iu4 v[4:11], v0, v1, v[4:11]
; GFX12-NEXT:    s_clause 0x1
; GFX12-NEXT:    global_store_b128 v[2:3], v[4:7], off
; GFX12-NEXT:    global_store_b128 v[2:3], v[8:11], off offset:16
; GFX12-NEXT:    s_endpgm
bb:
  %res = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu4.v8i32.i32.i32.v8i32(i1 0, i32 %A, i1 0, i32 %B, <8 x i32> <i32 128, i32 128, i32 128, i32 128, i32 128, i32 128, i32 128, i32 128>, i1 0)
  store <8 x i32> %res, ptr addrspace(1) %out
  ret void
}

define amdgpu_ps void @test_wmma_f32_16x16x16_fp8_fp8_imm(<2 x i32> %A, <2 x i32> %B, ptr addrspace(1) %out) {
; GFX12-LABEL: test_wmma_f32_16x16x16_fp8_fp8_imm:
; GFX12:       ; %bb.0: ; %bb
; GFX12-NEXT:    v_wmma_f32_16x16x16_fp8_fp8 v[6:13], v[0:1], v[2:3], 1.0
; GFX12-NEXT:    s_clause 0x1
; GFX12-NEXT:    global_store_b128 v[4:5], v[6:9], off
; GFX12-NEXT:    global_store_b128 v[4:5], v[10:13], off offset:16
; GFX12-NEXT:    s_endpgm
bb:
  %res = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.fp8.fp8.v8f32.v2i32.v2i32.v8f32(<2 x i32> %A, <2 x i32> %B, <8 x float> <float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0>)
  store <8 x float> %res, ptr addrspace(1) %out
  ret void
}

define amdgpu_ps void @test_wmma_f32_16x16x16_fp8_fp8_imm_non_inlineable(<2 x i32> %A, <2 x i32> %B, ptr addrspace(1) %out) {
; GFX12-LABEL: test_wmma_f32_16x16x16_fp8_fp8_imm_non_inlineable:
; GFX12:       ; %bb.0: ; %bb
; GFX12-NEXT:    s_mov_b32 s0, 0x40400000
; GFX12-NEXT:    s_delay_alu instid0(SALU_CYCLE_1)
; GFX12-NEXT:    s_mov_b32 s7, s0
; GFX12-NEXT:    s_mov_b32 s1, s0
; GFX12-NEXT:    s_mov_b32 s2, s0
; GFX12-NEXT:    s_mov_b32 s3, s0
; GFX12-NEXT:    s_mov_b32 s4, s0
; GFX12-NEXT:    s_mov_b32 s5, s0
; GFX12-NEXT:    s_mov_b32 s6, s0
; GFX12-NEXT:    s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(VALU_DEP_1)
; GFX12-NEXT:    v_dual_mov_b32 v13, s7 :: v_dual_mov_b32 v12, s6
; GFX12-NEXT:    v_dual_mov_b32 v11, s5 :: v_dual_mov_b32 v10, s4
; GFX12-NEXT:    v_dual_mov_b32 v9, s3 :: v_dual_mov_b32 v8, s2
; GFX12-NEXT:    v_dual_mov_b32 v7, s1 :: v_dual_mov_b32 v6, s0
; GFX12-NEXT:    v_wmma_f32_16x16x16_fp8_fp8 v[6:13], v[0:1], v[2:3], v[6:13]
; GFX12-NEXT:    s_clause 0x1
; GFX12-NEXT:    global_store_b128 v[4:5], v[6:9], off
; GFX12-NEXT:    global_store_b128 v[4:5], v[10:13], off offset:16
; GFX12-NEXT:    s_endpgm
bb:
  %res = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.fp8.fp8.v8f32.v2i32.v2i32.v8f32(<2 x i32> %A, <2 x i32> %B, <8 x float> <float 3.0, float 3.0, float 3.0, float 3.0, float 3.0, float 3.0, float 3.0, float 3.0>)
  store <8 x float> %res, ptr addrspace(1) %out
  ret void
}

define amdgpu_ps void @test_wmma_f32_16x16x16_bf8_fp8_imm(<2 x i32> %A, <2 x i32> %B, ptr addrspace(1) %out) {
; GFX12-LABEL: test_wmma_f32_16x16x16_bf8_fp8_imm:
; GFX12:       ; %bb.0: ; %bb
; GFX12-NEXT:    v_wmma_f32_16x16x16_bf8_fp8 v[6:13], v[0:1], v[2:3], 1.0
; GFX12-NEXT:    s_clause 0x1
; GFX12-NEXT:    global_store_b128 v[4:5], v[6:9], off
; GFX12-NEXT:    global_store_b128 v[4:5], v[10:13], off offset:16
; GFX12-NEXT:    s_endpgm
bb:
  %res = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf8.fp8.v8f32.v2i32.v2i32.v8f32(<2 x i32> %A, <2 x i32> %B, <8 x float> <float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0>)
  store <8 x float> %res, ptr addrspace(1) %out
  ret void
}

define amdgpu_ps void @test_wmma_f32_16x16x16_bf8_fp8_imm_non_inlineable(<2 x i32> %A, <2 x i32> %B, ptr addrspace(1) %out) {
; GFX12-LABEL: test_wmma_f32_16x16x16_bf8_fp8_imm_non_inlineable:
; GFX12:       ; %bb.0: ; %bb
; GFX12-NEXT:    s_mov_b32 s0, 0x40400000
; GFX12-NEXT:    s_delay_alu instid0(SALU_CYCLE_1)
; GFX12-NEXT:    s_mov_b32 s7, s0
; GFX12-NEXT:    s_mov_b32 s1, s0
; GFX12-NEXT:    s_mov_b32 s2, s0
; GFX12-NEXT:    s_mov_b32 s3, s0
; GFX12-NEXT:    s_mov_b32 s4, s0
; GFX12-NEXT:    s_mov_b32 s5, s0
; GFX12-NEXT:    s_mov_b32 s6, s0
; GFX12-NEXT:    s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(VALU_DEP_1)
; GFX12-NEXT:    v_dual_mov_b32 v13, s7 :: v_dual_mov_b32 v12, s6
; GFX12-NEXT:    v_dual_mov_b32 v11, s5 :: v_dual_mov_b32 v10, s4
; GFX12-NEXT:    v_dual_mov_b32 v9, s3 :: v_dual_mov_b32 v8, s2
; GFX12-NEXT:    v_dual_mov_b32 v7, s1 :: v_dual_mov_b32 v6, s0
; GFX12-NEXT:    v_wmma_f32_16x16x16_bf8_fp8 v[6:13], v[0:1], v[2:3], v[6:13]
; GFX12-NEXT:    s_clause 0x1
; GFX12-NEXT:    global_store_b128 v[4:5], v[6:9], off
; GFX12-NEXT:    global_store_b128 v[4:5], v[10:13], off offset:16
; GFX12-NEXT:    s_endpgm
bb:
  %res = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf8.fp8.v8f32.v2i32.v2i32.v8f32(<2 x i32> %A, <2 x i32> %B, <8 x float> <float 3.0, float 3.0, float 3.0, float 3.0, float 3.0, float 3.0, float 3.0, float 3.0>)
  store <8 x float> %res, ptr addrspace(1) %out
  ret void
}

define amdgpu_ps void @test_wmma_f32_16x16x16_fp8_bf8_imm(<2 x i32> %A, <2 x i32> %B, ptr addrspace(1) %out) {
; GFX12-LABEL: test_wmma_f32_16x16x16_fp8_bf8_imm:
; GFX12:       ; %bb.0: ; %bb
; GFX12-NEXT:    v_wmma_f32_16x16x16_fp8_bf8 v[6:13], v[0:1], v[2:3], 1.0
; GFX12-NEXT:    s_clause 0x1
; GFX12-NEXT:    global_store_b128 v[4:5], v[6:9], off
; GFX12-NEXT:    global_store_b128 v[4:5], v[10:13], off offset:16
; GFX12-NEXT:    s_endpgm
bb:
  %res = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.fp8.bf8.v8f32.v2i32.v2i32.v8f32(<2 x i32> %A, <2 x i32> %B, <8 x float> <float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0>)
  store <8 x float> %res, ptr addrspace(1) %out
  ret void
}

define amdgpu_ps void @test_wmma_f32_16x16x16_fp8_bf8_imm_non_inlineable(<2 x i32> %A, <2 x i32> %B, ptr addrspace(1) %out) {
; GFX12-LABEL: test_wmma_f32_16x16x16_fp8_bf8_imm_non_inlineable:
; GFX12:       ; %bb.0: ; %bb
; GFX12-NEXT:    s_mov_b32 s0, 0x40400000
; GFX12-NEXT:    s_delay_alu instid0(SALU_CYCLE_1)
; GFX12-NEXT:    s_mov_b32 s7, s0
; GFX12-NEXT:    s_mov_b32 s1, s0
; GFX12-NEXT:    s_mov_b32 s2, s0
; GFX12-NEXT:    s_mov_b32 s3, s0
; GFX12-NEXT:    s_mov_b32 s4, s0
; GFX12-NEXT:    s_mov_b32 s5, s0
; GFX12-NEXT:    s_mov_b32 s6, s0
; GFX12-NEXT:    s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(VALU_DEP_1)
; GFX12-NEXT:    v_dual_mov_b32 v13, s7 :: v_dual_mov_b32 v12, s6
; GFX12-NEXT:    v_dual_mov_b32 v11, s5 :: v_dual_mov_b32 v10, s4
; GFX12-NEXT:    v_dual_mov_b32 v9, s3 :: v_dual_mov_b32 v8, s2
; GFX12-NEXT:    v_dual_mov_b32 v7, s1 :: v_dual_mov_b32 v6, s0
; GFX12-NEXT:    v_wmma_f32_16x16x16_fp8_bf8 v[6:13], v[0:1], v[2:3], v[6:13]
; GFX12-NEXT:    s_clause 0x1
; GFX12-NEXT:    global_store_b128 v[4:5], v[6:9], off
; GFX12-NEXT:    global_store_b128 v[4:5], v[10:13], off offset:16
; GFX12-NEXT:    s_endpgm
bb:
  %res = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.fp8.bf8.v8f32.v2i32.v2i32.v8f32(<2 x i32> %A, <2 x i32> %B, <8 x float> <float 3.0, float 3.0, float 3.0, float 3.0, float 3.0, float 3.0, float 3.0, float 3.0>)
  store <8 x float> %res, ptr addrspace(1) %out
  ret void
}

define amdgpu_ps void @test_wmma_f32_16x16x16_bf8_bf8_imm(<2 x i32> %A, <2 x i32> %B, ptr addrspace(1) %out) {
; GFX12-LABEL: test_wmma_f32_16x16x16_bf8_bf8_imm:
; GFX12:       ; %bb.0: ; %bb
; GFX12-NEXT:    v_wmma_f32_16x16x16_bf8_bf8 v[6:13], v[0:1], v[2:3], 1.0
; GFX12-NEXT:    s_clause 0x1
; GFX12-NEXT:    global_store_b128 v[4:5], v[6:9], off
; GFX12-NEXT:    global_store_b128 v[4:5], v[10:13], off offset:16
; GFX12-NEXT:    s_endpgm
bb:
  %res = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf8.bf8.v8f32.v2i32.v2i32.v8f32(<2 x i32> %A, <2 x i32> %B, <8 x float> <float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0>)
  store <8 x float> %res, ptr addrspace(1) %out
  ret void
}

define amdgpu_ps void @test_wmma_f32_16x16x16_bf8_bf8_imm_non_inlineable(<2 x i32> %A, <2 x i32> %B, ptr addrspace(1) %out) {
; GFX12-LABEL: test_wmma_f32_16x16x16_bf8_bf8_imm_non_inlineable:
; GFX12:       ; %bb.0: ; %bb
; GFX12-NEXT:    s_mov_b32 s0, 0x40400000
; GFX12-NEXT:    s_delay_alu instid0(SALU_CYCLE_1)
; GFX12-NEXT:    s_mov_b32 s7, s0
; GFX12-NEXT:    s_mov_b32 s1, s0
; GFX12-NEXT:    s_mov_b32 s2, s0
; GFX12-NEXT:    s_mov_b32 s3, s0
; GFX12-NEXT:    s_mov_b32 s4, s0
; GFX12-NEXT:    s_mov_b32 s5, s0
; GFX12-NEXT:    s_mov_b32 s6, s0
; GFX12-NEXT:    s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(VALU_DEP_1)
; GFX12-NEXT:    v_dual_mov_b32 v13, s7 :: v_dual_mov_b32 v12, s6
; GFX12-NEXT:    v_dual_mov_b32 v11, s5 :: v_dual_mov_b32 v10, s4
; GFX12-NEXT:    v_dual_mov_b32 v9, s3 :: v_dual_mov_b32 v8, s2
; GFX12-NEXT:    v_dual_mov_b32 v7, s1 :: v_dual_mov_b32 v6, s0
; GFX12-NEXT:    v_wmma_f32_16x16x16_bf8_bf8 v[6:13], v[0:1], v[2:3], v[6:13]
; GFX12-NEXT:    s_clause 0x1
; GFX12-NEXT:    global_store_b128 v[4:5], v[6:9], off
; GFX12-NEXT:    global_store_b128 v[4:5], v[10:13], off offset:16
; GFX12-NEXT:    s_endpgm
bb:
  %res = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf8.bf8.v8f32.v2i32.v2i32.v8f32(<2 x i32> %A, <2 x i32> %B, <8 x float> <float 3.0, float 3.0, float 3.0, float 3.0, float 3.0, float 3.0, float 3.0, float 3.0>)
  store <8 x float> %res, ptr addrspace(1) %out
  ret void
}

define amdgpu_ps void @test_wmma_i32_16x16x32_iu4_imm(<2 x i32> %A, <2 x i32> %B, ptr addrspace(1) %out) {
; GFX12-LABEL: test_wmma_i32_16x16x32_iu4_imm:
; GFX12:       ; %bb.0: ; %bb
; GFX12-NEXT:    v_wmma_i32_16x16x32_iu4 v[6:13], v[0:1], v[2:3], 1
; GFX12-NEXT:    s_clause 0x1
; GFX12-NEXT:    global_store_b128 v[4:5], v[6:9], off
; GFX12-NEXT:    global_store_b128 v[4:5], v[10:13], off offset:16
; GFX12-NEXT:    s_endpgm
bb:
  %res = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x32.iu4.v8i32.v2i32.v2i32.v8i32(i1 0, <2 x i32> %A, i1 0, <2 x i32> %B, <8 x i32> <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>, i1 0)
  store <8 x i32> %res, ptr addrspace(1) %out
  ret void
}

define amdgpu_ps void @test_wmma_i32_16x16x32_iu4_imm_non_inlineable(<2 x i32> %A, <2 x i32> %B, ptr addrspace(1) %out) {
; GFX12-LABEL: test_wmma_i32_16x16x32_iu4_imm_non_inlineable:
; GFX12:       ; %bb.0: ; %bb
; GFX12-NEXT:    s_movk_i32 s0, 0x80
; GFX12-NEXT:    s_delay_alu instid0(SALU_CYCLE_1)
; GFX12-NEXT:    s_mov_b32 s7, s0
; GFX12-NEXT:    s_mov_b32 s1, s0
; GFX12-NEXT:    s_mov_b32 s2, s0
; GFX12-NEXT:    s_mov_b32 s3, s0
; GFX12-NEXT:    s_mov_b32 s4, s0
; GFX12-NEXT:    s_mov_b32 s5, s0
; GFX12-NEXT:    s_mov_b32 s6, s0
; GFX12-NEXT:    s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(VALU_DEP_1)
; GFX12-NEXT:    v_dual_mov_b32 v13, s7 :: v_dual_mov_b32 v12, s6
; GFX12-NEXT:    v_dual_mov_b32 v11, s5 :: v_dual_mov_b32 v10, s4
; GFX12-NEXT:    v_dual_mov_b32 v9, s3 :: v_dual_mov_b32 v8, s2
; GFX12-NEXT:    v_dual_mov_b32 v7, s1 :: v_dual_mov_b32 v6, s0
; GFX12-NEXT:    v_wmma_i32_16x16x32_iu4 v[6:13], v[0:1], v[2:3], v[6:13]
; GFX12-NEXT:    s_clause 0x1
; GFX12-NEXT:    global_store_b128 v[4:5], v[6:9], off
; GFX12-NEXT:    global_store_b128 v[4:5], v[10:13], off offset:16
; GFX12-NEXT:    s_endpgm
bb:
  %res = call <8 x i32> @llvm.amdgcn.wmma.i32.16x16x32.iu4.v8i32.v2i32.v2i32.v8i32(i1 0, <2 x i32> %A, i1 0, <2 x i32> %B, <8 x i32> <i32 128, i32 128, i32 128, i32 128, i32 128, i32 128, i32 128, i32 128>, i1 0)
  store <8 x i32> %res, ptr addrspace(1) %out
  ret void
}

declare <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.f16.v8f32.v8f16.v8f16.v8f32(<8 x half>, <8 x half>, <8 x float>)
declare <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v8i16.v8i16.v8f32(<8 x i16>, <8 x i16>, <8 x float>)
declare <8 x half> @llvm.amdgcn.wmma.f16.16x16x16.f16.v8f16.v8f16.v8f16.v8f16(<8 x half>, <8 x half>, <8 x half>, i1 immarg)
declare <8 x i16> @llvm.amdgcn.wmma.bf16.16x16x16.bf16.v8i16.v8i16.v8i16.v8i16(<8 x i16>, <8 x i16>, <8 x i16>, i1 immarg)
declare <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu8.v8i32.v2i32.v2i32.v8i32(i1 immarg, <2 x i32>, i1 immarg, <2 x i32>, <8 x i32>, i1 immarg)
declare <8 x i32> @llvm.amdgcn.wmma.i32.16x16x16.iu4.v8i32.i32.i32.v8i32(i1 immarg, i32, i1 immarg, i32, <8 x i32>, i1 immarg)
declare <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.fp8.fp8.v8f32.v2i32.v2i32.v8f32(<2 x i32>, <2 x i32>, <8 x float>)
declare <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.fp8.bf8.v8f32.v2i32.v2i32.v8f32(<2 x i32>, <2 x i32>, <8 x float>)
declare <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf8.fp8.v8f32.v2i32.v2i32.v8f32(<2 x i32>, <2 x i32>, <8 x float>)
declare <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf8.bf8.v8f32.v2i32.v2i32.v8f32(<2 x i32>, <2 x i32>, <8 x float>)
declare <8 x i32> @llvm.amdgcn.wmma.i32.16x16x32.iu4.v8i32.v2i32.v2i32.v8i32(i1 immarg, <2 x i32>, i1 immarg, <2 x i32>, <8 x i32>, i1 immarg)
declare <8 x float> @llvm.amdgcn.swmmac.f32.16x16x32.f16.v8f32.v8f16.v16f16.v8f32.i16(<8 x half>, <16 x half>, <8 x float>, i16)
declare <8 x float> @llvm.amdgcn.swmmac.f32.16x16x32.bf16.v8f32.v8i16.v16i16.v8f32.i16(<8 x i16>, <16 x i16>, <8 x float>, i16)
declare <8 x half> @llvm.amdgcn.swmmac.f16.16x16x32.f16.v8f16.v8f16.v16f16.v8f16.i16(<8 x half>, <16 x half>, <8 x half>, i16)
declare <8 x i16> @llvm.amdgcn.swmmac.bf16.16x16x32.bf16.v8i16.v8i16.v16i16.v8i16.i16(<8 x i16>, <16 x i16>, <8 x i16>, i16)
declare <8 x i32> @llvm.amdgcn.swmmac.i32.16x16x32.iu8.v8i32.v2i32.v4i32.v8i32.i16(i1 immarg, <2 x i32>, i1 immarg, <4 x i32>, <8 x i32>, i16 %Index, i1 immarg)
declare <8 x i32> @llvm.amdgcn.swmmac.i32.16x16x32.iu4.v8i32.i32.v2i32.v8i32.i16(i1 immarg, i32, i1 immarg, <2 x i32>, <8 x i32>, i16 %Index, i1 immarg)
declare <8 x i32> @llvm.amdgcn.swmmac.i32.16x16x64.iu4.v8i32.v2i32.v4i32.v8i32.i32(i1 immarg, <2 x i32>, i1 immarg, <4 x i32>, <8 x i32>, i32 %Index, i1 immarg)
declare <8 x float> @llvm.amdgcn.swmmac.f32.16x16x32.fp8.fp8.v8f32.v2i32.v4i32.v8f32.i16(<2 x i32>, <4 x i32>, <8 x float>, i16)
declare <8 x float> @llvm.amdgcn.swmmac.f32.16x16x32.fp8.bf8.v8f32.v2i32.v4i32.v8f32.i16(<2 x i32>, <4 x i32>, <8 x float>, i16)
declare <8 x float> @llvm.amdgcn.swmmac.f32.16x16x32.bf8.fp8.v8f32.v2i32.v4i32.v8f32.i16(<2 x i32>, <4 x i32>, <8 x float>, i16)
declare <8 x float> @llvm.amdgcn.swmmac.f32.16x16x32.bf8.bf8.v8f32.v2i32.v4i32.v8f32.i16(<2 x i32>, <4 x i32>, <8 x float>, i16)
