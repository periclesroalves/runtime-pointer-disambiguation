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
  %tmp = alloca double, align 8
  %tmp1 = alloca double, align 8
  %tmp2 = tail call i8* @polybench_alloc_data(i64 16000000, i32 8) #4
  %tmp3 = tail call i8* @polybench_alloc_data(i64 16000000, i32 8) #4
  %tmp4 = tail call i8* @polybench_alloc_data(i64 4000, i32 8) #4
  %tmp5 = tail call i8* @polybench_alloc_data(i64 4000, i32 8) #4
  %tmp6 = tail call i8* @polybench_alloc_data(i64 4000, i32 8) #4
  %tmp7 = bitcast i8* %tmp2 to [4000 x double]*
  %tmp8 = bitcast i8* %tmp3 to [4000 x double]*
  %tmp9 = bitcast i8* %tmp5 to double*
  %beta45.i = bitcast double* %tmp1 to i8*
  %alpha53.i = bitcast double* %tmp to i8*
  %x50.i = ptrtoint i8* %tmp5 to i64
  %B47.i = ptrtoint i8* %tmp3 to i64
  %A44.i = ptrtoint i8* %tmp2 to i64
  %0 = add i64 %A44.i, 127999992
  %1 = inttoptr i64 %0 to i8*
  %2 = bitcast i8* %tmp2 to double*
  %3 = icmp ugt double* %2, %tmp1
  %4 = icmp ult i8* %1, %beta45.i
  %no-dyn-alias.i = or i1 %3, %4
  %5 = add i64 %B47.i, 127999992
  %6 = inttoptr i64 %5 to i8*
  %7 = bitcast i8* %tmp3 to double*
  %8 = icmp ugt double* %7, %tmp1
  %9 = icmp ult i8* %6, %beta45.i
  %no-dyn-alias49.i = or i1 %8, %9
  %10 = add i64 %x50.i, 31992
  %11 = inttoptr i64 %10 to i8*
  %12 = icmp ult double* %tmp1, %tmp9
  %13 = icmp ult i8* %11, %beta45.i
  %no-dyn-alias52.i = or i1 %12, %13
  %14 = icmp ult i8* %1, %tmp3
  %15 = icmp ult i8* %6, %tmp2
  %no-dyn-alias55.i = or i1 %14, %15
  %16 = icmp ult i8* %1, %tmp5
  %17 = icmp ult i8* %11, %tmp2
  %no-dyn-alias56.i = or i1 %16, %17
  %18 = icmp ult i8* %1, %alpha53.i
  %19 = icmp ugt double* %2, %tmp
  %no-dyn-alias57.i = or i1 %18, %19
  %20 = icmp ult i8* %6, %tmp5
  %21 = icmp ult i8* %11, %tmp3
  %no-dyn-alias58.i = or i1 %20, %21
  %22 = icmp ult i8* %6, %alpha53.i
  %23 = icmp ugt double* %7, %tmp
  %no-dyn-alias59.i = or i1 %22, %23
  %24 = icmp ult i8* %11, %alpha53.i
  %25 = icmp ult double* %tmp, %tmp9
  %no-dyn-alias60.i = or i1 %24, %25
  %no-dyn-alias61.i = and i1 %no-dyn-alias49.i, %no-dyn-alias.i
  %no-dyn-alias62.i = and i1 %no-dyn-alias52.i, %no-dyn-alias61.i
  %no-dyn-alias64.i = and i1 %no-dyn-alias55.i, %no-dyn-alias62.i
  %no-dyn-alias65.i = and i1 %no-dyn-alias56.i, %no-dyn-alias64.i
  %no-dyn-alias66.i = and i1 %no-dyn-alias57.i, %no-dyn-alias65.i
  %no-dyn-alias67.i = and i1 %no-dyn-alias58.i, %no-dyn-alias66.i
  %no-dyn-alias68.i = and i1 %no-dyn-alias59.i, %no-dyn-alias67.i
  %no-dyn-alias69.i = and i1 %no-dyn-alias60.i, %no-dyn-alias68.i
  store double 4.353200e+04, double* %tmp, align 8, !tbaa !2
  store double 1.231300e+04, double* %tmp1, align 8, !tbaa !2
  br i1 %no-dyn-alias69.i, label %bb15.clone.i.preheader, label %bb15.i.preheader

bb15.i.preheader:                                 ; preds = %bb
  br label %bb15.i

bb15.clone.i.preheader:                           ; preds = %bb
  br label %bb15.clone.i

bb15.clone.i:                                     ; preds = %bb40.clone.i, %bb15.clone.i.preheader
  %tmp16.clone.i = phi i64 [ %tmp41.clone.i, %bb40.clone.i ], [ 0, %bb15.clone.i.preheader ]
  %tmp17.clone.i = trunc i64 %tmp16.clone.i to i32
  %tmp18.clone.i = getelementptr double* %tmp9, i64 %tmp16.clone.i
  %tmp19.clone.i = sitofp i32 %tmp17.clone.i to double
  %tmp21.clone.i = fdiv double %tmp19.clone.i, 4.000000e+03
  store double %tmp21.clone.i, double* %tmp18.clone.i, align 8, !tbaa !2, !llvm.loop !7
  br label %bb23.clone.i

bb23.clone.i:                                     ; preds = %bb23.clone.i, %bb15.clone.i
  %tmp24.clone.i = phi i64 [ 0, %bb15.clone.i ], [ %tmp38.clone.i.1, %bb23.clone.i ]
  %tmp25.clone.i = getelementptr [4000 x double]* %tmp8, i64 %tmp16.clone.i, i64 %tmp24.clone.i
  %tmp26.clone.i = getelementptr [4000 x double]* %tmp7, i64 %tmp16.clone.i, i64 %tmp24.clone.i
  %tmp27.clone.i = trunc i64 %tmp24.clone.i to i32
  %tmp29.clone.i = sitofp i32 %tmp27.clone.i to double
  %tmp30.clone.i = fmul double %tmp19.clone.i, %tmp29.clone.i
  %tmp32.clone.i = fdiv double %tmp30.clone.i, 4.000000e+03
  store double %tmp32.clone.i, double* %tmp26.clone.i, align 8, !tbaa !2, !llvm.loop !10
  store double %tmp32.clone.i, double* %tmp25.clone.i, align 8, !tbaa !2, !llvm.loop !11
  %tmp38.clone.i = add i64 %tmp24.clone.i, 1
  %tmp25.clone.i.1 = getelementptr [4000 x double]* %tmp8, i64 %tmp16.clone.i, i64 %tmp38.clone.i
  %tmp26.clone.i.1 = getelementptr [4000 x double]* %tmp7, i64 %tmp16.clone.i, i64 %tmp38.clone.i
  %tmp27.clone.i.1 = trunc i64 %tmp38.clone.i to i32
  %tmp29.clone.i.1 = sitofp i32 %tmp27.clone.i.1 to double
  %tmp30.clone.i.1 = fmul double %tmp19.clone.i, %tmp29.clone.i.1
  %tmp32.clone.i.1 = fdiv double %tmp30.clone.i.1, 4.000000e+03
  store double %tmp32.clone.i.1, double* %tmp26.clone.i.1, align 8, !tbaa !2, !llvm.loop !10
  store double %tmp32.clone.i.1, double* %tmp25.clone.i.1, align 8, !tbaa !2, !llvm.loop !11
  %tmp38.clone.i.1 = add i64 %tmp38.clone.i, 1
  %tmp39.clone.i.1 = icmp eq i64 %tmp38.clone.i.1, 4000
  br i1 %tmp39.clone.i.1, label %bb40.clone.i, label %bb23.clone.i, !llvm.loop !16

bb40.clone.i:                                     ; preds = %bb23.clone.i
  %tmp41.clone.i = add i64 %tmp16.clone.i, 1
  %tmp42.clone.i = icmp eq i64 %tmp41.clone.i, 4000
  br i1 %tmp42.clone.i, label %init_array.exit.loopexit, label %bb15.clone.i, !llvm.loop !17

bb15.i:                                           ; preds = %bb40.i, %bb15.i.preheader
  %tmp16.i = phi i64 [ %tmp41.i, %bb40.i ], [ 0, %bb15.i.preheader ]
  %tmp17.i = trunc i64 %tmp16.i to i32
  %tmp18.i = getelementptr double* %tmp9, i64 %tmp16.i
  %tmp19.i = sitofp i32 %tmp17.i to double
  %tmp21.i = fdiv double %tmp19.i, 4.000000e+03
  store double %tmp21.i, double* %tmp18.i, align 8, !tbaa !2, !llvm.loop !7
  br label %bb23.i

bb23.i:                                           ; preds = %bb23.i, %bb15.i
  %tmp24.i = phi i64 [ 0, %bb15.i ], [ %tmp38.i.1, %bb23.i ]
  %tmp25.i = getelementptr [4000 x double]* %tmp8, i64 %tmp16.i, i64 %tmp24.i
  %tmp26.i = getelementptr [4000 x double]* %tmp7, i64 %tmp16.i, i64 %tmp24.i
  %tmp27.i = trunc i64 %tmp24.i to i32
  %tmp29.i = sitofp i32 %tmp27.i to double
  %tmp30.i = fmul double %tmp19.i, %tmp29.i
  %tmp32.i = fdiv double %tmp30.i, 4.000000e+03
  store double %tmp32.i, double* %tmp26.i, align 8, !tbaa !2, !llvm.loop !10
  store double %tmp32.i, double* %tmp25.i, align 8, !tbaa !2, !llvm.loop !11
  %tmp38.i = add i64 %tmp24.i, 1
  %tmp25.i.1 = getelementptr [4000 x double]* %tmp8, i64 %tmp16.i, i64 %tmp38.i
  %tmp26.i.1 = getelementptr [4000 x double]* %tmp7, i64 %tmp16.i, i64 %tmp38.i
  %tmp27.i.1 = trunc i64 %tmp38.i to i32
  %tmp29.i.1 = sitofp i32 %tmp27.i.1 to double
  %tmp30.i.1 = fmul double %tmp19.i, %tmp29.i.1
  %tmp32.i.1 = fdiv double %tmp30.i.1, 4.000000e+03
  store double %tmp32.i.1, double* %tmp26.i.1, align 8, !tbaa !2, !llvm.loop !10
  store double %tmp32.i.1, double* %tmp25.i.1, align 8, !tbaa !2, !llvm.loop !11
  %tmp38.i.1 = add i64 %tmp38.i, 1
  %tmp39.i.1 = icmp eq i64 %tmp38.i.1, 4000
  br i1 %tmp39.i.1, label %bb40.i, label %bb23.i, !llvm.loop !16

bb40.i:                                           ; preds = %bb23.i
  %tmp41.i = add i64 %tmp16.i, 1
  %tmp42.i = icmp eq i64 %tmp41.i, 4000
  br i1 %tmp42.i, label %init_array.exit.loopexit74, label %bb15.i, !llvm.loop !17

init_array.exit.loopexit:                         ; preds = %bb40.clone.i
  br label %init_array.exit

init_array.exit.loopexit74:                       ; preds = %bb40.i
  br label %init_array.exit

init_array.exit:                                  ; preds = %init_array.exit.loopexit74, %init_array.exit.loopexit
  %tmp10 = load double* %tmp, align 8, !tbaa !2
  %tmp11 = load double* %tmp1, align 8, !tbaa !2
  %tmp14 = bitcast i8* %tmp4 to double*
  %tmp16 = bitcast i8* %tmp6 to double*
  %y59.i = ptrtoint i8* %tmp6 to i64
  %tmp53.i = ptrtoint i8* %tmp4 to i64
  %26 = add i64 %tmp53.i, 31992
  %27 = inttoptr i64 %26 to i8*
  %28 = icmp ult i8* %1, %tmp4
  %29 = icmp ult i8* %27, %tmp2
  %no-dyn-alias55.i29 = or i1 %28, %29
  %30 = add i64 %y59.i, 31992
  %31 = inttoptr i64 %30 to i8*
  %32 = icmp ult i8* %1, %tmp6
  %33 = icmp ult i8* %31, %tmp2
  %no-dyn-alias61.i31 = or i1 %32, %33
  %34 = icmp ult i8* %6, %tmp4
  %35 = icmp ult i8* %27, %tmp3
  %no-dyn-alias62.i32 = or i1 %34, %35
  %36 = icmp ult i8* %6, %tmp6
  %37 = icmp ult i8* %31, %tmp3
  %no-dyn-alias64.i33 = or i1 %36, %37
  %38 = icmp ult i8* %27, %tmp5
  %39 = icmp ult i8* %11, %tmp4
  %no-dyn-alias65.i34 = or i1 %38, %39
  %40 = icmp ult i8* %27, %tmp6
  %41 = icmp ult i8* %31, %tmp4
  %no-dyn-alias66.i35 = or i1 %40, %41
  %42 = icmp ult i8* %11, %tmp6
  %43 = icmp ult i8* %31, %tmp5
  %no-dyn-alias67.i36 = or i1 %42, %43
  %no-dyn-alias68.i37 = and i1 %no-dyn-alias55.i29, %no-dyn-alias55.i
  %no-dyn-alias69.i38 = and i1 %no-dyn-alias56.i, %no-dyn-alias68.i37
  %no-dyn-alias70.i = and i1 %no-dyn-alias61.i31, %no-dyn-alias69.i38
  %no-dyn-alias71.i = and i1 %no-dyn-alias62.i32, %no-dyn-alias70.i
  %no-dyn-alias72.i = and i1 %no-dyn-alias58.i, %no-dyn-alias71.i
  %no-dyn-alias73.i = and i1 %no-dyn-alias64.i33, %no-dyn-alias72.i
  %no-dyn-alias74.i = and i1 %no-dyn-alias65.i34, %no-dyn-alias73.i
  %no-dyn-alias75.i = and i1 %no-dyn-alias66.i35, %no-dyn-alias74.i
  %no-dyn-alias76.i = and i1 %no-dyn-alias67.i36, %no-dyn-alias75.i
  br i1 %no-dyn-alias76.i, label %bb18.clone.i.preheader, label %bb18.i.preheader

bb18.i.preheader:                                 ; preds = %init_array.exit
  br label %bb18.i

bb18.clone.i.preheader:                           ; preds = %init_array.exit
  br label %bb18.clone.i

bb18.clone.i:                                     ; preds = %bb40.clone.i53, %bb18.clone.i.preheader
  %tmp19.clone.i39 = phi i64 [ %tmp46.clone.i, %bb40.clone.i53 ], [ 0, %bb18.clone.i.preheader ]
  %tmp20.clone.i = getelementptr double* %tmp14, i64 %tmp19.clone.i39
  %tmp21.clone.i40 = getelementptr double* %tmp16, i64 %tmp19.clone.i39
  store double 0.000000e+00, double* %tmp20.clone.i, align 8, !tbaa !2, !llvm.loop !12
  store double 0.000000e+00, double* %tmp21.clone.i40, align 8, !tbaa !2, !llvm.loop !6
  br label %bb23.clone.i50

bb23.clone.i50:                                   ; preds = %bb23.clone.i50, %bb18.clone.i
  %tmp24.clone.i41 = phi i64 [ %tmp38.clone.i48, %bb23.clone.i50 ], [ 0, %bb18.clone.i ]
  %tmp25.clone.i42 = getelementptr [4000 x double]* %tmp8, i64 %tmp19.clone.i39, i64 %tmp24.clone.i41
  %tmp26.clone.i43 = getelementptr [4000 x double]* %tmp7, i64 %tmp19.clone.i39, i64 %tmp24.clone.i41
  %tmp27.clone.i44 = getelementptr double* %tmp9, i64 %tmp24.clone.i41
  %tmp28.clone.i = load double* %tmp26.clone.i43, align 8, !tbaa !2
  %tmp29.clone.i45 = load double* %tmp27.clone.i44, align 8, !tbaa !2
  %tmp30.clone.i46 = fmul double %tmp28.clone.i, %tmp29.clone.i45
  %tmp31.clone.i = load double* %tmp20.clone.i, align 8, !tbaa !2
  %tmp32.clone.i47 = fadd double %tmp30.clone.i46, %tmp31.clone.i
  store double %tmp32.clone.i47, double* %tmp20.clone.i, align 8, !tbaa !2, !llvm.loop !9
  %tmp33.clone.i = load double* %tmp25.clone.i42, align 8, !tbaa !2
  %tmp34.clone.i = load double* %tmp27.clone.i44, align 8, !tbaa !2
  %tmp35.clone.i = fmul double %tmp33.clone.i, %tmp34.clone.i
  %tmp36.clone.i = load double* %tmp21.clone.i40, align 8, !tbaa !2
  %tmp37.clone.i = fadd double %tmp35.clone.i, %tmp36.clone.i
  store double %tmp37.clone.i, double* %tmp21.clone.i40, align 8, !tbaa !2, !llvm.loop !10
  %tmp38.clone.i48 = add i64 %tmp24.clone.i41, 1
  %tmp39.clone.i49 = icmp eq i64 %tmp38.clone.i48, 4000
  br i1 %tmp39.clone.i49, label %bb40.clone.i53, label %bb23.clone.i50, !llvm.loop !11

bb40.clone.i53:                                   ; preds = %bb23.clone.i50
  %tmp37.clone.i.lcssa = phi double [ %tmp37.clone.i, %bb23.clone.i50 ]
  %tmp41.clone.i51 = load double* %tmp20.clone.i, align 8, !tbaa !2
  %tmp42.clone.i52 = fmul double %tmp10, %tmp41.clone.i51
  %tmp44.clone.i = fmul double %tmp11, %tmp37.clone.i.lcssa
  %tmp45.clone.i = fadd double %tmp44.clone.i, %tmp42.clone.i52
  store double %tmp45.clone.i, double* %tmp21.clone.i40, align 8, !tbaa !2, !llvm.loop !18
  %tmp46.clone.i = add i64 %tmp19.clone.i39, 1
  %tmp47.clone.i = icmp eq i64 %tmp46.clone.i, 4000
  br i1 %tmp47.clone.i, label %kernel_gesummv.exit.loopexit, label %bb18.clone.i, !llvm.loop !17

bb18.i:                                           ; preds = %bb40.i68, %bb18.i.preheader
  %tmp19.i54 = phi i64 [ %tmp46.i, %bb40.i68 ], [ 0, %bb18.i.preheader ]
  %tmp20.i = getelementptr double* %tmp14, i64 %tmp19.i54
  %tmp21.i55 = getelementptr double* %tmp16, i64 %tmp19.i54
  store double 0.000000e+00, double* %tmp20.i, align 8, !tbaa !2, !llvm.loop !12
  store double 0.000000e+00, double* %tmp21.i55, align 8, !tbaa !2, !llvm.loop !6
  br label %bb23.i65

bb23.i65:                                         ; preds = %bb23.i65, %bb18.i
  %tmp24.i56 = phi i64 [ %tmp38.i63, %bb23.i65 ], [ 0, %bb18.i ]
  %tmp25.i57 = getelementptr [4000 x double]* %tmp8, i64 %tmp19.i54, i64 %tmp24.i56
  %tmp26.i58 = getelementptr [4000 x double]* %tmp7, i64 %tmp19.i54, i64 %tmp24.i56
  %tmp27.i59 = getelementptr double* %tmp9, i64 %tmp24.i56
  %tmp28.i = load double* %tmp26.i58, align 8, !tbaa !2
  %tmp29.i60 = load double* %tmp27.i59, align 8, !tbaa !2
  %tmp30.i61 = fmul double %tmp28.i, %tmp29.i60
  %tmp31.i = load double* %tmp20.i, align 8, !tbaa !2
  %tmp32.i62 = fadd double %tmp30.i61, %tmp31.i
  store double %tmp32.i62, double* %tmp20.i, align 8, !tbaa !2, !llvm.loop !9
  %tmp33.i = load double* %tmp25.i57, align 8, !tbaa !2
  %tmp34.i = load double* %tmp27.i59, align 8, !tbaa !2
  %tmp35.i = fmul double %tmp33.i, %tmp34.i
  %tmp36.i = load double* %tmp21.i55, align 8, !tbaa !2
  %tmp37.i = fadd double %tmp35.i, %tmp36.i
  store double %tmp37.i, double* %tmp21.i55, align 8, !tbaa !2, !llvm.loop !10
  %tmp38.i63 = add i64 %tmp24.i56, 1
  %tmp39.i64 = icmp eq i64 %tmp38.i63, 4000
  br i1 %tmp39.i64, label %bb40.i68, label %bb23.i65, !llvm.loop !11

bb40.i68:                                         ; preds = %bb23.i65
  %tmp37.i.lcssa = phi double [ %tmp37.i, %bb23.i65 ]
  %tmp41.i66 = load double* %tmp20.i, align 8, !tbaa !2
  %tmp42.i67 = fmul double %tmp10, %tmp41.i66
  %tmp44.i = fmul double %tmp11, %tmp37.i.lcssa
  %tmp45.i = fadd double %tmp44.i, %tmp42.i67
  store double %tmp45.i, double* %tmp21.i55, align 8, !tbaa !2, !llvm.loop !18
  %tmp46.i = add i64 %tmp19.i54, 1
  %tmp47.i = icmp eq i64 %tmp46.i, 4000
  br i1 %tmp47.i, label %kernel_gesummv.exit.loopexit73, label %bb18.i, !llvm.loop !17

kernel_gesummv.exit.loopexit:                     ; preds = %bb40.clone.i53
  br label %kernel_gesummv.exit

kernel_gesummv.exit.loopexit73:                   ; preds = %bb40.i68
  br label %kernel_gesummv.exit

kernel_gesummv.exit:                              ; preds = %kernel_gesummv.exit.loopexit73, %kernel_gesummv.exit.loopexit
  %tmp17 = icmp sgt i32 %argc, 42
  br i1 %tmp17, label %bb18, label %bb24, !llvm.loop !12

bb18:                                             ; preds = %kernel_gesummv.exit
  %tmp19 = load i8** %argv, align 8, !tbaa !14
  %tmp20 = load i8* %tmp19, align 1
  %tmp21 = icmp eq i8 %tmp20, 0
  br i1 %tmp21, label %bb3.i.preheader, label %bb24, !llvm.loop !6

bb3.i.preheader:                                  ; preds = %bb18
  br label %bb3.i

bb3.i:                                            ; preds = %bb15.i27, %bb3.i.preheader
  %tmp4.i = phi i64 [ %tmp16.i25, %bb15.i27 ], [ 0, %bb3.i.preheader ]
  %tmp5.i = trunc i64 %tmp4.i to i32
  %tmp6.i = getelementptr double* %tmp16, i64 %tmp4.i
  %tmp7.i = load %struct.__sFILE** @__stderrp, align 8, !tbaa !14
  %tmp8.i = load double* %tmp6.i, align 8, !tbaa !2
  %tmp9.i = call i32 (%struct.__sFILE*, i8*, ...)* @fprintf(%struct.__sFILE* %tmp7.i, i8* getelementptr inbounds ([8 x i8]* @.str11, i64 0, i64 0), double %tmp8.i) #4
  %tmp10.i = srem i32 %tmp5.i, 20
  %tmp11.i = icmp eq i32 %tmp10.i, 0
  br i1 %tmp11.i, label %bb12.i, label %bb15.i27, !llvm.loop !12

bb12.i:                                           ; preds = %bb3.i
  %tmp13.i = load %struct.__sFILE** @__stderrp, align 8, !tbaa !14
  %tmp14.i = call i32 @fputc(i32 10, %struct.__sFILE* %tmp13.i) #4
  br label %bb15.i27, !llvm.loop !6

bb15.i27:                                         ; preds = %bb12.i, %bb3.i
  %tmp16.i25 = add i64 %tmp4.i, 1
  %tmp17.i26 = icmp eq i64 %tmp16.i25, 4000
  br i1 %tmp17.i26, label %bb24.loopexit, label %bb3.i, !llvm.loop !7

bb24.loopexit:                                    ; preds = %bb15.i27
  br label %bb24

bb24:                                             ; preds = %bb24.loopexit, %bb18, %kernel_gesummv.exit
  call void @free(i8* %tmp2), !llvm.loop !9
  call void @free(i8* %tmp3), !llvm.loop !10
  call void @free(i8* %tmp4), !llvm.loop !11
  call void @free(i8* %tmp5), !llvm.loop !16
  call void @free(i8* %tmp6), !llvm.loop !18
  ret i32 0, !llvm.loop !17
}

; Function Attrs: nounwind
declare i32 @fprintf(%struct.__sFILE* nocapture, i8* nocapture readonly, ...) #1

; Function Attrs: nounwind
declare i32 @fputc(i32, %struct.__sFILE* nocapture) #4

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
!16 = metadata !{metadata !"void11"}
!17 = metadata !{metadata !"void13"}
!18 = metadata !{metadata !"void12"}
