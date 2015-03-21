; ModuleID = './linear-algebra/blas/symm/symm.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [2 x i8] c"C\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %alpha = alloca double, align 8
  %beta = alloca double, align 8
  %0 = tail call i8* @polybench_alloc_data(i64 1200000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 1000000, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 1200000, i32 8) #3
  %3 = bitcast i8* %0 to [1200 x double]*
  %4 = bitcast i8* %1 to [1000 x double]*
  %5 = bitcast i8* %2 to [1200 x double]*
  call void @init_array(i32 1000, i32 1200, double* %alpha, double* %beta, [1200 x double]* %3, [1000 x double]* %4, [1200 x double]* %5)
  call void (...)* @polybench_timer_start() #3
  %6 = load double* %alpha, align 8, !tbaa !1
  %7 = load double* %beta, align 8, !tbaa !1
  call void @kernel_symm(i32 1000, i32 1200, double %6, double %7, [1200 x double]* %3, [1000 x double]* %4, [1200 x double]* %5)
  call void (...)* @polybench_timer_stop() #3
  call void (...)* @polybench_timer_print() #3
  %8 = icmp sgt i32 %argc, 42
  br i1 %8, label %9, label %13

; <label>:9                                       ; preds = %.split
  %10 = load i8** %argv, align 8, !tbaa !5
  %11 = load i8* %10, align 1, !tbaa !7
  %phitmp = icmp eq i8 %11, 0
  br i1 %phitmp, label %12, label %13

; <label>:12                                      ; preds = %9
  call void @print_array(i32 1000, i32 1200, [1200 x double]* %3)
  br label %13

; <label>:13                                      ; preds = %9, %12, %.split
  call void @free(i8* %0) #3
  call void @free(i8* %1) #3
  call void @free(i8* %2) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %m, i32 %n, double* %alpha, double* %beta, [1200 x double]* %C, [1000 x double]* %A, [1200 x double]* %B) #0 {
.split:
  store double 1.500000e+00, double* %alpha, align 8, !tbaa !1
  store double 1.200000e+00, double* %beta, align 8, !tbaa !1
  %0 = icmp sgt i32 %m, 0
  br i1 %0, label %.preheader3.lr.ph, label %.preheader2

.preheader3.lr.ph:                                ; preds = %.split
  %1 = zext i32 %n to i64
  %2 = zext i32 %m to i64
  %3 = icmp sgt i32 %n, 0
  %4 = sitofp i32 %m to double
  br label %.preheader3

.preheader3:                                      ; preds = %.preheader3.lr.ph, %._crit_edge12
  %indvar27 = phi i64 [ 0, %.preheader3.lr.ph ], [ %indvar.next28, %._crit_edge12 ]
  %5 = add i64 %1, %indvar27
  br i1 %3, label %.lr.ph11, label %._crit_edge12

.preheader2:                                      ; preds = %._crit_edge12, %.split
  br i1 %0, label %.preheader1.lr.ph, label %._crit_edge9

.preheader1.lr.ph:                                ; preds = %.preheader2
  %6 = add i32 %m, -2
  %7 = zext i32 %m to i64
  %8 = zext i32 %6 to i64
  %9 = sitofp i32 %m to double
  br label %.preheader1

.lr.ph11:                                         ; preds = %.preheader3, %.lr.ph11
  %indvar24 = phi i64 [ %indvar.next25, %.lr.ph11 ], [ 0, %.preheader3 ]
  %10 = add i64 %indvar27, %indvar24
  %11 = trunc i64 %10 to i32
  %scevgep30 = getelementptr [1200 x double]* %B, i64 %indvar27, i64 %indvar24
  %scevgep29 = getelementptr [1200 x double]* %C, i64 %indvar27, i64 %indvar24
  %12 = mul i64 %indvar24, -1
  %13 = add i64 %5, %12
  %14 = trunc i64 %13 to i32
  %15 = srem i32 %11, 100
  %16 = sitofp i32 %15 to double
  %17 = fdiv double %16, %4
  store double %17, double* %scevgep29, align 8, !tbaa !1
  %18 = srem i32 %14, 100
  %19 = sitofp i32 %18 to double
  %20 = fdiv double %19, %4
  store double %20, double* %scevgep30, align 8, !tbaa !1
  %indvar.next25 = add i64 %indvar24, 1
  %exitcond26 = icmp ne i64 %indvar.next25, %1
  br i1 %exitcond26, label %.lr.ph11, label %._crit_edge12

._crit_edge12:                                    ; preds = %.lr.ph11, %.preheader3
  %indvar.next28 = add i64 %indvar27, 1
  %exitcond31 = icmp ne i64 %indvar.next28, %2
  br i1 %exitcond31, label %.preheader3, label %.preheader2

.preheader1:                                      ; preds = %.preheader1.lr.ph, %polly.merge
  %indvar15 = phi i64 [ 0, %.preheader1.lr.ph ], [ %29, %polly.merge ]
  %21 = mul i64 %indvar15, 8000
  %22 = mul i64 %indvar15, -1
  %23 = add i64 %8, %22
  %24 = trunc i64 %23 to i32
  %25 = zext i32 %24 to i64
  %26 = mul i64 %indvar15, 8008
  %i.18 = trunc i64 %indvar15 to i32
  %27 = mul i64 %indvar15, 1001
  %28 = add i64 %27, 1
  %29 = add i64 %indvar15, 1
  %j.25 = trunc i64 %29 to i32
  %30 = add i64 %25, 1
  %31 = icmp slt i32 %i.18, 0
  br i1 %31, label %.preheader, label %polly.cond40

.preheader:                                       ; preds = %polly.then45, %polly.loop_header47, %polly.cond40, %.preheader1
  %32 = icmp slt i32 %j.25, %m
  br i1 %32, label %polly.cond, label %polly.merge

polly.merge:                                      ; preds = %polly.then36, %polly.loop_header, %polly.cond, %.preheader
  %exitcond21 = icmp ne i64 %29, %7
  br i1 %exitcond21, label %.preheader1, label %._crit_edge9

._crit_edge9:                                     ; preds = %polly.merge, %.preheader2
  ret void

polly.cond:                                       ; preds = %.preheader
  %33 = srem i64 %26, 8
  %34 = icmp eq i64 %33, 0
  br i1 %34, label %polly.then36, label %polly.merge

polly.then36:                                     ; preds = %polly.cond
  br i1 true, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then36, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then36 ]
  %p_ = add i64 %28, %polly.indvar
  %p_scevgep20 = getelementptr [1000 x double]* %A, i64 0, i64 %p_
  store double -9.990000e+02, double* %p_scevgep20
  %p_indvar.next18 = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %25, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.cond40:                                     ; preds = %.preheader1
  %35 = srem i64 %21, 8
  %36 = icmp eq i64 %35, 0
  %37 = icmp sge i64 %indvar15, 0
  %or.cond63 = and i1 %36, %37
  br i1 %or.cond63, label %polly.then45, label %.preheader

polly.then45:                                     ; preds = %polly.cond40
  br i1 %37, label %polly.loop_header47, label %.preheader

polly.loop_header47:                              ; preds = %polly.then45, %polly.loop_header47
  %polly.indvar51 = phi i64 [ %polly.indvar_next52, %polly.loop_header47 ], [ 0, %polly.then45 ]
  %p_56 = add i64 %indvar15, %polly.indvar51
  %p_57 = trunc i64 %p_56 to i32
  %p_scevgep = getelementptr [1000 x double]* %A, i64 %indvar15, i64 %polly.indvar51
  %p_58 = srem i32 %p_57, 100
  %p_59 = sitofp i32 %p_58 to double
  %p_60 = fdiv double %p_59, %9
  store double %p_60, double* %p_scevgep
  %p_indvar.next = add i64 %polly.indvar51, 1
  %polly.indvar_next52 = add nsw i64 %polly.indvar51, 1
  %polly.adjust_ub53 = sub i64 %indvar15, 1
  %polly.loop_cond54 = icmp sle i64 %polly.indvar51, %polly.adjust_ub53
  br i1 %polly.loop_cond54, label %polly.loop_header47, label %.preheader
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_symm(i32 %m, i32 %n, double %alpha, double %beta, [1200 x double]* %C, [1000 x double]* %A, [1200 x double]* %B) #0 {
.split:
  %0 = icmp sgt i32 %m, 0
  br i1 %0, label %.preheader1.lr.ph, label %._crit_edge11

.preheader1.lr.ph:                                ; preds = %.split
  %1 = zext i32 %n to i64
  %2 = zext i32 %m to i64
  %3 = icmp sgt i32 %n, 0
  br label %.preheader1

.preheader1:                                      ; preds = %.preheader1.lr.ph, %._crit_edge8
  %4 = phi i64 [ 0, %.preheader1.lr.ph ], [ %indvar.next13, %._crit_edge8 ]
  %i.09 = trunc i64 %4 to i32
  %5 = mul i64 %4, 1001
  %scevgep27 = getelementptr [1000 x double]* %A, i64 0, i64 %5
  br i1 %3, label %.preheader.lr.ph, label %._crit_edge8

.preheader.lr.ph:                                 ; preds = %.preheader1
  %6 = icmp sgt i32 %i.09, 0
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %18
  %indvar14 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next15, %18 ]
  %scevgep22 = getelementptr [1200 x double]* %B, i64 %4, i64 %indvar14
  %scevgep21 = getelementptr [1200 x double]* %C, i64 %4, i64 %indvar14
  br i1 %6, label %.lr.ph, label %18

.lr.ph:                                           ; preds = %.preheader
  br label %7

; <label>:7                                       ; preds = %.lr.ph, %7
  %temp2.04.reg2mem.0 = phi double [ 0.000000e+00, %.lr.ph ], [ %17, %7 ]
  %indvar = phi i64 [ 0, %.lr.ph ], [ %indvar.next, %7 ]
  %scevgep = getelementptr [1000 x double]* %A, i64 %4, i64 %indvar
  %scevgep17 = getelementptr [1200 x double]* %B, i64 %indvar, i64 %indvar14
  %scevgep16 = getelementptr [1200 x double]* %C, i64 %indvar, i64 %indvar14
  %8 = load double* %scevgep22, align 8, !tbaa !1
  %9 = fmul double %8, %alpha
  %10 = load double* %scevgep, align 8, !tbaa !1
  %11 = fmul double %9, %10
  %12 = load double* %scevgep16, align 8, !tbaa !1
  %13 = fadd double %12, %11
  store double %13, double* %scevgep16, align 8, !tbaa !1
  %14 = load double* %scevgep17, align 8, !tbaa !1
  %15 = load double* %scevgep, align 8, !tbaa !1
  %16 = fmul double %14, %15
  %17 = fadd double %temp2.04.reg2mem.0, %16
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %4
  br i1 %exitcond, label %7, label %._crit_edge

._crit_edge:                                      ; preds = %7
  br label %18

; <label>:18                                      ; preds = %._crit_edge, %.preheader
  %temp2.0.lcssa.reg2mem.0 = phi double [ %17, %._crit_edge ], [ 0.000000e+00, %.preheader ]
  %19 = load double* %scevgep21, align 8, !tbaa !1
  %20 = fmul double %19, %beta
  %21 = load double* %scevgep22, align 8, !tbaa !1
  %22 = fmul double %21, %alpha
  %23 = load double* %scevgep27, align 8, !tbaa !1
  %24 = fmul double %22, %23
  %25 = fadd double %20, %24
  %26 = fmul double %temp2.0.lcssa.reg2mem.0, %alpha
  %27 = fadd double %26, %25
  store double %27, double* %scevgep21, align 8, !tbaa !1
  %indvar.next15 = add i64 %indvar14, 1
  %exitcond18 = icmp ne i64 %indvar.next15, %1
  br i1 %exitcond18, label %.preheader, label %._crit_edge8

._crit_edge8:                                     ; preds = %18, %.preheader1
  %indvar.next13 = add i64 %4, 1
  %exitcond23 = icmp ne i64 %indvar.next13, %2
  br i1 %exitcond23, label %.preheader1, label %._crit_edge11

._crit_edge11:                                    ; preds = %._crit_edge8, %.split
  ret void
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %m, i32 %n, [1200 x double]* %C) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %m, 0
  br i1 %5, label %.preheader.lr.ph, label %22

.preheader.lr.ph:                                 ; preds = %.split
  %6 = zext i32 %n to i64
  %7 = zext i32 %m to i64
  %8 = icmp sgt i32 %n, 0
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
  %scevgep = getelementptr [1200 x double]* %C, i64 %indvar4, i64 %indvar
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
  %24 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
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
