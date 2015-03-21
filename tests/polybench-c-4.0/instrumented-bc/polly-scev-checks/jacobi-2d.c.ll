; ModuleID = './stencils/jacobi-2d/jacobi-2d.c'
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
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %0 = tail call i8* @polybench_alloc_data(i64 1690000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 1690000, i32 8) #3
  %2 = bitcast i8* %0 to [1300 x double]*
  %3 = bitcast i8* %1 to [1300 x double]*
  tail call void @init_array(i32 1300, [1300 x double]* %2, [1300 x double]* %3)
  tail call void (...)* @polybench_timer_start() #3
  tail call void @kernel_jacobi_2d(i32 500, i32 1300, [1300 x double]* %2, [1300 x double]* %3)
  tail call void (...)* @polybench_timer_stop() #3
  tail call void (...)* @polybench_timer_print() #3
  %4 = icmp sgt i32 %argc, 42
  br i1 %4, label %5, label %9

; <label>:5                                       ; preds = %.split
  %6 = load i8** %argv, align 8, !tbaa !1
  %7 = load i8* %6, align 1, !tbaa !5
  %phitmp = icmp eq i8 %7, 0
  br i1 %phitmp, label %8, label %9

; <label>:8                                       ; preds = %5
  tail call void @print_array(i32 1300, [1300 x double]* %2)
  br label %9

; <label>:9                                       ; preds = %5, %8, %.split
  tail call void @free(i8* %0) #3
  tail call void @free(i8* %1) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %n, [1300 x double]* %A, [1300 x double]* %B) #0 {
.split:
  %A12 = bitcast [1300 x double]* %A to i8*
  %B13 = bitcast [1300 x double]* %B to i8*
  %B11 = ptrtoint [1300 x double]* %B to i64
  %A10 = ptrtoint [1300 x double]* %A to i64
  %0 = zext i32 %n to i64
  %1 = add i64 %0, -1
  %2 = mul i64 10400, %1
  %3 = add i64 %A10, %2
  %4 = mul i64 8, %1
  %5 = add i64 %3, %4
  %6 = inttoptr i64 %5 to i8*
  %7 = add i64 %B11, %2
  %8 = add i64 %7, %4
  %9 = inttoptr i64 %8 to i8*
  %10 = icmp ult i8* %6, %B13
  %11 = icmp ult i8* %9, %A12
  %pair-no-alias = or i1 %10, %11
  br i1 %pair-no-alias, label %polly.start, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  %12 = icmp sgt i32 %n, 0
  br i1 %12, label %.preheader.lr.ph.clone, label %.region.clone

.preheader.lr.ph.clone:                           ; preds = %.split.split.clone
  %13 = sitofp i32 %n to double
  br label %.preheader.clone

.preheader.clone:                                 ; preds = %._crit_edge.clone, %.preheader.lr.ph.clone
  %indvar4.clone = phi i64 [ 0, %.preheader.lr.ph.clone ], [ %indvar.next5.clone, %._crit_edge.clone ]
  %i.02.clone = trunc i64 %indvar4.clone to i32
  br i1 %12, label %.lr.ph.clone, label %._crit_edge.clone

.lr.ph.clone:                                     ; preds = %.preheader.clone
  %14 = sitofp i32 %i.02.clone to double
  br label %15

; <label>:15                                      ; preds = %15, %.lr.ph.clone
  %indvar.clone = phi i64 [ 0, %.lr.ph.clone ], [ %indvar.next.clone, %15 ]
  %scevgep6.clone = getelementptr [1300 x double]* %B, i64 %indvar4.clone, i64 %indvar.clone
  %scevgep.clone = getelementptr [1300 x double]* %A, i64 %indvar4.clone, i64 %indvar.clone
  %16 = add i64 %indvar.clone, 2
  %17 = trunc i64 %16 to i32
  %18 = add i64 %indvar.clone, 3
  %19 = trunc i64 %18 to i32
  %20 = sitofp i32 %17 to double
  %21 = fmul double %14, %20
  %22 = fadd double %21, 2.000000e+00
  %23 = fdiv double %22, %13
  store double %23, double* %scevgep.clone, align 8, !tbaa !6
  %24 = sitofp i32 %19 to double
  %25 = fmul double %14, %24
  %26 = fadd double %25, 3.000000e+00
  %27 = fdiv double %26, %13
  store double %27, double* %scevgep6.clone, align 8, !tbaa !6
  %indvar.next.clone = add i64 %indvar.clone, 1
  %exitcond.clone = icmp ne i64 %indvar.next.clone, %0
  br i1 %exitcond.clone, label %15, label %._crit_edge.clone

._crit_edge.clone:                                ; preds = %15, %.preheader.clone
  %indvar.next5.clone = add i64 %indvar4.clone, 1
  %exitcond7.clone = icmp ne i64 %indvar.next5.clone, %0
  br i1 %exitcond7.clone, label %.preheader.clone, label %.region.clone

.region.clone:                                    ; preds = %polly.then, %polly.loop_exit22, %polly.start, %.split.split.clone, %._crit_edge.clone
  ret void

polly.start:                                      ; preds = %.split
  %28 = sext i32 %n to i64
  %29 = icmp sge i64 %28, 1
  %30 = icmp sge i64 %0, 1
  %31 = and i1 %29, %30
  br i1 %31, label %polly.then, label %.region.clone

polly.then:                                       ; preds = %polly.start
  %polly.loop_guard = icmp sle i64 0, %1
  br i1 %polly.loop_guard, label %polly.loop_header, label %.region.clone

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit22
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit22 ], [ 0, %polly.then ]
  %32 = mul i64 -11, %0
  %33 = add i64 %32, 5
  %34 = sub i64 %33, 32
  %35 = add i64 %34, 1
  %36 = icmp slt i64 %33, 0
  %37 = select i1 %36, i64 %35, i64 %33
  %38 = sdiv i64 %37, 32
  %39 = mul i64 -32, %38
  %40 = mul i64 -32, %0
  %41 = add i64 %39, %40
  %42 = mul i64 -32, %polly.indvar
  %43 = mul i64 -3, %polly.indvar
  %44 = add i64 %43, %0
  %45 = add i64 %44, 5
  %46 = sub i64 %45, 32
  %47 = add i64 %46, 1
  %48 = icmp slt i64 %45, 0
  %49 = select i1 %48, i64 %47, i64 %45
  %50 = sdiv i64 %49, 32
  %51 = mul i64 -32, %50
  %52 = add i64 %42, %51
  %53 = add i64 %52, -640
  %54 = icmp sgt i64 %41, %53
  %55 = select i1 %54, i64 %41, i64 %53
  %56 = mul i64 -20, %polly.indvar
  %polly.loop_guard23 = icmp sle i64 %55, %56
  br i1 %polly.loop_guard23, label %polly.loop_header20, label %polly.loop_exit22

polly.loop_exit22:                                ; preds = %polly.loop_exit31, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %1, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %.region.clone

polly.loop_header20:                              ; preds = %polly.loop_header, %polly.loop_exit31
  %polly.indvar24 = phi i64 [ %polly.indvar_next25, %polly.loop_exit31 ], [ %55, %polly.loop_header ]
  %57 = mul i64 -1, %polly.indvar24
  %58 = mul i64 -1, %0
  %59 = add i64 %57, %58
  %60 = add i64 %59, -30
  %61 = add i64 %60, 20
  %62 = sub i64 %61, 1
  %63 = icmp slt i64 %60, 0
  %64 = select i1 %63, i64 %60, i64 %62
  %65 = sdiv i64 %64, 20
  %66 = icmp sgt i64 %65, %polly.indvar
  %67 = select i1 %66, i64 %65, i64 %polly.indvar
  %68 = sub i64 %57, 20
  %69 = add i64 %68, 1
  %70 = icmp slt i64 %57, 0
  %71 = select i1 %70, i64 %69, i64 %57
  %72 = sdiv i64 %71, 20
  %73 = add i64 %polly.indvar, 31
  %74 = icmp slt i64 %72, %73
  %75 = select i1 %74, i64 %72, i64 %73
  %76 = icmp slt i64 %75, %1
  %77 = select i1 %76, i64 %75, i64 %1
  %polly.loop_guard32 = icmp sle i64 %67, %77
  br i1 %polly.loop_guard32, label %polly.loop_header29, label %polly.loop_exit31

polly.loop_exit31:                                ; preds = %polly.loop_exit40, %polly.loop_header20
  %polly.indvar_next25 = add nsw i64 %polly.indvar24, 32
  %polly.adjust_ub26 = sub i64 %56, 32
  %polly.loop_cond27 = icmp sle i64 %polly.indvar24, %polly.adjust_ub26
  br i1 %polly.loop_cond27, label %polly.loop_header20, label %polly.loop_exit22

polly.loop_header29:                              ; preds = %polly.loop_header20, %polly.loop_exit40
  %polly.indvar33 = phi i64 [ %polly.indvar_next34, %polly.loop_exit40 ], [ %67, %polly.loop_header20 ]
  %78 = mul i64 -20, %polly.indvar33
  %79 = add i64 %78, %58
  %80 = add i64 %79, 1
  %81 = icmp sgt i64 %polly.indvar24, %80
  %82 = select i1 %81, i64 %polly.indvar24, i64 %80
  %83 = add i64 %polly.indvar24, 31
  %84 = icmp slt i64 %78, %83
  %85 = select i1 %84, i64 %78, i64 %83
  %polly.loop_guard41 = icmp sle i64 %82, %85
  br i1 %polly.loop_guard41, label %polly.loop_header38, label %polly.loop_exit40

polly.loop_exit40:                                ; preds = %polly.loop_header38, %polly.loop_header29
  %polly.indvar_next34 = add nsw i64 %polly.indvar33, 1
  %polly.adjust_ub35 = sub i64 %77, 1
  %polly.loop_cond36 = icmp sle i64 %polly.indvar33, %polly.adjust_ub35
  br i1 %polly.loop_cond36, label %polly.loop_header29, label %polly.loop_exit31

polly.loop_header38:                              ; preds = %polly.loop_header29, %polly.loop_header38
  %polly.indvar42 = phi i64 [ %polly.indvar_next43, %polly.loop_header38 ], [ %82, %polly.loop_header29 ]
  %86 = mul i64 -1, %polly.indvar42
  %87 = add i64 %78, %86
  %p_i.02.moved.to. = trunc i64 %polly.indvar33 to i32
  %p_.moved.to. = sitofp i32 %p_i.02.moved.to. to double
  %p_.moved.to.14 = sitofp i32 %n to double
  %p_scevgep6 = getelementptr [1300 x double]* %B, i64 %polly.indvar33, i64 %87
  %p_scevgep = getelementptr [1300 x double]* %A, i64 %polly.indvar33, i64 %87
  %p_ = add i64 %87, 2
  %p_46 = trunc i64 %p_ to i32
  %p_47 = add i64 %87, 3
  %p_48 = trunc i64 %p_47 to i32
  %p_49 = sitofp i32 %p_46 to double
  %p_50 = fmul double %p_.moved.to., %p_49
  %p_51 = fadd double %p_50, 2.000000e+00
  %p_52 = fdiv double %p_51, %p_.moved.to.14
  store double %p_52, double* %p_scevgep
  %p_53 = sitofp i32 %p_48 to double
  %p_54 = fmul double %p_.moved.to., %p_53
  %p_55 = fadd double %p_54, 3.000000e+00
  %p_56 = fdiv double %p_55, %p_.moved.to.14
  store double %p_56, double* %p_scevgep6
  %p_indvar.next = add i64 %87, 1
  %polly.indvar_next43 = add nsw i64 %polly.indvar42, 1
  %polly.adjust_ub44 = sub i64 %85, 1
  %polly.loop_cond45 = icmp sle i64 %polly.indvar42, %polly.adjust_ub44
  br i1 %polly.loop_cond45, label %polly.loop_header38, label %polly.loop_exit40
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_jacobi_2d(i32 %tsteps, i32 %n, [1300 x double]* %A, [1300 x double]* %B) #0 {
.split:
  %scevgep48 = getelementptr [1300 x double]* %A, i64 1, i64 1
  %scevgep49 = getelementptr [1300 x double]* %A, i64 1, i64 0
  %0 = icmp ult double* %scevgep49, %scevgep48
  %umin = select i1 %0, double* %scevgep49, double* %scevgep48
  %scevgep50 = getelementptr [1300 x double]* %A, i64 1, i64 2
  %1 = icmp ult double* %scevgep50, %umin
  %umin51 = select i1 %1, double* %scevgep50, double* %umin
  %scevgep52 = getelementptr [1300 x double]* %A, i64 2, i64 1
  %2 = icmp ult double* %scevgep52, %umin51
  %umin53 = select i1 %2, double* %scevgep52, double* %umin51
  %scevgep54 = getelementptr [1300 x double]* %A, i64 0, i64 1
  %3 = icmp ult double* %scevgep54, %umin53
  %umin55 = select i1 %3, double* %scevgep54, double* %umin53
  %4 = icmp ult double* %scevgep48, %umin55
  %umin56 = select i1 %4, double* %scevgep48, double* %umin55
  %umin5696 = bitcast double* %umin56 to i8*
  %scevgep5758 = ptrtoint double* %scevgep48 to i64
  %5 = add i32 %n, -3
  %6 = zext i32 %5 to i64
  %7 = mul i64 10400, %6
  %8 = add i64 %scevgep5758, %7
  %9 = mul i64 8, %6
  %10 = add i64 %8, %9
  %scevgep5960 = ptrtoint double* %scevgep49 to i64
  %11 = add i64 %scevgep5960, %7
  %12 = add i64 %11, %9
  %13 = icmp ugt i64 %12, %10
  %umax = select i1 %13, i64 %12, i64 %10
  %scevgep6162 = ptrtoint double* %scevgep50 to i64
  %14 = add i64 %scevgep6162, %7
  %15 = add i64 %14, %9
  %16 = icmp ugt i64 %15, %umax
  %umax63 = select i1 %16, i64 %15, i64 %umax
  %scevgep6465 = ptrtoint double* %scevgep52 to i64
  %17 = add i64 %scevgep6465, %7
  %18 = add i64 %17, %9
  %19 = icmp ugt i64 %18, %umax63
  %umax66 = select i1 %19, i64 %18, i64 %umax63
  %scevgep6768 = ptrtoint double* %scevgep54 to i64
  %20 = add i64 %scevgep6768, %7
  %21 = add i64 %20, %9
  %22 = icmp ugt i64 %21, %umax66
  %umax69 = select i1 %22, i64 %21, i64 %umax66
  %23 = icmp ugt i64 %10, %umax69
  %umax70 = select i1 %23, i64 %10, i64 %umax69
  %umax7097 = inttoptr i64 %umax70 to i8*
  %scevgep71 = getelementptr [1300 x double]* %B, i64 1, i64 1
  %scevgep73 = getelementptr [1300 x double]* %B, i64 1, i64 0
  %24 = icmp ult double* %scevgep73, %scevgep71
  %umin74 = select i1 %24, double* %scevgep73, double* %scevgep71
  %scevgep75 = getelementptr [1300 x double]* %B, i64 1, i64 2
  %25 = icmp ult double* %scevgep75, %umin74
  %umin76 = select i1 %25, double* %scevgep75, double* %umin74
  %scevgep77 = getelementptr [1300 x double]* %B, i64 2, i64 1
  %26 = icmp ult double* %scevgep77, %umin76
  %umin78 = select i1 %26, double* %scevgep77, double* %umin76
  %scevgep79 = getelementptr [1300 x double]* %B, i64 0, i64 1
  %27 = icmp ult double* %scevgep79, %umin78
  %umin80 = select i1 %27, double* %scevgep79, double* %umin78
  %umin8098 = bitcast double* %umin80 to i8*
  %scevgep8182 = ptrtoint double* %scevgep71 to i64
  %28 = add i64 %scevgep8182, %7
  %29 = add i64 %28, %9
  %scevgep8485 = ptrtoint double* %scevgep73 to i64
  %30 = add i64 %scevgep8485, %7
  %31 = add i64 %30, %9
  %32 = icmp ugt i64 %31, %29
  %umax86 = select i1 %32, i64 %31, i64 %29
  %scevgep8788 = ptrtoint double* %scevgep75 to i64
  %33 = add i64 %scevgep8788, %7
  %34 = add i64 %33, %9
  %35 = icmp ugt i64 %34, %umax86
  %umax89 = select i1 %35, i64 %34, i64 %umax86
  %scevgep9091 = ptrtoint double* %scevgep77 to i64
  %36 = add i64 %scevgep9091, %7
  %37 = add i64 %36, %9
  %38 = icmp ugt i64 %37, %umax89
  %umax92 = select i1 %38, i64 %37, i64 %umax89
  %scevgep9394 = ptrtoint double* %scevgep79 to i64
  %39 = add i64 %scevgep9394, %7
  %40 = add i64 %39, %9
  %41 = icmp ugt i64 %40, %umax92
  %umax95 = select i1 %41, i64 %40, i64 %umax92
  %umax9599 = inttoptr i64 %umax95 to i8*
  %42 = icmp ult i8* %umax7097, %umin8098
  %43 = icmp ult i8* %umax9599, %umin5696
  %pair-no-alias = or i1 %42, %43
  br i1 %pair-no-alias, label %polly.start, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  %44 = icmp sgt i32 %tsteps, 0
  br i1 %44, label %.preheader3.lr.ph.clone, label %.region.clone

.preheader3.lr.ph.clone:                          ; preds = %.split.split.clone
  %45 = add i64 %6, 1
  %46 = add nsw i32 %n, -1
  %47 = icmp sgt i32 %46, 1
  br label %.preheader3.clone

.preheader3.clone:                                ; preds = %._crit_edge12.clone, %.preheader3.lr.ph.clone
  %t.013.clone = phi i32 [ 0, %.preheader3.lr.ph.clone ], [ %76, %._crit_edge12.clone ]
  br i1 %47, label %.preheader1.clone, label %.preheader2.clone

.preheader1.clone:                                ; preds = %.preheader3.clone, %._crit_edge.clone
  %indvar15.clone = phi i64 [ %49, %._crit_edge.clone ], [ 0, %.preheader3.clone ]
  %48 = add i64 %indvar15.clone, 2
  %49 = add i64 %indvar15.clone, 1
  br i1 %47, label %.lr.ph.clone, label %._crit_edge.clone

.lr.ph.clone:                                     ; preds = %.preheader1.clone, %.lr.ph.clone
  %indvar.clone = phi i64 [ %50, %.lr.ph.clone ], [ 0, %.preheader1.clone ]
  %50 = add i64 %indvar.clone, 1
  %scevgep18.clone = getelementptr [1300 x double]* %A, i64 %indvar15.clone, i64 %50
  %scevgep17.clone = getelementptr [1300 x double]* %A, i64 %48, i64 %50
  %51 = add i64 %indvar.clone, 2
  %scevgep21.clone = getelementptr [1300 x double]* %A, i64 %49, i64 %51
  %scevgep20.clone = getelementptr [1300 x double]* %A, i64 %49, i64 %indvar.clone
  %scevgep19.clone = getelementptr [1300 x double]* %B, i64 %49, i64 %50
  %scevgep.clone = getelementptr [1300 x double]* %A, i64 %49, i64 %50
  %52 = load double* %scevgep.clone, align 8, !tbaa !6
  %53 = load double* %scevgep20.clone, align 8, !tbaa !6
  %54 = fadd double %52, %53
  %55 = load double* %scevgep21.clone, align 8, !tbaa !6
  %56 = fadd double %54, %55
  %57 = load double* %scevgep17.clone, align 8, !tbaa !6
  %58 = fadd double %56, %57
  %59 = load double* %scevgep18.clone, align 8, !tbaa !6
  %60 = fadd double %58, %59
  %61 = fmul double %60, 2.000000e-01
  store double %61, double* %scevgep19.clone, align 8, !tbaa !6
  %exitcond.clone = icmp ne i64 %50, %45
  br i1 %exitcond.clone, label %.lr.ph.clone, label %._crit_edge.clone

._crit_edge.clone:                                ; preds = %.lr.ph.clone, %.preheader1.clone
  %exitcond22.clone = icmp ne i64 %49, %45
  br i1 %exitcond22.clone, label %.preheader1.clone, label %.preheader2.clone

.preheader2.clone:                                ; preds = %._crit_edge.clone, %.preheader3.clone
  br i1 %47, label %.preheader.clone, label %._crit_edge12.clone

.preheader.clone:                                 ; preds = %.preheader2.clone, %._crit_edge9.clone
  %indvar32.clone = phi i64 [ %63, %._crit_edge9.clone ], [ 0, %.preheader2.clone ]
  %62 = add i64 %indvar32.clone, 2
  %63 = add i64 %indvar32.clone, 1
  br i1 %47, label %.lr.ph8.clone, label %._crit_edge9.clone

.lr.ph8.clone:                                    ; preds = %.preheader.clone, %.lr.ph8.clone
  %indvar29.clone = phi i64 [ %64, %.lr.ph8.clone ], [ 0, %.preheader.clone ]
  %64 = add i64 %indvar29.clone, 1
  %scevgep36.clone = getelementptr [1300 x double]* %B, i64 %indvar32.clone, i64 %64
  %scevgep35.clone = getelementptr [1300 x double]* %B, i64 %62, i64 %64
  %65 = add i64 %indvar29.clone, 2
  %scevgep39.clone = getelementptr [1300 x double]* %B, i64 %63, i64 %65
  %scevgep38.clone = getelementptr [1300 x double]* %B, i64 %63, i64 %indvar29.clone
  %scevgep37.clone = getelementptr [1300 x double]* %A, i64 %63, i64 %64
  %scevgep34.clone = getelementptr [1300 x double]* %B, i64 %63, i64 %64
  %66 = load double* %scevgep34.clone, align 8, !tbaa !6
  %67 = load double* %scevgep38.clone, align 8, !tbaa !6
  %68 = fadd double %66, %67
  %69 = load double* %scevgep39.clone, align 8, !tbaa !6
  %70 = fadd double %68, %69
  %71 = load double* %scevgep35.clone, align 8, !tbaa !6
  %72 = fadd double %70, %71
  %73 = load double* %scevgep36.clone, align 8, !tbaa !6
  %74 = fadd double %72, %73
  %75 = fmul double %74, 2.000000e-01
  store double %75, double* %scevgep37.clone, align 8, !tbaa !6
  %exitcond31.clone = icmp ne i64 %64, %45
  br i1 %exitcond31.clone, label %.lr.ph8.clone, label %._crit_edge9.clone

._crit_edge9.clone:                               ; preds = %.lr.ph8.clone, %.preheader.clone
  %exitcond40.clone = icmp ne i64 %63, %45
  br i1 %exitcond40.clone, label %.preheader.clone, label %._crit_edge12.clone

._crit_edge12.clone:                              ; preds = %._crit_edge9.clone, %.preheader2.clone
  %76 = add nsw i32 %t.013.clone, 1
  %exitcond47.clone = icmp ne i32 %76, %tsteps
  br i1 %exitcond47.clone, label %.preheader3.clone, label %.region.clone

.region.clone:                                    ; preds = %polly.then, %polly.loop_exit168, %polly.start, %.split.split.clone, %._crit_edge12.clone
  ret void

polly.start:                                      ; preds = %.split
  %77 = sext i32 %n to i64
  %78 = icmp sge i64 %77, 3
  %79 = sext i32 %tsteps to i64
  %80 = icmp sge i64 %79, 1
  %81 = and i1 %78, %80
  br i1 %81, label %polly.then, label %.region.clone

polly.then:                                       ; preds = %polly.start
  %82 = add i64 %79, -1
  %polly.loop_guard = icmp sle i64 0, %82
  br i1 %polly.loop_guard, label %polly.loop_header, label %.region.clone

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit168
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit168 ], [ 0, %polly.then ]
  br i1 true, label %polly.loop_header120, label %polly.loop_exit122

polly.loop_exit122:                               ; preds = %polly.loop_exit131, %polly.loop_header
  br i1 true, label %polly.loop_header166, label %polly.loop_exit168

polly.loop_exit168:                               ; preds = %polly.loop_exit177, %polly.loop_exit122
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %82, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %.region.clone

polly.loop_header120:                             ; preds = %polly.loop_header, %polly.loop_exit131
  %polly.indvar124 = phi i64 [ %polly.indvar_next125, %polly.loop_exit131 ], [ 0, %polly.loop_header ]
  %83 = mul i64 -32, %polly.indvar124
  %84 = mul i64 -3, %polly.indvar124
  %85 = add i64 %84, %6
  %86 = add i64 %85, 11
  %87 = sub i64 %86, 32
  %88 = add i64 %87, 1
  %89 = icmp slt i64 %86, 0
  %90 = select i1 %89, i64 %88, i64 %86
  %91 = sdiv i64 %90, 32
  %92 = mul i64 -32, %91
  %93 = add i64 %83, %92
  %94 = add i64 %93, -640
  %95 = mul i64 -11, %6
  %96 = add i64 %95, -1
  %97 = sub i64 %96, 32
  %98 = add i64 %97, 1
  %99 = icmp slt i64 %96, 0
  %100 = select i1 %99, i64 %98, i64 %96
  %101 = sdiv i64 %100, 32
  %102 = mul i64 -32, %101
  %103 = mul i64 -32, %6
  %104 = add i64 %102, %103
  %105 = add i64 %104, -32
  %106 = icmp sgt i64 %94, %105
  %107 = select i1 %106, i64 %94, i64 %105
  %108 = mul i64 -20, %polly.indvar124
  %polly.loop_guard132 = icmp sle i64 %107, %108
  br i1 %polly.loop_guard132, label %polly.loop_header129, label %polly.loop_exit131

polly.loop_exit131:                               ; preds = %polly.loop_exit140, %polly.loop_header120
  %polly.indvar_next125 = add nsw i64 %polly.indvar124, 32
  %polly.adjust_ub126 = sub i64 %6, 32
  %polly.loop_cond127 = icmp sle i64 %polly.indvar124, %polly.adjust_ub126
  br i1 %polly.loop_cond127, label %polly.loop_header120, label %polly.loop_exit122

polly.loop_header129:                             ; preds = %polly.loop_header120, %polly.loop_exit140
  %polly.indvar133 = phi i64 [ %polly.indvar_next134, %polly.loop_exit140 ], [ %107, %polly.loop_header120 ]
  %109 = mul i64 -1, %polly.indvar133
  %110 = mul i64 -1, %6
  %111 = add i64 %109, %110
  %112 = add i64 %111, -31
  %113 = add i64 %112, 20
  %114 = sub i64 %113, 1
  %115 = icmp slt i64 %112, 0
  %116 = select i1 %115, i64 %112, i64 %114
  %117 = sdiv i64 %116, 20
  %118 = icmp sgt i64 %117, %polly.indvar124
  %119 = select i1 %118, i64 %117, i64 %polly.indvar124
  %120 = sub i64 %109, 20
  %121 = add i64 %120, 1
  %122 = icmp slt i64 %109, 0
  %123 = select i1 %122, i64 %121, i64 %109
  %124 = sdiv i64 %123, 20
  %125 = icmp slt i64 %124, %6
  %126 = select i1 %125, i64 %124, i64 %6
  %127 = add i64 %polly.indvar124, 31
  %128 = icmp slt i64 %126, %127
  %129 = select i1 %128, i64 %126, i64 %127
  %polly.loop_guard141 = icmp sle i64 %119, %129
  br i1 %polly.loop_guard141, label %polly.loop_header138, label %polly.loop_exit140

polly.loop_exit140:                               ; preds = %polly.loop_exit149, %polly.loop_header129
  %polly.indvar_next134 = add nsw i64 %polly.indvar133, 32
  %polly.adjust_ub135 = sub i64 %108, 32
  %polly.loop_cond136 = icmp sle i64 %polly.indvar133, %polly.adjust_ub135
  br i1 %polly.loop_cond136, label %polly.loop_header129, label %polly.loop_exit131

polly.loop_header138:                             ; preds = %polly.loop_header129, %polly.loop_exit149
  %polly.indvar142 = phi i64 [ %polly.indvar_next143, %polly.loop_exit149 ], [ %119, %polly.loop_header129 ]
  %130 = mul i64 -20, %polly.indvar142
  %131 = add i64 %130, %110
  %132 = icmp sgt i64 %polly.indvar133, %131
  %133 = select i1 %132, i64 %polly.indvar133, i64 %131
  %134 = add i64 %polly.indvar133, 31
  %135 = icmp slt i64 %130, %134
  %136 = select i1 %135, i64 %130, i64 %134
  %polly.loop_guard150 = icmp sle i64 %133, %136
  br i1 %polly.loop_guard150, label %polly.loop_header147, label %polly.loop_exit149

polly.loop_exit149:                               ; preds = %polly.loop_header147, %polly.loop_header138
  %polly.indvar_next143 = add nsw i64 %polly.indvar142, 1
  %polly.adjust_ub144 = sub i64 %129, 1
  %polly.loop_cond145 = icmp sle i64 %polly.indvar142, %polly.adjust_ub144
  br i1 %polly.loop_cond145, label %polly.loop_header138, label %polly.loop_exit140

polly.loop_header147:                             ; preds = %polly.loop_header138, %polly.loop_header147
  %polly.indvar151 = phi i64 [ %polly.indvar_next152, %polly.loop_header147 ], [ %133, %polly.loop_header138 ]
  %137 = mul i64 -1, %polly.indvar151
  %138 = add i64 %130, %137
  %p_.moved.to. = add i64 %polly.indvar142, 1
  %p_.moved.to.102 = add i64 %polly.indvar142, 2
  %p_.moved.to.105 = add i64 %6, 1
  %p_ = add i64 %138, 1
  %p_scevgep18 = getelementptr [1300 x double]* %A, i64 %polly.indvar142, i64 %p_
  %p_scevgep17 = getelementptr [1300 x double]* %A, i64 %p_.moved.to.102, i64 %p_
  %p_155 = add i64 %138, 2
  %p_scevgep21 = getelementptr [1300 x double]* %A, i64 %p_.moved.to., i64 %p_155
  %p_scevgep20 = getelementptr [1300 x double]* %A, i64 %p_.moved.to., i64 %138
  %p_scevgep19 = getelementptr [1300 x double]* %B, i64 %p_.moved.to., i64 %p_
  %p_scevgep = getelementptr [1300 x double]* %A, i64 %p_.moved.to., i64 %p_
  %_p_scalar_ = load double* %p_scevgep
  %_p_scalar_156 = load double* %p_scevgep20
  %p_157 = fadd double %_p_scalar_, %_p_scalar_156
  %_p_scalar_158 = load double* %p_scevgep21
  %p_159 = fadd double %p_157, %_p_scalar_158
  %_p_scalar_160 = load double* %p_scevgep17
  %p_161 = fadd double %p_159, %_p_scalar_160
  %_p_scalar_162 = load double* %p_scevgep18
  %p_163 = fadd double %p_161, %_p_scalar_162
  %p_164 = fmul double %p_163, 2.000000e-01
  store double %p_164, double* %p_scevgep19
  %polly.indvar_next152 = add nsw i64 %polly.indvar151, 1
  %polly.adjust_ub153 = sub i64 %136, 1
  %polly.loop_cond154 = icmp sle i64 %polly.indvar151, %polly.adjust_ub153
  br i1 %polly.loop_cond154, label %polly.loop_header147, label %polly.loop_exit149

polly.loop_header166:                             ; preds = %polly.loop_exit122, %polly.loop_exit177
  %polly.indvar170 = phi i64 [ %polly.indvar_next171, %polly.loop_exit177 ], [ 0, %polly.loop_exit122 ]
  %139 = mul i64 -32, %polly.indvar170
  %140 = mul i64 -3, %polly.indvar170
  %141 = add i64 %140, %6
  %142 = add i64 %141, 11
  %143 = sub i64 %142, 32
  %144 = add i64 %143, 1
  %145 = icmp slt i64 %142, 0
  %146 = select i1 %145, i64 %144, i64 %142
  %147 = sdiv i64 %146, 32
  %148 = mul i64 -32, %147
  %149 = add i64 %139, %148
  %150 = add i64 %149, -640
  %151 = mul i64 -11, %6
  %152 = add i64 %151, -1
  %153 = sub i64 %152, 32
  %154 = add i64 %153, 1
  %155 = icmp slt i64 %152, 0
  %156 = select i1 %155, i64 %154, i64 %152
  %157 = sdiv i64 %156, 32
  %158 = mul i64 -32, %157
  %159 = mul i64 -32, %6
  %160 = add i64 %158, %159
  %161 = add i64 %160, -32
  %162 = icmp sgt i64 %150, %161
  %163 = select i1 %162, i64 %150, i64 %161
  %164 = mul i64 -20, %polly.indvar170
  %polly.loop_guard178 = icmp sle i64 %163, %164
  br i1 %polly.loop_guard178, label %polly.loop_header175, label %polly.loop_exit177

polly.loop_exit177:                               ; preds = %polly.loop_exit186, %polly.loop_header166
  %polly.indvar_next171 = add nsw i64 %polly.indvar170, 32
  %polly.adjust_ub172 = sub i64 %6, 32
  %polly.loop_cond173 = icmp sle i64 %polly.indvar170, %polly.adjust_ub172
  br i1 %polly.loop_cond173, label %polly.loop_header166, label %polly.loop_exit168

polly.loop_header175:                             ; preds = %polly.loop_header166, %polly.loop_exit186
  %polly.indvar179 = phi i64 [ %polly.indvar_next180, %polly.loop_exit186 ], [ %163, %polly.loop_header166 ]
  %165 = mul i64 -1, %polly.indvar179
  %166 = mul i64 -1, %6
  %167 = add i64 %165, %166
  %168 = add i64 %167, -31
  %169 = add i64 %168, 20
  %170 = sub i64 %169, 1
  %171 = icmp slt i64 %168, 0
  %172 = select i1 %171, i64 %168, i64 %170
  %173 = sdiv i64 %172, 20
  %174 = icmp sgt i64 %173, %polly.indvar170
  %175 = select i1 %174, i64 %173, i64 %polly.indvar170
  %176 = sub i64 %165, 20
  %177 = add i64 %176, 1
  %178 = icmp slt i64 %165, 0
  %179 = select i1 %178, i64 %177, i64 %165
  %180 = sdiv i64 %179, 20
  %181 = icmp slt i64 %180, %6
  %182 = select i1 %181, i64 %180, i64 %6
  %183 = add i64 %polly.indvar170, 31
  %184 = icmp slt i64 %182, %183
  %185 = select i1 %184, i64 %182, i64 %183
  %polly.loop_guard187 = icmp sle i64 %175, %185
  br i1 %polly.loop_guard187, label %polly.loop_header184, label %polly.loop_exit186

polly.loop_exit186:                               ; preds = %polly.loop_exit195, %polly.loop_header175
  %polly.indvar_next180 = add nsw i64 %polly.indvar179, 32
  %polly.adjust_ub181 = sub i64 %164, 32
  %polly.loop_cond182 = icmp sle i64 %polly.indvar179, %polly.adjust_ub181
  br i1 %polly.loop_cond182, label %polly.loop_header175, label %polly.loop_exit177

polly.loop_header184:                             ; preds = %polly.loop_header175, %polly.loop_exit195
  %polly.indvar188 = phi i64 [ %polly.indvar_next189, %polly.loop_exit195 ], [ %175, %polly.loop_header175 ]
  %186 = mul i64 -20, %polly.indvar188
  %187 = add i64 %186, %166
  %188 = icmp sgt i64 %polly.indvar179, %187
  %189 = select i1 %188, i64 %polly.indvar179, i64 %187
  %190 = add i64 %polly.indvar179, 31
  %191 = icmp slt i64 %186, %190
  %192 = select i1 %191, i64 %186, i64 %190
  %polly.loop_guard196 = icmp sle i64 %189, %192
  br i1 %polly.loop_guard196, label %polly.loop_header193, label %polly.loop_exit195

polly.loop_exit195:                               ; preds = %polly.loop_header193, %polly.loop_header184
  %polly.indvar_next189 = add nsw i64 %polly.indvar188, 1
  %polly.adjust_ub190 = sub i64 %185, 1
  %polly.loop_cond191 = icmp sle i64 %polly.indvar188, %polly.adjust_ub190
  br i1 %polly.loop_cond191, label %polly.loop_header184, label %polly.loop_exit186

polly.loop_header193:                             ; preds = %polly.loop_header184, %polly.loop_header193
  %polly.indvar197 = phi i64 [ %polly.indvar_next198, %polly.loop_header193 ], [ %189, %polly.loop_header184 ]
  %193 = mul i64 -1, %polly.indvar197
  %194 = add i64 %186, %193
  %p_.moved.to.111 = add i64 %polly.indvar188, 1
  %p_.moved.to.112 = add i64 %polly.indvar188, 2
  %p_.moved.to.115 = add i64 %6, 1
  %p_202 = add i64 %194, 1
  %p_scevgep36 = getelementptr [1300 x double]* %B, i64 %polly.indvar188, i64 %p_202
  %p_scevgep35 = getelementptr [1300 x double]* %B, i64 %p_.moved.to.112, i64 %p_202
  %p_203 = add i64 %194, 2
  %p_scevgep39 = getelementptr [1300 x double]* %B, i64 %p_.moved.to.111, i64 %p_203
  %p_scevgep38 = getelementptr [1300 x double]* %B, i64 %p_.moved.to.111, i64 %194
  %p_scevgep37 = getelementptr [1300 x double]* %A, i64 %p_.moved.to.111, i64 %p_202
  %p_scevgep34 = getelementptr [1300 x double]* %B, i64 %p_.moved.to.111, i64 %p_202
  %_p_scalar_204 = load double* %p_scevgep34
  %_p_scalar_205 = load double* %p_scevgep38
  %p_206 = fadd double %_p_scalar_204, %_p_scalar_205
  %_p_scalar_207 = load double* %p_scevgep39
  %p_208 = fadd double %p_206, %_p_scalar_207
  %_p_scalar_209 = load double* %p_scevgep35
  %p_210 = fadd double %p_208, %_p_scalar_209
  %_p_scalar_211 = load double* %p_scevgep36
  %p_212 = fadd double %p_210, %_p_scalar_211
  %p_213 = fmul double %p_212, 2.000000e-01
  store double %p_213, double* %p_scevgep37
  %polly.indvar_next198 = add nsw i64 %polly.indvar197, 1
  %polly.adjust_ub199 = sub i64 %192, 1
  %polly.loop_cond200 = icmp sle i64 %polly.indvar197, %polly.adjust_ub199
  br i1 %polly.loop_cond200, label %polly.loop_header193, label %polly.loop_exit195
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, [1300 x double]* %A) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %n, 0
  br i1 %5, label %.preheader.lr.ph, label %22

.preheader.lr.ph:                                 ; preds = %.split
  %6 = zext i32 %n to i64
  %7 = zext i32 %n to i64
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
  %scevgep = getelementptr [1300 x double]* %A, i64 %indvar4, i64 %indvar
  %13 = srem i32 %12, 20
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %15, label %17

; <label>:15                                      ; preds = %10
  %16 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %16) #4
  br label %17

; <label>:17                                      ; preds = %15, %10
  %18 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %19 = load double* %scevgep, align 8, !tbaa !6
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
  %23 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %24 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %25 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
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
!2 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{metadata !3, metadata !3, i64 0}
!6 = metadata !{metadata !7, metadata !7, i64 0}
!7 = metadata !{metadata !"double", metadata !3, i64 0}
