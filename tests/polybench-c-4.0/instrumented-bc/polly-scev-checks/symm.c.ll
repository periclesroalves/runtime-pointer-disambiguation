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
define internal void @init_array(i32 %m, i32 %n, double* %alpha, double* %beta, [1200 x double]* %C, [1000 x double]* %A, [1200 x double]* %B) #0 {
.split:
  %alpha34 = bitcast double* %alpha to i8*
  %beta35 = bitcast double* %beta to i8*
  %C37 = bitcast [1200 x double]* %C to i8*
  %B40 = bitcast [1200 x double]* %B to i8*
  %B39 = ptrtoint [1200 x double]* %B to i64
  %C36 = ptrtoint [1200 x double]* %C to i64
  %0 = icmp ult i8* %alpha34, %beta35
  %1 = icmp ult i8* %beta35, %alpha34
  %pair-no-alias = or i1 %0, %1
  %2 = zext i32 %m to i64
  %3 = add i64 %2, -1
  %4 = mul i64 9600, %3
  %5 = add i64 %C36, %4
  %6 = zext i32 %n to i64
  %7 = add i64 %6, -1
  %8 = mul i64 8, %7
  %9 = add i64 %5, %8
  %10 = inttoptr i64 %9 to i8*
  %11 = icmp ult i8* %alpha34, %C37
  %12 = icmp ult i8* %10, %alpha34
  %pair-no-alias38 = or i1 %11, %12
  %13 = and i1 %pair-no-alias, %pair-no-alias38
  %14 = add i64 %B39, %4
  %15 = add i64 %14, %8
  %16 = inttoptr i64 %15 to i8*
  %17 = icmp ult i8* %alpha34, %B40
  %18 = icmp ult i8* %16, %alpha34
  %pair-no-alias41 = or i1 %17, %18
  %19 = and i1 %13, %pair-no-alias41
  %20 = icmp ult i8* %beta35, %C37
  %21 = icmp ult i8* %10, %beta35
  %pair-no-alias42 = or i1 %20, %21
  %22 = and i1 %19, %pair-no-alias42
  %23 = icmp ult i8* %beta35, %B40
  %24 = icmp ult i8* %16, %beta35
  %pair-no-alias43 = or i1 %23, %24
  %25 = and i1 %22, %pair-no-alias43
  %26 = icmp ult i8* %10, %B40
  %27 = icmp ult i8* %16, %C37
  %pair-no-alias44 = or i1 %26, %27
  %28 = and i1 %25, %pair-no-alias44
  br i1 %28, label %polly.start123, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  store double 1.500000e+00, double* %alpha, align 8, !tbaa !1
  store double 1.200000e+00, double* %beta, align 8, !tbaa !1
  %29 = icmp sgt i32 %m, 0
  br i1 %29, label %.preheader3.lr.ph.clone, label %.preheader2.split

.preheader3.lr.ph.clone:                          ; preds = %.split.split.clone
  %30 = icmp sgt i32 %n, 0
  %31 = sitofp i32 %m to double
  br label %.preheader3.clone

.preheader3.clone:                                ; preds = %._crit_edge12.clone, %.preheader3.lr.ph.clone
  %indvar27.clone = phi i64 [ 0, %.preheader3.lr.ph.clone ], [ %indvar.next28.clone, %._crit_edge12.clone ]
  %32 = add i64 %6, %indvar27.clone
  br i1 %30, label %.lr.ph11.clone, label %._crit_edge12.clone

.lr.ph11.clone:                                   ; preds = %.preheader3.clone, %.lr.ph11.clone
  %indvar24.clone = phi i64 [ %indvar.next25.clone, %.lr.ph11.clone ], [ 0, %.preheader3.clone ]
  %33 = add i64 %indvar27.clone, %indvar24.clone
  %34 = trunc i64 %33 to i32
  %scevgep30.clone = getelementptr [1200 x double]* %B, i64 %indvar27.clone, i64 %indvar24.clone
  %scevgep29.clone = getelementptr [1200 x double]* %C, i64 %indvar27.clone, i64 %indvar24.clone
  %35 = mul i64 %indvar24.clone, -1
  %36 = add i64 %32, %35
  %37 = trunc i64 %36 to i32
  %38 = srem i32 %34, 100
  %39 = sitofp i32 %38 to double
  %40 = fdiv double %39, %31
  store double %40, double* %scevgep29.clone, align 8, !tbaa !1
  %41 = srem i32 %37, 100
  %42 = sitofp i32 %41 to double
  %43 = fdiv double %42, %31
  store double %43, double* %scevgep30.clone, align 8, !tbaa !1
  %indvar.next25.clone = add i64 %indvar24.clone, 1
  %exitcond26.clone = icmp ne i64 %indvar.next25.clone, %6
  br i1 %exitcond26.clone, label %.lr.ph11.clone, label %._crit_edge12.clone

._crit_edge12.clone:                              ; preds = %.lr.ph11.clone, %.preheader3.clone
  %indvar.next28.clone = add i64 %indvar27.clone, 1
  %exitcond31.clone = icmp ne i64 %indvar.next28.clone, %2
  br i1 %exitcond31.clone, label %.preheader3.clone, label %.preheader2.split

.preheader2.split:                                ; preds = %polly.stmt..split.split, %._crit_edge12.clone, %.split.split.clone
  %44 = icmp sgt i32 %m, 0
  br i1 %44, label %.preheader1.lr.ph, label %.region

.preheader1.lr.ph:                                ; preds = %.preheader2.split
  %45 = add i32 %m, -2
  %46 = zext i32 %45 to i64
  %47 = sitofp i32 %m to double
  br label %.preheader1

.preheader1:                                      ; preds = %.preheader1.lr.ph, %polly.merge82
  %indvar15 = phi i64 [ 0, %.preheader1.lr.ph ], [ %56, %polly.merge82 ]
  %48 = mul i64 %indvar15, 8000
  %49 = mul i64 %indvar15, -1
  %50 = add i64 %46, %49
  %51 = trunc i64 %50 to i32
  %52 = zext i32 %51 to i64
  %53 = mul i64 %indvar15, 8008
  %i.18 = trunc i64 %indvar15 to i32
  %54 = mul i64 %indvar15, 1001
  %55 = add i64 %54, 1
  %56 = add i64 %indvar15, 1
  %j.25 = trunc i64 %56 to i32
  %57 = add i64 %52, 1
  %58 = icmp slt i32 %i.18, 0
  br i1 %58, label %.preheader, label %polly.cond101

.preheader:                                       ; preds = %polly.then106, %polly.loop_header108, %polly.cond101, %.preheader1
  %59 = icmp slt i32 %j.25, %m
  br i1 %59, label %polly.cond81, label %polly.merge82

polly.merge82:                                    ; preds = %polly.then86, %polly.loop_header88, %polly.cond81, %.preheader
  %exitcond21 = icmp ne i64 %56, %2
  br i1 %exitcond21, label %.preheader1, label %.region

.region:                                          ; preds = %.preheader2.split, %polly.merge82
  ret void

polly.cond81:                                     ; preds = %.preheader
  %60 = srem i64 %53, 8
  %61 = icmp eq i64 %60, 0
  br i1 %61, label %polly.then86, label %polly.merge82

polly.then86:                                     ; preds = %polly.cond81
  br i1 true, label %polly.loop_header88, label %polly.merge82

polly.loop_header88:                              ; preds = %polly.then86, %polly.loop_header88
  %polly.indvar92 = phi i64 [ %polly.indvar_next93, %polly.loop_header88 ], [ 0, %polly.then86 ]
  %p_97 = add i64 %55, %polly.indvar92
  %p_scevgep20 = getelementptr [1000 x double]* %A, i64 0, i64 %p_97
  store double -9.990000e+02, double* %p_scevgep20
  %p_indvar.next18 = add i64 %polly.indvar92, 1
  %polly.indvar_next93 = add nsw i64 %polly.indvar92, 1
  %polly.adjust_ub94 = sub i64 %52, 1
  %polly.loop_cond95 = icmp sle i64 %polly.indvar92, %polly.adjust_ub94
  br i1 %polly.loop_cond95, label %polly.loop_header88, label %polly.merge82

polly.cond101:                                    ; preds = %.preheader1
  %62 = srem i64 %48, 8
  %63 = icmp eq i64 %62, 0
  %64 = icmp sge i64 %indvar15, 0
  %or.cond179 = and i1 %63, %64
  br i1 %or.cond179, label %polly.then106, label %.preheader

polly.then106:                                    ; preds = %polly.cond101
  br i1 %64, label %polly.loop_header108, label %.preheader

polly.loop_header108:                             ; preds = %polly.then106, %polly.loop_header108
  %polly.indvar112 = phi i64 [ %polly.indvar_next113, %polly.loop_header108 ], [ 0, %polly.then106 ]
  %p_117 = add i64 %indvar15, %polly.indvar112
  %p_118 = trunc i64 %p_117 to i32
  %p_scevgep = getelementptr [1000 x double]* %A, i64 %indvar15, i64 %polly.indvar112
  %p_119 = srem i32 %p_118, 100
  %p_120 = sitofp i32 %p_119 to double
  %p_121 = fdiv double %p_120, %47
  store double %p_121, double* %p_scevgep
  %p_indvar.next = add i64 %polly.indvar112, 1
  %polly.indvar_next113 = add nsw i64 %polly.indvar112, 1
  %polly.adjust_ub114 = sub i64 %indvar15, 1
  %polly.loop_cond115 = icmp sle i64 %polly.indvar112, %polly.adjust_ub114
  br i1 %polly.loop_cond115, label %polly.loop_header108, label %.preheader

polly.start123:                                   ; preds = %.split
  %65 = sext i32 %m to i64
  %66 = icmp sge i64 %65, 1
  %67 = sext i32 %n to i64
  %68 = icmp sge i64 %67, 1
  %69 = and i1 %66, %68
  %70 = icmp sge i64 %2, 1
  %71 = and i1 %69, %70
  %72 = icmp sge i64 %6, 1
  %73 = and i1 %71, %72
  br i1 %73, label %polly.then127, label %polly.stmt..split.split

polly.stmt..split.split:                          ; preds = %polly.then127, %polly.loop_exit140, %polly.start123
  store double 1.500000e+00, double* %alpha
  store double 1.200000e+00, double* %beta
  br label %.preheader2.split

polly.then127:                                    ; preds = %polly.start123
  %polly.loop_guard132 = icmp sle i64 0, %3
  br i1 %polly.loop_guard132, label %polly.loop_header129, label %polly.stmt..split.split

polly.loop_header129:                             ; preds = %polly.then127, %polly.loop_exit140
  %polly.indvar133 = phi i64 [ %polly.indvar_next134, %polly.loop_exit140 ], [ 0, %polly.then127 ]
  %74 = mul i64 -3, %2
  %75 = add i64 %74, %6
  %76 = add i64 %75, 5
  %77 = sub i64 %76, 32
  %78 = add i64 %77, 1
  %79 = icmp slt i64 %76, 0
  %80 = select i1 %79, i64 %78, i64 %76
  %81 = sdiv i64 %80, 32
  %82 = mul i64 -32, %81
  %83 = mul i64 -32, %2
  %84 = add i64 %82, %83
  %85 = mul i64 -32, %polly.indvar133
  %86 = mul i64 -3, %polly.indvar133
  %87 = add i64 %86, %6
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
  %99 = mul i64 -20, %polly.indvar133
  %polly.loop_guard141 = icmp sle i64 %98, %99
  br i1 %polly.loop_guard141, label %polly.loop_header138, label %polly.loop_exit140

polly.loop_exit140:                               ; preds = %polly.loop_exit149, %polly.loop_header129
  %polly.indvar_next134 = add nsw i64 %polly.indvar133, 32
  %polly.adjust_ub135 = sub i64 %3, 32
  %polly.loop_cond136 = icmp sle i64 %polly.indvar133, %polly.adjust_ub135
  br i1 %polly.loop_cond136, label %polly.loop_header129, label %polly.stmt..split.split

polly.loop_header138:                             ; preds = %polly.loop_header129, %polly.loop_exit149
  %polly.indvar142 = phi i64 [ %polly.indvar_next143, %polly.loop_exit149 ], [ %98, %polly.loop_header129 ]
  %100 = mul i64 -1, %polly.indvar142
  %101 = mul i64 -1, %6
  %102 = add i64 %100, %101
  %103 = add i64 %102, -30
  %104 = add i64 %103, 20
  %105 = sub i64 %104, 1
  %106 = icmp slt i64 %103, 0
  %107 = select i1 %106, i64 %103, i64 %105
  %108 = sdiv i64 %107, 20
  %109 = icmp sgt i64 %108, %polly.indvar133
  %110 = select i1 %109, i64 %108, i64 %polly.indvar133
  %111 = sub i64 %100, 20
  %112 = add i64 %111, 1
  %113 = icmp slt i64 %100, 0
  %114 = select i1 %113, i64 %112, i64 %100
  %115 = sdiv i64 %114, 20
  %116 = add i64 %polly.indvar133, 31
  %117 = icmp slt i64 %115, %116
  %118 = select i1 %117, i64 %115, i64 %116
  %119 = icmp slt i64 %118, %3
  %120 = select i1 %119, i64 %118, i64 %3
  %polly.loop_guard150 = icmp sle i64 %110, %120
  br i1 %polly.loop_guard150, label %polly.loop_header147, label %polly.loop_exit149

polly.loop_exit149:                               ; preds = %polly.loop_exit158, %polly.loop_header138
  %polly.indvar_next143 = add nsw i64 %polly.indvar142, 32
  %polly.adjust_ub144 = sub i64 %99, 32
  %polly.loop_cond145 = icmp sle i64 %polly.indvar142, %polly.adjust_ub144
  br i1 %polly.loop_cond145, label %polly.loop_header138, label %polly.loop_exit140

polly.loop_header147:                             ; preds = %polly.loop_header138, %polly.loop_exit158
  %polly.indvar151 = phi i64 [ %polly.indvar_next152, %polly.loop_exit158 ], [ %110, %polly.loop_header138 ]
  %121 = mul i64 -20, %polly.indvar151
  %122 = add i64 %121, %101
  %123 = add i64 %122, 1
  %124 = icmp sgt i64 %polly.indvar142, %123
  %125 = select i1 %124, i64 %polly.indvar142, i64 %123
  %126 = add i64 %polly.indvar142, 31
  %127 = icmp slt i64 %121, %126
  %128 = select i1 %127, i64 %121, i64 %126
  %polly.loop_guard159 = icmp sle i64 %125, %128
  br i1 %polly.loop_guard159, label %polly.loop_header156, label %polly.loop_exit158

polly.loop_exit158:                               ; preds = %polly.loop_header156, %polly.loop_header147
  %polly.indvar_next152 = add nsw i64 %polly.indvar151, 1
  %polly.adjust_ub153 = sub i64 %120, 1
  %polly.loop_cond154 = icmp sle i64 %polly.indvar151, %polly.adjust_ub153
  br i1 %polly.loop_cond154, label %polly.loop_header147, label %polly.loop_exit149

polly.loop_header156:                             ; preds = %polly.loop_header147, %polly.loop_header156
  %polly.indvar160 = phi i64 [ %polly.indvar_next161, %polly.loop_header156 ], [ %125, %polly.loop_header147 ]
  %129 = mul i64 -1, %polly.indvar160
  %130 = add i64 %121, %129
  %p_.moved.to. = sitofp i32 %m to double
  %p_.moved.to.46 = add i64 %6, %polly.indvar151
  %p_165 = add i64 %polly.indvar151, %130
  %p_166 = trunc i64 %p_165 to i32
  %p_scevgep30 = getelementptr [1200 x double]* %B, i64 %polly.indvar151, i64 %130
  %p_scevgep29 = getelementptr [1200 x double]* %C, i64 %polly.indvar151, i64 %130
  %p_167 = mul i64 %130, -1
  %p_168 = add i64 %p_.moved.to.46, %p_167
  %p_169 = trunc i64 %p_168 to i32
  %p_170 = srem i32 %p_166, 100
  %p_171 = sitofp i32 %p_170 to double
  %p_172 = fdiv double %p_171, %p_.moved.to.
  store double %p_172, double* %p_scevgep29
  %p_173 = srem i32 %p_169, 100
  %p_174 = sitofp i32 %p_173 to double
  %p_175 = fdiv double %p_174, %p_.moved.to.
  store double %p_175, double* %p_scevgep30
  %p_indvar.next25 = add i64 %130, 1
  %polly.indvar_next161 = add nsw i64 %polly.indvar160, 1
  %polly.adjust_ub162 = sub i64 %128, 1
  %polly.loop_cond163 = icmp sle i64 %polly.indvar160, %polly.adjust_ub162
  br i1 %polly.loop_cond163, label %polly.loop_header156, label %polly.loop_exit158
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_symm(i32 %m, i32 %n, double %alpha, double %beta, [1200 x double]* %C, [1000 x double]* %A, [1200 x double]* %B) #0 {
.split:
  %B37 = ptrtoint [1200 x double]* %B to i64
  %A30 = ptrtoint [1000 x double]* %A to i64
  %C28 = ptrtoint [1200 x double]* %C to i64
  %umin32 = bitcast [1200 x double]* %C to i8*
  %0 = zext i32 %n to i64
  %1 = add i64 %0, -1
  %2 = mul i64 8, %1
  %3 = add i64 %C28, %2
  %4 = zext i32 %m to i64
  %5 = add i64 %4, -1
  %6 = add i64 -1, %5
  %7 = mul i64 9600, %6
  %8 = add i64 %3, %7
  %9 = mul i64 9600, %5
  %10 = add i64 %C28, %9
  %11 = add i64 %10, %2
  %12 = icmp ugt i64 %11, %8
  %umax = select i1 %12, i64 %11, i64 %8
  %umax33 = inttoptr i64 %umax to i8*
  %umin2934 = bitcast [1000 x double]* %A to i8*
  %13 = mul i64 8000, %5
  %14 = add i64 %A30, %13
  %15 = mul i64 8, %6
  %16 = add i64 %14, %15
  %17 = mul i64 8008, %5
  %18 = add i64 %A30, %17
  %19 = icmp ugt i64 %18, %16
  %umax31 = select i1 %19, i64 %18, i64 %16
  %umax3135 = inttoptr i64 %umax31 to i8*
  %20 = icmp ult i8* %umax33, %umin2934
  %21 = icmp ult i8* %umax3135, %umin32
  %pair-no-alias = or i1 %20, %21
  %umin3639 = bitcast [1200 x double]* %B to i8*
  %22 = add i64 %B37, %9
  %23 = add i64 %22, %2
  %24 = add i64 %B37, %2
  %25 = add i64 %24, %7
  %26 = icmp ugt i64 %25, %23
  %umax38 = select i1 %26, i64 %25, i64 %23
  %umax3840 = inttoptr i64 %umax38 to i8*
  %27 = icmp ult i8* %umax33, %umin3639
  %28 = icmp ult i8* %umax3840, %umin32
  %pair-no-alias41 = or i1 %27, %28
  %29 = and i1 %pair-no-alias, %pair-no-alias41
  %30 = icmp ult i8* %umax3135, %umin3639
  %31 = icmp ult i8* %umax3840, %umin2934
  %pair-no-alias42 = or i1 %30, %31
  %32 = and i1 %29, %pair-no-alias42
  br i1 %32, label %polly.start, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  %33 = icmp sgt i32 %m, 0
  br i1 %33, label %.preheader1.lr.ph.clone, label %.region.clone

.preheader1.lr.ph.clone:                          ; preds = %.split.split.clone
  %34 = icmp sgt i32 %n, 0
  br label %.preheader1.clone

.preheader1.clone:                                ; preds = %._crit_edge8.clone, %.preheader1.lr.ph.clone
  %35 = phi i64 [ 0, %.preheader1.lr.ph.clone ], [ %indvar.next13.clone, %._crit_edge8.clone ]
  %i.09.clone = trunc i64 %35 to i32
  %36 = mul i64 %35, 1001
  %scevgep27.clone = getelementptr [1000 x double]* %A, i64 0, i64 %36
  br i1 %34, label %.preheader.lr.ph.clone, label %._crit_edge8.clone

.preheader.lr.ph.clone:                           ; preds = %.preheader1.clone
  %37 = icmp sgt i32 %i.09.clone, 0
  br label %.preheader.clone

.preheader.clone:                                 ; preds = %49, %.preheader.lr.ph.clone
  %indvar14.clone = phi i64 [ 0, %.preheader.lr.ph.clone ], [ %indvar.next15.clone, %49 ]
  %scevgep22.clone = getelementptr [1200 x double]* %B, i64 %35, i64 %indvar14.clone
  %scevgep21.clone = getelementptr [1200 x double]* %C, i64 %35, i64 %indvar14.clone
  br i1 %37, label %.lr.ph.clone, label %49

.lr.ph.clone:                                     ; preds = %.preheader.clone
  br label %38

; <label>:38                                      ; preds = %38, %.lr.ph.clone
  %temp2.04.reg2mem.0 = phi double [ 0.000000e+00, %.lr.ph.clone ], [ %48, %38 ]
  %indvar.clone = phi i64 [ 0, %.lr.ph.clone ], [ %indvar.next.clone, %38 ]
  %scevgep.clone = getelementptr [1000 x double]* %A, i64 %35, i64 %indvar.clone
  %scevgep17.clone = getelementptr [1200 x double]* %B, i64 %indvar.clone, i64 %indvar14.clone
  %scevgep16.clone = getelementptr [1200 x double]* %C, i64 %indvar.clone, i64 %indvar14.clone
  %39 = load double* %scevgep22.clone, align 8, !tbaa !1
  %40 = fmul double %39, %alpha
  %41 = load double* %scevgep.clone, align 8, !tbaa !1
  %42 = fmul double %40, %41
  %43 = load double* %scevgep16.clone, align 8, !tbaa !1
  %44 = fadd double %43, %42
  store double %44, double* %scevgep16.clone, align 8, !tbaa !1
  %45 = load double* %scevgep17.clone, align 8, !tbaa !1
  %46 = load double* %scevgep.clone, align 8, !tbaa !1
  %47 = fmul double %45, %46
  %48 = fadd double %temp2.04.reg2mem.0, %47
  %indvar.next.clone = add i64 %indvar.clone, 1
  %exitcond.clone = icmp ne i64 %indvar.next.clone, %35
  br i1 %exitcond.clone, label %38, label %._crit_edge.clone

._crit_edge.clone:                                ; preds = %38
  br label %49

; <label>:49                                      ; preds = %._crit_edge.clone, %.preheader.clone
  %temp2.0.lcssa.reg2mem.0 = phi double [ %48, %._crit_edge.clone ], [ 0.000000e+00, %.preheader.clone ]
  %50 = load double* %scevgep21.clone, align 8, !tbaa !1
  %51 = fmul double %50, %beta
  %52 = load double* %scevgep22.clone, align 8, !tbaa !1
  %53 = fmul double %52, %alpha
  %54 = load double* %scevgep27.clone, align 8, !tbaa !1
  %55 = fmul double %53, %54
  %56 = fadd double %51, %55
  %57 = fmul double %temp2.0.lcssa.reg2mem.0, %alpha
  %58 = fadd double %57, %56
  store double %58, double* %scevgep21.clone, align 8, !tbaa !1
  %indvar.next15.clone = add i64 %indvar14.clone, 1
  %exitcond18.clone = icmp ne i64 %indvar.next15.clone, %0
  br i1 %exitcond18.clone, label %.preheader.clone, label %._crit_edge8.clone

._crit_edge8.clone:                               ; preds = %49, %.preheader1.clone
  %indvar.next13.clone = add i64 %35, 1
  %exitcond23.clone = icmp ne i64 %indvar.next13.clone, %4
  br i1 %exitcond23.clone, label %.preheader1.clone, label %.region.clone

.region.clone:                                    ; preds = %polly.loop_exit, %polly.loop_exit65, %polly.start, %.split.split.clone, %._crit_edge8.clone
  ret void

polly.start:                                      ; preds = %.split
  %59 = sext i32 %m to i64
  %60 = icmp sge i64 %59, 1
  %61 = sext i32 %n to i64
  %62 = icmp sge i64 %61, 1
  %63 = and i1 %60, %62
  %64 = icmp sge i64 %4, 1
  %65 = and i1 %63, %64
  %66 = icmp sge i64 %0, 1
  %67 = and i1 %65, %66
  br i1 %67, label %polly.then, label %.region.clone

polly.then:                                       ; preds = %polly.start
  %polly.loop_guard = icmp sle i64 0, %1
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.loop_exit

polly.loop_exit:                                  ; preds = %polly.loop_header, %polly.then
  %polly.loop_guard57 = icmp sle i64 1, %5
  br i1 %polly.loop_guard57, label %polly.loop_header54, label %.region.clone

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_scevgep21.moved.to. = getelementptr [1200 x double]* %C, i64 0, i64 %polly.indvar
  %p_scevgep22.moved.to.43 = getelementptr [1200 x double]* %B, i64 0, i64 %polly.indvar
  %p_scevgep27.moved.to. = getelementptr [1000 x double]* %A, i64 0, i64 0
  %_p_scalar_ = load double* %p_scevgep21.moved.to.
  %p_ = fmul double %_p_scalar_, %beta
  %_p_scalar_46 = load double* %p_scevgep22.moved.to.43
  %p_47 = fmul double %_p_scalar_46, %alpha
  %_p_scalar_48 = load double* %p_scevgep27.moved.to.
  %p_49 = fmul double %p_47, %_p_scalar_48
  %p_50 = fadd double %p_, %p_49
  %p_51 = fmul double 0.000000e+00, %alpha
  %p_52 = fadd double %p_51, %p_50
  store double %p_52, double* %p_scevgep21.moved.to.
  %p_indvar.next15 = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %1, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.loop_exit

polly.loop_header54:                              ; preds = %polly.loop_exit, %polly.loop_exit65
  %polly.indvar58 = phi i64 [ %polly.indvar_next59, %polly.loop_exit65 ], [ 1, %polly.loop_exit ]
  br i1 %polly.loop_guard, label %polly.loop_header63, label %polly.loop_exit65

polly.loop_exit65:                                ; preds = %polly.loop_exit74, %polly.loop_header54
  %polly.indvar_next59 = add nsw i64 %polly.indvar58, 1
  %polly.adjust_ub60 = sub i64 %5, 1
  %polly.loop_cond61 = icmp sle i64 %polly.indvar58, %polly.adjust_ub60
  br i1 %polly.loop_cond61, label %polly.loop_header54, label %.region.clone

polly.loop_header63:                              ; preds = %polly.loop_header54, %polly.loop_exit74
  %polly.indvar67 = phi i64 [ %polly.indvar_next68, %polly.loop_exit74 ], [ 0, %polly.loop_header54 ]
  %68 = add i64 %polly.indvar58, -1
  %polly.loop_guard75 = icmp sle i64 0, %68
  br i1 %polly.loop_guard75, label %polly.loop_header72, label %polly.loop_exit74

polly.loop_exit74:                                ; preds = %polly.loop_header72, %polly.loop_header63
  %temp2.04.reg2mem.1 = phi double [ %p_90, %polly.loop_header72 ], [ 0.000000e+00, %polly.loop_header63 ]
  %p_scevgep21.moved.to.93 = getelementptr [1200 x double]* %C, i64 %polly.indvar58, i64 %polly.indvar67
  %p_scevgep22.moved.to.4394 = getelementptr [1200 x double]* %B, i64 %polly.indvar58, i64 %polly.indvar67
  %p_.moved.to.95 = mul i64 %polly.indvar58, 1001
  %p_scevgep27.moved.to.96 = getelementptr [1000 x double]* %A, i64 0, i64 %p_.moved.to.95
  %_p_scalar_99 = load double* %p_scevgep21.moved.to.93
  %p_100 = fmul double %_p_scalar_99, %beta
  %_p_scalar_101 = load double* %p_scevgep22.moved.to.4394
  %p_102 = fmul double %_p_scalar_101, %alpha
  %_p_scalar_103 = load double* %p_scevgep27.moved.to.96
  %p_104 = fmul double %p_102, %_p_scalar_103
  %p_105 = fadd double %p_100, %p_104
  %p_106 = fmul double %temp2.04.reg2mem.1, %alpha
  %p_107 = fadd double %p_106, %p_105
  store double %p_107, double* %p_scevgep21.moved.to.93
  %p_indvar.next15108 = add i64 %polly.indvar67, 1
  %polly.indvar_next68 = add nsw i64 %polly.indvar67, 1
  %polly.adjust_ub69 = sub i64 %1, 1
  %polly.loop_cond70 = icmp sle i64 %polly.indvar67, %polly.adjust_ub69
  br i1 %polly.loop_cond70, label %polly.loop_header63, label %polly.loop_exit65

polly.loop_header72:                              ; preds = %polly.loop_header63, %polly.loop_header72
  %temp2.04.reg2mem.2 = phi double [ 0.000000e+00, %polly.loop_header63 ], [ %p_90, %polly.loop_header72 ]
  %polly.indvar76 = phi i64 [ %polly.indvar_next77, %polly.loop_header72 ], [ 0, %polly.loop_header63 ]
  %p_scevgep22.moved.to. = getelementptr [1200 x double]* %B, i64 %polly.indvar58, i64 %polly.indvar67
  %p_scevgep = getelementptr [1000 x double]* %A, i64 %polly.indvar58, i64 %polly.indvar76
  %p_scevgep17 = getelementptr [1200 x double]* %B, i64 %polly.indvar76, i64 %polly.indvar67
  %p_scevgep16 = getelementptr [1200 x double]* %C, i64 %polly.indvar76, i64 %polly.indvar67
  %_p_scalar_81 = load double* %p_scevgep22.moved.to.
  %p_82 = fmul double %_p_scalar_81, %alpha
  %_p_scalar_83 = load double* %p_scevgep
  %p_84 = fmul double %p_82, %_p_scalar_83
  %_p_scalar_85 = load double* %p_scevgep16
  %p_86 = fadd double %_p_scalar_85, %p_84
  store double %p_86, double* %p_scevgep16
  %_p_scalar_87 = load double* %p_scevgep17
  %_p_scalar_88 = load double* %p_scevgep
  %p_89 = fmul double %_p_scalar_87, %_p_scalar_88
  %p_90 = fadd double %temp2.04.reg2mem.2, %p_89
  %p_indvar.next = add i64 %polly.indvar76, 1
  %polly.indvar_next77 = add nsw i64 %polly.indvar76, 1
  %polly.adjust_ub78 = sub i64 %68, 1
  %polly.loop_cond79 = icmp sle i64 %polly.indvar76, %polly.adjust_ub78
  br i1 %polly.loop_cond79, label %polly.loop_header72, label %polly.loop_exit74
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %m, i32 %n, [1200 x double]* %C) #0 {
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
