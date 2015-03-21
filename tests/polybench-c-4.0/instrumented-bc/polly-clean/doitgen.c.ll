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
define void @kernel_doitgen(i32 %nr, i32 %nq, i32 %np, [140 x [160 x double]]* %A, [160 x double]* %C4, double* %sum) #0 {
.split:
  %0 = icmp sgt i32 %nr, 0
  br i1 %0, label %.preheader2.lr.ph, label %._crit_edge12

.preheader2.lr.ph:                                ; preds = %.split
  %1 = zext i32 %np to i64
  %2 = zext i32 %nq to i64
  %3 = zext i32 %nr to i64
  %4 = icmp sgt i32 %nq, 0
  %5 = icmp sgt i32 %np, 0
  br label %.preheader2

.preheader2:                                      ; preds = %.preheader2.lr.ph, %._crit_edge10
  %indvar13 = phi i64 [ 0, %.preheader2.lr.ph ], [ %indvar.next14, %._crit_edge10 ]
  br i1 %4, label %.preheader1, label %._crit_edge10

.preheader1:                                      ; preds = %.preheader2, %._crit_edge8
  %indvar15 = phi i64 [ %indvar.next16, %._crit_edge8 ], [ 0, %.preheader2 ]
  br i1 %5, label %.lr.ph5, label %.preheader

.preheader:                                       ; preds = %._crit_edge, %.preheader1
  br i1 %5, label %.lr.ph7, label %._crit_edge8

.lr.ph5:                                          ; preds = %.preheader1, %._crit_edge
  %indvar17 = phi i64 [ %indvar.next18, %._crit_edge ], [ 0, %.preheader1 ]
  %scevgep22 = getelementptr double* %sum, i64 %indvar17
  store double 0.000000e+00, double* %scevgep22, align 8, !tbaa !1
  br i1 %5, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %.lr.ph5, %.lr.ph
  %indvar = phi i64 [ %indvar.next, %.lr.ph ], [ 0, %.lr.ph5 ]
  %scevgep = getelementptr [140 x [160 x double]]* %A, i64 %indvar13, i64 %indvar15, i64 %indvar
  %scevgep19 = getelementptr [160 x double]* %C4, i64 %indvar, i64 %indvar17
  %6 = load double* %scevgep, align 8, !tbaa !1
  %7 = load double* %scevgep19, align 8, !tbaa !1
  %8 = fmul double %6, %7
  %9 = load double* %scevgep22, align 8, !tbaa !1
  %10 = fadd double %9, %8
  store double %10, double* %scevgep22, align 8, !tbaa !1
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %1
  br i1 %exitcond, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %.lr.ph5
  %indvar.next18 = add i64 %indvar17, 1
  %exitcond20 = icmp ne i64 %indvar.next18, %1
  br i1 %exitcond20, label %.lr.ph5, label %.preheader

.lr.ph7:                                          ; preds = %.preheader, %.lr.ph7
  %indvar23 = phi i64 [ %indvar.next24, %.lr.ph7 ], [ 0, %.preheader ]
  %scevgep27 = getelementptr [140 x [160 x double]]* %A, i64 %indvar13, i64 %indvar15, i64 %indvar23
  %scevgep26 = getelementptr double* %sum, i64 %indvar23
  %11 = load double* %scevgep26, align 8, !tbaa !1
  store double %11, double* %scevgep27, align 8, !tbaa !1
  %indvar.next24 = add i64 %indvar23, 1
  %exitcond25 = icmp ne i64 %indvar.next24, %1
  br i1 %exitcond25, label %.lr.ph7, label %._crit_edge8

._crit_edge8:                                     ; preds = %.lr.ph7, %.preheader
  %indvar.next16 = add i64 %indvar15, 1
  %exitcond28 = icmp ne i64 %indvar.next16, %2
  br i1 %exitcond28, label %.preheader1, label %._crit_edge10

._crit_edge10:                                    ; preds = %._crit_edge8, %.preheader2
  %indvar.next14 = add i64 %indvar13, 1
  %exitcond31 = icmp ne i64 %indvar.next14, %3
  br i1 %exitcond31, label %.preheader2, label %._crit_edge12

._crit_edge12:                                    ; preds = %._crit_edge10, %.split
  ret void
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
  %8 = load i8** %argv, align 8, !tbaa !5
  %9 = load i8* %8, align 1, !tbaa !7
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
define internal void @init_array(i32 %nr, i32 %nq, i32 %np, [140 x [160 x double]]* %A, [160 x double]* %C4) #0 {
polly.split_new_and_old70:
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
  br i1 %16, label %polly.then75, label %polly.merge74

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit42, %polly.merge74
  ret void

polly.then:                                       ; preds = %polly.merge74
  %17 = add i64 %2, -1
  %polly.loop_guard = icmp sle i64 0, %17
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit42
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit42 ], [ 0, %polly.then ]
  %18 = mul i64 -11, %2
  %19 = add i64 %18, 5
  %20 = sub i64 %19, 32
  %21 = add i64 %20, 1
  %22 = icmp slt i64 %19, 0
  %23 = select i1 %22, i64 %21, i64 %19
  %24 = sdiv i64 %23, 32
  %25 = mul i64 -32, %24
  %26 = mul i64 -32, %2
  %27 = add i64 %25, %26
  %28 = mul i64 -32, %polly.indvar
  %29 = mul i64 -3, %polly.indvar
  %30 = add i64 %29, %2
  %31 = add i64 %30, 5
  %32 = sub i64 %31, 32
  %33 = add i64 %32, 1
  %34 = icmp slt i64 %31, 0
  %35 = select i1 %34, i64 %33, i64 %31
  %36 = sdiv i64 %35, 32
  %37 = mul i64 -32, %36
  %38 = add i64 %28, %37
  %39 = add i64 %38, -640
  %40 = icmp sgt i64 %27, %39
  %41 = select i1 %40, i64 %27, i64 %39
  %42 = mul i64 -20, %polly.indvar
  %polly.loop_guard43 = icmp sle i64 %41, %42
  br i1 %polly.loop_guard43, label %polly.loop_header40, label %polly.loop_exit42

polly.loop_exit42:                                ; preds = %polly.loop_exit51, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %17, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header40:                              ; preds = %polly.loop_header, %polly.loop_exit51
  %polly.indvar44 = phi i64 [ %polly.indvar_next45, %polly.loop_exit51 ], [ %41, %polly.loop_header ]
  %43 = mul i64 -1, %polly.indvar44
  %44 = mul i64 -1, %2
  %45 = add i64 %43, %44
  %46 = add i64 %45, -30
  %47 = add i64 %46, 20
  %48 = sub i64 %47, 1
  %49 = icmp slt i64 %46, 0
  %50 = select i1 %49, i64 %46, i64 %48
  %51 = sdiv i64 %50, 20
  %52 = icmp sgt i64 %51, %polly.indvar
  %53 = select i1 %52, i64 %51, i64 %polly.indvar
  %54 = sub i64 %43, 20
  %55 = add i64 %54, 1
  %56 = icmp slt i64 %43, 0
  %57 = select i1 %56, i64 %55, i64 %43
  %58 = sdiv i64 %57, 20
  %59 = add i64 %polly.indvar, 31
  %60 = icmp slt i64 %58, %59
  %61 = select i1 %60, i64 %58, i64 %59
  %62 = icmp slt i64 %61, %17
  %63 = select i1 %62, i64 %61, i64 %17
  %polly.loop_guard52 = icmp sle i64 %53, %63
  br i1 %polly.loop_guard52, label %polly.loop_header49, label %polly.loop_exit51

polly.loop_exit51:                                ; preds = %polly.loop_exit60, %polly.loop_header40
  %polly.indvar_next45 = add nsw i64 %polly.indvar44, 32
  %polly.adjust_ub46 = sub i64 %42, 32
  %polly.loop_cond47 = icmp sle i64 %polly.indvar44, %polly.adjust_ub46
  br i1 %polly.loop_cond47, label %polly.loop_header40, label %polly.loop_exit42

polly.loop_header49:                              ; preds = %polly.loop_header40, %polly.loop_exit60
  %polly.indvar53 = phi i64 [ %polly.indvar_next54, %polly.loop_exit60 ], [ %53, %polly.loop_header40 ]
  %64 = mul i64 -20, %polly.indvar53
  %65 = add i64 %64, %44
  %66 = add i64 %65, 1
  %67 = icmp sgt i64 %polly.indvar44, %66
  %68 = select i1 %67, i64 %polly.indvar44, i64 %66
  %69 = add i64 %polly.indvar44, 31
  %70 = icmp slt i64 %64, %69
  %71 = select i1 %70, i64 %64, i64 %69
  %polly.loop_guard61 = icmp sle i64 %68, %71
  br i1 %polly.loop_guard61, label %polly.loop_header58, label %polly.loop_exit60

polly.loop_exit60:                                ; preds = %polly.loop_header58, %polly.loop_header49
  %polly.indvar_next54 = add nsw i64 %polly.indvar53, 1
  %polly.adjust_ub55 = sub i64 %63, 1
  %polly.loop_cond56 = icmp sle i64 %polly.indvar53, %polly.adjust_ub55
  br i1 %polly.loop_cond56, label %polly.loop_header49, label %polly.loop_exit51

polly.loop_header58:                              ; preds = %polly.loop_header49, %polly.loop_header58
  %polly.indvar62 = phi i64 [ %polly.indvar_next63, %polly.loop_header58 ], [ %68, %polly.loop_header49 ]
  %72 = mul i64 -1, %polly.indvar62
  %73 = add i64 %64, %72
  %p_.moved.to.36 = sitofp i32 %np to double
  %p_scevgep = getelementptr [160 x double]* %C4, i64 %polly.indvar53, i64 %73
  %p_ = mul i64 %polly.indvar53, %73
  %p_66 = trunc i64 %p_ to i32
  %p_67 = srem i32 %p_66, %np
  %p_68 = sitofp i32 %p_67 to double
  %p_69 = fdiv double %p_68, %p_.moved.to.36
  store double %p_69, double* %p_scevgep
  %p_indvar.next = add i64 %73, 1
  %polly.indvar_next63 = add nsw i64 %polly.indvar62, 1
  %polly.adjust_ub64 = sub i64 %71, 1
  %polly.loop_cond65 = icmp sle i64 %polly.indvar62, %polly.adjust_ub64
  br i1 %polly.loop_cond65, label %polly.loop_header58, label %polly.loop_exit60

polly.merge74:                                    ; preds = %polly.then75, %polly.loop_exit88, %polly.split_new_and_old70
  %74 = and i1 %4, %15
  br i1 %74, label %polly.then, label %polly.merge

polly.then75:                                     ; preds = %polly.split_new_and_old70
  %75 = add i64 %0, -1
  %polly.loop_guard80 = icmp sle i64 0, %75
  br i1 %polly.loop_guard80, label %polly.loop_header77, label %polly.merge74

polly.loop_header77:                              ; preds = %polly.then75, %polly.loop_exit88
  %polly.indvar81 = phi i64 [ %polly.indvar_next82, %polly.loop_exit88 ], [ 0, %polly.then75 ]
  %76 = add i64 %1, -1
  %polly.loop_guard89 = icmp sle i64 0, %76
  br i1 %polly.loop_guard89, label %polly.loop_header86, label %polly.loop_exit88

polly.loop_exit88:                                ; preds = %polly.loop_exit97, %polly.loop_header77
  %polly.indvar_next82 = add nsw i64 %polly.indvar81, 1
  %polly.adjust_ub83 = sub i64 %75, 1
  %polly.loop_cond84 = icmp sle i64 %polly.indvar81, %polly.adjust_ub83
  br i1 %polly.loop_cond84, label %polly.loop_header77, label %polly.merge74

polly.loop_header86:                              ; preds = %polly.loop_header77, %polly.loop_exit97
  %polly.indvar90 = phi i64 [ %polly.indvar_next91, %polly.loop_exit97 ], [ 0, %polly.loop_header77 ]
  %77 = mul i64 -3, %1
  %78 = add i64 %77, %2
  %79 = add i64 %78, 5
  %80 = sub i64 %79, 32
  %81 = add i64 %80, 1
  %82 = icmp slt i64 %79, 0
  %83 = select i1 %82, i64 %81, i64 %79
  %84 = sdiv i64 %83, 32
  %85 = mul i64 -32, %84
  %86 = mul i64 -32, %1
  %87 = add i64 %85, %86
  %88 = mul i64 -32, %polly.indvar90
  %89 = mul i64 -3, %polly.indvar90
  %90 = add i64 %89, %2
  %91 = add i64 %90, 5
  %92 = sub i64 %91, 32
  %93 = add i64 %92, 1
  %94 = icmp slt i64 %91, 0
  %95 = select i1 %94, i64 %93, i64 %91
  %96 = sdiv i64 %95, 32
  %97 = mul i64 -32, %96
  %98 = add i64 %88, %97
  %99 = add i64 %98, -640
  %100 = icmp sgt i64 %87, %99
  %101 = select i1 %100, i64 %87, i64 %99
  %102 = mul i64 -20, %polly.indvar90
  %polly.loop_guard98 = icmp sle i64 %101, %102
  br i1 %polly.loop_guard98, label %polly.loop_header95, label %polly.loop_exit97

polly.loop_exit97:                                ; preds = %polly.loop_exit106, %polly.loop_header86
  %polly.indvar_next91 = add nsw i64 %polly.indvar90, 32
  %polly.adjust_ub92 = sub i64 %76, 32
  %polly.loop_cond93 = icmp sle i64 %polly.indvar90, %polly.adjust_ub92
  br i1 %polly.loop_cond93, label %polly.loop_header86, label %polly.loop_exit88

polly.loop_header95:                              ; preds = %polly.loop_header86, %polly.loop_exit106
  %polly.indvar99 = phi i64 [ %polly.indvar_next100, %polly.loop_exit106 ], [ %101, %polly.loop_header86 ]
  %103 = mul i64 -1, %polly.indvar99
  %104 = mul i64 -1, %2
  %105 = add i64 %103, %104
  %106 = add i64 %105, -30
  %107 = add i64 %106, 20
  %108 = sub i64 %107, 1
  %109 = icmp slt i64 %106, 0
  %110 = select i1 %109, i64 %106, i64 %108
  %111 = sdiv i64 %110, 20
  %112 = icmp sgt i64 %111, %polly.indvar90
  %113 = select i1 %112, i64 %111, i64 %polly.indvar90
  %114 = sub i64 %103, 20
  %115 = add i64 %114, 1
  %116 = icmp slt i64 %103, 0
  %117 = select i1 %116, i64 %115, i64 %103
  %118 = sdiv i64 %117, 20
  %119 = add i64 %polly.indvar90, 31
  %120 = icmp slt i64 %118, %119
  %121 = select i1 %120, i64 %118, i64 %119
  %122 = icmp slt i64 %121, %76
  %123 = select i1 %122, i64 %121, i64 %76
  %polly.loop_guard107 = icmp sle i64 %113, %123
  br i1 %polly.loop_guard107, label %polly.loop_header104, label %polly.loop_exit106

polly.loop_exit106:                               ; preds = %polly.loop_exit115, %polly.loop_header95
  %polly.indvar_next100 = add nsw i64 %polly.indvar99, 32
  %polly.adjust_ub101 = sub i64 %102, 32
  %polly.loop_cond102 = icmp sle i64 %polly.indvar99, %polly.adjust_ub101
  br i1 %polly.loop_cond102, label %polly.loop_header95, label %polly.loop_exit97

polly.loop_header104:                             ; preds = %polly.loop_header95, %polly.loop_exit115
  %polly.indvar108 = phi i64 [ %polly.indvar_next109, %polly.loop_exit115 ], [ %113, %polly.loop_header95 ]
  %124 = mul i64 -20, %polly.indvar108
  %125 = add i64 %124, %104
  %126 = add i64 %125, 1
  %127 = icmp sgt i64 %polly.indvar99, %126
  %128 = select i1 %127, i64 %polly.indvar99, i64 %126
  %129 = add i64 %polly.indvar99, 31
  %130 = icmp slt i64 %124, %129
  %131 = select i1 %130, i64 %124, i64 %129
  %polly.loop_guard116 = icmp sle i64 %128, %131
  br i1 %polly.loop_guard116, label %polly.loop_header113, label %polly.loop_exit115

polly.loop_exit115:                               ; preds = %polly.loop_header113, %polly.loop_header104
  %polly.indvar_next109 = add nsw i64 %polly.indvar108, 1
  %polly.adjust_ub110 = sub i64 %123, 1
  %polly.loop_cond111 = icmp sle i64 %polly.indvar108, %polly.adjust_ub110
  br i1 %polly.loop_cond111, label %polly.loop_header104, label %polly.loop_exit106

polly.loop_header113:                             ; preds = %polly.loop_header104, %polly.loop_header113
  %polly.indvar117 = phi i64 [ %polly.indvar_next118, %polly.loop_header113 ], [ %128, %polly.loop_header104 ]
  %132 = mul i64 -1, %polly.indvar117
  %133 = add i64 %124, %132
  %p_.moved.to. = mul i64 %polly.indvar81, %polly.indvar108
  %p_.moved.to.32 = sitofp i32 %np to double
  %p_scevgep27 = getelementptr [140 x [160 x double]]* %A, i64 %polly.indvar81, i64 %polly.indvar108, i64 %133
  %p_122 = add i64 %p_.moved.to., %133
  %p_123 = trunc i64 %p_122 to i32
  %p_124 = srem i32 %p_123, %np
  %p_125 = sitofp i32 %p_124 to double
  %p_126 = fdiv double %p_125, %p_.moved.to.32
  store double %p_126, double* %p_scevgep27
  %p_indvar.next21 = add i64 %133, 1
  %polly.indvar_next118 = add nsw i64 %polly.indvar117, 1
  %polly.adjust_ub119 = sub i64 %131, 1
  %polly.loop_cond120 = icmp sle i64 %polly.indvar117, %polly.adjust_ub119
  br i1 %polly.loop_cond120, label %polly.loop_header113, label %polly.loop_exit115
}

declare void @polybench_timer_start(...) #1

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %nr, i32 %nq, i32 %np, [140 x [160 x double]]* %A) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
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
  %23 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %23) #4
  br label %24

; <label>:24                                      ; preds = %22, %17
  %25 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %26 = load double* %scevgep, align 8, !tbaa !1
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
  %31 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %32 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %31, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %33 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
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
!2 = metadata !{metadata !"double", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{metadata !6, metadata !6, i64 0}
!6 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!7 = metadata !{metadata !3, metadata !3, i64 0}
