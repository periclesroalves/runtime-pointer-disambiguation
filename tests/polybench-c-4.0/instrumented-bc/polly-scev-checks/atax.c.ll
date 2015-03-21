; ModuleID = './linear-algebra/kernels/atax/atax.c'
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
  %0 = tail call i8* @polybench_alloc_data(i64 3990000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 2100, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 2100, i32 8) #3
  %3 = tail call i8* @polybench_alloc_data(i64 1900, i32 8) #3
  %4 = bitcast i8* %0 to [2100 x double]*
  %5 = bitcast i8* %1 to double*
  tail call void @init_array(i32 1900, i32 2100, [2100 x double]* %4, double* %5)
  tail call void (...)* @polybench_timer_start() #3
  %6 = bitcast i8* %2 to double*
  %7 = bitcast i8* %3 to double*
  tail call void @kernel_atax(i32 1900, i32 2100, [2100 x double]* %4, double* %5, double* %6, double* %7)
  tail call void (...)* @polybench_timer_stop() #3
  tail call void (...)* @polybench_timer_print() #3
  %8 = icmp sgt i32 %argc, 42
  br i1 %8, label %9, label %13

; <label>:9                                       ; preds = %.split
  %10 = load i8** %argv, align 8, !tbaa !1
  %11 = load i8* %10, align 1, !tbaa !5
  %phitmp = icmp eq i8 %11, 0
  br i1 %phitmp, label %12, label %13

; <label>:12                                      ; preds = %9
  tail call void @print_array(i32 2100, double* %6)
  br label %13

; <label>:13                                      ; preds = %9, %12, %.split
  tail call void @free(i8* %0) #3
  tail call void @free(i8* %1) #3
  tail call void @free(i8* %2) #3
  tail call void @free(i8* %3) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %m, i32 %n, [2100 x double]* %A, double* %x) #0 {
polly.split_new_and_old63:
  %0 = zext i32 %n to i64
  %1 = sext i32 %n to i64
  %2 = icmp sge i64 %1, 1
  %3 = icmp sge i64 %0, 1
  %4 = and i1 %2, %3
  br i1 %4, label %polly.then68, label %polly.merge67

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit34, %polly.merge67
  ret void

polly.then:                                       ; preds = %polly.merge67
  %5 = add i64 %63, -1
  %polly.loop_guard = icmp sle i64 0, %5
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit34
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit34 ], [ 0, %polly.then ]
  %6 = mul i64 -3, %63
  %7 = add i64 %6, %0
  %8 = add i64 %7, 5
  %9 = sub i64 %8, 32
  %10 = add i64 %9, 1
  %11 = icmp slt i64 %8, 0
  %12 = select i1 %11, i64 %10, i64 %8
  %13 = sdiv i64 %12, 32
  %14 = mul i64 -32, %13
  %15 = mul i64 -32, %63
  %16 = add i64 %14, %15
  %17 = mul i64 -32, %polly.indvar
  %18 = mul i64 -3, %polly.indvar
  %19 = add i64 %18, %0
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
  %31 = mul i64 -20, %polly.indvar
  %polly.loop_guard35 = icmp sle i64 %30, %31
  br i1 %polly.loop_guard35, label %polly.loop_header32, label %polly.loop_exit34

polly.loop_exit34:                                ; preds = %polly.loop_exit43, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %5, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header32:                              ; preds = %polly.loop_header, %polly.loop_exit43
  %polly.indvar36 = phi i64 [ %polly.indvar_next37, %polly.loop_exit43 ], [ %30, %polly.loop_header ]
  %32 = mul i64 -1, %polly.indvar36
  %33 = mul i64 -1, %0
  %34 = add i64 %32, %33
  %35 = add i64 %34, -30
  %36 = add i64 %35, 20
  %37 = sub i64 %36, 1
  %38 = icmp slt i64 %35, 0
  %39 = select i1 %38, i64 %35, i64 %37
  %40 = sdiv i64 %39, 20
  %41 = icmp sgt i64 %40, %polly.indvar
  %42 = select i1 %41, i64 %40, i64 %polly.indvar
  %43 = sub i64 %32, 20
  %44 = add i64 %43, 1
  %45 = icmp slt i64 %32, 0
  %46 = select i1 %45, i64 %44, i64 %32
  %47 = sdiv i64 %46, 20
  %48 = add i64 %polly.indvar, 31
  %49 = icmp slt i64 %47, %48
  %50 = select i1 %49, i64 %47, i64 %48
  %51 = icmp slt i64 %50, %5
  %52 = select i1 %51, i64 %50, i64 %5
  %polly.loop_guard44 = icmp sle i64 %42, %52
  br i1 %polly.loop_guard44, label %polly.loop_header41, label %polly.loop_exit43

polly.loop_exit43:                                ; preds = %polly.loop_exit52, %polly.loop_header32
  %polly.indvar_next37 = add nsw i64 %polly.indvar36, 32
  %polly.adjust_ub38 = sub i64 %31, 32
  %polly.loop_cond39 = icmp sle i64 %polly.indvar36, %polly.adjust_ub38
  br i1 %polly.loop_cond39, label %polly.loop_header32, label %polly.loop_exit34

polly.loop_header41:                              ; preds = %polly.loop_header32, %polly.loop_exit52
  %polly.indvar45 = phi i64 [ %polly.indvar_next46, %polly.loop_exit52 ], [ %42, %polly.loop_header32 ]
  %53 = mul i64 -20, %polly.indvar45
  %54 = add i64 %53, %33
  %55 = add i64 %54, 1
  %56 = icmp sgt i64 %polly.indvar36, %55
  %57 = select i1 %56, i64 %polly.indvar36, i64 %55
  %58 = add i64 %polly.indvar36, 31
  %59 = icmp slt i64 %53, %58
  %60 = select i1 %59, i64 %53, i64 %58
  %polly.loop_guard53 = icmp sle i64 %57, %60
  br i1 %polly.loop_guard53, label %polly.loop_header50, label %polly.loop_exit52

polly.loop_exit52:                                ; preds = %polly.loop_header50, %polly.loop_header41
  %polly.indvar_next46 = add nsw i64 %polly.indvar45, 1
  %polly.adjust_ub47 = sub i64 %52, 1
  %polly.loop_cond48 = icmp sle i64 %polly.indvar45, %polly.adjust_ub47
  br i1 %polly.loop_cond48, label %polly.loop_header41, label %polly.loop_exit43

polly.loop_header50:                              ; preds = %polly.loop_header41, %polly.loop_header50
  %polly.indvar54 = phi i64 [ %polly.indvar_next55, %polly.loop_header50 ], [ %57, %polly.loop_header41 ]
  %61 = mul i64 -1, %polly.indvar54
  %62 = add i64 %53, %61
  %p_.moved.to. = mul nsw i32 %m, 5
  %p_.moved.to.17 = sitofp i32 %p_.moved.to. to double
  %p_ = add i64 %polly.indvar45, %62
  %p_58 = trunc i64 %p_ to i32
  %p_scevgep = getelementptr [2100 x double]* %A, i64 %polly.indvar45, i64 %62
  %p_59 = srem i32 %p_58, %n
  %p_60 = sitofp i32 %p_59 to double
  %p_61 = fdiv double %p_60, %p_.moved.to.17
  store double %p_61, double* %p_scevgep
  %p_indvar.next = add i64 %62, 1
  %polly.indvar_next55 = add nsw i64 %polly.indvar54, 1
  %polly.adjust_ub56 = sub i64 %60, 1
  %polly.loop_cond57 = icmp sle i64 %polly.indvar54, %polly.adjust_ub56
  br i1 %polly.loop_cond57, label %polly.loop_header50, label %polly.loop_exit52

polly.merge67:                                    ; preds = %polly.then68, %polly.loop_header70, %polly.split_new_and_old63
  %63 = zext i32 %m to i64
  %64 = sext i32 %m to i64
  %65 = icmp sge i64 %64, 1
  %66 = and i1 %65, %2
  %67 = icmp sge i64 %63, 1
  %68 = and i1 %66, %67
  %69 = and i1 %68, %3
  br i1 %69, label %polly.then, label %polly.merge

polly.then68:                                     ; preds = %polly.split_new_and_old63
  %70 = add i64 %0, -1
  %polly.loop_guard73 = icmp sle i64 0, %70
  br i1 %polly.loop_guard73, label %polly.loop_header70, label %polly.merge67

polly.loop_header70:                              ; preds = %polly.then68, %polly.loop_header70
  %polly.indvar74 = phi i64 [ %polly.indvar_next75, %polly.loop_header70 ], [ 0, %polly.then68 ]
  %p_.moved.to.24 = sitofp i32 %n to double
  %p_i.06 = trunc i64 %polly.indvar74 to i32
  %p_scevgep16 = getelementptr double* %x, i64 %polly.indvar74
  %p_79 = sitofp i32 %p_i.06 to double
  %p_80 = fdiv double %p_79, %p_.moved.to.24
  %p_81 = fadd double %p_80, 1.000000e+00
  store double %p_81, double* %p_scevgep16
  %p_indvar.next14 = add i64 %polly.indvar74, 1
  %polly.indvar_next75 = add nsw i64 %polly.indvar74, 1
  %polly.adjust_ub76 = sub i64 %70, 1
  %polly.loop_cond77 = icmp sle i64 %polly.indvar74, %polly.adjust_ub76
  br i1 %polly.loop_cond77, label %polly.loop_header70, label %polly.merge67
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_atax(i32 %m, i32 %n, [2100 x double]* %A, double* %x, double* %y, double* %tmp) #0 {
polly.split_new_and_old137:
  %x31 = bitcast double* %x to i8*
  %y33 = bitcast double* %y to i8*
  %tmp36 = bitcast double* %tmp to i8*
  %tmp35 = ptrtoint double* %tmp to i64
  %y32 = ptrtoint double* %y to i64
  %x28 = ptrtoint double* %x to i64
  %A27 = ptrtoint [2100 x double]* %A to i64
  %0 = zext i32 %n to i64
  %1 = sext i32 %n to i64
  %2 = icmp sge i64 %1, 1
  %3 = icmp sge i64 %0, 1
  %4 = and i1 %2, %3
  br i1 %4, label %polly.then142, label %polly.merge141

.preheader1.split.clone:                          ; preds = %polly.merge141
  %5 = icmp sgt i32 %m, 0
  br i1 %5, label %.lr.ph6.clone, label %.region.clone

.lr.ph6.clone:                                    ; preds = %.preheader1.split.clone
  %6 = icmp sgt i32 %n, 0
  br label %7

; <label>:7                                       ; preds = %._crit_edge.clone, %.lr.ph6.clone
  %indvar11.clone = phi i64 [ 0, %.lr.ph6.clone ], [ %indvar.next12.clone, %._crit_edge.clone ]
  %scevgep22.clone = getelementptr double* %tmp, i64 %indvar11.clone
  store double 0.000000e+00, double* %scevgep22.clone, align 8, !tbaa !6
  br i1 %6, label %.lr.ph.clone, label %.preheader.clone

.lr.ph.clone:                                     ; preds = %7, %.lr.ph.clone
  %indvar.clone = phi i64 [ %indvar.next.clone, %.lr.ph.clone ], [ 0, %7 ]
  %scevgep.clone = getelementptr [2100 x double]* %A, i64 %indvar11.clone, i64 %indvar.clone
  %scevgep13.clone = getelementptr double* %x, i64 %indvar.clone
  %8 = load double* %scevgep22.clone, align 8, !tbaa !6
  %9 = load double* %scevgep.clone, align 8, !tbaa !6
  %10 = load double* %scevgep13.clone, align 8, !tbaa !6
  %11 = fmul double %9, %10
  %12 = fadd double %8, %11
  store double %12, double* %scevgep22.clone, align 8, !tbaa !6
  %indvar.next.clone = add i64 %indvar.clone, 1
  %exitcond.clone = icmp ne i64 %indvar.next.clone, %0
  br i1 %exitcond.clone, label %.lr.ph.clone, label %.preheader.clone

.preheader.clone:                                 ; preds = %.lr.ph.clone, %7
  br i1 %6, label %.lr.ph4.clone, label %._crit_edge.clone

.lr.ph4.clone:                                    ; preds = %.preheader.clone, %.lr.ph4.clone
  %indvar14.clone = phi i64 [ %indvar.next15.clone, %.lr.ph4.clone ], [ 0, %.preheader.clone ]
  %scevgep18.clone = getelementptr [2100 x double]* %A, i64 %indvar11.clone, i64 %indvar14.clone
  %scevgep17.clone = getelementptr double* %y, i64 %indvar14.clone
  %13 = load double* %scevgep17.clone, align 8, !tbaa !6
  %14 = load double* %scevgep18.clone, align 8, !tbaa !6
  %15 = load double* %scevgep22.clone, align 8, !tbaa !6
  %16 = fmul double %14, %15
  %17 = fadd double %13, %16
  store double %17, double* %scevgep17.clone, align 8, !tbaa !6
  %indvar.next15.clone = add i64 %indvar14.clone, 1
  %exitcond16.clone = icmp ne i64 %indvar.next15.clone, %0
  br i1 %exitcond16.clone, label %.lr.ph4.clone, label %._crit_edge.clone

._crit_edge.clone:                                ; preds = %.lr.ph4.clone, %.preheader.clone
  %indvar.next12.clone = add i64 %indvar11.clone, 1
  %exitcond19.clone = icmp ne i64 %indvar.next12.clone, %34
  br i1 %exitcond19.clone, label %7, label %.region.clone

.region.clone:                                    ; preds = %polly.then93, %polly.loop_exit106, %polly.cond91, %polly.start, %.preheader1.split.clone, %._crit_edge.clone
  ret void

polly.start:                                      ; preds = %polly.merge141
  %18 = sext i32 %m to i64
  %19 = icmp sge i64 %18, 1
  %20 = icmp sge i64 %34, 1
  %21 = and i1 %19, %20
  br i1 %21, label %polly.then, label %.region.clone

polly.then:                                       ; preds = %polly.start
  %polly.loop_guard = icmp sle i64 0, %35
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond48

polly.cond48:                                     ; preds = %polly.then, %polly.loop_header
  br i1 %4, label %polly.then50, label %polly.cond91

polly.cond91:                                     ; preds = %polly.then50, %polly.loop_exit63, %polly.cond48
  br i1 %4, label %polly.then93, label %.region.clone

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_scevgep22 = getelementptr double* %tmp, i64 %polly.indvar
  store double 0.000000e+00, double* %p_scevgep22
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %35, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond48

polly.then50:                                     ; preds = %polly.cond48
  br i1 %polly.loop_guard, label %polly.loop_header52, label %polly.cond91

polly.loop_header52:                              ; preds = %polly.then50, %polly.loop_exit63
  %polly.indvar56 = phi i64 [ %polly.indvar_next57, %polly.loop_exit63 ], [ 0, %polly.then50 ]
  %polly.loop_guard64 = icmp sle i64 0, %38
  br i1 %polly.loop_guard64, label %polly.loop_header61, label %polly.loop_exit63

polly.loop_exit63:                                ; preds = %polly.loop_exit72, %polly.loop_header52
  %polly.indvar_next57 = add nsw i64 %polly.indvar56, 32
  %polly.adjust_ub58 = sub i64 %35, 32
  %polly.loop_cond59 = icmp sle i64 %polly.indvar56, %polly.adjust_ub58
  br i1 %polly.loop_cond59, label %polly.loop_header52, label %polly.cond91

polly.loop_header61:                              ; preds = %polly.loop_header52, %polly.loop_exit72
  %polly.indvar65 = phi i64 [ %polly.indvar_next66, %polly.loop_exit72 ], [ 0, %polly.loop_header52 ]
  %22 = add i64 %polly.indvar56, 31
  %23 = icmp slt i64 %22, %35
  %24 = select i1 %23, i64 %22, i64 %35
  %polly.loop_guard73 = icmp sle i64 %polly.indvar56, %24
  br i1 %polly.loop_guard73, label %polly.loop_header70, label %polly.loop_exit72

polly.loop_exit72:                                ; preds = %polly.loop_exit81, %polly.loop_header61
  %polly.indvar_next66 = add nsw i64 %polly.indvar65, 32
  %polly.adjust_ub67 = sub i64 %38, 32
  %polly.loop_cond68 = icmp sle i64 %polly.indvar65, %polly.adjust_ub67
  br i1 %polly.loop_cond68, label %polly.loop_header61, label %polly.loop_exit63

polly.loop_header70:                              ; preds = %polly.loop_header61, %polly.loop_exit81
  %polly.indvar74 = phi i64 [ %polly.indvar_next75, %polly.loop_exit81 ], [ %polly.indvar56, %polly.loop_header61 ]
  %25 = add i64 %polly.indvar65, 31
  %26 = icmp slt i64 %25, %38
  %27 = select i1 %26, i64 %25, i64 %38
  %polly.loop_guard82 = icmp sle i64 %polly.indvar65, %27
  br i1 %polly.loop_guard82, label %polly.loop_header79, label %polly.loop_exit81

polly.loop_exit81:                                ; preds = %polly.loop_header79, %polly.loop_header70
  %polly.indvar_next75 = add nsw i64 %polly.indvar74, 1
  %polly.adjust_ub76 = sub i64 %24, 1
  %polly.loop_cond77 = icmp sle i64 %polly.indvar74, %polly.adjust_ub76
  br i1 %polly.loop_cond77, label %polly.loop_header70, label %polly.loop_exit72

polly.loop_header79:                              ; preds = %polly.loop_header70, %polly.loop_header79
  %polly.indvar83 = phi i64 [ %polly.indvar_next84, %polly.loop_header79 ], [ %polly.indvar65, %polly.loop_header70 ]
  %p_scevgep22.moved.to. = getelementptr double* %tmp, i64 %polly.indvar74
  %p_scevgep = getelementptr [2100 x double]* %A, i64 %polly.indvar74, i64 %polly.indvar83
  %p_scevgep13 = getelementptr double* %x, i64 %polly.indvar83
  %_p_scalar_ = load double* %p_scevgep22.moved.to.
  %_p_scalar_88 = load double* %p_scevgep
  %_p_scalar_89 = load double* %p_scevgep13
  %p_ = fmul double %_p_scalar_88, %_p_scalar_89
  %p_90 = fadd double %_p_scalar_, %p_
  store double %p_90, double* %p_scevgep22.moved.to.
  %p_indvar.next = add i64 %polly.indvar83, 1
  %polly.indvar_next84 = add nsw i64 %polly.indvar83, 1
  %polly.adjust_ub85 = sub i64 %27, 1
  %polly.loop_cond86 = icmp sle i64 %polly.indvar83, %polly.adjust_ub85
  br i1 %polly.loop_cond86, label %polly.loop_header79, label %polly.loop_exit81

polly.then93:                                     ; preds = %polly.cond91
  %polly.loop_guard98 = icmp sle i64 0, %38
  br i1 %polly.loop_guard98, label %polly.loop_header95, label %.region.clone

polly.loop_header95:                              ; preds = %polly.then93, %polly.loop_exit106
  %polly.indvar99 = phi i64 [ %polly.indvar_next100, %polly.loop_exit106 ], [ 0, %polly.then93 ]
  br i1 %polly.loop_guard, label %polly.loop_header104, label %polly.loop_exit106

polly.loop_exit106:                               ; preds = %polly.loop_exit115, %polly.loop_header95
  %polly.indvar_next100 = add nsw i64 %polly.indvar99, 32
  %polly.adjust_ub101 = sub i64 %38, 32
  %polly.loop_cond102 = icmp sle i64 %polly.indvar99, %polly.adjust_ub101
  br i1 %polly.loop_cond102, label %polly.loop_header95, label %.region.clone

polly.loop_header104:                             ; preds = %polly.loop_header95, %polly.loop_exit115
  %polly.indvar108 = phi i64 [ %polly.indvar_next109, %polly.loop_exit115 ], [ 0, %polly.loop_header95 ]
  %28 = add i64 %polly.indvar99, 31
  %29 = icmp slt i64 %28, %38
  %30 = select i1 %29, i64 %28, i64 %38
  %polly.loop_guard116 = icmp sle i64 %polly.indvar99, %30
  br i1 %polly.loop_guard116, label %polly.loop_header113, label %polly.loop_exit115

polly.loop_exit115:                               ; preds = %polly.loop_exit124, %polly.loop_header104
  %polly.indvar_next109 = add nsw i64 %polly.indvar108, 32
  %polly.adjust_ub110 = sub i64 %35, 32
  %polly.loop_cond111 = icmp sle i64 %polly.indvar108, %polly.adjust_ub110
  br i1 %polly.loop_cond111, label %polly.loop_header104, label %polly.loop_exit106

polly.loop_header113:                             ; preds = %polly.loop_header104, %polly.loop_exit124
  %polly.indvar117 = phi i64 [ %polly.indvar_next118, %polly.loop_exit124 ], [ %polly.indvar99, %polly.loop_header104 ]
  %31 = add i64 %polly.indvar108, 31
  %32 = icmp slt i64 %31, %35
  %33 = select i1 %32, i64 %31, i64 %35
  %polly.loop_guard125 = icmp sle i64 %polly.indvar108, %33
  br i1 %polly.loop_guard125, label %polly.loop_header122, label %polly.loop_exit124

polly.loop_exit124:                               ; preds = %polly.loop_header122, %polly.loop_header113
  %polly.indvar_next118 = add nsw i64 %polly.indvar117, 1
  %polly.adjust_ub119 = sub i64 %30, 1
  %polly.loop_cond120 = icmp sle i64 %polly.indvar117, %polly.adjust_ub119
  br i1 %polly.loop_cond120, label %polly.loop_header113, label %polly.loop_exit115

polly.loop_header122:                             ; preds = %polly.loop_header113, %polly.loop_header122
  %polly.indvar126 = phi i64 [ %polly.indvar_next127, %polly.loop_header122 ], [ %polly.indvar108, %polly.loop_header113 ]
  %p_scevgep22.moved.to.42 = getelementptr double* %tmp, i64 %polly.indvar126
  %p_scevgep18 = getelementptr [2100 x double]* %A, i64 %polly.indvar126, i64 %polly.indvar117
  %p_scevgep17 = getelementptr double* %y, i64 %polly.indvar117
  %_p_scalar_131 = load double* %p_scevgep17
  %_p_scalar_132 = load double* %p_scevgep18
  %_p_scalar_133 = load double* %p_scevgep22.moved.to.42
  %p_134 = fmul double %_p_scalar_132, %_p_scalar_133
  %p_135 = fadd double %_p_scalar_131, %p_134
  store double %p_135, double* %p_scevgep17
  %p_indvar.next15 = add i64 %polly.indvar117, 1
  %polly.indvar_next127 = add nsw i64 %polly.indvar126, 1
  %polly.adjust_ub128 = sub i64 %33, 1
  %polly.loop_cond129 = icmp sle i64 %polly.indvar126, %polly.adjust_ub128
  br i1 %polly.loop_cond129, label %polly.loop_header122, label %polly.loop_exit124

polly.merge141:                                   ; preds = %polly.then142, %polly.loop_header144, %polly.split_new_and_old137
  %umin29 = bitcast [2100 x double]* %A to i8*
  %34 = zext i32 %m to i64
  %35 = add i64 %34, -1
  %36 = mul i64 16800, %35
  %37 = add i64 %A27, %36
  %38 = add i64 %0, -1
  %39 = mul i64 8, %38
  %40 = add i64 %37, %39
  %umax30 = inttoptr i64 %40 to i8*
  %41 = add i64 %x28, %39
  %42 = inttoptr i64 %41 to i8*
  %43 = icmp ult i8* %umax30, %x31
  %44 = icmp ult i8* %42, %umin29
  %pair-no-alias = or i1 %43, %44
  %45 = add i64 %y32, %39
  %46 = inttoptr i64 %45 to i8*
  %47 = icmp ult i8* %umax30, %y33
  %48 = icmp ult i8* %46, %umin29
  %pair-no-alias34 = or i1 %47, %48
  %49 = and i1 %pair-no-alias, %pair-no-alias34
  %50 = mul i64 8, %35
  %51 = add i64 %tmp35, %50
  %52 = inttoptr i64 %51 to i8*
  %53 = icmp ult i8* %umax30, %tmp36
  %54 = icmp ult i8* %52, %umin29
  %pair-no-alias37 = or i1 %53, %54
  %55 = and i1 %49, %pair-no-alias37
  %56 = icmp ult i8* %42, %y33
  %57 = icmp ult i8* %46, %x31
  %pair-no-alias38 = or i1 %56, %57
  %58 = and i1 %55, %pair-no-alias38
  %59 = icmp ult i8* %42, %tmp36
  %60 = icmp ult i8* %52, %x31
  %pair-no-alias39 = or i1 %59, %60
  %61 = and i1 %58, %pair-no-alias39
  %62 = icmp ult i8* %46, %tmp36
  %63 = icmp ult i8* %52, %y33
  %pair-no-alias40 = or i1 %62, %63
  %64 = and i1 %61, %pair-no-alias40
  br i1 %64, label %polly.start, label %.preheader1.split.clone

polly.then142:                                    ; preds = %polly.split_new_and_old137
  %65 = add i64 %0, -1
  %polly.loop_guard147 = icmp sle i64 0, %65
  br i1 %polly.loop_guard147, label %polly.loop_header144, label %polly.merge141

polly.loop_header144:                             ; preds = %polly.then142, %polly.loop_header144
  %polly.indvar148 = phi i64 [ %polly.indvar_next149, %polly.loop_header144 ], [ 0, %polly.then142 ]
  %p_scevgep26 = getelementptr double* %y, i64 %polly.indvar148
  store double 0.000000e+00, double* %p_scevgep26
  %p_indvar.next24 = add i64 %polly.indvar148, 1
  %polly.indvar_next149 = add nsw i64 %polly.indvar148, 1
  %polly.adjust_ub150 = sub i64 %65, 1
  %polly.loop_cond151 = icmp sle i64 %polly.indvar148, %polly.adjust_ub150
  br i1 %polly.loop_cond151, label %polly.loop_header144, label %polly.merge141
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, double* %y) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
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
  %11 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %11) #4
  br label %12

; <label>:12                                      ; preds = %10, %7
  %13 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %14 = load double* %scevgep, align 8, !tbaa !6
  %15 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %13, i8* getelementptr inbounds ([8 x i8]* @.str5, i64 0, i64 0), double %14) #5
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %6
  br i1 %exitcond, label %7, label %._crit_edge

._crit_edge:                                      ; preds = %12
  br label %16

; <label>:16                                      ; preds = %._crit_edge, %.split
  %17 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %18 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %17, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %19 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
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
!2 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{metadata !3, metadata !3, i64 0}
!6 = metadata !{metadata !7, metadata !7, i64 0}
!7 = metadata !{metadata !"double", metadata !3, i64 0}
