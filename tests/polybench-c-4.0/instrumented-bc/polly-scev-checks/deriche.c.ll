; ModuleID = './medley/deriche/deriche.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [7 x i8] c"imgOut\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [7 x i8] c"%0.2f \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %alpha = alloca float, align 4
  %0 = tail call i8* @polybench_alloc_data(i64 8847360, i32 4) #3
  %1 = tail call i8* @polybench_alloc_data(i64 8847360, i32 4) #3
  %2 = tail call i8* @polybench_alloc_data(i64 8847360, i32 4) #3
  %3 = tail call i8* @polybench_alloc_data(i64 8847360, i32 4) #3
  %4 = bitcast i8* %0 to [2160 x float]*
  %5 = bitcast i8* %1 to [2160 x float]*
  call void @init_array(i32 4096, i32 2160, float* %alpha, [2160 x float]* %4, [2160 x float]* %5)
  call void (...)* @polybench_timer_start() #3
  %6 = load float* %alpha, align 4, !tbaa !1
  %7 = bitcast i8* %2 to [2160 x float]*
  %8 = bitcast i8* %3 to [2160 x float]*
  call void @kernel_deriche(i32 4096, i32 2160, float %6, [2160 x float]* %4, [2160 x float]* %5, [2160 x float]* %7, [2160 x float]* %8)
  call void (...)* @polybench_timer_stop() #3
  call void (...)* @polybench_timer_print() #3
  %9 = icmp sgt i32 %argc, 42
  br i1 %9, label %10, label %14

; <label>:10                                      ; preds = %.split
  %11 = load i8** %argv, align 8, !tbaa !5
  %12 = load i8* %11, align 1, !tbaa !7
  %phitmp = icmp eq i8 %12, 0
  br i1 %phitmp, label %13, label %14

; <label>:13                                      ; preds = %10
  call void @print_array(i32 4096, i32 2160, [2160 x float]* %5)
  br label %14

; <label>:14                                      ; preds = %10, %13, %.split
  call void @free(i8* %0) #3
  call void @free(i8* %1) #3
  call void @free(i8* %2) #3
  call void @free(i8* %3) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %w, i32 %h, float* %alpha, [2160 x float]* %imgIn, [2160 x float]* %imgOut) #0 {
.split:
  %alpha10 = bitcast float* %alpha to i8*
  %imgIn11 = bitcast [2160 x float]* %imgIn to i8*
  %imgIn9 = ptrtoint [2160 x float]* %imgIn to i64
  %0 = zext i32 %w to i64
  %1 = add i64 %0, -1
  %2 = mul i64 8640, %1
  %3 = add i64 %imgIn9, %2
  %4 = zext i32 %h to i64
  %5 = add i64 %4, -1
  %6 = mul i64 4, %5
  %7 = add i64 %3, %6
  %8 = inttoptr i64 %7 to i8*
  %9 = icmp ult i8* %alpha10, %imgIn11
  %10 = icmp ult i8* %8, %alpha10
  %pair-no-alias = or i1 %9, %10
  br i1 %pair-no-alias, label %polly.start, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  store float 2.500000e-01, float* %alpha, align 4, !tbaa !1
  %11 = icmp sgt i32 %w, 0
  br i1 %11, label %.preheader.lr.ph.clone, label %.region.clone

.preheader.lr.ph.clone:                           ; preds = %.split.split.clone
  %12 = sext i32 %h to i64
  %13 = icmp sge i64 %12, 1
  %14 = icmp sge i64 %0, 1
  %15 = and i1 %13, %14
  %16 = icmp sge i64 %4, 1
  %17 = and i1 %15, %16
  br i1 %17, label %polly.then53, label %.region.clone

.region.clone:                                    ; preds = %polly.then53, %polly.loop_exit66, %.preheader.lr.ph.clone, %.split.split.clone, %polly.stmt..split.split
  ret void

polly.start:                                      ; preds = %.split
  %18 = sext i32 %h to i64
  %19 = icmp sge i64 %18, 1
  %20 = icmp sge i64 %0, 1
  %21 = and i1 %19, %20
  %22 = icmp sge i64 %4, 1
  %23 = and i1 %21, %22
  %24 = sext i32 %w to i64
  %25 = icmp sge i64 %24, 1
  %26 = and i1 %23, %25
  br i1 %26, label %polly.then, label %polly.stmt..split.split

polly.stmt..split.split:                          ; preds = %polly.then, %polly.loop_exit18, %polly.start
  store float 2.500000e-01, float* %alpha
  br label %.region.clone

polly.then:                                       ; preds = %polly.start
  %polly.loop_guard = icmp sle i64 0, %1
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.stmt..split.split

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit18
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit18 ], [ 0, %polly.then ]
  %27 = mul i64 -3, %0
  %28 = add i64 %27, %4
  %29 = add i64 %28, 5
  %30 = sub i64 %29, 32
  %31 = add i64 %30, 1
  %32 = icmp slt i64 %29, 0
  %33 = select i1 %32, i64 %31, i64 %29
  %34 = sdiv i64 %33, 32
  %35 = mul i64 -32, %34
  %36 = mul i64 -32, %0
  %37 = add i64 %35, %36
  %38 = mul i64 -32, %polly.indvar
  %39 = mul i64 -3, %polly.indvar
  %40 = add i64 %39, %4
  %41 = add i64 %40, 5
  %42 = sub i64 %41, 32
  %43 = add i64 %42, 1
  %44 = icmp slt i64 %41, 0
  %45 = select i1 %44, i64 %43, i64 %41
  %46 = sdiv i64 %45, 32
  %47 = mul i64 -32, %46
  %48 = add i64 %38, %47
  %49 = add i64 %48, -640
  %50 = icmp sgt i64 %37, %49
  %51 = select i1 %50, i64 %37, i64 %49
  %52 = mul i64 -20, %polly.indvar
  %polly.loop_guard19 = icmp sle i64 %51, %52
  br i1 %polly.loop_guard19, label %polly.loop_header16, label %polly.loop_exit18

polly.loop_exit18:                                ; preds = %polly.loop_exit27, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %1, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.stmt..split.split

polly.loop_header16:                              ; preds = %polly.loop_header, %polly.loop_exit27
  %polly.indvar20 = phi i64 [ %polly.indvar_next21, %polly.loop_exit27 ], [ %51, %polly.loop_header ]
  %53 = mul i64 -1, %polly.indvar20
  %54 = mul i64 -1, %4
  %55 = add i64 %53, %54
  %56 = add i64 %55, -30
  %57 = add i64 %56, 20
  %58 = sub i64 %57, 1
  %59 = icmp slt i64 %56, 0
  %60 = select i1 %59, i64 %56, i64 %58
  %61 = sdiv i64 %60, 20
  %62 = icmp sgt i64 %61, %polly.indvar
  %63 = select i1 %62, i64 %61, i64 %polly.indvar
  %64 = sub i64 %53, 20
  %65 = add i64 %64, 1
  %66 = icmp slt i64 %53, 0
  %67 = select i1 %66, i64 %65, i64 %53
  %68 = sdiv i64 %67, 20
  %69 = add i64 %polly.indvar, 31
  %70 = icmp slt i64 %68, %69
  %71 = select i1 %70, i64 %68, i64 %69
  %72 = icmp slt i64 %71, %1
  %73 = select i1 %72, i64 %71, i64 %1
  %polly.loop_guard28 = icmp sle i64 %63, %73
  br i1 %polly.loop_guard28, label %polly.loop_header25, label %polly.loop_exit27

polly.loop_exit27:                                ; preds = %polly.loop_exit36, %polly.loop_header16
  %polly.indvar_next21 = add nsw i64 %polly.indvar20, 32
  %polly.adjust_ub22 = sub i64 %52, 32
  %polly.loop_cond23 = icmp sle i64 %polly.indvar20, %polly.adjust_ub22
  br i1 %polly.loop_cond23, label %polly.loop_header16, label %polly.loop_exit18

polly.loop_header25:                              ; preds = %polly.loop_header16, %polly.loop_exit36
  %polly.indvar29 = phi i64 [ %polly.indvar_next30, %polly.loop_exit36 ], [ %63, %polly.loop_header16 ]
  %74 = mul i64 -20, %polly.indvar29
  %75 = add i64 %74, %54
  %76 = add i64 %75, 1
  %77 = icmp sgt i64 %polly.indvar20, %76
  %78 = select i1 %77, i64 %polly.indvar20, i64 %76
  %79 = add i64 %polly.indvar20, 31
  %80 = icmp slt i64 %74, %79
  %81 = select i1 %80, i64 %74, i64 %79
  %polly.loop_guard37 = icmp sle i64 %78, %81
  br i1 %polly.loop_guard37, label %polly.loop_header34, label %polly.loop_exit36

polly.loop_exit36:                                ; preds = %polly.loop_header34, %polly.loop_header25
  %polly.indvar_next30 = add nsw i64 %polly.indvar29, 1
  %polly.adjust_ub31 = sub i64 %73, 1
  %polly.loop_cond32 = icmp sle i64 %polly.indvar29, %polly.adjust_ub31
  br i1 %polly.loop_cond32, label %polly.loop_header25, label %polly.loop_exit27

polly.loop_header34:                              ; preds = %polly.loop_header25, %polly.loop_header34
  %polly.indvar38 = phi i64 [ %polly.indvar_next39, %polly.loop_header34 ], [ %78, %polly.loop_header25 ]
  %82 = mul i64 -1, %polly.indvar38
  %83 = add i64 %74, %82
  %p_.moved.to.12 = mul i64 %polly.indvar29, 313
  %p_ = mul i64 %83, 991
  %p_42 = add i64 %p_.moved.to.12, %p_
  %p_43 = trunc i64 %p_42 to i32
  %p_scevgep = getelementptr [2160 x float]* %imgIn, i64 %polly.indvar29, i64 %83
  %p_44 = srem i32 %p_43, 65536
  %p_45 = sitofp i32 %p_44 to float
  %p_46 = fdiv float %p_45, 6.553500e+04
  store float %p_46, float* %p_scevgep
  %p_indvar.next = add i64 %83, 1
  %polly.indvar_next39 = add nsw i64 %polly.indvar38, 1
  %polly.adjust_ub40 = sub i64 %81, 1
  %polly.loop_cond41 = icmp sle i64 %polly.indvar38, %polly.adjust_ub40
  br i1 %polly.loop_cond41, label %polly.loop_header34, label %polly.loop_exit36

polly.then53:                                     ; preds = %.preheader.lr.ph.clone
  %polly.loop_guard58 = icmp sle i64 0, %1
  br i1 %polly.loop_guard58, label %polly.loop_header55, label %.region.clone

polly.loop_header55:                              ; preds = %polly.then53, %polly.loop_exit66
  %polly.indvar59 = phi i64 [ %polly.indvar_next60, %polly.loop_exit66 ], [ 0, %polly.then53 ]
  %84 = mul i64 -3, %0
  %85 = add i64 %84, %4
  %86 = add i64 %85, 5
  %87 = sub i64 %86, 32
  %88 = add i64 %87, 1
  %89 = icmp slt i64 %86, 0
  %90 = select i1 %89, i64 %88, i64 %86
  %91 = sdiv i64 %90, 32
  %92 = mul i64 -32, %91
  %93 = mul i64 -32, %0
  %94 = add i64 %92, %93
  %95 = mul i64 -32, %polly.indvar59
  %96 = mul i64 -3, %polly.indvar59
  %97 = add i64 %96, %4
  %98 = add i64 %97, 5
  %99 = sub i64 %98, 32
  %100 = add i64 %99, 1
  %101 = icmp slt i64 %98, 0
  %102 = select i1 %101, i64 %100, i64 %98
  %103 = sdiv i64 %102, 32
  %104 = mul i64 -32, %103
  %105 = add i64 %95, %104
  %106 = add i64 %105, -640
  %107 = icmp sgt i64 %94, %106
  %108 = select i1 %107, i64 %94, i64 %106
  %109 = mul i64 -20, %polly.indvar59
  %polly.loop_guard67 = icmp sle i64 %108, %109
  br i1 %polly.loop_guard67, label %polly.loop_header64, label %polly.loop_exit66

polly.loop_exit66:                                ; preds = %polly.loop_exit75, %polly.loop_header55
  %polly.indvar_next60 = add nsw i64 %polly.indvar59, 32
  %polly.adjust_ub61 = sub i64 %1, 32
  %polly.loop_cond62 = icmp sle i64 %polly.indvar59, %polly.adjust_ub61
  br i1 %polly.loop_cond62, label %polly.loop_header55, label %.region.clone

polly.loop_header64:                              ; preds = %polly.loop_header55, %polly.loop_exit75
  %polly.indvar68 = phi i64 [ %polly.indvar_next69, %polly.loop_exit75 ], [ %108, %polly.loop_header55 ]
  %110 = mul i64 -1, %polly.indvar68
  %111 = mul i64 -1, %4
  %112 = add i64 %110, %111
  %113 = add i64 %112, -30
  %114 = add i64 %113, 20
  %115 = sub i64 %114, 1
  %116 = icmp slt i64 %113, 0
  %117 = select i1 %116, i64 %113, i64 %115
  %118 = sdiv i64 %117, 20
  %119 = icmp sgt i64 %118, %polly.indvar59
  %120 = select i1 %119, i64 %118, i64 %polly.indvar59
  %121 = sub i64 %110, 20
  %122 = add i64 %121, 1
  %123 = icmp slt i64 %110, 0
  %124 = select i1 %123, i64 %122, i64 %110
  %125 = sdiv i64 %124, 20
  %126 = add i64 %polly.indvar59, 31
  %127 = icmp slt i64 %125, %126
  %128 = select i1 %127, i64 %125, i64 %126
  %129 = icmp slt i64 %128, %1
  %130 = select i1 %129, i64 %128, i64 %1
  %polly.loop_guard76 = icmp sle i64 %120, %130
  br i1 %polly.loop_guard76, label %polly.loop_header73, label %polly.loop_exit75

polly.loop_exit75:                                ; preds = %polly.loop_exit84, %polly.loop_header64
  %polly.indvar_next69 = add nsw i64 %polly.indvar68, 32
  %polly.adjust_ub70 = sub i64 %109, 32
  %polly.loop_cond71 = icmp sle i64 %polly.indvar68, %polly.adjust_ub70
  br i1 %polly.loop_cond71, label %polly.loop_header64, label %polly.loop_exit66

polly.loop_header73:                              ; preds = %polly.loop_header64, %polly.loop_exit84
  %polly.indvar77 = phi i64 [ %polly.indvar_next78, %polly.loop_exit84 ], [ %120, %polly.loop_header64 ]
  %131 = mul i64 -20, %polly.indvar77
  %132 = add i64 %131, %111
  %133 = add i64 %132, 1
  %134 = icmp sgt i64 %polly.indvar68, %133
  %135 = select i1 %134, i64 %polly.indvar68, i64 %133
  %136 = add i64 %polly.indvar68, 31
  %137 = icmp slt i64 %131, %136
  %138 = select i1 %137, i64 %131, i64 %136
  %polly.loop_guard85 = icmp sle i64 %135, %138
  br i1 %polly.loop_guard85, label %polly.loop_header82, label %polly.loop_exit84

polly.loop_exit84:                                ; preds = %polly.loop_header82, %polly.loop_header73
  %polly.indvar_next78 = add nsw i64 %polly.indvar77, 1
  %polly.adjust_ub79 = sub i64 %130, 1
  %polly.loop_cond80 = icmp sle i64 %polly.indvar77, %polly.adjust_ub79
  br i1 %polly.loop_cond80, label %polly.loop_header73, label %polly.loop_exit75

polly.loop_header82:                              ; preds = %polly.loop_header73, %polly.loop_header82
  %polly.indvar86 = phi i64 [ %polly.indvar_next87, %polly.loop_header82 ], [ %135, %polly.loop_header73 ]
  %139 = mul i64 -1, %polly.indvar86
  %140 = add i64 %131, %139
  %p_.moved.to. = mul i64 %polly.indvar77, 313
  %p_91 = mul i64 %140, 991
  %p_92 = add i64 %p_.moved.to., %p_91
  %p_93 = trunc i64 %p_92 to i32
  %p_scevgep.clone = getelementptr [2160 x float]* %imgIn, i64 %polly.indvar77, i64 %140
  %p_94 = srem i32 %p_93, 65536
  %p_95 = sitofp i32 %p_94 to float
  %p_96 = fdiv float %p_95, 6.553500e+04
  store float %p_96, float* %p_scevgep.clone
  %p_indvar.next.clone = add i64 %140, 1
  %polly.indvar_next87 = add nsw i64 %polly.indvar86, 1
  %polly.adjust_ub88 = sub i64 %138, 1
  %polly.loop_cond89 = icmp sle i64 %polly.indvar86, %polly.adjust_ub88
  br i1 %polly.loop_cond89, label %polly.loop_header82, label %polly.loop_exit84
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_deriche(i32 %w, i32 %h, float %alpha, [2160 x float]* %imgIn, [2160 x float]* %imgOut, [2160 x float]* %y1, [2160 x float]* %y2) #0 {
.split:
  %imgIn112 = bitcast [2160 x float]* %imgIn to i8*
  %imgOut124 = bitcast [2160 x float]* %imgOut to i8*
  %y1113 = bitcast [2160 x float]* %y1 to i8*
  %y2127 = bitcast [2160 x float]* %y2 to i8*
  %y2126 = ptrtoint [2160 x float]* %y2 to i64
  %y1111 = ptrtoint [2160 x float]* %y1 to i64
  %imgOut123 = ptrtoint [2160 x float]* %imgOut to i64
  %imgIn110 = ptrtoint [2160 x float]* %imgIn to i64
  %0 = fsub float -0.000000e+00, %alpha
  %1 = tail call float @expf(float %0) #3
  %2 = fsub float 1.000000e+00, %1
  %3 = tail call float @expf(float %0) #3
  %4 = fsub float 1.000000e+00, %3
  %5 = fmul float %2, %4
  %6 = fmul float %alpha, 2.000000e+00
  %7 = tail call float @expf(float %0) #3
  %8 = fmul float %6, %7
  %9 = fadd float %8, 1.000000e+00
  %10 = tail call float @expf(float %6) #3
  %11 = fsub float %9, %10
  %12 = fdiv float %5, %11
  %13 = tail call float @expf(float %0) #3
  %14 = fmul float %12, %13
  %15 = fadd float %alpha, -1.000000e+00
  %16 = fmul float %15, %14
  %17 = tail call float @expf(float %0) #3
  %18 = fmul float %12, %17
  %19 = fadd float %alpha, 1.000000e+00
  %20 = fmul float %19, %18
  %21 = fmul float %alpha, -2.000000e+00
  %22 = tail call float @expf(float %21) #3
  %23 = fmul float %12, %22
  %24 = fsub float -0.000000e+00, %23
  %exp2f = tail call float @exp2f(float %0) #2
  %25 = tail call float @expf(float %21) #3
  %26 = fsub float -0.000000e+00, %25
  %27 = icmp sgt i32 %w, 0
  br i1 %27, label %.preheader10.lr.ph, label %.preheader9

.preheader10.lr.ph:                               ; preds = %.split
  %28 = zext i32 %h to i64
  %29 = zext i32 %w to i64
  %30 = icmp sgt i32 %h, 0
  %31 = add i64 %29, -1
  %32 = mul i64 8640, %31
  %33 = add i64 %imgIn110, %32
  %34 = add i64 %28, -1
  %35 = mul i64 4, %34
  %36 = add i64 %33, %35
  %37 = inttoptr i64 %36 to i8*
  %38 = add i64 %y1111, %32
  %39 = add i64 %38, %35
  %40 = inttoptr i64 %39 to i8*
  %41 = icmp ult i8* %37, %y1113
  %42 = icmp ult i8* %40, %imgIn112
  %pair-no-alias = or i1 %41, %42
  br i1 %pair-no-alias, label %polly.start390, label %.preheader10.clone

.preheader10.clone:                               ; preds = %.preheader10.lr.ph, %._crit_edge48.clone
  %indvar103.clone = phi i64 [ 0, %.preheader10.lr.ph ], [ %indvar.next104.clone, %._crit_edge48.clone ]
  br i1 %30, label %.lr.ph47.clone, label %._crit_edge48.clone

.lr.ph47.clone:                                   ; preds = %.preheader10.clone
  br label %43

; <label>:43                                      ; preds = %43, %.lr.ph47.clone
  %ym2.046.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph47.clone ], [ %ym1.043.reg2mem.0, %43 ]
  %xm1.044.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph47.clone ], [ %52, %43 ]
  %ym1.043.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph47.clone ], [ %51, %43 ]
  %indvar100.clone = phi i64 [ 0, %.lr.ph47.clone ], [ %indvar.next101.clone, %43 ]
  %scevgep106.clone = getelementptr [2160 x float]* %y1, i64 %indvar103.clone, i64 %indvar100.clone
  %scevgep105.clone = getelementptr [2160 x float]* %imgIn, i64 %indvar103.clone, i64 %indvar100.clone
  %44 = load float* %scevgep105.clone, align 4, !tbaa !1
  %45 = fmul float %12, %44
  %46 = fmul float %16, %xm1.044.reg2mem.0
  %47 = fadd float %46, %45
  %48 = fmul float %exp2f, %ym1.043.reg2mem.0
  %49 = fadd float %48, %47
  %50 = fmul float %ym2.046.reg2mem.0, %26
  %51 = fadd float %50, %49
  store float %51, float* %scevgep106.clone, align 4, !tbaa !1
  %52 = load float* %scevgep105.clone, align 4, !tbaa !1
  %indvar.next101.clone = add i64 %indvar100.clone, 1
  %exitcond102.clone = icmp ne i64 %indvar.next101.clone, %28
  br i1 %exitcond102.clone, label %43, label %._crit_edge48.clone

._crit_edge48.clone:                              ; preds = %43, %.preheader10.clone
  %indvar.next104.clone = add i64 %indvar103.clone, 1
  %exitcond107.clone = icmp ne i64 %indvar.next104.clone, %29
  br i1 %exitcond107.clone, label %.preheader10.clone, label %.preheader9

.preheader9:                                      ; preds = %polly.then429, %polly.loop_header431, %polly.cond427, %polly.start390, %._crit_edge48.clone, %.split
  %53 = sext i32 %h to i64
  %54 = add i64 %53, -1
  %scevgep114 = getelementptr [2160 x float]* %imgIn, i64 0, i64 %54
  %scevgep114120 = bitcast float* %scevgep114 to i8*
  %scevgep115116 = ptrtoint float* %scevgep114 to i64
  %55 = zext i32 %w to i64
  %56 = add i64 %55, -1
  %57 = mul i64 8640, %56
  %58 = add i64 %scevgep115116, %57
  %59 = zext i32 %h to i64
  %60 = add i64 %59, -1
  %61 = mul i64 -4, %60
  %62 = add i64 %58, %61
  %63 = inttoptr i64 %62 to i8*
  %scevgep117 = getelementptr [2160 x float]* %y2, i64 0, i64 %54
  %scevgep117121 = bitcast float* %scevgep117 to i8*
  %scevgep118119 = ptrtoint float* %scevgep117 to i64
  %64 = add i64 %scevgep118119, %57
  %65 = add i64 %64, %61
  %66 = inttoptr i64 %65 to i8*
  %67 = icmp ult i8* %63, %scevgep117121
  %68 = icmp ult i8* %66, %scevgep114120
  %pair-no-alias122 = or i1 %67, %68
  br i1 %pair-no-alias122, label %polly.start338, label %.preheader9.split.clone

.preheader9.split.clone:                          ; preds = %.preheader9
  br i1 %27, label %.preheader8.lr.ph.clone, label %.preheader7

.preheader8.lr.ph.clone:                          ; preds = %.preheader9.split.clone
  %69 = icmp sgt i32 %h, 0
  br label %.preheader8.clone

.preheader8.clone:                                ; preds = %._crit_edge41.clone, %.preheader8.lr.ph.clone
  %indvar93.clone = phi i64 [ 0, %.preheader8.lr.ph.clone ], [ %indvar.next94.clone, %._crit_edge41.clone ]
  br i1 %69, label %.lr.ph40.clone, label %._crit_edge41.clone

.lr.ph40.clone:                                   ; preds = %.preheader8.clone
  br label %70

; <label>:70                                      ; preds = %70, %.lr.ph40.clone
  %yp2.038.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph40.clone ], [ %yp1.037.reg2mem.0, %70 ]
  %yp1.037.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph40.clone ], [ %79, %70 ]
  %xp2.036.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph40.clone ], [ %xp1.035.reg2mem.0, %70 ]
  %xp1.035.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph40.clone ], [ %80, %70 ]
  %indvar90.clone = phi i64 [ 0, %.lr.ph40.clone ], [ %indvar.next91.clone, %70 ]
  %71 = mul i64 %indvar90.clone, -1
  %72 = add i64 %54, %71
  %scevgep96.clone = getelementptr [2160 x float]* %imgIn, i64 %indvar93.clone, i64 %72
  %scevgep95.clone = getelementptr [2160 x float]* %y2, i64 %indvar93.clone, i64 %72
  %73 = fmul float %20, %xp1.035.reg2mem.0
  %74 = fmul float %xp2.036.reg2mem.0, %24
  %75 = fadd float %73, %74
  %76 = fmul float %exp2f, %yp1.037.reg2mem.0
  %77 = fadd float %75, %76
  %78 = fmul float %yp2.038.reg2mem.0, %26
  %79 = fadd float %77, %78
  store float %79, float* %scevgep95.clone, align 4, !tbaa !1
  %80 = load float* %scevgep96.clone, align 4, !tbaa !1
  %indvar.next91.clone = add i64 %indvar90.clone, 1
  %exitcond92.clone = icmp ne i64 %indvar.next91.clone, %59
  br i1 %exitcond92.clone, label %70, label %._crit_edge41.clone

._crit_edge41.clone:                              ; preds = %70, %.preheader8.clone
  %indvar.next94.clone = add i64 %indvar93.clone, 1
  %exitcond97.clone = icmp ne i64 %indvar.next94.clone, %55
  br i1 %exitcond97.clone, label %.preheader8.clone, label %.preheader7

.preheader7:                                      ; preds = %polly.then378, %polly.loop_header380, %polly.cond376, %polly.start338, %.preheader9.split.clone, %._crit_edge41.clone
  %81 = add i64 %imgOut123, %57
  %82 = mul i64 4, %60
  %83 = add i64 %81, %82
  %84 = inttoptr i64 %83 to i8*
  %85 = add i64 %y1111, %57
  %86 = add i64 %85, %82
  %87 = inttoptr i64 %86 to i8*
  %88 = icmp ult i8* %84, %y1113
  %89 = icmp ult i8* %87, %imgOut124
  %pair-no-alias125 = or i1 %88, %89
  %90 = add i64 %y2126, %57
  %91 = add i64 %90, %82
  %92 = inttoptr i64 %91 to i8*
  %93 = icmp ult i8* %84, %y2127
  %94 = icmp ult i8* %92, %imgOut124
  %pair-no-alias128 = or i1 %93, %94
  %95 = and i1 %pair-no-alias125, %pair-no-alias128
  %96 = icmp ult i8* %87, %y2127
  %97 = icmp ult i8* %92, %y1113
  %pair-no-alias129 = or i1 %96, %97
  %98 = and i1 %95, %pair-no-alias129
  br i1 %98, label %polly.start292, label %.preheader7.split.clone

.preheader7.split.clone:                          ; preds = %.preheader7
  br i1 %27, label %.preheader6.lr.ph.clone, label %.preheader5

.preheader6.lr.ph.clone:                          ; preds = %.preheader7.split.clone
  %99 = icmp sgt i32 %h, 0
  br label %.preheader6.clone

.preheader6.clone:                                ; preds = %._crit_edge32.clone, %.preheader6.lr.ph.clone
  %indvar81.clone = phi i64 [ 0, %.preheader6.lr.ph.clone ], [ %indvar.next82.clone, %._crit_edge32.clone ]
  br i1 %99, label %.lr.ph31.clone, label %._crit_edge32.clone

.lr.ph31.clone:                                   ; preds = %.preheader6.clone, %.lr.ph31.clone
  %indvar78.clone = phi i64 [ %indvar.next79.clone, %.lr.ph31.clone ], [ 0, %.preheader6.clone ]
  %scevgep85.clone = getelementptr [2160 x float]* %imgOut, i64 %indvar81.clone, i64 %indvar78.clone
  %scevgep84.clone = getelementptr [2160 x float]* %y2, i64 %indvar81.clone, i64 %indvar78.clone
  %scevgep83.clone = getelementptr [2160 x float]* %y1, i64 %indvar81.clone, i64 %indvar78.clone
  %100 = load float* %scevgep83.clone, align 4, !tbaa !1
  %101 = load float* %scevgep84.clone, align 4, !tbaa !1
  %102 = fadd float %100, %101
  store float %102, float* %scevgep85.clone, align 4, !tbaa !1
  %indvar.next79.clone = add i64 %indvar78.clone, 1
  %exitcond80.clone = icmp ne i64 %indvar.next79.clone, %59
  br i1 %exitcond80.clone, label %.lr.ph31.clone, label %._crit_edge32.clone

._crit_edge32.clone:                              ; preds = %.lr.ph31.clone, %.preheader6.clone
  %indvar.next82.clone = add i64 %indvar81.clone, 1
  %exitcond86.clone = icmp ne i64 %indvar.next82.clone, %55
  br i1 %exitcond86.clone, label %.preheader6.clone, label %.preheader5

.preheader5:                                      ; preds = %polly.then296, %polly.loop_exit309, %polly.start292, %.preheader7.split.clone, %._crit_edge32.clone
  %103 = add i64 %imgOut123, %82
  %104 = add i64 %103, %57
  %105 = inttoptr i64 %104 to i8*
  %106 = add i64 %y1111, %82
  %107 = add i64 %106, %57
  %108 = inttoptr i64 %107 to i8*
  %109 = icmp ult i8* %105, %y1113
  %110 = icmp ult i8* %108, %imgOut124
  %pair-no-alias130 = or i1 %109, %110
  br i1 %pair-no-alias130, label %polly.start241, label %.preheader5.split.clone

.preheader5.split.clone:                          ; preds = %.preheader5
  %111 = icmp sgt i32 %h, 0
  br i1 %111, label %.preheader4.lr.ph.clone, label %.preheader3

.preheader4.lr.ph.clone:                          ; preds = %.preheader5.split.clone
  br label %.preheader4.clone

.preheader4.clone:                                ; preds = %._crit_edge28.clone, %.preheader4.lr.ph.clone
  %indvar71.clone = phi i64 [ 0, %.preheader4.lr.ph.clone ], [ %indvar.next72.clone, %._crit_edge28.clone ]
  br i1 %27, label %.lr.ph27.clone, label %._crit_edge28.clone

.lr.ph27.clone:                                   ; preds = %.preheader4.clone
  br label %112

; <label>:112                                     ; preds = %112, %.lr.ph27.clone
  %ym2.126.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph27.clone ], [ %ym1.123.reg2mem.0, %112 ]
  %tm1.024.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph27.clone ], [ %121, %112 ]
  %ym1.123.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph27.clone ], [ %120, %112 ]
  %indvar68.clone = phi i64 [ 0, %.lr.ph27.clone ], [ %indvar.next69.clone, %112 ]
  %scevgep74.clone = getelementptr [2160 x float]* %y1, i64 %indvar68.clone, i64 %indvar71.clone
  %scevgep73.clone = getelementptr [2160 x float]* %imgOut, i64 %indvar68.clone, i64 %indvar71.clone
  %113 = load float* %scevgep73.clone, align 4, !tbaa !1
  %114 = fmul float %12, %113
  %115 = fmul float %16, %tm1.024.reg2mem.0
  %116 = fadd float %115, %114
  %117 = fmul float %exp2f, %ym1.123.reg2mem.0
  %118 = fadd float %117, %116
  %119 = fmul float %ym2.126.reg2mem.0, %26
  %120 = fadd float %119, %118
  store float %120, float* %scevgep74.clone, align 4, !tbaa !1
  %121 = load float* %scevgep73.clone, align 4, !tbaa !1
  %indvar.next69.clone = add i64 %indvar68.clone, 1
  %exitcond70.clone = icmp ne i64 %indvar.next69.clone, %55
  br i1 %exitcond70.clone, label %112, label %._crit_edge28.clone

._crit_edge28.clone:                              ; preds = %112, %.preheader4.clone
  %indvar.next72.clone = add i64 %indvar71.clone, 1
  %exitcond75.clone = icmp ne i64 %indvar.next72.clone, %59
  br i1 %exitcond75.clone, label %.preheader4.clone, label %.preheader3

.preheader3:                                      ; preds = %polly.then280, %polly.loop_header282, %polly.cond278, %polly.start241, %.preheader5.split.clone, %._crit_edge28.clone
  %122 = sext i32 %w to i64
  %123 = add i64 %122, -1
  %scevgep131 = getelementptr [2160 x float]* %imgOut, i64 %123, i64 0
  %scevgep131137 = bitcast float* %scevgep131 to i8*
  %scevgep132133 = ptrtoint float* %scevgep131 to i64
  %124 = add i64 %scevgep132133, %82
  %125 = mul i64 -8640, %56
  %126 = add i64 %124, %125
  %127 = inttoptr i64 %126 to i8*
  %scevgep134 = getelementptr [2160 x float]* %y2, i64 %123, i64 0
  %scevgep134138 = bitcast float* %scevgep134 to i8*
  %scevgep135136 = ptrtoint float* %scevgep134 to i64
  %128 = add i64 %scevgep135136, %82
  %129 = add i64 %128, %125
  %130 = inttoptr i64 %129 to i8*
  %131 = icmp ult i8* %127, %scevgep134138
  %132 = icmp ult i8* %130, %scevgep131137
  %pair-no-alias139 = or i1 %131, %132
  br i1 %pair-no-alias139, label %polly.start189, label %.preheader3.split.clone

.preheader3.split.clone:                          ; preds = %.preheader3
  %133 = icmp sgt i32 %h, 0
  br i1 %133, label %.preheader2.lr.ph.clone, label %.preheader1

.preheader2.lr.ph.clone:                          ; preds = %.preheader3.split.clone
  br label %.preheader2.clone

.preheader2.clone:                                ; preds = %._crit_edge21.clone, %.preheader2.lr.ph.clone
  %indvar61.clone = phi i64 [ 0, %.preheader2.lr.ph.clone ], [ %indvar.next62.clone, %._crit_edge21.clone ]
  br i1 %27, label %.lr.ph20.clone, label %._crit_edge21.clone

.lr.ph20.clone:                                   ; preds = %.preheader2.clone
  br label %134

; <label>:134                                     ; preds = %134, %.lr.ph20.clone
  %yp2.118.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph20.clone ], [ %yp1.117.reg2mem.0, %134 ]
  %yp1.117.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph20.clone ], [ %143, %134 ]
  %tp2.016.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph20.clone ], [ %tp1.015.reg2mem.0, %134 ]
  %tp1.015.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph20.clone ], [ %144, %134 ]
  %indvar58.clone = phi i64 [ 0, %.lr.ph20.clone ], [ %indvar.next59.clone, %134 ]
  %135 = mul i64 %indvar58.clone, -1
  %136 = add i64 %123, %135
  %scevgep64.clone = getelementptr [2160 x float]* %imgOut, i64 %136, i64 %indvar61.clone
  %scevgep63.clone = getelementptr [2160 x float]* %y2, i64 %136, i64 %indvar61.clone
  %137 = fmul float %20, %tp1.015.reg2mem.0
  %138 = fmul float %tp2.016.reg2mem.0, %24
  %139 = fadd float %137, %138
  %140 = fmul float %exp2f, %yp1.117.reg2mem.0
  %141 = fadd float %139, %140
  %142 = fmul float %yp2.118.reg2mem.0, %26
  %143 = fadd float %141, %142
  store float %143, float* %scevgep63.clone, align 4, !tbaa !1
  %144 = load float* %scevgep64.clone, align 4, !tbaa !1
  %indvar.next59.clone = add i64 %indvar58.clone, 1
  %exitcond60.clone = icmp ne i64 %indvar.next59.clone, %55
  br i1 %exitcond60.clone, label %134, label %._crit_edge21.clone

._crit_edge21.clone:                              ; preds = %134, %.preheader2.clone
  %indvar.next62.clone = add i64 %indvar61.clone, 1
  %exitcond65.clone = icmp ne i64 %indvar.next62.clone, %59
  br i1 %exitcond65.clone, label %.preheader2.clone, label %.preheader1

.preheader1:                                      ; preds = %polly.then229, %polly.loop_header231, %polly.cond227, %polly.start189, %.preheader3.split.clone, %._crit_edge21.clone
  br i1 %98, label %polly.start, label %.preheader1.split.clone

.preheader1.split.clone:                          ; preds = %.preheader1
  br i1 %27, label %.preheader.lr.ph.clone, label %.region.clone

.preheader.lr.ph.clone:                           ; preds = %.preheader1.split.clone
  %145 = icmp sgt i32 %h, 0
  br label %.preheader.clone

.preheader.clone:                                 ; preds = %._crit_edge.clone, %.preheader.lr.ph.clone
  %indvar50.clone = phi i64 [ 0, %.preheader.lr.ph.clone ], [ %indvar.next51.clone, %._crit_edge.clone ]
  br i1 %145, label %.lr.ph.clone, label %._crit_edge.clone

.lr.ph.clone:                                     ; preds = %.preheader.clone, %.lr.ph.clone
  %indvar.clone = phi i64 [ %indvar.next.clone, %.lr.ph.clone ], [ 0, %.preheader.clone ]
  %scevgep53.clone = getelementptr [2160 x float]* %imgOut, i64 %indvar50.clone, i64 %indvar.clone
  %scevgep52.clone = getelementptr [2160 x float]* %y2, i64 %indvar50.clone, i64 %indvar.clone
  %scevgep.clone = getelementptr [2160 x float]* %y1, i64 %indvar50.clone, i64 %indvar.clone
  %146 = load float* %scevgep.clone, align 4, !tbaa !1
  %147 = load float* %scevgep52.clone, align 4, !tbaa !1
  %148 = fadd float %146, %147
  store float %148, float* %scevgep53.clone, align 4, !tbaa !1
  %indvar.next.clone = add i64 %indvar.clone, 1
  %exitcond.clone = icmp ne i64 %indvar.next.clone, %59
  br i1 %exitcond.clone, label %.lr.ph.clone, label %._crit_edge.clone

._crit_edge.clone:                                ; preds = %.lr.ph.clone, %.preheader.clone
  %indvar.next51.clone = add i64 %indvar50.clone, 1
  %exitcond54.clone = icmp ne i64 %indvar.next51.clone, %55
  br i1 %exitcond54.clone, label %.preheader.clone, label %.region.clone

.region.clone:                                    ; preds = %polly.then, %polly.loop_exit163, %polly.start, %.preheader1.split.clone, %._crit_edge.clone
  ret void

polly.start:                                      ; preds = %.preheader1
  %149 = icmp sge i64 %53, 1
  %150 = icmp sge i64 %55, 1
  %151 = and i1 %149, %150
  %152 = icmp sge i64 %59, 1
  %153 = and i1 %151, %152
  %154 = icmp sge i64 %122, 1
  %155 = and i1 %153, %154
  br i1 %155, label %polly.then, label %.region.clone

polly.then:                                       ; preds = %polly.start
  %polly.loop_guard = icmp sle i64 0, %56
  br i1 %polly.loop_guard, label %polly.loop_header, label %.region.clone

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit163
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit163 ], [ 0, %polly.then ]
  %156 = mul i64 -3, %55
  %157 = add i64 %156, %59
  %158 = add i64 %157, 5
  %159 = sub i64 %158, 32
  %160 = add i64 %159, 1
  %161 = icmp slt i64 %158, 0
  %162 = select i1 %161, i64 %160, i64 %158
  %163 = sdiv i64 %162, 32
  %164 = mul i64 -32, %163
  %165 = mul i64 -32, %55
  %166 = add i64 %164, %165
  %167 = mul i64 -32, %polly.indvar
  %168 = mul i64 -3, %polly.indvar
  %169 = add i64 %168, %59
  %170 = add i64 %169, 5
  %171 = sub i64 %170, 32
  %172 = add i64 %171, 1
  %173 = icmp slt i64 %170, 0
  %174 = select i1 %173, i64 %172, i64 %170
  %175 = sdiv i64 %174, 32
  %176 = mul i64 -32, %175
  %177 = add i64 %167, %176
  %178 = add i64 %177, -640
  %179 = icmp sgt i64 %166, %178
  %180 = select i1 %179, i64 %166, i64 %178
  %181 = mul i64 -20, %polly.indvar
  %polly.loop_guard164 = icmp sle i64 %180, %181
  br i1 %polly.loop_guard164, label %polly.loop_header161, label %polly.loop_exit163

polly.loop_exit163:                               ; preds = %polly.loop_exit172, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %56, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %.region.clone

polly.loop_header161:                             ; preds = %polly.loop_header, %polly.loop_exit172
  %polly.indvar165 = phi i64 [ %polly.indvar_next166, %polly.loop_exit172 ], [ %180, %polly.loop_header ]
  %182 = mul i64 -1, %polly.indvar165
  %183 = mul i64 -1, %59
  %184 = add i64 %182, %183
  %185 = add i64 %184, -30
  %186 = add i64 %185, 20
  %187 = sub i64 %186, 1
  %188 = icmp slt i64 %185, 0
  %189 = select i1 %188, i64 %185, i64 %187
  %190 = sdiv i64 %189, 20
  %191 = icmp sgt i64 %190, %polly.indvar
  %192 = select i1 %191, i64 %190, i64 %polly.indvar
  %193 = sub i64 %182, 20
  %194 = add i64 %193, 1
  %195 = icmp slt i64 %182, 0
  %196 = select i1 %195, i64 %194, i64 %182
  %197 = sdiv i64 %196, 20
  %198 = add i64 %polly.indvar, 31
  %199 = icmp slt i64 %197, %198
  %200 = select i1 %199, i64 %197, i64 %198
  %201 = icmp slt i64 %200, %56
  %202 = select i1 %201, i64 %200, i64 %56
  %polly.loop_guard173 = icmp sle i64 %192, %202
  br i1 %polly.loop_guard173, label %polly.loop_header170, label %polly.loop_exit172

polly.loop_exit172:                               ; preds = %polly.loop_exit181, %polly.loop_header161
  %polly.indvar_next166 = add nsw i64 %polly.indvar165, 32
  %polly.adjust_ub167 = sub i64 %181, 32
  %polly.loop_cond168 = icmp sle i64 %polly.indvar165, %polly.adjust_ub167
  br i1 %polly.loop_cond168, label %polly.loop_header161, label %polly.loop_exit163

polly.loop_header170:                             ; preds = %polly.loop_header161, %polly.loop_exit181
  %polly.indvar174 = phi i64 [ %polly.indvar_next175, %polly.loop_exit181 ], [ %192, %polly.loop_header161 ]
  %203 = mul i64 -20, %polly.indvar174
  %204 = add i64 %203, %183
  %205 = add i64 %204, 1
  %206 = icmp sgt i64 %polly.indvar165, %205
  %207 = select i1 %206, i64 %polly.indvar165, i64 %205
  %208 = add i64 %polly.indvar165, 31
  %209 = icmp slt i64 %203, %208
  %210 = select i1 %209, i64 %203, i64 %208
  %polly.loop_guard182 = icmp sle i64 %207, %210
  br i1 %polly.loop_guard182, label %polly.loop_header179, label %polly.loop_exit181

polly.loop_exit181:                               ; preds = %polly.loop_header179, %polly.loop_header170
  %polly.indvar_next175 = add nsw i64 %polly.indvar174, 1
  %polly.adjust_ub176 = sub i64 %202, 1
  %polly.loop_cond177 = icmp sle i64 %polly.indvar174, %polly.adjust_ub176
  br i1 %polly.loop_cond177, label %polly.loop_header170, label %polly.loop_exit172

polly.loop_header179:                             ; preds = %polly.loop_header170, %polly.loop_header179
  %polly.indvar183 = phi i64 [ %polly.indvar_next184, %polly.loop_header179 ], [ %207, %polly.loop_header170 ]
  %211 = mul i64 -1, %polly.indvar183
  %212 = add i64 %203, %211
  %p_scevgep53 = getelementptr [2160 x float]* %imgOut, i64 %polly.indvar174, i64 %212
  %p_scevgep52 = getelementptr [2160 x float]* %y2, i64 %polly.indvar174, i64 %212
  %p_scevgep = getelementptr [2160 x float]* %y1, i64 %polly.indvar174, i64 %212
  %_p_scalar_ = load float* %p_scevgep
  %_p_scalar_187 = load float* %p_scevgep52
  %p_ = fadd float %_p_scalar_, %_p_scalar_187
  store float %p_, float* %p_scevgep53
  %p_indvar.next = add i64 %212, 1
  %polly.indvar_next184 = add nsw i64 %polly.indvar183, 1
  %polly.adjust_ub185 = sub i64 %210, 1
  %polly.loop_cond186 = icmp sle i64 %polly.indvar183, %polly.adjust_ub185
  br i1 %polly.loop_cond186, label %polly.loop_header179, label %polly.loop_exit181

polly.start189:                                   ; preds = %.preheader3
  %213 = icmp sge i64 %53, 1
  %214 = icmp sge i64 %59, 1
  %215 = and i1 %213, %214
  %216 = icmp sge i64 %122, 1
  %217 = and i1 %215, %216
  br i1 %217, label %polly.cond194, label %.preheader1

polly.cond194:                                    ; preds = %polly.start189
  %218 = icmp sge i64 %55, 1
  br i1 %218, label %polly.then196, label %polly.cond227

polly.cond227:                                    ; preds = %polly.then196, %polly.loop_exit209, %polly.cond194
  %219 = icmp sle i64 %55, 0
  br i1 %219, label %polly.then229, label %.preheader1

polly.then196:                                    ; preds = %polly.cond194
  %polly.loop_guard201 = icmp sle i64 0, %60
  br i1 %polly.loop_guard201, label %polly.loop_header198, label %polly.cond227

polly.loop_header198:                             ; preds = %polly.then196, %polly.loop_exit209
  %polly.indvar202 = phi i64 [ %polly.indvar_next203, %polly.loop_exit209 ], [ 0, %polly.then196 ]
  %polly.loop_guard210 = icmp sle i64 0, %56
  br i1 %polly.loop_guard210, label %polly.loop_header207, label %polly.loop_exit209

polly.loop_exit209:                               ; preds = %polly.loop_header207, %polly.loop_header198
  %polly.indvar_next203 = add nsw i64 %polly.indvar202, 1
  %polly.adjust_ub204 = sub i64 %60, 1
  %polly.loop_cond205 = icmp sle i64 %polly.indvar202, %polly.adjust_ub204
  br i1 %polly.loop_cond205, label %polly.loop_header198, label %polly.cond227

polly.loop_header207:                             ; preds = %polly.loop_header198, %polly.loop_header207
  %yp2.118.reg2mem.1 = phi float [ 0.000000e+00, %polly.loop_header198 ], [ %yp1.117.reg2mem.1, %polly.loop_header207 ]
  %yp1.117.reg2mem.1 = phi float [ 0.000000e+00, %polly.loop_header198 ], [ %p_224, %polly.loop_header207 ]
  %tp2.016.reg2mem.1 = phi float [ 0.000000e+00, %polly.loop_header198 ], [ %tp1.015.reg2mem.1, %polly.loop_header207 ]
  %tp1.015.reg2mem.1 = phi float [ 0.000000e+00, %polly.loop_header198 ], [ %_p_scalar_226, %polly.loop_header207 ]
  %polly.indvar211 = phi i64 [ %polly.indvar_next212, %polly.loop_header207 ], [ 0, %polly.loop_header198 ]
  %p_216 = mul i64 %polly.indvar211, -1
  %p_217 = add i64 %123, %p_216
  %p_scevgep64 = getelementptr [2160 x float]* %imgOut, i64 %p_217, i64 %polly.indvar202
  %p_scevgep63 = getelementptr [2160 x float]* %y2, i64 %p_217, i64 %polly.indvar202
  %p_218 = fmul float %20, %tp1.015.reg2mem.1
  %p_219 = fmul float %tp2.016.reg2mem.1, %24
  %p_220 = fadd float %p_218, %p_219
  %p_221 = fmul float %exp2f, %yp1.117.reg2mem.1
  %p_222 = fadd float %p_220, %p_221
  %p_223 = fmul float %yp2.118.reg2mem.1, %26
  %p_224 = fadd float %p_222, %p_223
  store float %p_224, float* %p_scevgep63
  %_p_scalar_226 = load float* %p_scevgep64
  %p_indvar.next59 = add i64 %polly.indvar211, 1
  %polly.indvar_next212 = add nsw i64 %polly.indvar211, 1
  %polly.adjust_ub213 = sub i64 %56, 1
  %polly.loop_cond214 = icmp sle i64 %polly.indvar211, %polly.adjust_ub213
  br i1 %polly.loop_cond214, label %polly.loop_header207, label %polly.loop_exit209

polly.then229:                                    ; preds = %polly.cond227
  %polly.loop_guard234 = icmp sle i64 0, %60
  br i1 %polly.loop_guard234, label %polly.loop_header231, label %.preheader1

polly.loop_header231:                             ; preds = %polly.then229, %polly.loop_header231
  %polly.indvar235 = phi i64 [ %polly.indvar_next236, %polly.loop_header231 ], [ 0, %polly.then229 ]
  %polly.indvar_next236 = add nsw i64 %polly.indvar235, 1
  %polly.adjust_ub237 = sub i64 %60, 1
  %polly.loop_cond238 = icmp sle i64 %polly.indvar235, %polly.adjust_ub237
  br i1 %polly.loop_cond238, label %polly.loop_header231, label %.preheader1

polly.start241:                                   ; preds = %.preheader5
  %220 = icmp sge i64 %53, 1
  %221 = icmp sge i64 %59, 1
  %222 = and i1 %220, %221
  %223 = sext i32 %w to i64
  %224 = icmp sge i64 %223, 1
  %225 = and i1 %222, %224
  br i1 %225, label %polly.cond246, label %.preheader3

polly.cond246:                                    ; preds = %polly.start241
  %226 = icmp sge i64 %55, 1
  br i1 %226, label %polly.then248, label %polly.cond278

polly.cond278:                                    ; preds = %polly.then248, %polly.loop_exit261, %polly.cond246
  %227 = icmp sle i64 %55, 0
  br i1 %227, label %polly.then280, label %.preheader3

polly.then248:                                    ; preds = %polly.cond246
  %polly.loop_guard253 = icmp sle i64 0, %60
  br i1 %polly.loop_guard253, label %polly.loop_header250, label %polly.cond278

polly.loop_header250:                             ; preds = %polly.then248, %polly.loop_exit261
  %polly.indvar254 = phi i64 [ %polly.indvar_next255, %polly.loop_exit261 ], [ 0, %polly.then248 ]
  %polly.loop_guard262 = icmp sle i64 0, %56
  br i1 %polly.loop_guard262, label %polly.loop_header259, label %polly.loop_exit261

polly.loop_exit261:                               ; preds = %polly.loop_header259, %polly.loop_header250
  %polly.indvar_next255 = add nsw i64 %polly.indvar254, 1
  %polly.adjust_ub256 = sub i64 %60, 1
  %polly.loop_cond257 = icmp sle i64 %polly.indvar254, %polly.adjust_ub256
  br i1 %polly.loop_cond257, label %polly.loop_header250, label %polly.cond278

polly.loop_header259:                             ; preds = %polly.loop_header250, %polly.loop_header259
  %ym2.126.reg2mem.1 = phi float [ 0.000000e+00, %polly.loop_header250 ], [ %ym1.123.reg2mem.1, %polly.loop_header259 ]
  %tm1.024.reg2mem.1 = phi float [ 0.000000e+00, %polly.loop_header250 ], [ %_p_scalar_277, %polly.loop_header259 ]
  %ym1.123.reg2mem.1 = phi float [ 0.000000e+00, %polly.loop_header250 ], [ %p_275, %polly.loop_header259 ]
  %polly.indvar263 = phi i64 [ %polly.indvar_next264, %polly.loop_header259 ], [ 0, %polly.loop_header250 ]
  %p_scevgep74 = getelementptr [2160 x float]* %y1, i64 %polly.indvar263, i64 %polly.indvar254
  %p_scevgep73 = getelementptr [2160 x float]* %imgOut, i64 %polly.indvar263, i64 %polly.indvar254
  %_p_scalar_268 = load float* %p_scevgep73
  %p_269 = fmul float %12, %_p_scalar_268
  %p_270 = fmul float %16, %tm1.024.reg2mem.1
  %p_271 = fadd float %p_270, %p_269
  %p_272 = fmul float %exp2f, %ym1.123.reg2mem.1
  %p_273 = fadd float %p_272, %p_271
  %p_274 = fmul float %ym2.126.reg2mem.1, %26
  %p_275 = fadd float %p_274, %p_273
  store float %p_275, float* %p_scevgep74
  %_p_scalar_277 = load float* %p_scevgep73
  %p_indvar.next69 = add i64 %polly.indvar263, 1
  %polly.indvar_next264 = add nsw i64 %polly.indvar263, 1
  %polly.adjust_ub265 = sub i64 %56, 1
  %polly.loop_cond266 = icmp sle i64 %polly.indvar263, %polly.adjust_ub265
  br i1 %polly.loop_cond266, label %polly.loop_header259, label %polly.loop_exit261

polly.then280:                                    ; preds = %polly.cond278
  %polly.loop_guard285 = icmp sle i64 0, %60
  br i1 %polly.loop_guard285, label %polly.loop_header282, label %.preheader3

polly.loop_header282:                             ; preds = %polly.then280, %polly.loop_header282
  %polly.indvar286 = phi i64 [ %polly.indvar_next287, %polly.loop_header282 ], [ 0, %polly.then280 ]
  %polly.indvar_next287 = add nsw i64 %polly.indvar286, 1
  %polly.adjust_ub288 = sub i64 %60, 1
  %polly.loop_cond289 = icmp sle i64 %polly.indvar286, %polly.adjust_ub288
  br i1 %polly.loop_cond289, label %polly.loop_header282, label %.preheader3

polly.start292:                                   ; preds = %.preheader7
  %228 = icmp sge i64 %53, 1
  %229 = icmp sge i64 %55, 1
  %230 = and i1 %228, %229
  %231 = icmp sge i64 %59, 1
  %232 = and i1 %230, %231
  %233 = sext i32 %w to i64
  %234 = icmp sge i64 %233, 1
  %235 = and i1 %232, %234
  br i1 %235, label %polly.then296, label %.preheader5

polly.then296:                                    ; preds = %polly.start292
  %polly.loop_guard301 = icmp sle i64 0, %56
  br i1 %polly.loop_guard301, label %polly.loop_header298, label %.preheader5

polly.loop_header298:                             ; preds = %polly.then296, %polly.loop_exit309
  %polly.indvar302 = phi i64 [ %polly.indvar_next303, %polly.loop_exit309 ], [ 0, %polly.then296 ]
  %236 = mul i64 -3, %55
  %237 = add i64 %236, %59
  %238 = add i64 %237, 5
  %239 = sub i64 %238, 32
  %240 = add i64 %239, 1
  %241 = icmp slt i64 %238, 0
  %242 = select i1 %241, i64 %240, i64 %238
  %243 = sdiv i64 %242, 32
  %244 = mul i64 -32, %243
  %245 = mul i64 -32, %55
  %246 = add i64 %244, %245
  %247 = mul i64 -32, %polly.indvar302
  %248 = mul i64 -3, %polly.indvar302
  %249 = add i64 %248, %59
  %250 = add i64 %249, 5
  %251 = sub i64 %250, 32
  %252 = add i64 %251, 1
  %253 = icmp slt i64 %250, 0
  %254 = select i1 %253, i64 %252, i64 %250
  %255 = sdiv i64 %254, 32
  %256 = mul i64 -32, %255
  %257 = add i64 %247, %256
  %258 = add i64 %257, -640
  %259 = icmp sgt i64 %246, %258
  %260 = select i1 %259, i64 %246, i64 %258
  %261 = mul i64 -20, %polly.indvar302
  %polly.loop_guard310 = icmp sle i64 %260, %261
  br i1 %polly.loop_guard310, label %polly.loop_header307, label %polly.loop_exit309

polly.loop_exit309:                               ; preds = %polly.loop_exit318, %polly.loop_header298
  %polly.indvar_next303 = add nsw i64 %polly.indvar302, 32
  %polly.adjust_ub304 = sub i64 %56, 32
  %polly.loop_cond305 = icmp sle i64 %polly.indvar302, %polly.adjust_ub304
  br i1 %polly.loop_cond305, label %polly.loop_header298, label %.preheader5

polly.loop_header307:                             ; preds = %polly.loop_header298, %polly.loop_exit318
  %polly.indvar311 = phi i64 [ %polly.indvar_next312, %polly.loop_exit318 ], [ %260, %polly.loop_header298 ]
  %262 = mul i64 -1, %polly.indvar311
  %263 = mul i64 -1, %59
  %264 = add i64 %262, %263
  %265 = add i64 %264, -30
  %266 = add i64 %265, 20
  %267 = sub i64 %266, 1
  %268 = icmp slt i64 %265, 0
  %269 = select i1 %268, i64 %265, i64 %267
  %270 = sdiv i64 %269, 20
  %271 = icmp sgt i64 %270, %polly.indvar302
  %272 = select i1 %271, i64 %270, i64 %polly.indvar302
  %273 = sub i64 %262, 20
  %274 = add i64 %273, 1
  %275 = icmp slt i64 %262, 0
  %276 = select i1 %275, i64 %274, i64 %262
  %277 = sdiv i64 %276, 20
  %278 = add i64 %polly.indvar302, 31
  %279 = icmp slt i64 %277, %278
  %280 = select i1 %279, i64 %277, i64 %278
  %281 = icmp slt i64 %280, %56
  %282 = select i1 %281, i64 %280, i64 %56
  %polly.loop_guard319 = icmp sle i64 %272, %282
  br i1 %polly.loop_guard319, label %polly.loop_header316, label %polly.loop_exit318

polly.loop_exit318:                               ; preds = %polly.loop_exit327, %polly.loop_header307
  %polly.indvar_next312 = add nsw i64 %polly.indvar311, 32
  %polly.adjust_ub313 = sub i64 %261, 32
  %polly.loop_cond314 = icmp sle i64 %polly.indvar311, %polly.adjust_ub313
  br i1 %polly.loop_cond314, label %polly.loop_header307, label %polly.loop_exit309

polly.loop_header316:                             ; preds = %polly.loop_header307, %polly.loop_exit327
  %polly.indvar320 = phi i64 [ %polly.indvar_next321, %polly.loop_exit327 ], [ %272, %polly.loop_header307 ]
  %283 = mul i64 -20, %polly.indvar320
  %284 = add i64 %283, %263
  %285 = add i64 %284, 1
  %286 = icmp sgt i64 %polly.indvar311, %285
  %287 = select i1 %286, i64 %polly.indvar311, i64 %285
  %288 = add i64 %polly.indvar311, 31
  %289 = icmp slt i64 %283, %288
  %290 = select i1 %289, i64 %283, i64 %288
  %polly.loop_guard328 = icmp sle i64 %287, %290
  br i1 %polly.loop_guard328, label %polly.loop_header325, label %polly.loop_exit327

polly.loop_exit327:                               ; preds = %polly.loop_header325, %polly.loop_header316
  %polly.indvar_next321 = add nsw i64 %polly.indvar320, 1
  %polly.adjust_ub322 = sub i64 %282, 1
  %polly.loop_cond323 = icmp sle i64 %polly.indvar320, %polly.adjust_ub322
  br i1 %polly.loop_cond323, label %polly.loop_header316, label %polly.loop_exit318

polly.loop_header325:                             ; preds = %polly.loop_header316, %polly.loop_header325
  %polly.indvar329 = phi i64 [ %polly.indvar_next330, %polly.loop_header325 ], [ %287, %polly.loop_header316 ]
  %291 = mul i64 -1, %polly.indvar329
  %292 = add i64 %283, %291
  %p_scevgep85 = getelementptr [2160 x float]* %imgOut, i64 %polly.indvar320, i64 %292
  %p_scevgep84 = getelementptr [2160 x float]* %y2, i64 %polly.indvar320, i64 %292
  %p_scevgep83 = getelementptr [2160 x float]* %y1, i64 %polly.indvar320, i64 %292
  %_p_scalar_334 = load float* %p_scevgep83
  %_p_scalar_335 = load float* %p_scevgep84
  %p_336 = fadd float %_p_scalar_334, %_p_scalar_335
  store float %p_336, float* %p_scevgep85
  %p_indvar.next79 = add i64 %292, 1
  %polly.indvar_next330 = add nsw i64 %polly.indvar329, 1
  %polly.adjust_ub331 = sub i64 %290, 1
  %polly.loop_cond332 = icmp sle i64 %polly.indvar329, %polly.adjust_ub331
  br i1 %polly.loop_cond332, label %polly.loop_header325, label %polly.loop_exit327

polly.start338:                                   ; preds = %.preheader9
  %293 = icmp sge i64 %53, 1
  %294 = icmp sge i64 %55, 1
  %295 = and i1 %293, %294
  %296 = sext i32 %w to i64
  %297 = icmp sge i64 %296, 1
  %298 = and i1 %295, %297
  br i1 %298, label %polly.cond343, label %.preheader7

polly.cond343:                                    ; preds = %polly.start338
  %299 = icmp sge i64 %59, 1
  br i1 %299, label %polly.then345, label %polly.cond376

polly.cond376:                                    ; preds = %polly.then345, %polly.loop_exit358, %polly.cond343
  %300 = icmp sle i64 %59, 0
  br i1 %300, label %polly.then378, label %.preheader7

polly.then345:                                    ; preds = %polly.cond343
  %polly.loop_guard350 = icmp sle i64 0, %56
  br i1 %polly.loop_guard350, label %polly.loop_header347, label %polly.cond376

polly.loop_header347:                             ; preds = %polly.then345, %polly.loop_exit358
  %polly.indvar351 = phi i64 [ %polly.indvar_next352, %polly.loop_exit358 ], [ 0, %polly.then345 ]
  %polly.loop_guard359 = icmp sle i64 0, %60
  br i1 %polly.loop_guard359, label %polly.loop_header356, label %polly.loop_exit358

polly.loop_exit358:                               ; preds = %polly.loop_header356, %polly.loop_header347
  %polly.indvar_next352 = add nsw i64 %polly.indvar351, 1
  %polly.adjust_ub353 = sub i64 %56, 1
  %polly.loop_cond354 = icmp sle i64 %polly.indvar351, %polly.adjust_ub353
  br i1 %polly.loop_cond354, label %polly.loop_header347, label %polly.cond376

polly.loop_header356:                             ; preds = %polly.loop_header347, %polly.loop_header356
  %yp2.038.reg2mem.1 = phi float [ 0.000000e+00, %polly.loop_header347 ], [ %yp1.037.reg2mem.1, %polly.loop_header356 ]
  %yp1.037.reg2mem.1 = phi float [ 0.000000e+00, %polly.loop_header347 ], [ %p_373, %polly.loop_header356 ]
  %xp2.036.reg2mem.1 = phi float [ 0.000000e+00, %polly.loop_header347 ], [ %xp1.035.reg2mem.1, %polly.loop_header356 ]
  %xp1.035.reg2mem.1 = phi float [ 0.000000e+00, %polly.loop_header347 ], [ %_p_scalar_375, %polly.loop_header356 ]
  %polly.indvar360 = phi i64 [ %polly.indvar_next361, %polly.loop_header356 ], [ 0, %polly.loop_header347 ]
  %p_365 = mul i64 %polly.indvar360, -1
  %p_366 = add i64 %54, %p_365
  %p_scevgep96 = getelementptr [2160 x float]* %imgIn, i64 %polly.indvar351, i64 %p_366
  %p_scevgep95 = getelementptr [2160 x float]* %y2, i64 %polly.indvar351, i64 %p_366
  %p_367 = fmul float %20, %xp1.035.reg2mem.1
  %p_368 = fmul float %xp2.036.reg2mem.1, %24
  %p_369 = fadd float %p_367, %p_368
  %p_370 = fmul float %exp2f, %yp1.037.reg2mem.1
  %p_371 = fadd float %p_369, %p_370
  %p_372 = fmul float %yp2.038.reg2mem.1, %26
  %p_373 = fadd float %p_371, %p_372
  store float %p_373, float* %p_scevgep95
  %_p_scalar_375 = load float* %p_scevgep96
  %p_indvar.next91 = add i64 %polly.indvar360, 1
  %polly.indvar_next361 = add nsw i64 %polly.indvar360, 1
  %polly.adjust_ub362 = sub i64 %60, 1
  %polly.loop_cond363 = icmp sle i64 %polly.indvar360, %polly.adjust_ub362
  br i1 %polly.loop_cond363, label %polly.loop_header356, label %polly.loop_exit358

polly.then378:                                    ; preds = %polly.cond376
  %polly.loop_guard383 = icmp sle i64 0, %56
  br i1 %polly.loop_guard383, label %polly.loop_header380, label %.preheader7

polly.loop_header380:                             ; preds = %polly.then378, %polly.loop_header380
  %polly.indvar384 = phi i64 [ %polly.indvar_next385, %polly.loop_header380 ], [ 0, %polly.then378 ]
  %polly.indvar_next385 = add nsw i64 %polly.indvar384, 1
  %polly.adjust_ub386 = sub i64 %56, 1
  %polly.loop_cond387 = icmp sle i64 %polly.indvar384, %polly.adjust_ub386
  br i1 %polly.loop_cond387, label %polly.loop_header380, label %.preheader7

polly.start390:                                   ; preds = %.preheader10.lr.ph
  %301 = sext i32 %h to i64
  %302 = icmp sge i64 %301, 1
  %303 = icmp sge i64 %29, 1
  %304 = and i1 %302, %303
  br i1 %304, label %polly.cond395, label %.preheader9

polly.cond395:                                    ; preds = %polly.start390
  %305 = icmp sge i64 %28, 1
  br i1 %305, label %polly.then397, label %polly.cond427

polly.cond427:                                    ; preds = %polly.then397, %polly.loop_exit410, %polly.cond395
  %306 = icmp sle i64 %28, 0
  br i1 %306, label %polly.then429, label %.preheader9

polly.then397:                                    ; preds = %polly.cond395
  %polly.loop_guard402 = icmp sle i64 0, %31
  br i1 %polly.loop_guard402, label %polly.loop_header399, label %polly.cond427

polly.loop_header399:                             ; preds = %polly.then397, %polly.loop_exit410
  %polly.indvar403 = phi i64 [ %polly.indvar_next404, %polly.loop_exit410 ], [ 0, %polly.then397 ]
  %polly.loop_guard411 = icmp sle i64 0, %34
  br i1 %polly.loop_guard411, label %polly.loop_header408, label %polly.loop_exit410

polly.loop_exit410:                               ; preds = %polly.loop_header408, %polly.loop_header399
  %polly.indvar_next404 = add nsw i64 %polly.indvar403, 1
  %polly.adjust_ub405 = sub i64 %31, 1
  %polly.loop_cond406 = icmp sle i64 %polly.indvar403, %polly.adjust_ub405
  br i1 %polly.loop_cond406, label %polly.loop_header399, label %polly.cond427

polly.loop_header408:                             ; preds = %polly.loop_header399, %polly.loop_header408
  %ym2.046.reg2mem.1 = phi float [ 0.000000e+00, %polly.loop_header399 ], [ %ym1.043.reg2mem.1, %polly.loop_header408 ]
  %xm1.044.reg2mem.1 = phi float [ 0.000000e+00, %polly.loop_header399 ], [ %_p_scalar_426, %polly.loop_header408 ]
  %ym1.043.reg2mem.1 = phi float [ 0.000000e+00, %polly.loop_header399 ], [ %p_424, %polly.loop_header408 ]
  %polly.indvar412 = phi i64 [ %polly.indvar_next413, %polly.loop_header408 ], [ 0, %polly.loop_header399 ]
  %p_scevgep106 = getelementptr [2160 x float]* %y1, i64 %polly.indvar403, i64 %polly.indvar412
  %p_scevgep105 = getelementptr [2160 x float]* %imgIn, i64 %polly.indvar403, i64 %polly.indvar412
  %_p_scalar_417 = load float* %p_scevgep105
  %p_418 = fmul float %12, %_p_scalar_417
  %p_419 = fmul float %16, %xm1.044.reg2mem.1
  %p_420 = fadd float %p_419, %p_418
  %p_421 = fmul float %exp2f, %ym1.043.reg2mem.1
  %p_422 = fadd float %p_421, %p_420
  %p_423 = fmul float %ym2.046.reg2mem.1, %26
  %p_424 = fadd float %p_423, %p_422
  store float %p_424, float* %p_scevgep106
  %_p_scalar_426 = load float* %p_scevgep105
  %p_indvar.next101 = add i64 %polly.indvar412, 1
  %polly.indvar_next413 = add nsw i64 %polly.indvar412, 1
  %polly.adjust_ub414 = sub i64 %34, 1
  %polly.loop_cond415 = icmp sle i64 %polly.indvar412, %polly.adjust_ub414
  br i1 %polly.loop_cond415, label %polly.loop_header408, label %polly.loop_exit410

polly.then429:                                    ; preds = %polly.cond427
  %polly.loop_guard434 = icmp sle i64 0, %31
  br i1 %polly.loop_guard434, label %polly.loop_header431, label %.preheader9

polly.loop_header431:                             ; preds = %polly.then429, %polly.loop_header431
  %polly.indvar435 = phi i64 [ %polly.indvar_next436, %polly.loop_header431 ], [ 0, %polly.then429 ]
  %polly.indvar_next436 = add nsw i64 %polly.indvar435, 1
  %polly.adjust_ub437 = sub i64 %31, 1
  %polly.loop_cond438 = icmp sle i64 %polly.indvar435, %polly.adjust_ub437
  br i1 %polly.loop_cond438, label %polly.loop_header431, label %.preheader9
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %w, i32 %h, [2160 x float]* %imgOut) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([7 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %w, 0
  br i1 %5, label %.preheader.lr.ph, label %24

.preheader.lr.ph:                                 ; preds = %.split
  %6 = zext i32 %h to i64
  %7 = zext i32 %w to i64
  %8 = zext i32 %h to i64
  %9 = icmp sgt i32 %h, 0
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %23
  %indvar4 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next5, %23 ]
  %10 = mul i64 %8, %indvar4
  br i1 %9, label %.lr.ph, label %23

.lr.ph:                                           ; preds = %.preheader
  br label %11

; <label>:11                                      ; preds = %.lr.ph, %18
  %indvar = phi i64 [ 0, %.lr.ph ], [ %indvar.next, %18 ]
  %12 = add i64 %10, %indvar
  %13 = trunc i64 %12 to i32
  %scevgep = getelementptr [2160 x float]* %imgOut, i64 %indvar4, i64 %indvar
  %14 = srem i32 %13, 20
  %15 = icmp eq i32 %14, 0
  br i1 %15, label %16, label %18

; <label>:16                                      ; preds = %11
  %17 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %17) #4
  br label %18

; <label>:18                                      ; preds = %16, %11
  %19 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %20 = load float* %scevgep, align 4, !tbaa !1
  %21 = fpext float %20 to double
  %22 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %19, i8* getelementptr inbounds ([7 x i8]* @.str5, i64 0, i64 0), double %21) #5
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %6
  br i1 %exitcond, label %11, label %._crit_edge

._crit_edge:                                      ; preds = %18
  br label %23

; <label>:23                                      ; preds = %._crit_edge, %.preheader
  %indvar.next5 = add i64 %indvar4, 1
  %exitcond6 = icmp ne i64 %indvar.next5, %7
  br i1 %exitcond6, label %.preheader, label %._crit_edge3

._crit_edge3:                                     ; preds = %23
  br label %24

; <label>:24                                      ; preds = %._crit_edge3, %.split
  %25 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %26 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %25, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([7 x i8]* @.str3, i64 0, i64 0)) #5
  %27 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %28 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str7, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %27) #4
  ret void
}

; Function Attrs: nounwind
declare void @free(i8*) #2

declare i32 @fprintf(%struct._IO_FILE*, i8*, ...) #1

; Function Attrs: nounwind
declare float @expf(float) #2

; Function Attrs: nounwind
declare float @powf(float, float) #2

declare i8* @gcg_getBasePtr(i8* nocapture readonly)

declare float @exp2f(float)

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
!2 = metadata !{metadata !"float", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{metadata !6, metadata !6, i64 0}
!6 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!7 = metadata !{metadata !3, metadata !3, i64 0}
