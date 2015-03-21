; ModuleID = './stencils/seidel-2d/seidel-2d.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %0 = tail call i8* @polybench_alloc_data(i64 4000000, i32 8) #3
  %1 = bitcast i8* %0 to [2000 x double]*
  tail call void @init_array(i32 2000, [2000 x double]* %1)
  tail call void (...)* @polybench_timer_start() #3
  tail call void @kernel_seidel_2d(i32 500, i32 2000, [2000 x double]* %1)
  tail call void (...)* @polybench_timer_stop() #3
  tail call void (...)* @polybench_timer_print() #3
  %2 = icmp sgt i32 %argc, 42
  br i1 %2, label %3, label %7

; <label>:3                                       ; preds = %.split
  %4 = load i8** %argv, align 8, !tbaa !1
  %5 = load i8* %4, align 1, !tbaa !5
  %phitmp = icmp eq i8 %5, 0
  br i1 %phitmp, label %6, label %7

; <label>:6                                       ; preds = %3
  tail call void @print_array(i32 2000, [2000 x double]* %1)
  br label %7

; <label>:7                                       ; preds = %3, %6, %.split
  tail call void @free(i8* %0) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %n, [2000 x double]* noalias %A) #0 {
polly.split_new_and_old:
  %0 = zext i32 %n to i64
  %1 = sext i32 %n to i64
  %2 = icmp sge i64 %1, 1
  %3 = icmp sge i64 %0, 1
  %4 = and i1 %2, %3
  br i1 %4, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit14, %polly.split_new_and_old
  ret void

polly.then:                                       ; preds = %polly.split_new_and_old
  %5 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %5
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit14
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit14 ], [ 0, %polly.then ]
  %6 = mul i64 -11, %0
  %7 = add i64 %6, 5
  %8 = sub i64 %7, 32
  %9 = add i64 %8, 1
  %10 = icmp slt i64 %7, 0
  %11 = select i1 %10, i64 %9, i64 %7
  %12 = sdiv i64 %11, 32
  %13 = mul i64 -32, %12
  %14 = mul i64 -32, %0
  %15 = add i64 %13, %14
  %16 = mul i64 -32, %polly.indvar
  %17 = mul i64 -3, %polly.indvar
  %18 = add i64 %17, %0
  %19 = add i64 %18, 5
  %20 = sub i64 %19, 32
  %21 = add i64 %20, 1
  %22 = icmp slt i64 %19, 0
  %23 = select i1 %22, i64 %21, i64 %19
  %24 = sdiv i64 %23, 32
  %25 = mul i64 -32, %24
  %26 = add i64 %16, %25
  %27 = add i64 %26, -640
  %28 = icmp sgt i64 %15, %27
  %29 = select i1 %28, i64 %15, i64 %27
  %30 = mul i64 -20, %polly.indvar
  %polly.loop_guard15 = icmp sle i64 %29, %30
  br i1 %polly.loop_guard15, label %polly.loop_header12, label %polly.loop_exit14

polly.loop_exit14:                                ; preds = %polly.loop_exit23, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %5, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header12:                              ; preds = %polly.loop_header, %polly.loop_exit23
  %polly.indvar16 = phi i64 [ %polly.indvar_next17, %polly.loop_exit23 ], [ %29, %polly.loop_header ]
  %31 = mul i64 -1, %polly.indvar16
  %32 = mul i64 -1, %0
  %33 = add i64 %31, %32
  %34 = add i64 %33, -30
  %35 = add i64 %34, 20
  %36 = sub i64 %35, 1
  %37 = icmp slt i64 %34, 0
  %38 = select i1 %37, i64 %34, i64 %36
  %39 = sdiv i64 %38, 20
  %40 = icmp sgt i64 %39, %polly.indvar
  %41 = select i1 %40, i64 %39, i64 %polly.indvar
  %42 = sub i64 %31, 20
  %43 = add i64 %42, 1
  %44 = icmp slt i64 %31, 0
  %45 = select i1 %44, i64 %43, i64 %31
  %46 = sdiv i64 %45, 20
  %47 = add i64 %polly.indvar, 31
  %48 = icmp slt i64 %46, %47
  %49 = select i1 %48, i64 %46, i64 %47
  %50 = icmp slt i64 %49, %5
  %51 = select i1 %50, i64 %49, i64 %5
  %polly.loop_guard24 = icmp sle i64 %41, %51
  br i1 %polly.loop_guard24, label %polly.loop_header21, label %polly.loop_exit23

polly.loop_exit23:                                ; preds = %polly.loop_exit32, %polly.loop_header12
  %polly.indvar_next17 = add nsw i64 %polly.indvar16, 32
  %polly.adjust_ub18 = sub i64 %30, 32
  %polly.loop_cond19 = icmp sle i64 %polly.indvar16, %polly.adjust_ub18
  br i1 %polly.loop_cond19, label %polly.loop_header12, label %polly.loop_exit14

polly.loop_header21:                              ; preds = %polly.loop_header12, %polly.loop_exit32
  %polly.indvar25 = phi i64 [ %polly.indvar_next26, %polly.loop_exit32 ], [ %41, %polly.loop_header12 ]
  %52 = mul i64 -20, %polly.indvar25
  %53 = add i64 %52, %32
  %54 = add i64 %53, 1
  %55 = icmp sgt i64 %polly.indvar16, %54
  %56 = select i1 %55, i64 %polly.indvar16, i64 %54
  %57 = add i64 %polly.indvar16, 31
  %58 = icmp slt i64 %52, %57
  %59 = select i1 %58, i64 %52, i64 %57
  %polly.loop_guard33 = icmp sle i64 %56, %59
  br i1 %polly.loop_guard33, label %polly.loop_header30, label %polly.loop_exit32

polly.loop_exit32:                                ; preds = %polly.loop_header30, %polly.loop_header21
  %polly.indvar_next26 = add nsw i64 %polly.indvar25, 1
  %polly.adjust_ub27 = sub i64 %51, 1
  %polly.loop_cond28 = icmp sle i64 %polly.indvar25, %polly.adjust_ub27
  br i1 %polly.loop_cond28, label %polly.loop_header21, label %polly.loop_exit23

polly.loop_header30:                              ; preds = %polly.loop_header21, %polly.loop_header30
  %polly.indvar34 = phi i64 [ %polly.indvar_next35, %polly.loop_header30 ], [ %56, %polly.loop_header21 ]
  %60 = mul i64 -1, %polly.indvar34
  %61 = add i64 %52, %60
  %p_i.02.moved.to. = trunc i64 %polly.indvar25 to i32
  %p_.moved.to. = sitofp i32 %p_i.02.moved.to. to double
  %p_.moved.to.8 = sitofp i32 %n to double
  %p_scevgep = getelementptr [2000 x double]* %A, i64 %polly.indvar25, i64 %61
  %p_ = add i64 %61, 2
  %p_38 = trunc i64 %p_ to i32
  %p_39 = sitofp i32 %p_38 to double
  %p_40 = fmul double %p_.moved.to., %p_39
  %p_41 = fadd double %p_40, 2.000000e+00
  %p_42 = fdiv double %p_41, %p_.moved.to.8
  store double %p_42, double* %p_scevgep
  %p_indvar.next = add i64 %61, 1
  %polly.indvar_next35 = add nsw i64 %polly.indvar34, 1
  %polly.adjust_ub36 = sub i64 %59, 1
  %polly.loop_cond37 = icmp sle i64 %polly.indvar34, %polly.adjust_ub36
  br i1 %polly.loop_cond37, label %polly.loop_header30, label %polly.loop_exit32
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_seidel_2d(i32 %tsteps, i32 %n, [2000 x double]* noalias %A) #0 {
polly.split_new_and_old:
  %0 = add i32 %n, -2
  %1 = zext i32 %0 to i64
  %2 = sext i32 %n to i64
  %3 = icmp sge i64 %2, 3
  %4 = icmp sge i64 %1, 1
  %5 = and i1 %3, %4
  %6 = sext i32 %tsteps to i64
  %7 = icmp sge i64 %6, 1
  %8 = and i1 %5, %7
  br i1 %8, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit42, %polly.split_new_and_old
  ret void

polly.then:                                       ; preds = %polly.split_new_and_old
  %9 = add i64 %6, -1
  %polly.loop_guard = icmp sle i64 0, %9
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit42
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit42 ], [ 0, %polly.then ]
  %10 = add i64 %1, -1
  %polly.loop_guard43 = icmp sle i64 0, %10
  br i1 %polly.loop_guard43, label %polly.loop_header40, label %polly.loop_exit42

polly.loop_exit42:                                ; preds = %polly.loop_exit51, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %9, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header40:                              ; preds = %polly.loop_header, %polly.loop_exit51
  %polly.indvar44 = phi i64 [ %polly.indvar_next45, %polly.loop_exit51 ], [ 0, %polly.loop_header ]
  br i1 %polly.loop_guard43, label %polly.loop_header49, label %polly.loop_exit51

polly.loop_exit51:                                ; preds = %polly.loop_header49, %polly.loop_header40
  %polly.indvar_next45 = add nsw i64 %polly.indvar44, 1
  %polly.adjust_ub46 = sub i64 %10, 1
  %polly.loop_cond47 = icmp sle i64 %polly.indvar44, %polly.adjust_ub46
  br i1 %polly.loop_cond47, label %polly.loop_header40, label %polly.loop_exit42

polly.loop_header49:                              ; preds = %polly.loop_header40, %polly.loop_header49
  %polly.indvar53 = phi i64 [ %polly.indvar_next54, %polly.loop_header49 ], [ 0, %polly.loop_header40 ]
  %p_.moved.to.35 = add i64 %polly.indvar44, 1
  %p_.moved.to.36 = add i64 %polly.indvar44, 2
  %p_scevgep15 = getelementptr [2000 x double]* %A, i64 %polly.indvar44, i64 %polly.indvar53
  %p_scevgep17 = getelementptr [2000 x double]* %A, i64 %p_.moved.to.36, i64 %polly.indvar53
  %p_ = add i64 %polly.indvar53, 2
  %p_scevgep14 = getelementptr [2000 x double]* %A, i64 %p_.moved.to.36, i64 %p_
  %p_57 = add i64 %polly.indvar53, 1
  %p_scevgep13 = getelementptr [2000 x double]* %A, i64 %p_.moved.to.36, i64 %p_57
  %p_scevgep16 = getelementptr [2000 x double]* %A, i64 %p_.moved.to.35, i64 %polly.indvar53
  %p_scevgep12 = getelementptr [2000 x double]* %A, i64 %p_.moved.to.35, i64 %p_
  %p_scevgep11 = getelementptr [2000 x double]* %A, i64 %p_.moved.to.35, i64 %p_57
  %p_scevgep10 = getelementptr [2000 x double]* %A, i64 %polly.indvar44, i64 %p_
  %p_scevgep = getelementptr [2000 x double]* %A, i64 %polly.indvar44, i64 %p_57
  %_p_scalar_ = load double* %p_scevgep15
  %_p_scalar_58 = load double* %p_scevgep
  %p_59 = fadd double %_p_scalar_, %_p_scalar_58
  %_p_scalar_60 = load double* %p_scevgep10
  %p_61 = fadd double %p_59, %_p_scalar_60
  %_p_scalar_62 = load double* %p_scevgep16
  %p_63 = fadd double %p_61, %_p_scalar_62
  %_p_scalar_64 = load double* %p_scevgep11
  %p_65 = fadd double %p_63, %_p_scalar_64
  %_p_scalar_66 = load double* %p_scevgep12
  %p_67 = fadd double %p_65, %_p_scalar_66
  %_p_scalar_68 = load double* %p_scevgep17
  %p_69 = fadd double %p_67, %_p_scalar_68
  %_p_scalar_70 = load double* %p_scevgep13
  %p_71 = fadd double %p_69, %_p_scalar_70
  %_p_scalar_72 = load double* %p_scevgep14
  %p_73 = fadd double %p_71, %_p_scalar_72
  %p_74 = fdiv double %p_73, 9.000000e+00
  store double %p_74, double* %p_scevgep11
  %polly.indvar_next54 = add nsw i64 %polly.indvar53, 1
  %polly.adjust_ub55 = sub i64 %10, 1
  %polly.loop_cond56 = icmp sle i64 %polly.indvar53, %polly.adjust_ub55
  br i1 %polly.loop_cond56, label %polly.loop_header49, label %polly.loop_exit51
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, [2000 x double]* noalias %A) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %n, 0
  br i1 %5, label %.preheader.lr.ph, label %22

.preheader.lr.ph:                                 ; preds = %.split
  %6 = zext i32 %n to i64
  %7 = zext i32 %n to i64
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
  %scevgep = getelementptr [2000 x double]* %A, i64 %indvar4, i64 %indvar
  %13 = srem i32 %12, 20
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %15, label %17

; <label>:15                                      ; preds = %10
  %16 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %16) #4
  br label %17

; <label>:17                                      ; preds = %15, %10
  %18 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %19 = load double* %scevgep, align 8, !tbaa !6
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
  %23 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %24 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %25 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
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
!2 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{metadata !3, metadata !3, i64 0}
!6 = metadata !{metadata !7, metadata !7, i64 0}
!7 = metadata !{metadata !"double", metadata !3, i64 0}
