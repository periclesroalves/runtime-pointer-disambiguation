; ModuleID = './linear-algebra/kernels/bicg/bicg.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [2 x i8] c"s\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [2 x i8] c"q\00", align 1
@.str8 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %0 = tail call i8* @polybench_alloc_data(i64 3990000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 1900, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 2100, i32 8) #3
  %3 = tail call i8* @polybench_alloc_data(i64 1900, i32 8) #3
  %4 = tail call i8* @polybench_alloc_data(i64 2100, i32 8) #3
  %5 = bitcast i8* %0 to [1900 x double]*
  %6 = bitcast i8* %4 to double*
  %7 = bitcast i8* %3 to double*
  tail call void @init_array(i32 1900, i32 2100, [1900 x double]* %5, double* %6, double* %7)
  tail call void (...)* @polybench_timer_start() #3
  %8 = bitcast i8* %1 to double*
  %9 = bitcast i8* %2 to double*
  tail call void @kernel_bicg(i32 1900, i32 2100, [1900 x double]* %5, double* %8, double* %9, double* %7, double* %6)
  tail call void (...)* @polybench_timer_stop() #3
  tail call void (...)* @polybench_timer_print() #3
  %10 = icmp sgt i32 %argc, 42
  br i1 %10, label %11, label %15

; <label>:11                                      ; preds = %.split
  %12 = load i8** %argv, align 8, !tbaa !1
  %13 = load i8* %12, align 1, !tbaa !5
  %phitmp = icmp eq i8 %13, 0
  br i1 %phitmp, label %14, label %15

; <label>:14                                      ; preds = %11
  tail call void @print_array(i32 1900, i32 2100, double* %8, double* %9)
  br label %15

; <label>:15                                      ; preds = %11, %14, %.split
  tail call void @free(i8* %0) #3
  tail call void @free(i8* %1) #3
  tail call void @free(i8* %2) #3
  tail call void @free(i8* %3) #3
  tail call void @free(i8* %4) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %m, i32 %n, [1900 x double]* %A, double* %r, double* %p) #0 {
polly.split_new_and_old27:
  %0 = zext i32 %m to i64
  %1 = sext i32 %m to i64
  %2 = icmp sge i64 %1, 1
  %3 = icmp sge i64 %0, 1
  %4 = and i1 %2, %3
  br i1 %4, label %polly.then32, label %polly.merge31

.lr.ph4:                                          ; preds = %polly.merge31
  %5 = zext i32 %n to i64
  %6 = sitofp i32 %n to double
  %7 = icmp sgt i32 %m, 0
  br label %8

; <label>:8                                       ; preds = %.lr.ph4, %polly.merge
  %9 = phi i64 [ 0, %.lr.ph4 ], [ %indvar.next10, %polly.merge ]
  %10 = mul i64 %9, 15200
  %i.12 = trunc i64 %9 to i32
  %scevgep13 = getelementptr double* %r, i64 %9
  %11 = srem i32 %i.12, %n
  %12 = sitofp i32 %11 to double
  %13 = fdiv double %12, %6
  store double %13, double* %scevgep13, align 8, !tbaa !6
  br i1 %7, label %polly.cond, label %polly.merge

polly.merge:                                      ; preds = %polly.then21, %polly.loop_header, %polly.cond, %8
  %indvar.next10 = add i64 %9, 1
  %exitcond11 = icmp ne i64 %indvar.next10, %5
  br i1 %exitcond11, label %8, label %._crit_edge5

._crit_edge5:                                     ; preds = %polly.merge, %polly.merge31
  ret void

polly.cond:                                       ; preds = %8
  %14 = srem i64 %10, 8
  %15 = icmp eq i64 %14, 0
  %or.cond = and i1 %15, %3
  br i1 %or.cond, label %polly.then21, label %polly.merge

polly.then21:                                     ; preds = %polly.cond
  %16 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %16
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then21, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then21 ]
  %p_scevgep = getelementptr [1900 x double]* %A, i64 %9, i64 %polly.indvar
  %p_ = mul i64 %9, %polly.indvar
  %p_22 = add i64 %9, %p_
  %p_23 = trunc i64 %p_22 to i32
  %p_24 = srem i32 %p_23, %n
  %p_25 = sitofp i32 %p_24 to double
  %p_26 = fdiv double %p_25, %6
  store double %p_26, double* %p_scevgep
  %p_indvar.next = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %16, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.merge31:                                    ; preds = %polly.then32, %polly.loop_header34, %polly.split_new_and_old27
  %17 = icmp sgt i32 %n, 0
  br i1 %17, label %.lr.ph4, label %._crit_edge5

polly.then32:                                     ; preds = %polly.split_new_and_old27
  %18 = add i64 %0, -1
  %polly.loop_guard37 = icmp sle i64 0, %18
  br i1 %polly.loop_guard37, label %polly.loop_header34, label %polly.merge31

polly.loop_header34:                              ; preds = %polly.then32, %polly.loop_header34
  %polly.indvar38 = phi i64 [ %polly.indvar_next39, %polly.loop_header34 ], [ 0, %polly.then32 ]
  %p_.moved.to. = sitofp i32 %m to double
  %p_i.06 = trunc i64 %polly.indvar38 to i32
  %p_scevgep17 = getelementptr double* %p, i64 %polly.indvar38
  %p_43 = srem i32 %p_i.06, %m
  %p_44 = sitofp i32 %p_43 to double
  %p_45 = fdiv double %p_44, %p_.moved.to.
  store double %p_45, double* %p_scevgep17
  %p_indvar.next15 = add i64 %polly.indvar38, 1
  %polly.indvar_next39 = add nsw i64 %polly.indvar38, 1
  %polly.adjust_ub40 = sub i64 %18, 1
  %polly.loop_cond41 = icmp sle i64 %polly.indvar38, %polly.adjust_ub40
  br i1 %polly.loop_cond41, label %polly.loop_header34, label %polly.merge31
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_bicg(i32 %m, i32 %n, [1900 x double]* %A, double* %s, double* %q, double* %p, double* %r) #0 {
polly.split_new_and_old:
  %0 = zext i32 %m to i64
  %1 = sext i32 %m to i64
  %2 = icmp sge i64 %1, 1
  %3 = icmp sge i64 %0, 1
  %4 = and i1 %2, %3
  br i1 %4, label %polly.then, label %polly.merge

.lr.ph3:                                          ; preds = %polly.merge
  %5 = zext i32 %n to i64
  %6 = icmp sgt i32 %m, 0
  br label %7

; <label>:7                                       ; preds = %.lr.ph3, %._crit_edge
  %indvar8 = phi i64 [ 0, %.lr.ph3 ], [ %indvar.next9, %._crit_edge ]
  %scevgep14 = getelementptr double* %q, i64 %indvar8
  %scevgep15 = getelementptr double* %r, i64 %indvar8
  store double 0.000000e+00, double* %scevgep14, align 8, !tbaa !6
  br i1 %6, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %7, %.lr.ph
  %indvar = phi i64 [ %indvar.next, %.lr.ph ], [ 0, %7 ]
  %scevgep10 = getelementptr [1900 x double]* %A, i64 %indvar8, i64 %indvar
  %scevgep = getelementptr double* %s, i64 %indvar
  %scevgep11 = getelementptr double* %p, i64 %indvar
  %8 = load double* %scevgep, align 8, !tbaa !6
  %9 = load double* %scevgep15, align 8, !tbaa !6
  %10 = load double* %scevgep10, align 8, !tbaa !6
  %11 = fmul double %9, %10
  %12 = fadd double %8, %11
  store double %12, double* %scevgep, align 8, !tbaa !6
  %13 = load double* %scevgep14, align 8, !tbaa !6
  %14 = load double* %scevgep10, align 8, !tbaa !6
  %15 = load double* %scevgep11, align 8, !tbaa !6
  %16 = fmul double %14, %15
  %17 = fadd double %13, %16
  store double %17, double* %scevgep14, align 8, !tbaa !6
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %0
  br i1 %exitcond, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %7
  %indvar.next9 = add i64 %indvar8, 1
  %exitcond12 = icmp ne i64 %indvar.next9, %5
  br i1 %exitcond12, label %7, label %._crit_edge4

._crit_edge4:                                     ; preds = %._crit_edge, %polly.merge
  ret void

polly.merge:                                      ; preds = %polly.then, %polly.loop_header, %polly.split_new_and_old
  %18 = icmp sgt i32 %n, 0
  br i1 %18, label %.lr.ph3, label %._crit_edge4

polly.then:                                       ; preds = %polly.split_new_and_old
  %19 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %19
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_scevgep19 = getelementptr double* %s, i64 %polly.indvar
  store double 0.000000e+00, double* %p_scevgep19
  %p_indvar.next17 = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %19, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %m, i32 %n, double* %s, double* %q) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %m, 0
  br i1 %5, label %.lr.ph7, label %16

.lr.ph7:                                          ; preds = %.split
  %6 = zext i32 %m to i64
  br label %7

; <label>:7                                       ; preds = %.lr.ph7, %12
  %indvar9 = phi i64 [ 0, %.lr.ph7 ], [ %indvar.next10, %12 ]
  %i.05 = trunc i64 %indvar9 to i32
  %scevgep12 = getelementptr double* %s, i64 %indvar9
  %8 = srem i32 %i.05, 20
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %10, label %12

; <label>:10                                      ; preds = %7
  %11 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %fputc3 = tail call i32 @fputc(i32 10, %struct._IO_FILE* %11) #4
  br label %12

; <label>:12                                      ; preds = %10, %7
  %13 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %14 = load double* %scevgep12, align 8, !tbaa !6
  %15 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %13, i8* getelementptr inbounds ([8 x i8]* @.str5, i64 0, i64 0), double %14) #5
  %indvar.next10 = add i64 %indvar9, 1
  %exitcond11 = icmp ne i64 %indvar.next10, %6
  br i1 %exitcond11, label %7, label %._crit_edge8

._crit_edge8:                                     ; preds = %12
  br label %16

; <label>:16                                      ; preds = %._crit_edge8, %.split
  %17 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %18 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %17, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %19 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %20 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %19, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str7, i64 0, i64 0)) #5
  %21 = icmp sgt i32 %n, 0
  br i1 %21, label %.lr.ph, label %32

.lr.ph:                                           ; preds = %16
  %22 = zext i32 %n to i64
  br label %23

; <label>:23                                      ; preds = %.lr.ph, %28
  %indvar = phi i64 [ 0, %.lr.ph ], [ %indvar.next, %28 ]
  %i.14 = trunc i64 %indvar to i32
  %scevgep = getelementptr double* %q, i64 %indvar
  %24 = srem i32 %i.14, 20
  %25 = icmp eq i32 %24, 0
  br i1 %25, label %26, label %28

; <label>:26                                      ; preds = %23
  %27 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %27) #4
  br label %28

; <label>:28                                      ; preds = %26, %23
  %29 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %30 = load double* %scevgep, align 8, !tbaa !6
  %31 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %29, i8* getelementptr inbounds ([8 x i8]* @.str5, i64 0, i64 0), double %30) #5
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %22
  br i1 %exitcond, label %23, label %._crit_edge

._crit_edge:                                      ; preds = %28
  br label %32

; <label>:32                                      ; preds = %._crit_edge, %16
  %33 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %34 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %33, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str7, i64 0, i64 0)) #5
  %35 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %36 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str8, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %35) #4
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
!2 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{metadata !3, metadata !3, i64 0}
!6 = metadata !{metadata !7, metadata !7, i64 0}
!7 = metadata !{metadata !"double", metadata !3, i64 0}
