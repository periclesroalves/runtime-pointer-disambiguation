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
  %tmp = tail call i8* @polybench_alloc_data(i64 1048576, i32 8) #4
  %tmp1 = tail call i8* @polybench_alloc_data(i64 1048576, i32 8) #4
  %tmp2 = tail call i8* @polybench_alloc_data(i64 1048576, i32 8) #4
  %tmp3 = tail call i8* @polybench_alloc_data(i64 1048576, i32 8) #4
  %tmp4 = tail call i8* @polybench_alloc_data(i64 1048576, i32 8) #4
  %tmp5 = tail call i8* @polybench_alloc_data(i64 1048576, i32 8) #4
  %tmp6 = tail call i8* @polybench_alloc_data(i64 1048576, i32 8) #4
  %tmp7 = bitcast i8* %tmp1 to [1024 x double]*
  %tmp9 = bitcast i8* %tmp4 to [1024 x double]*
  br label %.preheader6.i

.preheader6.i:                                    ; preds = %bb69.i, %bb
  %tmp52.i = phi i64 [ %tmp70.i, %bb69.i ], [ 0, %bb ]
  %tmp53.moved.to.bb58.i = trunc i64 %tmp52.i to i32
  %tmp62.i = sitofp i32 %tmp53.moved.to.bb58.i to double
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %.preheader6.i
  %index = phi i64 [ 0, %.preheader6.i ], [ %index.next, %vector.body ]
  %induction59110 = or i64 %index, 1
  %0 = getelementptr [1024 x double]* %tmp7, i64 %tmp52.i, i64 %index
  %1 = getelementptr [1024 x double]* %tmp7, i64 %tmp52.i, i64 %induction59110
  %2 = trunc i64 %index to i32
  %induction61111 = or i32 %2, 1
  %3 = sitofp i32 %2 to double
  %4 = sitofp i32 %induction61111 to double
  %5 = fmul double %tmp62.i, %3
  %6 = fmul double %tmp62.i, %4
  %7 = fmul double %5, 9.765625e-04
  %8 = fmul double %6, 9.765625e-04
  store double %7, double* %0, align 8, !tbaa !2, !llvm.loop !10
  store double %8, double* %1, align 8, !tbaa !2, !llvm.loop !10
  %index.next = add i64 %index, 2
  %9 = icmp eq i64 %index.next, 1024
  br i1 %9, label %bb69.i, label %vector.body, !llvm.loop !16

bb69.i:                                           ; preds = %vector.body
  %tmp70.i = add i64 %tmp52.i, 1
  %tmp71.i = icmp eq i64 %tmp70.i, 1024
  br i1 %tmp71.i, label %.preheader4.i.preheader, label %.preheader6.i, !llvm.loop !19

.preheader4.i.preheader:                          ; preds = %bb69.i
  %tmp8 = bitcast i8* %tmp2 to [1024 x double]*
  %tmp10 = bitcast i8* %tmp5 to [1024 x double]*
  br label %.preheader4.i

.preheader4.i:                                    ; preds = %bb90.i, %.preheader4.i.preheader
  %tmp72.i = phi i64 [ %tmp91.i, %bb90.i ], [ 0, %.preheader4.i.preheader ]
  %tmp73.moved.to.bb78.i = trunc i64 %tmp72.i to i32
  %tmp83.i = sitofp i32 %tmp73.moved.to.bb78.i to double
  br label %vector.body65

vector.body65:                                    ; preds = %vector.body65, %.preheader4.i
  %index68 = phi i64 [ 0, %.preheader4.i ], [ %index.next75, %vector.body65 ]
  %induction77112 = or i64 %index68, 1
  %10 = getelementptr [1024 x double]* %tmp8, i64 %tmp72.i, i64 %index68
  %11 = getelementptr [1024 x double]* %tmp8, i64 %tmp72.i, i64 %induction77112
  %12 = or i64 %index68, 1
  %13 = add i64 %induction77112, 1
  %14 = trunc i64 %12 to i32
  %15 = trunc i64 %13 to i32
  %16 = sitofp i32 %14 to double
  %17 = sitofp i32 %15 to double
  %18 = fmul double %tmp83.i, %16
  %19 = fmul double %tmp83.i, %17
  %20 = fmul double %18, 9.765625e-04
  %21 = fmul double %19, 9.765625e-04
  store double %20, double* %10, align 8, !tbaa !2, !llvm.loop !20
  store double %21, double* %11, align 8, !tbaa !2, !llvm.loop !20
  %index.next75 = add i64 %index68, 2
  %22 = icmp eq i64 %index.next75, 1024
  br i1 %22, label %bb90.i, label %vector.body65, !llvm.loop !21

bb90.i:                                           ; preds = %vector.body65
  %tmp91.i = add i64 %tmp72.i, 1
  %tmp92.i = icmp eq i64 %tmp91.i, 1024
  br i1 %tmp92.i, label %.preheader2.i.preheader, label %.preheader4.i, !llvm.loop !22

.preheader2.i.preheader:                          ; preds = %bb90.i
  br label %.preheader2.i

.preheader2.i:                                    ; preds = %bb111.i, %.preheader2.i.preheader
  %tmp93.i = phi i64 [ %tmp112.i, %bb111.i ], [ 0, %.preheader2.i.preheader ]
  %tmp94.moved.to.bb99.i = trunc i64 %tmp93.i to i32
  %tmp104.i = sitofp i32 %tmp94.moved.to.bb99.i to double
  br label %vector.body81

vector.body81:                                    ; preds = %vector.body81, %.preheader2.i
  %index84 = phi i64 [ 0, %.preheader2.i ], [ %index.next91, %vector.body81 ]
  %induction93113 = or i64 %index84, 1
  %23 = getelementptr [1024 x double]* %tmp9, i64 %tmp93.i, i64 %index84
  %24 = getelementptr [1024 x double]* %tmp9, i64 %tmp93.i, i64 %induction93113
  %25 = add i64 %index84, 3
  %26 = add i64 %induction93113, 3
  %27 = trunc i64 %25 to i32
  %28 = trunc i64 %26 to i32
  %29 = sitofp i32 %27 to double
  %30 = sitofp i32 %28 to double
  %31 = fmul double %tmp104.i, %29
  %32 = fmul double %tmp104.i, %30
  %33 = fmul double %31, 9.765625e-04
  %34 = fmul double %32, 9.765625e-04
  store double %33, double* %23, align 8, !tbaa !2, !llvm.loop !23
  store double %34, double* %24, align 8, !tbaa !2, !llvm.loop !23
  %index.next91 = add i64 %index84, 2
  %35 = icmp eq i64 %index.next91, 1024
  br i1 %35, label %bb111.i, label %vector.body81, !llvm.loop !24

bb111.i:                                          ; preds = %vector.body81
  %tmp112.i = add i64 %tmp93.i, 1
  %tmp113.i = icmp eq i64 %tmp112.i, 1024
  br i1 %tmp113.i, label %.preheader.i.preheader, label %.preheader2.i, !llvm.loop !25

.preheader.i.preheader:                           ; preds = %bb111.i
  br label %.preheader.i

.preheader.i:                                     ; preds = %bb129.i, %.preheader.i.preheader
  %tmp114.i = phi i64 [ %tmp130.i, %bb129.i ], [ 0, %.preheader.i.preheader ]
  %tmp115.moved.to.bb117.i = trunc i64 %tmp114.i to i32
  %tmp122.i = sitofp i32 %tmp115.moved.to.bb117.i to double
  br label %vector.body97

vector.body97:                                    ; preds = %vector.body97, %.preheader.i
  %index100 = phi i64 [ 0, %.preheader.i ], [ %index.next107, %vector.body97 ]
  %induction109114 = or i64 %index100, 1
  %36 = getelementptr [1024 x double]* %tmp10, i64 %tmp114.i, i64 %index100
  %37 = getelementptr [1024 x double]* %tmp10, i64 %tmp114.i, i64 %induction109114
  %38 = add i64 %index100, 2
  %39 = add i64 %induction109114, 2
  %40 = trunc i64 %38 to i32
  %41 = trunc i64 %39 to i32
  %42 = sitofp i32 %40 to double
  %43 = sitofp i32 %41 to double
  %44 = fmul double %tmp122.i, %42
  %45 = fmul double %tmp122.i, %43
  %46 = fmul double %44, 9.765625e-04
  %47 = fmul double %45, 9.765625e-04
  store double %46, double* %36, align 8, !tbaa !2, !llvm.loop !26
  store double %47, double* %37, align 8, !tbaa !2, !llvm.loop !26
  %index.next107 = add i64 %index100, 2
  %48 = icmp eq i64 %index.next107, 1024
  br i1 %48, label %bb129.i, label %vector.body97, !llvm.loop !27

bb129.i:                                          ; preds = %vector.body97
  %tmp130.i = add i64 %tmp114.i, 1
  %tmp131.i = icmp eq i64 %tmp130.i, 1024
  br i1 %tmp131.i, label %init_array.exit, label %.preheader.i, !llvm.loop !28

init_array.exit:                                  ; preds = %bb129.i
  %tmp11 = bitcast i8* %tmp to [1024 x double]*
  %tmp14 = bitcast i8* %tmp3 to [1024 x double]*
  %tmp17 = bitcast i8* %tmp6 to [1024 x double]*
  %G171.i = ptrtoint i8* %tmp6 to i64
  %F159.i = ptrtoint i8* %tmp3 to i64
  %E149.i = ptrtoint i8* %tmp to i64
  %D164.i = ptrtoint i8* %tmp5 to i64
  %C160.i = ptrtoint i8* %tmp4 to i64
  %B153.i = ptrtoint i8* %tmp2 to i64
  %A150.i = ptrtoint i8* %tmp1 to i64
  %49 = add i64 %E149.i, 8388600
  %50 = inttoptr i64 %49 to i8*
  %51 = add i64 %A150.i, 8388600
  %52 = inttoptr i64 %51 to i8*
  %53 = icmp ult i8* %50, %tmp1
  %54 = icmp ult i8* %52, %tmp
  %no-dyn-alias.i = or i1 %53, %54
  %55 = add i64 %B153.i, 8388600
  %56 = inttoptr i64 %55 to i8*
  %57 = icmp ult i8* %50, %tmp2
  %58 = icmp ult i8* %56, %tmp
  %no-dyn-alias155.i = or i1 %57, %58
  %59 = icmp ult i8* %52, %tmp2
  %60 = icmp ult i8* %56, %tmp1
  %no-dyn-alias156.i = or i1 %59, %60
  %no-dyn-alias157.i = and i1 %no-dyn-alias155.i, %no-dyn-alias.i
  %no-dyn-alias158.i = and i1 %no-dyn-alias156.i, %no-dyn-alias157.i
  br i1 %no-dyn-alias158.i, label %.preheader4.clone.i.preheader, label %.preheader4.i28.preheader

.preheader4.i28.preheader:                        ; preds = %init_array.exit
  br label %.preheader4.i28

.preheader4.clone.i.preheader:                    ; preds = %init_array.exit
  br label %.preheader4.clone.i

.preheader4.clone.i:                              ; preds = %bb95.clone.i, %.preheader4.clone.i.preheader
  %tmp71.clone.i = phi i64 [ %tmp96.clone.i, %bb95.clone.i ], [ 0, %.preheader4.clone.i.preheader ]
  br label %bb77.clone.i

bb77.clone.i:                                     ; preds = %bb92.clone.i, %.preheader4.clone.i
  %tmp78.clone.i = phi i64 [ %tmp93.clone.i, %bb92.clone.i ], [ 0, %.preheader4.clone.i ]
  %tmp79.clone.i = getelementptr [1024 x double]* %tmp11, i64 %tmp71.clone.i, i64 %tmp78.clone.i
  store double 0.000000e+00, double* %tmp79.clone.i, align 8, !tbaa !2, !llvm.loop !10
  br label %bb81.clone.i

bb81.clone.i:                                     ; preds = %bb81.clone.i, %bb77.clone.i
  %tmp88.clone.i = phi double [ 0.000000e+00, %bb77.clone.i ], [ %tmp89.clone.i.1, %bb81.clone.i ]
  %tmp82.clone.i = phi i64 [ 0, %bb77.clone.i ], [ %tmp90.clone.i.1, %bb81.clone.i ]
  %tmp83.clone.i = getelementptr [1024 x double]* %tmp7, i64 %tmp71.clone.i, i64 %tmp82.clone.i
  %tmp84.clone.i = getelementptr [1024 x double]* %tmp8, i64 %tmp82.clone.i, i64 %tmp78.clone.i
  %tmp85.clone.i = load double* %tmp83.clone.i, align 8, !tbaa !2
  %tmp86.clone.i = load double* %tmp84.clone.i, align 8, !tbaa !2
  %tmp87.clone.i = fmul double %tmp85.clone.i, %tmp86.clone.i
  %tmp89.clone.i = fadd double %tmp88.clone.i, %tmp87.clone.i
  store double %tmp89.clone.i, double* %tmp79.clone.i, align 8, !tbaa !2, !llvm.loop !19
  %tmp90.clone.i = add i64 %tmp82.clone.i, 1
  %tmp83.clone.i.1 = getelementptr [1024 x double]* %tmp7, i64 %tmp71.clone.i, i64 %tmp90.clone.i
  %tmp84.clone.i.1 = getelementptr [1024 x double]* %tmp8, i64 %tmp90.clone.i, i64 %tmp78.clone.i
  %tmp85.clone.i.1 = load double* %tmp83.clone.i.1, align 8, !tbaa !2
  %tmp86.clone.i.1 = load double* %tmp84.clone.i.1, align 8, !tbaa !2
  %tmp87.clone.i.1 = fmul double %tmp85.clone.i.1, %tmp86.clone.i.1
  %tmp89.clone.i.1 = fadd double %tmp89.clone.i, %tmp87.clone.i.1
  store double %tmp89.clone.i.1, double* %tmp79.clone.i, align 8, !tbaa !2, !llvm.loop !19
  %tmp90.clone.i.1 = add i64 %tmp90.clone.i, 1
  %tmp91.clone.i.1 = icmp eq i64 %tmp90.clone.i.1, 1024
  br i1 %tmp91.clone.i.1, label %bb92.clone.i, label %bb81.clone.i, !llvm.loop !29

bb92.clone.i:                                     ; preds = %bb81.clone.i
  %tmp93.clone.i = add i64 %tmp78.clone.i, 1
  %tmp94.clone.i = icmp eq i64 %tmp93.clone.i, 1024
  br i1 %tmp94.clone.i, label %bb95.clone.i, label %bb77.clone.i, !llvm.loop !30

bb95.clone.i:                                     ; preds = %bb92.clone.i
  %tmp96.clone.i = add i64 %tmp71.clone.i, 1
  %tmp97.clone.i = icmp eq i64 %tmp96.clone.i, 1024
  br i1 %tmp97.clone.i, label %.preheader3.i.loopexit, label %.preheader4.clone.i, !llvm.loop !31

.preheader4.i28:                                  ; preds = %bb95.i, %.preheader4.i28.preheader
  %tmp71.i27 = phi i64 [ %tmp96.i, %bb95.i ], [ 0, %.preheader4.i28.preheader ]
  br label %bb77.i

.preheader3.i.loopexit:                           ; preds = %bb95.clone.i
  br label %.preheader3.i

.preheader3.i.loopexit117:                        ; preds = %bb95.i
  br label %.preheader3.i

.preheader3.i:                                    ; preds = %.preheader3.i.loopexit117, %.preheader3.i.loopexit
  %61 = add i64 %F159.i, 8388600
  %62 = inttoptr i64 %61 to i8*
  %63 = add i64 %C160.i, 8388600
  %64 = inttoptr i64 %63 to i8*
  %65 = icmp ult i8* %62, %tmp4
  %66 = icmp ult i8* %64, %tmp3
  %no-dyn-alias163.i = or i1 %65, %66
  %67 = add i64 %D164.i, 8388600
  %68 = inttoptr i64 %67 to i8*
  %69 = icmp ult i8* %62, %tmp5
  %70 = icmp ult i8* %68, %tmp3
  %no-dyn-alias166.i = or i1 %69, %70
  %71 = icmp ult i8* %64, %tmp5
  %72 = icmp ult i8* %68, %tmp4
  %no-dyn-alias167.i = or i1 %71, %72
  %no-dyn-alias168.i = and i1 %no-dyn-alias166.i, %no-dyn-alias163.i
  %no-dyn-alias169.i = and i1 %no-dyn-alias167.i, %no-dyn-alias168.i
  br i1 %no-dyn-alias169.i, label %.preheader2.clone.i.preheader, label %.preheader2.i38.preheader

.preheader2.i38.preheader:                        ; preds = %.preheader3.i
  br label %.preheader2.i38

.preheader2.clone.i.preheader:                    ; preds = %.preheader3.i
  br label %.preheader2.clone.i

.preheader2.clone.i:                              ; preds = %bb122.clone.i, %.preheader2.clone.i.preheader
  %tmp98.clone.i = phi i64 [ %tmp123.clone.i, %bb122.clone.i ], [ 0, %.preheader2.clone.i.preheader ]
  br label %bb104.clone.i

bb104.clone.i:                                    ; preds = %bb119.clone.i, %.preheader2.clone.i
  %tmp105.clone.i = phi i64 [ %tmp120.clone.i, %bb119.clone.i ], [ 0, %.preheader2.clone.i ]
  %tmp106.clone.i = getelementptr [1024 x double]* %tmp14, i64 %tmp98.clone.i, i64 %tmp105.clone.i
  store double 0.000000e+00, double* %tmp106.clone.i, align 8, !tbaa !2, !llvm.loop !32
  br label %bb108.clone.i

bb108.clone.i:                                    ; preds = %bb108.clone.i, %bb104.clone.i
  %tmp115.clone.i = phi double [ 0.000000e+00, %bb104.clone.i ], [ %tmp116.clone.i.1, %bb108.clone.i ]
  %tmp109.clone.i = phi i64 [ 0, %bb104.clone.i ], [ %tmp117.clone.i.1, %bb108.clone.i ]
  %tmp110.clone.i = getelementptr [1024 x double]* %tmp9, i64 %tmp98.clone.i, i64 %tmp109.clone.i
  %tmp111.clone.i = getelementptr [1024 x double]* %tmp10, i64 %tmp109.clone.i, i64 %tmp105.clone.i
  %tmp112.clone.i = load double* %tmp110.clone.i, align 8, !tbaa !2
  %tmp113.clone.i = load double* %tmp111.clone.i, align 8, !tbaa !2
  %tmp114.clone.i = fmul double %tmp112.clone.i, %tmp113.clone.i
  %tmp116.clone.i = fadd double %tmp115.clone.i, %tmp114.clone.i
  store double %tmp116.clone.i, double* %tmp106.clone.i, align 8, !tbaa !2, !llvm.loop !33
  %tmp117.clone.i = add i64 %tmp109.clone.i, 1
  %tmp110.clone.i.1 = getelementptr [1024 x double]* %tmp9, i64 %tmp98.clone.i, i64 %tmp117.clone.i
  %tmp111.clone.i.1 = getelementptr [1024 x double]* %tmp10, i64 %tmp117.clone.i, i64 %tmp105.clone.i
  %tmp112.clone.i.1 = load double* %tmp110.clone.i.1, align 8, !tbaa !2
  %tmp113.clone.i.1 = load double* %tmp111.clone.i.1, align 8, !tbaa !2
  %tmp114.clone.i.1 = fmul double %tmp112.clone.i.1, %tmp113.clone.i.1
  %tmp116.clone.i.1 = fadd double %tmp116.clone.i, %tmp114.clone.i.1
  store double %tmp116.clone.i.1, double* %tmp106.clone.i, align 8, !tbaa !2, !llvm.loop !33
  %tmp117.clone.i.1 = add i64 %tmp117.clone.i, 1
  %tmp118.clone.i.1 = icmp eq i64 %tmp117.clone.i.1, 1024
  br i1 %tmp118.clone.i.1, label %bb119.clone.i, label %bb108.clone.i, !llvm.loop !23

bb119.clone.i:                                    ; preds = %bb108.clone.i
  %tmp120.clone.i = add i64 %tmp105.clone.i, 1
  %tmp121.clone.i = icmp eq i64 %tmp120.clone.i, 1024
  br i1 %tmp121.clone.i, label %bb122.clone.i, label %bb104.clone.i, !llvm.loop !34

bb122.clone.i:                                    ; preds = %bb119.clone.i
  %tmp123.clone.i = add i64 %tmp98.clone.i, 1
  %tmp124.clone.i = icmp eq i64 %tmp123.clone.i, 1024
  br i1 %tmp124.clone.i, label %.preheader1.i.loopexit, label %.preheader2.clone.i, !llvm.loop !35

bb77.i:                                           ; preds = %bb92.i, %.preheader4.i28
  %tmp78.i = phi i64 [ %tmp93.i37, %bb92.i ], [ 0, %.preheader4.i28 ]
  %tmp79.i29 = getelementptr [1024 x double]* %tmp11, i64 %tmp71.i27, i64 %tmp78.i
  store double 0.000000e+00, double* %tmp79.i29, align 8, !tbaa !2, !llvm.loop !10
  br label %bb81.i

bb81.i:                                           ; preds = %bb81.i, %bb77.i
  %tmp88.i = phi double [ 0.000000e+00, %bb77.i ], [ %tmp89.i35.1, %bb81.i ]
  %tmp82.i30 = phi i64 [ 0, %bb77.i ], [ %tmp90.i.1, %bb81.i ]
  %tmp83.i31 = getelementptr [1024 x double]* %tmp7, i64 %tmp71.i27, i64 %tmp82.i30
  %tmp84.i32 = getelementptr [1024 x double]* %tmp8, i64 %tmp82.i30, i64 %tmp78.i
  %tmp85.i33 = load double* %tmp83.i31, align 8, !tbaa !2
  %tmp86.i = load double* %tmp84.i32, align 8, !tbaa !2
  %tmp87.i34 = fmul double %tmp85.i33, %tmp86.i
  %tmp89.i35 = fadd double %tmp88.i, %tmp87.i34
  store double %tmp89.i35, double* %tmp79.i29, align 8, !tbaa !2, !llvm.loop !19
  %tmp90.i = add i64 %tmp82.i30, 1
  %tmp83.i31.1 = getelementptr [1024 x double]* %tmp7, i64 %tmp71.i27, i64 %tmp90.i
  %tmp84.i32.1 = getelementptr [1024 x double]* %tmp8, i64 %tmp90.i, i64 %tmp78.i
  %tmp85.i33.1 = load double* %tmp83.i31.1, align 8, !tbaa !2
  %tmp86.i.1 = load double* %tmp84.i32.1, align 8, !tbaa !2
  %tmp87.i34.1 = fmul double %tmp85.i33.1, %tmp86.i.1
  %tmp89.i35.1 = fadd double %tmp89.i35, %tmp87.i34.1
  store double %tmp89.i35.1, double* %tmp79.i29, align 8, !tbaa !2, !llvm.loop !19
  %tmp90.i.1 = add i64 %tmp90.i, 1
  %tmp91.i36.1 = icmp eq i64 %tmp90.i.1, 1024
  br i1 %tmp91.i36.1, label %bb92.i, label %bb81.i, !llvm.loop !29

bb92.i:                                           ; preds = %bb81.i
  %tmp93.i37 = add i64 %tmp78.i, 1
  %tmp94.i = icmp eq i64 %tmp93.i37, 1024
  br i1 %tmp94.i, label %bb95.i, label %bb77.i, !llvm.loop !30

bb95.i:                                           ; preds = %bb92.i
  %tmp96.i = add i64 %tmp71.i27, 1
  %tmp97.i = icmp eq i64 %tmp96.i, 1024
  br i1 %tmp97.i, label %.preheader3.i.loopexit117, label %.preheader4.i28, !llvm.loop !31

.preheader2.i38:                                  ; preds = %bb122.i, %.preheader2.i38.preheader
  %tmp98.i = phi i64 [ %tmp123.i49, %bb122.i ], [ 0, %.preheader2.i38.preheader ]
  br label %bb104.i

.preheader1.i.loopexit:                           ; preds = %bb122.clone.i
  br label %.preheader1.i

.preheader1.i.loopexit116:                        ; preds = %bb122.i
  br label %.preheader1.i

.preheader1.i:                                    ; preds = %.preheader1.i.loopexit116, %.preheader1.i.loopexit
  %73 = icmp ult i8* %50, %tmp3
  %74 = icmp ult i8* %62, %tmp
  %no-dyn-alias170.i = or i1 %73, %74
  %75 = add i64 %G171.i, 8388600
  %76 = inttoptr i64 %75 to i8*
  %77 = icmp ult i8* %50, %tmp6
  %78 = icmp ult i8* %76, %tmp
  %no-dyn-alias173.i = or i1 %77, %78
  %79 = icmp ult i8* %62, %tmp6
  %80 = icmp ult i8* %76, %tmp3
  %no-dyn-alias174.i = or i1 %79, %80
  %no-dyn-alias175.i = and i1 %no-dyn-alias173.i, %no-dyn-alias170.i
  %no-dyn-alias176.i = and i1 %no-dyn-alias174.i, %no-dyn-alias175.i
  br i1 %no-dyn-alias176.i, label %.preheader.clone.i.preheader, label %.preheader.i51.preheader

.preheader.i51.preheader:                         ; preds = %.preheader1.i
  br label %.preheader.i51

.preheader.clone.i.preheader:                     ; preds = %.preheader1.i
  br label %.preheader.clone.i

.preheader.clone.i:                               ; preds = %bb145.clone.i, %.preheader.clone.i.preheader
  %tmp125.clone.i = phi i64 [ %tmp146.clone.i, %bb145.clone.i ], [ 0, %.preheader.clone.i.preheader ]
  br label %bb127.clone.i

bb127.clone.i:                                    ; preds = %bb142.clone.i, %.preheader.clone.i
  %tmp128.clone.i = phi i64 [ %tmp143.clone.i, %bb142.clone.i ], [ 0, %.preheader.clone.i ]
  %tmp129.clone.i = getelementptr [1024 x double]* %tmp17, i64 %tmp125.clone.i, i64 %tmp128.clone.i
  store double 0.000000e+00, double* %tmp129.clone.i, align 8, !tbaa !2, !llvm.loop !36
  br label %bb131.clone.i

bb131.clone.i:                                    ; preds = %bb131.clone.i, %bb127.clone.i
  %tmp138.clone.i = phi double [ 0.000000e+00, %bb127.clone.i ], [ %tmp139.clone.i.1, %bb131.clone.i ]
  %tmp132.clone.i = phi i64 [ 0, %bb127.clone.i ], [ %tmp140.clone.i.1, %bb131.clone.i ]
  %tmp133.clone.i = getelementptr [1024 x double]* %tmp11, i64 %tmp125.clone.i, i64 %tmp132.clone.i
  %tmp134.clone.i = getelementptr [1024 x double]* %tmp14, i64 %tmp132.clone.i, i64 %tmp128.clone.i
  %tmp135.clone.i = load double* %tmp133.clone.i, align 8, !tbaa !2
  %tmp136.clone.i = load double* %tmp134.clone.i, align 8, !tbaa !2
  %tmp137.clone.i = fmul double %tmp135.clone.i, %tmp136.clone.i
  %tmp139.clone.i = fadd double %tmp138.clone.i, %tmp137.clone.i
  store double %tmp139.clone.i, double* %tmp129.clone.i, align 8, !tbaa !2, !llvm.loop !37
  %tmp140.clone.i = add i64 %tmp132.clone.i, 1
  %tmp133.clone.i.1 = getelementptr [1024 x double]* %tmp11, i64 %tmp125.clone.i, i64 %tmp140.clone.i
  %tmp134.clone.i.1 = getelementptr [1024 x double]* %tmp14, i64 %tmp140.clone.i, i64 %tmp128.clone.i
  %tmp135.clone.i.1 = load double* %tmp133.clone.i.1, align 8, !tbaa !2
  %tmp136.clone.i.1 = load double* %tmp134.clone.i.1, align 8, !tbaa !2
  %tmp137.clone.i.1 = fmul double %tmp135.clone.i.1, %tmp136.clone.i.1
  %tmp139.clone.i.1 = fadd double %tmp139.clone.i, %tmp137.clone.i.1
  store double %tmp139.clone.i.1, double* %tmp129.clone.i, align 8, !tbaa !2, !llvm.loop !37
  %tmp140.clone.i.1 = add i64 %tmp140.clone.i, 1
  %tmp141.clone.i.1 = icmp eq i64 %tmp140.clone.i.1, 1024
  br i1 %tmp141.clone.i.1, label %bb142.clone.i, label %bb131.clone.i, !llvm.loop !38

bb142.clone.i:                                    ; preds = %bb131.clone.i
  %tmp143.clone.i = add i64 %tmp128.clone.i, 1
  %tmp144.clone.i = icmp eq i64 %tmp143.clone.i, 1024
  br i1 %tmp144.clone.i, label %bb145.clone.i, label %bb127.clone.i, !llvm.loop !39

bb145.clone.i:                                    ; preds = %bb142.clone.i
  %tmp146.clone.i = add i64 %tmp125.clone.i, 1
  %tmp147.clone.i = icmp eq i64 %tmp146.clone.i, 1024
  br i1 %tmp147.clone.i, label %kernel_3mm.exit.loopexit, label %.preheader.clone.i, !llvm.loop !40

bb104.i:                                          ; preds = %bb119.i, %.preheader2.i38
  %tmp105.i39 = phi i64 [ %tmp120.i47, %bb119.i ], [ 0, %.preheader2.i38 ]
  %tmp106.i40 = getelementptr [1024 x double]* %tmp14, i64 %tmp98.i, i64 %tmp105.i39
  store double 0.000000e+00, double* %tmp106.i40, align 8, !tbaa !2, !llvm.loop !32
  br label %bb108.i

bb108.i:                                          ; preds = %bb108.i, %bb104.i
  %tmp115.i = phi double [ 0.000000e+00, %bb104.i ], [ %tmp116.i.1, %bb108.i ]
  %tmp109.i41 = phi i64 [ 0, %bb104.i ], [ %tmp117.i.1, %bb108.i ]
  %tmp110.i42 = getelementptr [1024 x double]* %tmp9, i64 %tmp98.i, i64 %tmp109.i41
  %tmp111.i = getelementptr [1024 x double]* %tmp10, i64 %tmp109.i41, i64 %tmp105.i39
  %tmp112.i43 = load double* %tmp110.i42, align 8, !tbaa !2
  %tmp113.i44 = load double* %tmp111.i, align 8, !tbaa !2
  %tmp114.i45 = fmul double %tmp112.i43, %tmp113.i44
  %tmp116.i = fadd double %tmp115.i, %tmp114.i45
  store double %tmp116.i, double* %tmp106.i40, align 8, !tbaa !2, !llvm.loop !33
  %tmp117.i = add i64 %tmp109.i41, 1
  %tmp110.i42.1 = getelementptr [1024 x double]* %tmp9, i64 %tmp98.i, i64 %tmp117.i
  %tmp111.i.1 = getelementptr [1024 x double]* %tmp10, i64 %tmp117.i, i64 %tmp105.i39
  %tmp112.i43.1 = load double* %tmp110.i42.1, align 8, !tbaa !2
  %tmp113.i44.1 = load double* %tmp111.i.1, align 8, !tbaa !2
  %tmp114.i45.1 = fmul double %tmp112.i43.1, %tmp113.i44.1
  %tmp116.i.1 = fadd double %tmp116.i, %tmp114.i45.1
  store double %tmp116.i.1, double* %tmp106.i40, align 8, !tbaa !2, !llvm.loop !33
  %tmp117.i.1 = add i64 %tmp117.i, 1
  %tmp118.i46.1 = icmp eq i64 %tmp117.i.1, 1024
  br i1 %tmp118.i46.1, label %bb119.i, label %bb108.i, !llvm.loop !23

bb119.i:                                          ; preds = %bb108.i
  %tmp120.i47 = add i64 %tmp105.i39, 1
  %tmp121.i48 = icmp eq i64 %tmp120.i47, 1024
  br i1 %tmp121.i48, label %bb122.i, label %bb104.i, !llvm.loop !34

bb122.i:                                          ; preds = %bb119.i
  %tmp123.i49 = add i64 %tmp98.i, 1
  %tmp124.i50 = icmp eq i64 %tmp123.i49, 1024
  br i1 %tmp124.i50, label %.preheader1.i.loopexit116, label %.preheader2.i38, !llvm.loop !35

.preheader.i51:                                   ; preds = %bb145.i, %.preheader.i51.preheader
  %tmp125.i = phi i64 [ %tmp146.i, %bb145.i ], [ 0, %.preheader.i51.preheader ]
  br label %bb127.i

bb127.i:                                          ; preds = %bb142.i, %.preheader.i51
  %tmp128.i52 = phi i64 [ %tmp143.i, %bb142.i ], [ 0, %.preheader.i51 ]
  %tmp129.i = getelementptr [1024 x double]* %tmp17, i64 %tmp125.i, i64 %tmp128.i52
  store double 0.000000e+00, double* %tmp129.i, align 8, !tbaa !2, !llvm.loop !36
  br label %bb131.i

bb131.i:                                          ; preds = %bb131.i, %bb127.i
  %tmp138.i = phi double [ 0.000000e+00, %bb127.i ], [ %tmp139.i.1, %bb131.i ]
  %tmp132.i = phi i64 [ 0, %bb127.i ], [ %tmp140.i.1, %bb131.i ]
  %tmp133.i = getelementptr [1024 x double]* %tmp11, i64 %tmp125.i, i64 %tmp132.i
  %tmp134.i = getelementptr [1024 x double]* %tmp14, i64 %tmp132.i, i64 %tmp128.i52
  %tmp135.i = load double* %tmp133.i, align 8, !tbaa !2
  %tmp136.i = load double* %tmp134.i, align 8, !tbaa !2
  %tmp137.i = fmul double %tmp135.i, %tmp136.i
  %tmp139.i = fadd double %tmp138.i, %tmp137.i
  store double %tmp139.i, double* %tmp129.i, align 8, !tbaa !2, !llvm.loop !37
  %tmp140.i = add i64 %tmp132.i, 1
  %tmp133.i.1 = getelementptr [1024 x double]* %tmp11, i64 %tmp125.i, i64 %tmp140.i
  %tmp134.i.1 = getelementptr [1024 x double]* %tmp14, i64 %tmp140.i, i64 %tmp128.i52
  %tmp135.i.1 = load double* %tmp133.i.1, align 8, !tbaa !2
  %tmp136.i.1 = load double* %tmp134.i.1, align 8, !tbaa !2
  %tmp137.i.1 = fmul double %tmp135.i.1, %tmp136.i.1
  %tmp139.i.1 = fadd double %tmp139.i, %tmp137.i.1
  store double %tmp139.i.1, double* %tmp129.i, align 8, !tbaa !2, !llvm.loop !37
  %tmp140.i.1 = add i64 %tmp140.i, 1
  %tmp141.i.1 = icmp eq i64 %tmp140.i.1, 1024
  br i1 %tmp141.i.1, label %bb142.i, label %bb131.i, !llvm.loop !38

bb142.i:                                          ; preds = %bb131.i
  %tmp143.i = add i64 %tmp128.i52, 1
  %tmp144.i = icmp eq i64 %tmp143.i, 1024
  br i1 %tmp144.i, label %bb145.i, label %bb127.i, !llvm.loop !39

bb145.i:                                          ; preds = %bb142.i
  %tmp146.i = add i64 %tmp125.i, 1
  %tmp147.i = icmp eq i64 %tmp146.i, 1024
  br i1 %tmp147.i, label %kernel_3mm.exit.loopexit115, label %.preheader.i51, !llvm.loop !40

kernel_3mm.exit.loopexit:                         ; preds = %bb145.clone.i
  br label %kernel_3mm.exit

kernel_3mm.exit.loopexit115:                      ; preds = %bb145.i
  br label %kernel_3mm.exit

kernel_3mm.exit:                                  ; preds = %kernel_3mm.exit.loopexit115, %kernel_3mm.exit.loopexit
  %tmp18 = icmp sgt i32 %argc, 42
  br i1 %tmp18, label %bb19, label %bb25, !llvm.loop !12

bb19:                                             ; preds = %kernel_3mm.exit
  %tmp20 = load i8** %argv, align 8, !tbaa !14
  %tmp21 = load i8* %tmp20, align 1
  %tmp22 = icmp eq i8 %tmp21, 0
  br i1 %tmp22, label %.preheader.i26.preheader, label %bb25, !llvm.loop !6

.preheader.i26.preheader:                         ; preds = %bb19
  br label %.preheader.i26

.preheader.i26:                                   ; preds = %bb32.i, %.preheader.i26.preheader
  %tmp13.i = phi i64 [ %tmp33.i, %bb32.i ], [ 0, %.preheader.i26.preheader ]
  %tmp14.i = shl i64 %tmp13.i, 10
  br label %bb16.i

bb16.i:                                           ; preds = %bb29.i, %.preheader.i26
  %tmp17.i = phi i64 [ %tmp30.i, %bb29.i ], [ 0, %.preheader.i26 ]
  %tmp18.i = add i64 %tmp17.i, %tmp14.i
  %tmp19.i = trunc i64 %tmp18.i to i32
  %tmp20.i = getelementptr [1024 x double]* %tmp17, i64 %tmp13.i, i64 %tmp17.i
  %tmp21.i = load %struct.__sFILE** @__stderrp, align 8, !tbaa !14
  %tmp22.i = load double* %tmp20.i, align 8, !tbaa !2
  %tmp23.i = tail call i32 (%struct.__sFILE*, i8*, ...)* @fprintf(%struct.__sFILE* %tmp21.i, i8* getelementptr inbounds ([8 x i8]* @.str11, i64 0, i64 0), double %tmp22.i) #4
  %tmp24.i = srem i32 %tmp19.i, 20
  %tmp25.i = icmp eq i32 %tmp24.i, 0
  br i1 %tmp25.i, label %bb26.i, label %bb29.i, !llvm.loop !7

bb26.i:                                           ; preds = %bb16.i
  %tmp27.i = load %struct.__sFILE** @__stderrp, align 8, !tbaa !14
  %tmp28.i = tail call i32 @fputc(i32 10, %struct.__sFILE* %tmp27.i) #4
  br label %bb29.i, !llvm.loop !8

bb29.i:                                           ; preds = %bb26.i, %bb16.i
  %tmp30.i = add i64 %tmp17.i, 1
  %tmp31.i = icmp eq i64 %tmp30.i, 1024
  br i1 %tmp31.i, label %bb32.i, label %bb16.i, !llvm.loop !9

bb32.i:                                           ; preds = %bb29.i
  %tmp33.i = add i64 %tmp13.i, 1
  %tmp34.i = icmp eq i64 %tmp33.i, 1024
  br i1 %tmp34.i, label %print_array.exit, label %.preheader.i26, !llvm.loop !11

print_array.exit:                                 ; preds = %bb32.i
  %tmp36.i = load %struct.__sFILE** @__stderrp, align 8, !tbaa !14
  %tmp37.i = tail call i32 @fputc(i32 10, %struct.__sFILE* %tmp36.i) #4
  br label %bb25, !llvm.loop !8

bb25:                                             ; preds = %print_array.exit, %bb19, %kernel_3mm.exit
  tail call void @free(i8* %tmp), !llvm.loop !9
  tail call void @free(i8* %tmp1), !llvm.loop !10
  tail call void @free(i8* %tmp2), !llvm.loop !11
  tail call void @free(i8* %tmp3), !llvm.loop !41
  tail call void @free(i8* %tmp4), !llvm.loop !19
  tail call void @free(i8* %tmp5), !llvm.loop !29
  tail call void @free(i8* %tmp6), !llvm.loop !42
  ret i32 0, !llvm.loop !30
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
!16 = metadata !{metadata !16, metadata !17, metadata !18}
!17 = metadata !{metadata !"llvm.loop.vectorize.width", i32 1}
!18 = metadata !{metadata !"llvm.loop.interleave.count", i32 1}
!19 = metadata !{metadata !"void12"}
!20 = metadata !{metadata !"void18"}
!21 = metadata !{metadata !21, metadata !17, metadata !18}
!22 = metadata !{metadata !"void21"}
!23 = metadata !{metadata !"void27"}
!24 = metadata !{metadata !24, metadata !17, metadata !18}
!25 = metadata !{metadata !"void30"}
!26 = metadata !{metadata !"void33"}
!27 = metadata !{metadata !27, metadata !17, metadata !18}
!28 = metadata !{metadata !"void36"}
!29 = metadata !{metadata !"void13"}
!30 = metadata !{metadata !"void15"}
!31 = metadata !{metadata !"void17"}
!32 = metadata !{metadata !"void23"}
!33 = metadata !{metadata !"void26"}
!34 = metadata !{metadata !"void29"}
!35 = metadata !{metadata !"void31"}
!36 = metadata !{metadata !"void34"}
!37 = metadata !{metadata !"void37"}
!38 = metadata !{metadata !"void38"}
!39 = metadata !{metadata !"void40"}
!40 = metadata !{metadata !"void42"}
!41 = metadata !{metadata !"void11"}
!42 = metadata !{metadata !"void14"}
