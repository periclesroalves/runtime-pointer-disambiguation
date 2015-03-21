; ModuleID = './datamining/correlation/correlation.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [5 x i8] c"corr\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %float_n = alloca double, align 8
  %0 = tail call i8* @polybench_alloc_data(i64 1680000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 1440000, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 1200, i32 8) #3
  %3 = tail call i8* @polybench_alloc_data(i64 1200, i32 8) #3
  %4 = bitcast i8* %0 to [1200 x double]*
  call void @init_array(i32 1200, i32 1400, double* %float_n, [1200 x double]* %4)
  call void (...)* @polybench_timer_start() #3
  %5 = load double* %float_n, align 8, !tbaa !1
  %6 = bitcast i8* %1 to [1200 x double]*
  %7 = bitcast i8* %2 to double*
  %8 = bitcast i8* %3 to double*
  call void @kernel_correlation(i32 1200, i32 1400, double %5, [1200 x double]* %4, [1200 x double]* %6, double* %7, double* %8)
  call void (...)* @polybench_timer_stop() #3
  call void (...)* @polybench_timer_print() #3
  %9 = icmp sgt i32 %argc, 42
  br i1 %9, label %10, label %14

; <label>:10                                      ; preds = %.split
  %11 = load i8** %argv, align 8, !tbaa !5
  %12 = load i8* %11, align 1, !tbaa !7
  %phitmp = icmp eq i8 %12, 0
  br i1 %phitmp, label %13, label %14

; <label>:13                                      ; preds = %10
  call void @print_array(i32 1200, [1200 x double]* %6)
  br label %14

; <label>:14                                      ; preds = %10, %13, %.split
  call void @free(i8* %0) #3
  call void @free(i8* %1) #3
  call void @free(i8* %2) #3
  call void @free(i8* %3) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %m, i32 %n, double* %float_n, [1200 x double]* %data) #0 {
.split:
  store double 1.400000e+03, double* %float_n, align 8, !tbaa !1
  br label %polly.loop_preheader9

polly.loop_exit:                                  ; preds = %polly.loop_exit10
  ret void

polly.loop_exit10:                                ; preds = %polly.loop_exit17
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, 1367
  br i1 %polly.loop_cond, label %polly.loop_preheader9, label %polly.loop_exit

polly.loop_header8:                               ; preds = %polly.loop_exit17, %polly.loop_preheader9
  %polly.indvar11 = phi i64 [ 0, %polly.loop_preheader9 ], [ %polly.indvar_next12, %polly.loop_exit17 ]
  %0 = add i64 %polly.indvar, 31
  %1 = icmp slt i64 1399, %0
  %2 = select i1 %1, i64 1399, i64 %0
  %polly.loop_guard = icmp sle i64 %polly.indvar, %2
  br i1 %polly.loop_guard, label %polly.loop_header15, label %polly.loop_exit17

polly.loop_exit17:                                ; preds = %polly.loop_exit24, %polly.loop_header8
  %polly.indvar_next12 = add nsw i64 %polly.indvar11, 32
  %polly.loop_cond13 = icmp sle i64 %polly.indvar11, 1167
  br i1 %polly.loop_cond13, label %polly.loop_header8, label %polly.loop_exit10

polly.loop_preheader9:                            ; preds = %polly.loop_exit10, %.split
  %polly.indvar = phi i64 [ 0, %.split ], [ %polly.indvar_next, %polly.loop_exit10 ]
  br label %polly.loop_header8

polly.loop_header15:                              ; preds = %polly.loop_header8, %polly.loop_exit24
  %polly.indvar18 = phi i64 [ %polly.indvar_next19, %polly.loop_exit24 ], [ %polly.indvar, %polly.loop_header8 ]
  %3 = add i64 %polly.indvar11, 31
  %4 = icmp slt i64 1199, %3
  %5 = select i1 %4, i64 1199, i64 %3
  %polly.loop_guard25 = icmp sle i64 %polly.indvar11, %5
  br i1 %polly.loop_guard25, label %polly.loop_header22, label %polly.loop_exit24

polly.loop_exit24:                                ; preds = %polly.loop_header22, %polly.loop_header15
  %polly.indvar_next19 = add nsw i64 %polly.indvar18, 1
  %polly.adjust_ub = sub i64 %2, 1
  %polly.loop_cond20 = icmp sle i64 %polly.indvar18, %polly.adjust_ub
  br i1 %polly.loop_cond20, label %polly.loop_header15, label %polly.loop_exit17

polly.loop_header22:                              ; preds = %polly.loop_header15, %polly.loop_header22
  %polly.indvar26 = phi i64 [ %polly.indvar_next27, %polly.loop_header22 ], [ %polly.indvar11, %polly.loop_header15 ]
  %p_i.02.moved.to. = trunc i64 %polly.indvar18 to i32
  %p_.moved.to. = sitofp i32 %p_i.02.moved.to. to double
  %p_scevgep = getelementptr [1200 x double]* %data, i64 %polly.indvar18, i64 %polly.indvar26
  %p_ = mul i64 %polly.indvar18, %polly.indvar26
  %p_30 = trunc i64 %p_ to i32
  %p_31 = sitofp i32 %p_30 to double
  %p_32 = fdiv double %p_31, 1.200000e+03
  %p_33 = fadd double %p_.moved.to., %p_32
  store double %p_33, double* %p_scevgep
  %p_indvar.next = add i64 %polly.indvar26, 1
  %polly.indvar_next27 = add nsw i64 %polly.indvar26, 1
  %polly.adjust_ub28 = sub i64 %5, 1
  %polly.loop_cond29 = icmp sle i64 %polly.indvar26, %polly.adjust_ub28
  br i1 %polly.loop_cond29, label %polly.loop_header22, label %polly.loop_exit24
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_correlation(i32 %m, i32 %n, double %float_n, [1200 x double]* %data, [1200 x double]* %corr, double* %mean, double* %stddev) #0 {
.split:
  %0 = icmp sgt i32 %m, 0
  br i1 %0, label %.lr.ph31, label %.preheader3

.lr.ph31:                                         ; preds = %.split
  %1 = zext i32 %n to i64
  %2 = zext i32 %m to i64
  %3 = icmp sgt i32 %n, 0
  br label %7

.preheader3:                                      ; preds = %._crit_edge27, %.split
  br i1 %0, label %.lr.ph23, label %.preheader2

.lr.ph23:                                         ; preds = %.preheader3
  %4 = zext i32 %n to i64
  %5 = zext i32 %m to i64
  %6 = icmp sgt i32 %n, 0
  br label %16

; <label>:7                                       ; preds = %.lr.ph31, %._crit_edge27
  %indvar70 = phi i64 [ 0, %.lr.ph31 ], [ %indvar.next71, %._crit_edge27 ]
  %scevgep75 = getelementptr double* %mean, i64 %indvar70
  store double 0.000000e+00, double* %scevgep75, align 8, !tbaa !1
  br i1 %3, label %.lr.ph26, label %._crit_edge27

.lr.ph26:                                         ; preds = %7, %.lr.ph26
  %indvar67 = phi i64 [ %indvar.next68, %.lr.ph26 ], [ 0, %7 ]
  %scevgep72 = getelementptr [1200 x double]* %data, i64 %indvar67, i64 %indvar70
  %8 = load double* %scevgep72, align 8, !tbaa !1
  %9 = load double* %scevgep75, align 8, !tbaa !1
  %10 = fadd double %8, %9
  store double %10, double* %scevgep75, align 8, !tbaa !1
  %indvar.next68 = add i64 %indvar67, 1
  %exitcond69 = icmp ne i64 %indvar.next68, %1
  br i1 %exitcond69, label %.lr.ph26, label %._crit_edge27

._crit_edge27:                                    ; preds = %.lr.ph26, %7
  %11 = load double* %scevgep75, align 8, !tbaa !1
  %12 = fdiv double %11, %float_n
  store double %12, double* %scevgep75, align 8, !tbaa !1
  %indvar.next71 = add i64 %indvar70, 1
  %exitcond73 = icmp ne i64 %indvar.next71, %2
  br i1 %exitcond73, label %7, label %.preheader3

.preheader2:                                      ; preds = %28, %.preheader3
  %13 = icmp sgt i32 %n, 0
  br i1 %13, label %.preheader1.lr.ph, label %.preheader

.preheader1.lr.ph:                                ; preds = %.preheader2
  %14 = zext i32 %m to i64
  %15 = zext i32 %n to i64
  br label %.preheader1

; <label>:16                                      ; preds = %.lr.ph23, %28
  %indvar60 = phi i64 [ 0, %.lr.ph23 ], [ %indvar.next61, %28 ]
  %scevgep65 = getelementptr double* %stddev, i64 %indvar60
  %scevgep66 = getelementptr double* %mean, i64 %indvar60
  store double 0.000000e+00, double* %scevgep65, align 8, !tbaa !1
  br i1 %6, label %.lr.ph20, label %._crit_edge21

.lr.ph20:                                         ; preds = %16, %.lr.ph20
  %indvar57 = phi i64 [ %indvar.next58, %.lr.ph20 ], [ 0, %16 ]
  %scevgep62 = getelementptr [1200 x double]* %data, i64 %indvar57, i64 %indvar60
  %17 = load double* %scevgep62, align 8, !tbaa !1
  %18 = load double* %scevgep66, align 8, !tbaa !1
  %19 = fsub double %17, %18
  %20 = fmul double %19, %19
  %21 = load double* %scevgep65, align 8, !tbaa !1
  %22 = fadd double %21, %20
  store double %22, double* %scevgep65, align 8, !tbaa !1
  %indvar.next58 = add i64 %indvar57, 1
  %exitcond59 = icmp ne i64 %indvar.next58, %4
  br i1 %exitcond59, label %.lr.ph20, label %._crit_edge21

._crit_edge21:                                    ; preds = %.lr.ph20, %16
  %23 = load double* %scevgep65, align 8, !tbaa !1
  %24 = fdiv double %23, %float_n
  store double %24, double* %scevgep65, align 8, !tbaa !1
  %25 = tail call double @sqrt(double %24) #3
  store double %25, double* %scevgep65, align 8, !tbaa !1
  %26 = fcmp ugt double %25, 1.000000e-01
  br i1 %26, label %27, label %28

; <label>:27                                      ; preds = %._crit_edge21
  br label %28

; <label>:28                                      ; preds = %._crit_edge21, %27
  %.reg2mem.0 = phi double [ %25, %27 ], [ 1.000000e+00, %._crit_edge21 ]
  store double %.reg2mem.0, double* %scevgep65, align 8, !tbaa !1
  %indvar.next61 = add i64 %indvar60, 1
  %exitcond63 = icmp ne i64 %indvar.next61, %5
  br i1 %exitcond63, label %16, label %.preheader2

.preheader1:                                      ; preds = %.preheader1.lr.ph, %._crit_edge16
  %indvar51 = phi i64 [ 0, %.preheader1.lr.ph ], [ %indvar.next52, %._crit_edge16 ]
  br i1 %0, label %.lr.ph15, label %._crit_edge16

.preheader:                                       ; preds = %._crit_edge16, %.preheader2
  %29 = add nsw i32 %m, -1
  %30 = icmp sgt i32 %29, 0
  br i1 %30, label %.lr.ph12, label %._crit_edge13

.lr.ph12:                                         ; preds = %.preheader
  %31 = zext i32 %n to i64
  %32 = add i32 %m, -2
  %33 = add i32 %m, -1
  %34 = zext i32 %33 to i64
  %35 = zext i32 %32 to i64
  br label %44

.lr.ph15:                                         ; preds = %.preheader1, %.lr.ph15
  %indvar47 = phi i64 [ %indvar.next48, %.lr.ph15 ], [ 0, %.preheader1 ]
  %scevgep53 = getelementptr [1200 x double]* %data, i64 %indvar51, i64 %indvar47
  %scevgep50 = getelementptr double* %mean, i64 %indvar47
  %scevgep54 = getelementptr double* %stddev, i64 %indvar47
  %36 = load double* %scevgep50, align 8, !tbaa !1
  %37 = load double* %scevgep53, align 8, !tbaa !1
  %38 = fsub double %37, %36
  store double %38, double* %scevgep53, align 8, !tbaa !1
  %39 = tail call double @sqrt(double %float_n) #3
  %40 = load double* %scevgep54, align 8, !tbaa !1
  %41 = fmul double %39, %40
  %42 = load double* %scevgep53, align 8, !tbaa !1
  %43 = fdiv double %42, %41
  store double %43, double* %scevgep53, align 8, !tbaa !1
  %indvar.next48 = add i64 %indvar47, 1
  %exitcond49 = icmp ne i64 %indvar.next48, %14
  br i1 %exitcond49, label %.lr.ph15, label %._crit_edge16

._crit_edge16:                                    ; preds = %.lr.ph15, %.preheader1
  %indvar.next52 = add i64 %indvar51, 1
  %exitcond55 = icmp ne i64 %indvar.next52, %15
  br i1 %exitcond55, label %.preheader1, label %.preheader

; <label>:44                                      ; preds = %.lr.ph12, %._crit_edge10
  %indvar32 = phi i64 [ 0, %.lr.ph12 ], [ %47, %._crit_edge10 ]
  %45 = mul i64 %indvar32, 1201
  %46 = add i64 %45, 1
  %47 = add i64 %indvar32, 1
  %j.36 = trunc i64 %47 to i32
  %48 = mul i64 %indvar32, -1
  %49 = add i64 %35, %48
  %50 = trunc i64 %49 to i32
  %scevgep46 = getelementptr [1200 x double]* %corr, i64 0, i64 %45
  %51 = zext i32 %50 to i64
  %52 = add i64 %51, 1
  store double 1.000000e+00, double* %scevgep46, align 8, !tbaa !1
  %53 = icmp slt i32 %j.36, %m
  br i1 %53, label %.lr.ph9, label %._crit_edge10

.lr.ph9:                                          ; preds = %44, %._crit_edge
  %indvar34 = phi i64 [ %55, %._crit_edge ], [ 0, %44 ]
  %54 = add i64 %46, %indvar34
  %scevgep40 = getelementptr [1200 x double]* %corr, i64 0, i64 %54
  %55 = add i64 %indvar34, 1
  %scevgep39 = getelementptr [1200 x double]* %corr, i64 %55, i64 %45
  %56 = add i64 %47, %indvar34
  store double 0.000000e+00, double* %scevgep40, align 8, !tbaa !1
  br i1 %13, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %.lr.ph9, %.lr.ph
  %indvar = phi i64 [ %indvar.next, %.lr.ph ], [ 0, %.lr.ph9 ]
  %scevgep36 = getelementptr [1200 x double]* %data, i64 %indvar, i64 %56
  %scevgep = getelementptr [1200 x double]* %data, i64 %indvar, i64 %indvar32
  %57 = load double* %scevgep, align 8, !tbaa !1
  %58 = load double* %scevgep36, align 8, !tbaa !1
  %59 = fmul double %57, %58
  %60 = load double* %scevgep40, align 8, !tbaa !1
  %61 = fadd double %60, %59
  store double %61, double* %scevgep40, align 8, !tbaa !1
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %31
  br i1 %exitcond, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %.lr.ph9
  %62 = load double* %scevgep40, align 8, !tbaa !1
  store double %62, double* %scevgep39, align 8, !tbaa !1
  %exitcond37 = icmp ne i64 %55, %52
  br i1 %exitcond37, label %.lr.ph9, label %._crit_edge10

._crit_edge10:                                    ; preds = %._crit_edge, %44
  %exitcond41 = icmp ne i64 %47, %34
  br i1 %exitcond41, label %44, label %._crit_edge13

._crit_edge13:                                    ; preds = %._crit_edge10, %.preheader
  %63 = sext i32 %29 to i64
  %64 = getelementptr inbounds [1200 x double]* %corr, i64 %63, i64 %63
  store double 1.000000e+00, double* %64, align 8, !tbaa !1
  ret void
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %m, [1200 x double]* %corr) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([5 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %m, 0
  br i1 %5, label %.preheader.lr.ph, label %22

.preheader.lr.ph:                                 ; preds = %.split
  %6 = zext i32 %m to i64
  %7 = zext i32 %m to i64
  %8 = icmp sgt i32 %m, 0
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %21
  %indvar4 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next5, %21 ]
  %9 = mul i64 %7, %indvar4
  br i1 %8, label %.lr.ph, label %21

.lr.ph:                                           ; preds = %.preheader
  br label %10

; <label>:10                                      ; preds = %.lr.ph, %17
  %indvar = phi i64 [ 0, %.lr.ph ], [ %indvar.next, %17 ]
  %11 = add i64 %9, %indvar
  %12 = trunc i64 %11 to i32
  %scevgep = getelementptr [1200 x double]* %corr, i64 %indvar4, i64 %indvar
  %13 = srem i32 %12, 20
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %15, label %17

; <label>:15                                      ; preds = %10
  %16 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %16) #4
  br label %17

; <label>:17                                      ; preds = %15, %10
  %18 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %19 = load double* %scevgep, align 8, !tbaa !1
  %20 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %18, i8* getelementptr inbounds ([8 x i8]* @.str5, i64 0, i64 0), double %19) #5
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %6
  br i1 %exitcond, label %10, label %._crit_edge

._crit_edge:                                      ; preds = %17
  br label %21

; <label>:21                                      ; preds = %._crit_edge, %.preheader
  %indvar.next5 = add i64 %indvar4, 1
  %exitcond6 = icmp ne i64 %indvar.next5, %7
  br i1 %exitcond6, label %.preheader, label %._crit_edge3

._crit_edge3:                                     ; preds = %21
  br label %22

; <label>:22                                      ; preds = %._crit_edge3, %.split
  %23 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %24 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([5 x i8]* @.str3, i64 0, i64 0)) #5
  %25 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %26 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str7, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %25) #4
  ret void
}

; Function Attrs: nounwind
declare void @free(i8*) #2

declare i32 @fprintf(%struct._IO_FILE*, i8*, ...) #1

; Function Attrs: nounwind
declare double @sqrt(double) #2

; Function Attrs: nounwind
declare i64 @fwrite(i8* nocapture, i64, i64, %struct._IO_FILE* nocapture) #3

; Function Attrs: nounwind
declare i32 @fputc(i32, %struct._IO_FILE* nocapture) #3

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }
attributes #4 = { cold }
attributes #5 = { cold nounwind }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.6.0 (trunk)"}
!1 = metadata !{metadata !2, metadata !2, i64 0}
!2 = metadata !{metadata !"double", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{metadata !6, metadata !6, i64 0}
!6 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!7 = metadata !{metadata !3, metadata !3, i64 0}
