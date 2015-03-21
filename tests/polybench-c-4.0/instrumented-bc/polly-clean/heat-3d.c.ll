; ModuleID = './stencils/heat-3d/heat-3d.c'
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
  %0 = tail call i8* @polybench_alloc_data(i64 1728000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 1728000, i32 8) #3
  %2 = bitcast i8* %0 to [120 x [120 x double]]*
  %3 = bitcast i8* %1 to [120 x [120 x double]]*
  tail call void @init_array(i32 120, [120 x [120 x double]]* %2, [120 x [120 x double]]* %3)
  tail call void (...)* @polybench_timer_start() #3
  tail call void @kernel_heat_3d(i32 500, i32 120, [120 x [120 x double]]* %2, [120 x [120 x double]]* %3)
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
  tail call void @print_array(i32 120, [120 x [120 x double]]* %2)
  br label %9

; <label>:9                                       ; preds = %5, %8, %.split
  tail call void @free(i8* %0) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %n, [120 x [120 x double]]* %A, [120 x [120 x double]]* %B) #0 {
.split:
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.preheader1.lr.ph, label %._crit_edge7

.preheader1.lr.ph:                                ; preds = %.split
  %1 = zext i32 %n to i64
  %2 = sitofp i32 %n to double
  br label %.preheader1

.preheader1:                                      ; preds = %.preheader1.lr.ph, %._crit_edge4
  %indvar10 = phi i64 [ 0, %.preheader1.lr.ph ], [ %indvar.next11, %._crit_edge4 ]
  %3 = add i64 %1, %indvar10
  br i1 %0, label %.preheader, label %._crit_edge4

.preheader:                                       ; preds = %.preheader1, %._crit_edge
  %indvar8 = phi i64 [ %indvar.next9, %._crit_edge ], [ 0, %.preheader1 ]
  %4 = add i64 %3, %indvar8
  br i1 %0, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %.preheader, %.lr.ph
  %indvar = phi i64 [ %indvar.next, %.lr.ph ], [ 0, %.preheader ]
  %5 = mul i64 %indvar, -1
  %6 = add i64 %4, %5
  %7 = trunc i64 %6 to i32
  %scevgep = getelementptr [120 x [120 x double]]* %B, i64 %indvar10, i64 %indvar8, i64 %indvar
  %scevgep12 = getelementptr [120 x [120 x double]]* %A, i64 %indvar10, i64 %indvar8, i64 %indvar
  %8 = sitofp i32 %7 to double
  %9 = fmul double %8, 1.000000e+01
  %10 = fdiv double %9, %2
  store double %10, double* %scevgep, align 8, !tbaa !6
  store double %10, double* %scevgep12, align 8, !tbaa !6
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %1
  br i1 %exitcond, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %.preheader
  %indvar.next9 = add i64 %indvar8, 1
  %exitcond13 = icmp ne i64 %indvar.next9, %1
  br i1 %exitcond13, label %.preheader, label %._crit_edge4

._crit_edge4:                                     ; preds = %._crit_edge, %.preheader1
  %indvar.next11 = add i64 %indvar10, 1
  %exitcond16 = icmp ne i64 %indvar.next11, %1
  br i1 %exitcond16, label %.preheader1, label %._crit_edge7

._crit_edge7:                                     ; preds = %._crit_edge4, %.split
  ret void
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_heat_3d(i32 %tsteps, i32 %n, [120 x [120 x double]]* %A, [120 x [120 x double]]* %B) #0 {
.split:
  %0 = add i32 %n, -3
  %1 = zext i32 %0 to i64
  %2 = add i64 %1, 1
  %3 = add nsw i32 %n, -1
  %4 = icmp sgt i32 %3, 1
  br label %.preheader5

.preheader5:                                      ; preds = %.split, %._crit_edge20
  %indvar84 = phi i32 [ 0, %.split ], [ %indvar.next85, %._crit_edge20 ]
  br i1 %4, label %.preheader3, label %.preheader4

.preheader4:                                      ; preds = %._crit_edge9, %.preheader5
  br i1 %4, label %.preheader2, label %._crit_edge20

.preheader3:                                      ; preds = %.preheader5, %._crit_edge9
  %indvar22 = phi i64 [ %6, %._crit_edge9 ], [ 0, %.preheader5 ]
  %5 = add i64 %indvar22, 2
  %6 = add i64 %indvar22, 1
  br i1 %4, label %.preheader1, label %._crit_edge9

.preheader1:                                      ; preds = %.preheader3, %._crit_edge
  %indvar24 = phi i64 [ %7, %._crit_edge ], [ 0, %.preheader3 ]
  %7 = add i64 %indvar24, 1
  %8 = add i64 %indvar24, 2
  br i1 %4, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %.preheader1, %.lr.ph
  %indvar = phi i64 [ %9, %.lr.ph ], [ 0, %.preheader1 ]
  %9 = add i64 %indvar, 1
  %scevgep = getelementptr [120 x [120 x double]]* %A, i64 %5, i64 %7, i64 %9
  %scevgep27 = getelementptr [120 x [120 x double]]* %A, i64 %indvar22, i64 %7, i64 %9
  %scevgep26 = getelementptr [120 x [120 x double]]* %A, i64 %6, i64 %7, i64 %9
  %10 = add i64 %indvar, 2
  %scevgep30 = getelementptr [120 x [120 x double]]* %A, i64 %6, i64 %7, i64 %10
  %scevgep31 = getelementptr [120 x [120 x double]]* %B, i64 %6, i64 %7, i64 %9
  %scevgep32 = getelementptr [120 x [120 x double]]* %A, i64 %6, i64 %7, i64 %indvar
  %scevgep28 = getelementptr [120 x [120 x double]]* %A, i64 %6, i64 %8, i64 %9
  %scevgep29 = getelementptr [120 x [120 x double]]* %A, i64 %6, i64 %indvar24, i64 %9
  %11 = load double* %scevgep, align 8, !tbaa !6
  %12 = load double* %scevgep26, align 8, !tbaa !6
  %13 = fmul double %12, 2.000000e+00
  %14 = fsub double %11, %13
  %15 = load double* %scevgep27, align 8, !tbaa !6
  %16 = fadd double %15, %14
  %17 = fmul double %16, 1.250000e-01
  %18 = load double* %scevgep28, align 8, !tbaa !6
  %19 = fsub double %18, %13
  %20 = load double* %scevgep29, align 8, !tbaa !6
  %21 = fadd double %20, %19
  %22 = fmul double %21, 1.250000e-01
  %23 = fadd double %17, %22
  %24 = load double* %scevgep30, align 8, !tbaa !6
  %25 = fsub double %24, %13
  %26 = load double* %scevgep32, align 8, !tbaa !6
  %27 = fadd double %26, %25
  %28 = fmul double %27, 1.250000e-01
  %29 = fadd double %23, %28
  %30 = fadd double %12, %29
  store double %30, double* %scevgep31, align 8, !tbaa !6
  %exitcond = icmp ne i64 %9, %2
  br i1 %exitcond, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %.preheader1
  %exitcond33 = icmp ne i64 %7, %2
  br i1 %exitcond33, label %.preheader1, label %._crit_edge9

._crit_edge9:                                     ; preds = %._crit_edge, %.preheader3
  %exitcond42 = icmp ne i64 %6, %2
  br i1 %exitcond42, label %.preheader3, label %.preheader4

.preheader2:                                      ; preds = %.preheader4, %._crit_edge17
  %indvar54 = phi i64 [ %32, %._crit_edge17 ], [ 0, %.preheader4 ]
  %31 = add i64 %indvar54, 2
  %32 = add i64 %indvar54, 1
  br i1 %4, label %.preheader, label %._crit_edge17

.preheader:                                       ; preds = %.preheader2, %._crit_edge14
  %indvar56 = phi i64 [ %33, %._crit_edge14 ], [ 0, %.preheader2 ]
  %33 = add i64 %indvar56, 1
  %34 = add i64 %indvar56, 2
  br i1 %4, label %.lr.ph13, label %._crit_edge14

.lr.ph13:                                         ; preds = %.preheader, %.lr.ph13
  %indvar51 = phi i64 [ %35, %.lr.ph13 ], [ 0, %.preheader ]
  %35 = add i64 %indvar51, 1
  %scevgep58 = getelementptr [120 x [120 x double]]* %B, i64 %31, i64 %33, i64 %35
  %scevgep60 = getelementptr [120 x [120 x double]]* %B, i64 %indvar54, i64 %33, i64 %35
  %scevgep59 = getelementptr [120 x [120 x double]]* %B, i64 %32, i64 %33, i64 %35
  %36 = add i64 %indvar51, 2
  %scevgep63 = getelementptr [120 x [120 x double]]* %B, i64 %32, i64 %33, i64 %36
  %scevgep64 = getelementptr [120 x [120 x double]]* %A, i64 %32, i64 %33, i64 %35
  %scevgep65 = getelementptr [120 x [120 x double]]* %B, i64 %32, i64 %33, i64 %indvar51
  %scevgep61 = getelementptr [120 x [120 x double]]* %B, i64 %32, i64 %34, i64 %35
  %scevgep62 = getelementptr [120 x [120 x double]]* %B, i64 %32, i64 %indvar56, i64 %35
  %37 = load double* %scevgep58, align 8, !tbaa !6
  %38 = load double* %scevgep59, align 8, !tbaa !6
  %39 = fmul double %38, 2.000000e+00
  %40 = fsub double %37, %39
  %41 = load double* %scevgep60, align 8, !tbaa !6
  %42 = fadd double %41, %40
  %43 = fmul double %42, 1.250000e-01
  %44 = load double* %scevgep61, align 8, !tbaa !6
  %45 = fsub double %44, %39
  %46 = load double* %scevgep62, align 8, !tbaa !6
  %47 = fadd double %46, %45
  %48 = fmul double %47, 1.250000e-01
  %49 = fadd double %43, %48
  %50 = load double* %scevgep63, align 8, !tbaa !6
  %51 = fsub double %50, %39
  %52 = load double* %scevgep65, align 8, !tbaa !6
  %53 = fadd double %52, %51
  %54 = fmul double %53, 1.250000e-01
  %55 = fadd double %49, %54
  %56 = fadd double %38, %55
  store double %56, double* %scevgep64, align 8, !tbaa !6
  %exitcond53 = icmp ne i64 %35, %2
  br i1 %exitcond53, label %.lr.ph13, label %._crit_edge14

._crit_edge14:                                    ; preds = %.lr.ph13, %.preheader
  %exitcond66 = icmp ne i64 %33, %2
  br i1 %exitcond66, label %.preheader, label %._crit_edge17

._crit_edge17:                                    ; preds = %._crit_edge14, %.preheader2
  %exitcond75 = icmp ne i64 %32, %2
  br i1 %exitcond75, label %.preheader2, label %._crit_edge20

._crit_edge20:                                    ; preds = %._crit_edge17, %.preheader4
  %indvar.next85 = add i32 %indvar84, 1
  %exitcond86 = icmp ne i32 %indvar.next85, 500
  br i1 %exitcond86, label %.preheader5, label %57

; <label>:57                                      ; preds = %._crit_edge20
  ret void
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, [120 x [120 x double]]* %A) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %n, 0
  br i1 %5, label %.preheader1.lr.ph, label %29

.preheader1.lr.ph:                                ; preds = %.split
  %6 = zext i32 %n to i64
  %7 = mul i32 %n, %n
  %8 = zext i32 %n to i64
  %9 = zext i32 %n to i64
  %10 = zext i32 %7 to i64
  %11 = icmp sgt i32 %n, 0
  %12 = icmp sgt i32 %n, 0
  br label %.preheader1

.preheader1:                                      ; preds = %.preheader1.lr.ph, %28
  %indvar8 = phi i64 [ 0, %.preheader1.lr.ph ], [ %indvar.next9, %28 ]
  %13 = mul i64 %10, %indvar8
  br i1 %11, label %.preheader.lr.ph, label %28

.preheader.lr.ph:                                 ; preds = %.preheader1
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %27
  %indvar10 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next11, %27 ]
  %14 = mul i64 %9, %indvar10
  %15 = add i64 %13, %14
  br i1 %12, label %.lr.ph, label %27

.lr.ph:                                           ; preds = %.preheader
  br label %16

; <label>:16                                      ; preds = %.lr.ph, %23
  %indvar = phi i64 [ 0, %.lr.ph ], [ %indvar.next, %23 ]
  %scevgep = getelementptr [120 x [120 x double]]* %A, i64 %indvar8, i64 %indvar10, i64 %indvar
  %17 = add i64 %15, %indvar
  %18 = trunc i64 %17 to i32
  %19 = srem i32 %18, 20
  %20 = icmp eq i32 %19, 0
  br i1 %20, label %21, label %23

; <label>:21                                      ; preds = %16
  %22 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %22) #4
  br label %23

; <label>:23                                      ; preds = %21, %16
  %24 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %25 = load double* %scevgep, align 8, !tbaa !6
  %26 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %24, i8* getelementptr inbounds ([8 x i8]* @.str5, i64 0, i64 0), double %25) #5
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %6
  br i1 %exitcond, label %16, label %._crit_edge

._crit_edge:                                      ; preds = %23
  br label %27

; <label>:27                                      ; preds = %._crit_edge, %.preheader
  %indvar.next11 = add i64 %indvar10, 1
  %exitcond12 = icmp ne i64 %indvar.next11, %8
  br i1 %exitcond12, label %.preheader, label %._crit_edge5

._crit_edge5:                                     ; preds = %27
  br label %28

; <label>:28                                      ; preds = %._crit_edge5, %.preheader1
  %indvar.next9 = add i64 %indvar8, 1
  %exitcond14 = icmp ne i64 %indvar.next9, %9
  br i1 %exitcond14, label %.preheader1, label %._crit_edge7

._crit_edge7:                                     ; preds = %28
  br label %29

; <label>:29                                      ; preds = %._crit_edge7, %.split
  %30 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %31 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %30, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %32 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %33 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str7, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %32) #4
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
