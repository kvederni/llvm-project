; RUN: llc -mtriple=amdgcn -mcpu=tonga -denormal-fp-math-f32=preserve-sign < %s | FileCheck -enable-var-scope -check-prefixes=GCN,GFX8 %s
; RUN: llc -mtriple=amdgcn -mcpu=tonga -denormal-fp-math-f32=ieee < %s | FileCheck -enable-var-scope -check-prefixes=GCN,GFX8 %s
; RUN: llc -mtriple=amdgcn -mcpu=gfx900 -denormal-fp-math-f32=ieee < %s | FileCheck -enable-var-scope -check-prefixes=GCN,GFX9 %s

declare half @llvm.amdgcn.fmad.ftz.f16(half %a, half %b, half %c)

; GCN-LABEL: {{^}}mad_f16:
; GCN: v_mac_f16_e32 v{{[0-9]+}}, v{{[0-9]+}}, v{{[0-9]+$}}
define amdgpu_kernel void @mad_f16(
    ptr addrspace(1) %r,
    ptr addrspace(1) %a,
    ptr addrspace(1) %b,
    ptr addrspace(1) %c) {
  %a.val = load half, ptr addrspace(1) %a
  %b.val = load half, ptr addrspace(1) %b
  %c.val = load half, ptr addrspace(1) %c
  %r.val = call half @llvm.amdgcn.fmad.ftz.f16(half %a.val, half %b.val, half %c.val)
  store half %r.val, ptr addrspace(1) %r
  ret void
}

; GCN-LABEL: {{^}}mad_f16_imm_a:
; GCN: v_madmk_f16 {{v[0-9]+}}, {{v[0-9]+}}, 0x4800, {{v[0-9]+}}
define amdgpu_kernel void @mad_f16_imm_a(
    ptr addrspace(1) %r,
    ptr addrspace(1) %b,
    ptr addrspace(1) %c) {
  %b.val = load half, ptr addrspace(1) %b
  %c.val = load half, ptr addrspace(1) %c
  %r.val = call half @llvm.amdgcn.fmad.ftz.f16(half 8.0, half %b.val, half %c.val)
  store half %r.val, ptr addrspace(1) %r
  ret void
}

; GCN-LABEL: {{^}}mad_f16_imm_b:
; GCN: v_madmk_f16 {{v[0-9]+}}, {{v[0-9]+}}, 0x4800, {{v[0-9]+$}}
define amdgpu_kernel void @mad_f16_imm_b(
    ptr addrspace(1) %r,
    ptr addrspace(1) %a,
    ptr addrspace(1) %c) {
  %a.val = load half, ptr addrspace(1) %a
  %c.val = load half, ptr addrspace(1) %c
  %r.val = call half @llvm.amdgcn.fmad.ftz.f16(half %a.val, half 8.0, half %c.val)
  store half %r.val, ptr addrspace(1) %r
  ret void
}

; GCN-LABEL: {{^}}mad_f16_imm_c:
; GCN: v_madak_f16 {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, 0x4800{{$}}
define amdgpu_kernel void @mad_f16_imm_c(
    ptr addrspace(1) %r,
    ptr addrspace(1) %a,
    ptr addrspace(1) %b) {
  %a.val = load half, ptr addrspace(1) %a
  %b.val = load half, ptr addrspace(1) %b
  %r.val = call half @llvm.amdgcn.fmad.ftz.f16(half %a.val, half %b.val, half 8.0)
  store half %r.val, ptr addrspace(1) %r
  ret void
}

; GCN-LABEL: {{^}}mad_f16_neg_b:
; GFX8: v_mad_f16 v{{[0-9]+}}, v{{[0-9]+}}, -v{{[0-9]+}}, v{{[0-9]+}}
; GFX9: v_mad_legacy_f16 v{{[0-9]+}}, v{{[0-9]+}}, -v{{[0-9]+}}, v{{[0-9]+}}
define amdgpu_kernel void @mad_f16_neg_b(
    ptr addrspace(1) %r,
    ptr addrspace(1) %a,
    ptr addrspace(1) %b,
    ptr addrspace(1) %c) {
  %a.val = load half, ptr addrspace(1) %a
  %b.val = load half, ptr addrspace(1) %b
  %c.val = load half, ptr addrspace(1) %c
  %neg.b = fsub half -0.0, %b.val
  %r.val = call half @llvm.amdgcn.fmad.ftz.f16(half %a.val, half %neg.b, half %c.val)
  store half %r.val, ptr addrspace(1) %r
  ret void
}

; GCN-LABEL: {{^}}mad_f16_abs_b:
; GFX8: v_mad_f16 v{{[0-9]+}}, v{{[0-9]+}}, |v{{[0-9]+}}|, v{{[0-9]+}}
; GFX9: v_mad_legacy_f16 v{{[0-9]+}}, v{{[0-9]+}}, |v{{[0-9]+}}|, v{{[0-9]+}}
define amdgpu_kernel void @mad_f16_abs_b(
    ptr addrspace(1) %r,
    ptr addrspace(1) %a,
    ptr addrspace(1) %b,
    ptr addrspace(1) %c) {
  %a.val = load half, ptr addrspace(1) %a
  %b.val = load half, ptr addrspace(1) %b
  %c.val = load half, ptr addrspace(1) %c
  %abs.b = call half @llvm.fabs.f16(half %b.val)
  %r.val = call half @llvm.amdgcn.fmad.ftz.f16(half %a.val, half %abs.b, half %c.val)
  store half %r.val, ptr addrspace(1) %r
  ret void
}

; GCN-LABEL: {{^}}mad_f16_neg_abs_b:
; GFX8: v_mad_f16 v{{[0-9]+}}, v{{[0-9]+}}, -|v{{[0-9]+}}|, v{{[0-9]+}}
; GFX9: v_mad_legacy_f16 v{{[0-9]+}}, v{{[0-9]+}}, -|v{{[0-9]+}}|, v{{[0-9]+}}
define amdgpu_kernel void @mad_f16_neg_abs_b(
    ptr addrspace(1) %r,
    ptr addrspace(1) %a,
    ptr addrspace(1) %b,
    ptr addrspace(1) %c) {
  %a.val = load half, ptr addrspace(1) %a
  %b.val = load half, ptr addrspace(1) %b
  %c.val = load half, ptr addrspace(1) %c
  %abs.b = call half @llvm.fabs.f16(half %b.val)
  %neg.abs.b = fsub half -0.0, %abs.b
  %r.val = call half @llvm.amdgcn.fmad.ftz.f16(half %a.val, half %neg.abs.b, half %c.val)
  store half %r.val, ptr addrspace(1) %r
  ret void
}

declare half @llvm.fabs.f16(half)
