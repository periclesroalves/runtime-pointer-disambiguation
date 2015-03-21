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
define internal void @init_array(i32 %n, [1300 x double]* noalias %A, [1300 x double]* noalias %B) #0 {
polly.split_new_and_old:
  %0 = zext i32 %n to i64
  %1 = sext i32 %n to i64
  %2 = icmp sge i64 %1, 1
  %3 = icmp sge i64 %0, 1
  %4 = and i1 %2, %3
  br i1 %4, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit18, %polly.split_new_and_old
  ret void

polly.then:                                       ; preds = %polly.split_new_and_old
  %5 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %5
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit18
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit18 ], [ 0, %polly.then ]
  %6 = mul i64 -11, %0
  %7 = add i64 %6, 5
  %8 = sub i64 %7, 32
  %9 = add i64 %8, 1
  %10 = icmp slt i64 %7, 0
  %11 = select i1 %10, i64 %9, i64 %7
  %12 = sdiv i64 %11, 32
  %13 = mul i64 -32, %12
  %14 = mul i64 -32, %0
  %15 = add i64 %13, %14
  %16 = mul i64 -32, %polly.indvar
  %17 = mul i64 -3, %polly.indvar
  %18 = add i64 %17, %0
  %19 = add i64 %18, 5
  %20 = sub i64 %19, 32
  %21 = add i64 %20, 1
  %22 = icmp slt i64 %19, 0
  %23 = select i1 %22, i64 %21, i64 %19
  %24 = sdiv i64 %23, 32
  %25 = mul i64 -32, %24
  %26 = add i64 %16, %25
  %27 = add i64 %26, -640
  %28 = icmp sgt i64 %15, %27
  %29 = select i1 %28, i64 %15, i64 %27
  %30 = mul i64 -20, %polly.indvar
  %polly.loop_guard19 = icmp sle i64 %29, %30
  br i1 %polly.loop_guard19, label %polly.loop_header16, label %polly.loop_exit18

polly.loop_exit18:                                ; preds = %polly.loop_exit27, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %5, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header16:                              ; preds = %polly.loop_header, %polly.loop_exit27
  %polly.indvar20 = phi i64 [ %polly.indvar_next21, %polly.loop_exit27 ], [ %29, %polly.loop_header ]
  %31 = mul i64 -1, %polly.indvar20
  %32 = mul i64 -1, %0
  %33 = add i64 %31, %32
  %34 = add i64 %33, -30
  %35 = add i64 %34, 20
  %36 = sub i64 %35, 1
  %37 = icmp slt i64 %34, 0
  %38 = select i1 %37, i64 %34, i64 %36
  %39 = sdiv i64 %38, 20
  %40 = icmp sgt i64 %39, %polly.indvar
  %41 = select i1 %40, i64 %39, i64 %polly.indvar
  %42 = sub i64 %31, 20
  %43 = add i64 %42, 1
  %44 = icmp slt i64 %31, 0
  %45 = select i1 %44, i64 %43, i64 %31
  %46 = sdiv i64 %45, 20
  %47 = add i64 %polly.indvar, 31
  %48 = icmp slt i64 %46, %47
  %49 = select i1 %48, i64 %46, i64 %47
  %50 = icmp slt i64 %49, %5
  %51 = select i1 %50, i64 %49, i64 %5
  %polly.loop_guard28 = icmp sle i64 %41, %51
  br i1 %polly.loop_guard28, label %polly.loop_header25, label %polly.loop_exit27

polly.loop_exit27:                                ; preds = %polly.loop_exit36, %polly.loop_header16
  %polly.indvar_next21 = add nsw i64 %polly.indvar20, 32
  %polly.adjust_ub22 = sub i64 %30, 32
  %polly.loop_cond23 = icmp sle i64 %polly.indvar20, %polly.adjust_ub22
  br i1 %polly.loop_cond23, label %polly.loop_header16, label %polly.loop_exit18

polly.loop_header25:                              ; preds = %polly.loop_header16, %polly.loop_exit36
  %polly.indvar29 = phi i64 [ %polly.indvar_next30, %polly.loop_exit36 ], [ %41, %polly.loop_header16 ]
  %52 = mul i64 -20, %polly.indvar29
  %53 = add i64 %52, %32
  %54 = add i64 %53, 1
  %55 = icmp sgt i64 %polly.indvar20, %54
  %56 = select i1 %55, i64 %polly.indvar20, i64 %54
  %57 = add i64 %polly.indvar20, 31
  %58 = icmp slt i64 %52, %57
  %59 = select i1 %58, i64 %52, i64 %57
  %polly.loop_guard37 = icmp sle i64 %56, %59
  br i1 %polly.loop_guard37, label %polly.loop_header34, label %polly.loop_exit36

polly.loop_exit36:                                ; preds = %polly.loop_header34, %polly.loop_header25
  %polly.indvar_next30 = add nsw i64 %polly.indvar29, 1
  %polly.adjust_ub31 = sub i64 %51, 1
  %polly.loop_cond32 = icmp sle i64 %polly.indvar29, %polly.adjust_ub31
  br i1 %polly.loop_cond32, label %polly.loop_header25, label %polly.loop_exit27

polly.loop_header34:                              ; preds = %polly.loop_header25, %polly.loop_header34
  %polly.indvar38 = phi i64 [ %polly.indvar_next39, %polly.loop_header34 ], [ %56, %polly.loop_header25 ]
  %60 = mul i64 -1, %polly.indvar38
  %61 = add i64 %52, %60
  %p_i.02.moved.to. = trunc i64 %polly.indvar29 to i32
  %p_.moved.to. = sitofp i32 %p_i.02.moved.to. to double
  %p_.moved.to.10 = sitofp i32 %n to double
  %p_scevgep6 = getelementptr [1300 x double]* %B, i64 %polly.indvar29, i64 %61
  %p_scevgep = getelementptr [1300 x double]* %A, i64 %polly.indvar29, i64 %61
  %p_ = add i64 %61, 2
  %p_42 = trunc i64 %p_ to i32
  %p_43 = add i64 %61, 3
  %p_44 = trunc i64 %p_43 to i32
  %p_45 = sitofp i32 %p_42 to double
  %p_46 = fmul double %p_.moved.to., %p_45
  %p_47 = fadd double %p_46, 2.000000e+00
  %p_48 = fdiv double %p_47, %p_.moved.to.10
  store double %p_48, double* %p_scevgep
  %p_49 = sitofp i32 %p_44 to double
  %p_50 = fmul double %p_.moved.to., %p_49
  %p_51 = fadd double %p_50, 3.000000e+00
  %p_52 = fdiv double %p_51, %p_.moved.to.10
  store double %p_52, double* %p_scevgep6
  %p_indvar.next = add i64 %61, 1
  %polly.indvar_next39 = add nsw i64 %polly.indvar38, 1
  %polly.adjust_ub40 = sub i64 %59, 1
  %polly.loop_cond41 = icmp sle i64 %polly.indvar38, %polly.adjust_ub40
  br i1 %polly.loop_cond41, label %polly.loop_header34, label %polly.loop_exit36
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_jacobi_2d(i32 %tsteps, i32 %n, [1300 x double]* noalias %A, [1300 x double]* noalias %B) #0 {
polly.split_new_and_old:
  %0 = add i32 %n, -3
  %1 = zext i32 %0 to i64
  %2 = sext i32 %n to i64
  %3 = icmp sge i64 %2, 3
  %4 = sext i32 %tsteps to i64
  %5 = icmp sge i64 %4, 1
  %6 = and i1 %3, %5
  br i1 %6, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit116, %polly.split_new_and_old
  ret void

polly.then:                                       ; preds = %polly.split_new_and_old
  %7 = add i64 %4, -1
  %polly.loop_guard = icmp sle i64 0, %7
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit116
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit116 ], [ 0, %polly.then ]
  br i1 true, label %polly.loop_header68, label %polly.loop_exit70

polly.loop_exit70:                                ; preds = %polly.loop_exit79, %polly.loop_header
  br i1 true, label %polly.loop_header114, label %polly.loop_exit116

polly.loop_exit116:                               ; preds = %polly.loop_exit125, %polly.loop_exit70
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %7, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header68:                              ; preds = %polly.loop_header, %polly.loop_exit79
  %polly.indvar72 = phi i64 [ %polly.indvar_next73, %polly.loop_exit79 ], [ 0, %polly.loop_header ]
  %8 = mul i64 -32, %polly.indvar72
  %9 = mul i64 -3, %polly.indvar72
  %10 = add i64 %9, %1
  %11 = add i64 %10, 11
  %12 = sub i64 %11, 32
  %13 = add i64 %12, 1
  %14 = icmp slt i64 %11, 0
  %15 = select i1 %14, i64 %13, i64 %11
  %16 = sdiv i64 %15, 32
  %17 = mul i64 -32, %16
  %18 = add i64 %8, %17
  %19 = add i64 %18, -640
  %20 = mul i64 -11, %1
  %21 = add i64 %20, -1
  %22 = sub i64 %21, 32
  %23 = add i64 %22, 1
  %24 = icmp slt i64 %21, 0
  %25 = select i1 %24, i64 %23, i64 %21
  %26 = sdiv i64 %25, 32
  %27 = mul i64 -32, %26
  %28 = mul i64 -32, %1
  %29 = add i64 %27, %28
  %30 = add i64 %29, -32
  %31 = icmp sgt i64 %19, %30
  %32 = select i1 %31, i64 %19, i64 %30
  %33 = mul i64 -20, %polly.indvar72
  %polly.loop_guard80 = icmp sle i64 %32, %33
  br i1 %polly.loop_guard80, label %polly.loop_header77, label %polly.loop_exit79

polly.loop_exit79:                                ; preds = %polly.loop_exit88, %polly.loop_header68
  %polly.indvar_next73 = add nsw i64 %polly.indvar72, 32
  %polly.adjust_ub74 = sub i64 %1, 32
  %polly.loop_cond75 = icmp sle i64 %polly.indvar72, %polly.adjust_ub74
  br i1 %polly.loop_cond75, label %polly.loop_header68, label %polly.loop_exit70

polly.loop_header77:                              ; preds = %polly.loop_header68, %polly.loop_exit88
  %polly.indvar81 = phi i64 [ %polly.indvar_next82, %polly.loop_exit88 ], [ %32, %polly.loop_header68 ]
  %34 = mul i64 -1, %polly.indvar81
  %35 = mul i64 -1, %1
  %36 = add i64 %34, %35
  %37 = add i64 %36, -31
  %38 = add i64 %37, 20
  %39 = sub i64 %38, 1
  %40 = icmp slt i64 %37, 0
  %41 = select i1 %40, i64 %37, i64 %39
  %42 = sdiv i64 %41, 20
  %43 = icmp sgt i64 %42, %polly.indvar72
  %44 = select i1 %43, i64 %42, i64 %polly.indvar72
  %45 = sub i64 %34, 20
  %46 = add i64 %45, 1
  %47 = icmp slt i64 %34, 0
  %48 = select i1 %47, i64 %46, i64 %34
  %49 = sdiv i64 %48, 20
  %50 = icmp slt i64 %49, %1
  %51 = select i1 %50, i64 %49, i64 %1
  %52 = add i64 %polly.indvar72, 31
  %53 = icmp slt i64 %51, %52
  %54 = select i1 %53, i64 %51, i64 %52
  %polly.loop_guard89 = icmp sle i64 %44, %54
  br i1 %polly.loop_guard89, label %polly.loop_header86, label %polly.loop_exit88

polly.loop_exit88:                                ; preds = %polly.loop_exit97, %polly.loop_header77
  %polly.indvar_next82 = add nsw i64 %polly.indvar81, 32
  %polly.adjust_ub83 = sub i64 %33, 32
  %polly.loop_cond84 = icmp sle i64 %polly.indvar81, %polly.adjust_ub83
  br i1 %polly.loop_cond84, label %polly.loop_header77, label %polly.loop_exit79

polly.loop_header86:                              ; preds = %polly.loop_header77, %polly.loop_exit97
  %polly.indvar90 = phi i64 [ %polly.indvar_next91, %polly.loop_exit97 ], [ %44, %polly.loop_header77 ]
  %55 = mul i64 -20, %polly.indvar90
  %56 = add i64 %55, %35
  %57 = icmp sgt i64 %polly.indvar81, %56
  %58 = select i1 %57, i64 %polly.indvar81, i64 %56
  %59 = add i64 %polly.indvar81, 31
  %60 = icmp slt i64 %55, %59
  %61 = select i1 %60, i64 %55, i64 %59
  %polly.loop_guard98 = icmp sle i64 %58, %61
  br i1 %polly.loop_guard98, label %polly.loop_header95, label %polly.loop_exit97

polly.loop_exit97:                                ; preds = %polly.loop_header95, %polly.loop_header86
  %polly.indvar_next91 = add nsw i64 %polly.indvar90, 1
  %polly.adjust_ub92 = sub i64 %54, 1
  %polly.loop_cond93 = icmp sle i64 %polly.indvar90, %polly.adjust_ub92
  br i1 %polly.loop_cond93, label %polly.loop_header86, label %polly.loop_exit88

polly.loop_header95:                              ; preds = %polly.loop_header86, %polly.loop_header95
  %polly.indvar99 = phi i64 [ %polly.indvar_next100, %polly.loop_header95 ], [ %58, %polly.loop_header86 ]
  %62 = mul i64 -1, %polly.indvar99
  %63 = add i64 %55, %62
  %p_.moved.to. = add i64 %polly.indvar90, 1
  %p_.moved.to.50 = add i64 %polly.indvar90, 2
  %p_.moved.to.53 = add i64 %1, 1
  %p_ = add i64 %63, 1
  %p_scevgep18 = getelementptr [1300 x double]* %A, i64 %polly.indvar90, i64 %p_
  %p_scevgep17 = getelementptr [1300 x double]* %A, i64 %p_.moved.to.50, i64 %p_
  %p_103 = add i64 %63, 2
  %p_scevgep21 = getelementptr [1300 x double]* %A, i64 %p_.moved.to., i64 %p_103
  %p_scevgep20 = getelementptr [1300 x double]* %A, i64 %p_.moved.to., i64 %63
  %p_scevgep19 = getelementptr [1300 x double]* %B, i64 %p_.moved.to., i64 %p_
  %p_scevgep = getelementptr [1300 x double]* %A, i64 %p_.moved.to., i64 %p_
  %_p_scalar_ = load double* %p_scevgep
  %_p_scalar_104 = load double* %p_scevgep20
  %p_105 = fadd double %_p_scalar_, %_p_scalar_104
  %_p_scalar_106 = load double* %p_scevgep21
  %p_107 = fadd double %p_105, %_p_scalar_106
  %_p_scalar_108 = load double* %p_scevgep17
  %p_109 = fadd double %p_107, %_p_scalar_108
  %_p_scalar_110 = load double* %p_scevgep18
  %p_111 = fadd double %p_109, %_p_scalar_110
  %p_112 = fmul double %p_111, 2.000000e-01
  store double %p_112, double* %p_scevgep19
  %polly.indvar_next100 = add nsw i64 %polly.indvar99, 1
  %polly.adjust_ub101 = sub i64 %61, 1
  %polly.loop_cond102 = icmp sle i64 %polly.indvar99, %polly.adjust_ub101
  br i1 %polly.loop_cond102, label %polly.loop_header95, label %polly.loop_exit97

polly.loop_header114:                             ; preds = %polly.loop_exit70, %polly.loop_exit125
  %polly.indvar118 = phi i64 [ %polly.indvar_next119, %polly.loop_exit125 ], [ 0, %polly.loop_exit70 ]
  %64 = mul i64 -32, %polly.indvar118
  %65 = mul i64 -3, %polly.indvar118
  %66 = add i64 %65, %1
  %67 = add i64 %66, 11
  %68 = sub i64 %67, 32
  %69 = add i64 %68, 1
  %70 = icmp slt i64 %67, 0
  %71 = select i1 %70, i64 %69, i64 %67
  %72 = sdiv i64 %71, 32
  %73 = mul i64 -32, %72
  %74 = add i64 %64, %73
  %75 = add i64 %74, -640
  %76 = mul i64 -11, %1
  %77 = add i64 %76, -1
  %78 = sub i64 %77, 32
  %79 = add i64 %78, 1
  %80 = icmp slt i64 %77, 0
  %81 = select i1 %80, i64 %79, i64 %77
  %82 = sdiv i64 %81, 32
  %83 = mul i64 -32, %82
  %84 = mul i64 -32, %1
  %85 = add i64 %83, %84
  %86 = add i64 %85, -32
  %87 = icmp sgt i64 %75, %86
  %88 = select i1 %87, i64 %75, i64 %86
  %89 = mul i64 -20, %polly.indvar118
  %polly.loop_guard126 = icmp sle i64 %88, %89
  br i1 %polly.loop_guard126, label %polly.loop_header123, label %polly.loop_exit125

polly.loop_exit125:                               ; preds = %polly.loop_exit134, %polly.loop_header114
  %polly.indvar_next119 = add nsw i64 %polly.indvar118, 32
  %polly.adjust_ub120 = sub i64 %1, 32
  %polly.loop_cond121 = icmp sle i64 %polly.indvar118, %polly.adjust_ub120
  br i1 %polly.loop_cond121, label %polly.loop_header114, label %polly.loop_exit116

polly.loop_header123:                             ; preds = %polly.loop_header114, %polly.loop_exit134
  %polly.indvar127 = phi i64 [ %polly.indvar_next128, %polly.loop_exit134 ], [ %88, %polly.loop_header114 ]
  %90 = mul i64 -1, %polly.indvar127
  %91 = mul i64 -1, %1
  %92 = add i64 %90, %91
  %93 = add i64 %92, -31
  %94 = add i64 %93, 20
  %95 = sub i64 %94, 1
  %96 = icmp slt i64 %93, 0
  %97 = select i1 %96, i64 %93, i64 %95
  %98 = sdiv i64 %97, 20
  %99 = icmp sgt i64 %98, %polly.indvar118
  %100 = select i1 %99, i64 %98, i64 %polly.indvar118
  %101 = sub i64 %90, 20
  %102 = add i64 %101, 1
  %103 = icmp slt i64 %90, 0
  %104 = select i1 %103, i64 %102, i64 %90
  %105 = sdiv i64 %104, 20
  %106 = icmp slt i64 %105, %1
  %107 = select i1 %106, i64 %105, i64 %1
  %108 = add i64 %polly.indvar118, 31
  %109 = icmp slt i64 %107, %108
  %110 = select i1 %109, i64 %107, i64 %108
  %polly.loop_guard135 = icmp sle i64 %100, %110
  br i1 %polly.loop_guard135, label %polly.loop_header132, label %polly.loop_exit134

polly.loop_exit134:                               ; preds = %polly.loop_exit143, %polly.loop_header123
  %polly.indvar_next128 = add nsw i64 %polly.indvar127, 32
  %polly.adjust_ub129 = sub i64 %89, 32
  %polly.loop_cond130 = icmp sle i64 %polly.indvar127, %polly.adjust_ub129
  br i1 %polly.loop_cond130, label %polly.loop_header123, label %polly.loop_exit125

polly.loop_header132:                             ; preds = %polly.loop_header123, %polly.loop_exit143
  %polly.indvar136 = phi i64 [ %polly.indvar_next137, %polly.loop_exit143 ], [ %100, %polly.loop_header123 ]
  %111 = mul i64 -20, %polly.indvar136
  %112 = add i64 %111, %91
  %113 = icmp sgt i64 %polly.indvar127, %112
  %114 = select i1 %113, i64 %polly.indvar127, i64 %112
  %115 = add i64 %polly.indvar127, 31
  %116 = icmp slt i64 %111, %115
  %117 = select i1 %116, i64 %111, i64 %115
  %polly.loop_guard144 = icmp sle i64 %114, %117
  br i1 %polly.loop_guard144, label %polly.loop_header141, label %polly.loop_exit143

polly.loop_exit143:                               ; preds = %polly.loop_header141, %polly.loop_header132
  %polly.indvar_next137 = add nsw i64 %polly.indvar136, 1
  %polly.adjust_ub138 = sub i64 %110, 1
  %polly.loop_cond139 = icmp sle i64 %polly.indvar136, %polly.adjust_ub138
  br i1 %polly.loop_cond139, label %polly.loop_header132, label %polly.loop_exit134

polly.loop_header141:                             ; preds = %polly.loop_header132, %polly.loop_header141
  %polly.indvar145 = phi i64 [ %polly.indvar_next146, %polly.loop_header141 ], [ %114, %polly.loop_header132 ]
  %118 = mul i64 -1, %polly.indvar145
  %119 = add i64 %111, %118
  %p_.moved.to.59 = add i64 %polly.indvar136, 1
  %p_.moved.to.60 = add i64 %polly.indvar136, 2
  %p_.moved.to.63 = add i64 %1, 1
  %p_150 = add i64 %119, 1
  %p_scevgep36 = getelementptr [1300 x double]* %B, i64 %polly.indvar136, i64 %p_150
  %p_scevgep35 = getelementptr [1300 x double]* %B, i64 %p_.moved.to.60, i64 %p_150
  %p_151 = add i64 %119, 2
  %p_scevgep39 = getelementptr [1300 x double]* %B, i64 %p_.moved.to.59, i64 %p_151
  %p_scevgep38 = getelementptr [1300 x double]* %B, i64 %p_.moved.to.59, i64 %119
  %p_scevgep37 = getelementptr [1300 x double]* %A, i64 %p_.moved.to.59, i64 %p_150
  %p_scevgep34 = getelementptr [1300 x double]* %B, i64 %p_.moved.to.59, i64 %p_150
  %_p_scalar_152 = load double* %p_scevgep34
  %_p_scalar_153 = load double* %p_scevgep38
  %p_154 = fadd double %_p_scalar_152, %_p_scalar_153
  %_p_scalar_155 = load double* %p_scevgep39
  %p_156 = fadd double %p_154, %_p_scalar_155
  %_p_scalar_157 = load double* %p_scevgep35
  %p_158 = fadd double %p_156, %_p_scalar_157
  %_p_scalar_159 = load double* %p_scevgep36
  %p_160 = fadd double %p_158, %_p_scalar_159
  %p_161 = fmul double %p_160, 2.000000e-01
  store double %p_161, double* %p_scevgep37
  %polly.indvar_next146 = add nsw i64 %polly.indvar145, 1
  %polly.adjust_ub147 = sub i64 %117, 1
  %polly.loop_cond148 = icmp sle i64 %polly.indvar145, %polly.adjust_ub147
  br i1 %polly.loop_cond148, label %polly.loop_header141, label %polly.loop_exit143
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, [1300 x double]* noalias %A) #0 {
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
