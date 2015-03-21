; ModuleID = './stencils/fdtd-2d/fdtd-2d.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [3 x i8] c"ex\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1
@.str8 = private unnamed_addr constant [3 x i8] c"ey\00", align 1
@.str9 = private unnamed_addr constant [3 x i8] c"hz\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %0 = tail call i8* @polybench_alloc_data(i64 1200000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 1200000, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 1200000, i32 8) #3
  %3 = tail call i8* @polybench_alloc_data(i64 500, i32 8) #3
  %4 = bitcast i8* %0 to [1200 x double]*
  %5 = bitcast i8* %1 to [1200 x double]*
  %6 = bitcast i8* %2 to [1200 x double]*
  %7 = bitcast i8* %3 to double*
  tail call void @init_array(i32 500, i32 1000, i32 1200, [1200 x double]* %4, [1200 x double]* %5, [1200 x double]* %6, double* %7)
  tail call void (...)* @polybench_timer_start() #3
  tail call void @kernel_fdtd_2d(i32 500, i32 1000, i32 1200, [1200 x double]* %4, [1200 x double]* %5, [1200 x double]* %6, double* %7)
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
  tail call void @print_array(i32 1000, i32 1200, [1200 x double]* %4, [1200 x double]* %5, [1200 x double]* %6)
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
define internal void @init_array(i32 %tmax, i32 %nx, i32 %ny, [1200 x double]* %ex, [1200 x double]* %ey, [1200 x double]* %hz, double* %_fict_) #0 {
polly.split_new_and_old:
  %0 = zext i32 %tmax to i64
  %1 = icmp sge i64 %0, 1
  %2 = sext i32 %tmax to i64
  %3 = icmp sge i64 %2, 1
  %4 = and i1 %1, %3
  br i1 %4, label %polly.then, label %polly.merge

.preheader.lr.ph:                                 ; preds = %polly.merge
  %5 = zext i32 %ny to i64
  %6 = zext i32 %nx to i64
  %7 = icmp sgt i32 %ny, 0
  %8 = sitofp i32 %nx to double
  %9 = sitofp i32 %ny to double
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %._crit_edge
  %indvar8 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next9, %._crit_edge ]
  %i.13 = trunc i64 %indvar8 to i32
  br i1 %7, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %.preheader
  %10 = sitofp i32 %i.13 to double
  br label %11

; <label>:11                                      ; preds = %.lr.ph, %11
  %indvar = phi i64 [ 0, %.lr.ph ], [ %12, %11 ]
  %scevgep11 = getelementptr [1200 x double]* %hz, i64 %indvar8, i64 %indvar
  %scevgep10 = getelementptr [1200 x double]* %ey, i64 %indvar8, i64 %indvar
  %scevgep = getelementptr [1200 x double]* %ex, i64 %indvar8, i64 %indvar
  %12 = add i64 %indvar, 1
  %13 = trunc i64 %12 to i32
  %14 = add i64 %indvar, 2
  %15 = trunc i64 %14 to i32
  %16 = add i64 %indvar, 3
  %17 = trunc i64 %16 to i32
  %18 = sitofp i32 %13 to double
  %19 = fmul double %10, %18
  %20 = fdiv double %19, %8
  store double %20, double* %scevgep, align 8, !tbaa !6
  %21 = sitofp i32 %15 to double
  %22 = fmul double %10, %21
  %23 = fdiv double %22, %9
  store double %23, double* %scevgep10, align 8, !tbaa !6
  %24 = sitofp i32 %17 to double
  %25 = fmul double %10, %24
  %26 = fdiv double %25, %8
  store double %26, double* %scevgep11, align 8, !tbaa !6
  %exitcond = icmp ne i64 %12, %5
  br i1 %exitcond, label %11, label %._crit_edge

._crit_edge:                                      ; preds = %11, %.preheader
  %indvar.next9 = add i64 %indvar8, 1
  %exitcond12 = icmp ne i64 %indvar.next9, %6
  br i1 %exitcond12, label %.preheader, label %._crit_edge4

._crit_edge4:                                     ; preds = %._crit_edge, %polly.merge
  ret void

polly.merge:                                      ; preds = %polly.then, %polly.loop_header, %polly.split_new_and_old
  %27 = icmp sgt i32 %nx, 0
  br i1 %27, label %.preheader.lr.ph, label %._crit_edge4

polly.then:                                       ; preds = %polly.split_new_and_old
  %28 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %28
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_i.05 = trunc i64 %polly.indvar to i32
  %p_scevgep19 = getelementptr double* %_fict_, i64 %polly.indvar
  %p_ = sitofp i32 %p_i.05 to double
  store double %p_, double* %p_scevgep19
  %p_indvar.next17 = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %28, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_fdtd_2d(i32 %tmax, i32 %nx, i32 %ny, [1200 x double]* %ex, [1200 x double]* %ey, [1200 x double]* %hz, double* %_fict_) #0 {
.split:
  %0 = icmp sgt i32 %tmax, 0
  br i1 %0, label %.preheader6.lr.ph, label %._crit_edge22

.preheader6.lr.ph:                                ; preds = %.split
  %1 = zext i32 %ny to i64
  %2 = add i32 %nx, -2
  %3 = zext i32 %2 to i64
  %4 = add i64 %3, 1
  %5 = add i32 %ny, -2
  %6 = zext i32 %5 to i64
  %7 = add i64 %6, 1
  %8 = zext i32 %nx to i64
  %9 = add i32 %ny, -1
  %10 = zext i32 %9 to i64
  %11 = add i32 %nx, -1
  %12 = zext i32 %11 to i64
  %13 = zext i32 %tmax to i64
  %14 = icmp sgt i32 %ny, 0
  %15 = icmp sgt i32 %nx, 1
  %16 = icmp sgt i32 %nx, 0
  %17 = add nsw i32 %nx, -1
  %18 = icmp sgt i32 %17, 0
  %19 = add nsw i32 %ny, -1
  %20 = icmp sgt i32 %19, 0
  %21 = icmp sgt i32 %ny, 1
  br label %.preheader6

.preheader6:                                      ; preds = %.preheader6.lr.ph, %._crit_edge20
  %indvar63 = phi i64 [ 0, %.preheader6.lr.ph ], [ %indvar.next64, %._crit_edge20 ]
  %scevgep66 = getelementptr double* %_fict_, i64 %indvar63
  br i1 %14, label %.lr.ph, label %.preheader5

.preheader5:                                      ; preds = %.lr.ph, %.preheader6
  br i1 %15, label %.preheader2, label %.preheader4

.lr.ph:                                           ; preds = %.preheader6, %.lr.ph
  %indvar = phi i64 [ %indvar.next, %.lr.ph ], [ 0, %.preheader6 ]
  %scevgep = getelementptr [1200 x double]* %ey, i64 0, i64 %indvar
  %22 = load double* %scevgep66, align 8, !tbaa !6
  store double %22, double* %scevgep, align 8, !tbaa !6
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %1
  br i1 %exitcond, label %.lr.ph, label %.preheader5

.preheader4:                                      ; preds = %._crit_edge, %.preheader5
  br i1 %16, label %.preheader1, label %.preheader3

.preheader2:                                      ; preds = %.preheader5, %._crit_edge
  %indvar26 = phi i64 [ %23, %._crit_edge ], [ 0, %.preheader5 ]
  %23 = add i64 %indvar26, 1
  br i1 %14, label %.lr.ph9, label %._crit_edge

.lr.ph9:                                          ; preds = %.preheader2, %.lr.ph9
  %indvar23 = phi i64 [ %indvar.next24, %.lr.ph9 ], [ 0, %.preheader2 ]
  %scevgep30 = getelementptr [1200 x double]* %hz, i64 %indvar26, i64 %indvar23
  %scevgep29 = getelementptr [1200 x double]* %hz, i64 %23, i64 %indvar23
  %scevgep28 = getelementptr [1200 x double]* %ey, i64 %23, i64 %indvar23
  %24 = load double* %scevgep28, align 8, !tbaa !6
  %25 = load double* %scevgep29, align 8, !tbaa !6
  %26 = load double* %scevgep30, align 8, !tbaa !6
  %27 = fsub double %25, %26
  %28 = fmul double %27, 5.000000e-01
  %29 = fsub double %24, %28
  store double %29, double* %scevgep28, align 8, !tbaa !6
  %indvar.next24 = add i64 %indvar23, 1
  %exitcond25 = icmp ne i64 %indvar.next24, %1
  br i1 %exitcond25, label %.lr.ph9, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph9, %.preheader2
  %exitcond31 = icmp ne i64 %23, %4
  br i1 %exitcond31, label %.preheader2, label %.preheader4

.preheader3:                                      ; preds = %._crit_edge14, %.preheader4
  br i1 %18, label %.preheader, label %._crit_edge20

.preheader1:                                      ; preds = %.preheader4, %._crit_edge14
  %indvar38 = phi i64 [ %indvar.next39, %._crit_edge14 ], [ 0, %.preheader4 ]
  br i1 %21, label %.lr.ph13, label %._crit_edge14

.lr.ph13:                                         ; preds = %.preheader1, %.lr.ph13
  %indvar35 = phi i64 [ %30, %.lr.ph13 ], [ 0, %.preheader1 ]
  %scevgep42 = getelementptr [1200 x double]* %hz, i64 %indvar38, i64 %indvar35
  %30 = add i64 %indvar35, 1
  %scevgep41 = getelementptr [1200 x double]* %hz, i64 %indvar38, i64 %30
  %scevgep40 = getelementptr [1200 x double]* %ex, i64 %indvar38, i64 %30
  %31 = load double* %scevgep40, align 8, !tbaa !6
  %32 = load double* %scevgep41, align 8, !tbaa !6
  %33 = load double* %scevgep42, align 8, !tbaa !6
  %34 = fsub double %32, %33
  %35 = fmul double %34, 5.000000e-01
  %36 = fsub double %31, %35
  store double %36, double* %scevgep40, align 8, !tbaa !6
  %exitcond37 = icmp ne i64 %30, %7
  br i1 %exitcond37, label %.lr.ph13, label %._crit_edge14

._crit_edge14:                                    ; preds = %.lr.ph13, %.preheader1
  %indvar.next39 = add i64 %indvar38, 1
  %exitcond43 = icmp ne i64 %indvar.next39, %8
  br i1 %exitcond43, label %.preheader1, label %.preheader3

.preheader:                                       ; preds = %.preheader3, %._crit_edge18
  %indvar50 = phi i64 [ %37, %._crit_edge18 ], [ 0, %.preheader3 ]
  %37 = add i64 %indvar50, 1
  br i1 %20, label %.lr.ph17, label %._crit_edge18

.lr.ph17:                                         ; preds = %.preheader, %.lr.ph17
  %indvar47 = phi i64 [ %38, %.lr.ph17 ], [ 0, %.preheader ]
  %scevgep56 = getelementptr [1200 x double]* %ey, i64 %indvar50, i64 %indvar47
  %scevgep55 = getelementptr [1200 x double]* %ey, i64 %37, i64 %indvar47
  %scevgep54 = getelementptr [1200 x double]* %ex, i64 %indvar50, i64 %indvar47
  %38 = add i64 %indvar47, 1
  %scevgep53 = getelementptr [1200 x double]* %ex, i64 %indvar50, i64 %38
  %scevgep52 = getelementptr [1200 x double]* %hz, i64 %indvar50, i64 %indvar47
  %39 = load double* %scevgep52, align 8, !tbaa !6
  %40 = load double* %scevgep53, align 8, !tbaa !6
  %41 = load double* %scevgep54, align 8, !tbaa !6
  %42 = fsub double %40, %41
  %43 = load double* %scevgep55, align 8, !tbaa !6
  %44 = fadd double %42, %43
  %45 = load double* %scevgep56, align 8, !tbaa !6
  %46 = fsub double %44, %45
  %47 = fmul double %46, 7.000000e-01
  %48 = fsub double %39, %47
  store double %48, double* %scevgep52, align 8, !tbaa !6
  %exitcond49 = icmp ne i64 %38, %10
  br i1 %exitcond49, label %.lr.ph17, label %._crit_edge18

._crit_edge18:                                    ; preds = %.lr.ph17, %.preheader
  %exitcond57 = icmp ne i64 %37, %12
  br i1 %exitcond57, label %.preheader, label %._crit_edge20

._crit_edge20:                                    ; preds = %._crit_edge18, %.preheader3
  %indvar.next64 = add i64 %indvar63, 1
  %exitcond65 = icmp ne i64 %indvar.next64, %13
  br i1 %exitcond65, label %.preheader6, label %._crit_edge22

._crit_edge22:                                    ; preds = %._crit_edge20, %.split
  ret void
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %nx, i32 %ny, [1200 x double]* %ex, [1200 x double]* %ey, [1200 x double]* %hz) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([3 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %nx, 0
  br i1 %5, label %.preheader8.lr.ph, label %22

.preheader8.lr.ph:                                ; preds = %.split
  %6 = zext i32 %ny to i64
  %7 = zext i32 %nx to i64
  %8 = icmp sgt i32 %ny, 0
  br label %.preheader8

.preheader8:                                      ; preds = %.preheader8.lr.ph, %21
  %indvar37 = phi i64 [ 0, %.preheader8.lr.ph ], [ %indvar.next38, %21 ]
  %9 = mul i64 %7, %indvar37
  br i1 %8, label %.lr.ph18, label %21

.lr.ph18:                                         ; preds = %.preheader8
  br label %10

; <label>:10                                      ; preds = %.lr.ph18, %17
  %indvar34 = phi i64 [ 0, %.lr.ph18 ], [ %indvar.next35, %17 ]
  %11 = add i64 %9, %indvar34
  %12 = trunc i64 %11 to i32
  %scevgep39 = getelementptr [1200 x double]* %ex, i64 %indvar37, i64 %indvar34
  %13 = srem i32 %12, 20
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %15, label %17

; <label>:15                                      ; preds = %10
  %16 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %fputc6 = tail call i32 @fputc(i32 10, %struct._IO_FILE* %16) #4
  br label %17

; <label>:17                                      ; preds = %15, %10
  %18 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %19 = load double* %scevgep39, align 8, !tbaa !6
  %20 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %18, i8* getelementptr inbounds ([8 x i8]* @.str5, i64 0, i64 0), double %19) #5
  %indvar.next35 = add i64 %indvar34, 1
  %exitcond36 = icmp ne i64 %indvar.next35, %6
  br i1 %exitcond36, label %10, label %._crit_edge19

._crit_edge19:                                    ; preds = %17
  br label %21

; <label>:21                                      ; preds = %._crit_edge19, %.preheader8
  %indvar.next38 = add i64 %indvar37, 1
  %exitcond40 = icmp ne i64 %indvar.next38, %7
  br i1 %exitcond40, label %.preheader8, label %._crit_edge21

._crit_edge21:                                    ; preds = %21
  br label %22

; <label>:22                                      ; preds = %._crit_edge21, %.split
  %23 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %24 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([3 x i8]* @.str3, i64 0, i64 0)) #5
  %25 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %26 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str7, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %25) #4
  %27 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %28 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %27, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([3 x i8]* @.str8, i64 0, i64 0)) #5
  %29 = icmp sgt i32 %nx, 0
  br i1 %29, label %.preheader7.lr.ph, label %46

.preheader7.lr.ph:                                ; preds = %22
  %30 = zext i32 %ny to i64
  %31 = zext i32 %nx to i64
  %32 = icmp sgt i32 %ny, 0
  br label %.preheader7

.preheader7:                                      ; preds = %.preheader7.lr.ph, %45
  %indvar29 = phi i64 [ 0, %.preheader7.lr.ph ], [ %indvar.next30, %45 ]
  %33 = mul i64 %31, %indvar29
  br i1 %32, label %.lr.ph13, label %45

.lr.ph13:                                         ; preds = %.preheader7
  br label %34

; <label>:34                                      ; preds = %.lr.ph13, %41
  %indvar26 = phi i64 [ 0, %.lr.ph13 ], [ %indvar.next27, %41 ]
  %35 = add i64 %33, %indvar26
  %36 = trunc i64 %35 to i32
  %scevgep31 = getelementptr [1200 x double]* %ey, i64 %indvar29, i64 %indvar26
  %37 = srem i32 %36, 20
  %38 = icmp eq i32 %37, 0
  br i1 %38, label %39, label %41

; <label>:39                                      ; preds = %34
  %40 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %fputc3 = tail call i32 @fputc(i32 10, %struct._IO_FILE* %40) #4
  br label %41

; <label>:41                                      ; preds = %39, %34
  %42 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %43 = load double* %scevgep31, align 8, !tbaa !6
  %44 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %42, i8* getelementptr inbounds ([8 x i8]* @.str5, i64 0, i64 0), double %43) #5
  %indvar.next27 = add i64 %indvar26, 1
  %exitcond28 = icmp ne i64 %indvar.next27, %30
  br i1 %exitcond28, label %34, label %._crit_edge14

._crit_edge14:                                    ; preds = %41
  br label %45

; <label>:45                                      ; preds = %._crit_edge14, %.preheader7
  %indvar.next30 = add i64 %indvar29, 1
  %exitcond32 = icmp ne i64 %indvar.next30, %31
  br i1 %exitcond32, label %.preheader7, label %._crit_edge16

._crit_edge16:                                    ; preds = %45
  br label %46

; <label>:46                                      ; preds = %._crit_edge16, %22
  %47 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %48 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %47, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([3 x i8]* @.str8, i64 0, i64 0)) #5
  %49 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %50 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %49, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([3 x i8]* @.str9, i64 0, i64 0)) #5
  %51 = icmp sgt i32 %nx, 0
  br i1 %51, label %.preheader.lr.ph, label %68

.preheader.lr.ph:                                 ; preds = %46
  %52 = zext i32 %ny to i64
  %53 = zext i32 %nx to i64
  %54 = icmp sgt i32 %ny, 0
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %67
  %indvar22 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next23, %67 ]
  %55 = mul i64 %53, %indvar22
  br i1 %54, label %.lr.ph, label %67

.lr.ph:                                           ; preds = %.preheader
  br label %56

; <label>:56                                      ; preds = %.lr.ph, %63
  %indvar = phi i64 [ 0, %.lr.ph ], [ %indvar.next, %63 ]
  %57 = add i64 %55, %indvar
  %58 = trunc i64 %57 to i32
  %scevgep = getelementptr [1200 x double]* %hz, i64 %indvar22, i64 %indvar
  %59 = srem i32 %58, 20
  %60 = icmp eq i32 %59, 0
  br i1 %60, label %61, label %63

; <label>:61                                      ; preds = %56
  %62 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %62) #4
  br label %63

; <label>:63                                      ; preds = %61, %56
  %64 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %65 = load double* %scevgep, align 8, !tbaa !6
  %66 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %64, i8* getelementptr inbounds ([8 x i8]* @.str5, i64 0, i64 0), double %65) #5
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %52
  br i1 %exitcond, label %56, label %._crit_edge

._crit_edge:                                      ; preds = %63
  br label %67

; <label>:67                                      ; preds = %._crit_edge, %.preheader
  %indvar.next23 = add i64 %indvar22, 1
  %exitcond24 = icmp ne i64 %indvar.next23, %53
  br i1 %exitcond24, label %.preheader, label %._crit_edge11

._crit_edge11:                                    ; preds = %67
  br label %68

; <label>:68                                      ; preds = %._crit_edge11, %46
  %69 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %70 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %69, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([3 x i8]* @.str9, i64 0, i64 0)) #5
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
