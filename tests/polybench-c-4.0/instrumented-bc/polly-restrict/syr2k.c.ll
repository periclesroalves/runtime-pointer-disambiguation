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
define internal void @init_array(i32 %n, i32 %m, double* %alpha, double* %beta, [1200 x double]* noalias %C, [1000 x double]* noalias %A, [1000 x double]* noalias %B) #0 {
.split:
  store double 1.500000e+00, double* %alpha, align 8, !tbaa !1
  store double 1.200000e+00, double* %beta, align 8, !tbaa !1
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.preheader2.lr.ph, label %polly.start

.preheader2.lr.ph:                                ; preds = %.split
  %1 = zext i32 %m to i64
  %2 = sitofp i32 %n to double
  %3 = sitofp i32 %m to double
  %4 = zext i32 %n to i64
  %5 = sext i32 %m to i64
  %6 = icmp sge i64 %5, 1
  %7 = icmp sge i64 %4, 1
  %8 = and i1 %6, %7
  %9 = icmp sge i64 %1, 1
  %10 = and i1 %8, %9
  br i1 %10, label %polly.then64, label %polly.start

polly.start:                                      ; preds = %polly.then64, %polly.loop_exit77, %.preheader2.lr.ph, %.split
  %11 = zext i32 %n to i64
  %12 = sext i32 %n to i64
  %13 = icmp sge i64 %12, 1
  %14 = icmp sge i64 %11, 1
  %15 = and i1 %13, %14
  br i1 %15, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit31, %polly.start
  ret void

polly.then:                                       ; preds = %polly.start
  %16 = add i64 %11, -1
  %polly.loop_guard = icmp sle i64 0, %16
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit31
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit31 ], [ 0, %polly.then ]
  %17 = mul i64 -11, %11
  %18 = add i64 %17, 5
  %19 = sub i64 %18, 32
  %20 = add i64 %19, 1
  %21 = icmp slt i64 %18, 0
  %22 = select i1 %21, i64 %20, i64 %18
  %23 = sdiv i64 %22, 32
  %24 = mul i64 -32, %23
  %25 = mul i64 -32, %11
  %26 = add i64 %24, %25
  %27 = mul i64 -32, %polly.indvar
  %28 = mul i64 -3, %polly.indvar
  %29 = add i64 %28, %11
  %30 = add i64 %29, 5
  %31 = sub i64 %30, 32
  %32 = add i64 %31, 1
  %33 = icmp slt i64 %30, 0
  %34 = select i1 %33, i64 %32, i64 %30
  %35 = sdiv i64 %34, 32
  %36 = mul i64 -32, %35
  %37 = add i64 %27, %36
  %38 = add i64 %37, -640
  %39 = icmp sgt i64 %26, %38
  %40 = select i1 %39, i64 %26, i64 %38
  %41 = mul i64 -20, %polly.indvar
  %polly.loop_guard32 = icmp sle i64 %40, %41
  br i1 %polly.loop_guard32, label %polly.loop_header29, label %polly.loop_exit31

polly.loop_exit31:                                ; preds = %polly.loop_exit40, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %16, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header29:                              ; preds = %polly.loop_header, %polly.loop_exit40
  %polly.indvar33 = phi i64 [ %polly.indvar_next34, %polly.loop_exit40 ], [ %40, %polly.loop_header ]
  %42 = mul i64 -1, %polly.indvar33
  %43 = mul i64 -1, %11
  %44 = add i64 %42, %43
  %45 = add i64 %44, -30
  %46 = add i64 %45, 20
  %47 = sub i64 %46, 1
  %48 = icmp slt i64 %45, 0
  %49 = select i1 %48, i64 %45, i64 %47
  %50 = sdiv i64 %49, 20
  %51 = icmp sgt i64 %50, %polly.indvar
  %52 = select i1 %51, i64 %50, i64 %polly.indvar
  %53 = sub i64 %42, 20
  %54 = add i64 %53, 1
  %55 = icmp slt i64 %42, 0
  %56 = select i1 %55, i64 %54, i64 %42
  %57 = sdiv i64 %56, 20
  %58 = add i64 %polly.indvar, 31
  %59 = icmp slt i64 %57, %58
  %60 = select i1 %59, i64 %57, i64 %58
  %61 = icmp slt i64 %60, %16
  %62 = select i1 %61, i64 %60, i64 %16
  %polly.loop_guard41 = icmp sle i64 %52, %62
  br i1 %polly.loop_guard41, label %polly.loop_header38, label %polly.loop_exit40

polly.loop_exit40:                                ; preds = %polly.loop_exit49, %polly.loop_header29
  %polly.indvar_next34 = add nsw i64 %polly.indvar33, 32
  %polly.adjust_ub35 = sub i64 %41, 32
  %polly.loop_cond36 = icmp sle i64 %polly.indvar33, %polly.adjust_ub35
  br i1 %polly.loop_cond36, label %polly.loop_header29, label %polly.loop_exit31

polly.loop_header38:                              ; preds = %polly.loop_header29, %polly.loop_exit49
  %polly.indvar42 = phi i64 [ %polly.indvar_next43, %polly.loop_exit49 ], [ %52, %polly.loop_header29 ]
  %63 = mul i64 -20, %polly.indvar42
  %64 = add i64 %63, %43
  %65 = add i64 %64, 1
  %66 = icmp sgt i64 %polly.indvar33, %65
  %67 = select i1 %66, i64 %polly.indvar33, i64 %65
  %68 = add i64 %polly.indvar33, 31
  %69 = icmp slt i64 %63, %68
  %70 = select i1 %69, i64 %63, i64 %68
  %polly.loop_guard50 = icmp sle i64 %67, %70
  br i1 %polly.loop_guard50, label %polly.loop_header47, label %polly.loop_exit49

polly.loop_exit49:                                ; preds = %polly.loop_header47, %polly.loop_header38
  %polly.indvar_next43 = add nsw i64 %polly.indvar42, 1
  %polly.adjust_ub44 = sub i64 %62, 1
  %polly.loop_cond45 = icmp sle i64 %polly.indvar42, %polly.adjust_ub44
  br i1 %polly.loop_cond45, label %polly.loop_header38, label %polly.loop_exit40

polly.loop_header47:                              ; preds = %polly.loop_header38, %polly.loop_header47
  %polly.indvar51 = phi i64 [ %polly.indvar_next52, %polly.loop_header47 ], [ %67, %polly.loop_header38 ]
  %71 = mul i64 -1, %polly.indvar51
  %72 = add i64 %63, %71
  %p_.moved.to. = sitofp i32 %m to double
  %p_scevgep = getelementptr [1200 x double]* %C, i64 %polly.indvar42, i64 %72
  %p_ = mul i64 %polly.indvar42, %72
  %p_55 = trunc i64 %p_ to i32
  %p_56 = srem i32 %p_55, %n
  %p_57 = sitofp i32 %p_56 to double
  %p_58 = fdiv double %p_57, %p_.moved.to.
  store double %p_58, double* %p_scevgep
  %p_indvar.next = add i64 %72, 1
  %polly.indvar_next52 = add nsw i64 %polly.indvar51, 1
  %polly.adjust_ub53 = sub i64 %70, 1
  %polly.loop_cond54 = icmp sle i64 %polly.indvar51, %polly.adjust_ub53
  br i1 %polly.loop_cond54, label %polly.loop_header47, label %polly.loop_exit49

polly.then64:                                     ; preds = %.preheader2.lr.ph
  %73 = add i64 %4, -1
  %polly.loop_guard69 = icmp sle i64 0, %73
  br i1 %polly.loop_guard69, label %polly.loop_header66, label %polly.start

polly.loop_header66:                              ; preds = %polly.then64, %polly.loop_exit77
  %polly.indvar70 = phi i64 [ %polly.indvar_next71, %polly.loop_exit77 ], [ 0, %polly.then64 ]
  %74 = mul i64 -3, %4
  %75 = add i64 %74, %1
  %76 = add i64 %75, 5
  %77 = sub i64 %76, 32
  %78 = add i64 %77, 1
  %79 = icmp slt i64 %76, 0
  %80 = select i1 %79, i64 %78, i64 %76
  %81 = sdiv i64 %80, 32
  %82 = mul i64 -32, %81
  %83 = mul i64 -32, %4
  %84 = add i64 %82, %83
  %85 = mul i64 -32, %polly.indvar70
  %86 = mul i64 -3, %polly.indvar70
  %87 = add i64 %86, %1
  %88 = add i64 %87, 5
  %89 = sub i64 %88, 32
  %90 = add i64 %89, 1
  %91 = icmp slt i64 %88, 0
  %92 = select i1 %91, i64 %90, i64 %88
  %93 = sdiv i64 %92, 32
  %94 = mul i64 -32, %93
  %95 = add i64 %85, %94
  %96 = add i64 %95, -640
  %97 = icmp sgt i64 %84, %96
  %98 = select i1 %97, i64 %84, i64 %96
  %99 = mul i64 -20, %polly.indvar70
  %polly.loop_guard78 = icmp sle i64 %98, %99
  br i1 %polly.loop_guard78, label %polly.loop_header75, label %polly.loop_exit77

polly.loop_exit77:                                ; preds = %polly.loop_exit86, %polly.loop_header66
  %polly.indvar_next71 = add nsw i64 %polly.indvar70, 32
  %polly.adjust_ub72 = sub i64 %73, 32
  %polly.loop_cond73 = icmp sle i64 %polly.indvar70, %polly.adjust_ub72
  br i1 %polly.loop_cond73, label %polly.loop_header66, label %polly.start

polly.loop_header75:                              ; preds = %polly.loop_header66, %polly.loop_exit86
  %polly.indvar79 = phi i64 [ %polly.indvar_next80, %polly.loop_exit86 ], [ %98, %polly.loop_header66 ]
  %100 = mul i64 -1, %polly.indvar79
  %101 = mul i64 -1, %1
  %102 = add i64 %100, %101
  %103 = add i64 %102, -30
  %104 = add i64 %103, 20
  %105 = sub i64 %104, 1
  %106 = icmp slt i64 %103, 0
  %107 = select i1 %106, i64 %103, i64 %105
  %108 = sdiv i64 %107, 20
  %109 = icmp sgt i64 %108, %polly.indvar70
  %110 = select i1 %109, i64 %108, i64 %polly.indvar70
  %111 = sub i64 %100, 20
  %112 = add i64 %111, 1
  %113 = icmp slt i64 %100, 0
  %114 = select i1 %113, i64 %112, i64 %100
  %115 = sdiv i64 %114, 20
  %116 = add i64 %polly.indvar70, 31
  %117 = icmp slt i64 %115, %116
  %118 = select i1 %117, i64 %115, i64 %116
  %119 = icmp slt i64 %118, %73
  %120 = select i1 %119, i64 %118, i64 %73
  %polly.loop_guard87 = icmp sle i64 %110, %120
  br i1 %polly.loop_guard87, label %polly.loop_header84, label %polly.loop_exit86

polly.loop_exit86:                                ; preds = %polly.loop_exit95, %polly.loop_header75
  %polly.indvar_next80 = add nsw i64 %polly.indvar79, 32
  %polly.adjust_ub81 = sub i64 %99, 32
  %polly.loop_cond82 = icmp sle i64 %polly.indvar79, %polly.adjust_ub81
  br i1 %polly.loop_cond82, label %polly.loop_header75, label %polly.loop_exit77

polly.loop_header84:                              ; preds = %polly.loop_header75, %polly.loop_exit95
  %polly.indvar88 = phi i64 [ %polly.indvar_next89, %polly.loop_exit95 ], [ %110, %polly.loop_header75 ]
  %121 = mul i64 -20, %polly.indvar88
  %122 = add i64 %121, %101
  %123 = add i64 %122, 1
  %124 = icmp sgt i64 %polly.indvar79, %123
  %125 = select i1 %124, i64 %polly.indvar79, i64 %123
  %126 = add i64 %polly.indvar79, 31
  %127 = icmp slt i64 %121, %126
  %128 = select i1 %127, i64 %121, i64 %126
  %polly.loop_guard96 = icmp sle i64 %125, %128
  br i1 %polly.loop_guard96, label %polly.loop_header93, label %polly.loop_exit95

polly.loop_exit95:                                ; preds = %polly.loop_header93, %polly.loop_header84
  %polly.indvar_next89 = add nsw i64 %polly.indvar88, 1
  %polly.adjust_ub90 = sub i64 %120, 1
  %polly.loop_cond91 = icmp sle i64 %polly.indvar88, %polly.adjust_ub90
  br i1 %polly.loop_cond91, label %polly.loop_header84, label %polly.loop_exit86

polly.loop_header93:                              ; preds = %polly.loop_header84, %polly.loop_header93
  %polly.indvar97 = phi i64 [ %polly.indvar_next98, %polly.loop_header93 ], [ %125, %polly.loop_header84 ]
  %129 = mul i64 -1, %polly.indvar97
  %130 = add i64 %121, %129
  %p_scevgep22 = getelementptr [1000 x double]* %B, i64 %polly.indvar88, i64 %130
  %p_scevgep21 = getelementptr [1000 x double]* %A, i64 %polly.indvar88, i64 %130
  %p_102 = mul i64 %polly.indvar88, %130
  %p_103 = trunc i64 %p_102 to i32
  %p_104 = srem i32 %p_103, %n
  %p_105 = sitofp i32 %p_104 to double
  %p_106 = fdiv double %p_105, %2
  store double %p_106, double* %p_scevgep21
  %p_107 = srem i32 %p_103, %m
  %p_108 = sitofp i32 %p_107 to double
  %p_109 = fdiv double %p_108, %3
  store double %p_109, double* %p_scevgep22
  %p_indvar.next17 = add i64 %130, 1
  %polly.indvar_next98 = add nsw i64 %polly.indvar97, 1
  %polly.adjust_ub99 = sub i64 %128, 1
  %polly.loop_cond100 = icmp sle i64 %polly.indvar97, %polly.adjust_ub99
  br i1 %polly.loop_cond100, label %polly.loop_header93, label %polly.loop_exit95
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_syr2k(i32 %n, i32 %m, double %alpha, double %beta, [1200 x double]* noalias %C, [1000 x double]* noalias %A, [1000 x double]* noalias %B) #0 {
polly.split_new_and_old:
  %0 = zext i32 %n to i64
  %1 = zext i32 %m to i64
  %2 = sext i32 %n to i64
  %3 = icmp sge i64 %2, 1
  %4 = icmp sge i64 %0, 1
  %5 = and i1 %3, %4
  br i1 %5, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.then71, %polly.loop_exit84, %polly.cond69, %polly.split_new_and_old
  ret void

polly.then:                                       ; preds = %polly.split_new_and_old
  %6 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %6
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond69

polly.cond69:                                     ; preds = %polly.then, %polly.loop_exit45
  %7 = sext i32 %m to i64
  %8 = icmp sge i64 %7, 1
  %9 = icmp sge i64 %1, 1
  %10 = and i1 %8, %9
  br i1 %10, label %polly.then71, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit45
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit45 ], [ 0, %polly.then ]
  %11 = mul i64 -11, %0
  %12 = add i64 %11, 5
  %13 = sub i64 %12, 32
  %14 = add i64 %13, 1
  %15 = icmp slt i64 %12, 0
  %16 = select i1 %15, i64 %14, i64 %12
  %17 = sdiv i64 %16, 32
  %18 = mul i64 -32, %17
  %19 = mul i64 -32, %0
  %20 = add i64 %18, %19
  %21 = mul i64 -32, %polly.indvar
  %22 = mul i64 -3, %polly.indvar
  %23 = add i64 %22, %0
  %24 = add i64 %23, 5
  %25 = sub i64 %24, 32
  %26 = add i64 %25, 1
  %27 = icmp slt i64 %24, 0
  %28 = select i1 %27, i64 %26, i64 %24
  %29 = sdiv i64 %28, 32
  %30 = mul i64 -32, %29
  %31 = add i64 %21, %30
  %32 = add i64 %31, -640
  %33 = icmp sgt i64 %20, %32
  %34 = select i1 %33, i64 %20, i64 %32
  %35 = mul i64 -20, %polly.indvar
  %polly.loop_guard46 = icmp sle i64 %34, %35
  br i1 %polly.loop_guard46, label %polly.loop_header43, label %polly.loop_exit45

polly.loop_exit45:                                ; preds = %polly.loop_exit54, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %6, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond69

polly.loop_header43:                              ; preds = %polly.loop_header, %polly.loop_exit54
  %polly.indvar47 = phi i64 [ %polly.indvar_next48, %polly.loop_exit54 ], [ %34, %polly.loop_header ]
  %36 = mul i64 -1, %polly.indvar47
  %37 = mul i64 -1, %0
  %38 = add i64 %36, %37
  %39 = add i64 %38, -30
  %40 = add i64 %39, 20
  %41 = sub i64 %40, 1
  %42 = icmp slt i64 %39, 0
  %43 = select i1 %42, i64 %39, i64 %41
  %44 = sdiv i64 %43, 20
  %45 = icmp sgt i64 %44, %polly.indvar
  %46 = select i1 %45, i64 %44, i64 %polly.indvar
  %47 = sub i64 %36, 20
  %48 = add i64 %47, 1
  %49 = icmp slt i64 %36, 0
  %50 = select i1 %49, i64 %48, i64 %36
  %51 = sdiv i64 %50, 20
  %52 = add i64 %polly.indvar, 31
  %53 = icmp slt i64 %51, %52
  %54 = select i1 %53, i64 %51, i64 %52
  %55 = icmp slt i64 %54, %6
  %56 = select i1 %55, i64 %54, i64 %6
  %polly.loop_guard55 = icmp sle i64 %46, %56
  br i1 %polly.loop_guard55, label %polly.loop_header52, label %polly.loop_exit54

polly.loop_exit54:                                ; preds = %polly.loop_exit63, %polly.loop_header43
  %polly.indvar_next48 = add nsw i64 %polly.indvar47, 32
  %polly.adjust_ub49 = sub i64 %35, 32
  %polly.loop_cond50 = icmp sle i64 %polly.indvar47, %polly.adjust_ub49
  br i1 %polly.loop_cond50, label %polly.loop_header43, label %polly.loop_exit45

polly.loop_header52:                              ; preds = %polly.loop_header43, %polly.loop_exit63
  %polly.indvar56 = phi i64 [ %polly.indvar_next57, %polly.loop_exit63 ], [ %46, %polly.loop_header43 ]
  %57 = mul i64 -20, %polly.indvar56
  %58 = add i64 %57, %37
  %59 = add i64 %58, 1
  %60 = icmp sgt i64 %polly.indvar47, %59
  %61 = select i1 %60, i64 %polly.indvar47, i64 %59
  %62 = add i64 %polly.indvar47, 31
  %63 = icmp slt i64 %57, %62
  %64 = select i1 %63, i64 %57, i64 %62
  %polly.loop_guard64 = icmp sle i64 %61, %64
  br i1 %polly.loop_guard64, label %polly.loop_header61, label %polly.loop_exit63

polly.loop_exit63:                                ; preds = %polly.loop_header61, %polly.loop_header52
  %polly.indvar_next57 = add nsw i64 %polly.indvar56, 1
  %polly.adjust_ub58 = sub i64 %56, 1
  %polly.loop_cond59 = icmp sle i64 %polly.indvar56, %polly.adjust_ub58
  br i1 %polly.loop_cond59, label %polly.loop_header52, label %polly.loop_exit54

polly.loop_header61:                              ; preds = %polly.loop_header52, %polly.loop_header61
  %polly.indvar65 = phi i64 [ %polly.indvar_next66, %polly.loop_header61 ], [ %61, %polly.loop_header52 ]
  %65 = mul i64 -1, %polly.indvar65
  %66 = add i64 %57, %65
  %p_scevgep33 = getelementptr [1200 x double]* %C, i64 %polly.indvar56, i64 %66
  %_p_scalar_ = load double* %p_scevgep33
  %p_ = fmul double %_p_scalar_, %beta
  store double %p_, double* %p_scevgep33
  %p_indvar.next29 = add i64 %66, 1
  %polly.indvar_next66 = add nsw i64 %polly.indvar65, 1
  %polly.adjust_ub67 = sub i64 %64, 1
  %polly.loop_cond68 = icmp sle i64 %polly.indvar65, %polly.adjust_ub67
  br i1 %polly.loop_cond68, label %polly.loop_header61, label %polly.loop_exit63

polly.then71:                                     ; preds = %polly.cond69
  br i1 %polly.loop_guard, label %polly.loop_header73, label %polly.merge

polly.loop_header73:                              ; preds = %polly.then71, %polly.loop_exit84
  %polly.indvar77 = phi i64 [ %polly.indvar_next78, %polly.loop_exit84 ], [ 0, %polly.then71 ]
  %67 = add i64 %1, -1
  %polly.loop_guard85 = icmp sle i64 0, %67
  br i1 %polly.loop_guard85, label %polly.loop_header82, label %polly.loop_exit84

polly.loop_exit84:                                ; preds = %polly.loop_exit95, %polly.loop_header73
  %polly.indvar_next78 = add nsw i64 %polly.indvar77, 1
  %polly.adjust_ub79 = sub i64 %6, 1
  %polly.loop_cond80 = icmp sle i64 %polly.indvar77, %polly.adjust_ub79
  br i1 %polly.loop_cond80, label %polly.loop_header73, label %polly.merge

polly.loop_header82:                              ; preds = %polly.loop_header73, %polly.loop_exit95
  %polly.indvar86 = phi i64 [ %polly.indvar_next87, %polly.loop_exit95 ], [ 0, %polly.loop_header73 ]
  %p_scevgep22.moved.to..lr.ph = getelementptr [1000 x double]* %B, i64 %polly.indvar77, i64 %polly.indvar86
  %p_scevgep23.moved.to..lr.ph = getelementptr [1000 x double]* %A, i64 %polly.indvar77, i64 %polly.indvar86
  %_p_scalar_90 = load double* %p_scevgep22.moved.to..lr.ph
  %_p_scalar_91 = load double* %p_scevgep23.moved.to..lr.ph
  br i1 %polly.loop_guard, label %polly.loop_header93, label %polly.loop_exit95

polly.loop_exit95:                                ; preds = %polly.loop_header93, %polly.loop_header82
  %polly.indvar_next87 = add nsw i64 %polly.indvar86, 1
  %polly.adjust_ub88 = sub i64 %67, 1
  %polly.loop_cond89 = icmp sle i64 %polly.indvar86, %polly.adjust_ub88
  br i1 %polly.loop_cond89, label %polly.loop_header82, label %polly.loop_exit84

polly.loop_header93:                              ; preds = %polly.loop_header82, %polly.loop_header93
  %polly.indvar97 = phi i64 [ %polly.indvar_next98, %polly.loop_header93 ], [ 0, %polly.loop_header82 ]
  %p_scevgep18 = getelementptr [1200 x double]* %C, i64 %polly.indvar77, i64 %polly.indvar97
  %p_scevgep15 = getelementptr [1000 x double]* %B, i64 %polly.indvar97, i64 %polly.indvar86
  %p_scevgep = getelementptr [1000 x double]* %A, i64 %polly.indvar97, i64 %polly.indvar86
  %_p_scalar_102 = load double* %p_scevgep
  %p_103 = fmul double %_p_scalar_102, %alpha
  %p_104 = fmul double %p_103, %_p_scalar_90
  %_p_scalar_105 = load double* %p_scevgep15
  %p_106 = fmul double %_p_scalar_105, %alpha
  %p_107 = fmul double %p_106, %_p_scalar_91
  %p_108 = fadd double %p_104, %p_107
  %_p_scalar_109 = load double* %p_scevgep18
  %p_110 = fadd double %_p_scalar_109, %p_108
  store double %p_110, double* %p_scevgep18
  %p_indvar.next = add i64 %polly.indvar97, 1
  %polly.indvar_next98 = add nsw i64 %polly.indvar97, 1
  %polly.adjust_ub99 = sub i64 %6, 1
  %polly.loop_cond100 = icmp sle i64 %polly.indvar97, %polly.adjust_ub99
  br i1 %polly.loop_cond100, label %polly.loop_header93, label %polly.loop_exit95
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
