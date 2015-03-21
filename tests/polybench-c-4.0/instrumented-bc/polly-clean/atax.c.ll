; ModuleID = './linear-algebra/kernels/atax/atax.c'
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
  %0 = tail call i8* @polybench_alloc_data(i64 3990000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 2100, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 2100, i32 8) #3
  %3 = tail call i8* @polybench_alloc_data(i64 1900, i32 8) #3
  %4 = bitcast i8* %0 to [2100 x double]*
  %5 = bitcast i8* %1 to double*
  tail call void @init_array(i32 1900, i32 2100, [2100 x double]* %4, double* %5)
  tail call void (...)* @polybench_timer_start() #3
  %6 = bitcast i8* %2 to double*
  %7 = bitcast i8* %3 to double*
  tail call void @kernel_atax(i32 1900, i32 2100, [2100 x double]* %4, double* %5, double* %6, double* %7)
  tail call void (...)* @polybench_timer_stop() #3
  tail call void (...)* @polybench_timer_print() #3
  %8 = icmp sgt i32 %argc, 42
  br i1 %8, label %9, label %13

; <label>:9                                       ; preds = %.split
  %10 = load i8** %argv, align 8, !tbaa !1
  %11 = load i8* %10, align 1, !tbaa !5
  %phitmp = icmp eq i8 %11, 0
  br i1 %phitmp, label %12, label %13

; <label>:12                                      ; preds = %9
  tail call void @print_array(i32 2100, double* %6)
  br label %13

; <label>:13                                      ; preds = %9, %12, %.split
  tail call void @free(i8* %0) #3
  tail call void @free(i8* %1) #3
  tail call void @free(i8* %2) #3
  tail call void @free(i8* %3) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %m, i32 %n, [2100 x double]* %A, double* %x) #0 {
polly.split_new_and_old53:
  %0 = zext i32 %n to i64
  %1 = sext i32 %n to i64
  %2 = icmp sge i64 %1, 1
  %3 = icmp sge i64 %0, 1
  %4 = and i1 %2, %3
  br i1 %4, label %polly.then58, label %polly.merge57

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit25, %polly.merge57
  ret void

polly.then:                                       ; preds = %polly.merge57
  %5 = add i64 %63, -1
  %polly.loop_guard = icmp sle i64 0, %5
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit25
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit25 ], [ 0, %polly.then ]
  %6 = mul i64 -3, %63
  %7 = add i64 %6, %0
  %8 = add i64 %7, 5
  %9 = sub i64 %8, 32
  %10 = add i64 %9, 1
  %11 = icmp slt i64 %8, 0
  %12 = select i1 %11, i64 %10, i64 %8
  %13 = sdiv i64 %12, 32
  %14 = mul i64 -32, %13
  %15 = mul i64 -32, %63
  %16 = add i64 %14, %15
  %17 = mul i64 -32, %polly.indvar
  %18 = mul i64 -3, %polly.indvar
  %19 = add i64 %18, %0
  %20 = add i64 %19, 5
  %21 = sub i64 %20, 32
  %22 = add i64 %21, 1
  %23 = icmp slt i64 %20, 0
  %24 = select i1 %23, i64 %22, i64 %20
  %25 = sdiv i64 %24, 32
  %26 = mul i64 -32, %25
  %27 = add i64 %17, %26
  %28 = add i64 %27, -640
  %29 = icmp sgt i64 %16, %28
  %30 = select i1 %29, i64 %16, i64 %28
  %31 = mul i64 -20, %polly.indvar
  %polly.loop_guard26 = icmp sle i64 %30, %31
  br i1 %polly.loop_guard26, label %polly.loop_header23, label %polly.loop_exit25

polly.loop_exit25:                                ; preds = %polly.loop_exit34, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %5, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header23:                              ; preds = %polly.loop_header, %polly.loop_exit34
  %polly.indvar27 = phi i64 [ %polly.indvar_next28, %polly.loop_exit34 ], [ %30, %polly.loop_header ]
  %32 = mul i64 -1, %polly.indvar27
  %33 = mul i64 -1, %0
  %34 = add i64 %32, %33
  %35 = add i64 %34, -30
  %36 = add i64 %35, 20
  %37 = sub i64 %36, 1
  %38 = icmp slt i64 %35, 0
  %39 = select i1 %38, i64 %35, i64 %37
  %40 = sdiv i64 %39, 20
  %41 = icmp sgt i64 %40, %polly.indvar
  %42 = select i1 %41, i64 %40, i64 %polly.indvar
  %43 = sub i64 %32, 20
  %44 = add i64 %43, 1
  %45 = icmp slt i64 %32, 0
  %46 = select i1 %45, i64 %44, i64 %32
  %47 = sdiv i64 %46, 20
  %48 = add i64 %polly.indvar, 31
  %49 = icmp slt i64 %47, %48
  %50 = select i1 %49, i64 %47, i64 %48
  %51 = icmp slt i64 %50, %5
  %52 = select i1 %51, i64 %50, i64 %5
  %polly.loop_guard35 = icmp sle i64 %42, %52
  br i1 %polly.loop_guard35, label %polly.loop_header32, label %polly.loop_exit34

polly.loop_exit34:                                ; preds = %polly.loop_exit43, %polly.loop_header23
  %polly.indvar_next28 = add nsw i64 %polly.indvar27, 32
  %polly.adjust_ub29 = sub i64 %31, 32
  %polly.loop_cond30 = icmp sle i64 %polly.indvar27, %polly.adjust_ub29
  br i1 %polly.loop_cond30, label %polly.loop_header23, label %polly.loop_exit25

polly.loop_header32:                              ; preds = %polly.loop_header23, %polly.loop_exit43
  %polly.indvar36 = phi i64 [ %polly.indvar_next37, %polly.loop_exit43 ], [ %42, %polly.loop_header23 ]
  %53 = mul i64 -20, %polly.indvar36
  %54 = add i64 %53, %33
  %55 = add i64 %54, 1
  %56 = icmp sgt i64 %polly.indvar27, %55
  %57 = select i1 %56, i64 %polly.indvar27, i64 %55
  %58 = add i64 %polly.indvar27, 31
  %59 = icmp slt i64 %53, %58
  %60 = select i1 %59, i64 %53, i64 %58
  %polly.loop_guard44 = icmp sle i64 %57, %60
  br i1 %polly.loop_guard44, label %polly.loop_header41, label %polly.loop_exit43

polly.loop_exit43:                                ; preds = %polly.loop_header41, %polly.loop_header32
  %polly.indvar_next37 = add nsw i64 %polly.indvar36, 1
  %polly.adjust_ub38 = sub i64 %52, 1
  %polly.loop_cond39 = icmp sle i64 %polly.indvar36, %polly.adjust_ub38
  br i1 %polly.loop_cond39, label %polly.loop_header32, label %polly.loop_exit34

polly.loop_header41:                              ; preds = %polly.loop_header32, %polly.loop_header41
  %polly.indvar45 = phi i64 [ %polly.indvar_next46, %polly.loop_header41 ], [ %57, %polly.loop_header32 ]
  %61 = mul i64 -1, %polly.indvar45
  %62 = add i64 %53, %61
  %p_.moved.to. = mul nsw i32 %m, 5
  %p_.moved.to.17 = sitofp i32 %p_.moved.to. to double
  %p_ = add i64 %polly.indvar36, %62
  %p_49 = trunc i64 %p_ to i32
  %p_scevgep = getelementptr [2100 x double]* %A, i64 %polly.indvar36, i64 %62
  %p_50 = srem i32 %p_49, %n
  %p_51 = sitofp i32 %p_50 to double
  %p_52 = fdiv double %p_51, %p_.moved.to.17
  store double %p_52, double* %p_scevgep
  %p_indvar.next = add i64 %62, 1
  %polly.indvar_next46 = add nsw i64 %polly.indvar45, 1
  %polly.adjust_ub47 = sub i64 %60, 1
  %polly.loop_cond48 = icmp sle i64 %polly.indvar45, %polly.adjust_ub47
  br i1 %polly.loop_cond48, label %polly.loop_header41, label %polly.loop_exit43

polly.merge57:                                    ; preds = %polly.then58, %polly.loop_header60, %polly.split_new_and_old53
  %63 = zext i32 %m to i64
  %64 = sext i32 %m to i64
  %65 = icmp sge i64 %64, 1
  %66 = and i1 %65, %2
  %67 = icmp sge i64 %63, 1
  %68 = and i1 %66, %67
  %69 = and i1 %68, %3
  br i1 %69, label %polly.then, label %polly.merge

polly.then58:                                     ; preds = %polly.split_new_and_old53
  %70 = add i64 %0, -1
  %polly.loop_guard63 = icmp sle i64 0, %70
  br i1 %polly.loop_guard63, label %polly.loop_header60, label %polly.merge57

polly.loop_header60:                              ; preds = %polly.then58, %polly.loop_header60
  %polly.indvar64 = phi i64 [ %polly.indvar_next65, %polly.loop_header60 ], [ 0, %polly.then58 ]
  %p_.moved.to.20 = sitofp i32 %n to double
  %p_i.06 = trunc i64 %polly.indvar64 to i32
  %p_scevgep16 = getelementptr double* %x, i64 %polly.indvar64
  %p_69 = sitofp i32 %p_i.06 to double
  %p_70 = fdiv double %p_69, %p_.moved.to.20
  %p_71 = fadd double %p_70, 1.000000e+00
  store double %p_71, double* %p_scevgep16
  %p_indvar.next14 = add i64 %polly.indvar64, 1
  %polly.indvar_next65 = add nsw i64 %polly.indvar64, 1
  %polly.adjust_ub66 = sub i64 %70, 1
  %polly.loop_cond67 = icmp sle i64 %polly.indvar64, %polly.adjust_ub66
  br i1 %polly.loop_cond67, label %polly.loop_header60, label %polly.merge57
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_atax(i32 %m, i32 %n, [2100 x double]* %A, double* %x, double* %y, double* %tmp) #0 {
polly.split_new_and_old:
  %0 = zext i32 %n to i64
  %1 = sext i32 %n to i64
  %2 = icmp sge i64 %1, 1
  %3 = icmp sge i64 %0, 1
  %4 = and i1 %2, %3
  br i1 %4, label %polly.then, label %polly.merge

.lr.ph6:                                          ; preds = %polly.merge
  %5 = zext i32 %m to i64
  %6 = icmp sgt i32 %n, 0
  br label %7

; <label>:7                                       ; preds = %.lr.ph6, %._crit_edge
  %indvar11 = phi i64 [ 0, %.lr.ph6 ], [ %indvar.next12, %._crit_edge ]
  %scevgep22 = getelementptr double* %tmp, i64 %indvar11
  store double 0.000000e+00, double* %scevgep22, align 8, !tbaa !6
  br i1 %6, label %.lr.ph, label %.preheader

.preheader:                                       ; preds = %.lr.ph, %7
  br i1 %6, label %.lr.ph4, label %._crit_edge

.lr.ph:                                           ; preds = %7, %.lr.ph
  %indvar = phi i64 [ %indvar.next, %.lr.ph ], [ 0, %7 ]
  %scevgep = getelementptr [2100 x double]* %A, i64 %indvar11, i64 %indvar
  %scevgep13 = getelementptr double* %x, i64 %indvar
  %8 = load double* %scevgep22, align 8, !tbaa !6
  %9 = load double* %scevgep, align 8, !tbaa !6
  %10 = load double* %scevgep13, align 8, !tbaa !6
  %11 = fmul double %9, %10
  %12 = fadd double %8, %11
  store double %12, double* %scevgep22, align 8, !tbaa !6
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %0
  br i1 %exitcond, label %.lr.ph, label %.preheader

.lr.ph4:                                          ; preds = %.preheader, %.lr.ph4
  %indvar14 = phi i64 [ %indvar.next15, %.lr.ph4 ], [ 0, %.preheader ]
  %scevgep18 = getelementptr [2100 x double]* %A, i64 %indvar11, i64 %indvar14
  %scevgep17 = getelementptr double* %y, i64 %indvar14
  %13 = load double* %scevgep17, align 8, !tbaa !6
  %14 = load double* %scevgep18, align 8, !tbaa !6
  %15 = load double* %scevgep22, align 8, !tbaa !6
  %16 = fmul double %14, %15
  %17 = fadd double %13, %16
  store double %17, double* %scevgep17, align 8, !tbaa !6
  %indvar.next15 = add i64 %indvar14, 1
  %exitcond16 = icmp ne i64 %indvar.next15, %0
  br i1 %exitcond16, label %.lr.ph4, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph4, %.preheader
  %indvar.next12 = add i64 %indvar11, 1
  %exitcond19 = icmp ne i64 %indvar.next12, %5
  br i1 %exitcond19, label %7, label %._crit_edge7

._crit_edge7:                                     ; preds = %._crit_edge, %polly.merge
  ret void

polly.merge:                                      ; preds = %polly.then, %polly.loop_header, %polly.split_new_and_old
  %18 = icmp sgt i32 %m, 0
  br i1 %18, label %.lr.ph6, label %._crit_edge7

polly.then:                                       ; preds = %polly.split_new_and_old
  %19 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %19
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_scevgep26 = getelementptr double* %y, i64 %polly.indvar
  store double 0.000000e+00, double* %p_scevgep26
  %p_indvar.next24 = add i64 %polly.indvar, 1
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
define internal void @print_array(i32 %n, double* %y) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
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
  %11 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %11) #4
  br label %12

; <label>:12                                      ; preds = %10, %7
  %13 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %14 = load double* %scevgep, align 8, !tbaa !6
  %15 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %13, i8* getelementptr inbounds ([8 x i8]* @.str5, i64 0, i64 0), double %14) #5
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %6
  br i1 %exitcond, label %7, label %._crit_edge

._crit_edge:                                      ; preds = %12
  br label %16

; <label>:16                                      ; preds = %._crit_edge, %.split
  %17 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %18 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %17, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %19 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
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
!2 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{metadata !3, metadata !3, i64 0}
!6 = metadata !{metadata !7, metadata !7, i64 0}
!7 = metadata !{metadata !"double", metadata !3, i64 0}
