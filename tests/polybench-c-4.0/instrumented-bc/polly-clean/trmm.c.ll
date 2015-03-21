; ModuleID = './linear-algebra/blas/trmm/trmm.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [2 x i8] c"B\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %alpha = alloca double, align 8
  %0 = tail call i8* @polybench_alloc_data(i64 1000000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 1200000, i32 8) #3
  %2 = bitcast i8* %0 to [1000 x double]*
  %3 = bitcast i8* %1 to [1200 x double]*
  call void @init_array(i32 1000, i32 1200, double* %alpha, [1000 x double]* %2, [1200 x double]* %3)
  call void (...)* @polybench_timer_start() #3
  %4 = load double* %alpha, align 8, !tbaa !1
  call void @kernel_trmm(i32 1000, i32 1200, double %4, [1000 x double]* %2, [1200 x double]* %3)
  call void (...)* @polybench_timer_stop() #3
  call void (...)* @polybench_timer_print() #3
  %5 = icmp sgt i32 %argc, 42
  br i1 %5, label %6, label %10

; <label>:6                                       ; preds = %.split
  %7 = load i8** %argv, align 8, !tbaa !5
  %8 = load i8* %7, align 1, !tbaa !7
  %phitmp = icmp eq i8 %8, 0
  br i1 %phitmp, label %9, label %10

; <label>:9                                       ; preds = %6
  call void @print_array(i32 1000, i32 1200, [1200 x double]* %3)
  br label %10

; <label>:10                                      ; preds = %6, %9, %.split
  call void @free(i8* %0) #3
  call void @free(i8* %1) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %m, i32 %n, double* %alpha, [1000 x double]* %A, [1200 x double]* %B) #0 {
.split:
  store double 1.500000e+00, double* %alpha, align 8, !tbaa !1
  %0 = icmp sgt i32 %m, 0
  br i1 %0, label %.preheader.lr.ph, label %._crit_edge8

.preheader.lr.ph:                                 ; preds = %.split
  %1 = zext i32 %n to i64
  %2 = zext i32 %m to i64
  %3 = icmp sgt i32 %n, 0
  %4 = sitofp i32 %n to double
  %5 = sitofp i32 %m to double
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %polly.merge
  %6 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next10, %polly.merge ]
  %7 = mul i64 %6, 8000
  %8 = mul i64 %6, 9600
  %i.06 = trunc i64 %6 to i32
  %9 = add i64 %1, %6
  %10 = mul i64 %6, 1001
  %scevgep18 = getelementptr [1000 x double]* %A, i64 0, i64 %10
  %11 = icmp sgt i32 %i.06, 0
  br i1 %11, label %polly.cond30, label %polly.merge31

polly.merge31:                                    ; preds = %polly.then35, %polly.loop_header37, %polly.cond30, %.preheader
  store double 1.000000e+00, double* %scevgep18, align 8, !tbaa !1
  br i1 %3, label %polly.cond, label %polly.merge

polly.merge:                                      ; preds = %polly.then21, %polly.loop_header, %polly.cond, %polly.merge31
  %indvar.next10 = add i64 %6, 1
  %exitcond15 = icmp ne i64 %indvar.next10, %2
  br i1 %exitcond15, label %.preheader, label %._crit_edge8

._crit_edge8:                                     ; preds = %polly.merge, %.split
  ret void

polly.cond:                                       ; preds = %polly.merge31
  %12 = srem i64 %8, 8
  %13 = icmp eq i64 %12, 0
  %14 = icmp sge i64 %1, 1
  %or.cond = and i1 %13, %14
  br i1 %or.cond, label %polly.then21, label %polly.merge

polly.then21:                                     ; preds = %polly.cond
  %15 = add i64 %1, -1
  %polly.loop_guard = icmp sle i64 0, %15
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then21, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then21 ]
  %p_scevgep14 = getelementptr [1200 x double]* %B, i64 %6, i64 %polly.indvar
  %p_ = mul i64 %polly.indvar, -1
  %p_22 = add i64 %9, %p_
  %p_23 = trunc i64 %p_22 to i32
  %p_24 = srem i32 %p_23, %n
  %p_25 = sitofp i32 %p_24 to double
  %p_26 = fdiv double %p_25, %4
  store double %p_26, double* %p_scevgep14
  %p_indvar.next12 = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %15, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.cond30:                                     ; preds = %.preheader
  %16 = srem i64 %7, 8
  %17 = icmp eq i64 %16, 0
  %18 = icmp sge i64 %6, 1
  %or.cond53 = and i1 %17, %18
  br i1 %or.cond53, label %polly.then35, label %polly.merge31

polly.then35:                                     ; preds = %polly.cond30
  %19 = add i64 %6, -1
  %polly.loop_guard40 = icmp sle i64 0, %19
  br i1 %polly.loop_guard40, label %polly.loop_header37, label %polly.merge31

polly.loop_header37:                              ; preds = %polly.then35, %polly.loop_header37
  %polly.indvar41 = phi i64 [ %polly.indvar_next42, %polly.loop_header37 ], [ 0, %polly.then35 ]
  %p_46 = add i64 %6, %polly.indvar41
  %p_47 = trunc i64 %p_46 to i32
  %p_scevgep = getelementptr [1000 x double]* %A, i64 %6, i64 %polly.indvar41
  %p_48 = srem i32 %p_47, %m
  %p_49 = sitofp i32 %p_48 to double
  %p_50 = fdiv double %p_49, %5
  store double %p_50, double* %p_scevgep
  %p_indvar.next = add i64 %polly.indvar41, 1
  %polly.indvar_next42 = add nsw i64 %polly.indvar41, 1
  %polly.adjust_ub43 = sub i64 %19, 1
  %polly.loop_cond44 = icmp sle i64 %polly.indvar41, %polly.adjust_ub43
  br i1 %polly.loop_cond44, label %polly.loop_header37, label %polly.merge31
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_trmm(i32 %m, i32 %n, double %alpha, [1000 x double]* %A, [1200 x double]* %B) #0 {
.split:
  %0 = icmp sgt i32 %m, 0
  br i1 %0, label %.preheader1.lr.ph, label %._crit_edge8

.preheader1.lr.ph:                                ; preds = %.split
  %1 = add i32 %m, -2
  %2 = zext i32 %n to i64
  %3 = zext i32 %m to i64
  %4 = zext i32 %1 to i64
  %5 = icmp sgt i32 %n, 0
  br label %.preheader1

.preheader1:                                      ; preds = %.preheader1.lr.ph, %._crit_edge5
  %indvar9 = phi i64 [ 0, %.preheader1.lr.ph ], [ %6, %._crit_edge5 ]
  %6 = add i64 %indvar9, 1
  %k.02 = trunc i64 %6 to i32
  %7 = mul i64 %indvar9, 1001
  %8 = mul i64 %indvar9, -1
  %9 = add i64 %4, %8
  %10 = trunc i64 %9 to i32
  %11 = zext i32 %10 to i64
  %12 = add i64 %11, 1
  br i1 %5, label %.preheader.lr.ph, label %._crit_edge5

.preheader.lr.ph:                                 ; preds = %.preheader1
  %13 = icmp slt i32 %k.02, %m
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %._crit_edge
  %indvar11 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next12, %._crit_edge ]
  %scevgep16 = getelementptr [1200 x double]* %B, i64 %indvar9, i64 %indvar11
  br i1 %13, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %.preheader, %.lr.ph
  %indvar = phi i64 [ %15, %.lr.ph ], [ 0, %.preheader ]
  %14 = add i64 %6, %indvar
  %scevgep = getelementptr [1200 x double]* %B, i64 %14, i64 %indvar11
  %15 = add i64 %indvar, 1
  %scevgep13 = getelementptr [1000 x double]* %A, i64 %15, i64 %7
  %16 = load double* %scevgep13, align 8, !tbaa !1
  %17 = load double* %scevgep, align 8, !tbaa !1
  %18 = fmul double %16, %17
  %19 = load double* %scevgep16, align 8, !tbaa !1
  %20 = fadd double %19, %18
  store double %20, double* %scevgep16, align 8, !tbaa !1
  %exitcond = icmp ne i64 %15, %12
  br i1 %exitcond, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %.preheader
  %21 = load double* %scevgep16, align 8, !tbaa !1
  %22 = fmul double %21, %alpha
  store double %22, double* %scevgep16, align 8, !tbaa !1
  %indvar.next12 = add i64 %indvar11, 1
  %exitcond14 = icmp ne i64 %indvar.next12, %2
  br i1 %exitcond14, label %.preheader, label %._crit_edge5

._crit_edge5:                                     ; preds = %._crit_edge, %.preheader1
  %exitcond17 = icmp ne i64 %6, %3
  br i1 %exitcond17, label %.preheader1, label %._crit_edge8

._crit_edge8:                                     ; preds = %._crit_edge5, %.split
  ret void
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %m, i32 %n, [1200 x double]* %B) #0 {
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
  %scevgep = getelementptr [1200 x double]* %B, i64 %indvar4, i64 %indvar
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
