; ModuleID = '/Users/periclesalves/ufmg-research/tests/bad-alias.s'
target datalayout = "e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: nounwind ssp uwtable
define void @_Z3fooPiS_S_i(i32* nocapture %A, i32* nocapture %B, i32* nocapture %C, i32 %n) #0 {
  %resume.val.reg2mem = alloca i64
  %resume.val54.reg2mem = alloca i64
  br label %.split

.split:                                           ; preds = %0
  %1 = icmp sgt i32 %n, 0
  br i1 %1, label %overflow.checked, label %._crit_edge

overflow.checked:                                 ; preds = %.split
  %2 = add i32 %n, -1
  %3 = zext i32 %2 to i64
  %4 = add nuw nsw i64 %3, 1
  %end.idx = add nuw nsw i64 %3, 1
  %n.vec = and i64 %4, 8589934590
  %cmp.zero = icmp eq i64 %n.vec, 0
  %5 = add i32 %n, -1
  %6 = zext i32 %5 to i64
  %scevgep8 = getelementptr i32* %B, i64 %6
  store i64 0, i64* %resume.val.reg2mem
  br i1 %cmp.zero, label %middle.block, label %vector.memcheck

vector.memcheck:                                  ; preds = %overflow.checked
  %bound0 = icmp uge i32* %scevgep8, %A
  %scevgep = getelementptr i32* %A, i64 %6
  %bound1 = icmp uge i32* %scevgep, %B
  %found.conflict = and i1 %bound0, %bound1
  %7 = add nuw nsw i64 %6, 2
  %scevgep12 = getelementptr i32* %A, i64 %7
  %bound014 = icmp uge i32* %scevgep12, %B
  %scevgep10 = getelementptr i32* %A, i64 2
  %bound115 = icmp ule i32* %scevgep10, %scevgep8
  %found.conflict16 = and i1 %bound014, %bound115
  %conflict.rdx = or i1 %found.conflict, %found.conflict16
  store i64 0, i64* %resume.val.reg2mem
  br i1 %conflict.rdx, label %middle.block, label %vector.body.preheader

vector.body.preheader:                            ; preds = %vector.memcheck
  br label %vector.body

vector.body:                                      ; preds = %vector.body.preheader, %vector.body
  %indvar87 = phi i64 [ 0, %vector.body.preheader ], [ %indvar.next88, %vector.body ]
  %8 = mul i64 %indvar87, 2
  %9 = trunc i64 %8 to i32
  %index.next = add i64 %8, 2
  %scevgep89 = getelementptr i32* %A, i64 %index.next
  %scevgep8990 = bitcast i32* %scevgep89 to <2 x i32>*
  %scevgep91 = getelementptr i32* %A, i64 %8
  %scevgep9192 = bitcast i32* %scevgep91 to <2 x i32>*
  %scevgep93 = getelementptr i32* %B, i64 %8
  %scevgep9394 = bitcast i32* %scevgep93 to <2 x i32>*
  %broadcast.splatinsert17 = insertelement <2 x i32> undef, i32 %9, i32 0
  %broadcast.splat18 = shufflevector <2 x i32> %broadcast.splatinsert17, <2 x i32> undef, <2 x i32> zeroinitializer
  %induction19 = add <2 x i32> %broadcast.splat18, <i32 0, i32 1>
  store <2 x i32> %induction19, <2 x i32>* %scevgep9192, align 4, !tbaa !0
  %wide.load = load <2 x i32>* %scevgep8990, align 4, !tbaa !0
  store <2 x i32> %wide.load, <2 x i32>* %scevgep9394, align 4, !tbaa !0
  %10 = icmp eq i64 %index.next, %n.vec
  %indvar.next88 = add i64 %indvar87, 1
  br i1 %10, label %middle.block.loopexit, label %vector.body, !llvm.loop !4

middle.block.loopexit:                            ; preds = %vector.body
  store i64 %n.vec, i64* %resume.val.reg2mem
  br label %middle.block

middle.block:                                     ; preds = %middle.block.loopexit, %vector.memcheck, %overflow.checked
  %resume.val.reload = load i64* %resume.val.reg2mem
  %cmp.n = icmp eq i64 %end.idx, %resume.val.reload
  br i1 %cmp.n, label %overflow.checked34, label %.lr.ph5.preheader

.lr.ph5.preheader:                                ; preds = %middle.block
  %11 = add i64 %resume.val.reload, 1
  %12 = trunc i64 %11 to i32
  %13 = sub i32 %n, %12
  %14 = zext i32 %13 to i64
  %15 = add i64 %14, 1
  %16 = add i64 %resume.val.reload, 2
  br label %.lr.ph5

.lr.ph5:                                          ; preds = %.lr.ph5.preheader, %.lr.ph5
  %indvar81 = phi i64 [ 0, %.lr.ph5.preheader ], [ %indvar.next82, %.lr.ph5 ]
  %17 = add i64 %resume.val.reload, %indvar81
  %18 = trunc i64 %17 to i32
  %scevgep84 = getelementptr i32* %B, i64 %17
  %19 = add i64 %16, %indvar81
  %scevgep85 = getelementptr i32* %A, i64 %19
  %scevgep86 = getelementptr i32* %A, i64 %17
  store i32 %18, i32* %scevgep86, align 4, !tbaa !0
  %20 = load i32* %scevgep85, align 4, !tbaa !0
  store i32 %20, i32* %scevgep84, align 4, !tbaa !0
  %indvar.next82 = add i64 %indvar81, 1
  %exitcond83 = icmp eq i64 %indvar.next82, %15
  br i1 %exitcond83, label %overflow.checked34.loopexit, label %.lr.ph5, !llvm.loop !7

overflow.checked34.loopexit:                      ; preds = %.lr.ph5
  br label %overflow.checked34

overflow.checked34:                               ; preds = %overflow.checked34.loopexit, %middle.block
  %21 = add i32 %n, -1
  %22 = zext i32 %21 to i64
  %23 = add nuw nsw i64 %22, 1
  %end.idx29 = add nuw nsw i64 %22, 1
  %n.vec31 = and i64 %23, 8589934590
  %cmp.zero33 = icmp eq i64 %n.vec31, 0
  %24 = add i32 %n, -1
  %25 = zext i32 %24 to i64
  %scevgep37 = getelementptr i32* %C, i64 8
  %26 = add nuw nsw i64 %25, 8
  %scevgep39 = getelementptr i32* %C, i64 %26
  store i64 0, i64* %resume.val54.reg2mem
  br i1 %cmp.zero33, label %middle.block26, label %vector.memcheck53

vector.memcheck53:                                ; preds = %overflow.checked34
  %bound045 = icmp uge i32* %scevgep39, %B
  %scevgep35 = getelementptr i32* %B, i64 %25
  %bound146 = icmp ule i32* %scevgep37, %scevgep35
  %found.conflict47 = and i1 %bound045, %bound146
  %27 = add nuw nsw i64 %25, 3
  %scevgep43 = getelementptr i32* %B, i64 %27
  %bound048 = icmp ule i32* %scevgep37, %scevgep43
  %scevgep41 = getelementptr i32* %B, i64 3
  %bound149 = icmp ule i32* %scevgep41, %scevgep39
  %found.conflict50 = and i1 %bound048, %bound149
  %conflict.rdx51 = or i1 %found.conflict47, %found.conflict50
  store i64 0, i64* %resume.val54.reg2mem
  br i1 %conflict.rdx51, label %middle.block26, label %vector.body25.preheader

vector.body25.preheader:                          ; preds = %vector.memcheck53
  br label %vector.body25

vector.body25:                                    ; preds = %vector.body25.preheader, %vector.body25
  %indvar73 = phi i64 [ 0, %vector.body25.preheader ], [ %indvar.next74, %vector.body25 ]
  %28 = mul i64 %indvar73, 2
  %29 = trunc i64 %28 to i32
  %30 = add i64 %28, 8
  %scevgep75 = getelementptr i32* %C, i64 %30
  %scevgep7576 = bitcast i32* %scevgep75 to <2 x i32>*
  %31 = add i64 %28, 3
  %scevgep77 = getelementptr i32* %B, i64 %31
  %scevgep7778 = bitcast i32* %scevgep77 to <2 x i32>*
  %scevgep79 = getelementptr i32* %B, i64 %28
  %scevgep7980 = bitcast i32* %scevgep79 to <2 x i32>*
  %index.next59 = add i64 %28, 2
  %broadcast.splatinsert63 = insertelement <2 x i32> undef, i32 %29, i32 0
  %broadcast.splat64 = shufflevector <2 x i32> %broadcast.splatinsert63, <2 x i32> undef, <2 x i32> zeroinitializer
  %induction65 = add <2 x i32> %broadcast.splat64, <i32 0, i32 1>
  store <2 x i32> %induction65, <2 x i32>* %scevgep7980, align 4, !tbaa !0
  %wide.load66 = load <2 x i32>* %scevgep7778, align 4, !tbaa !0
  store <2 x i32> %wide.load66, <2 x i32>* %scevgep7576, align 4, !tbaa !0
  %32 = icmp eq i64 %index.next59, %n.vec31
  %indvar.next74 = add i64 %indvar73, 1
  br i1 %32, label %middle.block26.loopexit, label %vector.body25, !llvm.loop !8

middle.block26.loopexit:                          ; preds = %vector.body25
  store i64 %n.vec31, i64* %resume.val54.reg2mem
  br label %middle.block26

middle.block26:                                   ; preds = %middle.block26.loopexit, %vector.memcheck53, %overflow.checked34
  %resume.val54.reload = load i64* %resume.val54.reg2mem
  %cmp.n58 = icmp eq i64 %end.idx29, %resume.val54.reload
  br i1 %cmp.n58, label %._crit_edge, label %.lr.ph.preheader

.lr.ph.preheader:                                 ; preds = %middle.block26
  %33 = add i64 %resume.val54.reload, 1
  %34 = trunc i64 %33 to i32
  %35 = sub i32 %n, %34
  %36 = zext i32 %35 to i64
  %37 = add i64 %36, 1
  %38 = add i64 %resume.val54.reload, 8
  %39 = add i64 %resume.val54.reload, 3
  br label %.lr.ph

.lr.ph:                                           ; preds = %.lr.ph.preheader, %.lr.ph
  %indvar = phi i64 [ 0, %.lr.ph.preheader ], [ %indvar.next, %.lr.ph ]
  %40 = add i64 %38, %indvar
  %scevgep70 = getelementptr i32* %C, i64 %40
  %41 = add i64 %39, %indvar
  %scevgep71 = getelementptr i32* %B, i64 %41
  %42 = add i64 %resume.val54.reload, %indvar
  %43 = trunc i64 %42 to i32
  %scevgep72 = getelementptr i32* %B, i64 %42
  store i32 %43, i32* %scevgep72, align 4, !tbaa !0
  %44 = load i32* %scevgep71, align 4, !tbaa !0
  store i32 %44, i32* %scevgep70, align 4, !tbaa !0
  %indvar.next = add i64 %indvar, 1
  %exitcond69 = icmp eq i64 %indvar.next, %37
  br i1 %exitcond69, label %._crit_edge.loopexit, label %.lr.ph, !llvm.loop !9

._crit_edge.loopexit:                             ; preds = %.lr.ph
  br label %._crit_edge

._crit_edge:                                      ; preds = %._crit_edge.loopexit, %middle.block26, %.split
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
  %indvar28 = phi i64 [ %indvar.next29, %vector.body ], [ 0, %overflow.checked.split ]
  %0 = mul i64 %indvar28, 2
  %1 = trunc i64 %0 to i32
  %index.next = add i64 %0, 2
  %scevgep31 = getelementptr [100 x i32]* %A, i64 0, i64 %index.next
  %scevgep3132 = bitcast i32* %scevgep31 to <2 x i32>*
  %scevgep33 = getelementptr [100 x i32]* %A, i64 0, i64 %0
  %scevgep3334 = bitcast i32* %scevgep33 to <2 x i32>*
  %scevgep35 = getelementptr [100 x i32]* %B, i64 0, i64 %0
  %scevgep3536 = bitcast i32* %scevgep35 to <2 x i32>*
  %broadcast.splatinsert4 = insertelement <2 x i32> undef, i32 %1, i32 0
  %broadcast.splat5 = shufflevector <2 x i32> %broadcast.splatinsert4, <2 x i32> undef, <2 x i32> zeroinitializer
  %induction6 = add <2 x i32> %broadcast.splat5, <i32 0, i32 1>
  store <2 x i32> %induction6, <2 x i32>* %scevgep3334, align 8, !tbaa !0
  %wide.load = load <2 x i32>* %scevgep3132, align 8, !tbaa !0
  store <2 x i32> %wide.load, <2 x i32>* %scevgep3536, align 8, !tbaa !0
  %indvar.next29 = add i64 %indvar28, 1
  %exitcond30 = icmp eq i64 %indvar.next29, 50
  br i1 %exitcond30, label %vector.body10.preheader, label %vector.body, !llvm.loop !10

vector.body10.preheader:                          ; preds = %vector.body
  br label %vector.body10

vector.body10:                                    ; preds = %vector.body10.preheader, %vector.body10
  %indvar = phi i64 [ 0, %vector.body10.preheader ], [ %indvar.next, %vector.body10 ]
  %2 = mul i64 %indvar, 4
  %3 = trunc i64 %2 to i32
  %scevgep = getelementptr [100 x i32]* %B, i64 0, i64 %2
  %scevgep27 = bitcast i32* %scevgep to <4 x i32>*
  %broadcast.splatinsert24 = insertelement <4 x i32> undef, i32 %3, i32 0
  %broadcast.splat25 = shufflevector <4 x i32> %broadcast.splatinsert24, <4 x i32> undef, <4 x i32> zeroinitializer
  %induction26 = add <4 x i32> %broadcast.splat25, <i32 0, i32 1, i32 2, i32 3>
  store <4 x i32> %induction26, <4 x i32>* %scevgep27, align 16, !tbaa !0
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp eq i64 %indvar.next, 25
  br i1 %exitcond, label %_Z3fooPiS_S_i.exit, label %vector.body10, !llvm.loop !11

_Z3fooPiS_S_i.exit:                               ; preds = %vector.body10
  %4 = getelementptr inbounds [100 x i32]* %B, i64 0, i64 5
  %5 = load i32* %4, align 4, !tbaa !0
  %6 = tail call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str, i64 0, i64 0), i32 %5)
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
!9 = metadata !{metadata !9, metadata !5, metadata !6}
!10 = metadata !{metadata !10, metadata !5, metadata !6}
!11 = metadata !{metadata !11, metadata !5, metadata !6}
