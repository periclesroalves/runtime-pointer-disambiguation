; ModuleID = './linear-algebra/blas/symm/symm.c'
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
  %0 = tail call i8* @polybench_alloc_data(i64 1200000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 1000000, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 1200000, i32 8) #3
  %3 = bitcast i8* %0 to [1200 x double]*
  %4 = bitcast i8* %1 to [1000 x double]*
  %5 = bitcast i8* %2 to [1200 x double]*
  call void @init_array(i32 1000, i32 1200, double* %alpha, double* %beta, [1200 x double]* %3, [1000 x double]* %4, [1200 x double]* %5)
  call void (...)* @polybench_timer_start() #3
  %6 = load double* %alpha, align 8, !tbaa !1
  %7 = load double* %beta, align 8, !tbaa !1
  call void @kernel_symm(i32 1000, i32 1200, double %6, double %7, [1200 x double]* %3, [1000 x double]* %4, [1200 x double]* %5)
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
  call void @print_array(i32 1000, i32 1200, [1200 x double]* %3)
  br label %13

; <label>:13                                      ; preds = %9, %12, %.split
  call void @free(i8* %0) #3
  call void @free(i8* %1) #3
  call void @free(i8* %2) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %m, i32 %n, double* %alpha, double* %beta, [1200 x double]* noalias %C, [1000 x double]* noalias %A, [1200 x double]* noalias %B) #0 {
.split:
  store double 1.500000e+00, double* %alpha, align 8, !tbaa !1
  store double 1.200000e+00, double* %beta, align 8, !tbaa !1
  %0 = icmp sgt i32 %m, 0
  br i1 %0, label %.preheader3.lr.ph, label %.preheader2

.preheader3.lr.ph:                                ; preds = %.split
  %1 = zext i32 %n to i64
  %2 = sitofp i32 %m to double
  %3 = zext i32 %m to i64
  %4 = sext i32 %n to i64
  %5 = icmp sge i64 %4, 1
  %6 = icmp sge i64 %3, 1
  %7 = and i1 %5, %6
  %8 = icmp sge i64 %1, 1
  %9 = and i1 %7, %8
  br i1 %9, label %polly.then66, label %.preheader2

.preheader2:                                      ; preds = %polly.then66, %polly.loop_exit79, %.preheader3.lr.ph, %.split
  br i1 %0, label %.preheader1.lr.ph, label %._crit_edge9

.preheader1.lr.ph:                                ; preds = %.preheader2
  %10 = add i32 %m, -2
  %11 = zext i32 %m to i64
  %12 = zext i32 %10 to i64
  %13 = sitofp i32 %m to double
  br label %.preheader1

.preheader1:                                      ; preds = %.preheader1.lr.ph, %polly.merge
  %indvar15 = phi i64 [ 0, %.preheader1.lr.ph ], [ %22, %polly.merge ]
  %14 = mul i64 %indvar15, 8000
  %15 = mul i64 %indvar15, -1
  %16 = add i64 %12, %15
  %17 = trunc i64 %16 to i32
  %18 = zext i32 %17 to i64
  %19 = mul i64 %indvar15, 8008
  %i.18 = trunc i64 %indvar15 to i32
  %20 = mul i64 %indvar15, 1001
  %21 = add i64 %20, 1
  %22 = add i64 %indvar15, 1
  %j.25 = trunc i64 %22 to i32
  %23 = add i64 %18, 1
  %24 = icmp slt i32 %i.18, 0
  br i1 %24, label %.preheader, label %polly.cond40

.preheader:                                       ; preds = %polly.then45, %polly.loop_header47, %polly.cond40, %.preheader1
  %25 = icmp slt i32 %j.25, %m
  br i1 %25, label %polly.cond, label %polly.merge

polly.merge:                                      ; preds = %polly.then36, %polly.loop_header, %polly.cond, %.preheader
  %exitcond21 = icmp ne i64 %22, %11
  br i1 %exitcond21, label %.preheader1, label %._crit_edge9

._crit_edge9:                                     ; preds = %polly.merge, %.preheader2
  ret void

polly.cond:                                       ; preds = %.preheader
  %26 = srem i64 %19, 8
  %27 = icmp eq i64 %26, 0
  br i1 %27, label %polly.then36, label %polly.merge

polly.then36:                                     ; preds = %polly.cond
  br i1 true, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then36, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then36 ]
  %p_ = add i64 %21, %polly.indvar
  %p_scevgep20 = getelementptr [1000 x double]* %A, i64 0, i64 %p_
  store double -9.990000e+02, double* %p_scevgep20
  %p_indvar.next18 = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %18, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.cond40:                                     ; preds = %.preheader1
  %28 = srem i64 %14, 8
  %29 = icmp eq i64 %28, 0
  %30 = icmp sge i64 %indvar15, 0
  %or.cond117 = and i1 %29, %30
  br i1 %or.cond117, label %polly.then45, label %.preheader

polly.then45:                                     ; preds = %polly.cond40
  br i1 %30, label %polly.loop_header47, label %.preheader

polly.loop_header47:                              ; preds = %polly.then45, %polly.loop_header47
  %polly.indvar51 = phi i64 [ %polly.indvar_next52, %polly.loop_header47 ], [ 0, %polly.then45 ]
  %p_56 = add i64 %indvar15, %polly.indvar51
  %p_57 = trunc i64 %p_56 to i32
  %p_scevgep = getelementptr [1000 x double]* %A, i64 %indvar15, i64 %polly.indvar51
  %p_58 = srem i32 %p_57, 100
  %p_59 = sitofp i32 %p_58 to double
  %p_60 = fdiv double %p_59, %13
  store double %p_60, double* %p_scevgep
  %p_indvar.next = add i64 %polly.indvar51, 1
  %polly.indvar_next52 = add nsw i64 %polly.indvar51, 1
  %polly.adjust_ub53 = sub i64 %indvar15, 1
  %polly.loop_cond54 = icmp sle i64 %polly.indvar51, %polly.adjust_ub53
  br i1 %polly.loop_cond54, label %polly.loop_header47, label %.preheader

polly.then66:                                     ; preds = %.preheader3.lr.ph
  %31 = add i64 %3, -1
  %polly.loop_guard71 = icmp sle i64 0, %31
  br i1 %polly.loop_guard71, label %polly.loop_header68, label %.preheader2

polly.loop_header68:                              ; preds = %polly.then66, %polly.loop_exit79
  %polly.indvar72 = phi i64 [ %polly.indvar_next73, %polly.loop_exit79 ], [ 0, %polly.then66 ]
  %32 = mul i64 -3, %3
  %33 = add i64 %32, %1
  %34 = add i64 %33, 5
  %35 = sub i64 %34, 32
  %36 = add i64 %35, 1
  %37 = icmp slt i64 %34, 0
  %38 = select i1 %37, i64 %36, i64 %34
  %39 = sdiv i64 %38, 32
  %40 = mul i64 -32, %39
  %41 = mul i64 -32, %3
  %42 = add i64 %40, %41
  %43 = mul i64 -32, %polly.indvar72
  %44 = mul i64 -3, %polly.indvar72
  %45 = add i64 %44, %1
  %46 = add i64 %45, 5
  %47 = sub i64 %46, 32
  %48 = add i64 %47, 1
  %49 = icmp slt i64 %46, 0
  %50 = select i1 %49, i64 %48, i64 %46
  %51 = sdiv i64 %50, 32
  %52 = mul i64 -32, %51
  %53 = add i64 %43, %52
  %54 = add i64 %53, -640
  %55 = icmp sgt i64 %42, %54
  %56 = select i1 %55, i64 %42, i64 %54
  %57 = mul i64 -20, %polly.indvar72
  %polly.loop_guard80 = icmp sle i64 %56, %57
  br i1 %polly.loop_guard80, label %polly.loop_header77, label %polly.loop_exit79

polly.loop_exit79:                                ; preds = %polly.loop_exit88, %polly.loop_header68
  %polly.indvar_next73 = add nsw i64 %polly.indvar72, 32
  %polly.adjust_ub74 = sub i64 %31, 32
  %polly.loop_cond75 = icmp sle i64 %polly.indvar72, %polly.adjust_ub74
  br i1 %polly.loop_cond75, label %polly.loop_header68, label %.preheader2

polly.loop_header77:                              ; preds = %polly.loop_header68, %polly.loop_exit88
  %polly.indvar81 = phi i64 [ %polly.indvar_next82, %polly.loop_exit88 ], [ %56, %polly.loop_header68 ]
  %58 = mul i64 -1, %polly.indvar81
  %59 = mul i64 -1, %1
  %60 = add i64 %58, %59
  %61 = add i64 %60, -30
  %62 = add i64 %61, 20
  %63 = sub i64 %62, 1
  %64 = icmp slt i64 %61, 0
  %65 = select i1 %64, i64 %61, i64 %63
  %66 = sdiv i64 %65, 20
  %67 = icmp sgt i64 %66, %polly.indvar72
  %68 = select i1 %67, i64 %66, i64 %polly.indvar72
  %69 = sub i64 %58, 20
  %70 = add i64 %69, 1
  %71 = icmp slt i64 %58, 0
  %72 = select i1 %71, i64 %70, i64 %58
  %73 = sdiv i64 %72, 20
  %74 = add i64 %polly.indvar72, 31
  %75 = icmp slt i64 %73, %74
  %76 = select i1 %75, i64 %73, i64 %74
  %77 = icmp slt i64 %76, %31
  %78 = select i1 %77, i64 %76, i64 %31
  %polly.loop_guard89 = icmp sle i64 %68, %78
  br i1 %polly.loop_guard89, label %polly.loop_header86, label %polly.loop_exit88

polly.loop_exit88:                                ; preds = %polly.loop_exit97, %polly.loop_header77
  %polly.indvar_next82 = add nsw i64 %polly.indvar81, 32
  %polly.adjust_ub83 = sub i64 %57, 32
  %polly.loop_cond84 = icmp sle i64 %polly.indvar81, %polly.adjust_ub83
  br i1 %polly.loop_cond84, label %polly.loop_header77, label %polly.loop_exit79

polly.loop_header86:                              ; preds = %polly.loop_header77, %polly.loop_exit97
  %polly.indvar90 = phi i64 [ %polly.indvar_next91, %polly.loop_exit97 ], [ %68, %polly.loop_header77 ]
  %79 = mul i64 -20, %polly.indvar90
  %80 = add i64 %79, %59
  %81 = add i64 %80, 1
  %82 = icmp sgt i64 %polly.indvar81, %81
  %83 = select i1 %82, i64 %polly.indvar81, i64 %81
  %84 = add i64 %polly.indvar81, 31
  %85 = icmp slt i64 %79, %84
  %86 = select i1 %85, i64 %79, i64 %84
  %polly.loop_guard98 = icmp sle i64 %83, %86
  br i1 %polly.loop_guard98, label %polly.loop_header95, label %polly.loop_exit97

polly.loop_exit97:                                ; preds = %polly.loop_header95, %polly.loop_header86
  %polly.indvar_next91 = add nsw i64 %polly.indvar90, 1
  %polly.adjust_ub92 = sub i64 %78, 1
  %polly.loop_cond93 = icmp sle i64 %polly.indvar90, %polly.adjust_ub92
  br i1 %polly.loop_cond93, label %polly.loop_header86, label %polly.loop_exit88

polly.loop_header95:                              ; preds = %polly.loop_header86, %polly.loop_header95
  %polly.indvar99 = phi i64 [ %polly.indvar_next100, %polly.loop_header95 ], [ %83, %polly.loop_header86 ]
  %87 = mul i64 -1, %polly.indvar99
  %88 = add i64 %79, %87
  %p_.moved.to. = add i64 %1, %polly.indvar90
  %p_104 = add i64 %polly.indvar90, %88
  %p_105 = trunc i64 %p_104 to i32
  %p_scevgep30 = getelementptr [1200 x double]* %B, i64 %polly.indvar90, i64 %88
  %p_scevgep29 = getelementptr [1200 x double]* %C, i64 %polly.indvar90, i64 %88
  %p_106 = mul i64 %88, -1
  %p_107 = add i64 %p_.moved.to., %p_106
  %p_108 = trunc i64 %p_107 to i32
  %p_109 = srem i32 %p_105, 100
  %p_110 = sitofp i32 %p_109 to double
  %p_111 = fdiv double %p_110, %2
  store double %p_111, double* %p_scevgep29
  %p_112 = srem i32 %p_108, 100
  %p_113 = sitofp i32 %p_112 to double
  %p_114 = fdiv double %p_113, %2
  store double %p_114, double* %p_scevgep30
  %p_indvar.next25 = add i64 %88, 1
  %polly.indvar_next100 = add nsw i64 %polly.indvar99, 1
  %polly.adjust_ub101 = sub i64 %86, 1
  %polly.loop_cond102 = icmp sle i64 %polly.indvar99, %polly.adjust_ub101
  br i1 %polly.loop_cond102, label %polly.loop_header95, label %polly.loop_exit97
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_symm(i32 %m, i32 %n, double %alpha, double %beta, [1200 x double]* noalias %C, [1000 x double]* noalias %A, [1200 x double]* noalias %B) #0 {
polly.split_new_and_old:
  %0 = zext i32 %m to i64
  %1 = zext i32 %n to i64
  %2 = sext i32 %m to i64
  %3 = icmp sge i64 %2, 1
  %4 = sext i32 %n to i64
  %5 = icmp sge i64 %4, 1
  %6 = and i1 %3, %5
  %7 = icmp sge i64 %0, 1
  %8 = and i1 %6, %7
  br i1 %8, label %polly.cond32, label %polly.merge

polly.merge:                                      ; preds = %polly.then112, %polly.loop_header114, %polly.cond110, %polly.split_new_and_old
  ret void

polly.cond32:                                     ; preds = %polly.split_new_and_old
  %9 = icmp sge i64 %1, 1
  br i1 %9, label %polly.stmt..preheader.lr.ph, label %polly.cond42

polly.cond42:                                     ; preds = %polly.stmt..preheader.lr.ph, %polly.loop_header, %polly.cond32
  %10 = icmp sle i64 %1, 0
  br i1 %10, label %polly.stmt..preheader.lr.ph45, label %polly.cond49

polly.cond49:                                     ; preds = %polly.cond42, %polly.stmt..preheader.lr.ph45
  br i1 %9, label %polly.then51, label %polly.cond110

polly.cond110:                                    ; preds = %polly.then51, %polly.loop_exit68, %polly.cond49
  br i1 %10, label %polly.then112, label %polly.merge

polly.stmt..preheader.lr.ph:                      ; preds = %polly.cond32
  %p_scevgep27.moved.to..preheader.lr.ph = getelementptr [1000 x double]* %A, i64 0, i64 0
  %_p_scalar_ = load double* %p_scevgep27.moved.to..preheader.lr.ph
  %11 = add i64 %1, -1
  %polly.loop_guard = icmp sle i64 0, %11
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond42

polly.loop_header:                                ; preds = %polly.stmt..preheader.lr.ph, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.stmt..preheader.lr.ph ]
  %p_scevgep21.moved.to. = getelementptr [1200 x double]* %C, i64 0, i64 %polly.indvar
  %p_scevgep22.moved.to. = getelementptr [1200 x double]* %B, i64 0, i64 %polly.indvar
  %_p_scalar_35 = load double* %p_scevgep21.moved.to.
  %p_ = fmul double %_p_scalar_35, %beta
  %_p_scalar_36 = load double* %p_scevgep22.moved.to.
  %p_37 = fmul double %_p_scalar_36, %alpha
  %p_38 = fmul double %p_37, %_p_scalar_
  %p_39 = fadd double %p_, %p_38
  %p_40 = fmul double 0.000000e+00, %alpha
  %p_41 = fadd double %p_40, %p_39
  store double %p_41, double* %p_scevgep21.moved.to.
  %p_indvar.next15 = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %11, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond42

polly.stmt..preheader.lr.ph45:                    ; preds = %polly.cond42
  %p_scevgep27.moved.to..preheader.lr.ph47 = getelementptr [1000 x double]* %A, i64 0, i64 0
  br label %polly.cond49

polly.then51:                                     ; preds = %polly.cond49
  %12 = add i64 %0, -1
  %polly.loop_guard56 = icmp sle i64 1, %12
  br i1 %polly.loop_guard56, label %polly.loop_header53, label %polly.cond110

polly.loop_header53:                              ; preds = %polly.then51, %polly.loop_exit68
  %polly.indvar57 = phi i64 [ %polly.indvar_next58, %polly.loop_exit68 ], [ 1, %polly.then51 ]
  %p_.moved.to..preheader.lr.ph62 = mul i64 %polly.indvar57, 1001
  %p_scevgep27.moved.to..preheader.lr.ph63 = getelementptr [1000 x double]* %A, i64 0, i64 %p_.moved.to..preheader.lr.ph62
  %_p_scalar_64 = load double* %p_scevgep27.moved.to..preheader.lr.ph63
  %13 = add i64 %1, -1
  %polly.loop_guard69 = icmp sle i64 0, %13
  br i1 %polly.loop_guard69, label %polly.loop_header66, label %polly.loop_exit68

polly.loop_exit68:                                ; preds = %polly.loop_exit78, %polly.loop_header53
  %polly.indvar_next58 = add nsw i64 %polly.indvar57, 1
  %polly.adjust_ub59 = sub i64 %12, 1
  %polly.loop_cond60 = icmp sle i64 %polly.indvar57, %polly.adjust_ub59
  br i1 %polly.loop_cond60, label %polly.loop_header53, label %polly.cond110

polly.loop_header66:                              ; preds = %polly.loop_header53, %polly.loop_exit78
  %polly.indvar70 = phi i64 [ %polly.indvar_next71, %polly.loop_exit78 ], [ 0, %polly.loop_header53 ]
  %p_scevgep22.moved.to..lr.ph = getelementptr [1200 x double]* %B, i64 %polly.indvar57, i64 %polly.indvar70
  %_p_scalar_74 = load double* %p_scevgep22.moved.to..lr.ph
  %14 = add i64 %polly.indvar57, -1
  %polly.loop_guard79 = icmp sle i64 0, %14
  br i1 %polly.loop_guard79, label %polly.loop_header76, label %polly.loop_exit78

polly.loop_exit78:                                ; preds = %polly.loop_header76, %polly.loop_header66
  %temp2.04.reg2mem.0 = phi double [ %p_92, %polly.loop_header76 ], [ 0.000000e+00, %polly.loop_header66 ]
  %p_scevgep21.moved.to.95 = getelementptr [1200 x double]* %C, i64 %polly.indvar57, i64 %polly.indvar70
  %_p_scalar_99 = load double* %p_scevgep21.moved.to.95
  %p_100 = fmul double %_p_scalar_99, %beta
  %_p_scalar_101 = load double* %p_scevgep22.moved.to..lr.ph
  %p_102 = fmul double %_p_scalar_101, %alpha
  %p_104 = fmul double %p_102, %_p_scalar_64
  %p_105 = fadd double %p_100, %p_104
  %p_106 = fmul double %temp2.04.reg2mem.0, %alpha
  %p_107 = fadd double %p_106, %p_105
  store double %p_107, double* %p_scevgep21.moved.to.95
  %p_indvar.next15108 = add i64 %polly.indvar70, 1
  %polly.indvar_next71 = add nsw i64 %polly.indvar70, 1
  %polly.adjust_ub72 = sub i64 %13, 1
  %polly.loop_cond73 = icmp sle i64 %polly.indvar70, %polly.adjust_ub72
  br i1 %polly.loop_cond73, label %polly.loop_header66, label %polly.loop_exit68

polly.loop_header76:                              ; preds = %polly.loop_header66, %polly.loop_header76
  %temp2.04.reg2mem.1 = phi double [ 0.000000e+00, %polly.loop_header66 ], [ %p_92, %polly.loop_header76 ]
  %polly.indvar80 = phi i64 [ %polly.indvar_next81, %polly.loop_header76 ], [ 0, %polly.loop_header66 ]
  %p_.moved.to. = fmul double %_p_scalar_74, %alpha
  %p_scevgep = getelementptr [1000 x double]* %A, i64 %polly.indvar57, i64 %polly.indvar80
  %p_scevgep17 = getelementptr [1200 x double]* %B, i64 %polly.indvar80, i64 %polly.indvar70
  %p_scevgep16 = getelementptr [1200 x double]* %C, i64 %polly.indvar80, i64 %polly.indvar70
  %_p_scalar_85 = load double* %p_scevgep
  %p_86 = fmul double %p_.moved.to., %_p_scalar_85
  %_p_scalar_87 = load double* %p_scevgep16
  %p_88 = fadd double %_p_scalar_87, %p_86
  store double %p_88, double* %p_scevgep16
  %_p_scalar_89 = load double* %p_scevgep17
  %_p_scalar_90 = load double* %p_scevgep
  %p_91 = fmul double %_p_scalar_89, %_p_scalar_90
  %p_92 = fadd double %temp2.04.reg2mem.1, %p_91
  %p_indvar.next = add i64 %polly.indvar80, 1
  %polly.indvar_next81 = add nsw i64 %polly.indvar80, 1
  %polly.adjust_ub82 = sub i64 %14, 1
  %polly.loop_cond83 = icmp sle i64 %polly.indvar80, %polly.adjust_ub82
  br i1 %polly.loop_cond83, label %polly.loop_header76, label %polly.loop_exit78

polly.then112:                                    ; preds = %polly.cond110
  %15 = add i64 %0, -1
  %polly.loop_guard117 = icmp sle i64 1, %15
  br i1 %polly.loop_guard117, label %polly.loop_header114, label %polly.merge

polly.loop_header114:                             ; preds = %polly.then112, %polly.loop_header114
  %polly.indvar118 = phi i64 [ %polly.indvar_next119, %polly.loop_header114 ], [ 1, %polly.then112 ]
  %p_.moved.to..preheader.lr.ph123 = mul i64 %polly.indvar118, 1001
  %p_scevgep27.moved.to..preheader.lr.ph124 = getelementptr [1000 x double]* %A, i64 0, i64 %p_.moved.to..preheader.lr.ph123
  %polly.indvar_next119 = add nsw i64 %polly.indvar118, 1
  %polly.adjust_ub120 = sub i64 %15, 1
  %polly.loop_cond121 = icmp sle i64 %polly.indvar118, %polly.adjust_ub120
  br i1 %polly.loop_cond121, label %polly.loop_header114, label %polly.merge
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %m, i32 %n, [1200 x double]* noalias %C) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %m, 0
  br i1 %5, label %.preheader.lr.ph, label %22

.preheader.lr.ph:                                 ; preds = %.split
  %6 = zext i32 %n to i64
  %7 = zext i32 %m to i64
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
