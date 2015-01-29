; ModuleID = 'polybench.ll'
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"

%struct.__sFILE = type { i8*, i32, i32, i16, i16, %struct.__sbuf, i32, i8*, i32 (i8*)*, i32 (i8*, i8*, i32)*, i64 (i8*, i64, i32)*, i32 (i8*, i8*, i32)*, %struct.__sbuf, %struct.__sFILEX*, i32, [3 x i8], [1 x i8], %struct.__sbuf, i32, i64 }
%struct.__sFILEX = type opaque
%struct.__sbuf = type { i8*, i32 }

@polybench_papi_counters_threadid = global i32 0, align 4
@polybench_program_total_flops = global double 0.000000e+00, align 8
@__func__.polybench_flush_cache = private unnamed_addr constant [22 x i8] c"polybench_flush_cache\00", align 1
@.str = private unnamed_addr constant [22 x i8] c"utilities/polybench.c\00", align 1
@.str1 = private unnamed_addr constant [12 x i8] c"tmp <= 10.0\00", align 1
@polybench_t_start = common global double 0.000000e+00, align 8
@polybench_t_end = common global double 0.000000e+00, align 8
@.str2 = private unnamed_addr constant [7 x i8] c"%0.6f\0A\00", align 1
@polybench_c_start = common global i64 0, align 8
@polybench_c_end = common global i64 0, align 8
@__stderrp = external global %struct.__sFILE*
@.str3 = private unnamed_addr constant [51 x i8] c"[PolyBench] posix_memalign: cannot allocate memory\00", align 1
@.str11 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1

; Function Attrs: nounwind ssp uwtable
define void @polybench_flush_cache() #0 {
bb:
  %tmp4 = tail call i8* @calloc(i64 4194560, i64 8) #4
  br label %bb5, !llvm.loop !1

bb5:                                              ; preds = %bb5, %bb
  %tmp.0 = phi double [ 0.000000e+00, %bb ], [ %tmp12.3, %bb5 ]
  %tmp6 = phi i64 [ 0, %bb ], [ %tmp13.3, %bb5 ]
  %tmp8 = shl i64 %tmp6, 3
  %tmp9 = getelementptr i8* %tmp4, i64 %tmp8
  %tmp10 = bitcast i8* %tmp9 to double*
  %tmp11 = load double* %tmp10, align 8, !tbaa !2
  %tmp12 = fadd double %tmp.0, %tmp11
  %tmp13 = add i64 %tmp6, 1
  %tmp8.1 = shl i64 %tmp13, 3
  %tmp9.1 = getelementptr i8* %tmp4, i64 %tmp8.1
  %tmp10.1 = bitcast i8* %tmp9.1 to double*
  %tmp11.1 = load double* %tmp10.1, align 8, !tbaa !2
  %tmp12.1 = fadd double %tmp12, %tmp11.1
  %tmp13.1 = add i64 %tmp13, 1
  %tmp8.2 = shl i64 %tmp13.1, 3
  %tmp9.2 = getelementptr i8* %tmp4, i64 %tmp8.2
  %tmp10.2 = bitcast i8* %tmp9.2 to double*
  %tmp11.2 = load double* %tmp10.2, align 8, !tbaa !2
  %tmp12.2 = fadd double %tmp12.1, %tmp11.2
  %tmp13.2 = add i64 %tmp13.1, 1
  %tmp8.3 = shl i64 %tmp13.2, 3
  %tmp9.3 = getelementptr i8* %tmp4, i64 %tmp8.3
  %tmp10.3 = bitcast i8* %tmp9.3 to double*
  %tmp11.3 = load double* %tmp10.3, align 8, !tbaa !2
  %tmp12.3 = fadd double %tmp12.2, %tmp11.3
  %tmp13.3 = add i64 %tmp13.2, 1
  %tmp14.3 = icmp eq i64 %tmp13.3, 4194560
  br i1 %tmp14.3, label %bb15, label %bb5, !llvm.loop !6

bb15:                                             ; preds = %bb5
  %tmp12.lcssa = phi double [ %tmp12.3, %bb5 ]
  %tmp17 = fcmp ugt double %tmp12.lcssa, 1.000000e+01
  br i1 %tmp17, label %bb21, label %bb22, !llvm.loop !7

bb21:                                             ; preds = %bb15
  tail call void @__assert_rtn(i8* getelementptr inbounds ([22 x i8]* @__func__.polybench_flush_cache, i64 0, i64 0), i8* getelementptr inbounds ([22 x i8]* @.str, i64 0, i64 0), i32 96, i8* getelementptr inbounds ([12 x i8]* @.str1, i64 0, i64 0)) #5, !llvm.loop !8
  unreachable, !llvm.loop !9

bb22:                                             ; preds = %bb15
  tail call void @free(i8* %tmp4), !llvm.loop !10
  ret void, !llvm.loop !11
}

; Function Attrs: nounwind
declare noalias i8* @calloc(i64, i64) #1

; Function Attrs: noreturn
declare void @__assert_rtn(i8*, i8*, i32, i8*) #2

; Function Attrs: nounwind
declare void @free(i8* nocapture) #1

; Function Attrs: nounwind ssp uwtable
define void @polybench_prepare_instruments() #0 {
bb:
  %tmp4.i = tail call i8* @calloc(i64 4194560, i64 8) #4
  br label %bb5.i, !llvm.loop !1

bb5.i:                                            ; preds = %bb5.i, %bb
  %tmp.0.i = phi double [ 0.000000e+00, %bb ], [ %tmp12.i.3, %bb5.i ]
  %tmp6.i = phi i64 [ 0, %bb ], [ %tmp13.i.3, %bb5.i ]
  %tmp8.i = shl i64 %tmp6.i, 3
  %tmp9.i = getelementptr i8* %tmp4.i, i64 %tmp8.i
  %tmp10.i = bitcast i8* %tmp9.i to double*
  %tmp11.i = load double* %tmp10.i, align 8, !tbaa !2
  %tmp12.i = fadd double %tmp.0.i, %tmp11.i
  %tmp13.i = add i64 %tmp6.i, 1
  %tmp8.i.1 = shl i64 %tmp13.i, 3
  %tmp9.i.1 = getelementptr i8* %tmp4.i, i64 %tmp8.i.1
  %tmp10.i.1 = bitcast i8* %tmp9.i.1 to double*
  %tmp11.i.1 = load double* %tmp10.i.1, align 8, !tbaa !2
  %tmp12.i.1 = fadd double %tmp12.i, %tmp11.i.1
  %tmp13.i.1 = add i64 %tmp13.i, 1
  %tmp8.i.2 = shl i64 %tmp13.i.1, 3
  %tmp9.i.2 = getelementptr i8* %tmp4.i, i64 %tmp8.i.2
  %tmp10.i.2 = bitcast i8* %tmp9.i.2 to double*
  %tmp11.i.2 = load double* %tmp10.i.2, align 8, !tbaa !2
  %tmp12.i.2 = fadd double %tmp12.i.1, %tmp11.i.2
  %tmp13.i.2 = add i64 %tmp13.i.1, 1
  %tmp8.i.3 = shl i64 %tmp13.i.2, 3
  %tmp9.i.3 = getelementptr i8* %tmp4.i, i64 %tmp8.i.3
  %tmp10.i.3 = bitcast i8* %tmp9.i.3 to double*
  %tmp11.i.3 = load double* %tmp10.i.3, align 8, !tbaa !2
  %tmp12.i.3 = fadd double %tmp12.i.2, %tmp11.i.3
  %tmp13.i.3 = add i64 %tmp13.i.2, 1
  %tmp14.i.3 = icmp eq i64 %tmp13.i.3, 4194560
  br i1 %tmp14.i.3, label %bb15.i, label %bb5.i, !llvm.loop !6

bb15.i:                                           ; preds = %bb5.i
  %tmp12.i.lcssa = phi double [ %tmp12.i.3, %bb5.i ]
  %tmp17.i = fcmp ugt double %tmp12.i.lcssa, 1.000000e+01
  br i1 %tmp17.i, label %bb21.i, label %polybench_flush_cache.exit, !llvm.loop !7

bb21.i:                                           ; preds = %bb15.i
  tail call void @__assert_rtn(i8* getelementptr inbounds ([22 x i8]* @__func__.polybench_flush_cache, i64 0, i64 0), i8* getelementptr inbounds ([22 x i8]* @.str, i64 0, i64 0), i32 96, i8* getelementptr inbounds ([12 x i8]* @.str1, i64 0, i64 0)) #5, !llvm.loop !8
  unreachable, !llvm.loop !9

polybench_flush_cache.exit:                       ; preds = %bb15.i
  tail call void @free(i8* %tmp4.i) #4, !llvm.loop !10
  ret void, !llvm.loop !1
}

; Function Attrs: nounwind ssp uwtable
define void @polybench_timer_start() #0 {
bb:
  %tmp4.i.i = tail call i8* @calloc(i64 4194560, i64 8) #4
  br label %bb5.i.i, !llvm.loop !1

bb5.i.i:                                          ; preds = %bb5.i.i, %bb
  %tmp.0.i.i = phi double [ 0.000000e+00, %bb ], [ %tmp12.i.i.3, %bb5.i.i ]
  %tmp6.i.i = phi i64 [ 0, %bb ], [ %tmp13.i.i.3, %bb5.i.i ]
  %tmp8.i.i = shl i64 %tmp6.i.i, 3
  %tmp9.i.i = getelementptr i8* %tmp4.i.i, i64 %tmp8.i.i
  %tmp10.i.i = bitcast i8* %tmp9.i.i to double*
  %tmp11.i.i = load double* %tmp10.i.i, align 8, !tbaa !2
  %tmp12.i.i = fadd double %tmp.0.i.i, %tmp11.i.i
  %tmp13.i.i = add i64 %tmp6.i.i, 1
  %tmp8.i.i.1 = shl i64 %tmp13.i.i, 3
  %tmp9.i.i.1 = getelementptr i8* %tmp4.i.i, i64 %tmp8.i.i.1
  %tmp10.i.i.1 = bitcast i8* %tmp9.i.i.1 to double*
  %tmp11.i.i.1 = load double* %tmp10.i.i.1, align 8, !tbaa !2
  %tmp12.i.i.1 = fadd double %tmp12.i.i, %tmp11.i.i.1
  %tmp13.i.i.1 = add i64 %tmp13.i.i, 1
  %tmp8.i.i.2 = shl i64 %tmp13.i.i.1, 3
  %tmp9.i.i.2 = getelementptr i8* %tmp4.i.i, i64 %tmp8.i.i.2
  %tmp10.i.i.2 = bitcast i8* %tmp9.i.i.2 to double*
  %tmp11.i.i.2 = load double* %tmp10.i.i.2, align 8, !tbaa !2
  %tmp12.i.i.2 = fadd double %tmp12.i.i.1, %tmp11.i.i.2
  %tmp13.i.i.2 = add i64 %tmp13.i.i.1, 1
  %tmp8.i.i.3 = shl i64 %tmp13.i.i.2, 3
  %tmp9.i.i.3 = getelementptr i8* %tmp4.i.i, i64 %tmp8.i.i.3
  %tmp10.i.i.3 = bitcast i8* %tmp9.i.i.3 to double*
  %tmp11.i.i.3 = load double* %tmp10.i.i.3, align 8, !tbaa !2
  %tmp12.i.i.3 = fadd double %tmp12.i.i.2, %tmp11.i.i.3
  %tmp13.i.i.3 = add i64 %tmp13.i.i.2, 1
  %tmp14.i.i.3 = icmp eq i64 %tmp13.i.i.3, 4194560
  br i1 %tmp14.i.i.3, label %bb15.i.i, label %bb5.i.i, !llvm.loop !6

bb15.i.i:                                         ; preds = %bb5.i.i
  %tmp12.i.i.lcssa = phi double [ %tmp12.i.i.3, %bb5.i.i ]
  %tmp17.i.i = fcmp ugt double %tmp12.i.i.lcssa, 1.000000e+01
  br i1 %tmp17.i.i, label %bb21.i.i, label %polybench_prepare_instruments.exit, !llvm.loop !7

bb21.i.i:                                         ; preds = %bb15.i.i
  tail call void @__assert_rtn(i8* getelementptr inbounds ([22 x i8]* @__func__.polybench_flush_cache, i64 0, i64 0), i8* getelementptr inbounds ([22 x i8]* @.str, i64 0, i64 0), i32 96, i8* getelementptr inbounds ([12 x i8]* @.str1, i64 0, i64 0)) #5, !llvm.loop !8
  unreachable, !llvm.loop !9

polybench_prepare_instruments.exit:               ; preds = %bb15.i.i
  tail call void @free(i8* %tmp4.i.i) #4, !llvm.loop !10
  store double 0.000000e+00, double* @polybench_t_start, align 8, !tbaa !2, !llvm.loop !1
  ret void, !llvm.loop !12
}

; Function Attrs: nounwind ssp uwtable
define void @polybench_timer_stop() #0 {
bb:
  store double 0.000000e+00, double* @polybench_t_end, align 8, !tbaa !2, !llvm.loop !13
  ret void, !llvm.loop !1
}

; Function Attrs: nounwind ssp uwtable
define void @polybench_timer_print() #0 {
bb:
  %tmp = load double* @polybench_t_end, align 8, !tbaa !2
  %tmp1 = load double* @polybench_t_start, align 8, !tbaa !2
  %tmp2 = fsub double %tmp, %tmp1
  %tmp3 = tail call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([7 x i8]* @.str2, i64 0, i64 0), double %tmp2) #4
  ret void, !llvm.loop !13
}

; Function Attrs: nounwind
declare i32 @printf(i8* nocapture readonly, ...) #1

; Function Attrs: nounwind ssp uwtable
define i8* @polybench_alloc_data(i64 %n, i32 %elt_size) #0 {
bb:
  %tmp.i = alloca i8*, align 8
  %tmp = sext i32 %elt_size to i64
  %tmp1 = mul i64 %tmp, %n
  %0 = bitcast i8** %tmp.i to i8*
  call void @llvm.lifetime.start(i64 8, i8* %0)
  store i8* null, i8** %tmp.i, align 8, !tbaa !14, !llvm.loop !13
  %tmp1.i = call i32 @posix_memalign(i8** %tmp.i, i64 32, i64 %tmp1) #4
  %tmp2.i = load i8** %tmp.i, align 8, !tbaa !14
  %tmp3.i = icmp ne i8* %tmp2.i, null
  %tmp4.i = icmp eq i32 %tmp1.i, 0
  %tmp5.i = and i1 %tmp3.i, %tmp4.i
  br i1 %tmp5.i, label %xmalloc.exit, label %bb6.i, !llvm.loop !1

bb6.i:                                            ; preds = %bb
  %tmp7.i = load %struct.__sFILE** @__stderrp, align 8, !tbaa !14
  %tmp8.i = call i64 @fwrite(i8* getelementptr inbounds ([51 x i8]* @.str3, i64 0, i64 0), i64 50, i64 1, %struct.__sFILE* %tmp7.i) #4
  call void @exit(i32 1) #5, !llvm.loop !12
  unreachable, !llvm.loop !6

xmalloc.exit:                                     ; preds = %bb
  call void @llvm.lifetime.end(i64 8, i8* %0)
  ret i8* %tmp2.i, !llvm.loop !13
}

declare i32 @posix_memalign(i8**, i64, i64) #3

; Function Attrs: noreturn
declare void @exit(i32) #2

; Function Attrs: nounwind
declare i64 @fwrite(i8* nocapture, i64, i64, %struct.__sFILE* nocapture) #4

; Function Attrs: nounwind
declare void @llvm.lifetime.start(i64, i8* nocapture) #4

; Function Attrs: nounwind
declare void @llvm.lifetime.end(i64, i8* nocapture) #4

; Function Attrs: nounwind ssp uwtable
define i32 @main(i32 %argc, i8** nocapture readonly %argv) #0 {
bb:
  %tmp = tail call i8* @polybench_alloc_data(i64 16000000, i32 8) #4
  %tmp1 = tail call i8* @polybench_alloc_data(i64 4000, i32 8) #4
  %tmp2 = tail call i8* @polybench_alloc_data(i64 4000, i32 8) #4
  %tmp3 = tail call i8* @polybench_alloc_data(i64 4000, i32 8) #4
  %tmp4 = tail call i8* @polybench_alloc_data(i64 4000, i32 8) #4
  %tmp5 = bitcast i8* %tmp to [4000 x double]*
  %tmp7 = bitcast i8* %tmp3 to double*
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %bb
  %index = phi i64 [ 0, %bb ], [ %index.next.1, %vector.body ]
  %induction78113 = or i64 %index, 1
  %0 = trunc i64 %index to i32
  %induction80114 = or i32 %0, 1
  %1 = getelementptr double* %tmp7, i64 %index
  %2 = getelementptr double* %tmp7, i64 %induction78113
  %3 = sitofp i32 %0 to double
  %4 = sitofp i32 %induction80114 to double
  %5 = fmul double %3, 0x400921FB54442D18
  %6 = fmul double %4, 0x400921FB54442D18
  store double %5, double* %1, align 8, !tbaa !2, !llvm.loop !8
  store double %6, double* %2, align 8, !tbaa !2, !llvm.loop !8
  %index.next = add i64 %index, 2
  %induction78113.1 = or i64 %index.next, 1
  %7 = trunc i64 %index.next to i32
  %induction80114.1 = or i32 %7, 1
  %8 = getelementptr double* %tmp7, i64 %index.next
  %9 = getelementptr double* %tmp7, i64 %induction78113.1
  %10 = sitofp i32 %7 to double
  %11 = sitofp i32 %induction80114.1 to double
  %12 = fmul double %10, 0x400921FB54442D18
  %13 = fmul double %11, 0x400921FB54442D18
  store double %12, double* %8, align 8, !tbaa !2, !llvm.loop !8
  store double %13, double* %9, align 8, !tbaa !2, !llvm.loop !8
  %index.next.1 = add i64 %index.next, 2
  %14 = icmp eq i64 %index.next.1, 4000
  br i1 %14, label %.preheader.i, label %vector.body, !llvm.loop !16

.preheader.i:                                     ; preds = %vector.body
  %tmp6 = bitcast i8* %tmp4 to double*
  %r53.i = ptrtoint i8* %tmp4 to i64
  %A52.i = ptrtoint i8* %tmp to i64
  %15 = add i64 %A52.i, 127999992
  %16 = inttoptr i64 %15 to i8*
  %17 = add i64 %r53.i, 31992
  %18 = inttoptr i64 %17 to i8*
  %19 = icmp ult i8* %16, %tmp4
  %20 = icmp ult i8* %18, %tmp
  %no-dyn-alias.i = or i1 %19, %20
  br i1 %no-dyn-alias.i, label %bb29.clone.i.preheader, label %bb29.i.preheader

bb29.i.preheader:                                 ; preds = %.preheader.i
  br label %bb29.i

bb29.clone.i.preheader:                           ; preds = %.preheader.i
  br label %bb29.clone.i

bb29.clone.i:                                     ; preds = %bb48.clone.i, %bb29.clone.i.preheader
  %tmp30.clone.i = phi i64 [ %tmp49.clone.i, %bb48.clone.i ], [ 0, %bb29.clone.i.preheader ]
  %tmp31.clone.i = trunc i64 %tmp30.clone.i to i32
  %tmp32.clone.i = getelementptr double* %tmp6, i64 %tmp30.clone.i
  %tmp33.clone.i = sitofp i32 %tmp31.clone.i to double
  %tmp34.clone.i = fmul double %tmp33.clone.i, 0x400921FB54442D18
  store double %tmp34.clone.i, double* %tmp32.clone.i, align 8, !tbaa !2, !llvm.loop !10
  br label %vector.body100

vector.body100:                                   ; preds = %vector.body100, %bb29.clone.i
  %index103 = phi i64 [ 0, %bb29.clone.i ], [ %index.next110, %vector.body100 ]
  %induction112116 = or i64 %index103, 1
  %21 = getelementptr [4000 x double]* %tmp5, i64 %tmp30.clone.i, i64 %index103
  %22 = getelementptr [4000 x double]* %tmp5, i64 %tmp30.clone.i, i64 %induction112116
  %23 = or i64 %index103, 1
  %24 = add i64 %induction112116, 1
  %25 = trunc i64 %23 to i32
  %26 = trunc i64 %24 to i32
  %27 = sitofp i32 %25 to double
  %28 = sitofp i32 %26 to double
  %29 = fmul double %tmp33.clone.i, %27
  %30 = fmul double %tmp33.clone.i, %28
  %31 = fdiv double %29, 4.000000e+03
  %32 = fdiv double %30, 4.000000e+03
  store double %31, double* %21, align 8, !tbaa !2, !llvm.loop !19
  store double %32, double* %22, align 8, !tbaa !2, !llvm.loop !19
  %index.next110 = add i64 %index103, 2
  %33 = icmp eq i64 %index.next110, 4000
  br i1 %33, label %bb48.clone.i, label %vector.body100, !llvm.loop !20

bb48.clone.i:                                     ; preds = %vector.body100
  %tmp49.clone.i = add i64 %tmp30.clone.i, 1
  %tmp50.clone.i = icmp eq i64 %tmp49.clone.i, 4000
  br i1 %tmp50.clone.i, label %init_array.exit.loopexit, label %bb29.clone.i, !llvm.loop !21

bb29.i:                                           ; preds = %bb48.i, %bb29.i.preheader
  %tmp30.i = phi i64 [ %tmp49.i, %bb48.i ], [ 0, %bb29.i.preheader ]
  %tmp31.i = trunc i64 %tmp30.i to i32
  %tmp32.i = getelementptr double* %tmp6, i64 %tmp30.i
  %tmp33.i = sitofp i32 %tmp31.i to double
  %tmp34.i = fmul double %tmp33.i, 0x400921FB54442D18
  store double %tmp34.i, double* %tmp32.i, align 8, !tbaa !2, !llvm.loop !10
  br label %vector.body84

vector.body84:                                    ; preds = %vector.body84, %bb29.i
  %index87 = phi i64 [ 0, %bb29.i ], [ %index.next94, %vector.body84 ]
  %induction96115 = or i64 %index87, 1
  %34 = getelementptr [4000 x double]* %tmp5, i64 %tmp30.i, i64 %index87
  %35 = getelementptr [4000 x double]* %tmp5, i64 %tmp30.i, i64 %induction96115
  %36 = or i64 %index87, 1
  %37 = add i64 %induction96115, 1
  %38 = trunc i64 %36 to i32
  %39 = trunc i64 %37 to i32
  %40 = sitofp i32 %38 to double
  %41 = sitofp i32 %39 to double
  %42 = fmul double %tmp33.i, %40
  %43 = fmul double %tmp33.i, %41
  %44 = fdiv double %42, 4.000000e+03
  %45 = fdiv double %43, 4.000000e+03
  store double %44, double* %34, align 8, !tbaa !2, !llvm.loop !19
  store double %45, double* %35, align 8, !tbaa !2, !llvm.loop !19
  %index.next94 = add i64 %index87, 2
  %46 = icmp eq i64 %index.next94, 4000
  br i1 %46, label %bb48.i, label %vector.body84, !llvm.loop !22

bb48.i:                                           ; preds = %vector.body84
  %tmp49.i = add i64 %tmp30.i, 1
  %tmp50.i = icmp eq i64 %tmp49.i, 4000
  br i1 %tmp50.i, label %init_array.exit.loopexit118, label %bb29.i, !llvm.loop !21

init_array.exit.loopexit:                         ; preds = %bb48.clone.i
  br label %init_array.exit

init_array.exit.loopexit118:                      ; preds = %bb48.i
  br label %init_array.exit

init_array.exit:                                  ; preds = %init_array.exit.loopexit118, %init_array.exit.loopexit
  %tmp9 = bitcast i8* %tmp1 to double*
  %tmp10 = bitcast i8* %tmp2 to double*
  %p62.i = ptrtoint i8* %tmp3 to i64
  %s56.i = ptrtoint i8* %tmp1 to i64
  tail call void @llvm.memset.p0i8.i64(i8* %tmp1, i8 0, i64 32000, i32 8, i1 false) #4
  %q59.i = ptrtoint i8* %tmp2 to i64
  %47 = add i64 %s56.i, 31992
  %48 = inttoptr i64 %47 to i8*
  %49 = icmp ult i8* %16, %tmp1
  %50 = icmp ult i8* %48, %tmp
  %no-dyn-alias.i39 = or i1 %49, %50
  %51 = add i64 %q59.i, 31992
  %52 = inttoptr i64 %51 to i8*
  %53 = icmp ult i8* %16, %tmp2
  %54 = icmp ult i8* %52, %tmp
  %no-dyn-alias61.i = or i1 %53, %54
  %55 = add i64 %p62.i, 31992
  %56 = inttoptr i64 %55 to i8*
  %57 = icmp ult i8* %16, %tmp3
  %58 = icmp ult i8* %56, %tmp
  %no-dyn-alias64.i = or i1 %57, %58
  %59 = icmp ult i8* %48, %tmp2
  %60 = icmp ult i8* %52, %tmp1
  %no-dyn-alias68.i = or i1 %59, %60
  %61 = icmp ult i8* %48, %tmp3
  %62 = icmp ult i8* %56, %tmp1
  %no-dyn-alias69.i = or i1 %61, %62
  %63 = icmp ult i8* %48, %tmp4
  %64 = icmp ult i8* %18, %tmp1
  %no-dyn-alias70.i = or i1 %63, %64
  %65 = icmp ult i8* %52, %tmp3
  %66 = icmp ult i8* %56, %tmp2
  %no-dyn-alias71.i = or i1 %65, %66
  %67 = icmp ult i8* %52, %tmp4
  %68 = icmp ult i8* %18, %tmp2
  %no-dyn-alias72.i = or i1 %67, %68
  %69 = icmp ult i8* %56, %tmp4
  %70 = icmp ult i8* %18, %tmp3
  %no-dyn-alias73.i = or i1 %69, %70
  %no-dyn-alias74.i = and i1 %no-dyn-alias61.i, %no-dyn-alias.i39
  %no-dyn-alias75.i = and i1 %no-dyn-alias64.i, %no-dyn-alias74.i
  %no-dyn-alias76.i = and i1 %no-dyn-alias.i, %no-dyn-alias75.i
  %no-dyn-alias77.i = and i1 %no-dyn-alias68.i, %no-dyn-alias76.i
  %no-dyn-alias78.i = and i1 %no-dyn-alias69.i, %no-dyn-alias77.i
  %no-dyn-alias79.i = and i1 %no-dyn-alias70.i, %no-dyn-alias78.i
  %no-dyn-alias80.i = and i1 %no-dyn-alias71.i, %no-dyn-alias79.i
  %no-dyn-alias81.i = and i1 %no-dyn-alias72.i, %no-dyn-alias80.i
  %no-dyn-alias82.i = and i1 %no-dyn-alias73.i, %no-dyn-alias81.i
  br i1 %no-dyn-alias82.i, label %bb29.clone.i42.preheader, label %bb29.i56.preheader

bb29.i56.preheader:                               ; preds = %init_array.exit
  br label %bb29.i56

bb29.clone.i42.preheader:                         ; preds = %init_array.exit
  br label %bb29.clone.i42

bb29.clone.i42:                                   ; preds = %bb51.clone.i, %bb29.clone.i42.preheader
  %tmp30.clone.i40 = phi i64 [ %tmp52.clone.i, %bb51.clone.i ], [ 0, %bb29.clone.i42.preheader ]
  %tmp31.clone.i41 = getelementptr double* %tmp10, i64 %tmp30.clone.i40
  store double 0.000000e+00, double* %tmp31.clone.i41, align 8, !tbaa !2, !llvm.loop !10
  %tmp32.clone.moved.to.bb34.clone.i = getelementptr double* %tmp6, i64 %tmp30.clone.i40
  br label %bb34.clone.i

bb34.clone.i:                                     ; preds = %bb34.clone.i, %bb29.clone.i42
  %tmp35.clone.i = phi i64 [ %tmp49.clone.i51, %bb34.clone.i ], [ 0, %bb29.clone.i42 ]
  %tmp36.clone.i = getelementptr [4000 x double]* %tmp5, i64 %tmp30.clone.i40, i64 %tmp35.clone.i
  %tmp37.clone.i43 = getelementptr double* %tmp9, i64 %tmp35.clone.i
  %tmp38.clone.i44 = getelementptr double* %tmp7, i64 %tmp35.clone.i
  %tmp39.clone.i45 = load double* %tmp37.clone.i43, align 8, !tbaa !2
  %tmp40.clone.i46 = load double* %tmp32.clone.moved.to.bb34.clone.i, align 8, !tbaa !2
  %tmp41.clone.i = load double* %tmp36.clone.i, align 8, !tbaa !2
  %tmp42.clone.i47 = fmul double %tmp40.clone.i46, %tmp41.clone.i
  %tmp43.clone.i48 = fadd double %tmp39.clone.i45, %tmp42.clone.i47
  store double %tmp43.clone.i48, double* %tmp37.clone.i43, align 8, !tbaa !2, !llvm.loop !19
  %tmp44.clone.i = load double* %tmp31.clone.i41, align 8, !tbaa !2
  %tmp45.clone.i49 = load double* %tmp36.clone.i, align 8, !tbaa !2
  %tmp46.clone.i = load double* %tmp38.clone.i44, align 8, !tbaa !2
  %tmp47.clone.i50 = fmul double %tmp45.clone.i49, %tmp46.clone.i
  %tmp48.clone.i = fadd double %tmp44.clone.i, %tmp47.clone.i50
  store double %tmp48.clone.i, double* %tmp31.clone.i41, align 8, !tbaa !2, !llvm.loop !23
  %tmp49.clone.i51 = add i64 %tmp35.clone.i, 1
  %tmp50.clone.i52 = icmp eq i64 %tmp49.clone.i51, 4000
  br i1 %tmp50.clone.i52, label %bb51.clone.i, label %bb34.clone.i, !llvm.loop !24

bb51.clone.i:                                     ; preds = %bb34.clone.i
  %tmp52.clone.i = add i64 %tmp30.clone.i40, 1
  %tmp53.clone.i = icmp eq i64 %tmp52.clone.i, 4000
  br i1 %tmp53.clone.i, label %kernel_bicg.exit.loopexit, label %bb29.clone.i42, !llvm.loop !25

bb29.i56:                                         ; preds = %bb51.i, %bb29.i56.preheader
  %tmp30.i53 = phi i64 [ %tmp52.i73, %bb51.i ], [ 0, %bb29.i56.preheader ]
  %tmp31.i54 = getelementptr double* %tmp10, i64 %tmp30.i53
  %tmp32.i55 = getelementptr double* %tmp6, i64 %tmp30.i53
  store double 0.000000e+00, double* %tmp31.i54, align 8, !tbaa !2, !llvm.loop !10
  br label %bb34.i72

bb34.i72:                                         ; preds = %bb34.i72, %bb29.i56
  %tmp35.i57 = phi i64 [ %tmp49.i70, %bb34.i72 ], [ 0, %bb29.i56 ]
  %tmp36.i58 = getelementptr [4000 x double]* %tmp5, i64 %tmp30.i53, i64 %tmp35.i57
  %tmp37.i59 = getelementptr double* %tmp9, i64 %tmp35.i57
  %tmp38.i60 = getelementptr double* %tmp7, i64 %tmp35.i57
  %tmp39.i61 = load double* %tmp37.i59, align 8, !tbaa !2
  %tmp40.i62 = load double* %tmp32.i55, align 8, !tbaa !2
  %tmp41.i63 = load double* %tmp36.i58, align 8, !tbaa !2
  %tmp42.i64 = fmul double %tmp40.i62, %tmp41.i63
  %tmp43.i65 = fadd double %tmp39.i61, %tmp42.i64
  store double %tmp43.i65, double* %tmp37.i59, align 8, !tbaa !2, !llvm.loop !19
  %tmp44.i66 = load double* %tmp31.i54, align 8, !tbaa !2
  %tmp45.i67 = load double* %tmp36.i58, align 8, !tbaa !2
  %tmp46.i = load double* %tmp38.i60, align 8, !tbaa !2
  %tmp47.i68 = fmul double %tmp45.i67, %tmp46.i
  %tmp48.i69 = fadd double %tmp44.i66, %tmp47.i68
  store double %tmp48.i69, double* %tmp31.i54, align 8, !tbaa !2, !llvm.loop !23
  %tmp49.i70 = add i64 %tmp35.i57, 1
  %tmp50.i71 = icmp eq i64 %tmp49.i70, 4000
  br i1 %tmp50.i71, label %bb51.i, label %bb34.i72, !llvm.loop !24

bb51.i:                                           ; preds = %bb34.i72
  %tmp52.i73 = add i64 %tmp30.i53, 1
  %tmp53.i = icmp eq i64 %tmp52.i73, 4000
  br i1 %tmp53.i, label %kernel_bicg.exit.loopexit117, label %bb29.i56, !llvm.loop !25

kernel_bicg.exit.loopexit:                        ; preds = %bb51.clone.i
  br label %kernel_bicg.exit

kernel_bicg.exit.loopexit117:                     ; preds = %bb51.i
  br label %kernel_bicg.exit

kernel_bicg.exit:                                 ; preds = %kernel_bicg.exit.loopexit117, %kernel_bicg.exit.loopexit
  %tmp13 = icmp sgt i32 %argc, 42
  br i1 %tmp13, label %bb14, label %bb21, !llvm.loop !12

bb14:                                             ; preds = %kernel_bicg.exit
  %tmp15 = load i8** %argv, align 8, !tbaa !14
  %tmp16 = load i8* %tmp15, align 1
  %tmp17 = icmp eq i8 %tmp16, 0
  br i1 %tmp17, label %bb22.i.preheader, label %bb21, !llvm.loop !6

bb22.i.preheader:                                 ; preds = %bb14
  br label %bb22.i

.preheader.i22:                                   ; preds = %bb34.i
  %tmp20.i = load %struct.__sFILE** @__stderrp, align 8, !tbaa !14
  br label %bb37.i, !llvm.loop !9

bb22.i:                                           ; preds = %bb34.i, %bb22.i.preheader
  %tmp23.i23 = phi i64 [ %tmp35.i, %bb34.i ], [ 0, %bb22.i.preheader ]
  %tmp24.i24 = trunc i64 %tmp23.i23 to i32
  %tmp25.i25 = getelementptr double* %tmp9, i64 %tmp23.i23
  %tmp26.i26 = load %struct.__sFILE** @__stderrp, align 8, !tbaa !14
  %tmp27.i27 = load double* %tmp25.i25, align 8, !tbaa !2
  %tmp28.i28 = tail call i32 (%struct.__sFILE*, i8*, ...)* @fprintf(%struct.__sFILE* %tmp26.i26, i8* getelementptr inbounds ([8 x i8]* @.str11, i64 0, i64 0), double %tmp27.i27) #4
  %tmp29.i = srem i32 %tmp24.i24, 20
  %tmp30.i29 = icmp eq i32 %tmp29.i, 0
  br i1 %tmp30.i29, label %bb31.i, label %bb34.i, !llvm.loop !10

bb31.i:                                           ; preds = %bb22.i
  %tmp32.i30 = load %struct.__sFILE** @__stderrp, align 8, !tbaa !14
  %tmp33.i31 = tail call i32 @fputc(i32 10, %struct.__sFILE* %tmp32.i30) #4
  br label %bb34.i, !llvm.loop !11

bb34.i:                                           ; preds = %bb31.i, %bb22.i
  %tmp35.i = add i64 %tmp23.i23, 1
  %tmp36.i = icmp eq i64 %tmp35.i, 4000
  br i1 %tmp36.i, label %.preheader.i22, label %bb22.i, !llvm.loop !26

bb37.i:                                           ; preds = %bb49.i, %.preheader.i22
  %tmp.0.i = phi %struct.__sFILE* [ %tmp20.i, %.preheader.i22 ], [ %tmp50.i38, %bb49.i ]
  %tmp38.i32 = phi i64 [ 0, %.preheader.i22 ], [ %tmp51.i, %bb49.i ]
  %tmp40.i33 = trunc i64 %tmp38.i32 to i32
  %tmp41.i = getelementptr double* %tmp10, i64 %tmp38.i32
  %tmp42.i34 = load double* %tmp41.i, align 8, !tbaa !2
  %tmp43.i35 = tail call i32 (%struct.__sFILE*, i8*, ...)* @fprintf(%struct.__sFILE* %tmp.0.i, i8* getelementptr inbounds ([8 x i8]* @.str11, i64 0, i64 0), double %tmp42.i34) #4
  %tmp44.i = srem i32 %tmp40.i33, 20
  %tmp45.i36 = icmp eq i32 %tmp44.i, 0
  br i1 %tmp45.i36, label %bb46.i, label %bb49.i, !llvm.loop !19

bb46.i:                                           ; preds = %bb37.i
  %tmp47.i37 = load %struct.__sFILE** @__stderrp, align 8, !tbaa !14
  %tmp48.i = tail call i32 @fputc(i32 10, %struct.__sFILE* %tmp47.i37) #4
  br label %bb49.i, !llvm.loop !23

bb49.i:                                           ; preds = %bb46.i, %bb37.i
  %tmp50.i38 = load %struct.__sFILE** @__stderrp, align 8, !tbaa !14
  %tmp51.i = add i64 %tmp38.i32, 1
  %tmp52.i = icmp eq i64 %tmp51.i, 4000
  br i1 %tmp52.i, label %print_array.exit, label %bb37.i, !llvm.loop !21

print_array.exit:                                 ; preds = %bb49.i
  %tmp50.i38.lcssa = phi %struct.__sFILE* [ %tmp50.i38, %bb49.i ]
  %tmp56.i = tail call i32 @fputc(i32 10, %struct.__sFILE* %tmp50.i38.lcssa) #4
  br label %bb21, !llvm.loop !8

bb21:                                             ; preds = %print_array.exit, %bb14, %kernel_bicg.exit
  tail call void @free(i8* %tmp), !llvm.loop !9
  tail call void @free(i8* %tmp1), !llvm.loop !10
  tail call void @free(i8* %tmp2), !llvm.loop !11
  tail call void @free(i8* %tmp3), !llvm.loop !26
  tail call void @free(i8* %tmp4), !llvm.loop !19
  ret i32 0, !llvm.loop !23
}

; Function Attrs: nounwind
declare i32 @fprintf(%struct.__sFILE* nocapture, i8* nocapture readonly, ...) #1

; Function Attrs: nounwind
declare i32 @fputc(i32, %struct.__sFILE* nocapture) #4

; Function Attrs: nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i32, i1) #4

attributes #0 = { nounwind ssp uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { noreturn "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }
attributes #5 = { noreturn nounwind }

!llvm.ident = !{!0, !0}

!0 = metadata !{metadata !"clang version 3.6.0 (trunk 217066) (llvm/trunk 217065)"}
!1 = metadata !{metadata !"void3"}
!2 = metadata !{metadata !3, metadata !3, i64 0}
!3 = metadata !{metadata !"double", metadata !4, i64 0}
!4 = metadata !{metadata !"omnipotent char", metadata !5, i64 0}
!5 = metadata !{metadata !"Simple C/C++ TBAA"}
!6 = metadata !{metadata !"void5"}
!7 = metadata !{metadata !"void6"}
!8 = metadata !{metadata !"void7"}
!9 = metadata !{metadata !"void8"}
!10 = metadata !{metadata !"void9"}
!11 = metadata !{metadata !"void10"}
!12 = metadata !{metadata !"void4"}
!13 = metadata !{metadata !"void2"}
!14 = metadata !{metadata !15, metadata !15, i64 0}
!15 = metadata !{metadata !"any pointer", metadata !4, i64 0}
!16 = metadata !{metadata !16, metadata !17, metadata !18}
!17 = metadata !{metadata !"llvm.loop.vectorize.width", i32 1}
!18 = metadata !{metadata !"llvm.loop.interleave.count", i32 1}
!19 = metadata !{metadata !"void12"}
!20 = metadata !{metadata !20, metadata !17, metadata !18}
!21 = metadata !{metadata !"void15"}
!22 = metadata !{metadata !22, metadata !17, metadata !18}
!23 = metadata !{metadata !"void13"}
!24 = metadata !{metadata !"void14"}
!25 = metadata !{metadata !"void16"}
!26 = metadata !{metadata !"void11"}
