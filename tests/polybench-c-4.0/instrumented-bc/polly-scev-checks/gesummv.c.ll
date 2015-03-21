; ModuleID = './linear-algebra/blas/gesummv/gesummv.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %alpha = alloca double, align 8
  %beta = alloca double, align 8
  %0 = tail call i8* @polybench_alloc_data(i64 1690000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 1690000, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 1300, i32 8) #3
  %3 = tail call i8* @polybench_alloc_data(i64 1300, i32 8) #3
  %4 = tail call i8* @polybench_alloc_data(i64 1300, i32 8) #3
  %5 = bitcast i8* %0 to [1300 x double]*
  %6 = bitcast i8* %1 to [1300 x double]*
  %7 = bitcast i8* %3 to double*
  call void @init_array(i32 1300, double* %alpha, double* %beta, [1300 x double]* %5, [1300 x double]* %6, double* %7)
  call void (...)* @polybench_timer_start() #3
  %8 = load double* %alpha, align 8, !tbaa !1
  %9 = load double* %beta, align 8, !tbaa !1
  %10 = bitcast i8* %2 to double*
  %11 = bitcast i8* %4 to double*
  call void @kernel_gesummv(i32 1300, double %8, double %9, [1300 x double]* %5, [1300 x double]* %6, double* %10, double* %7, double* %11)
  call void (...)* @polybench_timer_stop() #3
  call void (...)* @polybench_timer_print() #3
  %12 = icmp sgt i32 %argc, 42
  br i1 %12, label %13, label %17

; <label>:13                                      ; preds = %.split
  %14 = load i8** %argv, align 8, !tbaa !5
  %15 = load i8* %14, align 1, !tbaa !7
  %phitmp = icmp eq i8 %15, 0
  br i1 %phitmp, label %16, label %17

; <label>:16                                      ; preds = %13
  call void @print_array(i32 1300, double* %11)
  br label %17

; <label>:17                                      ; preds = %13, %16, %.split
  call void @free(i8* %0) #3
  call void @free(i8* %1) #3
  call void @free(i8* %2) #3
  call void @free(i8* %3) #3
  call void @free(i8* %4) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %n, double* %alpha, double* %beta, [1300 x double]* %A, [1300 x double]* %B, double* %x) #0 {
.split:
  %alpha14 = bitcast double* %alpha to i8*
  %beta15 = bitcast double* %beta to i8*
  %A17 = bitcast [1300 x double]* %A to i8*
  %B20 = bitcast [1300 x double]* %B to i8*
  %x23 = bitcast double* %x to i8*
  %x22 = ptrtoint double* %x to i64
  %B19 = ptrtoint [1300 x double]* %B to i64
  %A16 = ptrtoint [1300 x double]* %A to i64
  %0 = icmp ult i8* %alpha14, %beta15
  %1 = icmp ult i8* %beta15, %alpha14
  %pair-no-alias = or i1 %0, %1
  %2 = zext i32 %n to i64
  %3 = add i64 %2, -1
  %4 = mul i64 10400, %3
  %5 = add i64 %A16, %4
  %6 = mul i64 8, %3
  %7 = add i64 %5, %6
  %8 = inttoptr i64 %7 to i8*
  %9 = icmp ult i8* %alpha14, %A17
  %10 = icmp ult i8* %8, %alpha14
  %pair-no-alias18 = or i1 %9, %10
  %11 = and i1 %pair-no-alias, %pair-no-alias18
  %12 = add i64 %B19, %4
  %13 = add i64 %12, %6
  %14 = inttoptr i64 %13 to i8*
  %15 = icmp ult i8* %alpha14, %B20
  %16 = icmp ult i8* %14, %alpha14
  %pair-no-alias21 = or i1 %15, %16
  %17 = and i1 %11, %pair-no-alias21
  %18 = add i64 %x22, %6
  %19 = inttoptr i64 %18 to i8*
  %20 = icmp ult i8* %alpha14, %x23
  %21 = icmp ult i8* %19, %alpha14
  %pair-no-alias24 = or i1 %20, %21
  %22 = and i1 %17, %pair-no-alias24
  %23 = icmp ult i8* %beta15, %A17
  %24 = icmp ult i8* %8, %beta15
  %pair-no-alias25 = or i1 %23, %24
  %25 = and i1 %22, %pair-no-alias25
  %26 = icmp ult i8* %beta15, %B20
  %27 = icmp ult i8* %14, %beta15
  %pair-no-alias26 = or i1 %26, %27
  %28 = and i1 %25, %pair-no-alias26
  %29 = icmp ult i8* %beta15, %x23
  %30 = icmp ult i8* %19, %beta15
  %pair-no-alias27 = or i1 %29, %30
  %31 = and i1 %28, %pair-no-alias27
  %32 = icmp ult i8* %8, %B20
  %33 = icmp ult i8* %14, %A17
  %pair-no-alias28 = or i1 %32, %33
  %34 = and i1 %31, %pair-no-alias28
  %35 = icmp ult i8* %8, %x23
  %36 = icmp ult i8* %19, %A17
  %pair-no-alias29 = or i1 %35, %36
  %37 = and i1 %34, %pair-no-alias29
  %38 = icmp ult i8* %14, %x23
  %39 = icmp ult i8* %19, %B20
  %pair-no-alias30 = or i1 %38, %39
  %40 = and i1 %37, %pair-no-alias30
  br i1 %40, label %polly.start, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  store double 1.500000e+00, double* %alpha, align 8, !tbaa !1
  store double 1.200000e+00, double* %beta, align 8, !tbaa !1
  %41 = icmp sgt i32 %n, 0
  br i1 %41, label %.lr.ph5.clone, label %.region.clone

.lr.ph5.clone:                                    ; preds = %.split.split.clone
  %42 = sitofp i32 %n to double
  br label %43

; <label>:43                                      ; preds = %._crit_edge.clone, %.lr.ph5.clone
  %44 = phi i64 [ 0, %.lr.ph5.clone ], [ %indvar.next8.clone, %._crit_edge.clone ]
  %i.02.clone = trunc i64 %44 to i32
  %scevgep13.clone = getelementptr double* %x, i64 %44
  %45 = srem i32 %i.02.clone, %n
  %46 = sitofp i32 %45 to double
  %47 = fdiv double %46, %42
  store double %47, double* %scevgep13.clone, align 8, !tbaa !1
  br i1 %41, label %.lr.ph.clone, label %._crit_edge.clone

.lr.ph.clone:                                     ; preds = %43, %.lr.ph.clone
  %indvar.clone = phi i64 [ %indvar.next.clone, %.lr.ph.clone ], [ 0, %43 ]
  %scevgep9.clone = getelementptr [1300 x double]* %B, i64 %44, i64 %indvar.clone
  %scevgep.clone = getelementptr [1300 x double]* %A, i64 %44, i64 %indvar.clone
  %48 = mul i64 %44, %indvar.clone
  %49 = trunc i64 %48 to i32
  %50 = srem i32 %49, %n
  %51 = sitofp i32 %50 to double
  %52 = fdiv double %51, %42
  store double %52, double* %scevgep.clone, align 8, !tbaa !1
  store double %52, double* %scevgep9.clone, align 8, !tbaa !1
  %indvar.next.clone = add i64 %indvar.clone, 1
  %exitcond.clone = icmp ne i64 %indvar.next.clone, %2
  br i1 %exitcond.clone, label %.lr.ph.clone, label %._crit_edge.clone

._crit_edge.clone:                                ; preds = %.lr.ph.clone, %43
  %indvar.next8.clone = add i64 %44, 1
  %exitcond10.clone = icmp ne i64 %indvar.next8.clone, %2
  br i1 %exitcond10.clone, label %43, label %.region.clone

.region.clone:                                    ; preds = %.split.split.clone, %._crit_edge.clone, %polly.stmt..split.split
  ret void

polly.start:                                      ; preds = %.split
  %53 = sext i32 %n to i64
  %54 = icmp sge i64 %53, 1
  %55 = icmp sge i64 %2, 1
  %56 = and i1 %54, %55
  br i1 %56, label %polly.then, label %polly.cond38

polly.cond38:                                     ; preds = %polly.then, %polly.loop_header, %polly.start
  br i1 %56, label %polly.then40, label %polly.stmt..split.split

polly.stmt..split.split:                          ; preds = %polly.then40, %polly.loop_exit53, %polly.cond38
  store double 1.500000e+00, double* %alpha
  store double 1.200000e+00, double* %beta
  br label %.region.clone

polly.then:                                       ; preds = %polly.start
  %polly.loop_guard = icmp sle i64 0, %3
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond38

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_.moved.to. = sitofp i32 %n to double
  %p_i.02 = trunc i64 %polly.indvar to i32
  %p_scevgep13 = getelementptr double* %x, i64 %polly.indvar
  %p_ = srem i32 %p_i.02, %n
  %p_36 = sitofp i32 %p_ to double
  %p_37 = fdiv double %p_36, %p_.moved.to.
  store double %p_37, double* %p_scevgep13
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %3, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond38

polly.then40:                                     ; preds = %polly.cond38
  %polly.loop_guard45 = icmp sle i64 0, %3
  br i1 %polly.loop_guard45, label %polly.loop_header42, label %polly.stmt..split.split

polly.loop_header42:                              ; preds = %polly.then40, %polly.loop_exit53
  %polly.indvar46 = phi i64 [ %polly.indvar_next47, %polly.loop_exit53 ], [ 0, %polly.then40 ]
  %57 = mul i64 -11, %2
  %58 = add i64 %57, 5
  %59 = sub i64 %58, 32
  %60 = add i64 %59, 1
  %61 = icmp slt i64 %58, 0
  %62 = select i1 %61, i64 %60, i64 %58
  %63 = sdiv i64 %62, 32
  %64 = mul i64 -32, %63
  %65 = mul i64 -32, %2
  %66 = add i64 %64, %65
  %67 = mul i64 -32, %polly.indvar46
  %68 = mul i64 -3, %polly.indvar46
  %69 = add i64 %68, %2
  %70 = add i64 %69, 5
  %71 = sub i64 %70, 32
  %72 = add i64 %71, 1
  %73 = icmp slt i64 %70, 0
  %74 = select i1 %73, i64 %72, i64 %70
  %75 = sdiv i64 %74, 32
  %76 = mul i64 -32, %75
  %77 = add i64 %67, %76
  %78 = add i64 %77, -640
  %79 = icmp sgt i64 %66, %78
  %80 = select i1 %79, i64 %66, i64 %78
  %81 = mul i64 -20, %polly.indvar46
  %polly.loop_guard54 = icmp sle i64 %80, %81
  br i1 %polly.loop_guard54, label %polly.loop_header51, label %polly.loop_exit53

polly.loop_exit53:                                ; preds = %polly.loop_exit62, %polly.loop_header42
  %polly.indvar_next47 = add nsw i64 %polly.indvar46, 32
  %polly.adjust_ub48 = sub i64 %3, 32
  %polly.loop_cond49 = icmp sle i64 %polly.indvar46, %polly.adjust_ub48
  br i1 %polly.loop_cond49, label %polly.loop_header42, label %polly.stmt..split.split

polly.loop_header51:                              ; preds = %polly.loop_header42, %polly.loop_exit62
  %polly.indvar55 = phi i64 [ %polly.indvar_next56, %polly.loop_exit62 ], [ %80, %polly.loop_header42 ]
  %82 = mul i64 -1, %polly.indvar55
  %83 = mul i64 -1, %2
  %84 = add i64 %82, %83
  %85 = add i64 %84, -30
  %86 = add i64 %85, 20
  %87 = sub i64 %86, 1
  %88 = icmp slt i64 %85, 0
  %89 = select i1 %88, i64 %85, i64 %87
  %90 = sdiv i64 %89, 20
  %91 = icmp sgt i64 %90, %polly.indvar46
  %92 = select i1 %91, i64 %90, i64 %polly.indvar46
  %93 = sub i64 %82, 20
  %94 = add i64 %93, 1
  %95 = icmp slt i64 %82, 0
  %96 = select i1 %95, i64 %94, i64 %82
  %97 = sdiv i64 %96, 20
  %98 = add i64 %polly.indvar46, 31
  %99 = icmp slt i64 %97, %98
  %100 = select i1 %99, i64 %97, i64 %98
  %101 = icmp slt i64 %100, %3
  %102 = select i1 %101, i64 %100, i64 %3
  %polly.loop_guard63 = icmp sle i64 %92, %102
  br i1 %polly.loop_guard63, label %polly.loop_header60, label %polly.loop_exit62

polly.loop_exit62:                                ; preds = %polly.loop_exit71, %polly.loop_header51
  %polly.indvar_next56 = add nsw i64 %polly.indvar55, 32
  %polly.adjust_ub57 = sub i64 %81, 32
  %polly.loop_cond58 = icmp sle i64 %polly.indvar55, %polly.adjust_ub57
  br i1 %polly.loop_cond58, label %polly.loop_header51, label %polly.loop_exit53

polly.loop_header60:                              ; preds = %polly.loop_header51, %polly.loop_exit71
  %polly.indvar64 = phi i64 [ %polly.indvar_next65, %polly.loop_exit71 ], [ %92, %polly.loop_header51 ]
  %103 = mul i64 -20, %polly.indvar64
  %104 = add i64 %103, %83
  %105 = add i64 %104, 1
  %106 = icmp sgt i64 %polly.indvar55, %105
  %107 = select i1 %106, i64 %polly.indvar55, i64 %105
  %108 = add i64 %polly.indvar55, 31
  %109 = icmp slt i64 %103, %108
  %110 = select i1 %109, i64 %103, i64 %108
  %polly.loop_guard72 = icmp sle i64 %107, %110
  br i1 %polly.loop_guard72, label %polly.loop_header69, label %polly.loop_exit71

polly.loop_exit71:                                ; preds = %polly.loop_header69, %polly.loop_header60
  %polly.indvar_next65 = add nsw i64 %polly.indvar64, 1
  %polly.adjust_ub66 = sub i64 %102, 1
  %polly.loop_cond67 = icmp sle i64 %polly.indvar64, %polly.adjust_ub66
  br i1 %polly.loop_cond67, label %polly.loop_header60, label %polly.loop_exit62

polly.loop_header69:                              ; preds = %polly.loop_header60, %polly.loop_header69
  %polly.indvar73 = phi i64 [ %polly.indvar_next74, %polly.loop_header69 ], [ %107, %polly.loop_header60 ]
  %111 = mul i64 -1, %polly.indvar73
  %112 = add i64 %103, %111
  %p_.moved.to.32 = sitofp i32 %n to double
  %p_scevgep9 = getelementptr [1300 x double]* %B, i64 %polly.indvar64, i64 %112
  %p_scevgep = getelementptr [1300 x double]* %A, i64 %polly.indvar64, i64 %112
  %p_78 = mul i64 %polly.indvar64, %112
  %p_79 = trunc i64 %p_78 to i32
  %p_80 = srem i32 %p_79, %n
  %p_81 = sitofp i32 %p_80 to double
  %p_82 = fdiv double %p_81, %p_.moved.to.32
  store double %p_82, double* %p_scevgep
  store double %p_82, double* %p_scevgep9
  %p_indvar.next = add i64 %112, 1
  %polly.indvar_next74 = add nsw i64 %polly.indvar73, 1
  %polly.adjust_ub75 = sub i64 %110, 1
  %polly.loop_cond76 = icmp sle i64 %polly.indvar73, %polly.adjust_ub75
  br i1 %polly.loop_cond76, label %polly.loop_header69, label %polly.loop_exit71
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_gesummv(i32 %n, double %alpha, double %beta, [1300 x double]* %A, [1300 x double]* %B, double* %tmp, double* %x, double* %y) #0 {
.split:
  %A17 = bitcast [1300 x double]* %A to i8*
  %B18 = bitcast [1300 x double]* %B to i8*
  %tmp20 = bitcast double* %tmp to i8*
  %x23 = bitcast double* %x to i8*
  %y26 = bitcast double* %y to i8*
  %y25 = ptrtoint double* %y to i64
  %x22 = ptrtoint double* %x to i64
  %tmp19 = ptrtoint double* %tmp to i64
  %B16 = ptrtoint [1300 x double]* %B to i64
  %A15 = ptrtoint [1300 x double]* %A to i64
  %0 = zext i32 %n to i64
  %1 = add i64 %0, -1
  %2 = mul i64 10400, %1
  %3 = add i64 %A15, %2
  %4 = mul i64 8, %1
  %5 = add i64 %3, %4
  %6 = inttoptr i64 %5 to i8*
  %7 = add i64 %B16, %2
  %8 = add i64 %7, %4
  %9 = inttoptr i64 %8 to i8*
  %10 = icmp ult i8* %6, %B18
  %11 = icmp ult i8* %9, %A17
  %pair-no-alias = or i1 %10, %11
  %12 = add i64 %tmp19, %4
  %13 = inttoptr i64 %12 to i8*
  %14 = icmp ult i8* %6, %tmp20
  %15 = icmp ult i8* %13, %A17
  %pair-no-alias21 = or i1 %14, %15
  %16 = and i1 %pair-no-alias, %pair-no-alias21
  %17 = add i64 %x22, %4
  %18 = inttoptr i64 %17 to i8*
  %19 = icmp ult i8* %6, %x23
  %20 = icmp ult i8* %18, %A17
  %pair-no-alias24 = or i1 %19, %20
  %21 = and i1 %16, %pair-no-alias24
  %22 = add i64 %y25, %4
  %23 = inttoptr i64 %22 to i8*
  %24 = icmp ult i8* %6, %y26
  %25 = icmp ult i8* %23, %A17
  %pair-no-alias27 = or i1 %24, %25
  %26 = and i1 %21, %pair-no-alias27
  %27 = icmp ult i8* %9, %tmp20
  %28 = icmp ult i8* %13, %B18
  %pair-no-alias28 = or i1 %27, %28
  %29 = and i1 %26, %pair-no-alias28
  %30 = icmp ult i8* %9, %x23
  %31 = icmp ult i8* %18, %B18
  %pair-no-alias29 = or i1 %30, %31
  %32 = and i1 %29, %pair-no-alias29
  %33 = icmp ult i8* %9, %y26
  %34 = icmp ult i8* %23, %B18
  %pair-no-alias30 = or i1 %33, %34
  %35 = and i1 %32, %pair-no-alias30
  %36 = icmp ult i8* %13, %x23
  %37 = icmp ult i8* %18, %tmp20
  %pair-no-alias31 = or i1 %36, %37
  %38 = and i1 %35, %pair-no-alias31
  %39 = icmp ult i8* %13, %y26
  %40 = icmp ult i8* %23, %tmp20
  %pair-no-alias32 = or i1 %39, %40
  %41 = and i1 %38, %pair-no-alias32
  %42 = icmp ult i8* %18, %y26
  %43 = icmp ult i8* %23, %x23
  %pair-no-alias33 = or i1 %42, %43
  %44 = and i1 %41, %pair-no-alias33
  br i1 %44, label %polly.start, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  %45 = icmp sgt i32 %n, 0
  br i1 %45, label %.lr.ph4.clone, label %.region.clone

.lr.ph4.clone:                                    ; preds = %.split.split.clone
  br label %46

; <label>:46                                      ; preds = %._crit_edge.clone, %.lr.ph4.clone
  %indvar6.clone = phi i64 [ 0, %.lr.ph4.clone ], [ %indvar.next7.clone, %._crit_edge.clone ]
  %scevgep13.clone = getelementptr double* %tmp, i64 %indvar6.clone
  %scevgep14.clone = getelementptr double* %y, i64 %indvar6.clone
  store double 0.000000e+00, double* %scevgep13.clone, align 8, !tbaa !1
  store double 0.000000e+00, double* %scevgep14.clone, align 8, !tbaa !1
  br i1 %45, label %.lr.ph.clone, label %._crit_edge.clone

.lr.ph.clone:                                     ; preds = %46, %.lr.ph.clone
  %indvar.clone = phi i64 [ %indvar.next.clone, %.lr.ph.clone ], [ 0, %46 ]
  %scevgep9.clone = getelementptr [1300 x double]* %B, i64 %indvar6.clone, i64 %indvar.clone
  %scevgep.clone = getelementptr [1300 x double]* %A, i64 %indvar6.clone, i64 %indvar.clone
  %scevgep8.clone = getelementptr double* %x, i64 %indvar.clone
  %47 = load double* %scevgep.clone, align 8, !tbaa !1
  %48 = load double* %scevgep8.clone, align 8, !tbaa !1
  %49 = fmul double %47, %48
  %50 = load double* %scevgep13.clone, align 8, !tbaa !1
  %51 = fadd double %49, %50
  store double %51, double* %scevgep13.clone, align 8, !tbaa !1
  %52 = load double* %scevgep9.clone, align 8, !tbaa !1
  %53 = load double* %scevgep8.clone, align 8, !tbaa !1
  %54 = fmul double %52, %53
  %55 = load double* %scevgep14.clone, align 8, !tbaa !1
  %56 = fadd double %54, %55
  store double %56, double* %scevgep14.clone, align 8, !tbaa !1
  %indvar.next.clone = add i64 %indvar.clone, 1
  %exitcond.clone = icmp ne i64 %indvar.next.clone, %0
  br i1 %exitcond.clone, label %.lr.ph.clone, label %._crit_edge.clone

._crit_edge.clone:                                ; preds = %.lr.ph.clone, %46
  %57 = load double* %scevgep13.clone, align 8, !tbaa !1
  %58 = fmul double %57, %alpha
  %59 = load double* %scevgep14.clone, align 8, !tbaa !1
  %60 = fmul double %59, %beta
  %61 = fadd double %58, %60
  store double %61, double* %scevgep14.clone, align 8, !tbaa !1
  %indvar.next7.clone = add i64 %indvar6.clone, 1
  %exitcond10.clone = icmp ne i64 %indvar.next7.clone, %0
  br i1 %exitcond10.clone, label %46, label %.region.clone

.region.clone:                                    ; preds = %polly.loop_exit41, %polly.loop_header84, %polly.start, %.split.split.clone, %._crit_edge.clone
  ret void

polly.start:                                      ; preds = %.split
  %62 = sext i32 %n to i64
  %63 = icmp sge i64 %62, 1
  %64 = icmp sge i64 %0, 1
  %65 = and i1 %63, %64
  br i1 %65, label %polly.then, label %.region.clone

polly.then:                                       ; preds = %polly.start
  %polly.loop_guard = icmp sle i64 0, %1
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.loop_exit

polly.loop_exit:                                  ; preds = %polly.loop_header, %polly.then
  br i1 %polly.loop_guard, label %polly.loop_header39, label %polly.loop_exit41

polly.loop_exit41:                                ; preds = %polly.loop_exit50, %polly.loop_exit
  br i1 %polly.loop_guard, label %polly.loop_header84, label %.region.clone

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_scevgep13 = getelementptr double* %tmp, i64 %polly.indvar
  %p_scevgep14 = getelementptr double* %y, i64 %polly.indvar
  store double 0.000000e+00, double* %p_scevgep13
  store double 0.000000e+00, double* %p_scevgep14
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %1, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.loop_exit

polly.loop_header39:                              ; preds = %polly.loop_exit, %polly.loop_exit50
  %polly.indvar43 = phi i64 [ %polly.indvar_next44, %polly.loop_exit50 ], [ 0, %polly.loop_exit ]
  br i1 %polly.loop_guard, label %polly.loop_header48, label %polly.loop_exit50

polly.loop_exit50:                                ; preds = %polly.loop_exit59, %polly.loop_header39
  %polly.indvar_next44 = add nsw i64 %polly.indvar43, 32
  %polly.adjust_ub45 = sub i64 %1, 32
  %polly.loop_cond46 = icmp sle i64 %polly.indvar43, %polly.adjust_ub45
  br i1 %polly.loop_cond46, label %polly.loop_header39, label %polly.loop_exit41

polly.loop_header48:                              ; preds = %polly.loop_header39, %polly.loop_exit59
  %polly.indvar52 = phi i64 [ %polly.indvar_next53, %polly.loop_exit59 ], [ 0, %polly.loop_header39 ]
  %66 = add i64 %polly.indvar43, 31
  %67 = icmp slt i64 %66, %1
  %68 = select i1 %67, i64 %66, i64 %1
  %polly.loop_guard60 = icmp sle i64 %polly.indvar43, %68
  br i1 %polly.loop_guard60, label %polly.loop_header57, label %polly.loop_exit59

polly.loop_exit59:                                ; preds = %polly.loop_exit68, %polly.loop_header48
  %polly.indvar_next53 = add nsw i64 %polly.indvar52, 32
  %polly.adjust_ub54 = sub i64 %1, 32
  %polly.loop_cond55 = icmp sle i64 %polly.indvar52, %polly.adjust_ub54
  br i1 %polly.loop_cond55, label %polly.loop_header48, label %polly.loop_exit50

polly.loop_header57:                              ; preds = %polly.loop_header48, %polly.loop_exit68
  %polly.indvar61 = phi i64 [ %polly.indvar_next62, %polly.loop_exit68 ], [ %polly.indvar43, %polly.loop_header48 ]
  %69 = add i64 %polly.indvar52, 31
  %70 = icmp slt i64 %69, %1
  %71 = select i1 %70, i64 %69, i64 %1
  %polly.loop_guard69 = icmp sle i64 %polly.indvar52, %71
  br i1 %polly.loop_guard69, label %polly.loop_header66, label %polly.loop_exit68

polly.loop_exit68:                                ; preds = %polly.loop_header66, %polly.loop_header57
  %polly.indvar_next62 = add nsw i64 %polly.indvar61, 1
  %polly.adjust_ub63 = sub i64 %68, 1
  %polly.loop_cond64 = icmp sle i64 %polly.indvar61, %polly.adjust_ub63
  br i1 %polly.loop_cond64, label %polly.loop_header57, label %polly.loop_exit59

polly.loop_header66:                              ; preds = %polly.loop_header57, %polly.loop_header66
  %polly.indvar70 = phi i64 [ %polly.indvar_next71, %polly.loop_header66 ], [ %polly.indvar52, %polly.loop_header57 ]
  %p_scevgep13.moved.to. = getelementptr double* %tmp, i64 %polly.indvar61
  %p_scevgep14.moved.to. = getelementptr double* %y, i64 %polly.indvar61
  %p_scevgep9 = getelementptr [1300 x double]* %B, i64 %polly.indvar61, i64 %polly.indvar70
  %p_scevgep = getelementptr [1300 x double]* %A, i64 %polly.indvar61, i64 %polly.indvar70
  %p_scevgep8 = getelementptr double* %x, i64 %polly.indvar70
  %_p_scalar_ = load double* %p_scevgep
  %_p_scalar_75 = load double* %p_scevgep8
  %p_ = fmul double %_p_scalar_, %_p_scalar_75
  %_p_scalar_76 = load double* %p_scevgep13.moved.to.
  %p_77 = fadd double %p_, %_p_scalar_76
  store double %p_77, double* %p_scevgep13.moved.to.
  %_p_scalar_78 = load double* %p_scevgep9
  %_p_scalar_79 = load double* %p_scevgep8
  %p_80 = fmul double %_p_scalar_78, %_p_scalar_79
  %_p_scalar_81 = load double* %p_scevgep14.moved.to.
  %p_82 = fadd double %p_80, %_p_scalar_81
  store double %p_82, double* %p_scevgep14.moved.to.
  %p_indvar.next = add i64 %polly.indvar70, 1
  %polly.indvar_next71 = add nsw i64 %polly.indvar70, 1
  %polly.adjust_ub72 = sub i64 %71, 1
  %polly.loop_cond73 = icmp sle i64 %polly.indvar70, %polly.adjust_ub72
  br i1 %polly.loop_cond73, label %polly.loop_header66, label %polly.loop_exit68

polly.loop_header84:                              ; preds = %polly.loop_exit41, %polly.loop_header84
  %polly.indvar88 = phi i64 [ %polly.indvar_next89, %polly.loop_header84 ], [ 0, %polly.loop_exit41 ]
  %p_scevgep13.moved.to.35 = getelementptr double* %tmp, i64 %polly.indvar88
  %p_scevgep14.moved.to.36 = getelementptr double* %y, i64 %polly.indvar88
  %_p_scalar_93 = load double* %p_scevgep13.moved.to.35
  %p_94 = fmul double %_p_scalar_93, %alpha
  %_p_scalar_95 = load double* %p_scevgep14.moved.to.36
  %p_96 = fmul double %_p_scalar_95, %beta
  %p_97 = fadd double %p_94, %p_96
  store double %p_97, double* %p_scevgep14.moved.to.36
  %p_indvar.next7 = add i64 %polly.indvar88, 1
  %polly.indvar_next89 = add nsw i64 %polly.indvar88, 1
  %polly.adjust_ub90 = sub i64 %1, 1
  %polly.loop_cond91 = icmp sle i64 %polly.indvar88, %polly.adjust_ub90
  br i1 %polly.loop_cond91, label %polly.loop_header84, label %.region.clone
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, double* %y) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %n, 0
  br i1 %5, label %.lr.ph, label %16

.lr.ph:                                           ; preds = %.split
  %6 = zext i32 %n to i64
  br label %7

; <label>:7                                       ; preds = %.lr.ph, %12
  %indvar = phi i64 [ 0, %.lr.ph ], [ %indvar.next, %12 ]
  %i.01 = trunc i64 %indvar to i32
  %scevgep = getelementptr double* %y, i64 %indvar
  %8 = srem i32 %i.01, 20
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %10, label %12

; <label>:10                                      ; preds = %7
  %11 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %11) #4
  br label %12

; <label>:12                                      ; preds = %10, %7
  %13 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %14 = load double* %scevgep, align 8, !tbaa !1
  %15 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %13, i8* getelementptr inbounds ([8 x i8]* @.str5, i64 0, i64 0), double %14) #5
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %6
  br i1 %exitcond, label %7, label %._crit_edge

._crit_edge:                                      ; preds = %12
  br label %16

; <label>:16                                      ; preds = %._crit_edge, %.split
  %17 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %18 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %17, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %19 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %20 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str7, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %19) #4
  ret void
}

; Function Attrs: nounwind
declare void @free(i8*) #2

declare i32 @fprintf(%struct._IO_FILE*, i8*, ...) #1

declare i8* @gcg_getBasePtr(i8* nocapture readonly)

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
