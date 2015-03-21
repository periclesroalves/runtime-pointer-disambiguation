; ModuleID = './linear-algebra/kernels/doitgen/doitgen.c'
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
define void @kernel_doitgen(i32 %nr, i32 %nq, i32 %np, [140 x [160 x double]]* noalias %A, [160 x double]* noalias %C4, double* noalias %sum) #0 {
polly.split_new_and_old:
  %0 = zext i32 %nr to i64
  %1 = zext i32 %nq to i64
  %2 = zext i32 %np to i64
  %3 = sext i32 %np to i64
  %4 = icmp sge i64 %3, 1
  %5 = sext i32 %nq to i64
  %6 = icmp sge i64 %5, 1
  %7 = and i1 %4, %6
  %8 = sext i32 %nr to i64
  %9 = icmp sge i64 %8, 1
  %10 = and i1 %7, %9
  %11 = icmp sge i64 %0, 1
  %12 = and i1 %10, %11
  %13 = icmp sge i64 %1, 1
  %14 = and i1 %12, %13
  %15 = icmp sge i64 %2, 1
  %16 = and i1 %14, %15
  br i1 %16, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit42, %polly.split_new_and_old
  ret void

polly.then:                                       ; preds = %polly.split_new_and_old
  %17 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %17
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit42
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit42 ], [ 0, %polly.then ]
  %18 = add i64 %1, -1
  %polly.loop_guard43 = icmp sle i64 0, %18
  br i1 %polly.loop_guard43, label %polly.loop_header40, label %polly.loop_exit42

polly.loop_exit42:                                ; preds = %polly.loop_exit82, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %17, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header40:                              ; preds = %polly.loop_header, %polly.loop_exit82
  %polly.indvar44 = phi i64 [ %polly.indvar_next45, %polly.loop_exit82 ], [ 0, %polly.loop_header ]
  %19 = add i64 %2, -1
  %polly.loop_guard52 = icmp sle i64 0, %19
  br i1 %polly.loop_guard52, label %polly.loop_header49, label %polly.loop_exit51

polly.loop_exit51:                                ; preds = %polly.loop_header49, %polly.loop_header40
  br i1 %polly.loop_guard52, label %polly.loop_header58, label %polly.loop_exit60

polly.loop_exit60:                                ; preds = %polly.loop_exit69, %polly.loop_exit51
  br i1 %polly.loop_guard52, label %polly.loop_header80, label %polly.loop_exit82

polly.loop_exit82:                                ; preds = %polly.loop_header80, %polly.loop_exit60
  %polly.indvar_next45 = add nsw i64 %polly.indvar44, 1
  %polly.adjust_ub46 = sub i64 %18, 1
  %polly.loop_cond47 = icmp sle i64 %polly.indvar44, %polly.adjust_ub46
  br i1 %polly.loop_cond47, label %polly.loop_header40, label %polly.loop_exit42

polly.loop_header49:                              ; preds = %polly.loop_header40, %polly.loop_header49
  %polly.indvar53 = phi i64 [ %polly.indvar_next54, %polly.loop_header49 ], [ 0, %polly.loop_header40 ]
  %p_scevgep22 = getelementptr double* %sum, i64 %polly.indvar53
  store double 0.000000e+00, double* %p_scevgep22
  %polly.indvar_next54 = add nsw i64 %polly.indvar53, 1
  %polly.adjust_ub55 = sub i64 %19, 1
  %polly.loop_cond56 = icmp sle i64 %polly.indvar53, %polly.adjust_ub55
  br i1 %polly.loop_cond56, label %polly.loop_header49, label %polly.loop_exit51

polly.loop_header58:                              ; preds = %polly.loop_exit51, %polly.loop_exit69
  %polly.indvar62 = phi i64 [ %polly.indvar_next63, %polly.loop_exit69 ], [ 0, %polly.loop_exit51 ]
  %p_scevgep22.moved.to..lr.ph = getelementptr double* %sum, i64 %polly.indvar62
  %.promoted_p_scalar_ = load double* %p_scevgep22.moved.to..lr.ph
  br i1 %polly.loop_guard52, label %polly.loop_header67, label %polly.loop_exit69

polly.loop_exit69:                                ; preds = %polly.loop_header67, %polly.loop_header58
  %.reg2mem.0 = phi double [ %p_77, %polly.loop_header67 ], [ %.promoted_p_scalar_, %polly.loop_header58 ]
  store double %.reg2mem.0, double* %p_scevgep22.moved.to..lr.ph
  %polly.indvar_next63 = add nsw i64 %polly.indvar62, 1
  %polly.adjust_ub64 = sub i64 %19, 1
  %polly.loop_cond65 = icmp sle i64 %polly.indvar62, %polly.adjust_ub64
  br i1 %polly.loop_cond65, label %polly.loop_header58, label %polly.loop_exit60

polly.loop_header67:                              ; preds = %polly.loop_header58, %polly.loop_header67
  %.reg2mem.1 = phi double [ %.promoted_p_scalar_, %polly.loop_header58 ], [ %p_77, %polly.loop_header67 ]
  %polly.indvar71 = phi i64 [ %polly.indvar_next72, %polly.loop_header67 ], [ 0, %polly.loop_header58 ]
  %p_scevgep = getelementptr [140 x [160 x double]]* %A, i64 %polly.indvar, i64 %polly.indvar44, i64 %polly.indvar71
  %p_scevgep19 = getelementptr [160 x double]* %C4, i64 %polly.indvar71, i64 %polly.indvar62
  %_p_scalar_ = load double* %p_scevgep
  %_p_scalar_76 = load double* %p_scevgep19
  %p_ = fmul double %_p_scalar_, %_p_scalar_76
  %p_77 = fadd double %.reg2mem.1, %p_
  %p_indvar.next = add i64 %polly.indvar71, 1
  %polly.indvar_next72 = add nsw i64 %polly.indvar71, 1
  %polly.adjust_ub73 = sub i64 %19, 1
  %polly.loop_cond74 = icmp sle i64 %polly.indvar71, %polly.adjust_ub73
  br i1 %polly.loop_cond74, label %polly.loop_header67, label %polly.loop_exit69

polly.loop_header80:                              ; preds = %polly.loop_exit60, %polly.loop_header80
  %polly.indvar84 = phi i64 [ %polly.indvar_next85, %polly.loop_header80 ], [ 0, %polly.loop_exit60 ]
  %p_scevgep27 = getelementptr [140 x [160 x double]]* %A, i64 %polly.indvar, i64 %polly.indvar44, i64 %polly.indvar84
  %p_scevgep26 = getelementptr double* %sum, i64 %polly.indvar84
  %_p_scalar_89 = load double* %p_scevgep26
  store double %_p_scalar_89, double* %p_scevgep27
  %p_indvar.next24 = add i64 %polly.indvar84, 1
  %polly.indvar_next85 = add nsw i64 %polly.indvar84, 1
  %polly.adjust_ub86 = sub i64 %19, 1
  %polly.loop_cond87 = icmp sle i64 %polly.indvar84, %polly.adjust_ub86
  br i1 %polly.loop_cond87, label %polly.loop_header80, label %polly.loop_exit82
}

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %0 = tail call i8* @polybench_alloc_data(i64 3360000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 160, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 25600, i32 8) #3
  %3 = bitcast i8* %0 to [140 x [160 x double]]*
  %4 = bitcast i8* %2 to [160 x double]*
  tail call void @init_array(i32 150, i32 140, i32 160, [140 x [160 x double]]* %3, [160 x double]* %4)
  tail call void (...)* @polybench_timer_start() #3
  %5 = bitcast i8* %1 to double*
  tail call void @kernel_doitgen(i32 150, i32 140, i32 160, [140 x [160 x double]]* %3, [160 x double]* %4, double* %5)
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
  tail call void @print_array(i32 150, i32 140, i32 160, [140 x [160 x double]]* %3)
  br label %11

; <label>:11                                      ; preds = %7, %10, %.split
  tail call void @free(i8* %0) #3
  tail call void @free(i8* %1) #3
  tail call void @free(i8* %2) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %nr, i32 %nq, i32 %np, [140 x [160 x double]]* noalias %A, [160 x double]* noalias %C4) #0 {
polly.split_new_and_old:
  %0 = zext i32 %nr to i64
  %1 = zext i32 %nq to i64
  %2 = zext i32 %np to i64
  %3 = sext i32 %np to i64
  %4 = icmp sge i64 %3, 1
  %5 = icmp sge i64 %2, 1
  %6 = and i1 %4, %5
  br i1 %6, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.then72, %polly.loop_exit85, %polly.cond70, %polly.split_new_and_old
  ret void

polly.then:                                       ; preds = %polly.split_new_and_old
  %7 = add i64 %2, -1
  %polly.loop_guard = icmp sle i64 0, %7
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond70

polly.cond70:                                     ; preds = %polly.then, %polly.loop_exit42
  %8 = sext i32 %nq to i64
  %9 = icmp sge i64 %8, 1
  %10 = sext i32 %nr to i64
  %11 = icmp sge i64 %10, 1
  %12 = and i1 %9, %11
  %13 = icmp sge i64 %0, 1
  %14 = and i1 %12, %13
  %15 = icmp sge i64 %1, 1
  %16 = and i1 %14, %15
  br i1 %16, label %polly.then72, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit42
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit42 ], [ 0, %polly.then ]
  %17 = mul i64 -11, %2
  %18 = add i64 %17, 5
  %19 = sub i64 %18, 32
  %20 = add i64 %19, 1
  %21 = icmp slt i64 %18, 0
  %22 = select i1 %21, i64 %20, i64 %18
  %23 = sdiv i64 %22, 32
  %24 = mul i64 -32, %23
  %25 = mul i64 -32, %2
  %26 = add i64 %24, %25
  %27 = mul i64 -32, %polly.indvar
  %28 = mul i64 -3, %polly.indvar
  %29 = add i64 %28, %2
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
  %polly.loop_guard43 = icmp sle i64 %40, %41
  br i1 %polly.loop_guard43, label %polly.loop_header40, label %polly.loop_exit42

polly.loop_exit42:                                ; preds = %polly.loop_exit51, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %7, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond70

polly.loop_header40:                              ; preds = %polly.loop_header, %polly.loop_exit51
  %polly.indvar44 = phi i64 [ %polly.indvar_next45, %polly.loop_exit51 ], [ %40, %polly.loop_header ]
  %42 = mul i64 -1, %polly.indvar44
  %43 = mul i64 -1, %2
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
  %61 = icmp slt i64 %60, %7
  %62 = select i1 %61, i64 %60, i64 %7
  %polly.loop_guard52 = icmp sle i64 %52, %62
  br i1 %polly.loop_guard52, label %polly.loop_header49, label %polly.loop_exit51

polly.loop_exit51:                                ; preds = %polly.loop_exit60, %polly.loop_header40
  %polly.indvar_next45 = add nsw i64 %polly.indvar44, 32
  %polly.adjust_ub46 = sub i64 %41, 32
  %polly.loop_cond47 = icmp sle i64 %polly.indvar44, %polly.adjust_ub46
  br i1 %polly.loop_cond47, label %polly.loop_header40, label %polly.loop_exit42

polly.loop_header49:                              ; preds = %polly.loop_header40, %polly.loop_exit60
  %polly.indvar53 = phi i64 [ %polly.indvar_next54, %polly.loop_exit60 ], [ %52, %polly.loop_header40 ]
  %63 = mul i64 -20, %polly.indvar53
  %64 = add i64 %63, %43
  %65 = add i64 %64, 1
  %66 = icmp sgt i64 %polly.indvar44, %65
  %67 = select i1 %66, i64 %polly.indvar44, i64 %65
  %68 = add i64 %polly.indvar44, 31
  %69 = icmp slt i64 %63, %68
  %70 = select i1 %69, i64 %63, i64 %68
  %polly.loop_guard61 = icmp sle i64 %67, %70
  br i1 %polly.loop_guard61, label %polly.loop_header58, label %polly.loop_exit60

polly.loop_exit60:                                ; preds = %polly.loop_header58, %polly.loop_header49
  %polly.indvar_next54 = add nsw i64 %polly.indvar53, 1
  %polly.adjust_ub55 = sub i64 %62, 1
  %polly.loop_cond56 = icmp sle i64 %polly.indvar53, %polly.adjust_ub55
  br i1 %polly.loop_cond56, label %polly.loop_header49, label %polly.loop_exit51

polly.loop_header58:                              ; preds = %polly.loop_header49, %polly.loop_header58
  %polly.indvar62 = phi i64 [ %polly.indvar_next63, %polly.loop_header58 ], [ %67, %polly.loop_header49 ]
  %71 = mul i64 -1, %polly.indvar62
  %72 = add i64 %63, %71
  %p_.moved.to.36 = sitofp i32 %np to double
  %p_scevgep = getelementptr [160 x double]* %C4, i64 %polly.indvar53, i64 %72
  %p_ = mul i64 %polly.indvar53, %72
  %p_66 = trunc i64 %p_ to i32
  %p_67 = srem i32 %p_66, %np
  %p_68 = sitofp i32 %p_67 to double
  %p_69 = fdiv double %p_68, %p_.moved.to.36
  store double %p_69, double* %p_scevgep
  %p_indvar.next = add i64 %72, 1
  %polly.indvar_next63 = add nsw i64 %polly.indvar62, 1
  %polly.adjust_ub64 = sub i64 %70, 1
  %polly.loop_cond65 = icmp sle i64 %polly.indvar62, %polly.adjust_ub64
  br i1 %polly.loop_cond65, label %polly.loop_header58, label %polly.loop_exit60

polly.then72:                                     ; preds = %polly.cond70
  %73 = add i64 %0, -1
  %polly.loop_guard77 = icmp sle i64 0, %73
  br i1 %polly.loop_guard77, label %polly.loop_header74, label %polly.merge

polly.loop_header74:                              ; preds = %polly.then72, %polly.loop_exit85
  %polly.indvar78 = phi i64 [ %polly.indvar_next79, %polly.loop_exit85 ], [ 0, %polly.then72 ]
  %74 = add i64 %1, -1
  %polly.loop_guard86 = icmp sle i64 0, %74
  br i1 %polly.loop_guard86, label %polly.loop_header83, label %polly.loop_exit85

polly.loop_exit85:                                ; preds = %polly.loop_exit94, %polly.loop_header74
  %polly.indvar_next79 = add nsw i64 %polly.indvar78, 1
  %polly.adjust_ub80 = sub i64 %73, 1
  %polly.loop_cond81 = icmp sle i64 %polly.indvar78, %polly.adjust_ub80
  br i1 %polly.loop_cond81, label %polly.loop_header74, label %polly.merge

polly.loop_header83:                              ; preds = %polly.loop_header74, %polly.loop_exit94
  %polly.indvar87 = phi i64 [ %polly.indvar_next88, %polly.loop_exit94 ], [ 0, %polly.loop_header74 ]
  %75 = mul i64 -3, %1
  %76 = add i64 %75, %2
  %77 = add i64 %76, 5
  %78 = sub i64 %77, 32
  %79 = add i64 %78, 1
  %80 = icmp slt i64 %77, 0
  %81 = select i1 %80, i64 %79, i64 %77
  %82 = sdiv i64 %81, 32
  %83 = mul i64 -32, %82
  %84 = mul i64 -32, %1
  %85 = add i64 %83, %84
  %86 = mul i64 -32, %polly.indvar87
  %87 = mul i64 -3, %polly.indvar87
  %88 = add i64 %87, %2
  %89 = add i64 %88, 5
  %90 = sub i64 %89, 32
  %91 = add i64 %90, 1
  %92 = icmp slt i64 %89, 0
  %93 = select i1 %92, i64 %91, i64 %89
  %94 = sdiv i64 %93, 32
  %95 = mul i64 -32, %94
  %96 = add i64 %86, %95
  %97 = add i64 %96, -640
  %98 = icmp sgt i64 %85, %97
  %99 = select i1 %98, i64 %85, i64 %97
  %100 = mul i64 -20, %polly.indvar87
  %polly.loop_guard95 = icmp sle i64 %99, %100
  br i1 %polly.loop_guard95, label %polly.loop_header92, label %polly.loop_exit94

polly.loop_exit94:                                ; preds = %polly.loop_exit103, %polly.loop_header83
  %polly.indvar_next88 = add nsw i64 %polly.indvar87, 32
  %polly.adjust_ub89 = sub i64 %74, 32
  %polly.loop_cond90 = icmp sle i64 %polly.indvar87, %polly.adjust_ub89
  br i1 %polly.loop_cond90, label %polly.loop_header83, label %polly.loop_exit85

polly.loop_header92:                              ; preds = %polly.loop_header83, %polly.loop_exit103
  %polly.indvar96 = phi i64 [ %polly.indvar_next97, %polly.loop_exit103 ], [ %99, %polly.loop_header83 ]
  %101 = mul i64 -1, %polly.indvar96
  %102 = mul i64 -1, %2
  %103 = add i64 %101, %102
  %104 = add i64 %103, -30
  %105 = add i64 %104, 20
  %106 = sub i64 %105, 1
  %107 = icmp slt i64 %104, 0
  %108 = select i1 %107, i64 %104, i64 %106
  %109 = sdiv i64 %108, 20
  %110 = icmp sgt i64 %109, %polly.indvar87
  %111 = select i1 %110, i64 %109, i64 %polly.indvar87
  %112 = sub i64 %101, 20
  %113 = add i64 %112, 1
  %114 = icmp slt i64 %101, 0
  %115 = select i1 %114, i64 %113, i64 %101
  %116 = sdiv i64 %115, 20
  %117 = add i64 %polly.indvar87, 31
  %118 = icmp slt i64 %116, %117
  %119 = select i1 %118, i64 %116, i64 %117
  %120 = icmp slt i64 %119, %74
  %121 = select i1 %120, i64 %119, i64 %74
  %polly.loop_guard104 = icmp sle i64 %111, %121
  br i1 %polly.loop_guard104, label %polly.loop_header101, label %polly.loop_exit103

polly.loop_exit103:                               ; preds = %polly.loop_exit112, %polly.loop_header92
  %polly.indvar_next97 = add nsw i64 %polly.indvar96, 32
  %polly.adjust_ub98 = sub i64 %100, 32
  %polly.loop_cond99 = icmp sle i64 %polly.indvar96, %polly.adjust_ub98
  br i1 %polly.loop_cond99, label %polly.loop_header92, label %polly.loop_exit94

polly.loop_header101:                             ; preds = %polly.loop_header92, %polly.loop_exit112
  %polly.indvar105 = phi i64 [ %polly.indvar_next106, %polly.loop_exit112 ], [ %111, %polly.loop_header92 ]
  %122 = mul i64 -20, %polly.indvar105
  %123 = add i64 %122, %102
  %124 = add i64 %123, 1
  %125 = icmp sgt i64 %polly.indvar96, %124
  %126 = select i1 %125, i64 %polly.indvar96, i64 %124
  %127 = add i64 %polly.indvar96, 31
  %128 = icmp slt i64 %122, %127
  %129 = select i1 %128, i64 %122, i64 %127
  %polly.loop_guard113 = icmp sle i64 %126, %129
  br i1 %polly.loop_guard113, label %polly.loop_header110, label %polly.loop_exit112

polly.loop_exit112:                               ; preds = %polly.loop_header110, %polly.loop_header101
  %polly.indvar_next106 = add nsw i64 %polly.indvar105, 1
  %polly.adjust_ub107 = sub i64 %121, 1
  %polly.loop_cond108 = icmp sle i64 %polly.indvar105, %polly.adjust_ub107
  br i1 %polly.loop_cond108, label %polly.loop_header101, label %polly.loop_exit103

polly.loop_header110:                             ; preds = %polly.loop_header101, %polly.loop_header110
  %polly.indvar114 = phi i64 [ %polly.indvar_next115, %polly.loop_header110 ], [ %126, %polly.loop_header101 ]
  %130 = mul i64 -1, %polly.indvar114
  %131 = add i64 %122, %130
  %p_.moved.to. = mul i64 %polly.indvar78, %polly.indvar105
  %p_.moved.to.32 = sitofp i32 %np to double
  %p_scevgep27 = getelementptr [140 x [160 x double]]* %A, i64 %polly.indvar78, i64 %polly.indvar105, i64 %131
  %p_119 = add i64 %p_.moved.to., %131
  %p_120 = trunc i64 %p_119 to i32
  %p_121 = srem i32 %p_120, %np
  %p_122 = sitofp i32 %p_121 to double
  %p_123 = fdiv double %p_122, %p_.moved.to.32
  store double %p_123, double* %p_scevgep27
  %p_indvar.next21 = add i64 %131, 1
  %polly.indvar_next115 = add nsw i64 %polly.indvar114, 1
  %polly.adjust_ub116 = sub i64 %129, 1
  %polly.loop_cond117 = icmp sle i64 %polly.indvar114, %polly.adjust_ub116
  br i1 %polly.loop_cond117, label %polly.loop_header110, label %polly.loop_exit112
}

declare void @polybench_timer_start(...) #1

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %nr, i32 %nq, i32 %np, [140 x [160 x double]]* noalias %A) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %nr, 0
  br i1 %5, label %.preheader1.lr.ph, label %30

.preheader1.lr.ph:                                ; preds = %.split
  %6 = zext i32 %np to i64
  %7 = mul i32 %np, %nq
  %8 = zext i32 %nq to i64
  %9 = zext i32 %nr to i64
  %10 = zext i32 %np to i64
  %11 = zext i32 %7 to i64
  %12 = icmp sgt i32 %nq, 0
  %13 = icmp sgt i32 %np, 0
  br label %.preheader1

.preheader1:                                      ; preds = %.preheader1.lr.ph, %29
  %indvar8 = phi i64 [ 0, %.preheader1.lr.ph ], [ %indvar.next9, %29 ]
  %14 = mul i64 %11, %indvar8
  br i1 %12, label %.preheader.lr.ph, label %29

.preheader.lr.ph:                                 ; preds = %.preheader1
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %28
  %indvar10 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next11, %28 ]
  %15 = mul i64 %10, %indvar10
  %16 = add i64 %14, %15
  br i1 %13, label %.lr.ph, label %28

.lr.ph:                                           ; preds = %.preheader
  br label %17

; <label>:17                                      ; preds = %.lr.ph, %24
  %indvar = phi i64 [ 0, %.lr.ph ], [ %indvar.next, %24 ]
  %scevgep = getelementptr [140 x [160 x double]]* %A, i64 %indvar8, i64 %indvar10, i64 %indvar
  %18 = add i64 %16, %indvar
  %19 = trunc i64 %18 to i32
  %20 = srem i32 %19, 20
  %21 = icmp eq i32 %20, 0
  br i1 %21, label %22, label %24

; <label>:22                                      ; preds = %17
  %23 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %23) #4
  br label %24

; <label>:24                                      ; preds = %22, %17
  %25 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %26 = load double* %scevgep, align 8, !tbaa !6
  %27 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %25, i8* getelementptr inbounds ([8 x i8]* @.str5, i64 0, i64 0), double %26) #5
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %6
  br i1 %exitcond, label %17, label %._crit_edge

._crit_edge:                                      ; preds = %24
  br label %28

; <label>:28                                      ; preds = %._crit_edge, %.preheader
  %indvar.next11 = add i64 %indvar10, 1
  %exitcond12 = icmp ne i64 %indvar.next11, %8
  br i1 %exitcond12, label %.preheader, label %._crit_edge5

._crit_edge5:                                     ; preds = %28
  br label %29

; <label>:29                                      ; preds = %._crit_edge5, %.preheader1
  %indvar.next9 = add i64 %indvar8, 1
  %exitcond14 = icmp ne i64 %indvar.next9, %9
  br i1 %exitcond14, label %.preheader1, label %._crit_edge7

._crit_edge7:                                     ; preds = %29
  br label %30

; <label>:30                                      ; preds = %._crit_edge7, %.split
  %31 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %32 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %31, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %33 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %34 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str7, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %33) #4
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
