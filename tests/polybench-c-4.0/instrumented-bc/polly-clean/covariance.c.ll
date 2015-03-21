; ModuleID = './datamining/covariance/covariance.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [4 x i8] c"cov\00", align 1
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
  %3 = bitcast i8* %0 to [1200 x double]*
  call void @init_array(i32 1200, i32 1400, double* %float_n, [1200 x double]* %3)
  call void (...)* @polybench_timer_start() #3
  %4 = load double* %float_n, align 8, !tbaa !1
  %5 = bitcast i8* %1 to [1200 x double]*
  %6 = bitcast i8* %2 to double*
  call void @kernel_covariance(i32 1200, i32 1400, double %4, [1200 x double]* %3, [1200 x double]* %5, double* %6)
  call void (...)* @polybench_timer_stop() #3
  call void (...)* @polybench_timer_print() #3
  %7 = icmp sgt i32 %argc, 42
  br i1 %7, label %8, label %12

; <label>:8                                       ; preds = %.split
  %9 = load i8** %argv, align 8, !tbaa !5
  %10 = load i8* %9, align 1, !tbaa !7
  %phitmp = icmp eq i8 %10, 0
  br i1 %phitmp, label %11, label %12

; <label>:11                                      ; preds = %8
  call void @print_array(i32 1200, [1200 x double]* %5)
  br label %12

; <label>:12                                      ; preds = %8, %11, %.split
  call void @free(i8* %0) #3
  call void @free(i8* %1) #3
  call void @free(i8* %2) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %m, i32 %n, double* %float_n, [1200 x double]* %data) #0 {
.split:
  %0 = sitofp i32 %n to double
  store double %0, double* %float_n, align 8, !tbaa !1
  br label %polly.loop_preheader9

polly.loop_exit:                                  ; preds = %polly.loop_exit10
  ret void

polly.loop_exit10:                                ; preds = %polly.loop_exit17
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, 1367
  br i1 %polly.loop_cond, label %polly.loop_preheader9, label %polly.loop_exit

polly.loop_header8:                               ; preds = %polly.loop_exit17, %polly.loop_preheader9
  %polly.indvar11 = phi i64 [ 0, %polly.loop_preheader9 ], [ %polly.indvar_next12, %polly.loop_exit17 ]
  %1 = add i64 %polly.indvar, 31
  %2 = icmp slt i64 1399, %1
  %3 = select i1 %2, i64 1399, i64 %1
  %polly.loop_guard = icmp sle i64 %polly.indvar, %3
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
  %4 = add i64 %polly.indvar11, 31
  %5 = icmp slt i64 1199, %4
  %6 = select i1 %5, i64 1199, i64 %4
  %polly.loop_guard25 = icmp sle i64 %polly.indvar11, %6
  br i1 %polly.loop_guard25, label %polly.loop_header22, label %polly.loop_exit24

polly.loop_exit24:                                ; preds = %polly.loop_header22, %polly.loop_header15
  %polly.indvar_next19 = add nsw i64 %polly.indvar18, 1
  %polly.adjust_ub = sub i64 %3, 1
  %polly.loop_cond20 = icmp sle i64 %polly.indvar18, %polly.adjust_ub
  br i1 %polly.loop_cond20, label %polly.loop_header15, label %polly.loop_exit17

polly.loop_header22:                              ; preds = %polly.loop_header15, %polly.loop_header22
  %polly.indvar26 = phi i64 [ %polly.indvar_next27, %polly.loop_header22 ], [ %polly.indvar11, %polly.loop_header15 ]
  %p_i.02.moved.to. = trunc i64 %polly.indvar18 to i32
  %p_.moved.to. = sitofp i32 %p_i.02.moved.to. to double
  %p_scevgep = getelementptr [1200 x double]* %data, i64 %polly.indvar18, i64 %polly.indvar26
  %p_j.01 = trunc i64 %polly.indvar26 to i32
  %p_ = sitofp i32 %p_j.01 to double
  %p_30 = fmul double %p_.moved.to., %p_
  %p_31 = fdiv double %p_30, 1.200000e+03
  store double %p_31, double* %p_scevgep
  %p_indvar.next = add i64 %polly.indvar26, 1
  %polly.indvar_next27 = add nsw i64 %polly.indvar26, 1
  %polly.adjust_ub28 = sub i64 %6, 1
  %polly.loop_cond29 = icmp sle i64 %polly.indvar26, %polly.adjust_ub28
  br i1 %polly.loop_cond29, label %polly.loop_header22, label %polly.loop_exit24
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_covariance(i32 %m, i32 %n, double %float_n, [1200 x double]* %data, [1200 x double]* %cov, double* %mean) #0 {
.split:
  %0 = icmp sgt i32 %m, 0
  br i1 %0, label %.lr.ph20, label %.preheader3

.lr.ph20:                                         ; preds = %.split
  %1 = zext i32 %n to i64
  %2 = zext i32 %m to i64
  %3 = icmp sgt i32 %n, 0
  br label %7

.preheader3:                                      ; preds = %._crit_edge17, %.split
  %4 = icmp sgt i32 %n, 0
  br i1 %4, label %.preheader2.lr.ph, label %.preheader1

.preheader2.lr.ph:                                ; preds = %.preheader3
  %5 = zext i32 %m to i64
  %6 = zext i32 %n to i64
  br label %.preheader2

; <label>:7                                       ; preds = %.lr.ph20, %._crit_edge17
  %indvar47 = phi i64 [ 0, %.lr.ph20 ], [ %indvar.next48, %._crit_edge17 ]
  %scevgep52 = getelementptr double* %mean, i64 %indvar47
  store double 0.000000e+00, double* %scevgep52, align 8, !tbaa !1
  br i1 %3, label %.lr.ph16, label %._crit_edge17

.lr.ph16:                                         ; preds = %7, %.lr.ph16
  %indvar44 = phi i64 [ %indvar.next45, %.lr.ph16 ], [ 0, %7 ]
  %scevgep49 = getelementptr [1200 x double]* %data, i64 %indvar44, i64 %indvar47
  %8 = load double* %scevgep49, align 8, !tbaa !1
  %9 = load double* %scevgep52, align 8, !tbaa !1
  %10 = fadd double %8, %9
  store double %10, double* %scevgep52, align 8, !tbaa !1
  %indvar.next45 = add i64 %indvar44, 1
  %exitcond46 = icmp ne i64 %indvar.next45, %1
  br i1 %exitcond46, label %.lr.ph16, label %._crit_edge17

._crit_edge17:                                    ; preds = %.lr.ph16, %7
  %11 = load double* %scevgep52, align 8, !tbaa !1
  %12 = fdiv double %11, %float_n
  store double %12, double* %scevgep52, align 8, !tbaa !1
  %indvar.next48 = add i64 %indvar47, 1
  %exitcond50 = icmp ne i64 %indvar.next48, %2
  br i1 %exitcond50, label %7, label %.preheader3

.preheader2:                                      ; preds = %.preheader2.lr.ph, %._crit_edge12
  %indvar39 = phi i64 [ 0, %.preheader2.lr.ph ], [ %indvar.next40, %._crit_edge12 ]
  br i1 %0, label %.lr.ph11, label %._crit_edge12

.preheader1:                                      ; preds = %._crit_edge12, %.preheader3
  br i1 %0, label %.preheader.lr.ph, label %._crit_edge9

.preheader.lr.ph:                                 ; preds = %.preheader1
  %13 = zext i32 %n to i64
  %14 = add i32 %m, -1
  %15 = zext i32 %m to i64
  %16 = zext i32 %14 to i64
  %17 = fadd double %float_n, -1.000000e+00
  br label %.preheader

.lr.ph11:                                         ; preds = %.preheader2, %.lr.ph11
  %indvar35 = phi i64 [ %indvar.next36, %.lr.ph11 ], [ 0, %.preheader2 ]
  %scevgep41 = getelementptr [1200 x double]* %data, i64 %indvar39, i64 %indvar35
  %scevgep38 = getelementptr double* %mean, i64 %indvar35
  %18 = load double* %scevgep38, align 8, !tbaa !1
  %19 = load double* %scevgep41, align 8, !tbaa !1
  %20 = fsub double %19, %18
  store double %20, double* %scevgep41, align 8, !tbaa !1
  %indvar.next36 = add i64 %indvar35, 1
  %exitcond37 = icmp ne i64 %indvar.next36, %5
  br i1 %exitcond37, label %.lr.ph11, label %._crit_edge12

._crit_edge12:                                    ; preds = %.lr.ph11, %.preheader2
  %indvar.next40 = add i64 %indvar39, 1
  %exitcond42 = icmp ne i64 %indvar.next40, %6
  br i1 %exitcond42, label %.preheader2, label %.preheader1

.preheader:                                       ; preds = %.preheader.lr.ph, %._crit_edge7
  %indvar21 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next22, %._crit_edge7 ]
  %i.28 = trunc i64 %indvar21 to i32
  %21 = mul i64 %indvar21, 1201
  %22 = mul i64 %indvar21, -1
  %23 = add i64 %16, %22
  %24 = trunc i64 %23 to i32
  %25 = zext i32 %24 to i64
  %26 = add i64 %25, 1
  %27 = icmp slt i32 %i.28, %m
  br i1 %27, label %.lr.ph6, label %._crit_edge7

.lr.ph6:                                          ; preds = %.preheader, %._crit_edge
  %indvar23 = phi i64 [ %indvar.next24, %._crit_edge ], [ 0, %.preheader ]
  %scevgep29 = getelementptr [1200 x double]* %cov, i64 %indvar23, i64 %21
  %28 = add i64 %21, %indvar23
  %scevgep28 = getelementptr [1200 x double]* %cov, i64 0, i64 %28
  %29 = add i64 %indvar21, %indvar23
  store double 0.000000e+00, double* %scevgep28, align 8, !tbaa !1
  br i1 %4, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %.lr.ph6, %.lr.ph
  %indvar = phi i64 [ %indvar.next, %.lr.ph ], [ 0, %.lr.ph6 ]
  %scevgep25 = getelementptr [1200 x double]* %data, i64 %indvar, i64 %29
  %scevgep = getelementptr [1200 x double]* %data, i64 %indvar, i64 %indvar21
  %30 = load double* %scevgep, align 8, !tbaa !1
  %31 = load double* %scevgep25, align 8, !tbaa !1
  %32 = fmul double %30, %31
  %33 = load double* %scevgep28, align 8, !tbaa !1
  %34 = fadd double %33, %32
  store double %34, double* %scevgep28, align 8, !tbaa !1
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %13
  br i1 %exitcond, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %.lr.ph6
  %35 = load double* %scevgep28, align 8, !tbaa !1
  %36 = fdiv double %35, %17
  store double %36, double* %scevgep28, align 8, !tbaa !1
  store double %36, double* %scevgep29, align 8, !tbaa !1
  %indvar.next24 = add i64 %indvar23, 1
  %exitcond26 = icmp ne i64 %indvar.next24, %26
  br i1 %exitcond26, label %.lr.ph6, label %._crit_edge7

._crit_edge7:                                     ; preds = %._crit_edge, %.preheader
  %indvar.next22 = add i64 %indvar21, 1
  %exitcond30 = icmp ne i64 %indvar.next22, %15
  br i1 %exitcond30, label %.preheader, label %._crit_edge9

._crit_edge9:                                     ; preds = %._crit_edge7, %.preheader1
  ret void
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %m, [1200 x double]* %cov) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([4 x i8]* @.str3, i64 0, i64 0)) #5
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
  %scevgep = getelementptr [1200 x double]* %cov, i64 %indvar4, i64 %indvar
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
  %24 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([4 x i8]* @.str3, i64 0, i64 0)) #5
  %25 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %26 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str7, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %25) #4
  ret void
}

; Function Attrs: nounwind
declare void @free(i8*) #2

declare i32 @fprintf(%struct._IO_FILE*, i8*, ...) #1

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
