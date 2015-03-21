; ModuleID = './linear-algebra/blas/gemver/gemver.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [2 x i8] c"w\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %alpha = alloca double, align 8
  %beta = alloca double, align 8
  %0 = tail call i8* @polybench_alloc_data(i64 4000000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %3 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %4 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %5 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %6 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %7 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %8 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %9 = bitcast i8* %0 to [2000 x double]*
  %10 = bitcast i8* %1 to double*
  %11 = bitcast i8* %2 to double*
  %12 = bitcast i8* %3 to double*
  %13 = bitcast i8* %4 to double*
  %14 = bitcast i8* %5 to double*
  %15 = bitcast i8* %6 to double*
  %16 = bitcast i8* %7 to double*
  %17 = bitcast i8* %8 to double*
  call void @init_array(i32 2000, double* %alpha, double* %beta, [2000 x double]* %9, double* %10, double* %11, double* %12, double* %13, double* %14, double* %15, double* %16, double* %17)
  call void (...)* @polybench_timer_start() #3
  %18 = load double* %alpha, align 8, !tbaa !1
  %19 = load double* %beta, align 8, !tbaa !1
  call void @kernel_gemver(i32 2000, double %18, double %19, [2000 x double]* %9, double* %10, double* %11, double* %12, double* %13, double* %14, double* %15, double* %16, double* %17)
  call void (...)* @polybench_timer_stop() #3
  call void (...)* @polybench_timer_print() #3
  %20 = icmp sgt i32 %argc, 42
  br i1 %20, label %21, label %25

; <label>:21                                      ; preds = %.split
  %22 = load i8** %argv, align 8, !tbaa !5
  %23 = load i8* %22, align 1, !tbaa !7
  %phitmp = icmp eq i8 %23, 0
  br i1 %phitmp, label %24, label %25

; <label>:24                                      ; preds = %21
  call void @print_array(i32 2000, double* %14)
  br label %25

; <label>:25                                      ; preds = %21, %24, %.split
  call void @free(i8* %0) #3
  call void @free(i8* %1) #3
  call void @free(i8* %2) #3
  call void @free(i8* %3) #3
  call void @free(i8* %4) #3
  call void @free(i8* %5) #3
  call void @free(i8* %6) #3
  call void @free(i8* %7) #3
  call void @free(i8* %8) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %n, double* %alpha, double* %beta, [2000 x double]* %A, double* %u1, double* %v1, double* %u2, double* %v2, double* %w, double* %x, double* %y, double* %z) #0 {
.split:
  store double 1.500000e+00, double* %alpha, align 8, !tbaa !1
  store double 1.200000e+00, double* %beta, align 8, !tbaa !1
  %0 = sitofp i32 %n to double
  %1 = icmp sgt i32 %n, 0
  br i1 %1, label %.lr.ph5, label %._crit_edge6

.lr.ph5:                                          ; preds = %.split
  %2 = zext i32 %n to i64
  br label %3

; <label>:3                                       ; preds = %.lr.ph5, %polly.merge
  %4 = phi i64 [ 0, %.lr.ph5 ], [ %6, %polly.merge ]
  %5 = mul i64 %4, 16000
  %i.02 = trunc i64 %4 to i32
  %6 = add i64 %4, 1
  %7 = trunc i64 %6 to i32
  %scevgep11 = getelementptr double* %u1, i64 %4
  %scevgep12 = getelementptr double* %u2, i64 %4
  %scevgep13 = getelementptr double* %v1, i64 %4
  %scevgep14 = getelementptr double* %v2, i64 %4
  %scevgep15 = getelementptr double* %y, i64 %4
  %scevgep16 = getelementptr double* %z, i64 %4
  %scevgep17 = getelementptr double* %x, i64 %4
  %scevgep18 = getelementptr double* %w, i64 %4
  %8 = sitofp i32 %i.02 to double
  store double %8, double* %scevgep11, align 8, !tbaa !1
  %9 = sitofp i32 %7 to double
  %10 = fdiv double %9, %0
  %11 = fmul double %10, 5.000000e-01
  store double %11, double* %scevgep12, align 8, !tbaa !1
  %12 = fmul double %10, 2.500000e-01
  store double %12, double* %scevgep13, align 8, !tbaa !1
  %13 = fdiv double %10, 6.000000e+00
  store double %13, double* %scevgep14, align 8, !tbaa !1
  %14 = fmul double %10, 1.250000e-01
  store double %14, double* %scevgep15, align 8, !tbaa !1
  %15 = fdiv double %10, 9.000000e+00
  store double %15, double* %scevgep16, align 8, !tbaa !1
  store double 0.000000e+00, double* %scevgep17, align 8, !tbaa !1
  store double 0.000000e+00, double* %scevgep18, align 8, !tbaa !1
  br i1 %1, label %polly.cond, label %polly.merge

polly.merge:                                      ; preds = %polly.then21, %polly.loop_header, %polly.cond, %3
  %exitcond9 = icmp ne i64 %6, %2
  br i1 %exitcond9, label %3, label %._crit_edge6

._crit_edge6:                                     ; preds = %polly.merge, %.split
  ret void

polly.cond:                                       ; preds = %3
  %16 = srem i64 %5, 8
  %17 = icmp eq i64 %16, 0
  %18 = icmp sge i64 %2, 1
  %or.cond = and i1 %17, %18
  br i1 %or.cond, label %polly.then21, label %polly.merge

polly.then21:                                     ; preds = %polly.cond
  %19 = add i64 %2, -1
  %polly.loop_guard = icmp sle i64 0, %19
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then21, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then21 ]
  %p_scevgep = getelementptr [2000 x double]* %A, i64 %4, i64 %polly.indvar
  %p_ = mul i64 %4, %polly.indvar
  %p_22 = trunc i64 %p_ to i32
  %p_23 = srem i32 %p_22, %n
  %p_24 = sitofp i32 %p_23 to double
  %p_25 = fdiv double %p_24, %0
  store double %p_25, double* %p_scevgep
  %p_indvar.next = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %19, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_gemver(i32 %n, double %alpha, double %beta, [2000 x double]* %A, double* %u1, double* %v1, double* %u2, double* %v2, double* %w, double* %x, double* %y, double* %z) #0 {
.split:
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.preheader5.lr.ph, label %.preheader4

.preheader5.lr.ph:                                ; preds = %.split
  %1 = zext i32 %n to i64
  br label %.preheader5

.preheader5:                                      ; preds = %.preheader5.lr.ph, %._crit_edge17
  %indvar43 = phi i64 [ 0, %.preheader5.lr.ph ], [ %indvar.next44, %._crit_edge17 ]
  %scevgep50 = getelementptr double* %u1, i64 %indvar43
  %scevgep51 = getelementptr double* %u2, i64 %indvar43
  br i1 %0, label %.lr.ph16, label %._crit_edge17

.preheader4:                                      ; preds = %._crit_edge17, %.split
  br i1 %0, label %.preheader3.lr.ph, label %.preheader2

.preheader3.lr.ph:                                ; preds = %.preheader4
  %2 = zext i32 %n to i64
  br label %.preheader3

.lr.ph16:                                         ; preds = %.preheader5, %.lr.ph16
  %indvar40 = phi i64 [ %indvar.next41, %.lr.ph16 ], [ 0, %.preheader5 ]
  %scevgep45 = getelementptr [2000 x double]* %A, i64 %indvar43, i64 %indvar40
  %scevgep46 = getelementptr double* %v1, i64 %indvar40
  %scevgep47 = getelementptr double* %v2, i64 %indvar40
  %3 = load double* %scevgep45, align 8, !tbaa !1
  %4 = load double* %scevgep50, align 8, !tbaa !1
  %5 = load double* %scevgep46, align 8, !tbaa !1
  %6 = fmul double %4, %5
  %7 = fadd double %3, %6
  %8 = load double* %scevgep51, align 8, !tbaa !1
  %9 = load double* %scevgep47, align 8, !tbaa !1
  %10 = fmul double %8, %9
  %11 = fadd double %7, %10
  store double %11, double* %scevgep45, align 8, !tbaa !1
  %indvar.next41 = add i64 %indvar40, 1
  %exitcond42 = icmp ne i64 %indvar.next41, %1
  br i1 %exitcond42, label %.lr.ph16, label %._crit_edge17

._crit_edge17:                                    ; preds = %.lr.ph16, %.preheader5
  %indvar.next44 = add i64 %indvar43, 1
  %exitcond48 = icmp ne i64 %indvar.next44, %1
  br i1 %exitcond48, label %.preheader5, label %.preheader4

.preheader3:                                      ; preds = %.preheader3.lr.ph, %._crit_edge13
  %indvar33 = phi i64 [ 0, %.preheader3.lr.ph ], [ %indvar.next34, %._crit_edge13 ]
  %scevgep39 = getelementptr double* %x, i64 %indvar33
  br i1 %0, label %.lr.ph12, label %._crit_edge13

.preheader2:                                      ; preds = %._crit_edge13, %.preheader4
  br i1 %0, label %.lr.ph10, label %.preheader1

.lr.ph10:                                         ; preds = %.preheader2
  %12 = zext i32 %n to i64
  br label %20

.lr.ph12:                                         ; preds = %.preheader3, %.lr.ph12
  %indvar30 = phi i64 [ %indvar.next31, %.lr.ph12 ], [ 0, %.preheader3 ]
  %scevgep35 = getelementptr [2000 x double]* %A, i64 %indvar30, i64 %indvar33
  %scevgep36 = getelementptr double* %y, i64 %indvar30
  %13 = load double* %scevgep39, align 8, !tbaa !1
  %14 = load double* %scevgep35, align 8, !tbaa !1
  %15 = fmul double %14, %beta
  %16 = load double* %scevgep36, align 8, !tbaa !1
  %17 = fmul double %15, %16
  %18 = fadd double %13, %17
  store double %18, double* %scevgep39, align 8, !tbaa !1
  %indvar.next31 = add i64 %indvar30, 1
  %exitcond32 = icmp ne i64 %indvar.next31, %2
  br i1 %exitcond32, label %.lr.ph12, label %._crit_edge13

._crit_edge13:                                    ; preds = %.lr.ph12, %.preheader3
  %indvar.next34 = add i64 %indvar33, 1
  %exitcond37 = icmp ne i64 %indvar.next34, %2
  br i1 %exitcond37, label %.preheader3, label %.preheader2

.preheader1:                                      ; preds = %20, %.preheader2
  br i1 %0, label %.preheader.lr.ph, label %._crit_edge8

.preheader.lr.ph:                                 ; preds = %.preheader1
  %19 = zext i32 %n to i64
  br label %.preheader

; <label>:20                                      ; preds = %.lr.ph10, %20
  %indvar25 = phi i64 [ 0, %.lr.ph10 ], [ %indvar.next26, %20 ]
  %scevgep28 = getelementptr double* %x, i64 %indvar25
  %scevgep29 = getelementptr double* %z, i64 %indvar25
  %21 = load double* %scevgep28, align 8, !tbaa !1
  %22 = load double* %scevgep29, align 8, !tbaa !1
  %23 = fadd double %21, %22
  store double %23, double* %scevgep28, align 8, !tbaa !1
  %indvar.next26 = add i64 %indvar25, 1
  %exitcond27 = icmp ne i64 %indvar.next26, %12
  br i1 %exitcond27, label %20, label %.preheader1

.preheader:                                       ; preds = %.preheader.lr.ph, %._crit_edge
  %indvar19 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next20, %._crit_edge ]
  %scevgep24 = getelementptr double* %w, i64 %indvar19
  br i1 %0, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %.preheader, %.lr.ph
  %indvar = phi i64 [ %indvar.next, %.lr.ph ], [ 0, %.preheader ]
  %scevgep = getelementptr [2000 x double]* %A, i64 %indvar19, i64 %indvar
  %scevgep21 = getelementptr double* %x, i64 %indvar
  %24 = load double* %scevgep24, align 8, !tbaa !1
  %25 = load double* %scevgep, align 8, !tbaa !1
  %26 = fmul double %25, %alpha
  %27 = load double* %scevgep21, align 8, !tbaa !1
  %28 = fmul double %26, %27
  %29 = fadd double %24, %28
  store double %29, double* %scevgep24, align 8, !tbaa !1
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %19
  br i1 %exitcond, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %.preheader
  %indvar.next20 = add i64 %indvar19, 1
  %exitcond22 = icmp ne i64 %indvar.next20, %19
  br i1 %exitcond22, label %.preheader, label %._crit_edge8

._crit_edge8:                                     ; preds = %._crit_edge, %.preheader1
  ret void
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, double* %w) #0 {
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
  %scevgep = getelementptr double* %w, i64 %indvar
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
