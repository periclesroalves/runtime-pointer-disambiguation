; ModuleID = '/Users/periclesalves/ufmg-research/tests/bad-alias.s'
target datalayout = "e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: nounwind ssp uwtable
define void @_Z3fooPiS_i(i32* nocapture %A, i32* nocapture %B, i32 %n) #0 {
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
  %scevgep = getelementptr i32* %B, i64 %indvars.iv
  %scevgep3 = getelementptr i32* %A, i64 %indvars.iv
  store i32 %3, i32* %scevgep3, align 4, !tbaa !0
  store i32 %3, i32* %scevgep, align 4, !tbaa !0
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
  %A = alloca [100 x i32], align 16
  %B = alloca [100 x i32], align 16
  br label %.split

.split:                                           ; preds = %0
  %1 = getelementptr inbounds [100 x i32]* %A, i64 0, i64 0
  %2 = getelementptr inbounds [100 x i32]* %B, i64 0, i64 0
  call void @_Z3fooPiS_i(i32* %1, i32* %2, i32 100)
  %3 = getelementptr inbounds [100 x i32]* %B, i64 0, i64 5
  %4 = load i32* %3, align 4, !tbaa !0
  %5 = tail call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str, i64 0, i64 0), i32 %4)
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
