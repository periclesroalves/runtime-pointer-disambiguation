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
  %tmp = tail call i8* @polybench_alloc_data(i64 2097152, i32 8) #4
  %tmp1 = tail call i8* @polybench_alloc_data(i64 2097152, i32 8) #4
  %tmp2 = tail call i8* @polybench_alloc_data(i64 16384, i32 8) #4
  %tmp3 = bitcast i8* %tmp to [128 x [128 x double]]*
  br label %.preheader3.i

.preheader3.i:                                    ; preds = %bb57.i, %bb
  %tmp32.i = phi i64 [ %tmp58.i, %bb57.i ], [ 0, %bb ]
  %tmp33.moved.to.bb41.i = trunc i64 %tmp32.i to i32
  %tmp45.i = sitofp i32 %tmp33.moved.to.bb41.i to double
  br label %.preheader2.i

.preheader2.i:                                    ; preds = %bb54.i, %.preheader3.i
  %tmp38.i = phi i64 [ %tmp55.i, %bb54.i ], [ 0, %.preheader3.i ]
  %tmp39.moved.to.bb41.i = trunc i64 %tmp38.i to i32
  %tmp46.i = sitofp i32 %tmp39.moved.to.bb41.i to double
  %tmp47.i = fmul double %tmp45.i, %tmp46.i
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %.preheader2.i
  %index = phi i64 [ 0, %.preheader2.i ], [ %index.next, %vector.body ]
  %induction46107 = or i64 %index, 1
  %0 = getelementptr [128 x [128 x double]]* %tmp3, i64 %tmp32.i, i64 %tmp38.i, i64 %index
  %1 = getelementptr [128 x [128 x double]]* %tmp3, i64 %tmp32.i, i64 %tmp38.i, i64 %induction46107
  %2 = trunc i64 %index to i32
  %induction48108 = or i32 %2, 1
  %3 = sitofp i32 %2 to double
  %4 = sitofp i32 %induction48108 to double
  %5 = fadd double %tmp47.i, %3
  %6 = fadd double %tmp47.i, %4
  %7 = fmul double %5, 7.812500e-03
  %8 = fmul double %6, 7.812500e-03
  store double %7, double* %0, align 8, !tbaa !2, !llvm.loop !16
  store double %8, double* %1, align 8, !tbaa !2, !llvm.loop !16
  %index.next = add i64 %index, 2
  %9 = icmp eq i64 %index.next, 128
  br i1 %9, label %bb54.i, label %vector.body, !llvm.loop !17

bb54.i:                                           ; preds = %vector.body
  %tmp55.i = add i64 %tmp38.i, 1
  %tmp56.i = icmp eq i64 %tmp55.i, 128
  br i1 %tmp56.i, label %bb57.i, label %.preheader2.i, !llvm.loop !20

bb57.i:                                           ; preds = %bb54.i
  %tmp58.i = add i64 %tmp32.i, 1
  %tmp59.i = icmp eq i64 %tmp58.i, 128
  br i1 %tmp59.i, label %.preheader.i.preheader, label %.preheader3.i, !llvm.loop !21

.preheader.i.preheader:                           ; preds = %bb57.i
  %tmp4 = bitcast i8* %tmp2 to [128 x double]*
  br label %.preheader.i

.preheader.i:                                     ; preds = %bb74.i, %.preheader.i.preheader
  %tmp60.i = phi i64 [ %tmp75.i, %bb74.i ], [ 0, %.preheader.i.preheader ]
  %tmp61.moved.to.bb63.i = trunc i64 %tmp60.i to i32
  %tmp67.i = sitofp i32 %tmp61.moved.to.bb63.i to double
  br label %vector.body52

vector.body52:                                    ; preds = %vector.body52, %.preheader.i
  %index55 = phi i64 [ 0, %.preheader.i ], [ %index.next62, %vector.body52 ]
  %induction64109 = or i64 %index55, 1
  %10 = getelementptr [128 x double]* %tmp4, i64 %tmp60.i, i64 %index55
  %11 = getelementptr [128 x double]* %tmp4, i64 %tmp60.i, i64 %induction64109
  %12 = trunc i64 %index55 to i32
  %induction66110 = or i32 %12, 1
  %13 = sitofp i32 %12 to double
  %14 = sitofp i32 %induction66110 to double
  %15 = fmul double %tmp67.i, %13
  %16 = fmul double %tmp67.i, %14
  %17 = fmul double %15, 7.812500e-03
  %18 = fmul double %16, 7.812500e-03
  store double %17, double* %10, align 8, !tbaa !2, !llvm.loop !22
  store double %18, double* %11, align 8, !tbaa !2, !llvm.loop !22
  %index.next62 = add i64 %index55, 2
  %19 = icmp eq i64 %index.next62, 128
  br i1 %19, label %bb74.i, label %vector.body52, !llvm.loop !23

bb74.i:                                           ; preds = %vector.body52
  %tmp75.i = add i64 %tmp60.i, 1
  %tmp76.i = icmp eq i64 %tmp75.i, 128
  br i1 %tmp76.i, label %init_array.exit, label %.preheader.i, !llvm.loop !24

init_array.exit:                                  ; preds = %bb74.i
  %tmp7 = bitcast i8* %tmp1 to [128 x [128 x double]]*
  %sum86.i = ptrtoint i8* %tmp1 to i64
  %C481.i = ptrtoint i8* %tmp2 to i64
  %A80.i = ptrtoint i8* %tmp to i64
  %20 = add i64 %A80.i, 16777208
  %umax83.i = inttoptr i64 %20 to i8*
  %21 = add i64 %C481.i, 131064
  %22 = inttoptr i64 %21 to i8*
  %23 = icmp ult i8* %umax83.i, %tmp2
  %24 = icmp ult i8* %22, %tmp
  %no-dyn-alias.i = or i1 %23, %24
  %25 = add i64 %sum86.i, 16777208
  %umax8789.i = inttoptr i64 %25 to i8*
  %26 = icmp ult i8* %umax83.i, %tmp1
  %27 = icmp ult i8* %umax8789.i, %tmp
  %no-dyn-alias90.i = or i1 %26, %27
  %28 = icmp ult i8* %22, %tmp1
  %29 = icmp ult i8* %umax8789.i, %tmp2
  %no-dyn-alias91.i = or i1 %28, %29
  %no-dyn-alias92.i = and i1 %no-dyn-alias90.i, %no-dyn-alias.i
  %no-dyn-alias93.i = and i1 %no-dyn-alias91.i, %no-dyn-alias92.i
  br i1 %no-dyn-alias93.i, label %.preheader2.clone.i.preheader, label %.preheader2.i24.preheader

.preheader2.i24.preheader:                        ; preds = %init_array.exit
  br label %.preheader2.i24

.preheader2.clone.i.preheader:                    ; preds = %init_array.exit
  br label %.preheader2.clone.i

.preheader2.clone.i:                              ; preds = %bb76.clone.i, %.preheader2.clone.i.preheader
  %tmp43.clone.i = phi i64 [ %tmp77.clone.i, %bb76.clone.i ], [ 0, %.preheader2.clone.i.preheader ]
  br label %.preheader1.clone.i

.preheader1.clone.i:                              ; preds = %bb73.clone.i, %.preheader2.clone.i
  %tmp45.clone.i = phi i64 [ %tmp74.clone.i, %bb73.clone.i ], [ 0, %.preheader2.clone.i ]
  br label %bb48.clone.i

bb48.clone.i:                                     ; preds = %bb63.clone.i, %.preheader1.clone.i
  %tmp49.clone.i = phi i64 [ %tmp64.clone.i, %bb63.clone.i ], [ 0, %.preheader1.clone.i ]
  %tmp50.clone.i = getelementptr [128 x [128 x double]]* %tmp7, i64 %tmp43.clone.i, i64 %tmp45.clone.i, i64 %tmp49.clone.i
  store double 0.000000e+00, double* %tmp50.clone.i, align 8, !tbaa !2, !alias.scope !25, !noalias !28, !llvm.loop !16
  br label %bb52.clone.i

bb52.clone.i:                                     ; preds = %bb52.clone.i, %bb48.clone.i
  %tmp56.clone2.i = phi double [ 0.000000e+00, %bb48.clone.i ], [ %tmp60.clone.i.1, %bb52.clone.i ]
  %tmp53.clone.i = phi i64 [ 0, %bb48.clone.i ], [ %tmp61.clone.i.1, %bb52.clone.i ]
  %tmp54.clone.i = getelementptr [128 x [128 x double]]* %tmp3, i64 %tmp43.clone.i, i64 %tmp45.clone.i, i64 %tmp53.clone.i
  %tmp55.clone.i = getelementptr [128 x double]* %tmp4, i64 %tmp53.clone.i, i64 %tmp49.clone.i
  %tmp57.clone.i = load double* %tmp54.clone.i, align 8, !tbaa !2, !alias.scope !31, !noalias !32
  %tmp58.clone.i = load double* %tmp55.clone.i, align 8, !tbaa !2, !alias.scope !33, !noalias !34
  %tmp59.clone.i = fmul double %tmp57.clone.i, %tmp58.clone.i
  %tmp60.clone.i = fadd double %tmp56.clone2.i, %tmp59.clone.i
  %tmp61.clone.i = add i64 %tmp53.clone.i, 1
  %tmp54.clone.i.1 = getelementptr [128 x [128 x double]]* %tmp3, i64 %tmp43.clone.i, i64 %tmp45.clone.i, i64 %tmp61.clone.i
  %tmp55.clone.i.1 = getelementptr [128 x double]* %tmp4, i64 %tmp61.clone.i, i64 %tmp49.clone.i
  %tmp57.clone.i.1 = load double* %tmp54.clone.i.1, align 8, !tbaa !2, !alias.scope !31, !noalias !32
  %tmp58.clone.i.1 = load double* %tmp55.clone.i.1, align 8, !tbaa !2, !alias.scope !33, !noalias !34
  %tmp59.clone.i.1 = fmul double %tmp57.clone.i.1, %tmp58.clone.i.1
  %tmp60.clone.i.1 = fadd double %tmp60.clone.i, %tmp59.clone.i.1
  %tmp61.clone.i.1 = add i64 %tmp61.clone.i, 1
  %tmp62.clone.i.1 = icmp eq i64 %tmp61.clone.i.1, 128
  br i1 %tmp62.clone.i.1, label %bb63.clone.i, label %bb52.clone.i, !llvm.loop !35

bb63.clone.i:                                     ; preds = %bb52.clone.i
  %tmp60.clone.i.lcssa = phi double [ %tmp60.clone.i.1, %bb52.clone.i ]
  store double %tmp60.clone.i.lcssa, double* %tmp50.clone.i, align 8, !tbaa !2, !alias.scope !25, !noalias !28
  %tmp64.clone.i = add i64 %tmp49.clone.i, 1
  %tmp65.clone.i = icmp eq i64 %tmp64.clone.i, 128
  br i1 %tmp65.clone.i, label %vector.body90.preheader, label %bb48.clone.i, !llvm.loop !36

vector.body90.preheader:                          ; preds = %bb63.clone.i
  br label %vector.body90

vector.body90:                                    ; preds = %vector.body90, %vector.body90.preheader
  %index93 = phi i64 [ 0, %vector.body90.preheader ], [ %index.next100.1, %vector.body90 ]
  %30 = getelementptr [128 x [128 x double]]* %tmp7, i64 %tmp43.clone.i, i64 %tmp45.clone.i, i64 %index93
  %31 = getelementptr [128 x [128 x double]]* %tmp3, i64 %tmp43.clone.i, i64 %tmp45.clone.i, i64 %index93
  %32 = bitcast double* %30 to <2 x double>*
  %wide.load105 = load <2 x double>* %32, align 8, !tbaa !2, !alias.scope !25, !noalias !28
  %.sum113 = or i64 %index93, 2
  %33 = getelementptr [128 x [128 x double]]* %tmp7, i64 %tmp43.clone.i, i64 %tmp45.clone.i, i64 %.sum113
  %34 = bitcast double* %33 to <2 x double>*
  %wide.load106 = load <2 x double>* %34, align 8, !tbaa !2, !alias.scope !25, !noalias !28
  %35 = bitcast double* %31 to <2 x double>*
  store <2 x double> %wide.load105, <2 x double>* %35, align 8, !tbaa !2, !alias.scope !31, !noalias !32
  %.sum114 = or i64 %index93, 2
  %36 = getelementptr [128 x [128 x double]]* %tmp3, i64 %tmp43.clone.i, i64 %tmp45.clone.i, i64 %.sum114
  %37 = bitcast double* %36 to <2 x double>*
  store <2 x double> %wide.load106, <2 x double>* %37, align 8, !tbaa !2, !alias.scope !31, !noalias !32
  %index.next100 = add i64 %index93, 4
  %38 = getelementptr [128 x [128 x double]]* %tmp7, i64 %tmp43.clone.i, i64 %tmp45.clone.i, i64 %index.next100
  %39 = getelementptr [128 x [128 x double]]* %tmp3, i64 %tmp43.clone.i, i64 %tmp45.clone.i, i64 %index.next100
  %40 = bitcast double* %38 to <2 x double>*
  %wide.load105.1 = load <2 x double>* %40, align 8, !tbaa !2, !alias.scope !25, !noalias !28
  %.sum113.1 = or i64 %index.next100, 2
  %41 = getelementptr [128 x [128 x double]]* %tmp7, i64 %tmp43.clone.i, i64 %tmp45.clone.i, i64 %.sum113.1
  %42 = bitcast double* %41 to <2 x double>*
  %wide.load106.1 = load <2 x double>* %42, align 8, !tbaa !2, !alias.scope !25, !noalias !28
  %43 = bitcast double* %39 to <2 x double>*
  store <2 x double> %wide.load105.1, <2 x double>* %43, align 8, !tbaa !2, !alias.scope !31, !noalias !32
  %.sum114.1 = or i64 %index.next100, 2
  %44 = getelementptr [128 x [128 x double]]* %tmp3, i64 %tmp43.clone.i, i64 %tmp45.clone.i, i64 %.sum114.1
  %45 = bitcast double* %44 to <2 x double>*
  store <2 x double> %wide.load106.1, <2 x double>* %45, align 8, !tbaa !2, !alias.scope !31, !noalias !32
  %index.next100.1 = add i64 %index.next100, 4
  %46 = icmp eq i64 %index.next100.1, 128
  br i1 %46, label %bb73.clone.i, label %vector.body90, !llvm.loop !37

bb73.clone.i:                                     ; preds = %vector.body90
  %tmp74.clone.i = add i64 %tmp45.clone.i, 1
  %tmp75.clone.i = icmp eq i64 %tmp74.clone.i, 128
  br i1 %tmp75.clone.i, label %bb76.clone.i, label %.preheader1.clone.i, !llvm.loop !38

bb76.clone.i:                                     ; preds = %bb73.clone.i
  %tmp77.clone.i = add i64 %tmp43.clone.i, 1
  %tmp78.clone.i = icmp eq i64 %tmp77.clone.i, 128
  br i1 %tmp78.clone.i, label %kernel_doitgen.exit.loopexit, label %.preheader2.clone.i, !llvm.loop !39

.preheader2.i24:                                  ; preds = %bb76.i, %.preheader2.i24.preheader
  %tmp43.i23 = phi i64 [ %tmp77.i, %bb76.i ], [ 0, %.preheader2.i24.preheader ]
  %47 = shl i64 %tmp43.i23, 17
  %48 = or i64 %47, 1016
  br label %.preheader1.i

.preheader1.i:                                    ; preds = %bb73.i, %.preheader2.i24
  %tmp45.i25 = phi i64 [ %tmp74.i, %bb73.i ], [ 0, %.preheader2.i24 ]
  %49 = shl i64 %tmp45.i25, 10
  %50 = add i64 %47, %49
  %scevgep = getelementptr i8* %tmp, i64 %50
  %51 = add i64 %48, %49
  %scevgep75 = getelementptr i8* %tmp, i64 %51
  %scevgep76 = getelementptr i8* %tmp1, i64 %50
  %scevgep77 = getelementptr i8* %tmp1, i64 %51
  br label %bb48.i

bb48.i:                                           ; preds = %bb63.i35, %.preheader1.i
  %tmp49.i26 = phi i64 [ %tmp64.i33, %bb63.i35 ], [ 0, %.preheader1.i ]
  %tmp50.i = getelementptr [128 x [128 x double]]* %tmp7, i64 %tmp43.i23, i64 %tmp45.i25, i64 %tmp49.i26
  store double 0.000000e+00, double* %tmp50.i, align 8, !tbaa !2, !llvm.loop !16
  br label %bb52.i

bb52.i:                                           ; preds = %bb52.i, %bb48.i
  %tmp56.i27 = phi double [ 0.000000e+00, %bb48.i ], [ %tmp60.i32.1, %bb52.i ]
  %tmp53.i28 = phi i64 [ 0, %bb48.i ], [ %tmp61.i.1, %bb52.i ]
  %tmp54.i = getelementptr [128 x [128 x double]]* %tmp3, i64 %tmp43.i23, i64 %tmp45.i25, i64 %tmp53.i28
  %tmp55.i29 = getelementptr [128 x double]* %tmp4, i64 %tmp53.i28, i64 %tmp49.i26
  %tmp57.i = load double* %tmp54.i, align 8, !tbaa !2
  %tmp58.i30 = load double* %tmp55.i29, align 8, !tbaa !2
  %tmp59.i31 = fmul double %tmp57.i, %tmp58.i30
  %tmp60.i32 = fadd double %tmp56.i27, %tmp59.i31
  store double %tmp60.i32, double* %tmp50.i, align 8, !tbaa !2, !llvm.loop !20
  %tmp61.i = add i64 %tmp53.i28, 1
  %tmp54.i.1 = getelementptr [128 x [128 x double]]* %tmp3, i64 %tmp43.i23, i64 %tmp45.i25, i64 %tmp61.i
  %tmp55.i29.1 = getelementptr [128 x double]* %tmp4, i64 %tmp61.i, i64 %tmp49.i26
  %tmp57.i.1 = load double* %tmp54.i.1, align 8, !tbaa !2
  %tmp58.i30.1 = load double* %tmp55.i29.1, align 8, !tbaa !2
  %tmp59.i31.1 = fmul double %tmp57.i.1, %tmp58.i30.1
  %tmp60.i32.1 = fadd double %tmp60.i32, %tmp59.i31.1
  store double %tmp60.i32.1, double* %tmp50.i, align 8, !tbaa !2, !llvm.loop !20
  %tmp61.i.1 = add i64 %tmp61.i, 1
  %tmp62.i.1 = icmp eq i64 %tmp61.i.1, 128
  br i1 %tmp62.i.1, label %bb63.i35, label %bb52.i, !llvm.loop !35

bb63.i35:                                         ; preds = %bb52.i
  %tmp64.i33 = add i64 %tmp49.i26, 1
  %tmp65.i34 = icmp eq i64 %tmp64.i33, 128
  br i1 %tmp65.i34, label %vector.memcheck, label %bb48.i, !llvm.loop !36

vector.memcheck:                                  ; preds = %bb63.i35
  %bound0 = icmp ule i8* %scevgep, %scevgep77
  %bound1 = icmp ule i8* %scevgep76, %scevgep75
  %memcheck.conflict = and i1 %bound0, %bound1
  br i1 %memcheck.conflict, label %middle.block71, label %vector.body70.preheader

vector.body70.preheader:                          ; preds = %vector.memcheck
  br label %vector.body70

vector.body70:                                    ; preds = %vector.body70, %vector.body70.preheader
  %index73 = phi i64 [ 0, %vector.body70.preheader ], [ %index.next83.1, %vector.body70 ]
  %52 = getelementptr [128 x [128 x double]]* %tmp7, i64 %tmp43.i23, i64 %tmp45.i25, i64 %index73
  %53 = getelementptr [128 x [128 x double]]* %tmp3, i64 %tmp43.i23, i64 %tmp45.i25, i64 %index73
  %54 = bitcast double* %52 to <2 x double>*
  %wide.load = load <2 x double>* %54, align 8, !tbaa !2
  %.sum111 = or i64 %index73, 2
  %55 = getelementptr [128 x [128 x double]]* %tmp7, i64 %tmp43.i23, i64 %tmp45.i25, i64 %.sum111
  %56 = bitcast double* %55 to <2 x double>*
  %wide.load86 = load <2 x double>* %56, align 8, !tbaa !2
  %57 = bitcast double* %53 to <2 x double>*
  store <2 x double> %wide.load, <2 x double>* %57, align 8, !tbaa !2
  %.sum112 = or i64 %index73, 2
  %58 = getelementptr [128 x [128 x double]]* %tmp3, i64 %tmp43.i23, i64 %tmp45.i25, i64 %.sum112
  %59 = bitcast double* %58 to <2 x double>*
  store <2 x double> %wide.load86, <2 x double>* %59, align 8, !tbaa !2
  %index.next83 = add i64 %index73, 4
  %60 = getelementptr [128 x [128 x double]]* %tmp7, i64 %tmp43.i23, i64 %tmp45.i25, i64 %index.next83
  %61 = getelementptr [128 x [128 x double]]* %tmp3, i64 %tmp43.i23, i64 %tmp45.i25, i64 %index.next83
  %62 = bitcast double* %60 to <2 x double>*
  %wide.load.1 = load <2 x double>* %62, align 8, !tbaa !2
  %.sum111.1 = or i64 %index.next83, 2
  %63 = getelementptr [128 x [128 x double]]* %tmp7, i64 %tmp43.i23, i64 %tmp45.i25, i64 %.sum111.1
  %64 = bitcast double* %63 to <2 x double>*
  %wide.load86.1 = load <2 x double>* %64, align 8, !tbaa !2
  %65 = bitcast double* %61 to <2 x double>*
  store <2 x double> %wide.load.1, <2 x double>* %65, align 8, !tbaa !2
  %.sum112.1 = or i64 %index.next83, 2
  %66 = getelementptr [128 x [128 x double]]* %tmp3, i64 %tmp43.i23, i64 %tmp45.i25, i64 %.sum112.1
  %67 = bitcast double* %66 to <2 x double>*
  store <2 x double> %wide.load86.1, <2 x double>* %67, align 8, !tbaa !2
  %index.next83.1 = add i64 %index.next83, 4
  %68 = icmp eq i64 %index.next83.1, 128
  br i1 %68, label %middle.block71.loopexit, label %vector.body70, !llvm.loop !40

middle.block71.loopexit:                          ; preds = %vector.body70
  br label %middle.block71

middle.block71:                                   ; preds = %middle.block71.loopexit, %vector.memcheck
  %resume.val78 = phi i1 [ false, %vector.memcheck ], [ true, %middle.block71.loopexit ]
  %trunc.resume.val79 = phi i64 [ 0, %vector.memcheck ], [ 128, %middle.block71.loopexit ]
  br i1 %resume.val78, label %bb73.i, label %bb66.i.preheader

bb66.i.preheader:                                 ; preds = %middle.block71
  %69 = sub i64 128, %trunc.resume.val79
  %xtraiter = and i64 %69, 3
  %lcmp.mod = icmp ne i64 %xtraiter, 0
  %lcmp.overflow = icmp eq i64 %69, 0
  %lcmp.or = or i1 %lcmp.overflow, %lcmp.mod
  br i1 %lcmp.or, label %unr.cmp130, label %bb66.i.preheader.split

unr.cmp130:                                       ; preds = %bb66.i.preheader
  %un.tmp131 = icmp eq i64 %xtraiter, 1
  br i1 %un.tmp131, label %bb66.i.unr123, label %unr.cmp

unr.cmp:                                          ; preds = %unr.cmp130
  %un.tmp = icmp eq i64 %xtraiter, 2
  br i1 %un.tmp, label %bb66.i.unr117, label %bb66.i.unr

bb66.i.unr:                                       ; preds = %unr.cmp
  %tmp68.i37.unr = getelementptr [128 x [128 x double]]* %tmp7, i64 %tmp43.i23, i64 %tmp45.i25, i64 %trunc.resume.val79
  %tmp69.i38.unr = getelementptr [128 x [128 x double]]* %tmp3, i64 %tmp43.i23, i64 %tmp45.i25, i64 %trunc.resume.val79
  %tmp70.i.unr = load double* %tmp68.i37.unr, align 8, !tbaa !2
  store double %tmp70.i.unr, double* %tmp69.i38.unr, align 8, !tbaa !2, !llvm.loop !41
  %tmp71.i39.unr = add i64 %trunc.resume.val79, 1
  %tmp72.i40.unr = icmp eq i64 %tmp71.i39.unr, 128
  br label %bb66.i.unr117

bb66.i.unr117:                                    ; preds = %bb66.i.unr, %unr.cmp
  %tmp67.i36.unr = phi i64 [ %tmp71.i39.unr, %bb66.i.unr ], [ %trunc.resume.val79, %unr.cmp ]
  %tmp68.i37.unr118 = getelementptr [128 x [128 x double]]* %tmp7, i64 %tmp43.i23, i64 %tmp45.i25, i64 %tmp67.i36.unr
  %tmp69.i38.unr119 = getelementptr [128 x [128 x double]]* %tmp3, i64 %tmp43.i23, i64 %tmp45.i25, i64 %tmp67.i36.unr
  %tmp70.i.unr120 = load double* %tmp68.i37.unr118, align 8, !tbaa !2
  store double %tmp70.i.unr120, double* %tmp69.i38.unr119, align 8, !tbaa !2, !llvm.loop !41
  %tmp71.i39.unr121 = add i64 %tmp67.i36.unr, 1
  %tmp72.i40.unr122 = icmp eq i64 %tmp71.i39.unr121, 128
  br label %bb66.i.unr123

bb66.i.unr123:                                    ; preds = %bb66.i.unr117, %unr.cmp130
  %tmp67.i36.unr124 = phi i64 [ %tmp71.i39.unr121, %bb66.i.unr117 ], [ %trunc.resume.val79, %unr.cmp130 ]
  %tmp68.i37.unr125 = getelementptr [128 x [128 x double]]* %tmp7, i64 %tmp43.i23, i64 %tmp45.i25, i64 %tmp67.i36.unr124
  %tmp69.i38.unr126 = getelementptr [128 x [128 x double]]* %tmp3, i64 %tmp43.i23, i64 %tmp45.i25, i64 %tmp67.i36.unr124
  %tmp70.i.unr127 = load double* %tmp68.i37.unr125, align 8, !tbaa !2
  store double %tmp70.i.unr127, double* %tmp69.i38.unr126, align 8, !tbaa !2, !llvm.loop !41
  %tmp71.i39.unr128 = add i64 %tmp67.i36.unr124, 1
  %tmp72.i40.unr129 = icmp eq i64 %tmp71.i39.unr128, 128
  br label %bb66.i.preheader.split

bb66.i.preheader.split:                           ; preds = %bb66.i.unr123, %bb66.i.preheader
  %tmp67.i36.unr132 = phi i64 [ %trunc.resume.val79, %bb66.i.preheader ], [ %tmp71.i39.unr128, %bb66.i.unr123 ]
  %70 = icmp ult i64 %69, 4
  br i1 %70, label %bb73.i.loopexit, label %bb66.i.preheader.split.split

bb66.i.preheader.split.split:                     ; preds = %bb66.i.preheader.split
  br label %bb66.i

bb66.i:                                           ; preds = %bb66.i, %bb66.i.preheader.split.split
  %tmp67.i36 = phi i64 [ %tmp67.i36.unr132, %bb66.i.preheader.split.split ], [ %tmp71.i39.3, %bb66.i ]
  %tmp68.i37 = getelementptr [128 x [128 x double]]* %tmp7, i64 %tmp43.i23, i64 %tmp45.i25, i64 %tmp67.i36
  %tmp69.i38 = getelementptr [128 x [128 x double]]* %tmp3, i64 %tmp43.i23, i64 %tmp45.i25, i64 %tmp67.i36
  %tmp70.i = load double* %tmp68.i37, align 8, !tbaa !2
  store double %tmp70.i, double* %tmp69.i38, align 8, !tbaa !2, !llvm.loop !41
  %tmp71.i39 = add i64 %tmp67.i36, 1
  %tmp68.i37.1 = getelementptr [128 x [128 x double]]* %tmp7, i64 %tmp43.i23, i64 %tmp45.i25, i64 %tmp71.i39
  %tmp69.i38.1 = getelementptr [128 x [128 x double]]* %tmp3, i64 %tmp43.i23, i64 %tmp45.i25, i64 %tmp71.i39
  %tmp70.i.1 = load double* %tmp68.i37.1, align 8, !tbaa !2
  store double %tmp70.i.1, double* %tmp69.i38.1, align 8, !tbaa !2, !llvm.loop !41
  %tmp71.i39.1 = add i64 %tmp71.i39, 1
  %tmp68.i37.2 = getelementptr [128 x [128 x double]]* %tmp7, i64 %tmp43.i23, i64 %tmp45.i25, i64 %tmp71.i39.1
  %tmp69.i38.2 = getelementptr [128 x [128 x double]]* %tmp3, i64 %tmp43.i23, i64 %tmp45.i25, i64 %tmp71.i39.1
  %tmp70.i.2 = load double* %tmp68.i37.2, align 8, !tbaa !2
  store double %tmp70.i.2, double* %tmp69.i38.2, align 8, !tbaa !2, !llvm.loop !41
  %tmp71.i39.2 = add i64 %tmp71.i39.1, 1
  %tmp68.i37.3 = getelementptr [128 x [128 x double]]* %tmp7, i64 %tmp43.i23, i64 %tmp45.i25, i64 %tmp71.i39.2
  %tmp69.i38.3 = getelementptr [128 x [128 x double]]* %tmp3, i64 %tmp43.i23, i64 %tmp45.i25, i64 %tmp71.i39.2
  %tmp70.i.3 = load double* %tmp68.i37.3, align 8, !tbaa !2
  store double %tmp70.i.3, double* %tmp69.i38.3, align 8, !tbaa !2, !llvm.loop !41
  %tmp71.i39.3 = add i64 %tmp71.i39.2, 1
  %tmp72.i40.3 = icmp eq i64 %tmp71.i39.3, 128
  br i1 %tmp72.i40.3, label %bb73.i.loopexit.unr-lcssa, label %bb66.i, !llvm.loop !42

bb73.i.loopexit.unr-lcssa:                        ; preds = %bb66.i
  br label %bb73.i.loopexit

bb73.i.loopexit:                                  ; preds = %bb73.i.loopexit.unr-lcssa, %bb66.i.preheader.split
  br label %bb73.i

bb73.i:                                           ; preds = %bb73.i.loopexit, %middle.block71
  %tmp74.i = add i64 %tmp45.i25, 1
  %tmp75.i41 = icmp eq i64 %tmp74.i, 128
  br i1 %tmp75.i41, label %bb76.i, label %.preheader1.i, !llvm.loop !38

bb76.i:                                           ; preds = %bb73.i
  %tmp77.i = add i64 %tmp43.i23, 1
  %tmp78.i = icmp eq i64 %tmp77.i, 128
  br i1 %tmp78.i, label %kernel_doitgen.exit.loopexit116, label %.preheader2.i24, !llvm.loop !39

kernel_doitgen.exit.loopexit:                     ; preds = %bb76.clone.i
  br label %kernel_doitgen.exit

kernel_doitgen.exit.loopexit116:                  ; preds = %bb76.i
  br label %kernel_doitgen.exit

kernel_doitgen.exit:                              ; preds = %kernel_doitgen.exit.loopexit116, %kernel_doitgen.exit.loopexit
  %tmp8 = icmp sgt i32 %argc, 42
  br i1 %tmp8, label %bb9, label %bb15, !llvm.loop !12

bb9:                                              ; preds = %kernel_doitgen.exit
  %tmp10 = load i8** %argv, align 8, !tbaa !14
  %tmp11 = load i8* %tmp10, align 1
  %tmp12 = icmp eq i8 %tmp11, 0
  br i1 %tmp12, label %.preheader4.i.preheader, label %bb15, !llvm.loop !6

.preheader4.i.preheader:                          ; preds = %bb9
  br label %.preheader4.i

.preheader4.i:                                    ; preds = %bb43.i, %.preheader4.i.preheader
  %tmp21.i = phi i64 [ %tmp44.i19, %bb43.i ], [ 0, %.preheader4.i.preheader ]
  %tmp22.i = trunc i64 %tmp21.i to i32
  %tmp32.i16 = srem i32 %tmp22.i, 20
  %tmp33.i = icmp eq i32 %tmp32.i16, 0
  br i1 %tmp33.i, label %.preheader.split.us.us.i.preheader, label %.preheader..preheader.split_crit_edge.i.preheader

.preheader..preheader.split_crit_edge.i.preheader: ; preds = %.preheader4.i
  br label %.preheader..preheader.split_crit_edge.i

.preheader.split.us.us.i.preheader:               ; preds = %.preheader4.i
  br label %.preheader.split.us.us.i

bb40.us.i:                                        ; preds = %bb37.us.us.i
  %tmp41.us.i = add i64 %tmp24.us.i, 1
  %tmp42.us.i = icmp eq i64 %tmp41.us.i, 128
  br i1 %tmp42.us.i, label %bb43.i.loopexit, label %.preheader.split.us.us.i, !llvm.loop !43

bb37.us.us.i:                                     ; preds = %.preheader.split.us.us.i, %bb37.us.us.i
  %tmp27.us.us.i = phi i64 [ %tmp38.us.us.i, %bb37.us.us.i ], [ 0, %.preheader.split.us.us.i ]
  %tmp28.us.us.i = getelementptr [128 x [128 x double]]* %tmp3, i64 %tmp21.i, i64 %tmp24.us.i, i64 %tmp27.us.us.i
  %tmp29.us.us.i = load %struct.__sFILE** @__stderrp, align 8, !tbaa !14
  %tmp30.us.us.i = load double* %tmp28.us.us.i, align 8, !tbaa !2
  %tmp31.us.us.i = tail call i32 (%struct.__sFILE*, i8*, ...)* @fprintf(%struct.__sFILE* %tmp29.us.us.i, i8* getelementptr inbounds ([8 x i8]* @.str11, i64 0, i64 0), double %tmp30.us.us.i) #4
  %tmp35.us.us.i = load %struct.__sFILE** @__stderrp, align 8, !tbaa !14
  %tmp36.us.us.i = tail call i32 @fputc(i32 10, %struct.__sFILE* %tmp35.us.us.i) #4
  %tmp38.us.us.i = add i64 %tmp27.us.us.i, 1
  %tmp39.us.us.i = icmp eq i64 %tmp38.us.us.i, 128
  br i1 %tmp39.us.us.i, label %bb40.us.i, label %bb37.us.us.i, !llvm.loop !11

.preheader.split.us.us.i:                         ; preds = %bb40.us.i, %.preheader.split.us.us.i.preheader
  %tmp24.us.i = phi i64 [ %tmp41.us.i, %bb40.us.i ], [ 0, %.preheader.split.us.us.i.preheader ]
  br label %bb37.us.us.i

.preheader..preheader.split_crit_edge.i:          ; preds = %bb40.i, %.preheader..preheader.split_crit_edge.i.preheader
  %tmp24.i = phi i64 [ %tmp41.i, %bb40.i ], [ 0, %.preheader..preheader.split_crit_edge.i.preheader ]
  br label %bb37.i

bb37.i:                                           ; preds = %bb37.i, %.preheader..preheader.split_crit_edge.i
  %tmp27.i = phi i64 [ %tmp38.i17, %bb37.i ], [ 0, %.preheader..preheader.split_crit_edge.i ]
  %tmp28.i = getelementptr [128 x [128 x double]]* %tmp3, i64 %tmp21.i, i64 %tmp24.i, i64 %tmp27.i
  %tmp29.i = load %struct.__sFILE** @__stderrp, align 8, !tbaa !14
  %tmp30.i = load double* %tmp28.i, align 8, !tbaa !2
  %tmp31.i = tail call i32 (%struct.__sFILE*, i8*, ...)* @fprintf(%struct.__sFILE* %tmp29.i, i8* getelementptr inbounds ([8 x i8]* @.str11, i64 0, i64 0), double %tmp30.i) #4
  %tmp38.i17 = add i64 %tmp27.i, 1
  %tmp39.i = icmp eq i64 %tmp38.i17, 128
  br i1 %tmp39.i, label %bb40.i, label %bb37.i, !llvm.loop !11

bb40.i:                                           ; preds = %bb37.i
  %tmp41.i = add i64 %tmp24.i, 1
  %tmp42.i18 = icmp eq i64 %tmp41.i, 128
  br i1 %tmp42.i18, label %bb43.i.loopexit115, label %.preheader..preheader.split_crit_edge.i, !llvm.loop !43

bb43.i.loopexit:                                  ; preds = %bb40.us.i
  br label %bb43.i

bb43.i.loopexit115:                               ; preds = %bb40.i
  br label %bb43.i

bb43.i:                                           ; preds = %bb43.i.loopexit115, %bb43.i.loopexit
  %tmp44.i19 = add i64 %tmp21.i, 1
  %tmp45.i20 = icmp eq i64 %tmp44.i19, 128
  br i1 %tmp45.i20, label %print_array.exit, label %.preheader4.i, !llvm.loop !20

print_array.exit:                                 ; preds = %bb43.i
  %tmp47.i21 = load %struct.__sFILE** @__stderrp, align 8, !tbaa !14
  %tmp48.i22 = tail call i32 @fputc(i32 10, %struct.__sFILE* %tmp47.i21) #4
  br label %bb15, !llvm.loop !8

bb15:                                             ; preds = %print_array.exit, %bb9, %kernel_doitgen.exit
  tail call void @free(i8* %tmp), !llvm.loop !9
  tail call void @free(i8* %tmp1), !llvm.loop !10
  tail call void @free(i8* %tmp2), !llvm.loop !11
  ret i32 0, !llvm.loop !16
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
!17 = metadata !{metadata !17, metadata !18, metadata !19}
!18 = metadata !{metadata !"llvm.loop.vectorize.width", i32 1}
!19 = metadata !{metadata !"llvm.loop.interleave.count", i32 1}
!20 = metadata !{metadata !"void14"}
!21 = metadata !{metadata !"void16"}
!22 = metadata !{metadata !"void19"}
!23 = metadata !{metadata !23, metadata !18, metadata !19}
!24 = metadata !{metadata !"void22"}
!25 = metadata !{metadata !26}
!26 = metadata !{metadata !26, metadata !27, metadata !"kernel_doitgen: %sum"}
!27 = metadata !{metadata !27, metadata !"kernel_doitgen"}
!28 = metadata !{metadata !29, metadata !30}
!29 = metadata !{metadata !29, metadata !27, metadata !"kernel_doitgen: %A"}
!30 = metadata !{metadata !30, metadata !27, metadata !"kernel_doitgen: %C4"}
!31 = metadata !{metadata !29}
!32 = metadata !{metadata !30, metadata !26}
!33 = metadata !{metadata !30}
!34 = metadata !{metadata !29, metadata !26}
!35 = metadata !{metadata !"void15"}
!36 = metadata !{metadata !"void17"}
!37 = metadata !{metadata !37, metadata !18, metadata !19}
!38 = metadata !{metadata !"void21"}
!39 = metadata !{metadata !"void23"}
!40 = metadata !{metadata !40, metadata !18, metadata !19}
!41 = metadata !{metadata !"void18"}
!42 = metadata !{metadata !42, metadata !18, metadata !19}
!43 = metadata !{metadata !"void12"}
