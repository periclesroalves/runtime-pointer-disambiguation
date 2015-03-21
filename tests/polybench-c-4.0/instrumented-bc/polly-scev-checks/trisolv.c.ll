; ModuleID = './linear-algebra/solvers/trisolv/trisolv.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str4 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str5 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %0 = tail call i8* @polybench_alloc_data(i64 4000000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %3 = bitcast i8* %0 to [2000 x double]*
  %4 = bitcast i8* %1 to double*
  %5 = bitcast i8* %2 to double*
  tail call void @init_array(i32 2000, [2000 x double]* %3, double* %4, double* %5)
  tail call void (...)* @polybench_timer_start() #3
  tail call void @kernel_trisolv(i32 2000, [2000 x double]* %3, double* %4, double* %5)
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
  tail call void @print_array(i32 2000, double* %4)
  br label %11

; <label>:11                                      ; preds = %7, %10, %.split
  tail call void @free(i8* %0) #3
  tail call void @free(i8* %1) #3
  tail call void @free(i8* %2) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %n, [2000 x double]* %L, double* %x, double* %b) #0 {
.split:
  %L15 = bitcast [2000 x double]* %L to i8*
  %x16 = bitcast double* %x to i8*
  %b18 = bitcast double* %b to i8*
  %b17 = ptrtoint double* %b to i64
  %x14 = ptrtoint double* %x to i64
  %L13 = ptrtoint [2000 x double]* %L to i64
  %0 = zext i32 %n to i64
  %1 = add i64 %0, -1
  %2 = mul i64 16000, %1
  %3 = add i64 %L13, %2
  %4 = mul i64 8, %1
  %5 = add i64 %3, %4
  %6 = inttoptr i64 %5 to i8*
  %7 = add i64 %x14, %4
  %8 = inttoptr i64 %7 to i8*
  %9 = icmp ult i8* %6, %x16
  %10 = icmp ult i8* %8, %L15
  %pair-no-alias = or i1 %9, %10
  %11 = add i64 %b17, %4
  %12 = inttoptr i64 %11 to i8*
  %13 = icmp ult i8* %6, %b18
  %14 = icmp ult i8* %12, %L15
  %pair-no-alias19 = or i1 %13, %14
  %15 = and i1 %pair-no-alias, %pair-no-alias19
  %16 = icmp ult i8* %8, %b18
  %17 = icmp ult i8* %12, %x16
  %pair-no-alias20 = or i1 %16, %17
  %18 = and i1 %15, %pair-no-alias20
  br i1 %18, label %polly.start, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  %19 = icmp sgt i32 %n, 0
  br i1 %19, label %.lr.ph5.clone, label %.region.clone

.lr.ph5.clone:                                    ; preds = %.split.split.clone
  %20 = add i32 %n, 1
  %21 = zext i32 %20 to i64
  %22 = sitofp i32 %n to double
  br label %23

; <label>:23                                      ; preds = %polly.merge74, %.lr.ph5.clone
  %indvar7.clone = phi i64 [ 0, %.lr.ph5.clone ], [ %26, %polly.merge74 ]
  %24 = mul i64 %indvar7.clone, 16000
  %i.02.clone = trunc i64 %indvar7.clone to i32
  %25 = add i64 %21, %indvar7.clone
  %26 = add i64 %indvar7.clone, 1
  %scevgep11.clone = getelementptr double* %x, i64 %indvar7.clone
  %scevgep12.clone = getelementptr double* %b, i64 %indvar7.clone
  store double -9.990000e+02, double* %scevgep11.clone, align 8, !tbaa !6
  %27 = sitofp i32 %i.02.clone to double
  store double %27, double* %scevgep12.clone, align 8, !tbaa !6
  %28 = icmp slt i32 %i.02.clone, 0
  br i1 %28, label %polly.merge74, label %polly.cond73

polly.merge74:                                    ; preds = %polly.then78, %polly.loop_header80, %polly.cond73, %23
  %exitcond9.clone = icmp ne i64 %26, %0
  br i1 %exitcond9.clone, label %23, label %.region.clone

.region.clone:                                    ; preds = %polly.loop_exit, %polly.loop_exit39, %polly.start, %.split.split.clone, %polly.merge74
  ret void

polly.start:                                      ; preds = %.split
  %29 = sext i32 %n to i64
  %30 = icmp sge i64 %29, 1
  %31 = icmp sge i64 %0, 1
  %32 = and i1 %30, %31
  br i1 %32, label %polly.then, label %.region.clone

polly.then:                                       ; preds = %polly.start
  %polly.loop_guard = icmp sle i64 0, %1
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.loop_exit

polly.loop_exit:                                  ; preds = %polly.loop_header, %polly.then
  br i1 %polly.loop_guard, label %polly.loop_header28, label %.region.clone

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_i.02 = trunc i64 %polly.indvar to i32
  %p_scevgep11 = getelementptr double* %x, i64 %polly.indvar
  %p_scevgep12 = getelementptr double* %b, i64 %polly.indvar
  store double -9.990000e+02, double* %p_scevgep11
  %p_ = sitofp i32 %p_i.02 to double
  store double %p_, double* %p_scevgep12
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %1, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.loop_exit

polly.loop_header28:                              ; preds = %polly.loop_exit, %polly.loop_exit39
  %polly.indvar32 = phi i64 [ %polly.indvar_next33, %polly.loop_exit39 ], [ 0, %polly.loop_exit ]
  %33 = mul i64 -11, %0
  %34 = add i64 %33, 5
  %35 = sub i64 %34, 32
  %36 = add i64 %35, 1
  %37 = icmp slt i64 %34, 0
  %38 = select i1 %37, i64 %36, i64 %34
  %39 = sdiv i64 %38, 32
  %40 = mul i64 -32, %39
  %41 = mul i64 -32, %0
  %42 = add i64 %40, %41
  %43 = mul i64 -32, %polly.indvar32
  %44 = mul i64 11, %polly.indvar32
  %45 = add i64 %44, -1
  %46 = sub i64 %45, 32
  %47 = add i64 %46, 1
  %48 = icmp slt i64 %45, 0
  %49 = select i1 %48, i64 %47, i64 %45
  %50 = sdiv i64 %49, 32
  %51 = mul i64 32, %50
  %52 = add i64 %43, %51
  %53 = add i64 %52, -640
  %54 = icmp sgt i64 %42, %53
  %55 = select i1 %54, i64 %42, i64 %53
  %56 = mul i64 -20, %polly.indvar32
  %polly.loop_guard40 = icmp sle i64 %55, %56
  br i1 %polly.loop_guard40, label %polly.loop_header37, label %polly.loop_exit39

polly.loop_exit39:                                ; preds = %polly.loop_exit48, %polly.loop_header28
  %polly.indvar_next33 = add nsw i64 %polly.indvar32, 32
  %polly.adjust_ub34 = sub i64 %1, 32
  %polly.loop_cond35 = icmp sle i64 %polly.indvar32, %polly.adjust_ub34
  br i1 %polly.loop_cond35, label %polly.loop_header28, label %.region.clone

polly.loop_header37:                              ; preds = %polly.loop_header28, %polly.loop_exit48
  %polly.indvar41 = phi i64 [ %polly.indvar_next42, %polly.loop_exit48 ], [ %55, %polly.loop_header28 ]
  %57 = mul i64 -1, %polly.indvar41
  %58 = add i64 %57, -31
  %59 = add i64 %58, 21
  %60 = sub i64 %59, 1
  %61 = icmp slt i64 %58, 0
  %62 = select i1 %61, i64 %58, i64 %60
  %63 = sdiv i64 %62, 21
  %64 = icmp sgt i64 %63, %polly.indvar32
  %65 = select i1 %64, i64 %63, i64 %polly.indvar32
  %66 = sub i64 %57, 20
  %67 = add i64 %66, 1
  %68 = icmp slt i64 %57, 0
  %69 = select i1 %68, i64 %67, i64 %57
  %70 = sdiv i64 %69, 20
  %71 = add i64 %polly.indvar32, 31
  %72 = icmp slt i64 %70, %71
  %73 = select i1 %72, i64 %70, i64 %71
  %74 = icmp slt i64 %73, %1
  %75 = select i1 %74, i64 %73, i64 %1
  %polly.loop_guard49 = icmp sle i64 %65, %75
  br i1 %polly.loop_guard49, label %polly.loop_header46, label %polly.loop_exit48

polly.loop_exit48:                                ; preds = %polly.loop_exit57, %polly.loop_header37
  %polly.indvar_next42 = add nsw i64 %polly.indvar41, 32
  %polly.adjust_ub43 = sub i64 %56, 32
  %polly.loop_cond44 = icmp sle i64 %polly.indvar41, %polly.adjust_ub43
  br i1 %polly.loop_cond44, label %polly.loop_header37, label %polly.loop_exit39

polly.loop_header46:                              ; preds = %polly.loop_header37, %polly.loop_exit57
  %polly.indvar50 = phi i64 [ %polly.indvar_next51, %polly.loop_exit57 ], [ %65, %polly.loop_header37 ]
  %76 = mul i64 -21, %polly.indvar50
  %77 = icmp sgt i64 %polly.indvar41, %76
  %78 = select i1 %77, i64 %polly.indvar41, i64 %76
  %79 = mul i64 -20, %polly.indvar50
  %80 = add i64 %polly.indvar41, 31
  %81 = icmp slt i64 %79, %80
  %82 = select i1 %81, i64 %79, i64 %80
  %polly.loop_guard58 = icmp sle i64 %78, %82
  br i1 %polly.loop_guard58, label %polly.loop_header55, label %polly.loop_exit57

polly.loop_exit57:                                ; preds = %polly.loop_header55, %polly.loop_header46
  %polly.indvar_next51 = add nsw i64 %polly.indvar50, 1
  %polly.adjust_ub52 = sub i64 %75, 1
  %polly.loop_cond53 = icmp sle i64 %polly.indvar50, %polly.adjust_ub52
  br i1 %polly.loop_cond53, label %polly.loop_header46, label %polly.loop_exit48

polly.loop_header55:                              ; preds = %polly.loop_header46, %polly.loop_header55
  %polly.indvar59 = phi i64 [ %polly.indvar_next60, %polly.loop_header55 ], [ %78, %polly.loop_header46 ]
  %83 = mul i64 -1, %polly.indvar59
  %84 = add i64 %79, %83
  %p_.moved.to.21 = add i32 %n, 1
  %p_.moved.to.22 = zext i32 %p_.moved.to.21 to i64
  %p_.moved.to.23 = add i64 %p_.moved.to.22, %polly.indvar50
  %p_.moved.to.24 = sitofp i32 %n to double
  %p_.moved.to.25 = add i64 %polly.indvar50, 1
  %p_scevgep = getelementptr [2000 x double]* %L, i64 %polly.indvar50, i64 %84
  %p_64 = mul i64 %84, -1
  %p_65 = add i64 %p_.moved.to.23, %p_64
  %p_66 = trunc i64 %p_65 to i32
  %p_67 = sitofp i32 %p_66 to double
  %p_68 = fmul double %p_67, 2.000000e+00
  %p_69 = fdiv double %p_68, %p_.moved.to.24
  store double %p_69, double* %p_scevgep
  %p_indvar.next = add i64 %84, 1
  %polly.indvar_next60 = add nsw i64 %polly.indvar59, 1
  %polly.adjust_ub61 = sub i64 %82, 1
  %polly.loop_cond62 = icmp sle i64 %polly.indvar59, %polly.adjust_ub61
  br i1 %polly.loop_cond62, label %polly.loop_header55, label %polly.loop_exit57

polly.cond73:                                     ; preds = %23
  %85 = srem i64 %24, 8
  %86 = icmp eq i64 %85, 0
  %87 = icmp sge i64 %indvar7.clone, 0
  %or.cond = and i1 %86, %87
  br i1 %or.cond, label %polly.then78, label %polly.merge74

polly.then78:                                     ; preds = %polly.cond73
  br i1 %87, label %polly.loop_header80, label %polly.merge74

polly.loop_header80:                              ; preds = %polly.then78, %polly.loop_header80
  %polly.indvar84 = phi i64 [ %polly.indvar_next85, %polly.loop_header80 ], [ 0, %polly.then78 ]
  %p_scevgep.clone = getelementptr [2000 x double]* %L, i64 %indvar7.clone, i64 %polly.indvar84
  %p_89 = mul i64 %polly.indvar84, -1
  %p_90 = add i64 %25, %p_89
  %p_91 = trunc i64 %p_90 to i32
  %p_92 = sitofp i32 %p_91 to double
  %p_93 = fmul double %p_92, 2.000000e+00
  %p_94 = fdiv double %p_93, %22
  store double %p_94, double* %p_scevgep.clone
  %p_indvar.next.clone = add i64 %polly.indvar84, 1
  %polly.indvar_next85 = add nsw i64 %polly.indvar84, 1
  %polly.adjust_ub86 = sub i64 %indvar7.clone, 1
  %polly.loop_cond87 = icmp sle i64 %polly.indvar84, %polly.adjust_ub86
  br i1 %polly.loop_cond87, label %polly.loop_header80, label %polly.merge74
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_trisolv(i32 %n, [2000 x double]* %L, double* %x, double* %b) #0 {
.split:
  %b23 = bitcast double* %b to i8*
  %b22 = ptrtoint double* %b to i64
  %x16 = ptrtoint double* %x to i64
  %L14 = ptrtoint [2000 x double]* %L to i64
  %umin18 = bitcast [2000 x double]* %L to i8*
  %0 = zext i32 %n to i64
  %1 = add i64 %0, -1
  %2 = mul i64 16000, %1
  %3 = add i64 %L14, %2
  %4 = add i64 -1, %1
  %5 = mul i64 8, %4
  %6 = add i64 %3, %5
  %7 = mul i64 16008, %1
  %8 = add i64 %L14, %7
  %9 = icmp ugt i64 %8, %6
  %umax = select i1 %9, i64 %8, i64 %6
  %umax19 = inttoptr i64 %umax to i8*
  %umin1520 = bitcast double* %x to i8*
  %10 = mul i64 8, %1
  %11 = add i64 %x16, %10
  %12 = add i64 %x16, %5
  %13 = icmp ugt i64 %12, %11
  %umax17 = select i1 %13, i64 %12, i64 %11
  %umax1721 = inttoptr i64 %umax17 to i8*
  %14 = icmp ult i8* %umax19, %umin1520
  %15 = icmp ult i8* %umax1721, %umin18
  %pair-no-alias = or i1 %14, %15
  %16 = add i64 %b22, %10
  %17 = inttoptr i64 %16 to i8*
  %18 = icmp ult i8* %umax19, %b23
  %19 = icmp ult i8* %17, %umin18
  %pair-no-alias24 = or i1 %18, %19
  %20 = and i1 %pair-no-alias, %pair-no-alias24
  %21 = icmp ult i8* %umax1721, %b23
  %22 = icmp ult i8* %17, %umin1520
  %pair-no-alias25 = or i1 %21, %22
  %23 = and i1 %20, %pair-no-alias25
  br i1 %23, label %polly.start, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  %24 = icmp sgt i32 %n, 0
  br i1 %24, label %.lr.ph4.clone, label %.region.clone

.lr.ph4.clone:                                    ; preds = %.split.split.clone
  br label %25

; <label>:25                                      ; preds = %._crit_edge.clone, %.lr.ph4.clone
  %26 = phi i64 [ 0, %.lr.ph4.clone ], [ %indvar.next7.clone, %._crit_edge.clone ]
  %i.02.clone = trunc i64 %26 to i32
  %scevgep11.clone = getelementptr double* %b, i64 %26
  %scevgep12.clone = getelementptr double* %x, i64 %26
  %27 = mul i64 %26, 2001
  %scevgep13.clone = getelementptr [2000 x double]* %L, i64 0, i64 %27
  %28 = load double* %scevgep11.clone, align 8, !tbaa !6
  store double %28, double* %scevgep12.clone, align 8, !tbaa !6
  %29 = icmp sgt i32 %i.02.clone, 0
  br i1 %29, label %.lr.ph.clone, label %._crit_edge.clone

.lr.ph.clone:                                     ; preds = %25, %.lr.ph.clone
  %indvar.clone = phi i64 [ %indvar.next.clone, %.lr.ph.clone ], [ 0, %25 ]
  %scevgep.clone = getelementptr [2000 x double]* %L, i64 %26, i64 %indvar.clone
  %scevgep8.clone = getelementptr double* %x, i64 %indvar.clone
  %30 = load double* %scevgep.clone, align 8, !tbaa !6
  %31 = load double* %scevgep8.clone, align 8, !tbaa !6
  %32 = fmul double %30, %31
  %33 = load double* %scevgep12.clone, align 8, !tbaa !6
  %34 = fsub double %33, %32
  store double %34, double* %scevgep12.clone, align 8, !tbaa !6
  %indvar.next.clone = add i64 %indvar.clone, 1
  %exitcond.clone = icmp ne i64 %indvar.next.clone, %26
  br i1 %exitcond.clone, label %.lr.ph.clone, label %._crit_edge.clone

._crit_edge.clone:                                ; preds = %.lr.ph.clone, %25
  %35 = load double* %scevgep12.clone, align 8, !tbaa !6
  %36 = load double* %scevgep13.clone, align 8, !tbaa !6
  %37 = fdiv double %35, %36
  store double %37, double* %scevgep12.clone, align 8, !tbaa !6
  %indvar.next7.clone = add i64 %26, 1
  %exitcond9.clone = icmp ne i64 %indvar.next7.clone, %0
  br i1 %exitcond9.clone, label %25, label %.region.clone

.region.clone:                                    ; preds = %polly.start, %polly.loop_exit31, %.split.split.clone, %._crit_edge.clone
  ret void

polly.start:                                      ; preds = %.split
  %38 = sext i32 %n to i64
  %39 = icmp sge i64 %38, 1
  %40 = icmp sge i64 %0, 1
  %41 = and i1 %39, %40
  br i1 %41, label %polly.then, label %.region.clone

polly.then:                                       ; preds = %polly.start
  %polly.loop_guard = icmp sle i64 0, %1
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.loop_exit

polly.loop_exit:                                  ; preds = %polly.loop_header, %polly.then
  %42 = add i64 %0, -2
  %polly.loop_guard32 = icmp sle i64 0, %42
  br i1 %polly.loop_guard32, label %polly.loop_header29, label %polly.loop_exit31

polly.loop_exit31:                                ; preds = %polly.loop_exit44, %polly.loop_exit
  %p_scevgep12.moved.to.2657 = getelementptr double* %x, i64 %1
  %p_.moved.to.58 = mul i64 %1, 2001
  %p_scevgep13.moved.to.59 = getelementptr [2000 x double]* %L, i64 0, i64 %p_.moved.to.58
  %_p_scalar_61 = load double* %p_scevgep12.moved.to.2657
  %_p_scalar_62 = load double* %p_scevgep13.moved.to.59
  %p_63 = fdiv double %_p_scalar_61, %_p_scalar_62
  store double %p_63, double* %p_scevgep12.moved.to.2657
  br label %.region.clone

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_i.02 = trunc i64 %polly.indvar to i32
  %p_scevgep11 = getelementptr double* %b, i64 %polly.indvar
  %p_scevgep12 = getelementptr double* %x, i64 %polly.indvar
  %_p_scalar_ = load double* %p_scevgep11
  store double %_p_scalar_, double* %p_scevgep12
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %1, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.loop_exit

polly.loop_header29:                              ; preds = %polly.loop_exit, %polly.loop_exit44
  %polly.indvar33 = phi i64 [ %polly.indvar_next34, %polly.loop_exit44 ], [ 0, %polly.loop_exit ]
  %p_scevgep12.moved.to.26 = getelementptr double* %x, i64 %polly.indvar33
  %p_.moved.to. = mul i64 %polly.indvar33, 2001
  %p_scevgep13.moved.to. = getelementptr [2000 x double]* %L, i64 0, i64 %p_.moved.to.
  %_p_scalar_38 = load double* %p_scevgep12.moved.to.26
  %_p_scalar_39 = load double* %p_scevgep13.moved.to.
  %p_40 = fdiv double %_p_scalar_38, %_p_scalar_39
  store double %p_40, double* %p_scevgep12.moved.to.26
  %p_indvar.next7 = add i64 %polly.indvar33, 1
  %polly.loop_guard45 = icmp sle i64 %p_indvar.next7, %1
  br i1 %polly.loop_guard45, label %polly.loop_header42, label %polly.loop_exit44

polly.loop_exit44:                                ; preds = %polly.loop_header42, %polly.loop_header29
  %polly.indvar_next34 = add nsw i64 %polly.indvar33, 1
  %polly.adjust_ub35 = sub i64 %42, 1
  %polly.loop_cond36 = icmp sle i64 %polly.indvar33, %polly.adjust_ub35
  br i1 %polly.loop_cond36, label %polly.loop_header29, label %polly.loop_exit31

polly.loop_header42:                              ; preds = %polly.loop_header29, %polly.loop_header42
  %polly.indvar46 = phi i64 [ %polly.indvar_next47, %polly.loop_header42 ], [ %p_indvar.next7, %polly.loop_header29 ]
  %p_scevgep12.moved.to. = getelementptr double* %x, i64 %polly.indvar46
  %p_scevgep = getelementptr [2000 x double]* %L, i64 %polly.indvar46, i64 %polly.indvar33
  %_p_scalar_51 = load double* %p_scevgep
  %_p_scalar_52 = load double* %p_scevgep12.moved.to.26
  %p_53 = fmul double %_p_scalar_51, %_p_scalar_52
  %_p_scalar_54 = load double* %p_scevgep12.moved.to.
  %p_55 = fsub double %_p_scalar_54, %p_53
  store double %p_55, double* %p_scevgep12.moved.to.
  %polly.indvar_next47 = add nsw i64 %polly.indvar46, 1
  %polly.adjust_ub48 = sub i64 %1, 1
  %polly.loop_cond49 = icmp sle i64 %polly.indvar46, %polly.adjust_ub48
  br i1 %polly.loop_cond49, label %polly.loop_header42, label %polly.loop_exit44
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, double* %x) #0 {
  %.reg2mem = alloca %struct._IO_FILE*
  %.lcssa.reg2mem = alloca %struct._IO_FILE*
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %n, 0
  %6 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  store %struct._IO_FILE* %6, %struct._IO_FILE** %.lcssa.reg2mem
  br i1 %5, label %.lr.ph, label %18

.lr.ph:                                           ; preds = %.split
  %7 = zext i32 %n to i64
  store %struct._IO_FILE* %6, %struct._IO_FILE** %.reg2mem
  br label %8

; <label>:8                                       ; preds = %.lr.ph, %15
  %indvar = phi i64 [ 0, %.lr.ph ], [ %indvar.next, %15 ]
  %.reload = load %struct._IO_FILE** %.reg2mem
  %i.01 = trunc i64 %indvar to i32
  %scevgep = getelementptr double* %x, i64 %indvar
  %9 = load double* %scevgep, align 8, !tbaa !6
  %10 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %.reload, i8* getelementptr inbounds ([8 x i8]* @.str4, i64 0, i64 0), double %9) #5
  %11 = srem i32 %i.01, 20
  %12 = icmp eq i32 %11, 0
  br i1 %12, label %13, label %15

; <label>:13                                      ; preds = %8
  %14 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %14) #4
  br label %15

; <label>:15                                      ; preds = %8, %13
  %16 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %7
  store %struct._IO_FILE* %16, %struct._IO_FILE** %.reg2mem
  br i1 %exitcond, label %8, label %._crit_edge

._crit_edge:                                      ; preds = %15
  %17 = load %struct._IO_FILE** %.reg2mem
  store %struct._IO_FILE* %17, %struct._IO_FILE** %.lcssa.reg2mem
  br label %18

; <label>:18                                      ; preds = %._crit_edge, %.split
  %.lcssa.reload = load %struct._IO_FILE** %.lcssa.reg2mem
  %19 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %.lcssa.reload, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %20 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %21 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str7, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %20) #4
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
