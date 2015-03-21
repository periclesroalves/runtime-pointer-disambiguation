; ModuleID = './linear-algebra/blas/gemver/gemver.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [2 x i8] c"w\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %alpha = alloca double, align 8
  %beta = alloca double, align 8
  %0 = tail call i8* @polybench_alloc_data(i64 4000000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %3 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %4 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %5 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %6 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %7 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %8 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %9 = bitcast i8* %0 to [2000 x double]*
  %10 = bitcast i8* %1 to double*
  %11 = bitcast i8* %2 to double*
  %12 = bitcast i8* %3 to double*
  %13 = bitcast i8* %4 to double*
  %14 = bitcast i8* %5 to double*
  %15 = bitcast i8* %6 to double*
  %16 = bitcast i8* %7 to double*
  %17 = bitcast i8* %8 to double*
  call void @init_array(i32 2000, double* %alpha, double* %beta, [2000 x double]* %9, double* %10, double* %11, double* %12, double* %13, double* %14, double* %15, double* %16, double* %17)
  call void (...)* @polybench_timer_start() #3
  %18 = load double* %alpha, align 8, !tbaa !1
  %19 = load double* %beta, align 8, !tbaa !1
  call void @kernel_gemver(i32 2000, double %18, double %19, [2000 x double]* %9, double* %10, double* %11, double* %12, double* %13, double* %14, double* %15, double* %16, double* %17)
  call void (...)* @polybench_timer_stop() #3
  call void (...)* @polybench_timer_print() #3
  %20 = icmp sgt i32 %argc, 42
  br i1 %20, label %21, label %25

; <label>:21                                      ; preds = %.split
  %22 = load i8** %argv, align 8, !tbaa !5
  %23 = load i8* %22, align 1, !tbaa !7
  %phitmp = icmp eq i8 %23, 0
  br i1 %phitmp, label %24, label %25

; <label>:24                                      ; preds = %21
  call void @print_array(i32 2000, double* %14)
  br label %25

; <label>:25                                      ; preds = %21, %24, %.split
  call void @free(i8* %0) #3
  call void @free(i8* %1) #3
  call void @free(i8* %2) #3
  call void @free(i8* %3) #3
  call void @free(i8* %4) #3
  call void @free(i8* %5) #3
  call void @free(i8* %6) #3
  call void @free(i8* %7) #3
  call void @free(i8* %8) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %n, double* %alpha, double* %beta, [2000 x double]* noalias %A, double* noalias %u1, double* noalias %v1, double* noalias %u2, double* noalias %v2, double* noalias %w, double* noalias %x, double* noalias %y, double* noalias %z) #0 {
.split:
  store double 1.500000e+00, double* %alpha, align 8, !tbaa !1
  store double 1.200000e+00, double* %beta, align 8, !tbaa !1
  %0 = sitofp i32 %n to double
  %1 = icmp sgt i32 %n, 0
  br i1 %1, label %.lr.ph5, label %polly.merge

.lr.ph5:                                          ; preds = %.split
  %2 = zext i32 %n to i64
  %3 = icmp sge i64 %2, 1
  br i1 %3, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.then38, %polly.loop_exit51, %polly.cond36, %.lr.ph5, %.split
  ret void

polly.then:                                       ; preds = %.lr.ph5
  %4 = add i64 %2, -1
  %polly.loop_guard = icmp sle i64 0, %4
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond36

polly.cond36:                                     ; preds = %polly.then, %polly.loop_header
  %5 = sext i32 %n to i64
  %6 = icmp sge i64 %5, 1
  br i1 %6, label %polly.then38, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_i.02 = trunc i64 %polly.indvar to i32
  %p_ = add i64 %polly.indvar, 1
  %p_19 = trunc i64 %p_ to i32
  %p_scevgep11 = getelementptr double* %u1, i64 %polly.indvar
  %p_scevgep12 = getelementptr double* %u2, i64 %polly.indvar
  %p_scevgep13 = getelementptr double* %v1, i64 %polly.indvar
  %p_scevgep14 = getelementptr double* %v2, i64 %polly.indvar
  %p_scevgep15 = getelementptr double* %y, i64 %polly.indvar
  %p_scevgep16 = getelementptr double* %z, i64 %polly.indvar
  %p_scevgep17 = getelementptr double* %x, i64 %polly.indvar
  %p_scevgep18 = getelementptr double* %w, i64 %polly.indvar
  %p_20 = sitofp i32 %p_i.02 to double
  store double %p_20, double* %p_scevgep11
  %p_21 = sitofp i32 %p_19 to double
  %p_22 = fdiv double %p_21, %0
  %p_23 = fmul double %p_22, 5.000000e-01
  store double %p_23, double* %p_scevgep12
  %p_26 = fmul double %p_22, 2.500000e-01
  store double %p_26, double* %p_scevgep13
  %p_29 = fdiv double %p_22, 6.000000e+00
  store double %p_29, double* %p_scevgep14
  %p_32 = fmul double %p_22, 1.250000e-01
  store double %p_32, double* %p_scevgep15
  %p_35 = fdiv double %p_22, 9.000000e+00
  store double %p_35, double* %p_scevgep16
  store double 0.000000e+00, double* %p_scevgep17
  store double 0.000000e+00, double* %p_scevgep18
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %4, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond36

polly.then38:                                     ; preds = %polly.cond36
  br i1 %polly.loop_guard, label %polly.loop_header40, label %polly.merge

polly.loop_header40:                              ; preds = %polly.then38, %polly.loop_exit51
  %polly.indvar44 = phi i64 [ %polly.indvar_next45, %polly.loop_exit51 ], [ 0, %polly.then38 ]
  %7 = mul i64 -11, %2
  %8 = add i64 %7, 5
  %9 = sub i64 %8, 32
  %10 = add i64 %9, 1
  %11 = icmp slt i64 %8, 0
  %12 = select i1 %11, i64 %10, i64 %8
  %13 = sdiv i64 %12, 32
  %14 = mul i64 -32, %13
  %15 = mul i64 -32, %2
  %16 = add i64 %14, %15
  %17 = mul i64 -32, %polly.indvar44
  %18 = mul i64 -3, %polly.indvar44
  %19 = add i64 %18, %2
  %20 = add i64 %19, 5
  %21 = sub i64 %20, 32
  %22 = add i64 %21, 1
  %23 = icmp slt i64 %20, 0
  %24 = select i1 %23, i64 %22, i64 %20
  %25 = sdiv i64 %24, 32
  %26 = mul i64 -32, %25
  %27 = add i64 %17, %26
  %28 = add i64 %27, -640
  %29 = icmp sgt i64 %16, %28
  %30 = select i1 %29, i64 %16, i64 %28
  %31 = mul i64 -20, %polly.indvar44
  %polly.loop_guard52 = icmp sle i64 %30, %31
  br i1 %polly.loop_guard52, label %polly.loop_header49, label %polly.loop_exit51

polly.loop_exit51:                                ; preds = %polly.loop_exit60, %polly.loop_header40
  %polly.indvar_next45 = add nsw i64 %polly.indvar44, 32
  %polly.adjust_ub46 = sub i64 %4, 32
  %polly.loop_cond47 = icmp sle i64 %polly.indvar44, %polly.adjust_ub46
  br i1 %polly.loop_cond47, label %polly.loop_header40, label %polly.merge

polly.loop_header49:                              ; preds = %polly.loop_header40, %polly.loop_exit60
  %polly.indvar53 = phi i64 [ %polly.indvar_next54, %polly.loop_exit60 ], [ %30, %polly.loop_header40 ]
  %32 = mul i64 -1, %polly.indvar53
  %33 = mul i64 -1, %2
  %34 = add i64 %32, %33
  %35 = add i64 %34, -30
  %36 = add i64 %35, 20
  %37 = sub i64 %36, 1
  %38 = icmp slt i64 %35, 0
  %39 = select i1 %38, i64 %35, i64 %37
  %40 = sdiv i64 %39, 20
  %41 = icmp sgt i64 %40, %polly.indvar44
  %42 = select i1 %41, i64 %40, i64 %polly.indvar44
  %43 = sub i64 %32, 20
  %44 = add i64 %43, 1
  %45 = icmp slt i64 %32, 0
  %46 = select i1 %45, i64 %44, i64 %32
  %47 = sdiv i64 %46, 20
  %48 = add i64 %polly.indvar44, 31
  %49 = icmp slt i64 %47, %48
  %50 = select i1 %49, i64 %47, i64 %48
  %51 = icmp slt i64 %50, %4
  %52 = select i1 %51, i64 %50, i64 %4
  %polly.loop_guard61 = icmp sle i64 %42, %52
  br i1 %polly.loop_guard61, label %polly.loop_header58, label %polly.loop_exit60

polly.loop_exit60:                                ; preds = %polly.loop_exit69, %polly.loop_header49
  %polly.indvar_next54 = add nsw i64 %polly.indvar53, 32
  %polly.adjust_ub55 = sub i64 %31, 32
  %polly.loop_cond56 = icmp sle i64 %polly.indvar53, %polly.adjust_ub55
  br i1 %polly.loop_cond56, label %polly.loop_header49, label %polly.loop_exit51

polly.loop_header58:                              ; preds = %polly.loop_header49, %polly.loop_exit69
  %polly.indvar62 = phi i64 [ %polly.indvar_next63, %polly.loop_exit69 ], [ %42, %polly.loop_header49 ]
  %53 = mul i64 -20, %polly.indvar62
  %54 = add i64 %53, %33
  %55 = add i64 %54, 1
  %56 = icmp sgt i64 %polly.indvar53, %55
  %57 = select i1 %56, i64 %polly.indvar53, i64 %55
  %58 = add i64 %polly.indvar53, 31
  %59 = icmp slt i64 %53, %58
  %60 = select i1 %59, i64 %53, i64 %58
  %polly.loop_guard70 = icmp sle i64 %57, %60
  br i1 %polly.loop_guard70, label %polly.loop_header67, label %polly.loop_exit69

polly.loop_exit69:                                ; preds = %polly.loop_header67, %polly.loop_header58
  %polly.indvar_next63 = add nsw i64 %polly.indvar62, 1
  %polly.adjust_ub64 = sub i64 %52, 1
  %polly.loop_cond65 = icmp sle i64 %polly.indvar62, %polly.adjust_ub64
  br i1 %polly.loop_cond65, label %polly.loop_header58, label %polly.loop_exit60

polly.loop_header67:                              ; preds = %polly.loop_header58, %polly.loop_header67
  %polly.indvar71 = phi i64 [ %polly.indvar_next72, %polly.loop_header67 ], [ %57, %polly.loop_header58 ]
  %61 = mul i64 -1, %polly.indvar71
  %62 = add i64 %53, %61
  %p_scevgep = getelementptr [2000 x double]* %A, i64 %polly.indvar62, i64 %62
  %p_76 = mul i64 %polly.indvar62, %62
  %p_77 = trunc i64 %p_76 to i32
  %p_78 = srem i32 %p_77, %n
  %p_79 = sitofp i32 %p_78 to double
  %p_80 = fdiv double %p_79, %0
  store double %p_80, double* %p_scevgep
  %p_indvar.next = add i64 %62, 1
  %polly.indvar_next72 = add nsw i64 %polly.indvar71, 1
  %polly.adjust_ub73 = sub i64 %60, 1
  %polly.loop_cond74 = icmp sle i64 %polly.indvar71, %polly.adjust_ub73
  br i1 %polly.loop_cond74, label %polly.loop_header67, label %polly.loop_exit69
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_gemver(i32 %n, double %alpha, double %beta, [2000 x double]* noalias %A, double* noalias %u1, double* noalias %v1, double* noalias %u2, double* noalias %v2, double* noalias %w, double* noalias %x, double* noalias %y, double* noalias %z) #0 {
polly.split_new_and_old:
  %0 = zext i32 %n to i64
  %1 = sext i32 %n to i64
  %2 = icmp sge i64 %1, 1
  br i1 %2, label %polly.stmt..preheader.lr.ph, label %polly.merge

polly.merge:                                      ; preds = %polly.then171, %polly.loop_header173, %polly.stmt..preheader3.lr.ph, %polly.split_new_and_old
  ret void

polly.stmt..preheader.lr.ph:                      ; preds = %polly.split_new_and_old
  %3 = icmp sge i64 %0, 1
  br i1 %3, label %polly.then66, label %polly.cond67

polly.cond67:                                     ; preds = %polly.then66, %polly.loop_header, %polly.stmt..preheader.lr.ph
  br i1 %3, label %polly.then69, label %polly.cond97

polly.cond97:                                     ; preds = %polly.then69, %polly.loop_exit83, %polly.cond67
  br i1 %3, label %polly.then99, label %polly.cond125

polly.cond125:                                    ; preds = %polly.then99, %polly.loop_exit112, %polly.cond97
  br i1 %3, label %polly.then127, label %polly.cond141

polly.cond141:                                    ; preds = %polly.then127, %polly.loop_header129, %polly.cond125
  br i1 %3, label %polly.then143, label %polly.stmt..preheader3.lr.ph

polly.stmt..preheader3.lr.ph:                     ; preds = %polly.then143, %polly.loop_exit156, %polly.cond141
  br i1 %3, label %polly.then171, label %polly.merge

polly.then66:                                     ; preds = %polly.stmt..preheader.lr.ph
  %4 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %4
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond67

polly.loop_header:                                ; preds = %polly.then66, %polly.loop_header
  %i.37.reg2mem.0 = phi i32 [ 0, %polly.then66 ], [ %p_, %polly.loop_header ]
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then66 ]
  %p_ = add nsw i32 %i.37.reg2mem.0, 1
  %p_indvar.next20 = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %4, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond67

polly.then69:                                     ; preds = %polly.cond67
  %5 = add i64 %0, -1
  %polly.loop_guard74 = icmp sle i64 0, %5
  br i1 %polly.loop_guard74, label %polly.loop_header71, label %polly.cond97

polly.loop_header71:                              ; preds = %polly.then69, %polly.loop_exit83
  %polly.indvar75 = phi i64 [ %polly.indvar_next76, %polly.loop_exit83 ], [ 0, %polly.then69 ]
  %p_scevgep52.moved.to..lr.ph16 = getelementptr double* %u1, i64 %polly.indvar75
  %p_scevgep53.moved.to..lr.ph16 = getelementptr double* %u2, i64 %polly.indvar75
  %_p_scalar_ = load double* %p_scevgep52.moved.to..lr.ph16
  %_p_scalar_79 = load double* %p_scevgep53.moved.to..lr.ph16
  br i1 %polly.loop_guard74, label %polly.loop_header81, label %polly.loop_exit83

polly.loop_exit83:                                ; preds = %polly.loop_header81, %polly.loop_header71
  %polly.indvar_next76 = add nsw i64 %polly.indvar75, 1
  %polly.adjust_ub77 = sub i64 %5, 1
  %polly.loop_cond78 = icmp sle i64 %polly.indvar75, %polly.adjust_ub77
  br i1 %polly.loop_cond78, label %polly.loop_header71, label %polly.cond97

polly.loop_header81:                              ; preds = %polly.loop_header71, %polly.loop_header81
  %polly.indvar85 = phi i64 [ %polly.indvar_next86, %polly.loop_header81 ], [ 0, %polly.loop_header71 ]
  %p_scevgep47 = getelementptr [2000 x double]* %A, i64 %polly.indvar75, i64 %polly.indvar85
  %p_scevgep48 = getelementptr double* %v1, i64 %polly.indvar85
  %p_scevgep49 = getelementptr double* %v2, i64 %polly.indvar85
  %_p_scalar_90 = load double* %p_scevgep47
  %_p_scalar_91 = load double* %p_scevgep48
  %p_92 = fmul double %_p_scalar_, %_p_scalar_91
  %p_93 = fadd double %_p_scalar_90, %p_92
  %_p_scalar_94 = load double* %p_scevgep49
  %p_95 = fmul double %_p_scalar_79, %_p_scalar_94
  %p_96 = fadd double %p_93, %p_95
  store double %p_96, double* %p_scevgep47
  %p_indvar.next43 = add i64 %polly.indvar85, 1
  %polly.indvar_next86 = add nsw i64 %polly.indvar85, 1
  %polly.adjust_ub87 = sub i64 %5, 1
  %polly.loop_cond88 = icmp sle i64 %polly.indvar85, %polly.adjust_ub87
  br i1 %polly.loop_cond88, label %polly.loop_header81, label %polly.loop_exit83

polly.then99:                                     ; preds = %polly.cond97
  %6 = add i64 %0, -1
  %polly.loop_guard104 = icmp sle i64 0, %6
  br i1 %polly.loop_guard104, label %polly.loop_header101, label %polly.cond125

polly.loop_header101:                             ; preds = %polly.then99, %polly.loop_exit112
  %polly.indvar105 = phi i64 [ %polly.indvar_next106, %polly.loop_exit112 ], [ 0, %polly.then99 ]
  %p_scevgep41.moved.to..lr.ph12 = getelementptr double* %x, i64 %polly.indvar105
  %.promoted37_p_scalar_ = load double* %p_scevgep41.moved.to..lr.ph12
  br i1 %polly.loop_guard104, label %polly.loop_header110, label %polly.loop_exit112

polly.loop_exit112:                               ; preds = %polly.loop_header110, %polly.loop_header101
  %.reg2mem54.0 = phi double [ %p_123, %polly.loop_header110 ], [ %.promoted37_p_scalar_, %polly.loop_header101 ]
  store double %.reg2mem54.0, double* %p_scevgep41.moved.to..lr.ph12
  %polly.indvar_next106 = add nsw i64 %polly.indvar105, 1
  %polly.adjust_ub107 = sub i64 %6, 1
  %polly.loop_cond108 = icmp sle i64 %polly.indvar105, %polly.adjust_ub107
  br i1 %polly.loop_cond108, label %polly.loop_header101, label %polly.cond125

polly.loop_header110:                             ; preds = %polly.loop_header101, %polly.loop_header110
  %.reg2mem54.1 = phi double [ %.promoted37_p_scalar_, %polly.loop_header101 ], [ %p_123, %polly.loop_header110 ]
  %polly.indvar114 = phi i64 [ %polly.indvar_next115, %polly.loop_header110 ], [ 0, %polly.loop_header101 ]
  %p_scevgep35 = getelementptr [2000 x double]* %A, i64 %polly.indvar114, i64 %polly.indvar105
  %p_scevgep36 = getelementptr double* %y, i64 %polly.indvar114
  %_p_scalar_119 = load double* %p_scevgep35
  %p_120 = fmul double %_p_scalar_119, %beta
  %_p_scalar_121 = load double* %p_scevgep36
  %p_122 = fmul double %p_120, %_p_scalar_121
  %p_123 = fadd double %.reg2mem54.1, %p_122
  %p_indvar.next31 = add i64 %polly.indvar114, 1
  %polly.indvar_next115 = add nsw i64 %polly.indvar114, 1
  %polly.adjust_ub116 = sub i64 %6, 1
  %polly.loop_cond117 = icmp sle i64 %polly.indvar114, %polly.adjust_ub116
  br i1 %polly.loop_cond117, label %polly.loop_header110, label %polly.loop_exit112

polly.then127:                                    ; preds = %polly.cond125
  %7 = add i64 %0, -1
  %polly.loop_guard132 = icmp sle i64 0, %7
  br i1 %polly.loop_guard132, label %polly.loop_header129, label %polly.cond141

polly.loop_header129:                             ; preds = %polly.then127, %polly.loop_header129
  %polly.indvar133 = phi i64 [ %polly.indvar_next134, %polly.loop_header129 ], [ 0, %polly.then127 ]
  %p_scevgep28 = getelementptr double* %x, i64 %polly.indvar133
  %p_scevgep29 = getelementptr double* %z, i64 %polly.indvar133
  %_p_scalar_138 = load double* %p_scevgep28
  %_p_scalar_139 = load double* %p_scevgep29
  %p_140 = fadd double %_p_scalar_138, %_p_scalar_139
  store double %p_140, double* %p_scevgep28
  %p_indvar.next26 = add i64 %polly.indvar133, 1
  %polly.indvar_next134 = add nsw i64 %polly.indvar133, 1
  %polly.adjust_ub135 = sub i64 %7, 1
  %polly.loop_cond136 = icmp sle i64 %polly.indvar133, %polly.adjust_ub135
  br i1 %polly.loop_cond136, label %polly.loop_header129, label %polly.cond141

polly.then143:                                    ; preds = %polly.cond141
  %8 = add i64 %0, -1
  %polly.loop_guard148 = icmp sle i64 0, %8
  br i1 %polly.loop_guard148, label %polly.loop_header145, label %polly.stmt..preheader3.lr.ph

polly.loop_header145:                             ; preds = %polly.then143, %polly.loop_exit156
  %polly.indvar149 = phi i64 [ %polly.indvar_next150, %polly.loop_exit156 ], [ 0, %polly.then143 ]
  %p_scevgep24.moved.to..lr.ph = getelementptr double* %w, i64 %polly.indvar149
  %.promoted_p_scalar_ = load double* %p_scevgep24.moved.to..lr.ph
  br i1 %polly.loop_guard148, label %polly.loop_header154, label %polly.loop_exit156

polly.loop_exit156:                               ; preds = %polly.loop_header154, %polly.loop_header145
  %.reg2mem.0 = phi double [ %p_167, %polly.loop_header154 ], [ %.promoted_p_scalar_, %polly.loop_header145 ]
  store double %.reg2mem.0, double* %p_scevgep24.moved.to..lr.ph
  %polly.indvar_next150 = add nsw i64 %polly.indvar149, 1
  %polly.adjust_ub151 = sub i64 %8, 1
  %polly.loop_cond152 = icmp sle i64 %polly.indvar149, %polly.adjust_ub151
  br i1 %polly.loop_cond152, label %polly.loop_header145, label %polly.stmt..preheader3.lr.ph

polly.loop_header154:                             ; preds = %polly.loop_header145, %polly.loop_header154
  %.reg2mem.1 = phi double [ %.promoted_p_scalar_, %polly.loop_header145 ], [ %p_167, %polly.loop_header154 ]
  %polly.indvar158 = phi i64 [ %polly.indvar_next159, %polly.loop_header154 ], [ 0, %polly.loop_header145 ]
  %p_scevgep = getelementptr [2000 x double]* %A, i64 %polly.indvar149, i64 %polly.indvar158
  %p_scevgep21 = getelementptr double* %x, i64 %polly.indvar158
  %_p_scalar_163 = load double* %p_scevgep
  %p_164 = fmul double %_p_scalar_163, %alpha
  %_p_scalar_165 = load double* %p_scevgep21
  %p_166 = fmul double %p_164, %_p_scalar_165
  %p_167 = fadd double %.reg2mem.1, %p_166
  %p_indvar.next = add i64 %polly.indvar158, 1
  %polly.indvar_next159 = add nsw i64 %polly.indvar158, 1
  %polly.adjust_ub160 = sub i64 %8, 1
  %polly.loop_cond161 = icmp sle i64 %polly.indvar158, %polly.adjust_ub160
  br i1 %polly.loop_cond161, label %polly.loop_header154, label %polly.loop_exit156

polly.then171:                                    ; preds = %polly.stmt..preheader3.lr.ph
  %9 = add i64 %0, -1
  %polly.loop_guard176 = icmp sle i64 0, %9
  br i1 %polly.loop_guard176, label %polly.loop_header173, label %polly.merge

polly.loop_header173:                             ; preds = %polly.then171, %polly.loop_header173
  %i.114.reg2mem.0 = phi i32 [ 0, %polly.then171 ], [ %p_182, %polly.loop_header173 ]
  %polly.indvar177 = phi i64 [ %polly.indvar_next178, %polly.loop_header173 ], [ 0, %polly.then171 ]
  %p_182 = add nsw i32 %i.114.reg2mem.0, 1
  %p_indvar.next34 = add i64 %polly.indvar177, 1
  %polly.indvar_next178 = add nsw i64 %polly.indvar177, 1
  %polly.adjust_ub179 = sub i64 %9, 1
  %polly.loop_cond180 = icmp sle i64 %polly.indvar177, %polly.adjust_ub179
  br i1 %polly.loop_cond180, label %polly.loop_header173, label %polly.merge
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, double* noalias %w) #0 {
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
  %scevgep = getelementptr double* %w, i64 %indvar
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
