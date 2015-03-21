; ModuleID = './linear-algebra/kernels/bicg/bicg.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [2 x i8] c"s\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [2 x i8] c"q\00", align 1
@.str8 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %0 = tail call i8* @polybench_alloc_data(i64 3990000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 1900, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 2100, i32 8) #3
  %3 = tail call i8* @polybench_alloc_data(i64 1900, i32 8) #3
  %4 = tail call i8* @polybench_alloc_data(i64 2100, i32 8) #3
  %5 = bitcast i8* %0 to [1900 x double]*
  %6 = bitcast i8* %4 to double*
  %7 = bitcast i8* %3 to double*
  tail call void @init_array(i32 1900, i32 2100, [1900 x double]* %5, double* %6, double* %7)
  tail call void (...)* @polybench_timer_start() #3
  %8 = bitcast i8* %1 to double*
  %9 = bitcast i8* %2 to double*
  tail call void @kernel_bicg(i32 1900, i32 2100, [1900 x double]* %5, double* %8, double* %9, double* %7, double* %6)
  tail call void (...)* @polybench_timer_stop() #3
  tail call void (...)* @polybench_timer_print() #3
  %10 = icmp sgt i32 %argc, 42
  br i1 %10, label %11, label %15

; <label>:11                                      ; preds = %.split
  %12 = load i8** %argv, align 8, !tbaa !1
  %13 = load i8* %12, align 1, !tbaa !5
  %phitmp = icmp eq i8 %13, 0
  br i1 %phitmp, label %14, label %15

; <label>:14                                      ; preds = %11
  tail call void @print_array(i32 1900, i32 2100, double* %8, double* %9)
  br label %15

; <label>:15                                      ; preds = %11, %14, %.split
  tail call void @free(i8* %0) #3
  tail call void @free(i8* %1) #3
  tail call void @free(i8* %2) #3
  tail call void @free(i8* %3) #3
  tail call void @free(i8* %4) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %m, i32 %n, [1900 x double]* noalias %A, double* noalias %r, double* noalias %p) #0 {
polly.split_new_and_old:
  %0 = zext i32 %m to i64
  %1 = zext i32 %n to i64
  %2 = sext i32 %m to i64
  %3 = icmp sge i64 %2, 1
  %4 = icmp sge i64 %0, 1
  %5 = and i1 %3, %4
  br i1 %5, label %polly.then, label %polly.cond26

polly.cond26:                                     ; preds = %polly.then, %polly.loop_header, %polly.split_new_and_old
  %6 = sext i32 %n to i64
  %7 = icmp sge i64 %6, 1
  %8 = icmp sge i64 %1, 1
  %9 = and i1 %7, %8
  br i1 %9, label %polly.then28, label %polly.cond42

polly.cond42:                                     ; preds = %polly.then28, %polly.loop_header30, %polly.cond26
  %10 = and i1 %3, %7
  %11 = and i1 %10, %4
  %12 = and i1 %11, %8
  br i1 %12, label %polly.then44, label %polly.merge43

polly.merge43:                                    ; preds = %polly.then44, %polly.loop_exit57, %polly.cond42
  ret void

polly.then:                                       ; preds = %polly.split_new_and_old
  %13 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %13
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond26

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_.moved.to. = sitofp i32 %m to double
  %p_i.06 = trunc i64 %polly.indvar to i32
  %p_scevgep17 = getelementptr double* %p, i64 %polly.indvar
  %p_ = srem i32 %p_i.06, %m
  %p_24 = sitofp i32 %p_ to double
  %p_25 = fdiv double %p_24, %p_.moved.to.
  store double %p_25, double* %p_scevgep17
  %p_indvar.next15 = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %13, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond26

polly.then28:                                     ; preds = %polly.cond26
  %14 = add i64 %1, -1
  %polly.loop_guard33 = icmp sle i64 0, %14
  br i1 %polly.loop_guard33, label %polly.loop_header30, label %polly.cond42

polly.loop_header30:                              ; preds = %polly.then28, %polly.loop_header30
  %polly.indvar34 = phi i64 [ %polly.indvar_next35, %polly.loop_header30 ], [ 0, %polly.then28 ]
  %p_.moved.to.19 = sitofp i32 %n to double
  %p_i.12 = trunc i64 %polly.indvar34 to i32
  %p_scevgep13 = getelementptr double* %r, i64 %polly.indvar34
  %p_39 = srem i32 %p_i.12, %n
  %p_40 = sitofp i32 %p_39 to double
  %p_41 = fdiv double %p_40, %p_.moved.to.19
  store double %p_41, double* %p_scevgep13
  %polly.indvar_next35 = add nsw i64 %polly.indvar34, 1
  %polly.adjust_ub36 = sub i64 %14, 1
  %polly.loop_cond37 = icmp sle i64 %polly.indvar34, %polly.adjust_ub36
  br i1 %polly.loop_cond37, label %polly.loop_header30, label %polly.cond42

polly.then44:                                     ; preds = %polly.cond42
  %15 = add i64 %1, -1
  %polly.loop_guard49 = icmp sle i64 0, %15
  br i1 %polly.loop_guard49, label %polly.loop_header46, label %polly.merge43

polly.loop_header46:                              ; preds = %polly.then44, %polly.loop_exit57
  %polly.indvar50 = phi i64 [ %polly.indvar_next51, %polly.loop_exit57 ], [ 0, %polly.then44 ]
  %16 = mul i64 -3, %1
  %17 = add i64 %0, %16
  %18 = add i64 %17, 5
  %19 = sub i64 %18, 32
  %20 = add i64 %19, 1
  %21 = icmp slt i64 %18, 0
  %22 = select i1 %21, i64 %20, i64 %18
  %23 = sdiv i64 %22, 32
  %24 = mul i64 -32, %23
  %25 = mul i64 -32, %1
  %26 = add i64 %24, %25
  %27 = mul i64 -32, %polly.indvar50
  %28 = mul i64 -3, %polly.indvar50
  %29 = add i64 %28, %0
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
  %41 = mul i64 -20, %polly.indvar50
  %polly.loop_guard58 = icmp sle i64 %40, %41
  br i1 %polly.loop_guard58, label %polly.loop_header55, label %polly.loop_exit57

polly.loop_exit57:                                ; preds = %polly.loop_exit66, %polly.loop_header46
  %polly.indvar_next51 = add nsw i64 %polly.indvar50, 32
  %polly.adjust_ub52 = sub i64 %15, 32
  %polly.loop_cond53 = icmp sle i64 %polly.indvar50, %polly.adjust_ub52
  br i1 %polly.loop_cond53, label %polly.loop_header46, label %polly.merge43

polly.loop_header55:                              ; preds = %polly.loop_header46, %polly.loop_exit66
  %polly.indvar59 = phi i64 [ %polly.indvar_next60, %polly.loop_exit66 ], [ %40, %polly.loop_header46 ]
  %42 = mul i64 -1, %polly.indvar59
  %43 = mul i64 -1, %0
  %44 = add i64 %42, %43
  %45 = add i64 %44, -30
  %46 = add i64 %45, 20
  %47 = sub i64 %46, 1
  %48 = icmp slt i64 %45, 0
  %49 = select i1 %48, i64 %45, i64 %47
  %50 = sdiv i64 %49, 20
  %51 = icmp sgt i64 %50, %polly.indvar50
  %52 = select i1 %51, i64 %50, i64 %polly.indvar50
  %53 = sub i64 %42, 20
  %54 = add i64 %53, 1
  %55 = icmp slt i64 %42, 0
  %56 = select i1 %55, i64 %54, i64 %42
  %57 = sdiv i64 %56, 20
  %58 = add i64 %polly.indvar50, 31
  %59 = icmp slt i64 %57, %58
  %60 = select i1 %59, i64 %57, i64 %58
  %61 = icmp slt i64 %60, %15
  %62 = select i1 %61, i64 %60, i64 %15
  %polly.loop_guard67 = icmp sle i64 %52, %62
  br i1 %polly.loop_guard67, label %polly.loop_header64, label %polly.loop_exit66

polly.loop_exit66:                                ; preds = %polly.loop_exit75, %polly.loop_header55
  %polly.indvar_next60 = add nsw i64 %polly.indvar59, 32
  %polly.adjust_ub61 = sub i64 %41, 32
  %polly.loop_cond62 = icmp sle i64 %polly.indvar59, %polly.adjust_ub61
  br i1 %polly.loop_cond62, label %polly.loop_header55, label %polly.loop_exit57

polly.loop_header64:                              ; preds = %polly.loop_header55, %polly.loop_exit75
  %polly.indvar68 = phi i64 [ %polly.indvar_next69, %polly.loop_exit75 ], [ %52, %polly.loop_header55 ]
  %63 = mul i64 -20, %polly.indvar68
  %64 = add i64 %63, %43
  %65 = add i64 %64, 1
  %66 = icmp sgt i64 %polly.indvar59, %65
  %67 = select i1 %66, i64 %polly.indvar59, i64 %65
  %68 = add i64 %polly.indvar59, 31
  %69 = icmp slt i64 %63, %68
  %70 = select i1 %69, i64 %63, i64 %68
  %polly.loop_guard76 = icmp sle i64 %67, %70
  br i1 %polly.loop_guard76, label %polly.loop_header73, label %polly.loop_exit75

polly.loop_exit75:                                ; preds = %polly.loop_header73, %polly.loop_header64
  %polly.indvar_next69 = add nsw i64 %polly.indvar68, 1
  %polly.adjust_ub70 = sub i64 %62, 1
  %polly.loop_cond71 = icmp sle i64 %polly.indvar68, %polly.adjust_ub70
  br i1 %polly.loop_cond71, label %polly.loop_header64, label %polly.loop_exit66

polly.loop_header73:                              ; preds = %polly.loop_header64, %polly.loop_header73
  %polly.indvar77 = phi i64 [ %polly.indvar_next78, %polly.loop_header73 ], [ %67, %polly.loop_header64 ]
  %71 = mul i64 -1, %polly.indvar77
  %72 = add i64 %63, %71
  %p_.moved.to.21 = sitofp i32 %n to double
  %p_scevgep = getelementptr [1900 x double]* %A, i64 %polly.indvar68, i64 %72
  %p_82 = mul i64 %polly.indvar68, %72
  %p_83 = add i64 %polly.indvar68, %p_82
  %p_84 = trunc i64 %p_83 to i32
  %p_85 = srem i32 %p_84, %n
  %p_86 = sitofp i32 %p_85 to double
  %p_87 = fdiv double %p_86, %p_.moved.to.21
  store double %p_87, double* %p_scevgep
  %p_indvar.next = add i64 %72, 1
  %polly.indvar_next78 = add nsw i64 %polly.indvar77, 1
  %polly.adjust_ub79 = sub i64 %70, 1
  %polly.loop_cond80 = icmp sle i64 %polly.indvar77, %polly.adjust_ub79
  br i1 %polly.loop_cond80, label %polly.loop_header73, label %polly.loop_exit75
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_bicg(i32 %m, i32 %n, [1900 x double]* noalias %A, double* noalias %s, double* noalias %q, double* noalias %p, double* noalias %r) #0 {
polly.split_new_and_old:
  %0 = zext i32 %m to i64
  %1 = zext i32 %n to i64
  %2 = sext i32 %n to i64
  %3 = icmp sge i64 %2, 1
  br i1 %3, label %polly.stmt..lr.ph3, label %polly.cond23

polly.cond23:                                     ; preds = %polly.split_new_and_old, %polly.stmt..lr.ph3
  %4 = icmp sge i64 %1, 1
  %5 = and i1 %3, %4
  br i1 %5, label %polly.then25, label %polly.cond27

polly.cond27:                                     ; preds = %polly.then25, %polly.loop_header, %polly.cond23
  %6 = sext i32 %m to i64
  %7 = icmp sge i64 %6, 1
  %8 = icmp sge i64 %0, 1
  %9 = and i1 %7, %8
  br i1 %9, label %polly.then29, label %polly.cond40

polly.cond40:                                     ; preds = %polly.then29, %polly.loop_header31, %polly.cond27
  %10 = and i1 %7, %3
  %11 = and i1 %10, %4
  br i1 %11, label %polly.cond43, label %polly.merge41

polly.merge41:                                    ; preds = %polly.then76, %polly.loop_header78, %polly.cond74, %polly.cond40
  ret void

polly.stmt..lr.ph3:                               ; preds = %polly.split_new_and_old
  br label %polly.cond23

polly.then25:                                     ; preds = %polly.cond23
  %12 = add i64 %1, -1
  %polly.loop_guard = icmp sle i64 0, %12
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond27

polly.loop_header:                                ; preds = %polly.then25, %polly.loop_header
  %i.12.reg2mem.1 = phi i32 [ 0, %polly.then25 ], [ %p_, %polly.loop_header ]
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then25 ]
  %p_scevgep14 = getelementptr double* %q, i64 %polly.indvar
  store double 0.000000e+00, double* %p_scevgep14
  %p_ = add nsw i32 %i.12.reg2mem.1, 1
  %p_indvar.next9 = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %12, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond27

polly.then29:                                     ; preds = %polly.cond27
  %13 = add i64 %0, -1
  %polly.loop_guard34 = icmp sle i64 0, %13
  br i1 %polly.loop_guard34, label %polly.loop_header31, label %polly.cond40

polly.loop_header31:                              ; preds = %polly.then29, %polly.loop_header31
  %polly.indvar35 = phi i64 [ %polly.indvar_next36, %polly.loop_header31 ], [ 0, %polly.then29 ]
  %p_scevgep19 = getelementptr double* %s, i64 %polly.indvar35
  store double 0.000000e+00, double* %p_scevgep19
  %p_indvar.next17 = add i64 %polly.indvar35, 1
  %polly.indvar_next36 = add nsw i64 %polly.indvar35, 1
  %polly.adjust_ub37 = sub i64 %13, 1
  %polly.loop_cond38 = icmp sle i64 %polly.indvar35, %polly.adjust_ub37
  br i1 %polly.loop_cond38, label %polly.loop_header31, label %polly.cond40

polly.cond43:                                     ; preds = %polly.cond40
  br i1 %8, label %polly.then45, label %polly.cond74

polly.cond74:                                     ; preds = %polly.then45, %polly.loop_exit58, %polly.cond43
  %14 = icmp sle i64 %0, 0
  br i1 %14, label %polly.then76, label %polly.merge41

polly.then45:                                     ; preds = %polly.cond43
  %15 = add i64 %1, -1
  %polly.loop_guard50 = icmp sle i64 0, %15
  br i1 %polly.loop_guard50, label %polly.loop_header47, label %polly.cond74

polly.loop_header47:                              ; preds = %polly.then45, %polly.loop_exit58
  %polly.indvar51 = phi i64 [ %polly.indvar_next52, %polly.loop_exit58 ], [ 0, %polly.then45 ]
  %p_scevgep15.moved.to..lr.ph = getelementptr double* %r, i64 %polly.indvar51
  %p_scevgep14.moved.to..lr.ph = getelementptr double* %q, i64 %polly.indvar51
  %_p_scalar_ = load double* %p_scevgep15.moved.to..lr.ph
  %.promoted_p_scalar_ = load double* %p_scevgep14.moved.to..lr.ph
  %16 = add i64 %0, -1
  %polly.loop_guard59 = icmp sle i64 0, %16
  br i1 %polly.loop_guard59, label %polly.loop_header56, label %polly.loop_exit58

polly.loop_exit58:                                ; preds = %polly.loop_header56, %polly.loop_header47
  %.reg2mem.0 = phi double [ %p_72, %polly.loop_header56 ], [ %.promoted_p_scalar_, %polly.loop_header47 ]
  store double %.reg2mem.0, double* %p_scevgep14.moved.to..lr.ph
  %polly.indvar_next52 = add nsw i64 %polly.indvar51, 1
  %polly.adjust_ub53 = sub i64 %15, 1
  %polly.loop_cond54 = icmp sle i64 %polly.indvar51, %polly.adjust_ub53
  br i1 %polly.loop_cond54, label %polly.loop_header47, label %polly.cond74

polly.loop_header56:                              ; preds = %polly.loop_header47, %polly.loop_header56
  %.reg2mem.1 = phi double [ %.promoted_p_scalar_, %polly.loop_header47 ], [ %p_72, %polly.loop_header56 ]
  %polly.indvar60 = phi i64 [ %polly.indvar_next61, %polly.loop_header56 ], [ 0, %polly.loop_header47 ]
  %p_scevgep10 = getelementptr [1900 x double]* %A, i64 %polly.indvar51, i64 %polly.indvar60
  %p_scevgep = getelementptr double* %s, i64 %polly.indvar60
  %p_scevgep11 = getelementptr double* %p, i64 %polly.indvar60
  %_p_scalar_65 = load double* %p_scevgep
  %_p_scalar_66 = load double* %p_scevgep10
  %p_67 = fmul double %_p_scalar_, %_p_scalar_66
  %p_68 = fadd double %_p_scalar_65, %p_67
  store double %p_68, double* %p_scevgep
  %_p_scalar_69 = load double* %p_scevgep10
  %_p_scalar_70 = load double* %p_scevgep11
  %p_71 = fmul double %_p_scalar_69, %_p_scalar_70
  %p_72 = fadd double %.reg2mem.1, %p_71
  %p_indvar.next = add i64 %polly.indvar60, 1
  %polly.indvar_next61 = add nsw i64 %polly.indvar60, 1
  %polly.adjust_ub62 = sub i64 %16, 1
  %polly.loop_cond63 = icmp sle i64 %polly.indvar60, %polly.adjust_ub62
  br i1 %polly.loop_cond63, label %polly.loop_header56, label %polly.loop_exit58

polly.then76:                                     ; preds = %polly.cond74
  %17 = add i64 %1, -1
  %polly.loop_guard81 = icmp sle i64 0, %17
  br i1 %polly.loop_guard81, label %polly.loop_header78, label %polly.merge41

polly.loop_header78:                              ; preds = %polly.then76, %polly.loop_header78
  %polly.indvar82 = phi i64 [ %polly.indvar_next83, %polly.loop_header78 ], [ 0, %polly.then76 ]
  %p_scevgep15.moved.to..lr.ph87 = getelementptr double* %r, i64 %polly.indvar82
  %p_scevgep14.moved.to..lr.ph88 = getelementptr double* %q, i64 %polly.indvar82
  %.promoted_p_scalar_90 = load double* %p_scevgep14.moved.to..lr.ph88
  store double %.promoted_p_scalar_90, double* %p_scevgep14.moved.to..lr.ph88
  %polly.indvar_next83 = add nsw i64 %polly.indvar82, 1
  %polly.adjust_ub84 = sub i64 %17, 1
  %polly.loop_cond85 = icmp sle i64 %polly.indvar82, %polly.adjust_ub84
  br i1 %polly.loop_cond85, label %polly.loop_header78, label %polly.merge41
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %m, i32 %n, double* noalias %s, double* noalias %q) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %m, 0
  br i1 %5, label %.lr.ph7, label %16

.lr.ph7:                                          ; preds = %.split
  %6 = zext i32 %m to i64
  br label %7

; <label>:7                                       ; preds = %.lr.ph7, %12
  %indvar9 = phi i64 [ 0, %.lr.ph7 ], [ %indvar.next10, %12 ]
  %i.05 = trunc i64 %indvar9 to i32
  %scevgep12 = getelementptr double* %s, i64 %indvar9
  %8 = srem i32 %i.05, 20
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %10, label %12

; <label>:10                                      ; preds = %7
  %11 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %fputc3 = tail call i32 @fputc(i32 10, %struct._IO_FILE* %11) #4
  br label %12

; <label>:12                                      ; preds = %10, %7
  %13 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %14 = load double* %scevgep12, align 8, !tbaa !6
  %15 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %13, i8* getelementptr inbounds ([8 x i8]* @.str5, i64 0, i64 0), double %14) #5
  %indvar.next10 = add i64 %indvar9, 1
  %exitcond11 = icmp ne i64 %indvar.next10, %6
  br i1 %exitcond11, label %7, label %._crit_edge8

._crit_edge8:                                     ; preds = %12
  br label %16

; <label>:16                                      ; preds = %._crit_edge8, %.split
  %17 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %18 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %17, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %19 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %20 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %19, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str7, i64 0, i64 0)) #5
  %21 = icmp sgt i32 %n, 0
  br i1 %21, label %.lr.ph, label %32

.lr.ph:                                           ; preds = %16
  %22 = zext i32 %n to i64
  br label %23

; <label>:23                                      ; preds = %.lr.ph, %28
  %indvar = phi i64 [ 0, %.lr.ph ], [ %indvar.next, %28 ]
  %i.14 = trunc i64 %indvar to i32
  %scevgep = getelementptr double* %q, i64 %indvar
  %24 = srem i32 %i.14, 20
  %25 = icmp eq i32 %24, 0
  br i1 %25, label %26, label %28

; <label>:26                                      ; preds = %23
  %27 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %27) #4
  br label %28

; <label>:28                                      ; preds = %26, %23
  %29 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %30 = load double* %scevgep, align 8, !tbaa !6
  %31 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %29, i8* getelementptr inbounds ([8 x i8]* @.str5, i64 0, i64 0), double %30) #5
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %22
  br i1 %exitcond, label %23, label %._crit_edge

._crit_edge:                                      ; preds = %28
  br label %32

; <label>:32                                      ; preds = %._crit_edge, %16
  %33 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %34 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %33, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str7, i64 0, i64 0)) #5
  %35 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %36 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str8, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %35) #4
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
