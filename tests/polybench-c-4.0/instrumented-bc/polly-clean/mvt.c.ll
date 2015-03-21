; ModuleID = './linear-algebra/kernels/mvt/mvt.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [3 x i8] c"x1\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [3 x i8] c"x2\00", align 1
@.str8 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %0 = tail call i8* @polybench_alloc_data(i64 4000000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %3 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %4 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %5 = bitcast i8* %1 to double*
  %6 = bitcast i8* %2 to double*
  %7 = bitcast i8* %3 to double*
  %8 = bitcast i8* %4 to double*
  %9 = bitcast i8* %0 to [2000 x double]*
  tail call void @init_array(i32 2000, double* %5, double* %6, double* %7, double* %8, [2000 x double]* %9)
  tail call void (...)* @polybench_timer_start() #3
  tail call void @kernel_mvt(i32 2000, double* %5, double* %6, double* %7, double* %8, [2000 x double]* %9)
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
  tail call void @print_array(i32 2000, double* %5, double* %6)
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
define internal void @init_array(i32 %n, double* %x1, double* %x2, double* %y_1, double* %y_2, [2000 x double]* %A) #0 {
.split:
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.lr.ph5, label %._crit_edge6

.lr.ph5:                                          ; preds = %.split
  %1 = zext i32 %n to i64
  %2 = sitofp i32 %n to double
  br label %3

; <label>:3                                       ; preds = %.lr.ph5, %polly.merge
  %4 = phi i64 [ 0, %.lr.ph5 ], [ %6, %polly.merge ]
  %5 = mul i64 %4, 16000
  %i.02 = trunc i64 %4 to i32
  %6 = add i64 %4, 1
  %7 = trunc i64 %6 to i32
  %scevgep11 = getelementptr double* %x1, i64 %4
  %scevgep12 = getelementptr double* %x2, i64 %4
  %8 = add i64 %4, 3
  %9 = trunc i64 %8 to i32
  %scevgep13 = getelementptr double* %y_1, i64 %4
  %10 = add i64 %4, 4
  %11 = trunc i64 %10 to i32
  %scevgep14 = getelementptr double* %y_2, i64 %4
  %12 = srem i32 %i.02, %n
  %13 = sitofp i32 %12 to double
  %14 = fdiv double %13, %2
  store double %14, double* %scevgep11, align 8, !tbaa !6
  %15 = srem i32 %7, %n
  %16 = sitofp i32 %15 to double
  %17 = fdiv double %16, %2
  store double %17, double* %scevgep12, align 8, !tbaa !6
  %18 = srem i32 %9, %n
  %19 = sitofp i32 %18 to double
  %20 = fdiv double %19, %2
  store double %20, double* %scevgep13, align 8, !tbaa !6
  %21 = srem i32 %11, %n
  %22 = sitofp i32 %21 to double
  %23 = fdiv double %22, %2
  store double %23, double* %scevgep14, align 8, !tbaa !6
  br i1 %0, label %polly.cond, label %polly.merge

polly.merge:                                      ; preds = %polly.then17, %polly.loop_header, %polly.cond, %3
  %exitcond9 = icmp ne i64 %6, %1
  br i1 %exitcond9, label %3, label %._crit_edge6

._crit_edge6:                                     ; preds = %polly.merge, %.split
  ret void

polly.cond:                                       ; preds = %3
  %24 = srem i64 %5, 8
  %25 = icmp eq i64 %24, 0
  %26 = icmp sge i64 %1, 1
  %or.cond = and i1 %25, %26
  br i1 %or.cond, label %polly.then17, label %polly.merge

polly.then17:                                     ; preds = %polly.cond
  %27 = add i64 %1, -1
  %polly.loop_guard = icmp sle i64 0, %27
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then17, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then17 ]
  %p_scevgep = getelementptr [2000 x double]* %A, i64 %4, i64 %polly.indvar
  %p_ = mul i64 %4, %polly.indvar
  %p_18 = trunc i64 %p_ to i32
  %p_19 = srem i32 %p_18, %n
  %p_20 = sitofp i32 %p_19 to double
  %p_21 = fdiv double %p_20, %2
  store double %p_21, double* %p_scevgep
  %p_indvar.next = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %27, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_mvt(i32 %n, double* %x1, double* %x2, double* %y_1, double* %y_2, [2000 x double]* %A) #0 {
.split:
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.preheader2.lr.ph, label %.preheader1

.preheader2.lr.ph:                                ; preds = %.split
  %1 = zext i32 %n to i64
  br label %.preheader2

.preheader2:                                      ; preds = %.preheader2.lr.ph, %._crit_edge8
  %indvar19 = phi i64 [ 0, %.preheader2.lr.ph ], [ %indvar.next20, %._crit_edge8 ]
  %scevgep25 = getelementptr double* %x1, i64 %indvar19
  br i1 %0, label %.lr.ph7, label %._crit_edge8

.preheader1:                                      ; preds = %._crit_edge8, %.split
  br i1 %0, label %.preheader.lr.ph, label %._crit_edge5

.preheader.lr.ph:                                 ; preds = %.preheader1
  %2 = zext i32 %n to i64
  br label %.preheader

.lr.ph7:                                          ; preds = %.preheader2, %.lr.ph7
  %indvar16 = phi i64 [ %indvar.next17, %.lr.ph7 ], [ 0, %.preheader2 ]
  %scevgep21 = getelementptr [2000 x double]* %A, i64 %indvar19, i64 %indvar16
  %scevgep22 = getelementptr double* %y_1, i64 %indvar16
  %3 = load double* %scevgep25, align 8, !tbaa !6
  %4 = load double* %scevgep21, align 8, !tbaa !6
  %5 = load double* %scevgep22, align 8, !tbaa !6
  %6 = fmul double %4, %5
  %7 = fadd double %3, %6
  store double %7, double* %scevgep25, align 8, !tbaa !6
  %indvar.next17 = add i64 %indvar16, 1
  %exitcond18 = icmp ne i64 %indvar.next17, %1
  br i1 %exitcond18, label %.lr.ph7, label %._crit_edge8

._crit_edge8:                                     ; preds = %.lr.ph7, %.preheader2
  %indvar.next20 = add i64 %indvar19, 1
  %exitcond23 = icmp ne i64 %indvar.next20, %1
  br i1 %exitcond23, label %.preheader2, label %.preheader1

.preheader:                                       ; preds = %.preheader.lr.ph, %._crit_edge
  %indvar10 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next11, %._crit_edge ]
  %scevgep15 = getelementptr double* %x2, i64 %indvar10
  br i1 %0, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %.preheader, %.lr.ph
  %indvar = phi i64 [ %indvar.next, %.lr.ph ], [ 0, %.preheader ]
  %scevgep = getelementptr [2000 x double]* %A, i64 %indvar, i64 %indvar10
  %scevgep12 = getelementptr double* %y_2, i64 %indvar
  %8 = load double* %scevgep15, align 8, !tbaa !6
  %9 = load double* %scevgep, align 8, !tbaa !6
  %10 = load double* %scevgep12, align 8, !tbaa !6
  %11 = fmul double %9, %10
  %12 = fadd double %8, %11
  store double %12, double* %scevgep15, align 8, !tbaa !6
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %2
  br i1 %exitcond, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %.preheader
  %indvar.next11 = add i64 %indvar10, 1
  %exitcond13 = icmp ne i64 %indvar.next11, %2
  br i1 %exitcond13, label %.preheader, label %._crit_edge5

._crit_edge5:                                     ; preds = %._crit_edge, %.preheader1
  ret void
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, double* %x1, double* %x2) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([3 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %n, 0
  br i1 %5, label %.lr.ph7, label %16

.lr.ph7:                                          ; preds = %.split
  %6 = zext i32 %n to i64
  br label %7

; <label>:7                                       ; preds = %.lr.ph7, %12
  %indvar9 = phi i64 [ 0, %.lr.ph7 ], [ %indvar.next10, %12 ]
  %i.05 = trunc i64 %indvar9 to i32
  %scevgep12 = getelementptr double* %x1, i64 %indvar9
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
  %18 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %17, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([3 x i8]* @.str3, i64 0, i64 0)) #5
  %19 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %20 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %19, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([3 x i8]* @.str7, i64 0, i64 0)) #5
  %21 = icmp sgt i32 %n, 0
  br i1 %21, label %.lr.ph, label %32

.lr.ph:                                           ; preds = %16
  %22 = zext i32 %n to i64
  br label %23

; <label>:23                                      ; preds = %.lr.ph, %28
  %indvar = phi i64 [ 0, %.lr.ph ], [ %indvar.next, %28 ]
  %i.14 = trunc i64 %indvar to i32
  %scevgep = getelementptr double* %x2, i64 %indvar
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
  %34 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %33, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([3 x i8]* @.str7, i64 0, i64 0)) #5
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
