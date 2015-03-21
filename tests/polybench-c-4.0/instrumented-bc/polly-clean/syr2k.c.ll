; ModuleID = './linear-algebra/blas/syr2k/syr2k.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [2 x i8] c"C\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %alpha = alloca double, align 8
  %beta = alloca double, align 8
  %0 = tail call i8* @polybench_alloc_data(i64 1440000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 1200000, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 1200000, i32 8) #3
  %3 = bitcast i8* %0 to [1200 x double]*
  %4 = bitcast i8* %1 to [1000 x double]*
  %5 = bitcast i8* %2 to [1000 x double]*
  call void @init_array(i32 1200, i32 1000, double* %alpha, double* %beta, [1200 x double]* %3, [1000 x double]* %4, [1000 x double]* %5)
  call void (...)* @polybench_timer_start() #3
  %6 = load double* %alpha, align 8, !tbaa !1
  %7 = load double* %beta, align 8, !tbaa !1
  call void @kernel_syr2k(i32 1200, i32 1000, double %6, double %7, [1200 x double]* %3, [1000 x double]* %4, [1000 x double]* %5)
  call void (...)* @polybench_timer_stop() #3
  call void (...)* @polybench_timer_print() #3
  %8 = icmp sgt i32 %argc, 42
  br i1 %8, label %9, label %13

; <label>:9                                       ; preds = %.split
  %10 = load i8** %argv, align 8, !tbaa !5
  %11 = load i8* %10, align 1, !tbaa !7
  %phitmp = icmp eq i8 %11, 0
  br i1 %phitmp, label %12, label %13

; <label>:12                                      ; preds = %9
  call void @print_array(i32 1200, [1200 x double]* %3)
  br label %13

; <label>:13                                      ; preds = %9, %12, %.split
  call void @free(i8* %0) #3
  call void @free(i8* %1) #3
  call void @free(i8* %2) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %n, i32 %m, double* %alpha, double* %beta, [1200 x double]* %C, [1000 x double]* %A, [1000 x double]* %B) #0 {
.split:
  store double 1.500000e+00, double* %alpha, align 8, !tbaa !1
  store double 1.200000e+00, double* %beta, align 8, !tbaa !1
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.preheader2.lr.ph, label %polly.start

.preheader2.lr.ph:                                ; preds = %.split
  %1 = zext i32 %m to i64
  %2 = zext i32 %n to i64
  %3 = icmp sgt i32 %m, 0
  %4 = sitofp i32 %n to double
  %5 = sitofp i32 %m to double
  br label %.preheader2

.preheader2:                                      ; preds = %.preheader2.lr.ph, %._crit_edge9
  %6 = phi i64 [ 0, %.preheader2.lr.ph ], [ %indvar.next20, %._crit_edge9 ]
  br i1 %3, label %.lr.ph8, label %._crit_edge9

.lr.ph8:                                          ; preds = %.preheader2, %.lr.ph8
  %indvar16 = phi i64 [ %indvar.next17, %.lr.ph8 ], [ 0, %.preheader2 ]
  %scevgep22 = getelementptr [1000 x double]* %B, i64 %6, i64 %indvar16
  %scevgep21 = getelementptr [1000 x double]* %A, i64 %6, i64 %indvar16
  %7 = mul i64 %6, %indvar16
  %8 = trunc i64 %7 to i32
  %9 = srem i32 %8, %n
  %10 = sitofp i32 %9 to double
  %11 = fdiv double %10, %4
  store double %11, double* %scevgep21, align 8, !tbaa !1
  %12 = srem i32 %8, %m
  %13 = sitofp i32 %12 to double
  %14 = fdiv double %13, %5
  store double %14, double* %scevgep22, align 8, !tbaa !1
  %indvar.next17 = add i64 %indvar16, 1
  %exitcond18 = icmp ne i64 %indvar.next17, %1
  br i1 %exitcond18, label %.lr.ph8, label %._crit_edge9

._crit_edge9:                                     ; preds = %.lr.ph8, %.preheader2
  %indvar.next20 = add i64 %6, 1
  %exitcond23 = icmp ne i64 %indvar.next20, %2
  br i1 %exitcond23, label %.preheader2, label %polly.start

polly.start:                                      ; preds = %._crit_edge9, %.split
  %15 = zext i32 %n to i64
  %16 = sext i32 %n to i64
  %17 = icmp sge i64 %16, 1
  %18 = icmp sge i64 %15, 1
  %19 = and i1 %17, %18
  br i1 %19, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit31, %polly.start
  ret void

polly.then:                                       ; preds = %polly.start
  %20 = add i64 %15, -1
  %polly.loop_guard = icmp sle i64 0, %20
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit31
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit31 ], [ 0, %polly.then ]
  %21 = mul i64 -11, %15
  %22 = add i64 %21, 5
  %23 = sub i64 %22, 32
  %24 = add i64 %23, 1
  %25 = icmp slt i64 %22, 0
  %26 = select i1 %25, i64 %24, i64 %22
  %27 = sdiv i64 %26, 32
  %28 = mul i64 -32, %27
  %29 = mul i64 -32, %15
  %30 = add i64 %28, %29
  %31 = mul i64 -32, %polly.indvar
  %32 = mul i64 -3, %polly.indvar
  %33 = add i64 %32, %15
  %34 = add i64 %33, 5
  %35 = sub i64 %34, 32
  %36 = add i64 %35, 1
  %37 = icmp slt i64 %34, 0
  %38 = select i1 %37, i64 %36, i64 %34
  %39 = sdiv i64 %38, 32
  %40 = mul i64 -32, %39
  %41 = add i64 %31, %40
  %42 = add i64 %41, -640
  %43 = icmp sgt i64 %30, %42
  %44 = select i1 %43, i64 %30, i64 %42
  %45 = mul i64 -20, %polly.indvar
  %polly.loop_guard32 = icmp sle i64 %44, %45
  br i1 %polly.loop_guard32, label %polly.loop_header29, label %polly.loop_exit31

polly.loop_exit31:                                ; preds = %polly.loop_exit40, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %20, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header29:                              ; preds = %polly.loop_header, %polly.loop_exit40
  %polly.indvar33 = phi i64 [ %polly.indvar_next34, %polly.loop_exit40 ], [ %44, %polly.loop_header ]
  %46 = mul i64 -1, %polly.indvar33
  %47 = mul i64 -1, %15
  %48 = add i64 %46, %47
  %49 = add i64 %48, -30
  %50 = add i64 %49, 20
  %51 = sub i64 %50, 1
  %52 = icmp slt i64 %49, 0
  %53 = select i1 %52, i64 %49, i64 %51
  %54 = sdiv i64 %53, 20
  %55 = icmp sgt i64 %54, %polly.indvar
  %56 = select i1 %55, i64 %54, i64 %polly.indvar
  %57 = sub i64 %46, 20
  %58 = add i64 %57, 1
  %59 = icmp slt i64 %46, 0
  %60 = select i1 %59, i64 %58, i64 %46
  %61 = sdiv i64 %60, 20
  %62 = add i64 %polly.indvar, 31
  %63 = icmp slt i64 %61, %62
  %64 = select i1 %63, i64 %61, i64 %62
  %65 = icmp slt i64 %64, %20
  %66 = select i1 %65, i64 %64, i64 %20
  %polly.loop_guard41 = icmp sle i64 %56, %66
  br i1 %polly.loop_guard41, label %polly.loop_header38, label %polly.loop_exit40

polly.loop_exit40:                                ; preds = %polly.loop_exit49, %polly.loop_header29
  %polly.indvar_next34 = add nsw i64 %polly.indvar33, 32
  %polly.adjust_ub35 = sub i64 %45, 32
  %polly.loop_cond36 = icmp sle i64 %polly.indvar33, %polly.adjust_ub35
  br i1 %polly.loop_cond36, label %polly.loop_header29, label %polly.loop_exit31

polly.loop_header38:                              ; preds = %polly.loop_header29, %polly.loop_exit49
  %polly.indvar42 = phi i64 [ %polly.indvar_next43, %polly.loop_exit49 ], [ %56, %polly.loop_header29 ]
  %67 = mul i64 -20, %polly.indvar42
  %68 = add i64 %67, %47
  %69 = add i64 %68, 1
  %70 = icmp sgt i64 %polly.indvar33, %69
  %71 = select i1 %70, i64 %polly.indvar33, i64 %69
  %72 = add i64 %polly.indvar33, 31
  %73 = icmp slt i64 %67, %72
  %74 = select i1 %73, i64 %67, i64 %72
  %polly.loop_guard50 = icmp sle i64 %71, %74
  br i1 %polly.loop_guard50, label %polly.loop_header47, label %polly.loop_exit49

polly.loop_exit49:                                ; preds = %polly.loop_header47, %polly.loop_header38
  %polly.indvar_next43 = add nsw i64 %polly.indvar42, 1
  %polly.adjust_ub44 = sub i64 %66, 1
  %polly.loop_cond45 = icmp sle i64 %polly.indvar42, %polly.adjust_ub44
  br i1 %polly.loop_cond45, label %polly.loop_header38, label %polly.loop_exit40

polly.loop_header47:                              ; preds = %polly.loop_header38, %polly.loop_header47
  %polly.indvar51 = phi i64 [ %polly.indvar_next52, %polly.loop_header47 ], [ %71, %polly.loop_header38 ]
  %75 = mul i64 -1, %polly.indvar51
  %76 = add i64 %67, %75
  %p_.moved.to. = sitofp i32 %m to double
  %p_scevgep = getelementptr [1200 x double]* %C, i64 %polly.indvar42, i64 %76
  %p_ = mul i64 %polly.indvar42, %76
  %p_55 = trunc i64 %p_ to i32
  %p_56 = srem i32 %p_55, %n
  %p_57 = sitofp i32 %p_56 to double
  %p_58 = fdiv double %p_57, %p_.moved.to.
  store double %p_58, double* %p_scevgep
  %p_indvar.next = add i64 %76, 1
  %polly.indvar_next52 = add nsw i64 %polly.indvar51, 1
  %polly.adjust_ub53 = sub i64 %74, 1
  %polly.loop_cond54 = icmp sle i64 %polly.indvar51, %polly.adjust_ub53
  br i1 %polly.loop_cond54, label %polly.loop_header47, label %polly.loop_exit49
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_syr2k(i32 %n, i32 %m, double %alpha, double %beta, [1200 x double]* %C, [1000 x double]* %A, [1000 x double]* %B) #0 {
polly.split_new_and_old:
  %0 = zext i32 %n to i64
  %1 = sext i32 %n to i64
  %2 = icmp sge i64 %1, 1
  %3 = icmp sge i64 %0, 1
  %4 = and i1 %2, %3
  br i1 %4, label %polly.then, label %polly.merge

.preheader1.lr.ph:                                ; preds = %polly.merge
  %5 = zext i32 %m to i64
  %6 = icmp sgt i32 %m, 0
  br label %.preheader1

.preheader1:                                      ; preds = %.preheader1.lr.ph, %._crit_edge6
  %indvar16 = phi i64 [ 0, %.preheader1.lr.ph ], [ %indvar.next17, %._crit_edge6 ]
  br i1 %6, label %.preheader, label %._crit_edge6

.preheader:                                       ; preds = %.preheader1, %._crit_edge
  %indvar13 = phi i64 [ %indvar.next14, %._crit_edge ], [ 0, %.preheader1 ]
  %scevgep23 = getelementptr [1000 x double]* %A, i64 %indvar16, i64 %indvar13
  %scevgep22 = getelementptr [1000 x double]* %B, i64 %indvar16, i64 %indvar13
  br i1 %18, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %.preheader, %.lr.ph
  %indvar = phi i64 [ %indvar.next, %.lr.ph ], [ 0, %.preheader ]
  %scevgep18 = getelementptr [1200 x double]* %C, i64 %indvar16, i64 %indvar
  %scevgep15 = getelementptr [1000 x double]* %B, i64 %indvar, i64 %indvar13
  %scevgep = getelementptr [1000 x double]* %A, i64 %indvar, i64 %indvar13
  %7 = load double* %scevgep, align 8, !tbaa !1
  %8 = fmul double %7, %alpha
  %9 = load double* %scevgep22, align 8, !tbaa !1
  %10 = fmul double %8, %9
  %11 = load double* %scevgep15, align 8, !tbaa !1
  %12 = fmul double %11, %alpha
  %13 = load double* %scevgep23, align 8, !tbaa !1
  %14 = fmul double %12, %13
  %15 = fadd double %10, %14
  %16 = load double* %scevgep18, align 8, !tbaa !1
  %17 = fadd double %16, %15
  store double %17, double* %scevgep18, align 8, !tbaa !1
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %0
  br i1 %exitcond, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %.preheader
  %indvar.next14 = add i64 %indvar13, 1
  %exitcond19 = icmp ne i64 %indvar.next14, %5
  br i1 %exitcond19, label %.preheader, label %._crit_edge6

._crit_edge6:                                     ; preds = %._crit_edge, %.preheader1
  %indvar.next17 = add i64 %indvar16, 1
  %exitcond24 = icmp ne i64 %indvar.next17, %0
  br i1 %exitcond24, label %.preheader1, label %._crit_edge8

._crit_edge8:                                     ; preds = %._crit_edge6, %polly.merge
  ret void

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit40, %polly.split_new_and_old
  %18 = icmp sgt i32 %n, 0
  br i1 %18, label %.preheader1.lr.ph, label %._crit_edge8

polly.then:                                       ; preds = %polly.split_new_and_old
  %19 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %19
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit40
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit40 ], [ 0, %polly.then ]
  %20 = mul i64 -11, %0
  %21 = add i64 %20, 5
  %22 = sub i64 %21, 32
  %23 = add i64 %22, 1
  %24 = icmp slt i64 %21, 0
  %25 = select i1 %24, i64 %23, i64 %21
  %26 = sdiv i64 %25, 32
  %27 = mul i64 -32, %26
  %28 = mul i64 -32, %0
  %29 = add i64 %27, %28
  %30 = mul i64 -32, %polly.indvar
  %31 = mul i64 -3, %polly.indvar
  %32 = add i64 %31, %0
  %33 = add i64 %32, 5
  %34 = sub i64 %33, 32
  %35 = add i64 %34, 1
  %36 = icmp slt i64 %33, 0
  %37 = select i1 %36, i64 %35, i64 %33
  %38 = sdiv i64 %37, 32
  %39 = mul i64 -32, %38
  %40 = add i64 %30, %39
  %41 = add i64 %40, -640
  %42 = icmp sgt i64 %29, %41
  %43 = select i1 %42, i64 %29, i64 %41
  %44 = mul i64 -20, %polly.indvar
  %polly.loop_guard41 = icmp sle i64 %43, %44
  br i1 %polly.loop_guard41, label %polly.loop_header38, label %polly.loop_exit40

polly.loop_exit40:                                ; preds = %polly.loop_exit49, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %19, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header38:                              ; preds = %polly.loop_header, %polly.loop_exit49
  %polly.indvar42 = phi i64 [ %polly.indvar_next43, %polly.loop_exit49 ], [ %43, %polly.loop_header ]
  %45 = mul i64 -1, %polly.indvar42
  %46 = mul i64 -1, %0
  %47 = add i64 %45, %46
  %48 = add i64 %47, -30
  %49 = add i64 %48, 20
  %50 = sub i64 %49, 1
  %51 = icmp slt i64 %48, 0
  %52 = select i1 %51, i64 %48, i64 %50
  %53 = sdiv i64 %52, 20
  %54 = icmp sgt i64 %53, %polly.indvar
  %55 = select i1 %54, i64 %53, i64 %polly.indvar
  %56 = sub i64 %45, 20
  %57 = add i64 %56, 1
  %58 = icmp slt i64 %45, 0
  %59 = select i1 %58, i64 %57, i64 %45
  %60 = sdiv i64 %59, 20
  %61 = add i64 %polly.indvar, 31
  %62 = icmp slt i64 %60, %61
  %63 = select i1 %62, i64 %60, i64 %61
  %64 = icmp slt i64 %63, %19
  %65 = select i1 %64, i64 %63, i64 %19
  %polly.loop_guard50 = icmp sle i64 %55, %65
  br i1 %polly.loop_guard50, label %polly.loop_header47, label %polly.loop_exit49

polly.loop_exit49:                                ; preds = %polly.loop_exit58, %polly.loop_header38
  %polly.indvar_next43 = add nsw i64 %polly.indvar42, 32
  %polly.adjust_ub44 = sub i64 %44, 32
  %polly.loop_cond45 = icmp sle i64 %polly.indvar42, %polly.adjust_ub44
  br i1 %polly.loop_cond45, label %polly.loop_header38, label %polly.loop_exit40

polly.loop_header47:                              ; preds = %polly.loop_header38, %polly.loop_exit58
  %polly.indvar51 = phi i64 [ %polly.indvar_next52, %polly.loop_exit58 ], [ %55, %polly.loop_header38 ]
  %66 = mul i64 -20, %polly.indvar51
  %67 = add i64 %66, %46
  %68 = add i64 %67, 1
  %69 = icmp sgt i64 %polly.indvar42, %68
  %70 = select i1 %69, i64 %polly.indvar42, i64 %68
  %71 = add i64 %polly.indvar42, 31
  %72 = icmp slt i64 %66, %71
  %73 = select i1 %72, i64 %66, i64 %71
  %polly.loop_guard59 = icmp sle i64 %70, %73
  br i1 %polly.loop_guard59, label %polly.loop_header56, label %polly.loop_exit58

polly.loop_exit58:                                ; preds = %polly.loop_header56, %polly.loop_header47
  %polly.indvar_next52 = add nsw i64 %polly.indvar51, 1
  %polly.adjust_ub53 = sub i64 %65, 1
  %polly.loop_cond54 = icmp sle i64 %polly.indvar51, %polly.adjust_ub53
  br i1 %polly.loop_cond54, label %polly.loop_header47, label %polly.loop_exit49

polly.loop_header56:                              ; preds = %polly.loop_header47, %polly.loop_header56
  %polly.indvar60 = phi i64 [ %polly.indvar_next61, %polly.loop_header56 ], [ %70, %polly.loop_header47 ]
  %74 = mul i64 -1, %polly.indvar60
  %75 = add i64 %66, %74
  %p_scevgep33 = getelementptr [1200 x double]* %C, i64 %polly.indvar51, i64 %75
  %_p_scalar_ = load double* %p_scevgep33
  %p_ = fmul double %_p_scalar_, %beta
  store double %p_, double* %p_scevgep33
  %p_indvar.next29 = add i64 %75, 1
  %polly.indvar_next61 = add nsw i64 %polly.indvar60, 1
  %polly.adjust_ub62 = sub i64 %73, 1
  %polly.loop_cond63 = icmp sle i64 %polly.indvar60, %polly.adjust_ub62
  br i1 %polly.loop_cond63, label %polly.loop_header56, label %polly.loop_exit58
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, [1200 x double]* %C) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
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
  %scevgep = getelementptr [1200 x double]* %C, i64 %indvar4, i64 %indvar
  %13 = srem i32 %12, 20
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %15, label %17

; <label>:15                                      ; preds = %10
  %16 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %16) #4
  br label %17

; <label>:17                                      ; preds = %15, %10
  %18 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %19 = load double* %scevgep, align 8, !tbaa !1
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
  %23 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %24 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %25 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
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
!2 = metadata !{metadata !"double", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{metadata !6, metadata !6, i64 0}
!6 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!7 = metadata !{metadata !3, metadata !3, i64 0}
