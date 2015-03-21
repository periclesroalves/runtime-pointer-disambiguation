; ModuleID = './stencils/jacobi-1d/jacobi-1d.c'
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
  %0 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %2 = bitcast i8* %0 to double*
  %3 = bitcast i8* %1 to double*
  tail call void @init_array(i32 2000, double* %2, double* %3)
  tail call void (...)* @polybench_timer_start() #3
  tail call void @kernel_jacobi_1d(i32 500, i32 2000, double* %2, double* %3)
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
  tail call void @print_array(i32 2000, double* %2)
  br label %9

; <label>:9                                       ; preds = %5, %8, %.split
  tail call void @free(i8* %0) #3
  tail call void @free(i8* %1) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %n, double* %A, double* %B) #0 {
.split:
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %.split
  %1 = zext i32 %n to i64
  %2 = sitofp i32 %n to double
  br label %3

; <label>:3                                       ; preds = %.lr.ph, %3
  %indvar = phi i64 [ 0, %.lr.ph ], [ %indvar.next, %3 ]
  %i.01 = trunc i64 %indvar to i32
  %scevgep = getelementptr double* %A, i64 %indvar
  %scevgep2 = getelementptr double* %B, i64 %indvar
  %4 = sitofp i32 %i.01 to double
  %5 = fadd double %4, 2.000000e+00
  %6 = fdiv double %5, %2
  store double %6, double* %scevgep, align 8, !tbaa !6
  %7 = fadd double %4, 3.000000e+00
  %8 = fdiv double %7, %2
  store double %8, double* %scevgep2, align 8, !tbaa !6
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %1
  br i1 %exitcond, label %3, label %._crit_edge

._crit_edge:                                      ; preds = %3, %.split
  ret void
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_jacobi_1d(i32 %tsteps, i32 %n, double* %A, double* %B) #0 {
.split:
  %0 = icmp sgt i32 %tsteps, 0
  br i1 %0, label %.preheader1.lr.ph, label %._crit_edge6

.preheader1.lr.ph:                                ; preds = %.split
  %1 = add i32 %n, -1
  %2 = add i32 %n, -3
  %3 = zext i32 %2 to i64
  %4 = add i64 %3, 1
  %5 = add nsw i32 %n, -1
  %6 = icmp sgt i32 %5, 1
  br label %.preheader1

.preheader1:                                      ; preds = %.preheader1.lr.ph, %._crit_edge
  %t.05 = phi i32 [ 0, %.preheader1.lr.ph ], [ %31, %._crit_edge ]
  br i1 %6, label %.lr.ph, label %.preheader

..preheader_crit_edge:                            ; preds = %.lr.ph
  br label %.preheader

.preheader:                                       ; preds = %..preheader_crit_edge, %.preheader1
  %i.0.lcssa.reg2mem.0 = phi i32 [ %1, %..preheader_crit_edge ], [ 1, %.preheader1 ]
  br i1 %6, label %.lr.ph4, label %._crit_edge

.lr.ph4:                                          ; preds = %.preheader
  %7 = add nsw i32 %i.0.lcssa.reg2mem.0, -1
  %8 = sext i32 %7 to i64
  %9 = getelementptr inbounds double* %B, i64 %8
  %10 = sext i32 %i.0.lcssa.reg2mem.0 to i64
  %11 = getelementptr inbounds double* %B, i64 %10
  %12 = add nsw i32 %i.0.lcssa.reg2mem.0, 1
  %13 = sext i32 %12 to i64
  %14 = getelementptr inbounds double* %B, i64 %13
  br label %23

.lr.ph:                                           ; preds = %.preheader1, %.lr.ph
  %indvar = phi i64 [ %15, %.lr.ph ], [ 0, %.preheader1 ]
  %15 = add i64 %indvar, 1
  %scevgep = getelementptr double* %A, i64 %15
  %16 = add i64 %indvar, 2
  %scevgep7 = getelementptr double* %A, i64 %16
  %scevgep8 = getelementptr double* %B, i64 %15
  %scevgep9 = getelementptr double* %A, i64 %indvar
  %17 = load double* %scevgep9, align 8, !tbaa !6
  %18 = load double* %scevgep, align 8, !tbaa !6
  %19 = fadd double %17, %18
  %20 = load double* %scevgep7, align 8, !tbaa !6
  %21 = fadd double %19, %20
  %22 = fmul double %21, 3.333300e-01
  store double %22, double* %scevgep8, align 8, !tbaa !6
  %exitcond = icmp ne i64 %15, %4
  br i1 %exitcond, label %.lr.ph, label %..preheader_crit_edge

; <label>:23                                      ; preds = %.lr.ph4, %23
  %indvar10 = phi i64 [ 0, %.lr.ph4 ], [ %24, %23 ]
  %24 = add i64 %indvar10, 1
  %scevgep13 = getelementptr double* %A, i64 %24
  %25 = load double* %9, align 8, !tbaa !6
  %26 = load double* %11, align 8, !tbaa !6
  %27 = fadd double %25, %26
  %28 = load double* %14, align 8, !tbaa !6
  %29 = fadd double %27, %28
  %30 = fmul double %29, 3.333300e-01
  store double %30, double* %scevgep13, align 8, !tbaa !6
  %exitcond12 = icmp ne i64 %24, %4
  br i1 %exitcond12, label %23, label %._crit_edge

._crit_edge:                                      ; preds = %23, %.preheader
  %31 = add nsw i32 %t.05, 1
  %exitcond14 = icmp ne i32 %31, %tsteps
  br i1 %exitcond14, label %.preheader1, label %._crit_edge6

._crit_edge6:                                     ; preds = %._crit_edge, %.split
  ret void
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, double* %A) #0 {
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
  %scevgep = getelementptr double* %A, i64 %indvar
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
