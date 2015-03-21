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
define internal void @init_array(i32 %n, double* %alpha, double* %beta, [1300 x double]* %A, [1300 x double]* %B, double* %x) #0 {
.split:
  store double 1.500000e+00, double* %alpha, align 8, !tbaa !1
  store double 1.200000e+00, double* %beta, align 8, !tbaa !1
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.lr.ph5, label %._crit_edge6

.lr.ph5:                                          ; preds = %.split
  %1 = zext i32 %n to i64
  %2 = sitofp i32 %n to double
  br label %3

; <label>:3                                       ; preds = %.lr.ph5, %._crit_edge
  %4 = phi i64 [ 0, %.lr.ph5 ], [ %indvar.next8, %._crit_edge ]
  %i.02 = trunc i64 %4 to i32
  %scevgep13 = getelementptr double* %x, i64 %4
  %5 = srem i32 %i.02, %n
  %6 = sitofp i32 %5 to double
  %7 = fdiv double %6, %2
  store double %7, double* %scevgep13, align 8, !tbaa !1
  br i1 %0, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %3, %.lr.ph
  %indvar = phi i64 [ %indvar.next, %.lr.ph ], [ 0, %3 ]
  %scevgep9 = getelementptr [1300 x double]* %B, i64 %4, i64 %indvar
  %scevgep = getelementptr [1300 x double]* %A, i64 %4, i64 %indvar
  %8 = mul i64 %4, %indvar
  %9 = trunc i64 %8 to i32
  %10 = srem i32 %9, %n
  %11 = sitofp i32 %10 to double
  %12 = fdiv double %11, %2
  store double %12, double* %scevgep, align 8, !tbaa !1
  store double %12, double* %scevgep9, align 8, !tbaa !1
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %1
  br i1 %exitcond, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %3
  %indvar.next8 = add i64 %4, 1
  %exitcond10 = icmp ne i64 %indvar.next8, %1
  br i1 %exitcond10, label %3, label %._crit_edge6

._crit_edge6:                                     ; preds = %._crit_edge, %.split
  ret void
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_gesummv(i32 %n, double %alpha, double %beta, [1300 x double]* %A, [1300 x double]* %B, double* %tmp, double* %x, double* %y) #0 {
.split:
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.lr.ph4, label %._crit_edge5

.lr.ph4:                                          ; preds = %.split
  %1 = zext i32 %n to i64
  br label %2

; <label>:2                                       ; preds = %.lr.ph4, %._crit_edge
  %indvar6 = phi i64 [ 0, %.lr.ph4 ], [ %indvar.next7, %._crit_edge ]
  %scevgep13 = getelementptr double* %tmp, i64 %indvar6
  %scevgep14 = getelementptr double* %y, i64 %indvar6
  store double 0.000000e+00, double* %scevgep13, align 8, !tbaa !1
  store double 0.000000e+00, double* %scevgep14, align 8, !tbaa !1
  br i1 %0, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %2, %.lr.ph
  %indvar = phi i64 [ %indvar.next, %.lr.ph ], [ 0, %2 ]
  %scevgep9 = getelementptr [1300 x double]* %B, i64 %indvar6, i64 %indvar
  %scevgep = getelementptr [1300 x double]* %A, i64 %indvar6, i64 %indvar
  %scevgep8 = getelementptr double* %x, i64 %indvar
  %3 = load double* %scevgep, align 8, !tbaa !1
  %4 = load double* %scevgep8, align 8, !tbaa !1
  %5 = fmul double %3, %4
  %6 = load double* %scevgep13, align 8, !tbaa !1
  %7 = fadd double %5, %6
  store double %7, double* %scevgep13, align 8, !tbaa !1
  %8 = load double* %scevgep9, align 8, !tbaa !1
  %9 = load double* %scevgep8, align 8, !tbaa !1
  %10 = fmul double %8, %9
  %11 = load double* %scevgep14, align 8, !tbaa !1
  %12 = fadd double %10, %11
  store double %12, double* %scevgep14, align 8, !tbaa !1
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %1
  br i1 %exitcond, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %2
  %13 = load double* %scevgep13, align 8, !tbaa !1
  %14 = fmul double %13, %alpha
  %15 = load double* %scevgep14, align 8, !tbaa !1
  %16 = fmul double %15, %beta
  %17 = fadd double %14, %16
  store double %17, double* %scevgep14, align 8, !tbaa !1
  %indvar.next7 = add i64 %indvar6, 1
  %exitcond10 = icmp ne i64 %indvar.next7, %1
  br i1 %exitcond10, label %2, label %._crit_edge5

._crit_edge5:                                     ; preds = %._crit_edge, %.split
  ret void
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, double* %y) #0 {
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
