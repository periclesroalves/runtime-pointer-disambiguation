; ModuleID = './linear-algebra/kernels/mvt/mvt.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [3 x i8] c"x1\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [3 x i8] c"x2\00", align 1
@.str8 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %0 = tail call i8* @polybench_alloc_data(i64 4000000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %3 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %4 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %5 = bitcast i8* %1 to double*
  %6 = bitcast i8* %2 to double*
  %7 = bitcast i8* %3 to double*
  %8 = bitcast i8* %4 to double*
  %9 = bitcast i8* %0 to [2000 x double]*
  tail call void @init_array(i32 2000, double* %5, double* %6, double* %7, double* %8, [2000 x double]* %9)
  tail call void (...)* @polybench_timer_start() #3
  tail call void @kernel_mvt(i32 2000, double* %5, double* %6, double* %7, double* %8, [2000 x double]* %9)
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
  tail call void @print_array(i32 2000, double* %5, double* %6)
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
define internal void @init_array(i32 %n, double* %x1, double* %x2, double* %y_1, double* %y_2, [2000 x double]* %A) #0 {
.split:
  %x117 = bitcast double* %x1 to i8*
  %x218 = bitcast double* %x2 to i8*
  %y_120 = bitcast double* %y_1 to i8*
  %y_223 = bitcast double* %y_2 to i8*
  %A26 = bitcast [2000 x double]* %A to i8*
  %A25 = ptrtoint [2000 x double]* %A to i64
  %y_222 = ptrtoint double* %y_2 to i64
  %y_119 = ptrtoint double* %y_1 to i64
  %x216 = ptrtoint double* %x2 to i64
  %x115 = ptrtoint double* %x1 to i64
  %0 = zext i32 %n to i64
  %1 = add i64 %0, -1
  %2 = mul i64 8, %1
  %3 = add i64 %x115, %2
  %4 = inttoptr i64 %3 to i8*
  %5 = add i64 %x216, %2
  %6 = inttoptr i64 %5 to i8*
  %7 = icmp ult i8* %4, %x218
  %8 = icmp ult i8* %6, %x117
  %pair-no-alias = or i1 %7, %8
  %9 = add i64 %y_119, %2
  %10 = inttoptr i64 %9 to i8*
  %11 = icmp ult i8* %4, %y_120
  %12 = icmp ult i8* %10, %x117
  %pair-no-alias21 = or i1 %11, %12
  %13 = and i1 %pair-no-alias, %pair-no-alias21
  %14 = add i64 %y_222, %2
  %15 = inttoptr i64 %14 to i8*
  %16 = icmp ult i8* %4, %y_223
  %17 = icmp ult i8* %15, %x117
  %pair-no-alias24 = or i1 %16, %17
  %18 = and i1 %13, %pair-no-alias24
  %19 = mul i64 16000, %1
  %20 = add i64 %A25, %19
  %21 = add i64 %20, %2
  %22 = inttoptr i64 %21 to i8*
  %23 = icmp ult i8* %4, %A26
  %24 = icmp ult i8* %22, %x117
  %pair-no-alias27 = or i1 %23, %24
  %25 = and i1 %18, %pair-no-alias27
  %26 = icmp ult i8* %6, %y_120
  %27 = icmp ult i8* %10, %x218
  %pair-no-alias28 = or i1 %26, %27
  %28 = and i1 %25, %pair-no-alias28
  %29 = icmp ult i8* %6, %y_223
  %30 = icmp ult i8* %15, %x218
  %pair-no-alias29 = or i1 %29, %30
  %31 = and i1 %28, %pair-no-alias29
  %32 = icmp ult i8* %6, %A26
  %33 = icmp ult i8* %22, %x218
  %pair-no-alias30 = or i1 %32, %33
  %34 = and i1 %31, %pair-no-alias30
  %35 = icmp ult i8* %10, %y_223
  %36 = icmp ult i8* %15, %y_120
  %pair-no-alias31 = or i1 %35, %36
  %37 = and i1 %34, %pair-no-alias31
  %38 = icmp ult i8* %10, %A26
  %39 = icmp ult i8* %22, %y_120
  %pair-no-alias32 = or i1 %38, %39
  %40 = and i1 %37, %pair-no-alias32
  %41 = icmp ult i8* %15, %A26
  %42 = icmp ult i8* %22, %y_223
  %pair-no-alias33 = or i1 %41, %42
  %43 = and i1 %40, %pair-no-alias33
  br i1 %43, label %polly.start, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  %44 = icmp sgt i32 %n, 0
  br i1 %44, label %.lr.ph5.clone, label %.region.clone

.lr.ph5.clone:                                    ; preds = %.split.split.clone
  %45 = sitofp i32 %n to double
  br label %46

; <label>:46                                      ; preds = %polly.merge104, %.lr.ph5.clone
  %47 = phi i64 [ 0, %.lr.ph5.clone ], [ %49, %polly.merge104 ]
  %48 = mul i64 %47, 16000
  %i.02.clone = trunc i64 %47 to i32
  %49 = add i64 %47, 1
  %50 = trunc i64 %49 to i32
  %scevgep11.clone = getelementptr double* %x1, i64 %47
  %scevgep12.clone = getelementptr double* %x2, i64 %47
  %51 = add i64 %47, 3
  %52 = trunc i64 %51 to i32
  %scevgep13.clone = getelementptr double* %y_1, i64 %47
  %53 = add i64 %47, 4
  %54 = trunc i64 %53 to i32
  %scevgep14.clone = getelementptr double* %y_2, i64 %47
  %55 = srem i32 %i.02.clone, %n
  %56 = sitofp i32 %55 to double
  %57 = fdiv double %56, %45
  store double %57, double* %scevgep11.clone, align 8, !tbaa !6
  %58 = srem i32 %50, %n
  %59 = sitofp i32 %58 to double
  %60 = fdiv double %59, %45
  store double %60, double* %scevgep12.clone, align 8, !tbaa !6
  %61 = srem i32 %52, %n
  %62 = sitofp i32 %61 to double
  %63 = fdiv double %62, %45
  store double %63, double* %scevgep13.clone, align 8, !tbaa !6
  %64 = srem i32 %54, %n
  %65 = sitofp i32 %64 to double
  %66 = fdiv double %65, %45
  store double %66, double* %scevgep14.clone, align 8, !tbaa !6
  br i1 %44, label %polly.cond103, label %polly.merge104

polly.merge104:                                   ; preds = %polly.then108, %polly.loop_header110, %polly.cond103, %46
  %exitcond9.clone = icmp ne i64 %49, %0
  br i1 %exitcond9.clone, label %46, label %.region.clone

.region.clone:                                    ; preds = %polly.loop_exit, %polly.loop_exit70, %polly.start, %.split.split.clone, %polly.merge104
  ret void

polly.start:                                      ; preds = %.split
  %67 = sext i32 %n to i64
  %68 = icmp sge i64 %67, 1
  %69 = icmp sge i64 %0, 1
  %70 = and i1 %68, %69
  br i1 %70, label %polly.then, label %.region.clone

polly.then:                                       ; preds = %polly.start
  %polly.loop_guard = icmp sle i64 0, %1
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.loop_exit

polly.loop_exit:                                  ; preds = %polly.loop_header, %polly.then
  br i1 %polly.loop_guard, label %polly.loop_header59, label %.region.clone

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_.moved.to. = sitofp i32 %n to double
  %p_i.02 = trunc i64 %polly.indvar to i32
  %p_ = add i64 %polly.indvar, 1
  %p_41 = trunc i64 %p_ to i32
  %p_scevgep11 = getelementptr double* %x1, i64 %polly.indvar
  %p_scevgep12 = getelementptr double* %x2, i64 %polly.indvar
  %p_42 = add i64 %polly.indvar, 3
  %p_43 = trunc i64 %p_42 to i32
  %p_scevgep13 = getelementptr double* %y_1, i64 %polly.indvar
  %p_44 = add i64 %polly.indvar, 4
  %p_45 = trunc i64 %p_44 to i32
  %p_scevgep14 = getelementptr double* %y_2, i64 %polly.indvar
  %p_46 = srem i32 %p_i.02, %n
  %p_47 = sitofp i32 %p_46 to double
  %p_48 = fdiv double %p_47, %p_.moved.to.
  store double %p_48, double* %p_scevgep11
  %p_49 = srem i32 %p_41, %n
  %p_50 = sitofp i32 %p_49 to double
  %p_51 = fdiv double %p_50, %p_.moved.to.
  store double %p_51, double* %p_scevgep12
  %p_52 = srem i32 %p_43, %n
  %p_53 = sitofp i32 %p_52 to double
  %p_54 = fdiv double %p_53, %p_.moved.to.
  store double %p_54, double* %p_scevgep13
  %p_55 = srem i32 %p_45, %n
  %p_56 = sitofp i32 %p_55 to double
  %p_57 = fdiv double %p_56, %p_.moved.to.
  store double %p_57, double* %p_scevgep14
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %1, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.loop_exit

polly.loop_header59:                              ; preds = %polly.loop_exit, %polly.loop_exit70
  %polly.indvar63 = phi i64 [ %polly.indvar_next64, %polly.loop_exit70 ], [ 0, %polly.loop_exit ]
  %71 = mul i64 -11, %0
  %72 = add i64 %71, 5
  %73 = sub i64 %72, 32
  %74 = add i64 %73, 1
  %75 = icmp slt i64 %72, 0
  %76 = select i1 %75, i64 %74, i64 %72
  %77 = sdiv i64 %76, 32
  %78 = mul i64 -32, %77
  %79 = mul i64 -32, %0
  %80 = add i64 %78, %79
  %81 = mul i64 -32, %polly.indvar63
  %82 = mul i64 -3, %polly.indvar63
  %83 = add i64 %82, %0
  %84 = add i64 %83, 5
  %85 = sub i64 %84, 32
  %86 = add i64 %85, 1
  %87 = icmp slt i64 %84, 0
  %88 = select i1 %87, i64 %86, i64 %84
  %89 = sdiv i64 %88, 32
  %90 = mul i64 -32, %89
  %91 = add i64 %81, %90
  %92 = add i64 %91, -640
  %93 = icmp sgt i64 %80, %92
  %94 = select i1 %93, i64 %80, i64 %92
  %95 = mul i64 -20, %polly.indvar63
  %polly.loop_guard71 = icmp sle i64 %94, %95
  br i1 %polly.loop_guard71, label %polly.loop_header68, label %polly.loop_exit70

polly.loop_exit70:                                ; preds = %polly.loop_exit79, %polly.loop_header59
  %polly.indvar_next64 = add nsw i64 %polly.indvar63, 32
  %polly.adjust_ub65 = sub i64 %1, 32
  %polly.loop_cond66 = icmp sle i64 %polly.indvar63, %polly.adjust_ub65
  br i1 %polly.loop_cond66, label %polly.loop_header59, label %.region.clone

polly.loop_header68:                              ; preds = %polly.loop_header59, %polly.loop_exit79
  %polly.indvar72 = phi i64 [ %polly.indvar_next73, %polly.loop_exit79 ], [ %94, %polly.loop_header59 ]
  %96 = mul i64 -1, %polly.indvar72
  %97 = mul i64 -1, %0
  %98 = add i64 %96, %97
  %99 = add i64 %98, -30
  %100 = add i64 %99, 20
  %101 = sub i64 %100, 1
  %102 = icmp slt i64 %99, 0
  %103 = select i1 %102, i64 %99, i64 %101
  %104 = sdiv i64 %103, 20
  %105 = icmp sgt i64 %104, %polly.indvar63
  %106 = select i1 %105, i64 %104, i64 %polly.indvar63
  %107 = sub i64 %96, 20
  %108 = add i64 %107, 1
  %109 = icmp slt i64 %96, 0
  %110 = select i1 %109, i64 %108, i64 %96
  %111 = sdiv i64 %110, 20
  %112 = add i64 %polly.indvar63, 31
  %113 = icmp slt i64 %111, %112
  %114 = select i1 %113, i64 %111, i64 %112
  %115 = icmp slt i64 %114, %1
  %116 = select i1 %115, i64 %114, i64 %1
  %polly.loop_guard80 = icmp sle i64 %106, %116
  br i1 %polly.loop_guard80, label %polly.loop_header77, label %polly.loop_exit79

polly.loop_exit79:                                ; preds = %polly.loop_exit88, %polly.loop_header68
  %polly.indvar_next73 = add nsw i64 %polly.indvar72, 32
  %polly.adjust_ub74 = sub i64 %95, 32
  %polly.loop_cond75 = icmp sle i64 %polly.indvar72, %polly.adjust_ub74
  br i1 %polly.loop_cond75, label %polly.loop_header68, label %polly.loop_exit70

polly.loop_header77:                              ; preds = %polly.loop_header68, %polly.loop_exit88
  %polly.indvar81 = phi i64 [ %polly.indvar_next82, %polly.loop_exit88 ], [ %106, %polly.loop_header68 ]
  %117 = mul i64 -20, %polly.indvar81
  %118 = add i64 %117, %97
  %119 = add i64 %118, 1
  %120 = icmp sgt i64 %polly.indvar72, %119
  %121 = select i1 %120, i64 %polly.indvar72, i64 %119
  %122 = add i64 %polly.indvar72, 31
  %123 = icmp slt i64 %117, %122
  %124 = select i1 %123, i64 %117, i64 %122
  %polly.loop_guard89 = icmp sle i64 %121, %124
  br i1 %polly.loop_guard89, label %polly.loop_header86, label %polly.loop_exit88

polly.loop_exit88:                                ; preds = %polly.loop_header86, %polly.loop_header77
  %polly.indvar_next82 = add nsw i64 %polly.indvar81, 1
  %polly.adjust_ub83 = sub i64 %116, 1
  %polly.loop_cond84 = icmp sle i64 %polly.indvar81, %polly.adjust_ub83
  br i1 %polly.loop_cond84, label %polly.loop_header77, label %polly.loop_exit79

polly.loop_header86:                              ; preds = %polly.loop_header77, %polly.loop_header86
  %polly.indvar90 = phi i64 [ %polly.indvar_next91, %polly.loop_header86 ], [ %121, %polly.loop_header77 ]
  %125 = mul i64 -1, %polly.indvar90
  %126 = add i64 %117, %125
  %p_.moved.to.38 = sitofp i32 %n to double
  %p_scevgep = getelementptr [2000 x double]* %A, i64 %polly.indvar81, i64 %126
  %p_95 = mul i64 %polly.indvar81, %126
  %p_96 = trunc i64 %p_95 to i32
  %p_97 = srem i32 %p_96, %n
  %p_98 = sitofp i32 %p_97 to double
  %p_99 = fdiv double %p_98, %p_.moved.to.38
  store double %p_99, double* %p_scevgep
  %p_indvar.next = add i64 %126, 1
  %polly.indvar_next91 = add nsw i64 %polly.indvar90, 1
  %polly.adjust_ub92 = sub i64 %124, 1
  %polly.loop_cond93 = icmp sle i64 %polly.indvar90, %polly.adjust_ub92
  br i1 %polly.loop_cond93, label %polly.loop_header86, label %polly.loop_exit88

polly.cond103:                                    ; preds = %46
  %127 = srem i64 %48, 8
  %128 = icmp eq i64 %127, 0
  %129 = icmp sge i64 %0, 1
  %or.cond = and i1 %128, %129
  br i1 %or.cond, label %polly.then108, label %polly.merge104

polly.then108:                                    ; preds = %polly.cond103
  %polly.loop_guard113 = icmp sle i64 0, %1
  br i1 %polly.loop_guard113, label %polly.loop_header110, label %polly.merge104

polly.loop_header110:                             ; preds = %polly.then108, %polly.loop_header110
  %polly.indvar114 = phi i64 [ %polly.indvar_next115, %polly.loop_header110 ], [ 0, %polly.then108 ]
  %p_scevgep.clone = getelementptr [2000 x double]* %A, i64 %47, i64 %polly.indvar114
  %p_119 = mul i64 %47, %polly.indvar114
  %p_120 = trunc i64 %p_119 to i32
  %p_121 = srem i32 %p_120, %n
  %p_122 = sitofp i32 %p_121 to double
  %p_123 = fdiv double %p_122, %45
  store double %p_123, double* %p_scevgep.clone
  %p_indvar.next.clone = add i64 %polly.indvar114, 1
  %polly.indvar_next115 = add nsw i64 %polly.indvar114, 1
  %polly.adjust_ub116 = sub i64 %1, 1
  %polly.loop_cond117 = icmp sle i64 %polly.indvar114, %polly.adjust_ub116
  br i1 %polly.loop_cond117, label %polly.loop_header110, label %polly.merge104
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_mvt(i32 %n, double* %x1, double* %x2, double* %y_1, double* %y_2, [2000 x double]* %A) #0 {
.split:
  %x128 = bitcast double* %x1 to i8*
  %y_129 = bitcast double* %y_1 to i8*
  %x236 = bitcast double* %x2 to i8*
  %A31 = bitcast [2000 x double]* %A to i8*
  %y_237 = bitcast double* %y_2 to i8*
  %A30 = ptrtoint [2000 x double]* %A to i64
  %y_235 = ptrtoint double* %y_2 to i64
  %x234 = ptrtoint double* %x2 to i64
  %y_127 = ptrtoint double* %y_1 to i64
  %x126 = ptrtoint double* %x1 to i64
  %0 = zext i32 %n to i64
  %1 = add i64 %0, -1
  %2 = mul i64 8, %1
  %3 = add i64 %x126, %2
  %4 = inttoptr i64 %3 to i8*
  %5 = add i64 %y_127, %2
  %6 = inttoptr i64 %5 to i8*
  %7 = icmp ult i8* %4, %y_129
  %8 = icmp ult i8* %6, %x128
  %pair-no-alias = or i1 %7, %8
  %9 = mul i64 16000, %1
  %10 = add i64 %A30, %9
  %11 = add i64 %10, %2
  %12 = inttoptr i64 %11 to i8*
  %13 = icmp ult i8* %4, %A31
  %14 = icmp ult i8* %12, %x128
  %pair-no-alias32 = or i1 %13, %14
  %15 = and i1 %pair-no-alias, %pair-no-alias32
  %16 = icmp ult i8* %6, %A31
  %17 = icmp ult i8* %12, %y_129
  %pair-no-alias33 = or i1 %16, %17
  %18 = and i1 %15, %pair-no-alias33
  br i1 %18, label %polly.start76, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  %19 = icmp sgt i32 %n, 0
  br i1 %19, label %.preheader2.lr.ph.clone, label %.preheader1

.preheader2.lr.ph.clone:                          ; preds = %.split.split.clone
  br label %.preheader2.clone

.preheader2.clone:                                ; preds = %._crit_edge8.clone, %.preheader2.lr.ph.clone
  %indvar19.clone = phi i64 [ 0, %.preheader2.lr.ph.clone ], [ %indvar.next20.clone, %._crit_edge8.clone ]
  %scevgep25.clone = getelementptr double* %x1, i64 %indvar19.clone
  br i1 %19, label %.lr.ph7.clone, label %._crit_edge8.clone

.lr.ph7.clone:                                    ; preds = %.preheader2.clone, %.lr.ph7.clone
  %indvar16.clone = phi i64 [ %indvar.next17.clone, %.lr.ph7.clone ], [ 0, %.preheader2.clone ]
  %scevgep21.clone = getelementptr [2000 x double]* %A, i64 %indvar19.clone, i64 %indvar16.clone
  %scevgep22.clone = getelementptr double* %y_1, i64 %indvar16.clone
  %20 = load double* %scevgep25.clone, align 8, !tbaa !6
  %21 = load double* %scevgep21.clone, align 8, !tbaa !6
  %22 = load double* %scevgep22.clone, align 8, !tbaa !6
  %23 = fmul double %21, %22
  %24 = fadd double %20, %23
  store double %24, double* %scevgep25.clone, align 8, !tbaa !6
  %indvar.next17.clone = add i64 %indvar16.clone, 1
  %exitcond18.clone = icmp ne i64 %indvar.next17.clone, %0
  br i1 %exitcond18.clone, label %.lr.ph7.clone, label %._crit_edge8.clone

._crit_edge8.clone:                               ; preds = %.lr.ph7.clone, %.preheader2.clone
  %indvar.next20.clone = add i64 %indvar19.clone, 1
  %exitcond23.clone = icmp ne i64 %indvar.next20.clone, %0
  br i1 %exitcond23.clone, label %.preheader2.clone, label %.preheader1

.preheader1:                                      ; preds = %polly.then80, %polly.loop_exit93, %polly.start76, %.split.split.clone, %._crit_edge8.clone
  %25 = add i64 %x234, %2
  %26 = inttoptr i64 %25 to i8*
  %27 = add i64 %y_235, %2
  %28 = inttoptr i64 %27 to i8*
  %29 = icmp ult i8* %26, %y_237
  %30 = icmp ult i8* %28, %x236
  %pair-no-alias38 = or i1 %29, %30
  %31 = add i64 %A30, %2
  %32 = add i64 %31, %9
  %33 = inttoptr i64 %32 to i8*
  %34 = icmp ult i8* %26, %A31
  %35 = icmp ult i8* %33, %x236
  %pair-no-alias39 = or i1 %34, %35
  %36 = and i1 %pair-no-alias38, %pair-no-alias39
  %37 = icmp ult i8* %28, %A31
  %38 = icmp ult i8* %33, %y_237
  %pair-no-alias40 = or i1 %37, %38
  %39 = and i1 %36, %pair-no-alias40
  br i1 %39, label %polly.start, label %.preheader1.split.clone

.preheader1.split.clone:                          ; preds = %.preheader1
  %40 = icmp sgt i32 %n, 0
  br i1 %40, label %.preheader.lr.ph.clone, label %.region.clone

.preheader.lr.ph.clone:                           ; preds = %.preheader1.split.clone
  br label %.preheader.clone

.preheader.clone:                                 ; preds = %._crit_edge.clone, %.preheader.lr.ph.clone
  %indvar10.clone = phi i64 [ 0, %.preheader.lr.ph.clone ], [ %indvar.next11.clone, %._crit_edge.clone ]
  %scevgep15.clone = getelementptr double* %x2, i64 %indvar10.clone
  br i1 %40, label %.lr.ph.clone, label %._crit_edge.clone

.lr.ph.clone:                                     ; preds = %.preheader.clone, %.lr.ph.clone
  %indvar.clone = phi i64 [ %indvar.next.clone, %.lr.ph.clone ], [ 0, %.preheader.clone ]
  %scevgep.clone = getelementptr [2000 x double]* %A, i64 %indvar.clone, i64 %indvar10.clone
  %scevgep12.clone = getelementptr double* %y_2, i64 %indvar.clone
  %41 = load double* %scevgep15.clone, align 8, !tbaa !6
  %42 = load double* %scevgep.clone, align 8, !tbaa !6
  %43 = load double* %scevgep12.clone, align 8, !tbaa !6
  %44 = fmul double %42, %43
  %45 = fadd double %41, %44
  store double %45, double* %scevgep15.clone, align 8, !tbaa !6
  %indvar.next.clone = add i64 %indvar.clone, 1
  %exitcond.clone = icmp ne i64 %indvar.next.clone, %0
  br i1 %exitcond.clone, label %.lr.ph.clone, label %._crit_edge.clone

._crit_edge.clone:                                ; preds = %.lr.ph.clone, %.preheader.clone
  %indvar.next11.clone = add i64 %indvar10.clone, 1
  %exitcond13.clone = icmp ne i64 %indvar.next11.clone, %0
  br i1 %exitcond13.clone, label %.preheader.clone, label %.region.clone

.region.clone:                                    ; preds = %polly.then, %polly.loop_exit48, %polly.start, %.preheader1.split.clone, %._crit_edge.clone
  ret void

polly.start:                                      ; preds = %.preheader1
  %46 = sext i32 %n to i64
  %47 = icmp sge i64 %46, 1
  %48 = icmp sge i64 %0, 1
  %49 = and i1 %47, %48
  br i1 %49, label %polly.then, label %.region.clone

polly.then:                                       ; preds = %polly.start
  %polly.loop_guard = icmp sle i64 0, %1
  br i1 %polly.loop_guard, label %polly.loop_header, label %.region.clone

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit48
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit48 ], [ 0, %polly.then ]
  br i1 %polly.loop_guard, label %polly.loop_header46, label %polly.loop_exit48

polly.loop_exit48:                                ; preds = %polly.loop_exit57, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %1, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %.region.clone

polly.loop_header46:                              ; preds = %polly.loop_header, %polly.loop_exit57
  %polly.indvar50 = phi i64 [ %polly.indvar_next51, %polly.loop_exit57 ], [ 0, %polly.loop_header ]
  %50 = add i64 %polly.indvar, 31
  %51 = icmp slt i64 %50, %1
  %52 = select i1 %51, i64 %50, i64 %1
  %polly.loop_guard58 = icmp sle i64 %polly.indvar, %52
  br i1 %polly.loop_guard58, label %polly.loop_header55, label %polly.loop_exit57

polly.loop_exit57:                                ; preds = %polly.loop_exit66, %polly.loop_header46
  %polly.indvar_next51 = add nsw i64 %polly.indvar50, 32
  %polly.adjust_ub52 = sub i64 %1, 32
  %polly.loop_cond53 = icmp sle i64 %polly.indvar50, %polly.adjust_ub52
  br i1 %polly.loop_cond53, label %polly.loop_header46, label %polly.loop_exit48

polly.loop_header55:                              ; preds = %polly.loop_header46, %polly.loop_exit66
  %polly.indvar59 = phi i64 [ %polly.indvar_next60, %polly.loop_exit66 ], [ %polly.indvar, %polly.loop_header46 ]
  %53 = add i64 %polly.indvar50, 31
  %54 = icmp slt i64 %53, %1
  %55 = select i1 %54, i64 %53, i64 %1
  %polly.loop_guard67 = icmp sle i64 %polly.indvar50, %55
  br i1 %polly.loop_guard67, label %polly.loop_header64, label %polly.loop_exit66

polly.loop_exit66:                                ; preds = %polly.loop_header64, %polly.loop_header55
  %polly.indvar_next60 = add nsw i64 %polly.indvar59, 1
  %polly.adjust_ub61 = sub i64 %52, 1
  %polly.loop_cond62 = icmp sle i64 %polly.indvar59, %polly.adjust_ub61
  br i1 %polly.loop_cond62, label %polly.loop_header55, label %polly.loop_exit57

polly.loop_header64:                              ; preds = %polly.loop_header55, %polly.loop_header64
  %polly.indvar68 = phi i64 [ %polly.indvar_next69, %polly.loop_header64 ], [ %polly.indvar50, %polly.loop_header55 ]
  %p_scevgep15.moved.to. = getelementptr double* %x2, i64 %polly.indvar59
  %p_scevgep = getelementptr [2000 x double]* %A, i64 %polly.indvar68, i64 %polly.indvar59
  %p_scevgep12 = getelementptr double* %y_2, i64 %polly.indvar68
  %_p_scalar_ = load double* %p_scevgep15.moved.to.
  %_p_scalar_72 = load double* %p_scevgep
  %_p_scalar_73 = load double* %p_scevgep12
  %p_ = fmul double %_p_scalar_72, %_p_scalar_73
  %p_74 = fadd double %_p_scalar_, %p_
  store double %p_74, double* %p_scevgep15.moved.to.
  %p_indvar.next = add i64 %polly.indvar68, 1
  %polly.indvar_next69 = add nsw i64 %polly.indvar68, 1
  %polly.adjust_ub70 = sub i64 %55, 1
  %polly.loop_cond71 = icmp sle i64 %polly.indvar68, %polly.adjust_ub70
  br i1 %polly.loop_cond71, label %polly.loop_header64, label %polly.loop_exit66

polly.start76:                                    ; preds = %.split
  %56 = sext i32 %n to i64
  %57 = icmp sge i64 %56, 1
  %58 = icmp sge i64 %0, 1
  %59 = and i1 %57, %58
  br i1 %59, label %polly.then80, label %.preheader1

polly.then80:                                     ; preds = %polly.start76
  %polly.loop_guard85 = icmp sle i64 0, %1
  br i1 %polly.loop_guard85, label %polly.loop_header82, label %.preheader1

polly.loop_header82:                              ; preds = %polly.then80, %polly.loop_exit93
  %polly.indvar86 = phi i64 [ %polly.indvar_next87, %polly.loop_exit93 ], [ 0, %polly.then80 ]
  br i1 %polly.loop_guard85, label %polly.loop_header91, label %polly.loop_exit93

polly.loop_exit93:                                ; preds = %polly.loop_exit102, %polly.loop_header82
  %polly.indvar_next87 = add nsw i64 %polly.indvar86, 32
  %polly.adjust_ub88 = sub i64 %1, 32
  %polly.loop_cond89 = icmp sle i64 %polly.indvar86, %polly.adjust_ub88
  br i1 %polly.loop_cond89, label %polly.loop_header82, label %.preheader1

polly.loop_header91:                              ; preds = %polly.loop_header82, %polly.loop_exit102
  %polly.indvar95 = phi i64 [ %polly.indvar_next96, %polly.loop_exit102 ], [ 0, %polly.loop_header82 ]
  %60 = add i64 %polly.indvar86, 31
  %61 = icmp slt i64 %60, %1
  %62 = select i1 %61, i64 %60, i64 %1
  %polly.loop_guard103 = icmp sle i64 %polly.indvar86, %62
  br i1 %polly.loop_guard103, label %polly.loop_header100, label %polly.loop_exit102

polly.loop_exit102:                               ; preds = %polly.loop_exit111, %polly.loop_header91
  %polly.indvar_next96 = add nsw i64 %polly.indvar95, 32
  %polly.adjust_ub97 = sub i64 %1, 32
  %polly.loop_cond98 = icmp sle i64 %polly.indvar95, %polly.adjust_ub97
  br i1 %polly.loop_cond98, label %polly.loop_header91, label %polly.loop_exit93

polly.loop_header100:                             ; preds = %polly.loop_header91, %polly.loop_exit111
  %polly.indvar104 = phi i64 [ %polly.indvar_next105, %polly.loop_exit111 ], [ %polly.indvar86, %polly.loop_header91 ]
  %63 = add i64 %polly.indvar95, 31
  %64 = icmp slt i64 %63, %1
  %65 = select i1 %64, i64 %63, i64 %1
  %polly.loop_guard112 = icmp sle i64 %polly.indvar95, %65
  br i1 %polly.loop_guard112, label %polly.loop_header109, label %polly.loop_exit111

polly.loop_exit111:                               ; preds = %polly.loop_header109, %polly.loop_header100
  %polly.indvar_next105 = add nsw i64 %polly.indvar104, 1
  %polly.adjust_ub106 = sub i64 %62, 1
  %polly.loop_cond107 = icmp sle i64 %polly.indvar104, %polly.adjust_ub106
  br i1 %polly.loop_cond107, label %polly.loop_header100, label %polly.loop_exit102

polly.loop_header109:                             ; preds = %polly.loop_header100, %polly.loop_header109
  %polly.indvar113 = phi i64 [ %polly.indvar_next114, %polly.loop_header109 ], [ %polly.indvar95, %polly.loop_header100 ]
  %p_scevgep25.moved.to. = getelementptr double* %x1, i64 %polly.indvar104
  %p_scevgep21 = getelementptr [2000 x double]* %A, i64 %polly.indvar104, i64 %polly.indvar113
  %p_scevgep22 = getelementptr double* %y_1, i64 %polly.indvar113
  %_p_scalar_118 = load double* %p_scevgep25.moved.to.
  %_p_scalar_119 = load double* %p_scevgep21
  %_p_scalar_120 = load double* %p_scevgep22
  %p_121 = fmul double %_p_scalar_119, %_p_scalar_120
  %p_122 = fadd double %_p_scalar_118, %p_121
  store double %p_122, double* %p_scevgep25.moved.to.
  %p_indvar.next17 = add i64 %polly.indvar113, 1
  %polly.indvar_next114 = add nsw i64 %polly.indvar113, 1
  %polly.adjust_ub115 = sub i64 %65, 1
  %polly.loop_cond116 = icmp sle i64 %polly.indvar113, %polly.adjust_ub115
  br i1 %polly.loop_cond116, label %polly.loop_header109, label %polly.loop_exit111
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, double* %x1, double* %x2) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([3 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %n, 0
  br i1 %5, label %.lr.ph7, label %16

.lr.ph7:                                          ; preds = %.split
  %6 = zext i32 %n to i64
  br label %7

; <label>:7                                       ; preds = %.lr.ph7, %12
  %indvar9 = phi i64 [ 0, %.lr.ph7 ], [ %indvar.next10, %12 ]
  %i.05 = trunc i64 %indvar9 to i32
  %scevgep12 = getelementptr double* %x1, i64 %indvar9
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
  %18 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %17, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([3 x i8]* @.str3, i64 0, i64 0)) #5
  %19 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %20 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %19, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([3 x i8]* @.str7, i64 0, i64 0)) #5
  %21 = icmp sgt i32 %n, 0
  br i1 %21, label %.lr.ph, label %32

.lr.ph:                                           ; preds = %16
  %22 = zext i32 %n to i64
  br label %23

; <label>:23                                      ; preds = %.lr.ph, %28
  %indvar = phi i64 [ 0, %.lr.ph ], [ %indvar.next, %28 ]
  %i.14 = trunc i64 %indvar to i32
  %scevgep = getelementptr double* %x2, i64 %indvar
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
  %34 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %33, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([3 x i8]* @.str7, i64 0, i64 0)) #5
  %35 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %36 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str8, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %35) #4
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
!2 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{metadata !3, metadata !3, i64 0}
!6 = metadata !{metadata !7, metadata !7, i64 0}
!7 = metadata !{metadata !"double", metadata !3, i64 0}
