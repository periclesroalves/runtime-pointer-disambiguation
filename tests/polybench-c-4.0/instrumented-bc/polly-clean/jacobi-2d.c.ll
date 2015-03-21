; ModuleID = './stencils/jacobi-2d/jacobi-2d.c'
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
  %0 = tail call i8* @polybench_alloc_data(i64 1690000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 1690000, i32 8) #3
  %2 = bitcast i8* %0 to [1300 x double]*
  %3 = bitcast i8* %1 to [1300 x double]*
  tail call void @init_array(i32 1300, [1300 x double]* %2, [1300 x double]* %3)
  tail call void (...)* @polybench_timer_start() #3
  tail call void @kernel_jacobi_2d(i32 500, i32 1300, [1300 x double]* %2, [1300 x double]* %3)
  tail call void (...)* @polybench_timer_stop() #3
  tail call void (...)* @polybench_timer_print() #3
  %4 = icmp sgt i32 %argc, 42
  br i1 %4, label %5, label %9

; <label>:5                                       ; preds = %.split
  %6 = load i8** %argv, align 8, !tbaa !1
  %7 = load i8* %6, align 1, !tbaa !5
  %phitmp = icmp eq i8 %7, 0
  br i1 %phitmp, label %8, label %9

; <label>:8                                       ; preds = %5
  tail call void @print_array(i32 1300, [1300 x double]* %2)
  br label %9

; <label>:9                                       ; preds = %5, %8, %.split
  tail call void @free(i8* %0) #3
  tail call void @free(i8* %1) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %n, [1300 x double]* %A, [1300 x double]* %B) #0 {
.split:
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.preheader.lr.ph, label %._crit_edge3

.preheader.lr.ph:                                 ; preds = %.split
  %1 = zext i32 %n to i64
  %2 = sitofp i32 %n to double
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %._crit_edge
  %indvar4 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next5, %._crit_edge ]
  %i.02 = trunc i64 %indvar4 to i32
  br i1 %0, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %.preheader
  %3 = sitofp i32 %i.02 to double
  br label %4

; <label>:4                                       ; preds = %.lr.ph, %4
  %indvar = phi i64 [ 0, %.lr.ph ], [ %indvar.next, %4 ]
  %scevgep6 = getelementptr [1300 x double]* %B, i64 %indvar4, i64 %indvar
  %scevgep = getelementptr [1300 x double]* %A, i64 %indvar4, i64 %indvar
  %5 = add i64 %indvar, 2
  %6 = trunc i64 %5 to i32
  %7 = add i64 %indvar, 3
  %8 = trunc i64 %7 to i32
  %9 = sitofp i32 %6 to double
  %10 = fmul double %3, %9
  %11 = fadd double %10, 2.000000e+00
  %12 = fdiv double %11, %2
  store double %12, double* %scevgep, align 8, !tbaa !6
  %13 = sitofp i32 %8 to double
  %14 = fmul double %3, %13
  %15 = fadd double %14, 3.000000e+00
  %16 = fdiv double %15, %2
  store double %16, double* %scevgep6, align 8, !tbaa !6
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %1
  br i1 %exitcond, label %4, label %._crit_edge

._crit_edge:                                      ; preds = %4, %.preheader
  %indvar.next5 = add i64 %indvar4, 1
  %exitcond7 = icmp ne i64 %indvar.next5, %1
  br i1 %exitcond7, label %.preheader, label %._crit_edge3

._crit_edge3:                                     ; preds = %._crit_edge, %.split
  ret void
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_jacobi_2d(i32 %tsteps, i32 %n, [1300 x double]* %A, [1300 x double]* %B) #0 {
.split:
  %0 = icmp sgt i32 %tsteps, 0
  br i1 %0, label %.preheader3.lr.ph, label %._crit_edge14

.preheader3.lr.ph:                                ; preds = %.split
  %1 = add i32 %n, -3
  %2 = zext i32 %1 to i64
  %3 = add i64 %2, 1
  %4 = add nsw i32 %n, -1
  %5 = icmp sgt i32 %4, 1
  br label %.preheader3

.preheader3:                                      ; preds = %.preheader3.lr.ph, %._crit_edge12
  %t.013 = phi i32 [ 0, %.preheader3.lr.ph ], [ %34, %._crit_edge12 ]
  br i1 %5, label %.preheader1, label %.preheader2

.preheader2:                                      ; preds = %._crit_edge, %.preheader3
  br i1 %5, label %.preheader, label %._crit_edge12

.preheader1:                                      ; preds = %.preheader3, %._crit_edge
  %indvar15 = phi i64 [ %7, %._crit_edge ], [ 0, %.preheader3 ]
  %6 = add i64 %indvar15, 2
  %7 = add i64 %indvar15, 1
  br i1 %5, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %.preheader1, %.lr.ph
  %indvar = phi i64 [ %8, %.lr.ph ], [ 0, %.preheader1 ]
  %8 = add i64 %indvar, 1
  %scevgep18 = getelementptr [1300 x double]* %A, i64 %indvar15, i64 %8
  %scevgep17 = getelementptr [1300 x double]* %A, i64 %6, i64 %8
  %9 = add i64 %indvar, 2
  %scevgep21 = getelementptr [1300 x double]* %A, i64 %7, i64 %9
  %scevgep20 = getelementptr [1300 x double]* %A, i64 %7, i64 %indvar
  %scevgep19 = getelementptr [1300 x double]* %B, i64 %7, i64 %8
  %scevgep = getelementptr [1300 x double]* %A, i64 %7, i64 %8
  %10 = load double* %scevgep, align 8, !tbaa !6
  %11 = load double* %scevgep20, align 8, !tbaa !6
  %12 = fadd double %10, %11
  %13 = load double* %scevgep21, align 8, !tbaa !6
  %14 = fadd double %12, %13
  %15 = load double* %scevgep17, align 8, !tbaa !6
  %16 = fadd double %14, %15
  %17 = load double* %scevgep18, align 8, !tbaa !6
  %18 = fadd double %16, %17
  %19 = fmul double %18, 2.000000e-01
  store double %19, double* %scevgep19, align 8, !tbaa !6
  %exitcond = icmp ne i64 %8, %3
  br i1 %exitcond, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %.preheader1
  %exitcond22 = icmp ne i64 %7, %3
  br i1 %exitcond22, label %.preheader1, label %.preheader2

.preheader:                                       ; preds = %.preheader2, %._crit_edge9
  %indvar32 = phi i64 [ %21, %._crit_edge9 ], [ 0, %.preheader2 ]
  %20 = add i64 %indvar32, 2
  %21 = add i64 %indvar32, 1
  br i1 %5, label %.lr.ph8, label %._crit_edge9

.lr.ph8:                                          ; preds = %.preheader, %.lr.ph8
  %indvar29 = phi i64 [ %22, %.lr.ph8 ], [ 0, %.preheader ]
  %22 = add i64 %indvar29, 1
  %scevgep36 = getelementptr [1300 x double]* %B, i64 %indvar32, i64 %22
  %scevgep35 = getelementptr [1300 x double]* %B, i64 %20, i64 %22
  %23 = add i64 %indvar29, 2
  %scevgep39 = getelementptr [1300 x double]* %B, i64 %21, i64 %23
  %scevgep38 = getelementptr [1300 x double]* %B, i64 %21, i64 %indvar29
  %scevgep37 = getelementptr [1300 x double]* %A, i64 %21, i64 %22
  %scevgep34 = getelementptr [1300 x double]* %B, i64 %21, i64 %22
  %24 = load double* %scevgep34, align 8, !tbaa !6
  %25 = load double* %scevgep38, align 8, !tbaa !6
  %26 = fadd double %24, %25
  %27 = load double* %scevgep39, align 8, !tbaa !6
  %28 = fadd double %26, %27
  %29 = load double* %scevgep35, align 8, !tbaa !6
  %30 = fadd double %28, %29
  %31 = load double* %scevgep36, align 8, !tbaa !6
  %32 = fadd double %30, %31
  %33 = fmul double %32, 2.000000e-01
  store double %33, double* %scevgep37, align 8, !tbaa !6
  %exitcond31 = icmp ne i64 %22, %3
  br i1 %exitcond31, label %.lr.ph8, label %._crit_edge9

._crit_edge9:                                     ; preds = %.lr.ph8, %.preheader
  %exitcond40 = icmp ne i64 %21, %3
  br i1 %exitcond40, label %.preheader, label %._crit_edge12

._crit_edge12:                                    ; preds = %._crit_edge9, %.preheader2
  %34 = add nsw i32 %t.013, 1
  %exitcond47 = icmp ne i32 %34, %tsteps
  br i1 %exitcond47, label %.preheader3, label %._crit_edge14

._crit_edge14:                                    ; preds = %._crit_edge12, %.split
  ret void
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, [1300 x double]* %A) #0 {
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
  %scevgep = getelementptr [1300 x double]* %A, i64 %indvar4, i64 %indvar
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
