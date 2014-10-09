; ModuleID = '/Users/periclesalves/ufmg-research/tests/bad-alias.s'
target datalayout = "e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: nounwind ssp uwtable
define void @_Z3fooPiS_i(i32* nocapture %A, i32* nocapture %B, i32 %n) #0 {
  %resume.val.reg2mem = alloca i64
  br label %.split

.split:                                           ; preds = %0
  %1 = icmp sgt i32 %n, 0
  br i1 %1, label %overflow.checked, label %._crit_edge

overflow.checked:                                 ; preds = %.split
  %2 = add i32 %n, -1
  %3 = zext i32 %2 to i64
  %4 = add nuw nsw i64 %3, 1
  %end.idx = add nuw nsw i64 %3, 1
  %n.vec = and i64 %4, 8589934584
  %cmp.zero = icmp eq i64 %n.vec, 0
  %5 = add i32 %n, -1
  %6 = zext i32 %5 to i64
  store i64 0, i64* %resume.val.reg2mem
  br i1 %cmp.zero, label %middle.block, label %vector.memcheck

vector.memcheck:                                  ; preds = %overflow.checked
  %scevgep6 = getelementptr i32* %B, i64 %6
  %bound0 = icmp uge i32* %scevgep6, %A
  %scevgep = getelementptr i32* %A, i64 %6
  %bound1 = icmp uge i32* %scevgep, %B
  %memcheck.conflict = and i1 %bound0, %bound1
  store i64 0, i64* %resume.val.reg2mem
  br i1 %memcheck.conflict, label %middle.block, label %vector.body.preheader

vector.body.preheader:                            ; preds = %vector.memcheck
  br label %vector.body

vector.body:                                      ; preds = %vector.body.preheader, %vector.body
  %indvar19 = phi i64 [ 0, %vector.body.preheader ], [ %indvar.next20, %vector.body ]
  %7 = mul i64 %indvar19, 8
  %8 = trunc i64 %7 to i32
  %9 = add i64 %7, 4
  %scevgep21 = getelementptr i32* %B, i64 %9
  %scevgep2122 = bitcast i32* %scevgep21 to <4 x i32>*
  %scevgep23 = getelementptr i32* %A, i64 %9
  %scevgep2324 = bitcast i32* %scevgep23 to <4 x i32>*
  %scevgep25 = getelementptr i32* %A, i64 %7
  %scevgep2526 = bitcast i32* %scevgep25 to <4 x i32>*
  %scevgep27 = getelementptr i32* %B, i64 %7
  %scevgep2728 = bitcast i32* %scevgep27 to <4 x i32>*
  %index.next = add i64 %7, 8
  %broadcast.splatinsert9 = insertelement <4 x i32> undef, i32 %8, i32 0
  %broadcast.splat10 = shufflevector <4 x i32> %broadcast.splatinsert9, <4 x i32> undef, <4 x i32> zeroinitializer
  %induction11 = add <4 x i32> %broadcast.splat10, <i32 0, i32 1, i32 2, i32 3>
  %induction12 = add <4 x i32> %broadcast.splat10, <i32 4, i32 5, i32 6, i32 7>
  store <4 x i32> %induction11, <4 x i32>* %scevgep2526, align 4, !tbaa !0
  store <4 x i32> %induction12, <4 x i32>* %scevgep2324, align 4, !tbaa !0
  store <4 x i32> %induction11, <4 x i32>* %scevgep2728, align 4, !tbaa !0
  store <4 x i32> %induction12, <4 x i32>* %scevgep2122, align 4, !tbaa !0
  %10 = icmp eq i64 %index.next, %n.vec
  %indvar.next20 = add i64 %indvar19, 1
  br i1 %10, label %middle.block.loopexit, label %vector.body, !llvm.loop !4

middle.block.loopexit:                            ; preds = %vector.body
  store i64 %n.vec, i64* %resume.val.reg2mem
  br label %middle.block

middle.block:                                     ; preds = %middle.block.loopexit, %vector.memcheck, %overflow.checked
  %resume.val.reload = load i64* %resume.val.reg2mem
  %cmp.n = icmp eq i64 %end.idx, %resume.val.reload
  br i1 %cmp.n, label %._crit_edge, label %.lr.ph.preheader

.lr.ph.preheader:                                 ; preds = %middle.block
  %11 = add i64 %resume.val.reload, 1
  %12 = trunc i64 %11 to i32
  %13 = sub i32 %n, %12
  %14 = zext i32 %13 to i64
  %15 = add i64 %14, 1
  br label %.lr.ph

.lr.ph:                                           ; preds = %.lr.ph.preheader, %.lr.ph
  %indvar = phi i64 [ 0, %.lr.ph.preheader ], [ %indvar.next, %.lr.ph ]
  %16 = add i64 %resume.val.reload, %indvar
  %17 = trunc i64 %16 to i32
  %scevgep17 = getelementptr i32* %B, i64 %16
  %scevgep18 = getelementptr i32* %A, i64 %16
  store i32 %17, i32* %scevgep18, align 4, !tbaa !0
  store i32 %17, i32* %scevgep17, align 4, !tbaa !0
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp eq i64 %indvar.next, %15
  br i1 %exitcond, label %._crit_edge.loopexit, label %.lr.ph, !llvm.loop !7

._crit_edge.loopexit:                             ; preds = %.lr.ph
  br label %._crit_edge

._crit_edge:                                      ; preds = %._crit_edge.loopexit, %middle.block, %.split
  ret void
}

; Function Attrs: nounwind ssp uwtable
define i32 @main() #0 {
overflow.checked:
  %B = alloca [100 x i32], align 16
  br label %overflow.checked.split

overflow.checked.split:                           ; preds = %overflow.checked
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %overflow.checked.split
  %indvar = phi i64 [ %indvar.next, %vector.body ], [ 0, %overflow.checked.split ]
  %0 = mul i64 %indvar, 4
  %1 = trunc i64 %0 to i32
  %scevgep = getelementptr [100 x i32]* %B, i64 0, i64 %0
  %scevgep5 = bitcast i32* %scevgep to <4 x i32>*
  %broadcast.splatinsert2 = insertelement <4 x i32> undef, i32 %1, i32 0
  %broadcast.splat3 = shufflevector <4 x i32> %broadcast.splatinsert2, <4 x i32> undef, <4 x i32> zeroinitializer
  %induction4 = add <4 x i32> %broadcast.splat3, <i32 0, i32 1, i32 2, i32 3>
  store <4 x i32> %induction4, <4 x i32>* %scevgep5, align 16, !tbaa !0
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp eq i64 %indvar.next, 25
  br i1 %exitcond, label %_Z3fooPiS_i.exit, label %vector.body, !llvm.loop !8

_Z3fooPiS_i.exit:                                 ; preds = %vector.body
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
!4 = metadata !{metadata !4, metadata !5, metadata !6}
!5 = metadata !{metadata !"llvm.loop.vectorize.width", i32 1}
!6 = metadata !{metadata !"llvm.loop.interleave.count", i32 1}
!7 = metadata !{metadata !7, metadata !5, metadata !6}
!8 = metadata !{metadata !8, metadata !5, metadata !6}
