; RUN: opt -disable-output -aa-pipeline=basic-aa -passes='loop-mssa(licm),print<memoryssa>' < %s 2>&1 | FileCheck %s

; CHECK-LABEL: @f(i1 %arg)

; CHECK: lbl1:
; CHECK-NEXT: ; [[NO4:.*]] = MemoryPhi({entry,liveOnEntry},{lbl1.backedge,[[NO9:.*]]})
; CHECK-NEXT: ; [[NO2:.*]] = MemoryDef([[NO4]])
; CHECK-NEXT:  call void @g()
; CHECK-NEXT:  br i1 %arg, label %for.end, label %if.else

; CHECK: for.end:
; CHECK-NEXT:  br i1 %arg, label %lbl3, label %lbl2

; CHECK: lbl2:
; CHECK-NEXT: ; [[NO8:.*]] = MemoryPhi({lbl3,[[NO7:.*]]},{for.end,[[NO2]]})
; CHECK-NEXT:  br label %lbl3

; CHECK: lbl3:
; CHECK-NEXT: [[NO7]] = MemoryPhi({lbl2,[[NO8]]},{for.end,2})

; CHECK: cleanup:
; CHECK-NEXT: MemoryUse([[NO2]])
; CHECK-NEXT:  %cleanup.dest = load i32, ptr undef, align 1

; CHECK: lbl1.backedge:
; CHECK-NEXT:  [[NO9]] = MemoryPhi({cleanup,[[NO7]]},{if.else,2})
; CHECK-NEXT:   br label %lbl1

; CHECK: cleanup.cont:
; CHECK-NEXT: ; [[NO6:.*]] = MemoryDef([[NO7]])
; CHECK-NEXT:   store i16 undef, ptr %e, align 1
; CHECK-NEXT:  3 = MemoryDef([[NO6]])
; CHECK-NEXT:   call void @g()

define void @f(i1 %arg) {
entry:
  %e = alloca i16, align 1
  br label %lbl1

lbl1:                                             ; preds = %if.else, %cleanup, %entry
  store i16 undef, ptr %e, align 1
  call void @g()
  br i1 %arg, label %for.end, label %if.else

for.end:                                          ; preds = %lbl1
  br i1 %arg, label %lbl3, label %lbl2

lbl2:                                             ; preds = %lbl3, %for.end
  br label %lbl3

lbl3:                                             ; preds = %lbl2, %for.end
  br i1 %arg, label %lbl2, label %cleanup

cleanup:                                          ; preds = %lbl3
  %cleanup.dest = load i32, ptr undef, align 1
  %switch = icmp ult i32 %cleanup.dest, 1
  br i1 %switch, label %cleanup.cont, label %lbl1

cleanup.cont:                                     ; preds = %cleanup
  call void @g()
  ret void

if.else:                                          ; preds = %lbl1
  br label %lbl1
}

declare void @g()
