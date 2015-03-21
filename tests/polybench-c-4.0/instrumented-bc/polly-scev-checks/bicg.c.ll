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
define internal void @init_array(i32 %m, i32 %n, [1900 x double]* %A, double* %r, double* %p) #0 {
polly.split_new_and_old105:
  %A20 = bitcast [1900 x double]* %A to i8*
  %r21 = bitcast double* %r to i8*
  %r19 = ptrtoint double* %r to i64
  %A18 = ptrtoint [1900 x double]* %A to i64
  %0 = zext i32 %m to i64
  %1 = sext i32 %m to i64
  %2 = icmp sge i64 %1, 1
  %3 = icmp sge i64 %0, 1
  %4 = and i1 %2, %3
  br i1 %4, label %polly.then110, label %polly.merge109

.preheader.split.clone:                           ; preds = %polly.merge109
  %5 = icmp sgt i32 %n, 0
  br i1 %5, label %.lr.ph4.clone, label %.region.clone

.lr.ph4.clone:                                    ; preds = %.preheader.split.clone
  %6 = sitofp i32 %n to double
  %7 = icmp sgt i32 %m, 0
  br label %8

; <label>:8                                       ; preds = %polly.merge83, %.lr.ph4.clone
  %9 = phi i64 [ 0, %.lr.ph4.clone ], [ %indvar.next10.clone, %polly.merge83 ]
  %10 = mul i64 %9, 15200
  %i.12.clone = trunc i64 %9 to i32
  %scevgep13.clone = getelementptr double* %r, i64 %9
  %11 = srem i32 %i.12.clone, %n
  %12 = sitofp i32 %11 to double
  %13 = fdiv double %12, %6
  store double %13, double* %scevgep13.clone, align 8, !tbaa !6
  br i1 %7, label %polly.cond82, label %polly.merge83

polly.merge83:                                    ; preds = %polly.then87, %polly.loop_header89, %polly.cond82, %8
  %indvar.next10.clone = add i64 %9, 1
  %exitcond11.clone = icmp ne i64 %indvar.next10.clone, %77
  br i1 %exitcond11.clone, label %8, label %.region.clone

.region.clone:                                    ; preds = %polly.then35, %polly.loop_exit48, %polly.cond33, %polly.start, %.preheader.split.clone, %polly.merge83
  ret void

polly.start:                                      ; preds = %polly.merge109
  %14 = sext i32 %n to i64
  %15 = icmp sge i64 %14, 1
  %16 = icmp sge i64 %77, 1
  %17 = and i1 %15, %16
  br i1 %17, label %polly.then, label %.region.clone

polly.then:                                       ; preds = %polly.start
  %polly.loop_guard = icmp sle i64 0, %78
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond33

polly.cond33:                                     ; preds = %polly.then, %polly.loop_header
  br i1 %4, label %polly.then35, label %.region.clone

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_.moved.to.26 = sitofp i32 %n to double
  %p_i.12 = trunc i64 %polly.indvar to i32
  %p_scevgep13 = getelementptr double* %r, i64 %polly.indvar
  %p_ = srem i32 %p_i.12, %n
  %p_31 = sitofp i32 %p_ to double
  %p_32 = fdiv double %p_31, %p_.moved.to.26
  store double %p_32, double* %p_scevgep13
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %78, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond33

polly.then35:                                     ; preds = %polly.cond33
  br i1 %polly.loop_guard, label %polly.loop_header37, label %.region.clone

polly.loop_header37:                              ; preds = %polly.then35, %polly.loop_exit48
  %polly.indvar41 = phi i64 [ %polly.indvar_next42, %polly.loop_exit48 ], [ 0, %polly.then35 ]
  %18 = mul i64 -3, %77
  %19 = add i64 %18, %0
  %20 = add i64 %19, 5
  %21 = sub i64 %20, 32
  %22 = add i64 %21, 1
  %23 = icmp slt i64 %20, 0
  %24 = select i1 %23, i64 %22, i64 %20
  %25 = sdiv i64 %24, 32
  %26 = mul i64 -32, %25
  %27 = mul i64 -32, %77
  %28 = add i64 %26, %27
  %29 = mul i64 -32, %polly.indvar41
  %30 = mul i64 -3, %polly.indvar41
  %31 = add i64 %30, %0
  %32 = add i64 %31, 5
  %33 = sub i64 %32, 32
  %34 = add i64 %33, 1
  %35 = icmp slt i64 %32, 0
  %36 = select i1 %35, i64 %34, i64 %32
  %37 = sdiv i64 %36, 32
  %38 = mul i64 -32, %37
  %39 = add i64 %29, %38
  %40 = add i64 %39, -640
  %41 = icmp sgt i64 %28, %40
  %42 = select i1 %41, i64 %28, i64 %40
  %43 = mul i64 -20, %polly.indvar41
  %polly.loop_guard49 = icmp sle i64 %42, %43
  br i1 %polly.loop_guard49, label %polly.loop_header46, label %polly.loop_exit48

polly.loop_exit48:                                ; preds = %polly.loop_exit57, %polly.loop_header37
  %polly.indvar_next42 = add nsw i64 %polly.indvar41, 32
  %polly.adjust_ub43 = sub i64 %78, 32
  %polly.loop_cond44 = icmp sle i64 %polly.indvar41, %polly.adjust_ub43
  br i1 %polly.loop_cond44, label %polly.loop_header37, label %.region.clone

polly.loop_header46:                              ; preds = %polly.loop_header37, %polly.loop_exit57
  %polly.indvar50 = phi i64 [ %polly.indvar_next51, %polly.loop_exit57 ], [ %42, %polly.loop_header37 ]
  %44 = mul i64 -1, %polly.indvar50
  %45 = mul i64 -1, %0
  %46 = add i64 %44, %45
  %47 = add i64 %46, -30
  %48 = add i64 %47, 20
  %49 = sub i64 %48, 1
  %50 = icmp slt i64 %47, 0
  %51 = select i1 %50, i64 %47, i64 %49
  %52 = sdiv i64 %51, 20
  %53 = icmp sgt i64 %52, %polly.indvar41
  %54 = select i1 %53, i64 %52, i64 %polly.indvar41
  %55 = sub i64 %44, 20
  %56 = add i64 %55, 1
  %57 = icmp slt i64 %44, 0
  %58 = select i1 %57, i64 %56, i64 %44
  %59 = sdiv i64 %58, 20
  %60 = add i64 %polly.indvar41, 31
  %61 = icmp slt i64 %59, %60
  %62 = select i1 %61, i64 %59, i64 %60
  %63 = icmp slt i64 %62, %78
  %64 = select i1 %63, i64 %62, i64 %78
  %polly.loop_guard58 = icmp sle i64 %54, %64
  br i1 %polly.loop_guard58, label %polly.loop_header55, label %polly.loop_exit57

polly.loop_exit57:                                ; preds = %polly.loop_exit66, %polly.loop_header46
  %polly.indvar_next51 = add nsw i64 %polly.indvar50, 32
  %polly.adjust_ub52 = sub i64 %43, 32
  %polly.loop_cond53 = icmp sle i64 %polly.indvar50, %polly.adjust_ub52
  br i1 %polly.loop_cond53, label %polly.loop_header46, label %polly.loop_exit48

polly.loop_header55:                              ; preds = %polly.loop_header46, %polly.loop_exit66
  %polly.indvar59 = phi i64 [ %polly.indvar_next60, %polly.loop_exit66 ], [ %54, %polly.loop_header46 ]
  %65 = mul i64 -20, %polly.indvar59
  %66 = add i64 %65, %45
  %67 = add i64 %66, 1
  %68 = icmp sgt i64 %polly.indvar50, %67
  %69 = select i1 %68, i64 %polly.indvar50, i64 %67
  %70 = add i64 %polly.indvar50, 31
  %71 = icmp slt i64 %65, %70
  %72 = select i1 %71, i64 %65, i64 %70
  %polly.loop_guard67 = icmp sle i64 %69, %72
  br i1 %polly.loop_guard67, label %polly.loop_header64, label %polly.loop_exit66

polly.loop_exit66:                                ; preds = %polly.loop_header64, %polly.loop_header55
  %polly.indvar_next60 = add nsw i64 %polly.indvar59, 1
  %polly.adjust_ub61 = sub i64 %64, 1
  %polly.loop_cond62 = icmp sle i64 %polly.indvar59, %polly.adjust_ub61
  br i1 %polly.loop_cond62, label %polly.loop_header55, label %polly.loop_exit57

polly.loop_header64:                              ; preds = %polly.loop_header55, %polly.loop_header64
  %polly.indvar68 = phi i64 [ %polly.indvar_next69, %polly.loop_header64 ], [ %69, %polly.loop_header55 ]
  %73 = mul i64 -1, %polly.indvar68
  %74 = add i64 %65, %73
  %p_.moved.to.28 = sitofp i32 %n to double
  %p_scevgep = getelementptr [1900 x double]* %A, i64 %polly.indvar59, i64 %74
  %p_73 = mul i64 %polly.indvar59, %74
  %p_74 = add i64 %polly.indvar59, %p_73
  %p_75 = trunc i64 %p_74 to i32
  %p_76 = srem i32 %p_75, %n
  %p_77 = sitofp i32 %p_76 to double
  %p_78 = fdiv double %p_77, %p_.moved.to.28
  store double %p_78, double* %p_scevgep
  %p_indvar.next = add i64 %74, 1
  %polly.indvar_next69 = add nsw i64 %polly.indvar68, 1
  %polly.adjust_ub70 = sub i64 %72, 1
  %polly.loop_cond71 = icmp sle i64 %polly.indvar68, %polly.adjust_ub70
  br i1 %polly.loop_cond71, label %polly.loop_header64, label %polly.loop_exit66

polly.cond82:                                     ; preds = %8
  %75 = srem i64 %10, 8
  %76 = icmp eq i64 %75, 0
  %or.cond = and i1 %76, %3
  br i1 %or.cond, label %polly.then87, label %polly.merge83

polly.then87:                                     ; preds = %polly.cond82
  %polly.loop_guard92 = icmp sle i64 0, %81
  br i1 %polly.loop_guard92, label %polly.loop_header89, label %polly.merge83

polly.loop_header89:                              ; preds = %polly.then87, %polly.loop_header89
  %polly.indvar93 = phi i64 [ %polly.indvar_next94, %polly.loop_header89 ], [ 0, %polly.then87 ]
  %p_scevgep.clone = getelementptr [1900 x double]* %A, i64 %9, i64 %polly.indvar93
  %p_98 = mul i64 %9, %polly.indvar93
  %p_99 = add i64 %9, %p_98
  %p_100 = trunc i64 %p_99 to i32
  %p_101 = srem i32 %p_100, %n
  %p_102 = sitofp i32 %p_101 to double
  %p_103 = fdiv double %p_102, %6
  store double %p_103, double* %p_scevgep.clone
  %p_indvar.next.clone = add i64 %polly.indvar93, 1
  %polly.indvar_next94 = add nsw i64 %polly.indvar93, 1
  %polly.adjust_ub95 = sub i64 %81, 1
  %polly.loop_cond96 = icmp sle i64 %polly.indvar93, %polly.adjust_ub95
  br i1 %polly.loop_cond96, label %polly.loop_header89, label %polly.merge83

polly.merge109:                                   ; preds = %polly.then110, %polly.loop_header112, %polly.split_new_and_old105
  %77 = zext i32 %n to i64
  %78 = add i64 %77, -1
  %79 = mul i64 15200, %78
  %80 = add i64 %A18, %79
  %81 = add i64 %0, -1
  %82 = mul i64 8, %81
  %83 = add i64 %80, %82
  %84 = inttoptr i64 %83 to i8*
  %85 = mul i64 8, %78
  %86 = add i64 %r19, %85
  %87 = inttoptr i64 %86 to i8*
  %88 = icmp ult i8* %84, %r21
  %89 = icmp ult i8* %87, %A20
  %pair-no-alias = or i1 %88, %89
  br i1 %pair-no-alias, label %polly.start, label %.preheader.split.clone

polly.then110:                                    ; preds = %polly.split_new_and_old105
  %90 = add i64 %0, -1
  %polly.loop_guard115 = icmp sle i64 0, %90
  br i1 %polly.loop_guard115, label %polly.loop_header112, label %polly.merge109

polly.loop_header112:                             ; preds = %polly.then110, %polly.loop_header112
  %polly.indvar116 = phi i64 [ %polly.indvar_next117, %polly.loop_header112 ], [ 0, %polly.then110 ]
  %p_.moved.to. = sitofp i32 %m to double
  %p_i.06 = trunc i64 %polly.indvar116 to i32
  %p_scevgep17 = getelementptr double* %p, i64 %polly.indvar116
  %p_121 = srem i32 %p_i.06, %m
  %p_122 = sitofp i32 %p_121 to double
  %p_123 = fdiv double %p_122, %p_.moved.to.
  store double %p_123, double* %p_scevgep17
  %p_indvar.next15 = add i64 %polly.indvar116, 1
  %polly.indvar_next117 = add nsw i64 %polly.indvar116, 1
  %polly.adjust_ub118 = sub i64 %90, 1
  %polly.loop_cond119 = icmp sle i64 %polly.indvar116, %polly.adjust_ub118
  br i1 %polly.loop_cond119, label %polly.loop_header112, label %polly.merge109
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_bicg(i32 %m, i32 %n, [1900 x double]* %A, double* %s, double* %q, double* %p, double* %r) #0 {
polly.split_new_and_old93:
  %A22 = bitcast [1900 x double]* %A to i8*
  %s23 = bitcast double* %s to i8*
  %q25 = bitcast double* %q to i8*
  %p28 = bitcast double* %p to i8*
  %r31 = bitcast double* %r to i8*
  %r30 = ptrtoint double* %r to i64
  %p27 = ptrtoint double* %p to i64
  %q24 = ptrtoint double* %q to i64
  %s21 = ptrtoint double* %s to i64
  %A20 = ptrtoint [1900 x double]* %A to i64
  %0 = zext i32 %m to i64
  %1 = sext i32 %m to i64
  %2 = icmp sge i64 %1, 1
  %3 = icmp sge i64 %0, 1
  %4 = and i1 %2, %3
  br i1 %4, label %polly.then98, label %polly.merge97

.preheader.split.clone:                           ; preds = %polly.merge97
  %5 = icmp sgt i32 %n, 0
  br i1 %5, label %.lr.ph3.clone, label %.region.clone

.lr.ph3.clone:                                    ; preds = %.preheader.split.clone
  %6 = icmp sgt i32 %m, 0
  br label %7

; <label>:7                                       ; preds = %._crit_edge.clone, %.lr.ph3.clone
  %indvar8.clone = phi i64 [ 0, %.lr.ph3.clone ], [ %indvar.next9.clone, %._crit_edge.clone ]
  %scevgep14.clone = getelementptr double* %q, i64 %indvar8.clone
  %scevgep15.clone = getelementptr double* %r, i64 %indvar8.clone
  store double 0.000000e+00, double* %scevgep14.clone, align 8, !tbaa !6
  br i1 %6, label %.lr.ph.clone, label %._crit_edge.clone

.lr.ph.clone:                                     ; preds = %7, %.lr.ph.clone
  %indvar.clone = phi i64 [ %indvar.next.clone, %.lr.ph.clone ], [ 0, %7 ]
  %scevgep10.clone = getelementptr [1900 x double]* %A, i64 %indvar8.clone, i64 %indvar.clone
  %scevgep.clone = getelementptr double* %s, i64 %indvar.clone
  %scevgep11.clone = getelementptr double* %p, i64 %indvar.clone
  %8 = load double* %scevgep.clone, align 8, !tbaa !6
  %9 = load double* %scevgep15.clone, align 8, !tbaa !6
  %10 = load double* %scevgep10.clone, align 8, !tbaa !6
  %11 = fmul double %9, %10
  %12 = fadd double %8, %11
  store double %12, double* %scevgep.clone, align 8, !tbaa !6
  %13 = load double* %scevgep14.clone, align 8, !tbaa !6
  %14 = load double* %scevgep10.clone, align 8, !tbaa !6
  %15 = load double* %scevgep11.clone, align 8, !tbaa !6
  %16 = fmul double %14, %15
  %17 = fadd double %13, %16
  store double %17, double* %scevgep14.clone, align 8, !tbaa !6
  %indvar.next.clone = add i64 %indvar.clone, 1
  %exitcond.clone = icmp ne i64 %indvar.next.clone, %0
  br i1 %exitcond.clone, label %.lr.ph.clone, label %._crit_edge.clone

._crit_edge.clone:                                ; preds = %.lr.ph.clone, %7
  %indvar.next9.clone = add i64 %indvar8.clone, 1
  %exitcond12.clone = icmp ne i64 %indvar.next9.clone, %28
  br i1 %exitcond12.clone, label %7, label %.region.clone

.region.clone:                                    ; preds = %polly.then46, %polly.loop_exit59, %polly.cond44, %polly.start, %.preheader.split.clone, %._crit_edge.clone
  ret void

polly.start:                                      ; preds = %polly.merge97
  %18 = sext i32 %n to i64
  %19 = icmp sge i64 %18, 1
  %20 = icmp sge i64 %28, 1
  %21 = and i1 %19, %20
  br i1 %21, label %polly.then, label %.region.clone

polly.then:                                       ; preds = %polly.start
  %polly.loop_guard = icmp sle i64 0, %29
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond44

polly.cond44:                                     ; preds = %polly.then, %polly.loop_header
  br i1 %4, label %polly.then46, label %.region.clone

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_scevgep14 = getelementptr double* %q, i64 %polly.indvar
  store double 0.000000e+00, double* %p_scevgep14
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %29, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond44

polly.then46:                                     ; preds = %polly.cond44
  br i1 %polly.loop_guard, label %polly.loop_header48, label %.region.clone

polly.loop_header48:                              ; preds = %polly.then46, %polly.loop_exit59
  %polly.indvar52 = phi i64 [ %polly.indvar_next53, %polly.loop_exit59 ], [ 0, %polly.then46 ]
  %polly.loop_guard60 = icmp sle i64 0, %32
  br i1 %polly.loop_guard60, label %polly.loop_header57, label %polly.loop_exit59

polly.loop_exit59:                                ; preds = %polly.loop_exit68, %polly.loop_header48
  %polly.indvar_next53 = add nsw i64 %polly.indvar52, 32
  %polly.adjust_ub54 = sub i64 %29, 32
  %polly.loop_cond55 = icmp sle i64 %polly.indvar52, %polly.adjust_ub54
  br i1 %polly.loop_cond55, label %polly.loop_header48, label %.region.clone

polly.loop_header57:                              ; preds = %polly.loop_header48, %polly.loop_exit68
  %polly.indvar61 = phi i64 [ %polly.indvar_next62, %polly.loop_exit68 ], [ 0, %polly.loop_header48 ]
  %22 = add i64 %polly.indvar52, 31
  %23 = icmp slt i64 %22, %29
  %24 = select i1 %23, i64 %22, i64 %29
  %polly.loop_guard69 = icmp sle i64 %polly.indvar52, %24
  br i1 %polly.loop_guard69, label %polly.loop_header66, label %polly.loop_exit68

polly.loop_exit68:                                ; preds = %polly.loop_exit77, %polly.loop_header57
  %polly.indvar_next62 = add nsw i64 %polly.indvar61, 32
  %polly.adjust_ub63 = sub i64 %32, 32
  %polly.loop_cond64 = icmp sle i64 %polly.indvar61, %polly.adjust_ub63
  br i1 %polly.loop_cond64, label %polly.loop_header57, label %polly.loop_exit59

polly.loop_header66:                              ; preds = %polly.loop_header57, %polly.loop_exit77
  %polly.indvar70 = phi i64 [ %polly.indvar_next71, %polly.loop_exit77 ], [ %polly.indvar52, %polly.loop_header57 ]
  %25 = add i64 %polly.indvar61, 31
  %26 = icmp slt i64 %25, %32
  %27 = select i1 %26, i64 %25, i64 %32
  %polly.loop_guard78 = icmp sle i64 %polly.indvar61, %27
  br i1 %polly.loop_guard78, label %polly.loop_header75, label %polly.loop_exit77

polly.loop_exit77:                                ; preds = %polly.loop_header75, %polly.loop_header66
  %polly.indvar_next71 = add nsw i64 %polly.indvar70, 1
  %polly.adjust_ub72 = sub i64 %24, 1
  %polly.loop_cond73 = icmp sle i64 %polly.indvar70, %polly.adjust_ub72
  br i1 %polly.loop_cond73, label %polly.loop_header66, label %polly.loop_exit68

polly.loop_header75:                              ; preds = %polly.loop_header66, %polly.loop_header75
  %polly.indvar79 = phi i64 [ %polly.indvar_next80, %polly.loop_header75 ], [ %polly.indvar61, %polly.loop_header66 ]
  %p_scevgep15.moved.to. = getelementptr double* %r, i64 %polly.indvar70
  %p_scevgep14.moved.to. = getelementptr double* %q, i64 %polly.indvar70
  %p_scevgep10 = getelementptr [1900 x double]* %A, i64 %polly.indvar70, i64 %polly.indvar79
  %p_scevgep = getelementptr double* %s, i64 %polly.indvar79
  %p_scevgep11 = getelementptr double* %p, i64 %polly.indvar79
  %_p_scalar_ = load double* %p_scevgep
  %_p_scalar_84 = load double* %p_scevgep15.moved.to.
  %_p_scalar_85 = load double* %p_scevgep10
  %p_ = fmul double %_p_scalar_84, %_p_scalar_85
  %p_86 = fadd double %_p_scalar_, %p_
  store double %p_86, double* %p_scevgep
  %_p_scalar_87 = load double* %p_scevgep14.moved.to.
  %_p_scalar_88 = load double* %p_scevgep10
  %_p_scalar_89 = load double* %p_scevgep11
  %p_90 = fmul double %_p_scalar_88, %_p_scalar_89
  %p_91 = fadd double %_p_scalar_87, %p_90
  store double %p_91, double* %p_scevgep14.moved.to.
  %p_indvar.next = add i64 %polly.indvar79, 1
  %polly.indvar_next80 = add nsw i64 %polly.indvar79, 1
  %polly.adjust_ub81 = sub i64 %27, 1
  %polly.loop_cond82 = icmp sle i64 %polly.indvar79, %polly.adjust_ub81
  br i1 %polly.loop_cond82, label %polly.loop_header75, label %polly.loop_exit77

polly.merge97:                                    ; preds = %polly.then98, %polly.loop_header100, %polly.split_new_and_old93
  %28 = zext i32 %n to i64
  %29 = add i64 %28, -1
  %30 = mul i64 15200, %29
  %31 = add i64 %A20, %30
  %32 = add i64 %0, -1
  %33 = mul i64 8, %32
  %34 = add i64 %31, %33
  %35 = inttoptr i64 %34 to i8*
  %36 = add i64 %s21, %33
  %37 = inttoptr i64 %36 to i8*
  %38 = icmp ult i8* %35, %s23
  %39 = icmp ult i8* %37, %A22
  %pair-no-alias = or i1 %38, %39
  %40 = mul i64 8, %29
  %41 = add i64 %q24, %40
  %42 = inttoptr i64 %41 to i8*
  %43 = icmp ult i8* %35, %q25
  %44 = icmp ult i8* %42, %A22
  %pair-no-alias26 = or i1 %43, %44
  %45 = and i1 %pair-no-alias, %pair-no-alias26
  %46 = add i64 %p27, %33
  %47 = inttoptr i64 %46 to i8*
  %48 = icmp ult i8* %35, %p28
  %49 = icmp ult i8* %47, %A22
  %pair-no-alias29 = or i1 %48, %49
  %50 = and i1 %45, %pair-no-alias29
  %51 = add i64 %r30, %40
  %52 = inttoptr i64 %51 to i8*
  %53 = icmp ult i8* %35, %r31
  %54 = icmp ult i8* %52, %A22
  %pair-no-alias32 = or i1 %53, %54
  %55 = and i1 %50, %pair-no-alias32
  %56 = icmp ult i8* %37, %q25
  %57 = icmp ult i8* %42, %s23
  %pair-no-alias33 = or i1 %56, %57
  %58 = and i1 %55, %pair-no-alias33
  %59 = icmp ult i8* %37, %p28
  %60 = icmp ult i8* %47, %s23
  %pair-no-alias34 = or i1 %59, %60
  %61 = and i1 %58, %pair-no-alias34
  %62 = icmp ult i8* %37, %r31
  %63 = icmp ult i8* %52, %s23
  %pair-no-alias35 = or i1 %62, %63
  %64 = and i1 %61, %pair-no-alias35
  %65 = icmp ult i8* %42, %p28
  %66 = icmp ult i8* %47, %q25
  %pair-no-alias36 = or i1 %65, %66
  %67 = and i1 %64, %pair-no-alias36
  %68 = icmp ult i8* %42, %r31
  %69 = icmp ult i8* %52, %q25
  %pair-no-alias37 = or i1 %68, %69
  %70 = and i1 %67, %pair-no-alias37
  %71 = icmp ult i8* %47, %r31
  %72 = icmp ult i8* %52, %p28
  %pair-no-alias38 = or i1 %71, %72
  %73 = and i1 %70, %pair-no-alias38
  br i1 %73, label %polly.start, label %.preheader.split.clone

polly.then98:                                     ; preds = %polly.split_new_and_old93
  %74 = add i64 %0, -1
  %polly.loop_guard103 = icmp sle i64 0, %74
  br i1 %polly.loop_guard103, label %polly.loop_header100, label %polly.merge97

polly.loop_header100:                             ; preds = %polly.then98, %polly.loop_header100
  %polly.indvar104 = phi i64 [ %polly.indvar_next105, %polly.loop_header100 ], [ 0, %polly.then98 ]
  %p_scevgep19 = getelementptr double* %s, i64 %polly.indvar104
  store double 0.000000e+00, double* %p_scevgep19
  %p_indvar.next17 = add i64 %polly.indvar104, 1
  %polly.indvar_next105 = add nsw i64 %polly.indvar104, 1
  %polly.adjust_ub106 = sub i64 %74, 1
  %polly.loop_cond107 = icmp sle i64 %polly.indvar104, %polly.adjust_ub106
  br i1 %polly.loop_cond107, label %polly.loop_header100, label %polly.merge97
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %m, i32 %n, double* %s, double* %q) #0 {
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
