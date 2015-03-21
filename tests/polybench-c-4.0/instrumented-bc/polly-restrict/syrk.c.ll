; ModuleID = './linear-algebra/blas/syrk/syrk.c'
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
  %2 = bitcast i8* %0 to [1200 x double]*
  %3 = bitcast i8* %1 to [1000 x double]*
  call void @init_array(i32 1200, i32 1000, double* %alpha, double* %beta, [1200 x double]* %2, [1000 x double]* %3)
  call void (...)* @polybench_timer_start() #3
  %4 = load double* %alpha, align 8, !tbaa !1
  %5 = load double* %beta, align 8, !tbaa !1
  call void @kernel_syrk(i32 1200, i32 1000, double %4, double %5, [1200 x double]* %2, [1000 x double]* %3)
  call void (...)* @polybench_timer_stop() #3
  call void (...)* @polybench_timer_print() #3
  %6 = icmp sgt i32 %argc, 42
  br i1 %6, label %7, label %11

; <label>:7                                       ; preds = %.split
  %8 = load i8** %argv, align 8, !tbaa !5
  %9 = load i8* %8, align 1, !tbaa !7
  %phitmp = icmp eq i8 %9, 0
  br i1 %phitmp, label %10, label %11

; <label>:10                                      ; preds = %7
  call void @print_array(i32 1200, [1200 x double]* %2)
  br label %11

; <label>:11                                      ; preds = %7, %10, %.split
  call void @free(i8* %0) #3
  call void @free(i8* %1) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %n, i32 %m, double* %alpha, double* %beta, [1200 x double]* noalias %C, [1000 x double]* noalias %A) #0 {
.split:
  store double 1.500000e+00, double* %alpha, align 8, !tbaa !1
  store double 1.200000e+00, double* %beta, align 8, !tbaa !1
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.preheader2.lr.ph, label %polly.start

.preheader2.lr.ph:                                ; preds = %.split
  %1 = zext i32 %m to i64
  %2 = sitofp i32 %n to double
  %3 = zext i32 %n to i64
  %4 = sext i32 %m to i64
  %5 = icmp sge i64 %4, 1
  %6 = icmp sge i64 %3, 1
  %7 = and i1 %5, %6
  %8 = icmp sge i64 %1, 1
  %9 = and i1 %7, %8
  br i1 %9, label %polly.then62, label %polly.start

polly.start:                                      ; preds = %polly.then62, %polly.loop_exit75, %.preheader2.lr.ph, %.split
  %10 = zext i32 %n to i64
  %11 = sext i32 %n to i64
  %12 = icmp sge i64 %11, 1
  %13 = icmp sge i64 %10, 1
  %14 = and i1 %12, %13
  br i1 %14, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit29, %polly.start
  ret void

polly.then:                                       ; preds = %polly.start
  %15 = add i64 %10, -1
  %polly.loop_guard = icmp sle i64 0, %15
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit29
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit29 ], [ 0, %polly.then ]
  %16 = mul i64 -11, %10
  %17 = add i64 %16, 5
  %18 = sub i64 %17, 32
  %19 = add i64 %18, 1
  %20 = icmp slt i64 %17, 0
  %21 = select i1 %20, i64 %19, i64 %17
  %22 = sdiv i64 %21, 32
  %23 = mul i64 -32, %22
  %24 = mul i64 -32, %10
  %25 = add i64 %23, %24
  %26 = mul i64 -32, %polly.indvar
  %27 = mul i64 -3, %polly.indvar
  %28 = add i64 %27, %10
  %29 = add i64 %28, 5
  %30 = sub i64 %29, 32
  %31 = add i64 %30, 1
  %32 = icmp slt i64 %29, 0
  %33 = select i1 %32, i64 %31, i64 %29
  %34 = sdiv i64 %33, 32
  %35 = mul i64 -32, %34
  %36 = add i64 %26, %35
  %37 = add i64 %36, -640
  %38 = icmp sgt i64 %25, %37
  %39 = select i1 %38, i64 %25, i64 %37
  %40 = mul i64 -20, %polly.indvar
  %polly.loop_guard30 = icmp sle i64 %39, %40
  br i1 %polly.loop_guard30, label %polly.loop_header27, label %polly.loop_exit29

polly.loop_exit29:                                ; preds = %polly.loop_exit38, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %15, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header27:                              ; preds = %polly.loop_header, %polly.loop_exit38
  %polly.indvar31 = phi i64 [ %polly.indvar_next32, %polly.loop_exit38 ], [ %39, %polly.loop_header ]
  %41 = mul i64 -1, %polly.indvar31
  %42 = mul i64 -1, %10
  %43 = add i64 %41, %42
  %44 = add i64 %43, -30
  %45 = add i64 %44, 20
  %46 = sub i64 %45, 1
  %47 = icmp slt i64 %44, 0
  %48 = select i1 %47, i64 %44, i64 %46
  %49 = sdiv i64 %48, 20
  %50 = icmp sgt i64 %49, %polly.indvar
  %51 = select i1 %50, i64 %49, i64 %polly.indvar
  %52 = sub i64 %41, 20
  %53 = add i64 %52, 1
  %54 = icmp slt i64 %41, 0
  %55 = select i1 %54, i64 %53, i64 %41
  %56 = sdiv i64 %55, 20
  %57 = add i64 %polly.indvar, 31
  %58 = icmp slt i64 %56, %57
  %59 = select i1 %58, i64 %56, i64 %57
  %60 = icmp slt i64 %59, %15
  %61 = select i1 %60, i64 %59, i64 %15
  %polly.loop_guard39 = icmp sle i64 %51, %61
  br i1 %polly.loop_guard39, label %polly.loop_header36, label %polly.loop_exit38

polly.loop_exit38:                                ; preds = %polly.loop_exit47, %polly.loop_header27
  %polly.indvar_next32 = add nsw i64 %polly.indvar31, 32
  %polly.adjust_ub33 = sub i64 %40, 32
  %polly.loop_cond34 = icmp sle i64 %polly.indvar31, %polly.adjust_ub33
  br i1 %polly.loop_cond34, label %polly.loop_header27, label %polly.loop_exit29

polly.loop_header36:                              ; preds = %polly.loop_header27, %polly.loop_exit47
  %polly.indvar40 = phi i64 [ %polly.indvar_next41, %polly.loop_exit47 ], [ %51, %polly.loop_header27 ]
  %62 = mul i64 -20, %polly.indvar40
  %63 = add i64 %62, %42
  %64 = add i64 %63, 1
  %65 = icmp sgt i64 %polly.indvar31, %64
  %66 = select i1 %65, i64 %polly.indvar31, i64 %64
  %67 = add i64 %polly.indvar31, 31
  %68 = icmp slt i64 %62, %67
  %69 = select i1 %68, i64 %62, i64 %67
  %polly.loop_guard48 = icmp sle i64 %66, %69
  br i1 %polly.loop_guard48, label %polly.loop_header45, label %polly.loop_exit47

polly.loop_exit47:                                ; preds = %polly.loop_header45, %polly.loop_header36
  %polly.indvar_next41 = add nsw i64 %polly.indvar40, 1
  %polly.adjust_ub42 = sub i64 %61, 1
  %polly.loop_cond43 = icmp sle i64 %polly.indvar40, %polly.adjust_ub42
  br i1 %polly.loop_cond43, label %polly.loop_header36, label %polly.loop_exit38

polly.loop_header45:                              ; preds = %polly.loop_header36, %polly.loop_header45
  %polly.indvar49 = phi i64 [ %polly.indvar_next50, %polly.loop_header45 ], [ %66, %polly.loop_header36 ]
  %70 = mul i64 -1, %polly.indvar49
  %71 = add i64 %62, %70
  %p_.moved.to. = sitofp i32 %m to double
  %p_scevgep = getelementptr [1200 x double]* %C, i64 %polly.indvar40, i64 %71
  %p_ = mul i64 %polly.indvar40, %71
  %p_53 = trunc i64 %p_ to i32
  %p_54 = srem i32 %p_53, %m
  %p_55 = sitofp i32 %p_54 to double
  %p_56 = fdiv double %p_55, %p_.moved.to.
  store double %p_56, double* %p_scevgep
  %p_indvar.next = add i64 %71, 1
  %polly.indvar_next50 = add nsw i64 %polly.indvar49, 1
  %polly.adjust_ub51 = sub i64 %69, 1
  %polly.loop_cond52 = icmp sle i64 %polly.indvar49, %polly.adjust_ub51
  br i1 %polly.loop_cond52, label %polly.loop_header45, label %polly.loop_exit47

polly.then62:                                     ; preds = %.preheader2.lr.ph
  %72 = add i64 %3, -1
  %polly.loop_guard67 = icmp sle i64 0, %72
  br i1 %polly.loop_guard67, label %polly.loop_header64, label %polly.start

polly.loop_header64:                              ; preds = %polly.then62, %polly.loop_exit75
  %polly.indvar68 = phi i64 [ %polly.indvar_next69, %polly.loop_exit75 ], [ 0, %polly.then62 ]
  %73 = mul i64 -3, %3
  %74 = add i64 %73, %1
  %75 = add i64 %74, 5
  %76 = sub i64 %75, 32
  %77 = add i64 %76, 1
  %78 = icmp slt i64 %75, 0
  %79 = select i1 %78, i64 %77, i64 %75
  %80 = sdiv i64 %79, 32
  %81 = mul i64 -32, %80
  %82 = mul i64 -32, %3
  %83 = add i64 %81, %82
  %84 = mul i64 -32, %polly.indvar68
  %85 = mul i64 -3, %polly.indvar68
  %86 = add i64 %85, %1
  %87 = add i64 %86, 5
  %88 = sub i64 %87, 32
  %89 = add i64 %88, 1
  %90 = icmp slt i64 %87, 0
  %91 = select i1 %90, i64 %89, i64 %87
  %92 = sdiv i64 %91, 32
  %93 = mul i64 -32, %92
  %94 = add i64 %84, %93
  %95 = add i64 %94, -640
  %96 = icmp sgt i64 %83, %95
  %97 = select i1 %96, i64 %83, i64 %95
  %98 = mul i64 -20, %polly.indvar68
  %polly.loop_guard76 = icmp sle i64 %97, %98
  br i1 %polly.loop_guard76, label %polly.loop_header73, label %polly.loop_exit75

polly.loop_exit75:                                ; preds = %polly.loop_exit84, %polly.loop_header64
  %polly.indvar_next69 = add nsw i64 %polly.indvar68, 32
  %polly.adjust_ub70 = sub i64 %72, 32
  %polly.loop_cond71 = icmp sle i64 %polly.indvar68, %polly.adjust_ub70
  br i1 %polly.loop_cond71, label %polly.loop_header64, label %polly.start

polly.loop_header73:                              ; preds = %polly.loop_header64, %polly.loop_exit84
  %polly.indvar77 = phi i64 [ %polly.indvar_next78, %polly.loop_exit84 ], [ %97, %polly.loop_header64 ]
  %99 = mul i64 -1, %polly.indvar77
  %100 = mul i64 -1, %1
  %101 = add i64 %99, %100
  %102 = add i64 %101, -30
  %103 = add i64 %102, 20
  %104 = sub i64 %103, 1
  %105 = icmp slt i64 %102, 0
  %106 = select i1 %105, i64 %102, i64 %104
  %107 = sdiv i64 %106, 20
  %108 = icmp sgt i64 %107, %polly.indvar68
  %109 = select i1 %108, i64 %107, i64 %polly.indvar68
  %110 = sub i64 %99, 20
  %111 = add i64 %110, 1
  %112 = icmp slt i64 %99, 0
  %113 = select i1 %112, i64 %111, i64 %99
  %114 = sdiv i64 %113, 20
  %115 = add i64 %polly.indvar68, 31
  %116 = icmp slt i64 %114, %115
  %117 = select i1 %116, i64 %114, i64 %115
  %118 = icmp slt i64 %117, %72
  %119 = select i1 %118, i64 %117, i64 %72
  %polly.loop_guard85 = icmp sle i64 %109, %119
  br i1 %polly.loop_guard85, label %polly.loop_header82, label %polly.loop_exit84

polly.loop_exit84:                                ; preds = %polly.loop_exit93, %polly.loop_header73
  %polly.indvar_next78 = add nsw i64 %polly.indvar77, 32
  %polly.adjust_ub79 = sub i64 %98, 32
  %polly.loop_cond80 = icmp sle i64 %polly.indvar77, %polly.adjust_ub79
  br i1 %polly.loop_cond80, label %polly.loop_header73, label %polly.loop_exit75

polly.loop_header82:                              ; preds = %polly.loop_header73, %polly.loop_exit93
  %polly.indvar86 = phi i64 [ %polly.indvar_next87, %polly.loop_exit93 ], [ %109, %polly.loop_header73 ]
  %120 = mul i64 -20, %polly.indvar86
  %121 = add i64 %120, %100
  %122 = add i64 %121, 1
  %123 = icmp sgt i64 %polly.indvar77, %122
  %124 = select i1 %123, i64 %polly.indvar77, i64 %122
  %125 = add i64 %polly.indvar77, 31
  %126 = icmp slt i64 %120, %125
  %127 = select i1 %126, i64 %120, i64 %125
  %polly.loop_guard94 = icmp sle i64 %124, %127
  br i1 %polly.loop_guard94, label %polly.loop_header91, label %polly.loop_exit93

polly.loop_exit93:                                ; preds = %polly.loop_header91, %polly.loop_header82
  %polly.indvar_next87 = add nsw i64 %polly.indvar86, 1
  %polly.adjust_ub88 = sub i64 %119, 1
  %polly.loop_cond89 = icmp sle i64 %polly.indvar86, %polly.adjust_ub88
  br i1 %polly.loop_cond89, label %polly.loop_header82, label %polly.loop_exit84

polly.loop_header91:                              ; preds = %polly.loop_header82, %polly.loop_header91
  %polly.indvar95 = phi i64 [ %polly.indvar_next96, %polly.loop_header91 ], [ %124, %polly.loop_header82 ]
  %128 = mul i64 -1, %polly.indvar95
  %129 = add i64 %120, %128
  %p_scevgep21 = getelementptr [1000 x double]* %A, i64 %polly.indvar86, i64 %129
  %p_100 = mul i64 %polly.indvar86, %129
  %p_101 = trunc i64 %p_100 to i32
  %p_102 = srem i32 %p_101, %n
  %p_103 = sitofp i32 %p_102 to double
  %p_104 = fdiv double %p_103, %2
  store double %p_104, double* %p_scevgep21
  %p_indvar.next17 = add i64 %129, 1
  %polly.indvar_next96 = add nsw i64 %polly.indvar95, 1
  %polly.adjust_ub97 = sub i64 %127, 1
  %polly.loop_cond98 = icmp sle i64 %polly.indvar95, %polly.adjust_ub97
  br i1 %polly.loop_cond98, label %polly.loop_header91, label %polly.loop_exit93
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_syrk(i32 %n, i32 %m, double %alpha, double %beta, [1200 x double]* noalias %C, [1000 x double]* noalias %A) #0 {
polly.split_new_and_old:
  %0 = zext i32 %n to i64
  %1 = zext i32 %m to i64
  %2 = sext i32 %n to i64
  %3 = icmp sge i64 %2, 1
  %4 = icmp sge i64 %0, 1
  %5 = and i1 %3, %4
  br i1 %5, label %polly.cond31, label %polly.merge

polly.merge:                                      ; preds = %polly.then97, %polly.loop_exit110, %polly.cond95, %polly.split_new_and_old
  ret void

polly.cond31:                                     ; preds = %polly.split_new_and_old
  %6 = sext i32 %m to i64
  %7 = icmp sge i64 %6, 1
  %8 = icmp sge i64 %1, 1
  %9 = and i1 %7, %8
  br i1 %9, label %polly.then33, label %polly.cond67

polly.cond67:                                     ; preds = %polly.then33, %polly.loop_exit46, %polly.cond31
  %10 = icmp sle i64 %6, 0
  %11 = and i1 %10, %8
  br i1 %11, label %polly.then69, label %polly.cond95

polly.cond95:                                     ; preds = %polly.then69, %polly.loop_exit82, %polly.cond67
  %12 = icmp sle i64 %1, 0
  br i1 %12, label %polly.then97, label %polly.merge

polly.then33:                                     ; preds = %polly.cond31
  %13 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %13
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond67

polly.loop_header:                                ; preds = %polly.then33, %polly.loop_exit46
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit46 ], [ 0, %polly.then33 ]
  %polly.loop_guard38 = icmp sle i64 0, %polly.indvar
  br i1 %polly.loop_guard38, label %polly.loop_header35, label %polly.loop_exit37

polly.loop_exit37:                                ; preds = %polly.loop_header35, %polly.loop_header
  %14 = add i64 %1, -1
  %polly.loop_guard47 = icmp sle i64 0, %14
  br i1 %polly.loop_guard47, label %polly.loop_header44, label %polly.loop_exit46

polly.loop_exit46:                                ; preds = %polly.loop_exit56, %polly.loop_exit37
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %13, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond67

polly.loop_header35:                              ; preds = %polly.loop_header, %polly.loop_header35
  %polly.indvar39 = phi i64 [ %polly.indvar_next40, %polly.loop_header35 ], [ 0, %polly.loop_header ]
  %p_.moved.to.30 = add i64 %polly.indvar, 1
  %p_scevgep = getelementptr [1200 x double]* %C, i64 %polly.indvar, i64 %polly.indvar39
  %_p_scalar_ = load double* %p_scevgep
  %p_ = fmul double %_p_scalar_, %beta
  store double %p_, double* %p_scevgep
  %p_indvar.next = add i64 %polly.indvar39, 1
  %polly.indvar_next40 = add nsw i64 %polly.indvar39, 1
  %polly.adjust_ub41 = sub i64 %polly.indvar, 1
  %polly.loop_cond42 = icmp sle i64 %polly.indvar39, %polly.adjust_ub41
  br i1 %polly.loop_cond42, label %polly.loop_header35, label %polly.loop_exit37

polly.loop_header44:                              ; preds = %polly.loop_exit37, %polly.loop_exit56
  %polly.indvar48 = phi i64 [ %polly.indvar_next49, %polly.loop_exit56 ], [ 0, %polly.loop_exit37 ]
  %p_scevgep22.moved.to..lr.ph5 = getelementptr [1000 x double]* %A, i64 %polly.indvar, i64 %polly.indvar48
  %_p_scalar_52 = load double* %p_scevgep22.moved.to..lr.ph5
  br i1 %polly.loop_guard38, label %polly.loop_header54, label %polly.loop_exit56

polly.loop_exit56:                                ; preds = %polly.loop_header54, %polly.loop_header44
  %polly.indvar_next49 = add nsw i64 %polly.indvar48, 1
  %polly.adjust_ub50 = sub i64 %14, 1
  %polly.loop_cond51 = icmp sle i64 %polly.indvar48, %polly.adjust_ub50
  br i1 %polly.loop_cond51, label %polly.loop_header44, label %polly.loop_exit46

polly.loop_header54:                              ; preds = %polly.loop_header44, %polly.loop_header54
  %polly.indvar58 = phi i64 [ %polly.indvar_next59, %polly.loop_header54 ], [ 0, %polly.loop_header44 ]
  %p_.moved.to.28 = fmul double %_p_scalar_52, %alpha
  %p_.moved.to.29 = add i64 %polly.indvar, 1
  %p_scevgep19 = getelementptr [1200 x double]* %C, i64 %polly.indvar, i64 %polly.indvar58
  %p_scevgep18 = getelementptr [1000 x double]* %A, i64 %polly.indvar58, i64 %polly.indvar48
  %_p_scalar_63 = load double* %p_scevgep18
  %p_64 = fmul double %p_.moved.to.28, %_p_scalar_63
  %_p_scalar_65 = load double* %p_scevgep19
  %p_66 = fadd double %_p_scalar_65, %p_64
  store double %p_66, double* %p_scevgep19
  %p_indvar.next14 = add i64 %polly.indvar58, 1
  %polly.indvar_next59 = add nsw i64 %polly.indvar58, 1
  %polly.adjust_ub60 = sub i64 %polly.indvar, 1
  %polly.loop_cond61 = icmp sle i64 %polly.indvar58, %polly.adjust_ub60
  br i1 %polly.loop_cond61, label %polly.loop_header54, label %polly.loop_exit56

polly.then69:                                     ; preds = %polly.cond67
  %15 = add i64 %0, -1
  %polly.loop_guard74 = icmp sle i64 0, %15
  br i1 %polly.loop_guard74, label %polly.loop_header71, label %polly.cond95

polly.loop_header71:                              ; preds = %polly.then69, %polly.loop_exit82
  %polly.indvar75 = phi i64 [ %polly.indvar_next76, %polly.loop_exit82 ], [ 0, %polly.then69 ]
  %polly.loop_guard83 = icmp sle i64 0, %polly.indvar75
  br i1 %polly.loop_guard83, label %polly.loop_header80, label %polly.loop_exit82

polly.loop_exit82:                                ; preds = %polly.loop_header80, %polly.loop_header71
  %polly.indvar_next76 = add nsw i64 %polly.indvar75, 1
  %polly.adjust_ub77 = sub i64 %15, 1
  %polly.loop_cond78 = icmp sle i64 %polly.indvar75, %polly.adjust_ub77
  br i1 %polly.loop_cond78, label %polly.loop_header71, label %polly.cond95

polly.loop_header80:                              ; preds = %polly.loop_header71, %polly.loop_header80
  %polly.indvar84 = phi i64 [ %polly.indvar_next85, %polly.loop_header80 ], [ 0, %polly.loop_header71 ]
  %p_.moved.to.3089 = add i64 %polly.indvar75, 1
  %p_scevgep90 = getelementptr [1200 x double]* %C, i64 %polly.indvar75, i64 %polly.indvar84
  %_p_scalar_91 = load double* %p_scevgep90
  %p_92 = fmul double %_p_scalar_91, %beta
  store double %p_92, double* %p_scevgep90
  %p_indvar.next93 = add i64 %polly.indvar84, 1
  %polly.indvar_next85 = add nsw i64 %polly.indvar84, 1
  %polly.adjust_ub86 = sub i64 %polly.indvar75, 1
  %polly.loop_cond87 = icmp sle i64 %polly.indvar84, %polly.adjust_ub86
  br i1 %polly.loop_cond87, label %polly.loop_header80, label %polly.loop_exit82

polly.then97:                                     ; preds = %polly.cond95
  %16 = add i64 %0, -1
  %polly.loop_guard102 = icmp sle i64 0, %16
  br i1 %polly.loop_guard102, label %polly.loop_header99, label %polly.merge

polly.loop_header99:                              ; preds = %polly.then97, %polly.loop_exit110
  %polly.indvar103 = phi i64 [ %polly.indvar_next104, %polly.loop_exit110 ], [ 0, %polly.then97 ]
  %polly.loop_guard111 = icmp sle i64 0, %polly.indvar103
  br i1 %polly.loop_guard111, label %polly.loop_header108, label %polly.loop_exit110

polly.loop_exit110:                               ; preds = %polly.loop_header108, %polly.loop_header99
  %polly.indvar_next104 = add nsw i64 %polly.indvar103, 1
  %polly.adjust_ub105 = sub i64 %16, 1
  %polly.loop_cond106 = icmp sle i64 %polly.indvar103, %polly.adjust_ub105
  br i1 %polly.loop_cond106, label %polly.loop_header99, label %polly.merge

polly.loop_header108:                             ; preds = %polly.loop_header99, %polly.loop_header108
  %polly.indvar112 = phi i64 [ %polly.indvar_next113, %polly.loop_header108 ], [ 0, %polly.loop_header99 ]
  %p_.moved.to.30117 = add i64 %polly.indvar103, 1
  %p_scevgep118 = getelementptr [1200 x double]* %C, i64 %polly.indvar103, i64 %polly.indvar112
  %_p_scalar_119 = load double* %p_scevgep118
  %p_120 = fmul double %_p_scalar_119, %beta
  store double %p_120, double* %p_scevgep118
  %p_indvar.next121 = add i64 %polly.indvar112, 1
  %polly.indvar_next113 = add nsw i64 %polly.indvar112, 1
  %polly.adjust_ub114 = sub i64 %polly.indvar103, 1
  %polly.loop_cond115 = icmp sle i64 %polly.indvar112, %polly.adjust_ub114
  br i1 %polly.loop_cond115, label %polly.loop_header108, label %polly.loop_exit110
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, [1200 x double]* noalias %C) #0 {
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
