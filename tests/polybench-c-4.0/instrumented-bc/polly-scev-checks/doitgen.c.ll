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
  %C438 = bitcast [160 x double]* %C4 to i8*
  %sum40 = ptrtoint double* %sum to i64
  %C435 = ptrtoint [160 x double]* %C4 to i64
  %A34 = ptrtoint [140 x [160 x double]]* %A to i64
  %umin36 = bitcast [140 x [160 x double]]* %A to i8*
  %0 = zext i32 %nr to i64
  %1 = add i64 %0, -1
  %2 = mul i64 179200, %1
  %3 = add i64 %A34, %2
  %4 = zext i32 %nq to i64
  %5 = add i64 %4, -1
  %6 = mul i64 1280, %5
  %7 = add i64 %3, %6
  %8 = zext i32 %np to i64
  %9 = add i64 %8, -1
  %10 = mul i64 8, %9
  %11 = add i64 %7, %10
  %umax37 = inttoptr i64 %11 to i8*
  %12 = add i64 %C435, %10
  %13 = mul i64 1280, %9
  %14 = add i64 %12, %13
  %15 = inttoptr i64 %14 to i8*
  %16 = icmp ult i8* %umax37, %C438
  %17 = icmp ult i8* %15, %umin36
  %pair-no-alias = or i1 %16, %17
  %umin3942 = bitcast double* %sum to i8*
  %18 = add i64 %sum40, %10
  %umax4143 = inttoptr i64 %18 to i8*
  %19 = icmp ult i8* %umax37, %umin3942
  %20 = icmp ult i8* %umax4143, %umin36
  %pair-no-alias44 = or i1 %19, %20
  %21 = and i1 %pair-no-alias, %pair-no-alias44
  %22 = icmp ult i8* %15, %umin3942
  %23 = icmp ult i8* %umax4143, %C438
  %pair-no-alias45 = or i1 %22, %23
  %24 = and i1 %21, %pair-no-alias45
  br i1 %24, label %polly.start, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  %25 = icmp sgt i32 %nr, 0
  br i1 %25, label %.preheader2.lr.ph.clone, label %.region.clone

.preheader2.lr.ph.clone:                          ; preds = %.split.split.clone
  %26 = icmp sgt i32 %nq, 0
  %27 = icmp sgt i32 %np, 0
  br label %.preheader2.clone

.preheader2.clone:                                ; preds = %._crit_edge10.clone, %.preheader2.lr.ph.clone
  %indvar13.clone = phi i64 [ 0, %.preheader2.lr.ph.clone ], [ %indvar.next14.clone, %._crit_edge10.clone ]
  br i1 %26, label %.preheader1.clone, label %._crit_edge10.clone

.preheader1.clone:                                ; preds = %.preheader2.clone, %._crit_edge8.clone
  %indvar15.clone = phi i64 [ %indvar.next16.clone, %._crit_edge8.clone ], [ 0, %.preheader2.clone ]
  br i1 %27, label %.lr.ph5.clone, label %.preheader.clone

.lr.ph5.clone:                                    ; preds = %.preheader1.clone, %._crit_edge.clone
  %indvar17.clone = phi i64 [ %indvar.next18.clone, %._crit_edge.clone ], [ 0, %.preheader1.clone ]
  %scevgep22.clone = getelementptr double* %sum, i64 %indvar17.clone
  store double 0.000000e+00, double* %scevgep22.clone, align 8, !tbaa !1
  br i1 %27, label %.lr.ph.clone, label %._crit_edge.clone

.lr.ph.clone:                                     ; preds = %.lr.ph5.clone, %.lr.ph.clone
  %indvar.clone = phi i64 [ %indvar.next.clone, %.lr.ph.clone ], [ 0, %.lr.ph5.clone ]
  %scevgep.clone = getelementptr [140 x [160 x double]]* %A, i64 %indvar13.clone, i64 %indvar15.clone, i64 %indvar.clone
  %scevgep19.clone = getelementptr [160 x double]* %C4, i64 %indvar.clone, i64 %indvar17.clone
  %28 = load double* %scevgep.clone, align 8, !tbaa !1
  %29 = load double* %scevgep19.clone, align 8, !tbaa !1
  %30 = fmul double %28, %29
  %31 = load double* %scevgep22.clone, align 8, !tbaa !1
  %32 = fadd double %31, %30
  store double %32, double* %scevgep22.clone, align 8, !tbaa !1
  %indvar.next.clone = add i64 %indvar.clone, 1
  %exitcond.clone = icmp ne i64 %indvar.next.clone, %8
  br i1 %exitcond.clone, label %.lr.ph.clone, label %._crit_edge.clone

._crit_edge.clone:                                ; preds = %.lr.ph.clone, %.lr.ph5.clone
  %indvar.next18.clone = add i64 %indvar17.clone, 1
  %exitcond20.clone = icmp ne i64 %indvar.next18.clone, %8
  br i1 %exitcond20.clone, label %.lr.ph5.clone, label %.preheader.clone

.preheader.clone:                                 ; preds = %._crit_edge.clone, %.preheader1.clone
  br i1 %27, label %.lr.ph7.clone, label %._crit_edge8.clone

.lr.ph7.clone:                                    ; preds = %.preheader.clone, %.lr.ph7.clone
  %indvar23.clone = phi i64 [ %indvar.next24.clone, %.lr.ph7.clone ], [ 0, %.preheader.clone ]
  %scevgep27.clone = getelementptr [140 x [160 x double]]* %A, i64 %indvar13.clone, i64 %indvar15.clone, i64 %indvar23.clone
  %scevgep26.clone = getelementptr double* %sum, i64 %indvar23.clone
  %33 = load double* %scevgep26.clone, align 8, !tbaa !1
  store double %33, double* %scevgep27.clone, align 8, !tbaa !1
  %indvar.next24.clone = add i64 %indvar23.clone, 1
  %exitcond25.clone = icmp ne i64 %indvar.next24.clone, %8
  br i1 %exitcond25.clone, label %.lr.ph7.clone, label %._crit_edge8.clone

._crit_edge8.clone:                               ; preds = %.lr.ph7.clone, %.preheader.clone
  %indvar.next16.clone = add i64 %indvar15.clone, 1
  %exitcond28.clone = icmp ne i64 %indvar.next16.clone, %4
  br i1 %exitcond28.clone, label %.preheader1.clone, label %._crit_edge10.clone

._crit_edge10.clone:                              ; preds = %._crit_edge8.clone, %.preheader2.clone
  %indvar.next14.clone = add i64 %indvar13.clone, 1
  %exitcond31.clone = icmp ne i64 %indvar.next14.clone, %0
  br i1 %exitcond31.clone, label %.preheader2.clone, label %.region.clone

.region.clone:                                    ; preds = %polly.then, %polly.loop_exit54, %polly.start, %.split.split.clone, %._crit_edge10.clone
  ret void

polly.start:                                      ; preds = %.split
  %34 = sext i32 %np to i64
  %35 = icmp sge i64 %34, 1
  %36 = sext i32 %nq to i64
  %37 = icmp sge i64 %36, 1
  %38 = and i1 %35, %37
  %39 = sext i32 %nr to i64
  %40 = icmp sge i64 %39, 1
  %41 = and i1 %38, %40
  %42 = icmp sge i64 %0, 1
  %43 = and i1 %41, %42
  %44 = icmp sge i64 %4, 1
  %45 = and i1 %43, %44
  %46 = icmp sge i64 %8, 1
  %47 = and i1 %45, %46
  br i1 %47, label %polly.then, label %.region.clone

polly.then:                                       ; preds = %polly.start
  %polly.loop_guard = icmp sle i64 0, %1
  br i1 %polly.loop_guard, label %polly.loop_header, label %.region.clone

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit54
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit54 ], [ 0, %polly.then ]
  %polly.loop_guard55 = icmp sle i64 0, %5
  br i1 %polly.loop_guard55, label %polly.loop_header52, label %polly.loop_exit54

polly.loop_exit54:                                ; preds = %polly.loop_exit112, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %1, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %.region.clone

polly.loop_header52:                              ; preds = %polly.loop_header, %polly.loop_exit112
  %polly.indvar56 = phi i64 [ %polly.indvar_next57, %polly.loop_exit112 ], [ 0, %polly.loop_header ]
  %polly.loop_guard64 = icmp sle i64 0, %9
  br i1 %polly.loop_guard64, label %polly.loop_header61, label %polly.loop_exit63

polly.loop_exit63:                                ; preds = %polly.loop_header61, %polly.loop_header52
  br i1 %polly.loop_guard64, label %polly.loop_header70, label %polly.loop_exit72

polly.loop_exit72:                                ; preds = %polly.loop_exit81, %polly.loop_exit63
  br i1 %polly.loop_guard64, label %polly.loop_header110, label %polly.loop_exit112

polly.loop_exit112:                               ; preds = %polly.loop_header110, %polly.loop_exit72
  %polly.indvar_next57 = add nsw i64 %polly.indvar56, 1
  %polly.adjust_ub58 = sub i64 %5, 1
  %polly.loop_cond59 = icmp sle i64 %polly.indvar56, %polly.adjust_ub58
  br i1 %polly.loop_cond59, label %polly.loop_header52, label %polly.loop_exit54

polly.loop_header61:                              ; preds = %polly.loop_header52, %polly.loop_header61
  %polly.indvar65 = phi i64 [ %polly.indvar_next66, %polly.loop_header61 ], [ 0, %polly.loop_header52 ]
  %p_scevgep22 = getelementptr double* %sum, i64 %polly.indvar65
  store double 0.000000e+00, double* %p_scevgep22
  %polly.indvar_next66 = add nsw i64 %polly.indvar65, 1
  %polly.adjust_ub67 = sub i64 %9, 1
  %polly.loop_cond68 = icmp sle i64 %polly.indvar65, %polly.adjust_ub67
  br i1 %polly.loop_cond68, label %polly.loop_header61, label %polly.loop_exit63

polly.loop_header70:                              ; preds = %polly.loop_exit63, %polly.loop_exit81
  %polly.indvar74 = phi i64 [ %polly.indvar_next75, %polly.loop_exit81 ], [ 0, %polly.loop_exit63 ]
  br i1 %polly.loop_guard64, label %polly.loop_header79, label %polly.loop_exit81

polly.loop_exit81:                                ; preds = %polly.loop_exit90, %polly.loop_header70
  %polly.indvar_next75 = add nsw i64 %polly.indvar74, 32
  %polly.adjust_ub76 = sub i64 %9, 32
  %polly.loop_cond77 = icmp sle i64 %polly.indvar74, %polly.adjust_ub76
  br i1 %polly.loop_cond77, label %polly.loop_header70, label %polly.loop_exit72

polly.loop_header79:                              ; preds = %polly.loop_header70, %polly.loop_exit90
  %polly.indvar83 = phi i64 [ %polly.indvar_next84, %polly.loop_exit90 ], [ 0, %polly.loop_header70 ]
  %48 = add i64 %polly.indvar74, 31
  %49 = icmp slt i64 %48, %9
  %50 = select i1 %49, i64 %48, i64 %9
  %polly.loop_guard91 = icmp sle i64 %polly.indvar74, %50
  br i1 %polly.loop_guard91, label %polly.loop_header88, label %polly.loop_exit90

polly.loop_exit90:                                ; preds = %polly.loop_exit99, %polly.loop_header79
  %polly.indvar_next84 = add nsw i64 %polly.indvar83, 32
  %polly.adjust_ub85 = sub i64 %9, 32
  %polly.loop_cond86 = icmp sle i64 %polly.indvar83, %polly.adjust_ub85
  br i1 %polly.loop_cond86, label %polly.loop_header79, label %polly.loop_exit81

polly.loop_header88:                              ; preds = %polly.loop_header79, %polly.loop_exit99
  %polly.indvar92 = phi i64 [ %polly.indvar_next93, %polly.loop_exit99 ], [ %polly.indvar74, %polly.loop_header79 ]
  %51 = add i64 %polly.indvar83, 31
  %52 = icmp slt i64 %51, %9
  %53 = select i1 %52, i64 %51, i64 %9
  %polly.loop_guard100 = icmp sle i64 %polly.indvar83, %53
  br i1 %polly.loop_guard100, label %polly.loop_header97, label %polly.loop_exit99

polly.loop_exit99:                                ; preds = %polly.loop_header97, %polly.loop_header88
  %polly.indvar_next93 = add nsw i64 %polly.indvar92, 1
  %polly.adjust_ub94 = sub i64 %50, 1
  %polly.loop_cond95 = icmp sle i64 %polly.indvar92, %polly.adjust_ub94
  br i1 %polly.loop_cond95, label %polly.loop_header88, label %polly.loop_exit90

polly.loop_header97:                              ; preds = %polly.loop_header88, %polly.loop_header97
  %polly.indvar101 = phi i64 [ %polly.indvar_next102, %polly.loop_header97 ], [ %polly.indvar83, %polly.loop_header88 ]
  %p_scevgep22.moved.to. = getelementptr double* %sum, i64 %polly.indvar92
  %p_scevgep = getelementptr [140 x [160 x double]]* %A, i64 %polly.indvar, i64 %polly.indvar56, i64 %polly.indvar101
  %p_scevgep19 = getelementptr [160 x double]* %C4, i64 %polly.indvar101, i64 %polly.indvar92
  %_p_scalar_ = load double* %p_scevgep
  %_p_scalar_106 = load double* %p_scevgep19
  %p_ = fmul double %_p_scalar_, %_p_scalar_106
  %_p_scalar_107 = load double* %p_scevgep22.moved.to.
  %p_108 = fadd double %_p_scalar_107, %p_
  store double %p_108, double* %p_scevgep22.moved.to.
  %p_indvar.next = add i64 %polly.indvar101, 1
  %polly.indvar_next102 = add nsw i64 %polly.indvar101, 1
  %polly.adjust_ub103 = sub i64 %53, 1
  %polly.loop_cond104 = icmp sle i64 %polly.indvar101, %polly.adjust_ub103
  br i1 %polly.loop_cond104, label %polly.loop_header97, label %polly.loop_exit99

polly.loop_header110:                             ; preds = %polly.loop_exit72, %polly.loop_header110
  %polly.indvar114 = phi i64 [ %polly.indvar_next115, %polly.loop_header110 ], [ 0, %polly.loop_exit72 ]
  %p_scevgep27 = getelementptr [140 x [160 x double]]* %A, i64 %polly.indvar, i64 %polly.indvar56, i64 %polly.indvar114
  %p_scevgep26 = getelementptr double* %sum, i64 %polly.indvar114
  %_p_scalar_119 = load double* %p_scevgep26
  store double %_p_scalar_119, double* %p_scevgep27
  %p_indvar.next24 = add i64 %polly.indvar114, 1
  %polly.indvar_next115 = add nsw i64 %polly.indvar114, 1
  %polly.adjust_ub116 = sub i64 %9, 1
  %polly.loop_cond117 = icmp sle i64 %polly.indvar114, %polly.adjust_ub116
  br i1 %polly.loop_cond117, label %polly.loop_header110, label %polly.loop_exit112
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
polly.split_new_and_old82:
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
  br i1 %16, label %polly.then87, label %polly.merge86

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit53, %polly.merge86
  ret void

polly.then:                                       ; preds = %polly.merge86
  %17 = add i64 %2, -1
  %polly.loop_guard = icmp sle i64 0, %17
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit53
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit53 ], [ 0, %polly.then ]
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
  %polly.loop_guard54 = icmp sle i64 %41, %42
  br i1 %polly.loop_guard54, label %polly.loop_header51, label %polly.loop_exit53

polly.loop_exit53:                                ; preds = %polly.loop_exit62, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %17, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header51:                              ; preds = %polly.loop_header, %polly.loop_exit62
  %polly.indvar55 = phi i64 [ %polly.indvar_next56, %polly.loop_exit62 ], [ %41, %polly.loop_header ]
  %43 = mul i64 -1, %polly.indvar55
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
  %polly.loop_guard63 = icmp sle i64 %53, %63
  br i1 %polly.loop_guard63, label %polly.loop_header60, label %polly.loop_exit62

polly.loop_exit62:                                ; preds = %polly.loop_exit71, %polly.loop_header51
  %polly.indvar_next56 = add nsw i64 %polly.indvar55, 32
  %polly.adjust_ub57 = sub i64 %42, 32
  %polly.loop_cond58 = icmp sle i64 %polly.indvar55, %polly.adjust_ub57
  br i1 %polly.loop_cond58, label %polly.loop_header51, label %polly.loop_exit53

polly.loop_header60:                              ; preds = %polly.loop_header51, %polly.loop_exit71
  %polly.indvar64 = phi i64 [ %polly.indvar_next65, %polly.loop_exit71 ], [ %53, %polly.loop_header51 ]
  %64 = mul i64 -20, %polly.indvar64
  %65 = add i64 %64, %44
  %66 = add i64 %65, 1
  %67 = icmp sgt i64 %polly.indvar55, %66
  %68 = select i1 %67, i64 %polly.indvar55, i64 %66
  %69 = add i64 %polly.indvar55, 31
  %70 = icmp slt i64 %64, %69
  %71 = select i1 %70, i64 %64, i64 %69
  %polly.loop_guard72 = icmp sle i64 %68, %71
  br i1 %polly.loop_guard72, label %polly.loop_header69, label %polly.loop_exit71

polly.loop_exit71:                                ; preds = %polly.loop_header69, %polly.loop_header60
  %polly.indvar_next65 = add nsw i64 %polly.indvar64, 1
  %polly.adjust_ub66 = sub i64 %63, 1
  %polly.loop_cond67 = icmp sle i64 %polly.indvar64, %polly.adjust_ub66
  br i1 %polly.loop_cond67, label %polly.loop_header60, label %polly.loop_exit62

polly.loop_header69:                              ; preds = %polly.loop_header60, %polly.loop_header69
  %polly.indvar73 = phi i64 [ %polly.indvar_next74, %polly.loop_header69 ], [ %68, %polly.loop_header60 ]
  %72 = mul i64 -1, %polly.indvar73
  %73 = add i64 %64, %72
  %p_.moved.to. = sitofp i32 %np to double
  %p_scevgep = getelementptr [160 x double]* %C4, i64 %polly.indvar64, i64 %73
  %p_ = mul i64 %polly.indvar64, %73
  %p_77 = trunc i64 %p_ to i32
  %p_78 = srem i32 %p_77, %np
  %p_79 = sitofp i32 %p_78 to double
  %p_80 = fdiv double %p_79, %p_.moved.to.
  store double %p_80, double* %p_scevgep
  %p_indvar.next = add i64 %73, 1
  %polly.indvar_next74 = add nsw i64 %polly.indvar73, 1
  %polly.adjust_ub75 = sub i64 %71, 1
  %polly.loop_cond76 = icmp sle i64 %polly.indvar73, %polly.adjust_ub75
  br i1 %polly.loop_cond76, label %polly.loop_header69, label %polly.loop_exit71

polly.merge86:                                    ; preds = %polly.then87, %polly.loop_exit100, %polly.split_new_and_old82
  %74 = and i1 %4, %15
  br i1 %74, label %polly.then, label %polly.merge

polly.then87:                                     ; preds = %polly.split_new_and_old82
  %75 = add i64 %0, -1
  %polly.loop_guard92 = icmp sle i64 0, %75
  br i1 %polly.loop_guard92, label %polly.loop_header89, label %polly.merge86

polly.loop_header89:                              ; preds = %polly.then87, %polly.loop_exit100
  %polly.indvar93 = phi i64 [ %polly.indvar_next94, %polly.loop_exit100 ], [ 0, %polly.then87 ]
  %76 = add i64 %1, -1
  %polly.loop_guard101 = icmp sle i64 0, %76
  br i1 %polly.loop_guard101, label %polly.loop_header98, label %polly.loop_exit100

polly.loop_exit100:                               ; preds = %polly.loop_exit109, %polly.loop_header89
  %polly.indvar_next94 = add nsw i64 %polly.indvar93, 1
  %polly.adjust_ub95 = sub i64 %75, 1
  %polly.loop_cond96 = icmp sle i64 %polly.indvar93, %polly.adjust_ub95
  br i1 %polly.loop_cond96, label %polly.loop_header89, label %polly.merge86

polly.loop_header98:                              ; preds = %polly.loop_header89, %polly.loop_exit109
  %polly.indvar102 = phi i64 [ %polly.indvar_next103, %polly.loop_exit109 ], [ 0, %polly.loop_header89 ]
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
  %88 = mul i64 -32, %polly.indvar102
  %89 = mul i64 -3, %polly.indvar102
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
  %102 = mul i64 -20, %polly.indvar102
  %polly.loop_guard110 = icmp sle i64 %101, %102
  br i1 %polly.loop_guard110, label %polly.loop_header107, label %polly.loop_exit109

polly.loop_exit109:                               ; preds = %polly.loop_exit118, %polly.loop_header98
  %polly.indvar_next103 = add nsw i64 %polly.indvar102, 32
  %polly.adjust_ub104 = sub i64 %76, 32
  %polly.loop_cond105 = icmp sle i64 %polly.indvar102, %polly.adjust_ub104
  br i1 %polly.loop_cond105, label %polly.loop_header98, label %polly.loop_exit100

polly.loop_header107:                             ; preds = %polly.loop_header98, %polly.loop_exit118
  %polly.indvar111 = phi i64 [ %polly.indvar_next112, %polly.loop_exit118 ], [ %101, %polly.loop_header98 ]
  %103 = mul i64 -1, %polly.indvar111
  %104 = mul i64 -1, %2
  %105 = add i64 %103, %104
  %106 = add i64 %105, -30
  %107 = add i64 %106, 20
  %108 = sub i64 %107, 1
  %109 = icmp slt i64 %106, 0
  %110 = select i1 %109, i64 %106, i64 %108
  %111 = sdiv i64 %110, 20
  %112 = icmp sgt i64 %111, %polly.indvar102
  %113 = select i1 %112, i64 %111, i64 %polly.indvar102
  %114 = sub i64 %103, 20
  %115 = add i64 %114, 1
  %116 = icmp slt i64 %103, 0
  %117 = select i1 %116, i64 %115, i64 %103
  %118 = sdiv i64 %117, 20
  %119 = add i64 %polly.indvar102, 31
  %120 = icmp slt i64 %118, %119
  %121 = select i1 %120, i64 %118, i64 %119
  %122 = icmp slt i64 %121, %76
  %123 = select i1 %122, i64 %121, i64 %76
  %polly.loop_guard119 = icmp sle i64 %113, %123
  br i1 %polly.loop_guard119, label %polly.loop_header116, label %polly.loop_exit118

polly.loop_exit118:                               ; preds = %polly.loop_exit127, %polly.loop_header107
  %polly.indvar_next112 = add nsw i64 %polly.indvar111, 32
  %polly.adjust_ub113 = sub i64 %102, 32
  %polly.loop_cond114 = icmp sle i64 %polly.indvar111, %polly.adjust_ub113
  br i1 %polly.loop_cond114, label %polly.loop_header107, label %polly.loop_exit109

polly.loop_header116:                             ; preds = %polly.loop_header107, %polly.loop_exit127
  %polly.indvar120 = phi i64 [ %polly.indvar_next121, %polly.loop_exit127 ], [ %113, %polly.loop_header107 ]
  %124 = mul i64 -20, %polly.indvar120
  %125 = add i64 %124, %104
  %126 = add i64 %125, 1
  %127 = icmp sgt i64 %polly.indvar111, %126
  %128 = select i1 %127, i64 %polly.indvar111, i64 %126
  %129 = add i64 %polly.indvar111, 31
  %130 = icmp slt i64 %124, %129
  %131 = select i1 %130, i64 %124, i64 %129
  %polly.loop_guard128 = icmp sle i64 %128, %131
  br i1 %polly.loop_guard128, label %polly.loop_header125, label %polly.loop_exit127

polly.loop_exit127:                               ; preds = %polly.loop_header125, %polly.loop_header116
  %polly.indvar_next121 = add nsw i64 %polly.indvar120, 1
  %polly.adjust_ub122 = sub i64 %123, 1
  %polly.loop_cond123 = icmp sle i64 %polly.indvar120, %polly.adjust_ub122
  br i1 %polly.loop_cond123, label %polly.loop_header116, label %polly.loop_exit118

polly.loop_header125:                             ; preds = %polly.loop_header116, %polly.loop_header125
  %polly.indvar129 = phi i64 [ %polly.indvar_next130, %polly.loop_header125 ], [ %128, %polly.loop_header116 ]
  %132 = mul i64 -1, %polly.indvar129
  %133 = add i64 %124, %132
  %p_.moved.to.37 = mul i64 %polly.indvar93, %polly.indvar120
  %p_.moved.to.38 = sitofp i32 %np to double
  %p_scevgep27 = getelementptr [140 x [160 x double]]* %A, i64 %polly.indvar93, i64 %polly.indvar120, i64 %133
  %p_134 = add i64 %p_.moved.to.37, %133
  %p_135 = trunc i64 %p_134 to i32
  %p_136 = srem i32 %p_135, %np
  %p_137 = sitofp i32 %p_136 to double
  %p_138 = fdiv double %p_137, %p_.moved.to.38
  store double %p_138, double* %p_scevgep27
  %p_indvar.next21 = add i64 %133, 1
  %polly.indvar_next130 = add nsw i64 %polly.indvar129, 1
  %polly.adjust_ub131 = sub i64 %131, 1
  %polly.loop_cond132 = icmp sle i64 %polly.indvar129, %polly.adjust_ub131
  br i1 %polly.loop_cond132, label %polly.loop_header125, label %polly.loop_exit127
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
