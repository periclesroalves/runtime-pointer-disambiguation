; ModuleID = './linear-algebra/blas/trmm/trmm.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [2 x i8] c"B\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %alpha = alloca double, align 8
  %0 = tail call i8* @polybench_alloc_data(i64 1000000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 1200000, i32 8) #3
  %2 = bitcast i8* %0 to [1000 x double]*
  %3 = bitcast i8* %1 to [1200 x double]*
  call void @init_array(i32 1000, i32 1200, double* %alpha, [1000 x double]* %2, [1200 x double]* %3)
  call void (...)* @polybench_timer_start() #3
  %4 = load double* %alpha, align 8, !tbaa !1
  call void @kernel_trmm(i32 1000, i32 1200, double %4, [1000 x double]* %2, [1200 x double]* %3)
  call void (...)* @polybench_timer_stop() #3
  call void (...)* @polybench_timer_print() #3
  %5 = icmp sgt i32 %argc, 42
  br i1 %5, label %6, label %10

; <label>:6                                       ; preds = %.split
  %7 = load i8** %argv, align 8, !tbaa !5
  %8 = load i8* %7, align 1, !tbaa !7
  %phitmp = icmp eq i8 %8, 0
  br i1 %phitmp, label %9, label %10

; <label>:9                                       ; preds = %6
  call void @print_array(i32 1000, i32 1200, [1200 x double]* %3)
  br label %10

; <label>:10                                      ; preds = %6, %9, %.split
  call void @free(i8* %0) #3
  call void @free(i8* %1) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %m, i32 %n, double* %alpha, [1000 x double]* noalias %A, [1200 x double]* noalias %B) #0 {
polly.split_new_and_old:
  %0 = zext i32 %m to i64
  %1 = zext i32 %n to i64
  %2 = sext i32 %m to i64
  %3 = icmp sge i64 %2, 1
  %4 = icmp sge i64 %0, 1
  %5 = and i1 %3, %4
  br i1 %5, label %polly.then, label %polly.cond26

polly.cond26:                                     ; preds = %polly.then, %polly.loop_header, %polly.split_new_and_old
  %6 = icmp sge i64 %0, 2
  %7 = and i1 %3, %6
  br i1 %7, label %polly.then28, label %polly.stmt..split

polly.stmt..split:                                ; preds = %polly.then28, %polly.loop_exit41, %polly.cond26
  store double 1.500000e+00, double* %alpha
  %8 = sext i32 %n to i64
  %9 = icmp sge i64 %8, 1
  %10 = and i1 %3, %9
  %11 = and i1 %10, %4
  %12 = icmp sge i64 %1, 1
  %13 = and i1 %11, %12
  br i1 %13, label %polly.then73, label %polly.merge72

polly.merge72:                                    ; preds = %polly.then73, %polly.loop_exit86, %polly.stmt..split
  ret void

polly.then:                                       ; preds = %polly.split_new_and_old
  %14 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %14
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond26

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_.moved.to.19 = mul i64 %polly.indvar, 1001
  %p_scevgep18.moved.to. = getelementptr [1000 x double]* %A, i64 0, i64 %p_.moved.to.19
  store double 1.000000e+00, double* %p_scevgep18.moved.to.
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %14, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond26

polly.then28:                                     ; preds = %polly.cond26
  %15 = add i64 %0, -1
  %polly.loop_guard33 = icmp sle i64 0, %15
  br i1 %polly.loop_guard33, label %polly.loop_header30, label %polly.stmt..split

polly.loop_header30:                              ; preds = %polly.then28, %polly.loop_exit41
  %polly.indvar34 = phi i64 [ %polly.indvar_next35, %polly.loop_exit41 ], [ 0, %polly.then28 ]
  %16 = mul i64 -11, %0
  %17 = add i64 %16, 9
  %18 = sub i64 %17, 32
  %19 = add i64 %18, 1
  %20 = icmp slt i64 %17, 0
  %21 = select i1 %20, i64 %19, i64 %17
  %22 = sdiv i64 %21, 32
  %23 = mul i64 -32, %22
  %24 = mul i64 -32, %0
  %25 = add i64 %23, %24
  %26 = mul i64 -32, %polly.indvar34
  %27 = mul i64 11, %polly.indvar34
  %28 = add i64 %27, -1
  %29 = sub i64 %28, 32
  %30 = add i64 %29, 1
  %31 = icmp slt i64 %28, 0
  %32 = select i1 %31, i64 %30, i64 %28
  %33 = sdiv i64 %32, 32
  %34 = mul i64 32, %33
  %35 = add i64 %26, %34
  %36 = add i64 %35, -640
  %37 = icmp sgt i64 %25, %36
  %38 = select i1 %37, i64 %25, i64 %36
  %39 = mul i64 -20, %polly.indvar34
  %40 = icmp slt i64 -20, %39
  %41 = select i1 %40, i64 -20, i64 %39
  %polly.loop_guard42 = icmp sle i64 %38, %41
  br i1 %polly.loop_guard42, label %polly.loop_header39, label %polly.loop_exit41

polly.loop_exit41:                                ; preds = %polly.loop_exit50, %polly.loop_header30
  %polly.indvar_next35 = add nsw i64 %polly.indvar34, 32
  %polly.adjust_ub36 = sub i64 %15, 32
  %polly.loop_cond37 = icmp sle i64 %polly.indvar34, %polly.adjust_ub36
  br i1 %polly.loop_cond37, label %polly.loop_header30, label %polly.stmt..split

polly.loop_header39:                              ; preds = %polly.loop_header30, %polly.loop_exit50
  %polly.indvar43 = phi i64 [ %polly.indvar_next44, %polly.loop_exit50 ], [ %38, %polly.loop_header30 ]
  %42 = mul i64 -1, %polly.indvar43
  %43 = add i64 %42, -30
  %44 = add i64 %43, 21
  %45 = sub i64 %44, 1
  %46 = icmp slt i64 %43, 0
  %47 = select i1 %46, i64 %43, i64 %45
  %48 = sdiv i64 %47, 21
  %49 = icmp sgt i64 %48, %polly.indvar34
  %50 = select i1 %49, i64 %48, i64 %polly.indvar34
  %51 = sub i64 %42, 20
  %52 = add i64 %51, 1
  %53 = icmp slt i64 %42, 0
  %54 = select i1 %53, i64 %52, i64 %42
  %55 = sdiv i64 %54, 20
  %56 = add i64 %polly.indvar34, 31
  %57 = icmp slt i64 %55, %56
  %58 = select i1 %57, i64 %55, i64 %56
  %59 = icmp slt i64 %58, %15
  %60 = select i1 %59, i64 %58, i64 %15
  %polly.loop_guard51 = icmp sle i64 %50, %60
  br i1 %polly.loop_guard51, label %polly.loop_header48, label %polly.loop_exit50

polly.loop_exit50:                                ; preds = %polly.loop_exit59, %polly.loop_header39
  %polly.indvar_next44 = add nsw i64 %polly.indvar43, 32
  %polly.adjust_ub45 = sub i64 %41, 32
  %polly.loop_cond46 = icmp sle i64 %polly.indvar43, %polly.adjust_ub45
  br i1 %polly.loop_cond46, label %polly.loop_header39, label %polly.loop_exit41

polly.loop_header48:                              ; preds = %polly.loop_header39, %polly.loop_exit59
  %polly.indvar52 = phi i64 [ %polly.indvar_next53, %polly.loop_exit59 ], [ %50, %polly.loop_header39 ]
  %61 = mul i64 -21, %polly.indvar52
  %62 = add i64 %61, 1
  %63 = icmp sgt i64 %polly.indvar43, %62
  %64 = select i1 %63, i64 %polly.indvar43, i64 %62
  %65 = mul i64 -20, %polly.indvar52
  %66 = add i64 %polly.indvar43, 31
  %67 = icmp slt i64 %65, %66
  %68 = select i1 %67, i64 %65, i64 %66
  %polly.loop_guard60 = icmp sle i64 %64, %68
  br i1 %polly.loop_guard60, label %polly.loop_header57, label %polly.loop_exit59

polly.loop_exit59:                                ; preds = %polly.loop_header57, %polly.loop_header48
  %polly.indvar_next53 = add nsw i64 %polly.indvar52, 1
  %polly.adjust_ub54 = sub i64 %60, 1
  %polly.loop_cond55 = icmp sle i64 %polly.indvar52, %polly.adjust_ub54
  br i1 %polly.loop_cond55, label %polly.loop_header48, label %polly.loop_exit50

polly.loop_header57:                              ; preds = %polly.loop_header48, %polly.loop_header57
  %polly.indvar61 = phi i64 [ %polly.indvar_next62, %polly.loop_header57 ], [ %64, %polly.loop_header48 ]
  %69 = mul i64 -1, %polly.indvar61
  %70 = add i64 %65, %69
  %p_.moved.to. = sitofp i32 %m to double
  %p_ = add i64 %polly.indvar52, %70
  %p_66 = trunc i64 %p_ to i32
  %p_scevgep = getelementptr [1000 x double]* %A, i64 %polly.indvar52, i64 %70
  %p_67 = srem i32 %p_66, %m
  %p_68 = sitofp i32 %p_67 to double
  %p_69 = fdiv double %p_68, %p_.moved.to.
  store double %p_69, double* %p_scevgep
  %p_indvar.next = add i64 %70, 1
  %polly.indvar_next62 = add nsw i64 %polly.indvar61, 1
  %polly.adjust_ub63 = sub i64 %68, 1
  %polly.loop_cond64 = icmp sle i64 %polly.indvar61, %polly.adjust_ub63
  br i1 %polly.loop_cond64, label %polly.loop_header57, label %polly.loop_exit59

polly.then73:                                     ; preds = %polly.stmt..split
  %71 = add i64 %0, -1
  %polly.loop_guard78 = icmp sle i64 0, %71
  br i1 %polly.loop_guard78, label %polly.loop_header75, label %polly.merge72

polly.loop_header75:                              ; preds = %polly.then73, %polly.loop_exit86
  %polly.indvar79 = phi i64 [ %polly.indvar_next80, %polly.loop_exit86 ], [ 0, %polly.then73 ]
  %72 = mul i64 -3, %0
  %73 = add i64 %72, %1
  %74 = add i64 %73, 5
  %75 = sub i64 %74, 32
  %76 = add i64 %75, 1
  %77 = icmp slt i64 %74, 0
  %78 = select i1 %77, i64 %76, i64 %74
  %79 = sdiv i64 %78, 32
  %80 = mul i64 -32, %79
  %81 = mul i64 -32, %0
  %82 = add i64 %80, %81
  %83 = mul i64 -32, %polly.indvar79
  %84 = mul i64 -3, %polly.indvar79
  %85 = add i64 %84, %1
  %86 = add i64 %85, 5
  %87 = sub i64 %86, 32
  %88 = add i64 %87, 1
  %89 = icmp slt i64 %86, 0
  %90 = select i1 %89, i64 %88, i64 %86
  %91 = sdiv i64 %90, 32
  %92 = mul i64 -32, %91
  %93 = add i64 %83, %92
  %94 = add i64 %93, -640
  %95 = icmp sgt i64 %82, %94
  %96 = select i1 %95, i64 %82, i64 %94
  %97 = mul i64 -20, %polly.indvar79
  %polly.loop_guard87 = icmp sle i64 %96, %97
  br i1 %polly.loop_guard87, label %polly.loop_header84, label %polly.loop_exit86

polly.loop_exit86:                                ; preds = %polly.loop_exit95, %polly.loop_header75
  %polly.indvar_next80 = add nsw i64 %polly.indvar79, 32
  %polly.adjust_ub81 = sub i64 %71, 32
  %polly.loop_cond82 = icmp sle i64 %polly.indvar79, %polly.adjust_ub81
  br i1 %polly.loop_cond82, label %polly.loop_header75, label %polly.merge72

polly.loop_header84:                              ; preds = %polly.loop_header75, %polly.loop_exit95
  %polly.indvar88 = phi i64 [ %polly.indvar_next89, %polly.loop_exit95 ], [ %96, %polly.loop_header75 ]
  %98 = mul i64 -1, %polly.indvar88
  %99 = mul i64 -1, %1
  %100 = add i64 %98, %99
  %101 = add i64 %100, -30
  %102 = add i64 %101, 20
  %103 = sub i64 %102, 1
  %104 = icmp slt i64 %101, 0
  %105 = select i1 %104, i64 %101, i64 %103
  %106 = sdiv i64 %105, 20
  %107 = icmp sgt i64 %106, %polly.indvar79
  %108 = select i1 %107, i64 %106, i64 %polly.indvar79
  %109 = sub i64 %98, 20
  %110 = add i64 %109, 1
  %111 = icmp slt i64 %98, 0
  %112 = select i1 %111, i64 %110, i64 %98
  %113 = sdiv i64 %112, 20
  %114 = add i64 %polly.indvar79, 31
  %115 = icmp slt i64 %113, %114
  %116 = select i1 %115, i64 %113, i64 %114
  %117 = icmp slt i64 %116, %71
  %118 = select i1 %117, i64 %116, i64 %71
  %polly.loop_guard96 = icmp sle i64 %108, %118
  br i1 %polly.loop_guard96, label %polly.loop_header93, label %polly.loop_exit95

polly.loop_exit95:                                ; preds = %polly.loop_exit104, %polly.loop_header84
  %polly.indvar_next89 = add nsw i64 %polly.indvar88, 32
  %polly.adjust_ub90 = sub i64 %97, 32
  %polly.loop_cond91 = icmp sle i64 %polly.indvar88, %polly.adjust_ub90
  br i1 %polly.loop_cond91, label %polly.loop_header84, label %polly.loop_exit86

polly.loop_header93:                              ; preds = %polly.loop_header84, %polly.loop_exit104
  %polly.indvar97 = phi i64 [ %polly.indvar_next98, %polly.loop_exit104 ], [ %108, %polly.loop_header84 ]
  %119 = mul i64 -20, %polly.indvar97
  %120 = add i64 %119, %99
  %121 = add i64 %120, 1
  %122 = icmp sgt i64 %polly.indvar88, %121
  %123 = select i1 %122, i64 %polly.indvar88, i64 %121
  %124 = add i64 %polly.indvar88, 31
  %125 = icmp slt i64 %119, %124
  %126 = select i1 %125, i64 %119, i64 %124
  %polly.loop_guard105 = icmp sle i64 %123, %126
  br i1 %polly.loop_guard105, label %polly.loop_header102, label %polly.loop_exit104

polly.loop_exit104:                               ; preds = %polly.loop_header102, %polly.loop_header93
  %polly.indvar_next98 = add nsw i64 %polly.indvar97, 1
  %polly.adjust_ub99 = sub i64 %118, 1
  %polly.loop_cond100 = icmp sle i64 %polly.indvar97, %polly.adjust_ub99
  br i1 %polly.loop_cond100, label %polly.loop_header93, label %polly.loop_exit95

polly.loop_header102:                             ; preds = %polly.loop_header93, %polly.loop_header102
  %polly.indvar106 = phi i64 [ %polly.indvar_next107, %polly.loop_header102 ], [ %123, %polly.loop_header93 ]
  %127 = mul i64 -1, %polly.indvar106
  %128 = add i64 %119, %127
  %p_.moved.to.22 = add i64 %1, %polly.indvar97
  %p_.moved.to.23 = sitofp i32 %n to double
  %p_scevgep14 = getelementptr [1200 x double]* %B, i64 %polly.indvar97, i64 %128
  %p_111 = mul i64 %128, -1
  %p_112 = add i64 %p_.moved.to.22, %p_111
  %p_113 = trunc i64 %p_112 to i32
  %p_114 = srem i32 %p_113, %n
  %p_115 = sitofp i32 %p_114 to double
  %p_116 = fdiv double %p_115, %p_.moved.to.23
  store double %p_116, double* %p_scevgep14
  %p_indvar.next12 = add i64 %128, 1
  %polly.indvar_next107 = add nsw i64 %polly.indvar106, 1
  %polly.adjust_ub108 = sub i64 %126, 1
  %polly.loop_cond109 = icmp sle i64 %polly.indvar106, %polly.adjust_ub108
  br i1 %polly.loop_cond109, label %polly.loop_header102, label %polly.loop_exit104
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_trmm(i32 %m, i32 %n, double %alpha, [1000 x double]* noalias %A, [1200 x double]* noalias %B) #0 {
.split:
  %0 = icmp sgt i32 %m, 0
  br i1 %0, label %.preheader1.lr.ph, label %._crit_edge8

.preheader1.lr.ph:                                ; preds = %.split
  %1 = add i32 %m, -2
  %2 = zext i32 %n to i64
  %3 = zext i32 %m to i64
  %4 = zext i32 %1 to i64
  %5 = icmp sgt i32 %n, 0
  br label %.preheader1

.preheader1:                                      ; preds = %.preheader1.lr.ph, %polly.merge
  %indvar9 = phi i64 [ 0, %.preheader1.lr.ph ], [ %12, %polly.merge ]
  %6 = trunc i64 %indvar9 to i32
  %7 = mul i64 %indvar9, -1
  %8 = add i64 %4, %7
  %9 = trunc i64 %8 to i32
  %10 = zext i32 %9 to i64
  %11 = mul i64 %indvar9, 9600
  %12 = add i64 %indvar9, 1
  %k.02 = trunc i64 %12 to i32
  %13 = mul i64 %indvar9, 1001
  %14 = add i64 %10, 1
  br i1 %5, label %.preheader.lr.ph, label %polly.merge

.preheader.lr.ph:                                 ; preds = %.preheader1
  %15 = srem i64 %11, 8
  %16 = icmp eq i64 %15, 0
  %17 = icmp sge i64 %2, 1
  %or.cond = and i1 %16, %17
  br i1 %or.cond, label %polly.cond25, label %polly.merge

polly.merge:                                      ; preds = %polly.merge26, %polly.loop_header43, %.preheader.lr.ph, %.preheader1
  %exitcond17 = icmp ne i64 %12, %3
  br i1 %exitcond17, label %.preheader1, label %._crit_edge8

._crit_edge8:                                     ; preds = %polly.merge, %.split
  ret void

polly.cond25:                                     ; preds = %.preheader.lr.ph
  %18 = sext i32 %6 to i64
  %19 = sext i32 %m to i64
  %20 = add i64 %19, -2
  %21 = icmp sle i64 %18, %20
  br i1 %21, label %polly.then27, label %polly.merge26

polly.merge26:                                    ; preds = %polly.then27, %polly.loop_exit31, %polly.cond25
  %22 = add i64 %2, -1
  %polly.loop_guard46 = icmp sle i64 0, %22
  br i1 %polly.loop_guard46, label %polly.loop_header43, label %polly.merge

polly.then27:                                     ; preds = %polly.cond25
  %23 = mul i64 1200, %10
  %24 = add i64 %2, %23
  %25 = add i64 %24, -1
  %polly.loop_guard = icmp sle i64 0, %25
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge26

polly.loop_header:                                ; preds = %polly.then27, %polly.loop_exit31
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit31 ], [ 0, %polly.then27 ]
  %26 = mul i64 -1, %2
  %27 = add i64 %polly.indvar, %26
  %28 = add i64 %27, 1
  %29 = add i64 %28, 1200
  %30 = sub i64 %29, 1
  %31 = icmp slt i64 %28, 0
  %32 = select i1 %31, i64 %28, i64 %30
  %33 = sdiv i64 %32, 1200
  %34 = icmp sgt i64 0, %33
  %35 = select i1 %34, i64 0, i64 %33
  %36 = sub i64 %polly.indvar, 1200
  %37 = add i64 %36, 1
  %38 = icmp slt i64 %polly.indvar, 0
  %39 = select i1 %38, i64 %37, i64 %polly.indvar
  %40 = sdiv i64 %39, 1200
  %41 = icmp slt i64 %40, %10
  %42 = select i1 %41, i64 %40, i64 %10
  %polly.loop_guard32 = icmp sle i64 %35, %42
  br i1 %polly.loop_guard32, label %polly.loop_header29, label %polly.loop_exit31

polly.loop_exit31:                                ; preds = %polly.loop_header29, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %25, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge26

polly.loop_header29:                              ; preds = %polly.loop_header, %polly.loop_header29
  %polly.indvar33 = phi i64 [ %polly.indvar_next34, %polly.loop_header29 ], [ %35, %polly.loop_header ]
  %43 = mul i64 -1200, %polly.indvar33
  %44 = add i64 %polly.indvar, %43
  %p_scevgep16.moved.to. = getelementptr [1200 x double]* %B, i64 %indvar9, i64 %44
  %p_ = add i64 %12, %polly.indvar33
  %p_scevgep = getelementptr [1200 x double]* %B, i64 %p_, i64 %44
  %p_37 = add i64 %polly.indvar33, 1
  %p_scevgep13 = getelementptr [1000 x double]* %A, i64 %p_37, i64 %13
  %_p_scalar_ = load double* %p_scevgep13
  %_p_scalar_38 = load double* %p_scevgep
  %p_39 = fmul double %_p_scalar_, %_p_scalar_38
  %_p_scalar_40 = load double* %p_scevgep16.moved.to.
  %p_41 = fadd double %_p_scalar_40, %p_39
  store double %p_41, double* %p_scevgep16.moved.to.
  %polly.indvar_next34 = add nsw i64 %polly.indvar33, 1
  %polly.adjust_ub35 = sub i64 %42, 1
  %polly.loop_cond36 = icmp sle i64 %polly.indvar33, %polly.adjust_ub35
  br i1 %polly.loop_cond36, label %polly.loop_header29, label %polly.loop_exit31

polly.loop_header43:                              ; preds = %polly.merge26, %polly.loop_header43
  %polly.indvar47 = phi i64 [ %polly.indvar_next48, %polly.loop_header43 ], [ 0, %polly.merge26 ]
  %p_scevgep16.moved.to.21 = getelementptr [1200 x double]* %B, i64 %indvar9, i64 %polly.indvar47
  %_p_scalar_52 = load double* %p_scevgep16.moved.to.21
  %p_53 = fmul double %_p_scalar_52, %alpha
  store double %p_53, double* %p_scevgep16.moved.to.21
  %p_indvar.next12 = add i64 %polly.indvar47, 1
  %polly.indvar_next48 = add nsw i64 %polly.indvar47, 1
  %polly.adjust_ub49 = sub i64 %22, 1
  %polly.loop_cond50 = icmp sle i64 %polly.indvar47, %polly.adjust_ub49
  br i1 %polly.loop_cond50, label %polly.loop_header43, label %polly.merge
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %m, i32 %n, [1200 x double]* noalias %B) #0 {
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
  %scevgep = getelementptr [1200 x double]* %B, i64 %indvar4, i64 %indvar
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
