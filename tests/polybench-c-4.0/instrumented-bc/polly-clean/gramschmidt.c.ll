; ModuleID = './linear-algebra/solvers/gramschmidt/gramschmidt.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [2 x i8] c"R\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [2 x i8] c"Q\00", align 1
@.str8 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %0 = tail call i8* @polybench_alloc_data(i64 1200000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 1440000, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 1200000, i32 8) #3
  %3 = bitcast i8* %0 to [1200 x double]*
  %4 = bitcast i8* %1 to [1200 x double]*
  %5 = bitcast i8* %2 to [1200 x double]*
  tail call void @init_array(i32 1000, i32 1200, [1200 x double]* %3, [1200 x double]* %4, [1200 x double]* %5)
  tail call void (...)* @polybench_timer_start() #3
  tail call void @kernel_gramschmidt(i32 1000, i32 1200, [1200 x double]* %3, [1200 x double]* %4, [1200 x double]* %5)
  tail call void (...)* @polybench_timer_stop() #3
  tail call void (...)* @polybench_timer_print() #3
  %6 = icmp sgt i32 %argc, 42
  br i1 %6, label %7, label %11

; <label>:7                                       ; preds = %.split
  %8 = load i8** %argv, align 8, !tbaa !1
  %9 = load i8* %8, align 1, !tbaa !5
  %phitmp = icmp eq i8 %9, 0
  br i1 %phitmp, label %10, label %11

; <label>:10                                      ; preds = %7
  tail call void @print_array(i32 1000, i32 1200, [1200 x double]* %3, [1200 x double]* %4, [1200 x double]* %5)
  br label %11

; <label>:11                                      ; preds = %7, %10, %.split
  tail call void @free(i8* %0) #3
  tail call void @free(i8* %1) #3
  tail call void @free(i8* %2) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %m, i32 %n, [1200 x double]* %A, [1200 x double]* %R, [1200 x double]* %Q) #0 {
.split:
  %0 = icmp sgt i32 %m, 0
  br i1 %0, label %.preheader2.lr.ph, label %polly.start

.preheader2.lr.ph:                                ; preds = %.split
  %1 = zext i32 %n to i64
  %2 = zext i32 %m to i64
  %3 = icmp sgt i32 %n, 0
  %4 = sitofp i32 %m to double
  br label %.preheader2

.preheader2:                                      ; preds = %.preheader2.lr.ph, %._crit_edge8
  %5 = phi i64 [ 0, %.preheader2.lr.ph ], [ %indvar.next19, %._crit_edge8 ]
  br i1 %3, label %.lr.ph7, label %._crit_edge8

.lr.ph7:                                          ; preds = %.preheader2, %.lr.ph7
  %indvar15 = phi i64 [ %indvar.next16, %.lr.ph7 ], [ 0, %.preheader2 ]
  %scevgep21 = getelementptr [1200 x double]* %Q, i64 %5, i64 %indvar15
  %scevgep20 = getelementptr [1200 x double]* %A, i64 %5, i64 %indvar15
  %6 = mul i64 %5, %indvar15
  %7 = trunc i64 %6 to i32
  %8 = srem i32 %7, %m
  %9 = sitofp i32 %8 to double
  %10 = fdiv double %9, %4
  %11 = fmul double %10, 1.000000e+02
  %12 = fadd double %11, 1.000000e+01
  store double %12, double* %scevgep20, align 8, !tbaa !6
  store double 0.000000e+00, double* %scevgep21, align 8, !tbaa !6
  %indvar.next16 = add i64 %indvar15, 1
  %exitcond17 = icmp ne i64 %indvar.next16, %1
  br i1 %exitcond17, label %.lr.ph7, label %._crit_edge8

._crit_edge8:                                     ; preds = %.lr.ph7, %.preheader2
  %indvar.next19 = add i64 %5, 1
  %exitcond22 = icmp ne i64 %indvar.next19, %2
  br i1 %exitcond22, label %.preheader2, label %polly.start

polly.start:                                      ; preds = %._crit_edge8, %.split
  %13 = zext i32 %n to i64
  %14 = sext i32 %n to i64
  %15 = icmp sge i64 %14, 1
  %16 = icmp sge i64 %13, 1
  %17 = and i1 %15, %16
  br i1 %17, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit29, %polly.start
  ret void

polly.then:                                       ; preds = %polly.start
  %18 = add i64 %13, -1
  %polly.loop_guard = icmp sle i64 0, %18
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit29
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit29 ], [ 0, %polly.then ]
  %19 = mul i64 -11, %13
  %20 = add i64 %19, 5
  %21 = sub i64 %20, 32
  %22 = add i64 %21, 1
  %23 = icmp slt i64 %20, 0
  %24 = select i1 %23, i64 %22, i64 %20
  %25 = sdiv i64 %24, 32
  %26 = mul i64 -32, %25
  %27 = mul i64 -32, %13
  %28 = add i64 %26, %27
  %29 = mul i64 -32, %polly.indvar
  %30 = mul i64 -3, %polly.indvar
  %31 = add i64 %30, %13
  %32 = add i64 %31, 5
  %33 = sub i64 %32, 32
  %34 = add i64 %33, 1
  %35 = icmp slt i64 %32, 0
  %36 = select i1 %35, i64 %34, i64 %32
  %37 = sdiv i64 %36, 32
  %38 = mul i64 -32, %37
  %39 = add i64 %29, %38
  %40 = add i64 %39, -640
  %41 = icmp sgt i64 %28, %40
  %42 = select i1 %41, i64 %28, i64 %40
  %43 = mul i64 -20, %polly.indvar
  %polly.loop_guard30 = icmp sle i64 %42, %43
  br i1 %polly.loop_guard30, label %polly.loop_header27, label %polly.loop_exit29

polly.loop_exit29:                                ; preds = %polly.loop_exit38, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %18, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header27:                              ; preds = %polly.loop_header, %polly.loop_exit38
  %polly.indvar31 = phi i64 [ %polly.indvar_next32, %polly.loop_exit38 ], [ %42, %polly.loop_header ]
  %44 = mul i64 -1, %polly.indvar31
  %45 = mul i64 -1, %13
  %46 = add i64 %44, %45
  %47 = add i64 %46, -30
  %48 = add i64 %47, 20
  %49 = sub i64 %48, 1
  %50 = icmp slt i64 %47, 0
  %51 = select i1 %50, i64 %47, i64 %49
  %52 = sdiv i64 %51, 20
  %53 = icmp sgt i64 %52, %polly.indvar
  %54 = select i1 %53, i64 %52, i64 %polly.indvar
  %55 = sub i64 %44, 20
  %56 = add i64 %55, 1
  %57 = icmp slt i64 %44, 0
  %58 = select i1 %57, i64 %56, i64 %44
  %59 = sdiv i64 %58, 20
  %60 = add i64 %polly.indvar, 31
  %61 = icmp slt i64 %59, %60
  %62 = select i1 %61, i64 %59, i64 %60
  %63 = icmp slt i64 %62, %18
  %64 = select i1 %63, i64 %62, i64 %18
  %polly.loop_guard39 = icmp sle i64 %54, %64
  br i1 %polly.loop_guard39, label %polly.loop_header36, label %polly.loop_exit38

polly.loop_exit38:                                ; preds = %polly.loop_exit47, %polly.loop_header27
  %polly.indvar_next32 = add nsw i64 %polly.indvar31, 32
  %polly.adjust_ub33 = sub i64 %43, 32
  %polly.loop_cond34 = icmp sle i64 %polly.indvar31, %polly.adjust_ub33
  br i1 %polly.loop_cond34, label %polly.loop_header27, label %polly.loop_exit29

polly.loop_header36:                              ; preds = %polly.loop_header27, %polly.loop_exit47
  %polly.indvar40 = phi i64 [ %polly.indvar_next41, %polly.loop_exit47 ], [ %54, %polly.loop_header27 ]
  %65 = mul i64 -20, %polly.indvar40
  %66 = add i64 %65, %45
  %67 = add i64 %66, 1
  %68 = icmp sgt i64 %polly.indvar31, %67
  %69 = select i1 %68, i64 %polly.indvar31, i64 %67
  %70 = add i64 %polly.indvar31, 31
  %71 = icmp slt i64 %65, %70
  %72 = select i1 %71, i64 %65, i64 %70
  %polly.loop_guard48 = icmp sle i64 %69, %72
  br i1 %polly.loop_guard48, label %polly.loop_header45, label %polly.loop_exit47

polly.loop_exit47:                                ; preds = %polly.loop_header45, %polly.loop_header36
  %polly.indvar_next41 = add nsw i64 %polly.indvar40, 1
  %polly.adjust_ub42 = sub i64 %64, 1
  %polly.loop_cond43 = icmp sle i64 %polly.indvar40, %polly.adjust_ub42
  br i1 %polly.loop_cond43, label %polly.loop_header36, label %polly.loop_exit38

polly.loop_header45:                              ; preds = %polly.loop_header36, %polly.loop_header45
  %polly.indvar49 = phi i64 [ %polly.indvar_next50, %polly.loop_header45 ], [ %69, %polly.loop_header36 ]
  %73 = mul i64 -1, %polly.indvar49
  %74 = add i64 %65, %73
  %p_scevgep = getelementptr [1200 x double]* %R, i64 %polly.indvar40, i64 %74
  store double 0.000000e+00, double* %p_scevgep
  %p_indvar.next = add i64 %74, 1
  %polly.indvar_next50 = add nsw i64 %polly.indvar49, 1
  %polly.adjust_ub51 = sub i64 %72, 1
  %polly.loop_cond52 = icmp sle i64 %polly.indvar49, %polly.adjust_ub51
  br i1 %polly.loop_cond52, label %polly.loop_header45, label %polly.loop_exit47
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_gramschmidt(i32 %m, i32 %n, [1200 x double]* %A, [1200 x double]* %R, [1200 x double]* %Q) #0 {
.split:
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.preheader2.lr.ph, label %._crit_edge18

.preheader2.lr.ph:                                ; preds = %.split
  %1 = zext i32 %m to i64
  %2 = add i32 %n, -2
  %3 = zext i32 %n to i64
  %4 = zext i32 %2 to i64
  %5 = icmp sgt i32 %m, 0
  br label %.preheader2

.preheader2:                                      ; preds = %.preheader2.lr.ph, %._crit_edge16
  %indvar19 = phi i64 [ 0, %.preheader2.lr.ph ], [ %8, %._crit_edge16 ]
  %6 = mul i64 %indvar19, 1201
  %7 = add i64 %6, 1
  %8 = add i64 %indvar19, 1
  %j.013 = trunc i64 %8 to i32
  %9 = mul i64 %indvar19, -1
  %10 = add i64 %4, %9
  %11 = trunc i64 %10 to i32
  %scevgep51 = getelementptr [1200 x double]* %R, i64 0, i64 %6
  %12 = zext i32 %11 to i64
  %13 = add i64 %12, 1
  br i1 %5, label %.lr.ph, label %15

.lr.ph:                                           ; preds = %.preheader2
  %14 = icmp sge i64 %1, 1
  br i1 %14, label %polly.then, label %polly.stmt.._crit_edge

; <label>:15                                      ; preds = %polly.stmt.._crit_edge, %.preheader2
  %nrm.0.lcssa.reg2mem.0 = phi double [ %nrm.04.reg2mem.0, %polly.stmt.._crit_edge ], [ 0.000000e+00, %.preheader2 ]
  %16 = tail call double @sqrt(double %nrm.0.lcssa.reg2mem.0) #3
  store double %16, double* %scevgep51, align 8, !tbaa !6
  br i1 %5, label %.lr.ph7, label %.preheader1

.preheader1:                                      ; preds = %.lr.ph7, %15
  %17 = icmp slt i32 %j.013, %n
  br i1 %17, label %.lr.ph15, label %._crit_edge16

.lr.ph7:                                          ; preds = %15, %.lr.ph7
  %indvar21 = phi i64 [ %indvar.next22, %.lr.ph7 ], [ 0, %15 ]
  %scevgep25 = getelementptr [1200 x double]* %Q, i64 %indvar21, i64 %indvar19
  %scevgep24 = getelementptr [1200 x double]* %A, i64 %indvar21, i64 %indvar19
  %18 = load double* %scevgep24, align 8, !tbaa !6
  %19 = load double* %scevgep51, align 8, !tbaa !6
  %20 = fdiv double %18, %19
  store double %20, double* %scevgep25, align 8, !tbaa !6
  %indvar.next22 = add i64 %indvar21, 1
  %exitcond23 = icmp ne i64 %indvar.next22, %1
  br i1 %exitcond23, label %.lr.ph7, label %.preheader1

.loopexit:                                        ; preds = %.lr.ph12, %.preheader
  %indvar.next31 = add i64 %indvar30, 1
  %exitcond38 = icmp ne i64 %indvar.next31, %13
  br i1 %exitcond38, label %.lr.ph15, label %._crit_edge16

.lr.ph15:                                         ; preds = %.preheader1, %.loopexit
  %indvar30 = phi i64 [ %indvar.next31, %.loopexit ], [ 0, %.preheader1 ]
  %21 = add i64 %7, %indvar30
  %scevgep41 = getelementptr [1200 x double]* %R, i64 0, i64 %21
  %22 = add i64 %8, %indvar30
  store double 0.000000e+00, double* %scevgep41, align 8, !tbaa !6
  br i1 %5, label %.lr.ph10, label %.preheader

.preheader:                                       ; preds = %.lr.ph10, %.lr.ph15
  br i1 %5, label %.lr.ph12, label %.loopexit

.lr.ph10:                                         ; preds = %.lr.ph15, %.lr.ph10
  %indvar26 = phi i64 [ %indvar.next27, %.lr.ph10 ], [ 0, %.lr.ph15 ]
  %scevgep32 = getelementptr [1200 x double]* %A, i64 %indvar26, i64 %22
  %scevgep29 = getelementptr [1200 x double]* %Q, i64 %indvar26, i64 %indvar19
  %23 = load double* %scevgep29, align 8, !tbaa !6
  %24 = load double* %scevgep32, align 8, !tbaa !6
  %25 = fmul double %23, %24
  %26 = load double* %scevgep41, align 8, !tbaa !6
  %27 = fadd double %26, %25
  store double %27, double* %scevgep41, align 8, !tbaa !6
  %indvar.next27 = add i64 %indvar26, 1
  %exitcond28 = icmp ne i64 %indvar.next27, %1
  br i1 %exitcond28, label %.lr.ph10, label %.preheader

.lr.ph12:                                         ; preds = %.preheader, %.lr.ph12
  %indvar33 = phi i64 [ %indvar.next34, %.lr.ph12 ], [ 0, %.preheader ]
  %scevgep36 = getelementptr [1200 x double]* %A, i64 %indvar33, i64 %22
  %scevgep37 = getelementptr [1200 x double]* %Q, i64 %indvar33, i64 %indvar19
  %28 = load double* %scevgep36, align 8, !tbaa !6
  %29 = load double* %scevgep37, align 8, !tbaa !6
  %30 = load double* %scevgep41, align 8, !tbaa !6
  %31 = fmul double %29, %30
  %32 = fsub double %28, %31
  store double %32, double* %scevgep36, align 8, !tbaa !6
  %indvar.next34 = add i64 %indvar33, 1
  %exitcond35 = icmp ne i64 %indvar.next34, %1
  br i1 %exitcond35, label %.lr.ph12, label %.loopexit

._crit_edge16:                                    ; preds = %.loopexit, %.preheader1
  %exitcond42 = icmp ne i64 %8, %3
  br i1 %exitcond42, label %.preheader2, label %._crit_edge18

._crit_edge18:                                    ; preds = %._crit_edge16, %.split
  ret void

polly.stmt.._crit_edge:                           ; preds = %polly.then, %polly.loop_header, %.lr.ph
  %nrm.04.reg2mem.0 = phi double [ %p_53, %polly.loop_header ], [ 0.000000e+00, %polly.then ], [ 0.000000e+00, %.lr.ph ]
  br label %15

polly.then:                                       ; preds = %.lr.ph
  %33 = add i64 %1, -1
  %polly.loop_guard = icmp sle i64 0, %33
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.stmt.._crit_edge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %nrm.04.reg2mem.1 = phi double [ 0.000000e+00, %polly.then ], [ %p_53, %polly.loop_header ]
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_scevgep = getelementptr [1200 x double]* %A, i64 %polly.indvar, i64 %indvar19
  %_p_scalar_ = load double* %p_scevgep
  %p_ = fmul double %_p_scalar_, %_p_scalar_
  %p_53 = fadd double %nrm.04.reg2mem.1, %p_
  %p_indvar.next = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %33, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.stmt.._crit_edge
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %m, i32 %n, [1200 x double]* %A, [1200 x double]* %R, [1200 x double]* %Q) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %n, 0
  br i1 %5, label %.preheader4.lr.ph, label %22

.preheader4.lr.ph:                                ; preds = %.split
  %6 = zext i32 %n to i64
  %7 = zext i32 %n to i64
  %8 = icmp sgt i32 %n, 0
  br label %.preheader4

.preheader4:                                      ; preds = %.preheader4.lr.ph, %21
  %indvar20 = phi i64 [ 0, %.preheader4.lr.ph ], [ %indvar.next21, %21 ]
  %9 = mul i64 %7, %indvar20
  br i1 %8, label %.lr.ph9, label %21

.lr.ph9:                                          ; preds = %.preheader4
  br label %10

; <label>:10                                      ; preds = %.lr.ph9, %17
  %indvar17 = phi i64 [ 0, %.lr.ph9 ], [ %indvar.next18, %17 ]
  %11 = add i64 %9, %indvar17
  %12 = trunc i64 %11 to i32
  %scevgep22 = getelementptr [1200 x double]* %R, i64 %indvar20, i64 %indvar17
  %13 = srem i32 %12, 20
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %15, label %17

; <label>:15                                      ; preds = %10
  %16 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %fputc3 = tail call i32 @fputc(i32 10, %struct._IO_FILE* %16) #4
  br label %17

; <label>:17                                      ; preds = %15, %10
  %18 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %19 = load double* %scevgep22, align 8, !tbaa !6
  %20 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %18, i8* getelementptr inbounds ([8 x i8]* @.str5, i64 0, i64 0), double %19) #5
  %indvar.next18 = add i64 %indvar17, 1
  %exitcond19 = icmp ne i64 %indvar.next18, %6
  br i1 %exitcond19, label %10, label %._crit_edge10

._crit_edge10:                                    ; preds = %17
  br label %21

; <label>:21                                      ; preds = %._crit_edge10, %.preheader4
  %indvar.next21 = add i64 %indvar20, 1
  %exitcond23 = icmp ne i64 %indvar.next21, %7
  br i1 %exitcond23, label %.preheader4, label %._crit_edge12

._crit_edge12:                                    ; preds = %21
  br label %22

; <label>:22                                      ; preds = %._crit_edge12, %.split
  %23 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %24 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %25 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %26 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %25, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str7, i64 0, i64 0)) #5
  %27 = icmp sgt i32 %m, 0
  br i1 %27, label %.preheader.lr.ph, label %45

.preheader.lr.ph:                                 ; preds = %22
  %28 = zext i32 %n to i64
  %29 = zext i32 %m to i64
  %30 = zext i32 %n to i64
  %31 = icmp sgt i32 %n, 0
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %44
  %indvar13 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next14, %44 ]
  %32 = mul i64 %30, %indvar13
  br i1 %31, label %.lr.ph, label %44

.lr.ph:                                           ; preds = %.preheader
  br label %33

; <label>:33                                      ; preds = %.lr.ph, %40
  %indvar = phi i64 [ 0, %.lr.ph ], [ %indvar.next, %40 ]
  %34 = add i64 %32, %indvar
  %35 = trunc i64 %34 to i32
  %scevgep = getelementptr [1200 x double]* %Q, i64 %indvar13, i64 %indvar
  %36 = srem i32 %35, 20
  %37 = icmp eq i32 %36, 0
  br i1 %37, label %38, label %40

; <label>:38                                      ; preds = %33
  %39 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %39) #4
  br label %40

; <label>:40                                      ; preds = %38, %33
  %41 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %42 = load double* %scevgep, align 8, !tbaa !6
  %43 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %41, i8* getelementptr inbounds ([8 x i8]* @.str5, i64 0, i64 0), double %42) #5
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %28
  br i1 %exitcond, label %33, label %._crit_edge

._crit_edge:                                      ; preds = %40
  br label %44

; <label>:44                                      ; preds = %._crit_edge, %.preheader
  %indvar.next14 = add i64 %indvar13, 1
  %exitcond15 = icmp ne i64 %indvar.next14, %29
  br i1 %exitcond15, label %.preheader, label %._crit_edge7

._crit_edge7:                                     ; preds = %44
  br label %45

; <label>:45                                      ; preds = %._crit_edge7, %22
  %46 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %47 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %46, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str7, i64 0, i64 0)) #5
  %48 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %49 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str8, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %48) #4
  ret void
}

; Function Attrs: nounwind
declare void @free(i8*) #2

declare i32 @fprintf(%struct._IO_FILE*, i8*, ...) #1

; Function Attrs: nounwind
declare double @sqrt(double) #2

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
