; ModuleID = '/Users/periclesalves/ufmg-research/tests/bad-alias.s'
target datalayout = "e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: nounwind ssp uwtable
define void @_Z3fooPiS_Pfi(i32* nocapture %A, i32* nocapture %B, float* nocapture %C, i32 %n) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = icmp sgt i32 %n, 0
  br i1 %1, label %.lr.ph.preheader, label %._crit_edge

.lr.ph.preheader:                                 ; preds = %.split
  %2 = zext i32 %n to i64
  br label %.lr.ph

.lr.ph:                                           ; preds = %.lr.ph.preheader, %.lr.ph
  %indvars.iv = phi i64 [ %indvars.iv.next, %.lr.ph ], [ 0, %.lr.ph.preheader ]
  %3 = trunc i64 %indvars.iv to i32
  %4 = add i64 %indvars.iv, 8
  %scevgep = getelementptr float* %C, i64 %4
  %5 = add i64 %indvars.iv, 3
  %scevgep4 = getelementptr i32* %B, i64 %5
  %scevgep5 = getelementptr i32* %B, i64 %indvars.iv
  %6 = add i64 %indvars.iv, 2
  %scevgep6 = getelementptr i32* %A, i64 %6
  %scevgep7 = getelementptr i32* %A, i64 %indvars.iv
  store i32 %3, i32* %scevgep7, align 4, !tbaa !0
  %7 = load i32* %scevgep6, align 4, !tbaa !0
  store i32 %7, i32* %scevgep5, align 4, !tbaa !0
  %8 = load i32* %scevgep4, align 4, !tbaa !0
  %9 = sitofp i32 %8 to float
  store float %9, float* %scevgep, align 4, !tbaa !4
  %indvars.iv.next = add i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, %2
  br i1 %exitcond, label %._crit_edge.loopexit, label %.lr.ph

._crit_edge.loopexit:                             ; preds = %.lr.ph
  br label %._crit_edge

._crit_edge:                                      ; preds = %._crit_edge.loopexit, %.split
  ret void
}

; Function Attrs: nounwind ssp uwtable
define i32 @main() #0 {
overflow.checked:
  %A = alloca [100 x i32], align 16
  %B = alloca [100 x i32], align 16
  br label %overflow.checked.split

overflow.checked.split:                           ; preds = %overflow.checked
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %overflow.checked.split
  %indvar = phi i64 [ %indvar.next, %vector.body ], [ 0, %overflow.checked.split ]
  %0 = mul i64 %indvar, 2
  %1 = trunc i64 %0 to i32
  %index.next = add i64 %0, 2
  %scevgep = getelementptr [100 x i32]* %A, i64 0, i64 %index.next
  %scevgep7 = bitcast i32* %scevgep to <2 x i32>*
  %scevgep8 = getelementptr [100 x i32]* %A, i64 0, i64 %0
  %scevgep89 = bitcast i32* %scevgep8 to <2 x i32>*
  %scevgep10 = getelementptr [100 x i32]* %B, i64 0, i64 %0
  %scevgep1011 = bitcast i32* %scevgep10 to <2 x i32>*
  %broadcast.splatinsert4 = insertelement <2 x i32> undef, i32 %1, i32 0
  %broadcast.splat5 = shufflevector <2 x i32> %broadcast.splatinsert4, <2 x i32> undef, <2 x i32> zeroinitializer
  %induction6 = add <2 x i32> %broadcast.splat5, <i32 0, i32 1>
  store <2 x i32> %induction6, <2 x i32>* %scevgep89, align 8, !tbaa !0
  %wide.load = load <2 x i32>* %scevgep7, align 8, !tbaa !0
  store <2 x i32> %wide.load, <2 x i32>* %scevgep1011, align 8, !tbaa !0
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp eq i64 %indvar.next, 50
  br i1 %exitcond, label %_Z3fooPiS_Pfi.exit, label %vector.body, !llvm.loop !6

_Z3fooPiS_Pfi.exit:                               ; preds = %vector.body
  %2 = getelementptr inbounds [100 x i32]* %B, i64 0, i64 5
  %3 = load i32* %2, align 4, !tbaa !0
  %4 = tail call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str, i64 0, i64 0), i32 %3)
  ret i32 0
}

; Function Attrs: nounwind
declare i32 @printf(i8* nocapture readonly, ...) #1

attributes #0 = { nounwind ssp uwtable }
attributes #1 = { nounwind }

!0 = metadata !{metadata !1, metadata !1, i64 0}
!1 = metadata !{metadata !"int", metadata !2}
!2 = metadata !{metadata !"omnipotent char", metadata !3}
!3 = metadata !{metadata !"Simple C/C++ TBAA"}
!4 = metadata !{metadata !5, metadata !5, i64 0}
!5 = metadata !{metadata !"float", metadata !2}
!6 = metadata !{metadata !6, metadata !7, metadata !8}
!7 = metadata !{metadata !"llvm.loop.vectorize.width", i32 1}
!8 = metadata !{metadata !"llvm.loop.interleave.count", i32 1}
