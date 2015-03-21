; ModuleID = './stencils/heat-3d/heat-3d.c'
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
  %0 = tail call i8* @polybench_alloc_data(i64 1728000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 1728000, i32 8) #3
  %2 = bitcast i8* %0 to [120 x [120 x double]]*
  %3 = bitcast i8* %1 to [120 x [120 x double]]*
  tail call void @init_array(i32 120, [120 x [120 x double]]* %2, [120 x [120 x double]]* %3)
  tail call void (...)* @polybench_timer_start() #3
  tail call void @kernel_heat_3d(i32 500, i32 120, [120 x [120 x double]]* %2, [120 x [120 x double]]* %3)
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
  tail call void @print_array(i32 120, [120 x [120 x double]]* %2)
  br label %9

; <label>:9                                       ; preds = %5, %8, %.split
  tail call void @free(i8* %0) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %n, [120 x [120 x double]]* %A, [120 x [120 x double]]* %B) #0 {
.split:
  %A21 = bitcast [120 x [120 x double]]* %A to i8*
  %B22 = bitcast [120 x [120 x double]]* %B to i8*
  %B20 = ptrtoint [120 x [120 x double]]* %B to i64
  %A19 = ptrtoint [120 x [120 x double]]* %A to i64
  %0 = zext i32 %n to i64
  %1 = add i64 %0, -1
  %2 = mul i64 115200, %1
  %3 = add i64 %A19, %2
  %4 = mul i64 960, %1
  %5 = add i64 %3, %4
  %6 = mul i64 8, %1
  %7 = add i64 %5, %6
  %8 = inttoptr i64 %7 to i8*
  %9 = add i64 %B20, %2
  %10 = add i64 %9, %4
  %11 = add i64 %10, %6
  %12 = inttoptr i64 %11 to i8*
  %13 = icmp ult i8* %8, %B22
  %14 = icmp ult i8* %12, %A21
  %pair-no-alias = or i1 %13, %14
  br i1 %pair-no-alias, label %polly.start, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  %15 = icmp sgt i32 %n, 0
  br i1 %15, label %.preheader1.lr.ph.clone, label %.region.clone

.preheader1.lr.ph.clone:                          ; preds = %.split.split.clone
  %16 = sitofp i32 %n to double
  br label %.preheader1.clone

.preheader1.clone:                                ; preds = %._crit_edge4.clone, %.preheader1.lr.ph.clone
  %indvar10.clone = phi i64 [ 0, %.preheader1.lr.ph.clone ], [ %indvar.next11.clone, %._crit_edge4.clone ]
  %17 = add i64 %0, %indvar10.clone
  br i1 %15, label %.preheader.clone, label %._crit_edge4.clone

.preheader.clone:                                 ; preds = %.preheader1.clone, %._crit_edge.clone
  %indvar8.clone = phi i64 [ %indvar.next9.clone, %._crit_edge.clone ], [ 0, %.preheader1.clone ]
  %18 = add i64 %17, %indvar8.clone
  br i1 %15, label %.lr.ph.clone, label %._crit_edge.clone

.lr.ph.clone:                                     ; preds = %.preheader.clone, %.lr.ph.clone
  %indvar.clone = phi i64 [ %indvar.next.clone, %.lr.ph.clone ], [ 0, %.preheader.clone ]
  %19 = mul i64 %indvar.clone, -1
  %20 = add i64 %18, %19
  %21 = trunc i64 %20 to i32
  %scevgep.clone = getelementptr [120 x [120 x double]]* %B, i64 %indvar10.clone, i64 %indvar8.clone, i64 %indvar.clone
  %scevgep12.clone = getelementptr [120 x [120 x double]]* %A, i64 %indvar10.clone, i64 %indvar8.clone, i64 %indvar.clone
  %22 = sitofp i32 %21 to double
  %23 = fmul double %22, 1.000000e+01
  %24 = fdiv double %23, %16
  store double %24, double* %scevgep.clone, align 8, !tbaa !6
  store double %24, double* %scevgep12.clone, align 8, !tbaa !6
  %indvar.next.clone = add i64 %indvar.clone, 1
  %exitcond.clone = icmp ne i64 %indvar.next.clone, %0
  br i1 %exitcond.clone, label %.lr.ph.clone, label %._crit_edge.clone

._crit_edge.clone:                                ; preds = %.lr.ph.clone, %.preheader.clone
  %indvar.next9.clone = add i64 %indvar8.clone, 1
  %exitcond13.clone = icmp ne i64 %indvar.next9.clone, %0
  br i1 %exitcond13.clone, label %.preheader.clone, label %._crit_edge4.clone

._crit_edge4.clone:                               ; preds = %._crit_edge.clone, %.preheader1.clone
  %indvar.next11.clone = add i64 %indvar10.clone, 1
  %exitcond16.clone = icmp ne i64 %indvar.next11.clone, %0
  br i1 %exitcond16.clone, label %.preheader1.clone, label %.region.clone

.region.clone:                                    ; preds = %polly.then, %polly.loop_exit32, %polly.start, %.split.split.clone, %._crit_edge4.clone
  ret void

polly.start:                                      ; preds = %.split
  %25 = sext i32 %n to i64
  %26 = icmp sge i64 %25, 1
  %27 = icmp sge i64 %0, 1
  %28 = and i1 %26, %27
  br i1 %28, label %polly.then, label %.region.clone

polly.then:                                       ; preds = %polly.start
  %polly.loop_guard = icmp sle i64 0, %1
  br i1 %polly.loop_guard, label %polly.loop_header, label %.region.clone

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit32
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit32 ], [ 0, %polly.then ]
  br i1 %polly.loop_guard, label %polly.loop_header30, label %polly.loop_exit32

polly.loop_exit32:                                ; preds = %polly.loop_exit41, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %1, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %.region.clone

polly.loop_header30:                              ; preds = %polly.loop_header, %polly.loop_exit41
  %polly.indvar34 = phi i64 [ %polly.indvar_next35, %polly.loop_exit41 ], [ 0, %polly.loop_header ]
  %29 = mul i64 -11, %0
  %30 = add i64 %29, 5
  %31 = sub i64 %30, 32
  %32 = add i64 %31, 1
  %33 = icmp slt i64 %30, 0
  %34 = select i1 %33, i64 %32, i64 %30
  %35 = sdiv i64 %34, 32
  %36 = mul i64 -32, %35
  %37 = mul i64 -32, %0
  %38 = add i64 %36, %37
  %39 = mul i64 -32, %polly.indvar34
  %40 = mul i64 -3, %polly.indvar34
  %41 = add i64 %40, %0
  %42 = add i64 %41, 5
  %43 = sub i64 %42, 32
  %44 = add i64 %43, 1
  %45 = icmp slt i64 %42, 0
  %46 = select i1 %45, i64 %44, i64 %42
  %47 = sdiv i64 %46, 32
  %48 = mul i64 -32, %47
  %49 = add i64 %39, %48
  %50 = add i64 %49, -640
  %51 = icmp sgt i64 %38, %50
  %52 = select i1 %51, i64 %38, i64 %50
  %53 = mul i64 -20, %polly.indvar34
  %polly.loop_guard42 = icmp sle i64 %52, %53
  br i1 %polly.loop_guard42, label %polly.loop_header39, label %polly.loop_exit41

polly.loop_exit41:                                ; preds = %polly.loop_exit50, %polly.loop_header30
  %polly.indvar_next35 = add nsw i64 %polly.indvar34, 32
  %polly.adjust_ub36 = sub i64 %1, 32
  %polly.loop_cond37 = icmp sle i64 %polly.indvar34, %polly.adjust_ub36
  br i1 %polly.loop_cond37, label %polly.loop_header30, label %polly.loop_exit32

polly.loop_header39:                              ; preds = %polly.loop_header30, %polly.loop_exit50
  %polly.indvar43 = phi i64 [ %polly.indvar_next44, %polly.loop_exit50 ], [ %52, %polly.loop_header30 ]
  %54 = mul i64 -1, %polly.indvar43
  %55 = mul i64 -1, %0
  %56 = add i64 %54, %55
  %57 = add i64 %56, -30
  %58 = add i64 %57, 20
  %59 = sub i64 %58, 1
  %60 = icmp slt i64 %57, 0
  %61 = select i1 %60, i64 %57, i64 %59
  %62 = sdiv i64 %61, 20
  %63 = icmp sgt i64 %62, %polly.indvar34
  %64 = select i1 %63, i64 %62, i64 %polly.indvar34
  %65 = sub i64 %54, 20
  %66 = add i64 %65, 1
  %67 = icmp slt i64 %54, 0
  %68 = select i1 %67, i64 %66, i64 %54
  %69 = sdiv i64 %68, 20
  %70 = add i64 %polly.indvar34, 31
  %71 = icmp slt i64 %69, %70
  %72 = select i1 %71, i64 %69, i64 %70
  %73 = icmp slt i64 %72, %1
  %74 = select i1 %73, i64 %72, i64 %1
  %polly.loop_guard51 = icmp sle i64 %64, %74
  br i1 %polly.loop_guard51, label %polly.loop_header48, label %polly.loop_exit50

polly.loop_exit50:                                ; preds = %polly.loop_exit59, %polly.loop_header39
  %polly.indvar_next44 = add nsw i64 %polly.indvar43, 32
  %polly.adjust_ub45 = sub i64 %53, 32
  %polly.loop_cond46 = icmp sle i64 %polly.indvar43, %polly.adjust_ub45
  br i1 %polly.loop_cond46, label %polly.loop_header39, label %polly.loop_exit41

polly.loop_header48:                              ; preds = %polly.loop_header39, %polly.loop_exit59
  %polly.indvar52 = phi i64 [ %polly.indvar_next53, %polly.loop_exit59 ], [ %64, %polly.loop_header39 ]
  %75 = mul i64 -20, %polly.indvar52
  %76 = add i64 %75, %55
  %77 = add i64 %76, 1
  %78 = icmp sgt i64 %polly.indvar43, %77
  %79 = select i1 %78, i64 %polly.indvar43, i64 %77
  %80 = add i64 %polly.indvar43, 31
  %81 = icmp slt i64 %75, %80
  %82 = select i1 %81, i64 %75, i64 %80
  %polly.loop_guard60 = icmp sle i64 %79, %82
  br i1 %polly.loop_guard60, label %polly.loop_header57, label %polly.loop_exit59

polly.loop_exit59:                                ; preds = %polly.loop_header57, %polly.loop_header48
  %polly.indvar_next53 = add nsw i64 %polly.indvar52, 1
  %polly.adjust_ub54 = sub i64 %74, 1
  %polly.loop_cond55 = icmp sle i64 %polly.indvar52, %polly.adjust_ub54
  br i1 %polly.loop_cond55, label %polly.loop_header48, label %polly.loop_exit50

polly.loop_header57:                              ; preds = %polly.loop_header48, %polly.loop_header57
  %polly.indvar61 = phi i64 [ %polly.indvar_next62, %polly.loop_header57 ], [ %79, %polly.loop_header48 ]
  %83 = mul i64 -1, %polly.indvar61
  %84 = add i64 %75, %83
  %p_.moved.to.23 = add i64 %0, %polly.indvar
  %p_.moved.to.24 = add i64 %p_.moved.to.23, %polly.indvar52
  %p_.moved.to.25 = sitofp i32 %n to double
  %p_ = mul i64 %84, -1
  %p_65 = add i64 %p_.moved.to.24, %p_
  %p_66 = trunc i64 %p_65 to i32
  %p_scevgep = getelementptr [120 x [120 x double]]* %B, i64 %polly.indvar, i64 %polly.indvar52, i64 %84
  %p_scevgep12 = getelementptr [120 x [120 x double]]* %A, i64 %polly.indvar, i64 %polly.indvar52, i64 %84
  %p_67 = sitofp i32 %p_66 to double
  %p_68 = fmul double %p_67, 1.000000e+01
  %p_69 = fdiv double %p_68, %p_.moved.to.25
  store double %p_69, double* %p_scevgep
  store double %p_69, double* %p_scevgep12
  %p_indvar.next = add i64 %84, 1
  %polly.indvar_next62 = add nsw i64 %polly.indvar61, 1
  %polly.adjust_ub63 = sub i64 %82, 1
  %polly.loop_cond64 = icmp sle i64 %polly.indvar61, %polly.adjust_ub63
  br i1 %polly.loop_cond64, label %polly.loop_header57, label %polly.loop_exit59
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_heat_3d(i32 %tsteps, i32 %n, [120 x [120 x double]]* %A, [120 x [120 x double]]* %B) #0 {
.split:
  %0 = add i32 %n, -3
  %1 = zext i32 %0 to i64
  %2 = add i64 %1, 1
  %3 = add nsw i32 %n, -1
  %4 = icmp sgt i32 %3, 1
  %scevgep87 = getelementptr [120 x [120 x double]]* %A, i64 1, i64 1, i64 2
  %scevgep88 = getelementptr [120 x [120 x double]]* %A, i64 1, i64 1, i64 0
  %5 = icmp ult double* %scevgep88, %scevgep87
  %umin = select i1 %5, double* %scevgep88, double* %scevgep87
  %scevgep89 = getelementptr [120 x [120 x double]]* %A, i64 0, i64 1, i64 1
  %6 = icmp ult double* %scevgep89, %umin
  %umin90 = select i1 %6, double* %scevgep89, double* %umin
  %scevgep91 = getelementptr [120 x [120 x double]]* %A, i64 1, i64 2, i64 1
  %7 = icmp ult double* %scevgep91, %umin90
  %umin92 = select i1 %7, double* %scevgep91, double* %umin90
  %scevgep93 = getelementptr [120 x [120 x double]]* %A, i64 1, i64 0, i64 1
  %8 = icmp ult double* %scevgep93, %umin92
  %umin94 = select i1 %8, double* %scevgep93, double* %umin92
  %scevgep95 = getelementptr [120 x [120 x double]]* %A, i64 2, i64 1, i64 1
  %9 = icmp ult double* %scevgep95, %umin94
  %umin96 = select i1 %9, double* %scevgep95, double* %umin94
  %scevgep97 = getelementptr [120 x [120 x double]]* %A, i64 1, i64 1, i64 1
  %10 = icmp ult double* %scevgep97, %umin96
  %umin98 = select i1 %10, double* %scevgep97, double* %umin96
  %umin99155 = bitcast double* %umin98 to i8*
  %scevgep100101 = ptrtoint double* %scevgep87 to i64
  %11 = mul i64 115200, %1
  %12 = add i64 %scevgep100101, %11
  %13 = mul i64 960, %1
  %14 = add i64 %12, %13
  %15 = mul i64 8, %1
  %16 = add i64 %14, %15
  %scevgep102103 = ptrtoint double* %scevgep88 to i64
  %17 = add i64 %scevgep102103, %11
  %18 = add i64 %17, %13
  %19 = add i64 %18, %15
  %20 = icmp ugt i64 %19, %16
  %umax = select i1 %20, i64 %19, i64 %16
  %scevgep104105 = ptrtoint double* %scevgep89 to i64
  %21 = add i64 %scevgep104105, %11
  %22 = add i64 %21, %13
  %23 = add i64 %22, %15
  %24 = icmp ugt i64 %23, %umax
  %umax106 = select i1 %24, i64 %23, i64 %umax
  %scevgep107108 = ptrtoint double* %scevgep91 to i64
  %25 = add i64 %scevgep107108, %11
  %26 = add i64 %25, %13
  %27 = add i64 %26, %15
  %28 = icmp ugt i64 %27, %umax106
  %umax109 = select i1 %28, i64 %27, i64 %umax106
  %scevgep110111 = ptrtoint double* %scevgep93 to i64
  %29 = add i64 %scevgep110111, %11
  %30 = add i64 %29, %13
  %31 = add i64 %30, %15
  %32 = icmp ugt i64 %31, %umax109
  %umax112 = select i1 %32, i64 %31, i64 %umax109
  %scevgep113114 = ptrtoint double* %scevgep95 to i64
  %33 = add i64 %scevgep113114, %11
  %34 = add i64 %33, %13
  %35 = add i64 %34, %15
  %36 = icmp ugt i64 %35, %umax112
  %umax115 = select i1 %36, i64 %35, i64 %umax112
  %scevgep116117 = ptrtoint double* %scevgep97 to i64
  %37 = add i64 %scevgep116117, %11
  %38 = add i64 %37, %13
  %39 = add i64 %38, %15
  %40 = icmp ugt i64 %39, %umax115
  %umax118 = select i1 %40, i64 %39, i64 %umax115
  %umax119156 = inttoptr i64 %umax118 to i8*
  %scevgep120 = getelementptr [120 x [120 x double]]* %B, i64 0, i64 1, i64 1
  %scevgep121 = getelementptr [120 x [120 x double]]* %B, i64 1, i64 2, i64 1
  %41 = icmp ult double* %scevgep121, %scevgep120
  %umin122 = select i1 %41, double* %scevgep121, double* %scevgep120
  %scevgep123 = getelementptr [120 x [120 x double]]* %B, i64 1, i64 0, i64 1
  %42 = icmp ult double* %scevgep123, %umin122
  %umin124 = select i1 %42, double* %scevgep123, double* %umin122
  %scevgep125 = getelementptr [120 x [120 x double]]* %B, i64 1, i64 1, i64 2
  %43 = icmp ult double* %scevgep125, %umin124
  %umin126 = select i1 %43, double* %scevgep125, double* %umin124
  %scevgep127 = getelementptr [120 x [120 x double]]* %B, i64 1, i64 1, i64 1
  %44 = icmp ult double* %scevgep127, %umin126
  %umin128 = select i1 %44, double* %scevgep127, double* %umin126
  %scevgep129 = getelementptr [120 x [120 x double]]* %B, i64 2, i64 1, i64 1
  %45 = icmp ult double* %scevgep129, %umin128
  %umin130 = select i1 %45, double* %scevgep129, double* %umin128
  %46 = icmp ult double* %scevgep127, %umin130
  %umin131 = select i1 %46, double* %scevgep127, double* %umin130
  %scevgep132 = getelementptr [120 x [120 x double]]* %B, i64 1, i64 1, i64 0
  %47 = icmp ult double* %scevgep132, %umin131
  %umin133 = select i1 %47, double* %scevgep132, double* %umin131
  %umin133157 = bitcast double* %umin133 to i8*
  %scevgep134135 = ptrtoint double* %scevgep120 to i64
  %48 = add i64 %scevgep134135, %11
  %49 = add i64 %48, %13
  %50 = add i64 %49, %15
  %scevgep136137 = ptrtoint double* %scevgep121 to i64
  %51 = add i64 %scevgep136137, %11
  %52 = add i64 %51, %13
  %53 = add i64 %52, %15
  %54 = icmp ugt i64 %53, %50
  %umax138 = select i1 %54, i64 %53, i64 %50
  %scevgep139140 = ptrtoint double* %scevgep123 to i64
  %55 = add i64 %scevgep139140, %11
  %56 = add i64 %55, %13
  %57 = add i64 %56, %15
  %58 = icmp ugt i64 %57, %umax138
  %umax141 = select i1 %58, i64 %57, i64 %umax138
  %scevgep142143 = ptrtoint double* %scevgep125 to i64
  %59 = add i64 %scevgep142143, %11
  %60 = add i64 %59, %13
  %61 = add i64 %60, %15
  %62 = icmp ugt i64 %61, %umax141
  %umax144 = select i1 %62, i64 %61, i64 %umax141
  %scevgep145146 = ptrtoint double* %scevgep127 to i64
  %63 = add i64 %scevgep145146, %11
  %64 = add i64 %63, %13
  %65 = add i64 %64, %15
  %66 = icmp ugt i64 %65, %umax144
  %umax147 = select i1 %66, i64 %65, i64 %umax144
  %scevgep148149 = ptrtoint double* %scevgep129 to i64
  %67 = add i64 %scevgep148149, %11
  %68 = add i64 %67, %13
  %69 = add i64 %68, %15
  %70 = icmp ugt i64 %69, %umax147
  %umax150 = select i1 %70, i64 %69, i64 %umax147
  %71 = icmp ugt i64 %65, %umax150
  %umax151 = select i1 %71, i64 %65, i64 %umax150
  %scevgep152153 = ptrtoint double* %scevgep132 to i64
  %72 = add i64 %scevgep152153, %11
  %73 = add i64 %72, %13
  %74 = add i64 %73, %15
  %75 = icmp ugt i64 %74, %umax151
  %umax154 = select i1 %75, i64 %74, i64 %umax151
  %umax154158 = inttoptr i64 %umax154 to i8*
  %76 = icmp ult i8* %umax119156, %umin133157
  %77 = icmp ult i8* %umax154158, %umin99155
  %pair-no-alias = or i1 %76, %77
  br i1 %pair-no-alias, label %polly.start, label %.preheader5.clone

.preheader5.clone:                                ; preds = %.split, %._crit_edge20.clone
  %indvar84.clone = phi i32 [ 0, %.split ], [ %indvar.next85.clone, %._crit_edge20.clone ]
  br i1 %4, label %.preheader3.clone, label %.preheader4.clone

.preheader3.clone:                                ; preds = %.preheader5.clone, %._crit_edge9.clone
  %indvar22.clone = phi i64 [ %79, %._crit_edge9.clone ], [ 0, %.preheader5.clone ]
  %78 = add i64 %indvar22.clone, 2
  %79 = add i64 %indvar22.clone, 1
  br i1 %4, label %.preheader1.clone, label %._crit_edge9.clone

.preheader1.clone:                                ; preds = %.preheader3.clone, %._crit_edge.clone
  %indvar24.clone = phi i64 [ %80, %._crit_edge.clone ], [ 0, %.preheader3.clone ]
  %80 = add i64 %indvar24.clone, 1
  %81 = add i64 %indvar24.clone, 2
  br i1 %4, label %.lr.ph.clone, label %._crit_edge.clone

.lr.ph.clone:                                     ; preds = %.preheader1.clone, %.lr.ph.clone
  %indvar.clone = phi i64 [ %82, %.lr.ph.clone ], [ 0, %.preheader1.clone ]
  %82 = add i64 %indvar.clone, 1
  %scevgep.clone = getelementptr [120 x [120 x double]]* %A, i64 %78, i64 %80, i64 %82
  %scevgep27.clone = getelementptr [120 x [120 x double]]* %A, i64 %indvar22.clone, i64 %80, i64 %82
  %scevgep26.clone = getelementptr [120 x [120 x double]]* %A, i64 %79, i64 %80, i64 %82
  %83 = add i64 %indvar.clone, 2
  %scevgep30.clone = getelementptr [120 x [120 x double]]* %A, i64 %79, i64 %80, i64 %83
  %scevgep31.clone = getelementptr [120 x [120 x double]]* %B, i64 %79, i64 %80, i64 %82
  %scevgep32.clone = getelementptr [120 x [120 x double]]* %A, i64 %79, i64 %80, i64 %indvar.clone
  %scevgep28.clone = getelementptr [120 x [120 x double]]* %A, i64 %79, i64 %81, i64 %82
  %scevgep29.clone = getelementptr [120 x [120 x double]]* %A, i64 %79, i64 %indvar24.clone, i64 %82
  %84 = load double* %scevgep.clone, align 8, !tbaa !6
  %85 = load double* %scevgep26.clone, align 8, !tbaa !6
  %86 = fmul double %85, 2.000000e+00
  %87 = fsub double %84, %86
  %88 = load double* %scevgep27.clone, align 8, !tbaa !6
  %89 = fadd double %88, %87
  %90 = fmul double %89, 1.250000e-01
  %91 = load double* %scevgep28.clone, align 8, !tbaa !6
  %92 = fsub double %91, %86
  %93 = load double* %scevgep29.clone, align 8, !tbaa !6
  %94 = fadd double %93, %92
  %95 = fmul double %94, 1.250000e-01
  %96 = fadd double %90, %95
  %97 = load double* %scevgep30.clone, align 8, !tbaa !6
  %98 = fsub double %97, %86
  %99 = load double* %scevgep32.clone, align 8, !tbaa !6
  %100 = fadd double %99, %98
  %101 = fmul double %100, 1.250000e-01
  %102 = fadd double %96, %101
  %103 = fadd double %85, %102
  store double %103, double* %scevgep31.clone, align 8, !tbaa !6
  %exitcond.clone = icmp ne i64 %82, %2
  br i1 %exitcond.clone, label %.lr.ph.clone, label %._crit_edge.clone

._crit_edge.clone:                                ; preds = %.lr.ph.clone, %.preheader1.clone
  %exitcond33.clone = icmp ne i64 %80, %2
  br i1 %exitcond33.clone, label %.preheader1.clone, label %._crit_edge9.clone

._crit_edge9.clone:                               ; preds = %._crit_edge.clone, %.preheader3.clone
  %exitcond42.clone = icmp ne i64 %79, %2
  br i1 %exitcond42.clone, label %.preheader3.clone, label %.preheader4.clone

.preheader4.clone:                                ; preds = %._crit_edge9.clone, %.preheader5.clone
  br i1 %4, label %.preheader2.clone, label %._crit_edge20.clone

.preheader2.clone:                                ; preds = %.preheader4.clone, %._crit_edge17.clone
  %indvar54.clone = phi i64 [ %105, %._crit_edge17.clone ], [ 0, %.preheader4.clone ]
  %104 = add i64 %indvar54.clone, 2
  %105 = add i64 %indvar54.clone, 1
  br i1 %4, label %.preheader.clone, label %._crit_edge17.clone

.preheader.clone:                                 ; preds = %.preheader2.clone, %._crit_edge14.clone
  %indvar56.clone = phi i64 [ %106, %._crit_edge14.clone ], [ 0, %.preheader2.clone ]
  %106 = add i64 %indvar56.clone, 1
  %107 = add i64 %indvar56.clone, 2
  br i1 %4, label %.lr.ph13.clone, label %._crit_edge14.clone

.lr.ph13.clone:                                   ; preds = %.preheader.clone, %.lr.ph13.clone
  %indvar51.clone = phi i64 [ %108, %.lr.ph13.clone ], [ 0, %.preheader.clone ]
  %108 = add i64 %indvar51.clone, 1
  %scevgep58.clone = getelementptr [120 x [120 x double]]* %B, i64 %104, i64 %106, i64 %108
  %scevgep60.clone = getelementptr [120 x [120 x double]]* %B, i64 %indvar54.clone, i64 %106, i64 %108
  %scevgep59.clone = getelementptr [120 x [120 x double]]* %B, i64 %105, i64 %106, i64 %108
  %109 = add i64 %indvar51.clone, 2
  %scevgep63.clone = getelementptr [120 x [120 x double]]* %B, i64 %105, i64 %106, i64 %109
  %scevgep64.clone = getelementptr [120 x [120 x double]]* %A, i64 %105, i64 %106, i64 %108
  %scevgep65.clone = getelementptr [120 x [120 x double]]* %B, i64 %105, i64 %106, i64 %indvar51.clone
  %scevgep61.clone = getelementptr [120 x [120 x double]]* %B, i64 %105, i64 %107, i64 %108
  %scevgep62.clone = getelementptr [120 x [120 x double]]* %B, i64 %105, i64 %indvar56.clone, i64 %108
  %110 = load double* %scevgep58.clone, align 8, !tbaa !6
  %111 = load double* %scevgep59.clone, align 8, !tbaa !6
  %112 = fmul double %111, 2.000000e+00
  %113 = fsub double %110, %112
  %114 = load double* %scevgep60.clone, align 8, !tbaa !6
  %115 = fadd double %114, %113
  %116 = fmul double %115, 1.250000e-01
  %117 = load double* %scevgep61.clone, align 8, !tbaa !6
  %118 = fsub double %117, %112
  %119 = load double* %scevgep62.clone, align 8, !tbaa !6
  %120 = fadd double %119, %118
  %121 = fmul double %120, 1.250000e-01
  %122 = fadd double %116, %121
  %123 = load double* %scevgep63.clone, align 8, !tbaa !6
  %124 = fsub double %123, %112
  %125 = load double* %scevgep65.clone, align 8, !tbaa !6
  %126 = fadd double %125, %124
  %127 = fmul double %126, 1.250000e-01
  %128 = fadd double %122, %127
  %129 = fadd double %111, %128
  store double %129, double* %scevgep64.clone, align 8, !tbaa !6
  %exitcond53.clone = icmp ne i64 %108, %2
  br i1 %exitcond53.clone, label %.lr.ph13.clone, label %._crit_edge14.clone

._crit_edge14.clone:                              ; preds = %.lr.ph13.clone, %.preheader.clone
  %exitcond66.clone = icmp ne i64 %106, %2
  br i1 %exitcond66.clone, label %.preheader.clone, label %._crit_edge17.clone

._crit_edge17.clone:                              ; preds = %._crit_edge14.clone, %.preheader2.clone
  %exitcond75.clone = icmp ne i64 %105, %2
  br i1 %exitcond75.clone, label %.preheader2.clone, label %._crit_edge20.clone

._crit_edge20.clone:                              ; preds = %._crit_edge17.clone, %.preheader4.clone
  %indvar.next85.clone = add i32 %indvar84.clone, 1
  %exitcond86.clone = icmp ne i32 %indvar.next85.clone, 500
  br i1 %exitcond86.clone, label %.preheader5.clone, label %polly.merge

polly.merge:                                      ; preds = %polly.loop_exit220, %polly.start, %._crit_edge20.clone
  ret void

polly.start:                                      ; preds = %.split
  %130 = sext i32 %n to i64
  %131 = icmp sge i64 %130, 3
  br i1 %131, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.start, %polly.loop_exit220
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit220 ], [ 0, %polly.start ]
  br i1 true, label %polly.loop_header168, label %polly.loop_exit170

polly.loop_exit170:                               ; preds = %polly.loop_exit177, %polly.loop_header
  br i1 true, label %polly.loop_header218, label %polly.loop_exit220

polly.loop_exit220:                               ; preds = %polly.loop_exit229, %polly.loop_exit170
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, 498
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header168:                             ; preds = %polly.loop_header, %polly.loop_exit177
  %polly.indvar171 = phi i64 [ %polly.indvar_next172, %polly.loop_exit177 ], [ 0, %polly.loop_header ]
  br i1 true, label %polly.loop_header175, label %polly.loop_exit177

polly.loop_exit177:                               ; preds = %polly.loop_exit186, %polly.loop_header168
  %polly.indvar_next172 = add nsw i64 %polly.indvar171, 1
  %polly.adjust_ub = sub i64 %1, 1
  %polly.loop_cond173 = icmp sle i64 %polly.indvar171, %polly.adjust_ub
  br i1 %polly.loop_cond173, label %polly.loop_header168, label %polly.loop_exit170

polly.loop_header175:                             ; preds = %polly.loop_header168, %polly.loop_exit186
  %polly.indvar179 = phi i64 [ %polly.indvar_next180, %polly.loop_exit186 ], [ 0, %polly.loop_header168 ]
  br i1 true, label %polly.loop_header184, label %polly.loop_exit186

polly.loop_exit186:                               ; preds = %polly.loop_header184, %polly.loop_header175
  %polly.indvar_next180 = add nsw i64 %polly.indvar179, 1
  %polly.adjust_ub181 = sub i64 %1, 1
  %polly.loop_cond182 = icmp sle i64 %polly.indvar179, %polly.adjust_ub181
  br i1 %polly.loop_cond182, label %polly.loop_header175, label %polly.loop_exit177

polly.loop_header184:                             ; preds = %polly.loop_header175, %polly.loop_header184
  %polly.indvar188 = phi i64 [ %polly.indvar_next189, %polly.loop_header184 ], [ 0, %polly.loop_header175 ]
  %p_.moved.to. = add i64 %polly.indvar171, 2
  %p_.moved.to.159 = add i64 %polly.indvar179, 1
  %p_.moved.to.160 = add i64 %polly.indvar171, 1
  %p_.moved.to.161 = add i64 %polly.indvar179, 2
  %p_ = add i64 %polly.indvar188, 1
  %p_scevgep = getelementptr [120 x [120 x double]]* %A, i64 %p_.moved.to., i64 %p_.moved.to.159, i64 %p_
  %p_scevgep27 = getelementptr [120 x [120 x double]]* %A, i64 %polly.indvar171, i64 %p_.moved.to.159, i64 %p_
  %p_scevgep26 = getelementptr [120 x [120 x double]]* %A, i64 %p_.moved.to.160, i64 %p_.moved.to.159, i64 %p_
  %p_192 = add i64 %polly.indvar188, 2
  %p_scevgep30 = getelementptr [120 x [120 x double]]* %A, i64 %p_.moved.to.160, i64 %p_.moved.to.159, i64 %p_192
  %p_scevgep31 = getelementptr [120 x [120 x double]]* %B, i64 %p_.moved.to.160, i64 %p_.moved.to.159, i64 %p_
  %p_scevgep32 = getelementptr [120 x [120 x double]]* %A, i64 %p_.moved.to.160, i64 %p_.moved.to.159, i64 %polly.indvar188
  %p_scevgep28 = getelementptr [120 x [120 x double]]* %A, i64 %p_.moved.to.160, i64 %p_.moved.to.161, i64 %p_
  %p_scevgep29 = getelementptr [120 x [120 x double]]* %A, i64 %p_.moved.to.160, i64 %polly.indvar179, i64 %p_
  %_p_scalar_ = load double* %p_scevgep
  %_p_scalar_193 = load double* %p_scevgep26
  %p_194 = fmul double %_p_scalar_193, 2.000000e+00
  %p_195 = fsub double %_p_scalar_, %p_194
  %_p_scalar_196 = load double* %p_scevgep27
  %p_197 = fadd double %_p_scalar_196, %p_195
  %p_198 = fmul double %p_197, 1.250000e-01
  %_p_scalar_199 = load double* %p_scevgep28
  %p_202 = fsub double %_p_scalar_199, %p_194
  %_p_scalar_203 = load double* %p_scevgep29
  %p_204 = fadd double %_p_scalar_203, %p_202
  %p_205 = fmul double %p_204, 1.250000e-01
  %p_206 = fadd double %p_198, %p_205
  %_p_scalar_207 = load double* %p_scevgep30
  %p_210 = fsub double %_p_scalar_207, %p_194
  %_p_scalar_211 = load double* %p_scevgep32
  %p_212 = fadd double %_p_scalar_211, %p_210
  %p_213 = fmul double %p_212, 1.250000e-01
  %p_214 = fadd double %p_206, %p_213
  %p_216 = fadd double %_p_scalar_193, %p_214
  store double %p_216, double* %p_scevgep31
  %polly.indvar_next189 = add nsw i64 %polly.indvar188, 1
  %polly.adjust_ub190 = sub i64 %1, 1
  %polly.loop_cond191 = icmp sle i64 %polly.indvar188, %polly.adjust_ub190
  br i1 %polly.loop_cond191, label %polly.loop_header184, label %polly.loop_exit186

polly.loop_header218:                             ; preds = %polly.loop_exit170, %polly.loop_exit229
  %polly.indvar222 = phi i64 [ %polly.indvar_next223, %polly.loop_exit229 ], [ 0, %polly.loop_exit170 ]
  br i1 true, label %polly.loop_header227, label %polly.loop_exit229

polly.loop_exit229:                               ; preds = %polly.loop_exit238, %polly.loop_header218
  %polly.indvar_next223 = add nsw i64 %polly.indvar222, 1
  %polly.adjust_ub224 = sub i64 %1, 1
  %polly.loop_cond225 = icmp sle i64 %polly.indvar222, %polly.adjust_ub224
  br i1 %polly.loop_cond225, label %polly.loop_header218, label %polly.loop_exit220

polly.loop_header227:                             ; preds = %polly.loop_header218, %polly.loop_exit238
  %polly.indvar231 = phi i64 [ %polly.indvar_next232, %polly.loop_exit238 ], [ 0, %polly.loop_header218 ]
  br i1 true, label %polly.loop_header236, label %polly.loop_exit238

polly.loop_exit238:                               ; preds = %polly.loop_header236, %polly.loop_header227
  %polly.indvar_next232 = add nsw i64 %polly.indvar231, 1
  %polly.adjust_ub233 = sub i64 %1, 1
  %polly.loop_cond234 = icmp sle i64 %polly.indvar231, %polly.adjust_ub233
  br i1 %polly.loop_cond234, label %polly.loop_header227, label %polly.loop_exit229

polly.loop_header236:                             ; preds = %polly.loop_header227, %polly.loop_header236
  %polly.indvar240 = phi i64 [ %polly.indvar_next241, %polly.loop_header236 ], [ 0, %polly.loop_header227 ]
  %p_.moved.to.162 = add i64 %polly.indvar222, 2
  %p_.moved.to.163 = add i64 %polly.indvar231, 1
  %p_.moved.to.164 = add i64 %polly.indvar222, 1
  %p_.moved.to.165 = add i64 %polly.indvar231, 2
  %p_245 = add i64 %polly.indvar240, 1
  %p_scevgep58 = getelementptr [120 x [120 x double]]* %B, i64 %p_.moved.to.162, i64 %p_.moved.to.163, i64 %p_245
  %p_scevgep60 = getelementptr [120 x [120 x double]]* %B, i64 %polly.indvar222, i64 %p_.moved.to.163, i64 %p_245
  %p_scevgep59 = getelementptr [120 x [120 x double]]* %B, i64 %p_.moved.to.164, i64 %p_.moved.to.163, i64 %p_245
  %p_246 = add i64 %polly.indvar240, 2
  %p_scevgep63 = getelementptr [120 x [120 x double]]* %B, i64 %p_.moved.to.164, i64 %p_.moved.to.163, i64 %p_246
  %p_scevgep64 = getelementptr [120 x [120 x double]]* %A, i64 %p_.moved.to.164, i64 %p_.moved.to.163, i64 %p_245
  %p_scevgep65 = getelementptr [120 x [120 x double]]* %B, i64 %p_.moved.to.164, i64 %p_.moved.to.163, i64 %polly.indvar240
  %p_scevgep61 = getelementptr [120 x [120 x double]]* %B, i64 %p_.moved.to.164, i64 %p_.moved.to.165, i64 %p_245
  %p_scevgep62 = getelementptr [120 x [120 x double]]* %B, i64 %p_.moved.to.164, i64 %polly.indvar231, i64 %p_245
  %_p_scalar_247 = load double* %p_scevgep58
  %_p_scalar_248 = load double* %p_scevgep59
  %p_249 = fmul double %_p_scalar_248, 2.000000e+00
  %p_250 = fsub double %_p_scalar_247, %p_249
  %_p_scalar_251 = load double* %p_scevgep60
  %p_252 = fadd double %_p_scalar_251, %p_250
  %p_253 = fmul double %p_252, 1.250000e-01
  %_p_scalar_254 = load double* %p_scevgep61
  %p_257 = fsub double %_p_scalar_254, %p_249
  %_p_scalar_258 = load double* %p_scevgep62
  %p_259 = fadd double %_p_scalar_258, %p_257
  %p_260 = fmul double %p_259, 1.250000e-01
  %p_261 = fadd double %p_253, %p_260
  %_p_scalar_262 = load double* %p_scevgep63
  %p_265 = fsub double %_p_scalar_262, %p_249
  %_p_scalar_266 = load double* %p_scevgep65
  %p_267 = fadd double %_p_scalar_266, %p_265
  %p_268 = fmul double %p_267, 1.250000e-01
  %p_269 = fadd double %p_261, %p_268
  %p_271 = fadd double %_p_scalar_248, %p_269
  store double %p_271, double* %p_scevgep64
  %polly.indvar_next241 = add nsw i64 %polly.indvar240, 1
  %polly.adjust_ub242 = sub i64 %1, 1
  %polly.loop_cond243 = icmp sle i64 %polly.indvar240, %polly.adjust_ub242
  br i1 %polly.loop_cond243, label %polly.loop_header236, label %polly.loop_exit238
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, [120 x [120 x double]]* %A) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %n, 0
  br i1 %5, label %.preheader1.lr.ph, label %29

.preheader1.lr.ph:                                ; preds = %.split
  %6 = zext i32 %n to i64
  %7 = mul i32 %n, %n
  %8 = zext i32 %n to i64
  %9 = zext i32 %n to i64
  %10 = zext i32 %7 to i64
  %11 = icmp sgt i32 %n, 0
  %12 = icmp sgt i32 %n, 0
  br label %.preheader1

.preheader1:                                      ; preds = %.preheader1.lr.ph, %28
  %indvar8 = phi i64 [ 0, %.preheader1.lr.ph ], [ %indvar.next9, %28 ]
  %13 = mul i64 %10, %indvar8
  br i1 %11, label %.preheader.lr.ph, label %28

.preheader.lr.ph:                                 ; preds = %.preheader1
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %27
  %indvar10 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next11, %27 ]
  %14 = mul i64 %9, %indvar10
  %15 = add i64 %13, %14
  br i1 %12, label %.lr.ph, label %27

.lr.ph:                                           ; preds = %.preheader
  br label %16

; <label>:16                                      ; preds = %.lr.ph, %23
  %indvar = phi i64 [ 0, %.lr.ph ], [ %indvar.next, %23 ]
  %scevgep = getelementptr [120 x [120 x double]]* %A, i64 %indvar8, i64 %indvar10, i64 %indvar
  %17 = add i64 %15, %indvar
  %18 = trunc i64 %17 to i32
  %19 = srem i32 %18, 20
  %20 = icmp eq i32 %19, 0
  br i1 %20, label %21, label %23

; <label>:21                                      ; preds = %16
  %22 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %22) #4
  br label %23

; <label>:23                                      ; preds = %21, %16
  %24 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %25 = load double* %scevgep, align 8, !tbaa !6
  %26 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %24, i8* getelementptr inbounds ([8 x i8]* @.str5, i64 0, i64 0), double %25) #5
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %6
  br i1 %exitcond, label %16, label %._crit_edge

._crit_edge:                                      ; preds = %23
  br label %27

; <label>:27                                      ; preds = %._crit_edge, %.preheader
  %indvar.next11 = add i64 %indvar10, 1
  %exitcond12 = icmp ne i64 %indvar.next11, %8
  br i1 %exitcond12, label %.preheader, label %._crit_edge5

._crit_edge5:                                     ; preds = %27
  br label %28

; <label>:28                                      ; preds = %._crit_edge5, %.preheader1
  %indvar.next9 = add i64 %indvar8, 1
  %exitcond14 = icmp ne i64 %indvar.next9, %9
  br i1 %exitcond14, label %.preheader1, label %._crit_edge7

._crit_edge7:                                     ; preds = %28
  br label %29

; <label>:29                                      ; preds = %._crit_edge7, %.split
  %30 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %31 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %30, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %32 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %33 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str7, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %32) #4
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
