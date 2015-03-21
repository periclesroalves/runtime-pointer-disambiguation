; ModuleID = './linear-algebra/blas/gesummv/gesummv.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %alpha = alloca double, align 8
  %beta = alloca double, align 8
  %0 = tail call i8* @polybench_alloc_data(i64 1690000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 1690000, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 1300, i32 8) #3
  %3 = tail call i8* @polybench_alloc_data(i64 1300, i32 8) #3
  %4 = tail call i8* @polybench_alloc_data(i64 1300, i32 8) #3
  %5 = bitcast i8* %0 to [1300 x double]*
  %6 = bitcast i8* %1 to [1300 x double]*
  %7 = bitcast i8* %3 to double*
  call void @init_array(i32 1300, double* %alpha, double* %beta, [1300 x double]* %5, [1300 x double]* %6, double* %7)
  call void (...)* @polybench_timer_start() #3
  %8 = load double* %alpha, align 8, !tbaa !1
  %9 = load double* %beta, align 8, !tbaa !1
  %10 = bitcast i8* %2 to double*
  %11 = bitcast i8* %4 to double*
  call void @kernel_gesummv(i32 1300, double %8, double %9, [1300 x double]* %5, [1300 x double]* %6, double* %10, double* %7, double* %11)
  call void (...)* @polybench_timer_stop() #3
  call void (...)* @polybench_timer_print() #3
  %12 = icmp sgt i32 %argc, 42
  br i1 %12, label %13, label %17

; <label>:13                                      ; preds = %.split
  %14 = load i8** %argv, align 8, !tbaa !5
  %15 = load i8* %14, align 1, !tbaa !7
  %phitmp = icmp eq i8 %15, 0
  br i1 %phitmp, label %16, label %17

; <label>:16                                      ; preds = %13
  call void @print_array(i32 1300, double* %11)
  br label %17

; <label>:17                                      ; preds = %13, %16, %.split
  call void @free(i8* %0) #3
  call void @free(i8* %1) #3
  call void @free(i8* %2) #3
  call void @free(i8* %3) #3
  call void @free(i8* %4) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %n, double* %alpha, double* %beta, [1300 x double]* noalias %A, [1300 x double]* noalias %B, double* noalias %x) #0 {
.split:
  store double 1.500000e+00, double* %alpha, align 8, !tbaa !1
  store double 1.200000e+00, double* %beta, align 8, !tbaa !1
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.lr.ph5, label %polly.merge

.lr.ph5:                                          ; preds = %.split
  %1 = zext i32 %n to i64
  %2 = sitofp i32 %n to double
  %3 = icmp sge i64 %1, 1
  br i1 %3, label %polly.cond14, label %polly.merge

polly.merge:                                      ; preds = %polly.merge15, %polly.loop_header52, %.lr.ph5, %.split
  ret void

polly.cond14:                                     ; preds = %.lr.ph5
  %4 = sext i32 %n to i64
  %5 = icmp sge i64 %4, 1
  br i1 %5, label %polly.then16, label %polly.merge15

polly.merge15:                                    ; preds = %polly.then16, %polly.loop_exit20, %polly.cond14
  %6 = add i64 %1, -1
  %polly.loop_guard55 = icmp sle i64 0, %6
  br i1 %polly.loop_guard55, label %polly.loop_header52, label %polly.merge

polly.then16:                                     ; preds = %polly.cond14
  %7 = add i64 %1, -1
  %polly.loop_guard = icmp sle i64 0, %7
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge15

polly.loop_header:                                ; preds = %polly.then16, %polly.loop_exit20
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit20 ], [ 0, %polly.then16 ]
  %8 = mul i64 -11, %1
  %9 = add i64 %8, 5
  %10 = sub i64 %9, 32
  %11 = add i64 %10, 1
  %12 = icmp slt i64 %9, 0
  %13 = select i1 %12, i64 %11, i64 %9
  %14 = sdiv i64 %13, 32
  %15 = mul i64 -32, %14
  %16 = mul i64 -32, %1
  %17 = add i64 %15, %16
  %18 = mul i64 -32, %polly.indvar
  %19 = mul i64 -3, %polly.indvar
  %20 = add i64 %19, %1
  %21 = add i64 %20, 5
  %22 = sub i64 %21, 32
  %23 = add i64 %22, 1
  %24 = icmp slt i64 %21, 0
  %25 = select i1 %24, i64 %23, i64 %21
  %26 = sdiv i64 %25, 32
  %27 = mul i64 -32, %26
  %28 = add i64 %18, %27
  %29 = add i64 %28, -640
  %30 = icmp sgt i64 %17, %29
  %31 = select i1 %30, i64 %17, i64 %29
  %32 = mul i64 -20, %polly.indvar
  %polly.loop_guard21 = icmp sle i64 %31, %32
  br i1 %polly.loop_guard21, label %polly.loop_header18, label %polly.loop_exit20

polly.loop_exit20:                                ; preds = %polly.loop_exit29, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %7, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge15

polly.loop_header18:                              ; preds = %polly.loop_header, %polly.loop_exit29
  %polly.indvar22 = phi i64 [ %polly.indvar_next23, %polly.loop_exit29 ], [ %31, %polly.loop_header ]
  %33 = mul i64 -1, %polly.indvar22
  %34 = mul i64 -1, %1
  %35 = add i64 %33, %34
  %36 = add i64 %35, -30
  %37 = add i64 %36, 20
  %38 = sub i64 %37, 1
  %39 = icmp slt i64 %36, 0
  %40 = select i1 %39, i64 %36, i64 %38
  %41 = sdiv i64 %40, 20
  %42 = icmp sgt i64 %41, %polly.indvar
  %43 = select i1 %42, i64 %41, i64 %polly.indvar
  %44 = sub i64 %33, 20
  %45 = add i64 %44, 1
  %46 = icmp slt i64 %33, 0
  %47 = select i1 %46, i64 %45, i64 %33
  %48 = sdiv i64 %47, 20
  %49 = add i64 %polly.indvar, 31
  %50 = icmp slt i64 %48, %49
  %51 = select i1 %50, i64 %48, i64 %49
  %52 = icmp slt i64 %51, %7
  %53 = select i1 %52, i64 %51, i64 %7
  %polly.loop_guard30 = icmp sle i64 %43, %53
  br i1 %polly.loop_guard30, label %polly.loop_header27, label %polly.loop_exit29

polly.loop_exit29:                                ; preds = %polly.loop_exit38, %polly.loop_header18
  %polly.indvar_next23 = add nsw i64 %polly.indvar22, 32
  %polly.adjust_ub24 = sub i64 %32, 32
  %polly.loop_cond25 = icmp sle i64 %polly.indvar22, %polly.adjust_ub24
  br i1 %polly.loop_cond25, label %polly.loop_header18, label %polly.loop_exit20

polly.loop_header27:                              ; preds = %polly.loop_header18, %polly.loop_exit38
  %polly.indvar31 = phi i64 [ %polly.indvar_next32, %polly.loop_exit38 ], [ %43, %polly.loop_header18 ]
  %54 = mul i64 -20, %polly.indvar31
  %55 = add i64 %54, %34
  %56 = add i64 %55, 1
  %57 = icmp sgt i64 %polly.indvar22, %56
  %58 = select i1 %57, i64 %polly.indvar22, i64 %56
  %59 = add i64 %polly.indvar22, 31
  %60 = icmp slt i64 %54, %59
  %61 = select i1 %60, i64 %54, i64 %59
  %polly.loop_guard39 = icmp sle i64 %58, %61
  br i1 %polly.loop_guard39, label %polly.loop_header36, label %polly.loop_exit38

polly.loop_exit38:                                ; preds = %polly.loop_header36, %polly.loop_header27
  %polly.indvar_next32 = add nsw i64 %polly.indvar31, 1
  %polly.adjust_ub33 = sub i64 %53, 1
  %polly.loop_cond34 = icmp sle i64 %polly.indvar31, %polly.adjust_ub33
  br i1 %polly.loop_cond34, label %polly.loop_header27, label %polly.loop_exit29

polly.loop_header36:                              ; preds = %polly.loop_header27, %polly.loop_header36
  %polly.indvar40 = phi i64 [ %polly.indvar_next41, %polly.loop_header36 ], [ %58, %polly.loop_header27 ]
  %62 = mul i64 -1, %polly.indvar40
  %63 = add i64 %54, %62
  %p_scevgep9 = getelementptr [1300 x double]* %B, i64 %polly.indvar31, i64 %63
  %p_scevgep = getelementptr [1300 x double]* %A, i64 %polly.indvar31, i64 %63
  %p_ = mul i64 %polly.indvar31, %63
  %p_44 = trunc i64 %p_ to i32
  %p_45 = srem i32 %p_44, %n
  %p_46 = sitofp i32 %p_45 to double
  %p_47 = fdiv double %p_46, %2
  store double %p_47, double* %p_scevgep
  store double %p_47, double* %p_scevgep9
  %p_indvar.next = add i64 %63, 1
  %polly.indvar_next41 = add nsw i64 %polly.indvar40, 1
  %polly.adjust_ub42 = sub i64 %61, 1
  %polly.loop_cond43 = icmp sle i64 %polly.indvar40, %polly.adjust_ub42
  br i1 %polly.loop_cond43, label %polly.loop_header36, label %polly.loop_exit38

polly.loop_header52:                              ; preds = %polly.merge15, %polly.loop_header52
  %polly.indvar56 = phi i64 [ %polly.indvar_next57, %polly.loop_header52 ], [ 0, %polly.merge15 ]
  %p_i.02 = trunc i64 %polly.indvar56 to i32
  %p_scevgep13 = getelementptr double* %x, i64 %polly.indvar56
  %p_61 = srem i32 %p_i.02, %n
  %p_62 = sitofp i32 %p_61 to double
  %p_63 = fdiv double %p_62, %2
  store double %p_63, double* %p_scevgep13
  %polly.indvar_next57 = add nsw i64 %polly.indvar56, 1
  %polly.adjust_ub58 = sub i64 %6, 1
  %polly.loop_cond59 = icmp sle i64 %polly.indvar56, %polly.adjust_ub58
  br i1 %polly.loop_cond59, label %polly.loop_header52, label %polly.merge
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_gesummv(i32 %n, double %alpha, double %beta, [1300 x double]* noalias %A, [1300 x double]* noalias %B, double* noalias %tmp, double* noalias %x, double* noalias %y) #0 {
polly.split_new_and_old:
  %0 = zext i32 %n to i64
  %1 = sext i32 %n to i64
  %2 = icmp sge i64 %1, 1
  br i1 %2, label %polly.stmt..lr.ph4, label %polly.merge

polly.merge:                                      ; preds = %polly.then23, %polly.loop_exit27, %polly.stmt..lr.ph4, %polly.split_new_and_old
  ret void

polly.stmt..lr.ph4:                               ; preds = %polly.split_new_and_old
  %3 = icmp sge i64 %0, 1
  br i1 %3, label %polly.then23, label %polly.merge

polly.then23:                                     ; preds = %polly.stmt..lr.ph4
  %4 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %4
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then23, %polly.loop_exit27
  %i.02.reg2mem.0 = phi i32 [ 0, %polly.then23 ], [ %p_48, %polly.loop_exit27 ]
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit27 ], [ 0, %polly.then23 ]
  %p_scevgep15 = getelementptr double* %tmp, i64 %polly.indvar
  %p_scevgep16 = getelementptr double* %y, i64 %polly.indvar
  store double 0.000000e+00, double* %p_scevgep15
  store double 0.000000e+00, double* %p_scevgep16
  %.promoted_p_scalar_ = load double* %p_scevgep15
  br i1 %polly.loop_guard, label %polly.loop_header25, label %polly.loop_exit27

polly.loop_exit27:                                ; preds = %polly.loop_header25, %polly.loop_header
  %.reg2mem17.0 = phi double [ %p_39, %polly.loop_header25 ], [ 0.000000e+00, %polly.loop_header ]
  %.reg2mem.0 = phi double [ %p_35, %polly.loop_header25 ], [ %.promoted_p_scalar_, %polly.loop_header ]
  store double %.reg2mem.0, double* %p_scevgep15
  store double %.reg2mem17.0, double* %p_scevgep16
  %_p_scalar_43 = load double* %p_scevgep15
  %p_44 = fmul double %_p_scalar_43, %alpha
  %p_46 = fmul double %.reg2mem17.0, %beta
  %p_47 = fadd double %p_44, %p_46
  store double %p_47, double* %p_scevgep16
  %p_48 = add nsw i32 %i.02.reg2mem.0, 1
  %p_indvar.next7 = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %4, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header25:                              ; preds = %polly.loop_header, %polly.loop_header25
  %.reg2mem17.1 = phi double [ 0.000000e+00, %polly.loop_header ], [ %p_39, %polly.loop_header25 ]
  %.reg2mem.1 = phi double [ %.promoted_p_scalar_, %polly.loop_header ], [ %p_35, %polly.loop_header25 ]
  %polly.indvar29 = phi i64 [ %polly.indvar_next30, %polly.loop_header25 ], [ 0, %polly.loop_header ]
  %p_scevgep9 = getelementptr [1300 x double]* %B, i64 %polly.indvar, i64 %polly.indvar29
  %p_scevgep = getelementptr [1300 x double]* %A, i64 %polly.indvar, i64 %polly.indvar29
  %p_scevgep8 = getelementptr double* %x, i64 %polly.indvar29
  %_p_scalar_ = load double* %p_scevgep
  %_p_scalar_34 = load double* %p_scevgep8
  %p_ = fmul double %_p_scalar_, %_p_scalar_34
  %p_35 = fadd double %p_, %.reg2mem.1
  %_p_scalar_36 = load double* %p_scevgep9
  %p_38 = fmul double %_p_scalar_36, %_p_scalar_34
  %p_39 = fadd double %p_38, %.reg2mem17.1
  %p_indvar.next = add i64 %polly.indvar29, 1
  %polly.indvar_next30 = add nsw i64 %polly.indvar29, 1
  %polly.adjust_ub31 = sub i64 %4, 1
  %polly.loop_cond32 = icmp sle i64 %polly.indvar29, %polly.adjust_ub31
  br i1 %polly.loop_cond32, label %polly.loop_header25, label %polly.loop_exit27
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, double* noalias %y) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %n, 0
  br i1 %5, label %.lr.ph, label %16

.lr.ph:                                           ; preds = %.split
  %6 = zext i32 %n to i64
  br label %7

; <label>:7                                       ; preds = %.lr.ph, %12
  %indvar = phi i64 [ 0, %.lr.ph ], [ %indvar.next, %12 ]
  %i.01 = trunc i64 %indvar to i32
  %scevgep = getelementptr double* %y, i64 %indvar
  %8 = srem i32 %i.01, 20
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %10, label %12

; <label>:10                                      ; preds = %7
  %11 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %11) #4
  br label %12

; <label>:12                                      ; preds = %10, %7
  %13 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %14 = load double* %scevgep, align 8, !tbaa !1
  %15 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %13, i8* getelementptr inbounds ([8 x i8]* @.str5, i64 0, i64 0), double %14) #5
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %6
  br i1 %exitcond, label %7, label %._crit_edge

._crit_edge:                                      ; preds = %12
  br label %16

; <label>:16                                      ; preds = %._crit_edge, %.split
  %17 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %18 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %17, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %19 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %20 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str7, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %19) #4
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
