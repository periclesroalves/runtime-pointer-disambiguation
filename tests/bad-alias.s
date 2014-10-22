; ModuleID = '/Users/periclesalves/ufmg-research/tests/bad-alias.cpp'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

define void @_Z3fooPiS_S_i(i32* nocapture %A, i32* nocapture %B, i32* nocapture %C, i32 %n) nounwind uwtable ssp {
  %1 = icmp sgt i32 %n, 0
  br i1 %1, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %0, %.lr.ph
  %indvars.iv = phi i64 [ %indvars.iv.next, %.lr.ph ], [ 0, %0 ]
  %2 = getelementptr inbounds i32* %A, i64 %indvars.iv
  %3 = trunc i64 %indvars.iv to i32
  store i32 %3, i32* %2, align 4, !tbaa !0
  %4 = add nsw i64 %indvars.iv, 2
  %5 = getelementptr inbounds i32* %A, i64 %4
  %6 = load i32* %5, align 4, !tbaa !0
  %7 = getelementptr inbounds i32* %B, i64 %indvars.iv
  store i32 %6, i32* %7, align 4, !tbaa !0
  %8 = add nsw i64 %indvars.iv, 3
  %9 = getelementptr inbounds i32* %B, i64 %8
  %10 = load i32* %9, align 4, !tbaa !0
  %11 = add nsw i64 %indvars.iv, 8
  %12 = getelementptr inbounds i32* %C, i64 %11
  store i32 %10, i32* %12, align 4, !tbaa !0
  %indvars.iv.next = add i64 %indvars.iv, 1
  %lftr.wideiv = trunc i64 %indvars.iv.next to i32
  %exitcond = icmp eq i32 %lftr.wideiv, %n
  br i1 %exitcond, label %._crit_edge, label %.lr.ph

._crit_edge:                                      ; preds = %.lr.ph, %0
  ret void
}

define i32 @main() nounwind uwtable ssp {
  %A = alloca [100 x i32], align 16
  %B = alloca [100 x i32], align 16
  br label %.lr.ph.i

.lr.ph.i:                                         ; preds = %.lr.ph.i, %0
  %indvars.iv.i = phi i64 [ %indvars.iv.next.i, %.lr.ph.i ], [ 0, %0 ]
  %1 = getelementptr inbounds [100 x i32]* %A, i64 0, i64 %indvars.iv.i
  %2 = trunc i64 %indvars.iv.i to i32
  store i32 %2, i32* %1, align 4, !tbaa !0
  %3 = add nsw i64 %indvars.iv.i, 2
  %4 = getelementptr inbounds [100 x i32]* %A, i64 0, i64 %3
  %5 = load i32* %4, align 4, !tbaa !0
  %6 = getelementptr inbounds [100 x i32]* %B, i64 0, i64 %indvars.iv.i
  store i32 %5, i32* %6, align 4, !tbaa !0
  %indvars.iv.next.i = add i64 %indvars.iv.i, 1
  %lftr.wideiv = trunc i64 %indvars.iv.next.i to i32
  %exitcond = icmp eq i32 %lftr.wideiv, 100
  br i1 %exitcond, label %_Z3fooPiS_S_i.exit, label %.lr.ph.i

_Z3fooPiS_S_i.exit:                               ; preds = %.lr.ph.i
  %7 = getelementptr inbounds [100 x i32]* %B, i64 0, i64 5
  %8 = load i32* %7, align 4, !tbaa !0
  %9 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str, i64 0, i64 0), i32 %8)
  ret i32 0
}

declare i32 @printf(i8* nocapture, ...) nounwind

!0 = metadata !{metadata !"int", metadata !1}
!1 = metadata !{metadata !"omnipotent char", metadata !2}
!2 = metadata !{metadata !"Simple C/C++ TBAA"}
