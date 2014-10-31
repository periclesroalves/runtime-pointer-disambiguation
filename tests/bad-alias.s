; ModuleID = '/Users/periclesalves/ufmg-research/tests/bad-alias.cpp'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

define void @_Z3fooPiS_S_i(i32* nocapture %A, i32* nocapture %B, i32* nocapture %C, i32 %n) nounwind uwtable ssp {
  %1 = icmp sgt i32 %n, 0
  br i1 %1, label %.lr.ph5, label %._crit_edge

.preheader:                                       ; preds = %.lr.ph5
  %2 = icmp sgt i32 %n, 0
  br i1 %2, label %.lr.ph, label %._crit_edge

.lr.ph5:                                          ; preds = %0, %.lr.ph5
  %indvars.iv7 = phi i64 [ %indvars.iv.next8, %.lr.ph5 ], [ 0, %0 ]
  %3 = getelementptr inbounds i32* %A, i64 %indvars.iv7
  %4 = trunc i64 %indvars.iv7 to i32
  store i32 %4, i32* %3, align 4, !tbaa !0
  %5 = add nsw i64 %indvars.iv7, 2
  %6 = getelementptr inbounds i32* %A, i64 %5
  %7 = load i32* %6, align 4, !tbaa !0
  %8 = getelementptr inbounds i32* %B, i64 %indvars.iv7
  store i32 %7, i32* %8, align 4, !tbaa !0
  %indvars.iv.next8 = add i64 %indvars.iv7, 1
  %lftr.wideiv9 = trunc i64 %indvars.iv.next8 to i32
  %exitcond10 = icmp eq i32 %lftr.wideiv9, %n
  br i1 %exitcond10, label %.preheader, label %.lr.ph5

.lr.ph:                                           ; preds = %.preheader, %.lr.ph
  %indvars.iv = phi i64 [ %indvars.iv.next, %.lr.ph ], [ 0, %.preheader ]
  %9 = getelementptr inbounds i32* %B, i64 %indvars.iv
  %10 = trunc i64 %indvars.iv to i32
  store i32 %10, i32* %9, align 4, !tbaa !0
  %11 = add nsw i64 %indvars.iv, 3
  %12 = getelementptr inbounds i32* %B, i64 %11
  %13 = load i32* %12, align 4, !tbaa !0
  %14 = add nsw i64 %indvars.iv, 8
  %15 = getelementptr inbounds i32* %C, i64 %14
  store i32 %13, i32* %15, align 4, !tbaa !0
  %indvars.iv.next = add i64 %indvars.iv, 1
  %lftr.wideiv = trunc i64 %indvars.iv.next to i32
  %exitcond = icmp eq i32 %lftr.wideiv, %n
  br i1 %exitcond, label %._crit_edge, label %.lr.ph

._crit_edge:                                      ; preds = %0, %.lr.ph, %.preheader
  ret void
}

define i32 @main() nounwind uwtable ssp {
  %A = alloca [100 x i32], align 16
  %B = alloca [100 x i32], align 16
  %C = alloca [200 x i32], align 16
  %1 = getelementptr inbounds [100 x i32]* %A, i64 0, i64 0
  %2 = getelementptr inbounds [100 x i32]* %B, i64 0, i64 0
  %3 = getelementptr inbounds [200 x i32]* %C, i64 0, i64 0
  call void @_Z3fooPiS_S_i(i32* %1, i32* %2, i32* %3, i32 100)
  %4 = getelementptr inbounds [100 x i32]* %B, i64 0, i64 5
  %5 = load i32* %4, align 4, !tbaa !0
  %6 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str, i64 0, i64 0), i32 %5)
  ret i32 0
}

declare i32 @printf(i8* nocapture, ...) nounwind

!0 = metadata !{metadata !"int", metadata !1}
!1 = metadata !{metadata !"omnipotent char", metadata !2}
!2 = metadata !{metadata !"Simple C/C++ TBAA"}
