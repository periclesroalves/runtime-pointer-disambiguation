; ModuleID = './datamining/correlation/correlation.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [5 x i8] c"corr\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %float_n = alloca double, align 8
  %0 = tail call i8* @polybench_alloc_data(i64 1680000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 1440000, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 1200, i32 8) #3
  %3 = tail call i8* @polybench_alloc_data(i64 1200, i32 8) #3
  %4 = bitcast i8* %0 to [1200 x double]*
  call void @init_array(i32 1200, i32 1400, double* %float_n, [1200 x double]* %4)
  call void (...)* @polybench_timer_start() #3
  %5 = load double* %float_n, align 8, !tbaa !1
  %6 = bitcast i8* %1 to [1200 x double]*
  %7 = bitcast i8* %2 to double*
  %8 = bitcast i8* %3 to double*
  call void @kernel_correlation(i32 1200, i32 1400, double %5, [1200 x double]* %4, [1200 x double]* %6, double* %7, double* %8)
  call void (...)* @polybench_timer_stop() #3
  call void (...)* @polybench_timer_print() #3
  %9 = icmp sgt i32 %argc, 42
  br i1 %9, label %10, label %14

; <label>:10                                      ; preds = %.split
  %11 = load i8** %argv, align 8, !tbaa !5
  %12 = load i8* %11, align 1, !tbaa !7
  %phitmp = icmp eq i8 %12, 0
  br i1 %phitmp, label %13, label %14

; <label>:13                                      ; preds = %10
  call void @print_array(i32 1200, [1200 x double]* %6)
  br label %14

; <label>:14                                      ; preds = %10, %13, %.split
  call void @free(i8* %0) #3
  call void @free(i8* %1) #3
  call void @free(i8* %2) #3
  call void @free(i8* %3) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %m, i32 %n, double* %float_n, [1200 x double]* %data) #0 {
.split:
  store double 1.400000e+03, double* %float_n, align 8, !tbaa !1
  br label %polly.loop_preheader10

polly.loop_exit:                                  ; preds = %polly.loop_exit11
  ret void

polly.loop_exit11:                                ; preds = %polly.loop_exit18
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, 1367
  br i1 %polly.loop_cond, label %polly.loop_preheader10, label %polly.loop_exit

polly.loop_header9:                               ; preds = %polly.loop_exit18, %polly.loop_preheader10
  %polly.indvar12 = phi i64 [ 0, %polly.loop_preheader10 ], [ %polly.indvar_next13, %polly.loop_exit18 ]
  %0 = add i64 %polly.indvar, 31
  %1 = icmp slt i64 1399, %0
  %2 = select i1 %1, i64 1399, i64 %0
  %polly.loop_guard = icmp sle i64 %polly.indvar, %2
  br i1 %polly.loop_guard, label %polly.loop_header16, label %polly.loop_exit18

polly.loop_exit18:                                ; preds = %polly.loop_exit25, %polly.loop_header9
  %polly.indvar_next13 = add nsw i64 %polly.indvar12, 32
  %polly.loop_cond14 = icmp sle i64 %polly.indvar12, 1167
  br i1 %polly.loop_cond14, label %polly.loop_header9, label %polly.loop_exit11

polly.loop_preheader10:                           ; preds = %polly.loop_exit11, %.split
  %polly.indvar = phi i64 [ 0, %.split ], [ %polly.indvar_next, %polly.loop_exit11 ]
  br label %polly.loop_header9

polly.loop_header16:                              ; preds = %polly.loop_header9, %polly.loop_exit25
  %polly.indvar19 = phi i64 [ %polly.indvar_next20, %polly.loop_exit25 ], [ %polly.indvar, %polly.loop_header9 ]
  %3 = add i64 %polly.indvar12, 31
  %4 = icmp slt i64 1199, %3
  %5 = select i1 %4, i64 1199, i64 %3
  %polly.loop_guard26 = icmp sle i64 %polly.indvar12, %5
  br i1 %polly.loop_guard26, label %polly.loop_header23, label %polly.loop_exit25

polly.loop_exit25:                                ; preds = %polly.loop_header23, %polly.loop_header16
  %polly.indvar_next20 = add nsw i64 %polly.indvar19, 1
  %polly.adjust_ub = sub i64 %2, 1
  %polly.loop_cond21 = icmp sle i64 %polly.indvar19, %polly.adjust_ub
  br i1 %polly.loop_cond21, label %polly.loop_header16, label %polly.loop_exit18

polly.loop_header23:                              ; preds = %polly.loop_header16, %polly.loop_header23
  %polly.indvar27 = phi i64 [ %polly.indvar_next28, %polly.loop_header23 ], [ %polly.indvar12, %polly.loop_header16 ]
  %p_i.02.moved.to. = trunc i64 %polly.indvar19 to i32
  %p_.moved.to. = sitofp i32 %p_i.02.moved.to. to double
  %p_scevgep = getelementptr [1200 x double]* %data, i64 %polly.indvar19, i64 %polly.indvar27
  %p_ = mul i64 %polly.indvar19, %polly.indvar27
  %p_31 = trunc i64 %p_ to i32
  %p_32 = sitofp i32 %p_31 to double
  %p_33 = fdiv double %p_32, 1.200000e+03
  %p_34 = fadd double %p_.moved.to., %p_33
  store double %p_34, double* %p_scevgep
  %p_indvar.next = add i64 %polly.indvar27, 1
  %polly.indvar_next28 = add nsw i64 %polly.indvar27, 1
  %polly.adjust_ub29 = sub i64 %5, 1
  %polly.loop_cond30 = icmp sle i64 %polly.indvar27, %polly.adjust_ub29
  br i1 %polly.loop_cond30, label %polly.loop_header23, label %polly.loop_exit25
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_correlation(i32 %m, i32 %n, double %float_n, [1200 x double]* %data, [1200 x double]* %corr, double* %mean, double* %stddev) #0 {
.split:
  %corr96 = ptrtoint [1200 x double]* %corr to i64
  %corr92 = bitcast [1200 x double]* %corr to double*
  %data76 = ptrtoint [1200 x double]* %data to i64
  %data88 = bitcast [1200 x double]* %data to double*
  %data78 = bitcast [1200 x double]* %data to i8*
  %mean79 = bitcast double* %mean to i8*
  %stddev83 = bitcast double* %stddev to i8*
  %stddev82 = ptrtoint double* %stddev to i64
  %mean77 = ptrtoint double* %mean to i64
  %0 = zext i32 %m to i64
  %1 = add i64 %0, -1
  %2 = mul i64 8, %1
  %3 = add i64 %data76, %2
  %4 = zext i32 %n to i64
  %5 = add i64 %4, -1
  %6 = mul i64 9600, %5
  %7 = add i64 %3, %6
  %8 = inttoptr i64 %7 to i8*
  %9 = add i64 %mean77, %2
  %10 = inttoptr i64 %9 to i8*
  %11 = icmp ult i8* %8, %mean79
  %12 = icmp ult i8* %10, %data78
  %pair-no-alias = or i1 %11, %12
  br i1 %pair-no-alias, label %polly.start217, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  %13 = icmp sgt i32 %m, 0
  br i1 %13, label %.lr.ph31.clone, label %.preheader3

.lr.ph31.clone:                                   ; preds = %.split.split.clone
  %14 = icmp sgt i32 %n, 0
  br label %15

; <label>:15                                      ; preds = %._crit_edge27.clone, %.lr.ph31.clone
  %indvar70.clone = phi i64 [ 0, %.lr.ph31.clone ], [ %indvar.next71.clone, %._crit_edge27.clone ]
  %scevgep75.clone = getelementptr double* %mean, i64 %indvar70.clone
  store double 0.000000e+00, double* %scevgep75.clone, align 8, !tbaa !1
  br i1 %14, label %.lr.ph26.clone, label %._crit_edge27.clone

.lr.ph26.clone:                                   ; preds = %15, %.lr.ph26.clone
  %indvar67.clone = phi i64 [ %indvar.next68.clone, %.lr.ph26.clone ], [ 0, %15 ]
  %scevgep72.clone = getelementptr [1200 x double]* %data, i64 %indvar67.clone, i64 %indvar70.clone
  %16 = load double* %scevgep72.clone, align 8, !tbaa !1
  %17 = load double* %scevgep75.clone, align 8, !tbaa !1
  %18 = fadd double %16, %17
  store double %18, double* %scevgep75.clone, align 8, !tbaa !1
  %indvar.next68.clone = add i64 %indvar67.clone, 1
  %exitcond69.clone = icmp ne i64 %indvar.next68.clone, %4
  br i1 %exitcond69.clone, label %.lr.ph26.clone, label %._crit_edge27.clone

._crit_edge27.clone:                              ; preds = %.lr.ph26.clone, %15
  %19 = load double* %scevgep75.clone, align 8, !tbaa !1
  %20 = fdiv double %19, %float_n
  store double %20, double* %scevgep75.clone, align 8, !tbaa !1
  %indvar.next71.clone = add i64 %indvar70.clone, 1
  %exitcond73.clone = icmp ne i64 %indvar.next71.clone, %0
  br i1 %exitcond73.clone, label %15, label %.preheader3

.preheader3:                                      ; preds = %polly.merge233, %polly.loop_header276, %polly.start217, %.split.split.clone, %._crit_edge27.clone
  %21 = icmp sgt i32 %m, 0
  br i1 %21, label %.lr.ph23, label %.preheader2

.lr.ph23:                                         ; preds = %.preheader3
  %22 = icmp sgt i32 %n, 0
  br label %24

.preheader2:                                      ; preds = %47, %.preheader3
  %23 = icmp sgt i32 %n, 0
  br i1 %23, label %.preheader1.lr.ph, label %.preheader

.preheader1.lr.ph:                                ; preds = %.preheader2
  br label %.preheader1

; <label>:24                                      ; preds = %.lr.ph23, %47
  %indvar60 = phi i64 [ 0, %.lr.ph23 ], [ %indvar.next61, %47 ]
  %25 = mul i64 %indvar60, 8
  %26 = add i64 %stddev82, %2
  %27 = inttoptr i64 %26 to i8*
  %28 = icmp ult i8* %8, %stddev83
  %29 = icmp ult i8* %27, %data78
  %pair-no-alias84 = or i1 %28, %29
  %30 = and i1 %pair-no-alias, %pair-no-alias84
  %31 = icmp ult i8* %10, %stddev83
  %32 = icmp ult i8* %27, %mean79
  %pair-no-alias85 = or i1 %31, %32
  %33 = and i1 %30, %pair-no-alias85
  br i1 %33, label %polly.stmt..split80, label %.split80.clone

.split80.clone:                                   ; preds = %24
  %scevgep65.clone = getelementptr double* %stddev, i64 %indvar60
  %scevgep66.clone = getelementptr double* %mean, i64 %indvar60
  store double 0.000000e+00, double* %scevgep65.clone, align 8, !tbaa !1
  br i1 %22, label %.lr.ph20.clone, label %.region.clone

.lr.ph20.clone:                                   ; preds = %.split80.clone, %.lr.ph20.clone
  %indvar57.clone = phi i64 [ %indvar.next58.clone, %.lr.ph20.clone ], [ 0, %.split80.clone ]
  %scevgep62.clone = getelementptr [1200 x double]* %data, i64 %indvar57.clone, i64 %indvar60
  %34 = load double* %scevgep62.clone, align 8, !tbaa !1
  %35 = load double* %scevgep66.clone, align 8, !tbaa !1
  %36 = fsub double %34, %35
  %37 = fmul double %36, %36
  %38 = load double* %scevgep65.clone, align 8, !tbaa !1
  %39 = fadd double %38, %37
  store double %39, double* %scevgep65.clone, align 8, !tbaa !1
  %indvar.next58.clone = add i64 %indvar57.clone, 1
  %exitcond59.clone = icmp ne i64 %indvar.next58.clone, %4
  br i1 %exitcond59.clone, label %.lr.ph20.clone, label %.region.clone

.region.clone:                                    ; preds = %.split80.clone, %.lr.ph20.clone, %polly.merge192
  %40 = phi double* [ %p_scevgep65, %polly.merge192 ], [ %scevgep65.clone, %.lr.ph20.clone ], [ %scevgep65.clone, %.split80.clone ]
  %41 = load double* %p_scevgep65, align 8, !tbaa !1
  %42 = fdiv double %41, %float_n
  store double %42, double* %p_scevgep65, align 8, !tbaa !1
  %43 = tail call double @sqrt(double %42) #3
  store double %43, double* %p_scevgep65, align 8, !tbaa !1
  %44 = fcmp ugt double %43, 1.000000e-01
  br i1 %44, label %45, label %47

; <label>:45                                      ; preds = %.region.clone
  %46 = load double* %40, align 8, !tbaa !1
  br label %47

; <label>:47                                      ; preds = %.region.clone, %45
  %.reg2mem.0 = phi double [ %46, %45 ], [ 1.000000e+00, %.region.clone ]
  store double %.reg2mem.0, double* %p_scevgep65, align 8, !tbaa !1
  %indvar.next61 = add i64 %indvar60, 1
  %exitcond63 = icmp ne i64 %indvar.next61, %0
  br i1 %exitcond63, label %24, label %.preheader2

.preheader1:                                      ; preds = %.preheader1.lr.ph, %._crit_edge16
  %indvar51 = phi i64 [ 0, %.preheader1.lr.ph ], [ %indvar.next52, %._crit_edge16 ]
  br i1 %21, label %.lr.ph15, label %._crit_edge16

.preheader:                                       ; preds = %._crit_edge16, %.preheader2
  %scevgep87 = getelementptr [1200 x double]* %data, i64 0, i64 1
  %48 = icmp ult double* %scevgep87, %data88
  %umin = select i1 %48, double* %scevgep87, double* %data88
  %umin103 = bitcast double* %umin to i8*
  %49 = add i32 %m, -1
  %50 = zext i32 %49 to i64
  %51 = add i64 %50, -1
  %52 = mul i64 8, %51
  %53 = add i64 %data76, %52
  %54 = add i64 %53, %6
  %scevgep8990 = ptrtoint double* %scevgep87 to i64
  %55 = add i64 %scevgep8990, %52
  %56 = add i32 %m, -2
  %57 = mul i32 -1, %56
  %58 = add i32 %56, %57
  %59 = zext i32 %58 to i64
  %60 = mul i64 8, %59
  %61 = add i64 %55, %60
  %62 = add i64 %61, %6
  %63 = icmp ugt i64 %62, %54
  %umax = select i1 %63, i64 %62, i64 %54
  %umax104 = inttoptr i64 %umax to i8*
  %scevgep91 = getelementptr [1200 x double]* %corr, i64 0, i64 1
  %64 = icmp ult double* %scevgep91, %corr92
  %umin93 = select i1 %64, double* %scevgep91, double* %corr92
  %scevgep94 = getelementptr [1200 x double]* %corr, i64 1, i64 0
  %65 = icmp ult double* %scevgep94, %umin93
  %umin95 = select i1 %65, double* %scevgep94, double* %umin93
  %umin95105 = bitcast double* %umin95 to i8*
  %66 = mul i64 9608, %51
  %67 = add i64 %corr96, %66
  %scevgep9798 = ptrtoint double* %scevgep91 to i64
  %68 = add i64 %scevgep9798, %66
  %69 = add i64 %68, %60
  %70 = icmp ugt i64 %69, %67
  %umax99 = select i1 %70, i64 %69, i64 %67
  %scevgep100101 = ptrtoint double* %scevgep94 to i64
  %71 = add i64 %scevgep100101, %66
  %72 = mul i64 9600, %59
  %73 = add i64 %71, %72
  %74 = icmp ugt i64 %73, %umax99
  %umax102 = select i1 %74, i64 %73, i64 %umax99
  %umax102106 = inttoptr i64 %umax102 to i8*
  %75 = icmp ult i8* %umax104, %umin95105
  %76 = icmp ult i8* %umax102106, %umin103
  %pair-no-alias107 = or i1 %75, %76
  %77 = add nsw i32 %m, -1
  %78 = icmp sgt i32 %77, 0
  br i1 %pair-no-alias107, label %.preheader.split, label %.preheader.split.clone

.preheader.split.clone:                           ; preds = %.preheader
  br i1 %78, label %.lr.ph12.clone, label %.region86.clone

.lr.ph12.clone:                                   ; preds = %.preheader.split.clone
  %79 = zext i32 %56 to i64
  br label %80

; <label>:80                                      ; preds = %._crit_edge10.clone, %.lr.ph12.clone
  %indvar32.clone = phi i64 [ 0, %.lr.ph12.clone ], [ %83, %._crit_edge10.clone ]
  %81 = mul i64 %indvar32.clone, 1201
  %82 = add i64 %81, 1
  %83 = add i64 %indvar32.clone, 1
  %j.36.clone = trunc i64 %83 to i32
  %84 = mul i64 %indvar32.clone, -1
  %85 = add i64 %79, %84
  %86 = trunc i64 %85 to i32
  %scevgep46.clone = getelementptr [1200 x double]* %corr, i64 0, i64 %81
  %87 = zext i32 %86 to i64
  %88 = add i64 %87, 1
  store double 1.000000e+00, double* %scevgep46.clone, align 8, !tbaa !1
  %89 = icmp slt i32 %j.36.clone, %m
  br i1 %89, label %.lr.ph9.clone, label %._crit_edge10.clone

.lr.ph9.clone:                                    ; preds = %80, %._crit_edge.clone
  %indvar34.clone = phi i64 [ %91, %._crit_edge.clone ], [ 0, %80 ]
  %90 = add i64 %82, %indvar34.clone
  %scevgep40.clone = getelementptr [1200 x double]* %corr, i64 0, i64 %90
  %91 = add i64 %indvar34.clone, 1
  %scevgep39.clone = getelementptr [1200 x double]* %corr, i64 %91, i64 %81
  %92 = add i64 %83, %indvar34.clone
  store double 0.000000e+00, double* %scevgep40.clone, align 8, !tbaa !1
  br i1 %23, label %.lr.ph.clone, label %._crit_edge.clone

.lr.ph.clone:                                     ; preds = %.lr.ph9.clone, %.lr.ph.clone
  %indvar.clone = phi i64 [ %indvar.next.clone, %.lr.ph.clone ], [ 0, %.lr.ph9.clone ]
  %scevgep36.clone = getelementptr [1200 x double]* %data, i64 %indvar.clone, i64 %92
  %scevgep.clone = getelementptr [1200 x double]* %data, i64 %indvar.clone, i64 %indvar32.clone
  %93 = load double* %scevgep.clone, align 8, !tbaa !1
  %94 = load double* %scevgep36.clone, align 8, !tbaa !1
  %95 = fmul double %93, %94
  %96 = load double* %scevgep40.clone, align 8, !tbaa !1
  %97 = fadd double %96, %95
  store double %97, double* %scevgep40.clone, align 8, !tbaa !1
  %indvar.next.clone = add i64 %indvar.clone, 1
  %exitcond.clone = icmp ne i64 %indvar.next.clone, %4
  br i1 %exitcond.clone, label %.lr.ph.clone, label %._crit_edge.clone

._crit_edge.clone:                                ; preds = %.lr.ph.clone, %.lr.ph9.clone
  %98 = load double* %scevgep40.clone, align 8, !tbaa !1
  store double %98, double* %scevgep39.clone, align 8, !tbaa !1
  %exitcond37.clone = icmp ne i64 %91, %88
  br i1 %exitcond37.clone, label %.lr.ph9.clone, label %._crit_edge10.clone

._crit_edge10.clone:                              ; preds = %._crit_edge.clone, %80
  %exitcond41.clone = icmp ne i64 %83, %50
  br i1 %exitcond41.clone, label %80, label %.region86.clone

.preheader.split:                                 ; preds = %.preheader
  br i1 %78, label %.lr.ph12, label %.region86.clone

.lr.ph12:                                         ; preds = %.preheader.split
  %99 = zext i32 %56 to i64
  br label %108

.lr.ph15:                                         ; preds = %.preheader1, %.lr.ph15
  %indvar47 = phi i64 [ %indvar.next48, %.lr.ph15 ], [ 0, %.preheader1 ]
  %scevgep53 = getelementptr [1200 x double]* %data, i64 %indvar51, i64 %indvar47
  %scevgep50 = getelementptr double* %mean, i64 %indvar47
  %scevgep54 = getelementptr double* %stddev, i64 %indvar47
  %100 = load double* %scevgep50, align 8, !tbaa !1
  %101 = load double* %scevgep53, align 8, !tbaa !1
  %102 = fsub double %101, %100
  store double %102, double* %scevgep53, align 8, !tbaa !1
  %103 = tail call double @sqrt(double %float_n) #3
  %104 = load double* %scevgep54, align 8, !tbaa !1
  %105 = fmul double %103, %104
  %106 = load double* %scevgep53, align 8, !tbaa !1
  %107 = fdiv double %106, %105
  store double %107, double* %scevgep53, align 8, !tbaa !1
  %indvar.next48 = add i64 %indvar47, 1
  %exitcond49 = icmp ne i64 %indvar.next48, %0
  br i1 %exitcond49, label %.lr.ph15, label %._crit_edge16

._crit_edge16:                                    ; preds = %.lr.ph15, %.preheader1
  %indvar.next52 = add i64 %indvar51, 1
  %exitcond55 = icmp ne i64 %indvar.next52, %4
  br i1 %exitcond55, label %.preheader1, label %.preheader

; <label>:108                                     ; preds = %.lr.ph12, %polly.merge
  %indvar32 = phi i64 [ 0, %.lr.ph12 ], [ %116, %polly.merge ]
  %109 = mul i64 %indvar32, -1
  %110 = add i64 %99, %109
  %111 = trunc i64 %110 to i32
  %112 = zext i32 %111 to i64
  %113 = mul i64 %indvar32, 9608
  %114 = mul i64 %indvar32, 1201
  %115 = add i64 %114, 1
  %116 = add i64 %indvar32, 1
  %j.36 = trunc i64 %116 to i32
  %scevgep46 = getelementptr [1200 x double]* %corr, i64 0, i64 %114
  %117 = add i64 %112, 1
  store double 1.000000e+00, double* %scevgep46, align 8, !tbaa !1, !alias.scope !8, !noalias !11
  %118 = icmp slt i32 %j.36, %m
  br i1 %118, label %polly.cond, label %polly.merge

polly.merge:                                      ; preds = %polly.then166, %polly.loop_header168, %polly.cond164, %polly.cond, %108
  %exitcond41 = icmp ne i64 %116, %50
  br i1 %exitcond41, label %108, label %.region86.clone

.region86.clone:                                  ; preds = %.preheader.split, %polly.merge, %.preheader.split.clone, %._crit_edge10.clone
  %119 = sext i32 %77 to i64
  %120 = getelementptr inbounds [1200 x double]* %corr, i64 %119, i64 %119
  store double 1.000000e+00, double* %120, align 8, !tbaa !1
  ret void

polly.cond:                                       ; preds = %108
  %121 = srem i64 %113, 8
  %122 = icmp eq i64 %121, 0
  br i1 %122, label %polly.cond121, label %polly.merge

polly.cond121:                                    ; preds = %polly.cond
  %123 = sext i32 %n to i64
  %124 = icmp sge i64 %123, 1
  %125 = icmp sge i64 %4, 1
  %126 = and i1 %124, %125
  br i1 %126, label %polly.then123, label %polly.cond140

polly.cond140:                                    ; preds = %polly.then123, %polly.loop_exit127, %polly.cond121
  %127 = icmp sle i64 %123, 0
  %128 = and i1 %127, %125
  br i1 %128, label %polly.then142, label %polly.cond164

polly.cond164:                                    ; preds = %polly.then142, %polly.loop_header144, %polly.cond140
  %129 = icmp sle i64 %4, 0
  br i1 %129, label %polly.then166, label %polly.merge

polly.then123:                                    ; preds = %polly.cond121
  br i1 true, label %polly.loop_header, label %polly.cond140

polly.loop_header:                                ; preds = %polly.then123, %polly.loop_exit127
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit127 ], [ 0, %polly.then123 ]
  %p_ = add i64 %115, %polly.indvar
  %p_scevgep40 = getelementptr [1200 x double]* %corr, i64 0, i64 %p_
  store double 0.000000e+00, double* %p_scevgep40
  %polly.loop_guard128 = icmp sle i64 0, %5
  br i1 %polly.loop_guard128, label %polly.loop_header125, label %polly.loop_exit127

polly.loop_exit127:                               ; preds = %polly.loop_header125, %polly.loop_header
  %p_.moved.to.112 = add i64 %polly.indvar, 1
  %p_scevgep39.moved.to. = getelementptr [1200 x double]* %corr, i64 %p_.moved.to.112, i64 %114
  %_p_scalar_139 = load double* %p_scevgep40
  store double %_p_scalar_139, double* %p_scevgep39.moved.to.
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %112, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond140

polly.loop_header125:                             ; preds = %polly.loop_header, %polly.loop_header125
  %polly.indvar129 = phi i64 [ %polly.indvar_next130, %polly.loop_header125 ], [ 0, %polly.loop_header ]
  %p_.moved.to.108 = add i64 %116, %polly.indvar
  %p_scevgep36 = getelementptr [1200 x double]* %data, i64 %polly.indvar129, i64 %p_.moved.to.108
  %p_scevgep = getelementptr [1200 x double]* %data, i64 %polly.indvar129, i64 %indvar32
  %_p_scalar_ = load double* %p_scevgep
  %_p_scalar_134 = load double* %p_scevgep36
  %p_135 = fmul double %_p_scalar_, %_p_scalar_134
  %_p_scalar_136 = load double* %p_scevgep40
  %p_137 = fadd double %_p_scalar_136, %p_135
  store double %p_137, double* %p_scevgep40
  %p_indvar.next = add i64 %polly.indvar129, 1
  %polly.indvar_next130 = add nsw i64 %polly.indvar129, 1
  %polly.adjust_ub131 = sub i64 %5, 1
  %polly.loop_cond132 = icmp sle i64 %polly.indvar129, %polly.adjust_ub131
  br i1 %polly.loop_cond132, label %polly.loop_header125, label %polly.loop_exit127

polly.then142:                                    ; preds = %polly.cond140
  br i1 true, label %polly.loop_header144, label %polly.cond164

polly.loop_header144:                             ; preds = %polly.then142, %polly.loop_header144
  %polly.indvar148 = phi i64 [ %polly.indvar_next149, %polly.loop_header144 ], [ 0, %polly.then142 ]
  %p_154 = add i64 %115, %polly.indvar148
  %p_scevgep40155 = getelementptr [1200 x double]* %corr, i64 0, i64 %p_154
  store double 0.000000e+00, double* %p_scevgep40155
  %p_.moved.to.112159 = add i64 %polly.indvar148, 1
  %p_scevgep39.moved.to.160 = getelementptr [1200 x double]* %corr, i64 %p_.moved.to.112159, i64 %114
  store double 0.000000e+00, double* %p_scevgep39.moved.to.160
  %polly.indvar_next149 = add nsw i64 %polly.indvar148, 1
  %polly.adjust_ub150 = sub i64 %112, 1
  %polly.loop_cond151 = icmp sle i64 %polly.indvar148, %polly.adjust_ub150
  br i1 %polly.loop_cond151, label %polly.loop_header144, label %polly.cond164

polly.then166:                                    ; preds = %polly.cond164
  br i1 true, label %polly.loop_header168, label %polly.merge

polly.loop_header168:                             ; preds = %polly.then166, %polly.loop_header168
  %polly.indvar172 = phi i64 [ %polly.indvar_next173, %polly.loop_header168 ], [ 0, %polly.then166 ]
  %p_178 = add i64 %115, %polly.indvar172
  %p_scevgep40179 = getelementptr [1200 x double]* %corr, i64 0, i64 %p_178
  store double 0.000000e+00, double* %p_scevgep40179
  %p_.moved.to.112183 = add i64 %polly.indvar172, 1
  %p_scevgep39.moved.to.184 = getelementptr [1200 x double]* %corr, i64 %p_.moved.to.112183, i64 %114
  store double 0.000000e+00, double* %p_scevgep39.moved.to.184
  %polly.indvar_next173 = add nsw i64 %polly.indvar172, 1
  %polly.adjust_ub174 = sub i64 %112, 1
  %polly.loop_cond175 = icmp sle i64 %polly.indvar172, %polly.adjust_ub174
  br i1 %polly.loop_cond175, label %polly.loop_header168, label %polly.merge

polly.stmt..split80:                              ; preds = %24
  %p_scevgep65 = getelementptr double* %stddev, i64 %indvar60
  store double 0.000000e+00, double* %p_scevgep65
  %130 = srem i64 %25, 8
  %131 = icmp eq i64 %130, 0
  br i1 %131, label %polly.cond194, label %polly.merge192

polly.merge192:                                   ; preds = %polly.then196, %polly.loop_header198, %polly.cond194, %polly.stmt..split80
  br label %.region.clone

polly.cond194:                                    ; preds = %polly.stmt..split80
  %132 = sext i32 %n to i64
  %133 = icmp sge i64 %132, 1
  %134 = icmp sge i64 %4, 1
  %135 = and i1 %133, %134
  br i1 %135, label %polly.then196, label %polly.merge192

polly.then196:                                    ; preds = %polly.cond194
  %polly.loop_guard201 = icmp sle i64 0, %5
  br i1 %polly.loop_guard201, label %polly.loop_header198, label %polly.merge192

polly.loop_header198:                             ; preds = %polly.then196, %polly.loop_header198
  %polly.indvar202 = phi i64 [ %polly.indvar_next203, %polly.loop_header198 ], [ 0, %polly.then196 ]
  %p_scevgep66.moved.to. = getelementptr double* %mean, i64 %indvar60
  %p_scevgep62 = getelementptr [1200 x double]* %data, i64 %polly.indvar202, i64 %indvar60
  %_p_scalar_207 = load double* %p_scevgep62
  %_p_scalar_208 = load double* %p_scevgep66.moved.to.
  %p_209 = fsub double %_p_scalar_207, %_p_scalar_208
  %p_213 = fmul double %p_209, %p_209
  %_p_scalar_214 = load double* %p_scevgep65
  %p_215 = fadd double %_p_scalar_214, %p_213
  store double %p_215, double* %p_scevgep65
  %p_indvar.next58 = add i64 %polly.indvar202, 1
  %polly.indvar_next203 = add nsw i64 %polly.indvar202, 1
  %polly.adjust_ub204 = sub i64 %5, 1
  %polly.loop_cond205 = icmp sle i64 %polly.indvar202, %polly.adjust_ub204
  br i1 %polly.loop_cond205, label %polly.loop_header198, label %polly.merge192

polly.start217:                                   ; preds = %.split
  %136 = sext i32 %m to i64
  %137 = icmp sge i64 %136, 1
  %138 = icmp sge i64 %0, 1
  %139 = and i1 %137, %138
  br i1 %139, label %polly.then221, label %.preheader3

polly.then221:                                    ; preds = %polly.start217
  %polly.loop_guard226 = icmp sle i64 0, %1
  br i1 %polly.loop_guard226, label %polly.loop_header223, label %polly.cond232

polly.cond232:                                    ; preds = %polly.then221, %polly.loop_header223
  %140 = sext i32 %n to i64
  %141 = icmp sge i64 %140, 1
  %142 = icmp sge i64 %4, 1
  %143 = and i1 %141, %142
  br i1 %143, label %polly.then234, label %polly.merge233

polly.merge233:                                   ; preds = %polly.then234, %polly.loop_exit247, %polly.cond232
  br i1 %polly.loop_guard226, label %polly.loop_header276, label %.preheader3

polly.loop_header223:                             ; preds = %polly.then221, %polly.loop_header223
  %polly.indvar227 = phi i64 [ %polly.indvar_next228, %polly.loop_header223 ], [ 0, %polly.then221 ]
  %p_scevgep75 = getelementptr double* %mean, i64 %polly.indvar227
  store double 0.000000e+00, double* %p_scevgep75
  %polly.indvar_next228 = add nsw i64 %polly.indvar227, 1
  %polly.adjust_ub229 = sub i64 %1, 1
  %polly.loop_cond230 = icmp sle i64 %polly.indvar227, %polly.adjust_ub229
  br i1 %polly.loop_cond230, label %polly.loop_header223, label %polly.cond232

polly.then234:                                    ; preds = %polly.cond232
  br i1 %polly.loop_guard226, label %polly.loop_header236, label %polly.merge233

polly.loop_header236:                             ; preds = %polly.then234, %polly.loop_exit247
  %polly.indvar240 = phi i64 [ %polly.indvar_next241, %polly.loop_exit247 ], [ 0, %polly.then234 ]
  %polly.loop_guard248 = icmp sle i64 0, %5
  br i1 %polly.loop_guard248, label %polly.loop_header245, label %polly.loop_exit247

polly.loop_exit247:                               ; preds = %polly.loop_exit256, %polly.loop_header236
  %polly.indvar_next241 = add nsw i64 %polly.indvar240, 32
  %polly.adjust_ub242 = sub i64 %1, 32
  %polly.loop_cond243 = icmp sle i64 %polly.indvar240, %polly.adjust_ub242
  br i1 %polly.loop_cond243, label %polly.loop_header236, label %polly.merge233

polly.loop_header245:                             ; preds = %polly.loop_header236, %polly.loop_exit256
  %polly.indvar249 = phi i64 [ %polly.indvar_next250, %polly.loop_exit256 ], [ 0, %polly.loop_header236 ]
  %144 = add i64 %polly.indvar240, 31
  %145 = icmp slt i64 %144, %1
  %146 = select i1 %145, i64 %144, i64 %1
  %polly.loop_guard257 = icmp sle i64 %polly.indvar240, %146
  br i1 %polly.loop_guard257, label %polly.loop_header254, label %polly.loop_exit256

polly.loop_exit256:                               ; preds = %polly.loop_exit265, %polly.loop_header245
  %polly.indvar_next250 = add nsw i64 %polly.indvar249, 32
  %polly.adjust_ub251 = sub i64 %5, 32
  %polly.loop_cond252 = icmp sle i64 %polly.indvar249, %polly.adjust_ub251
  br i1 %polly.loop_cond252, label %polly.loop_header245, label %polly.loop_exit247

polly.loop_header254:                             ; preds = %polly.loop_header245, %polly.loop_exit265
  %polly.indvar258 = phi i64 [ %polly.indvar_next259, %polly.loop_exit265 ], [ %polly.indvar240, %polly.loop_header245 ]
  %147 = add i64 %polly.indvar249, 31
  %148 = icmp slt i64 %147, %5
  %149 = select i1 %148, i64 %147, i64 %5
  %polly.loop_guard266 = icmp sle i64 %polly.indvar249, %149
  br i1 %polly.loop_guard266, label %polly.loop_header263, label %polly.loop_exit265

polly.loop_exit265:                               ; preds = %polly.loop_header263, %polly.loop_header254
  %polly.indvar_next259 = add nsw i64 %polly.indvar258, 1
  %polly.adjust_ub260 = sub i64 %146, 1
  %polly.loop_cond261 = icmp sle i64 %polly.indvar258, %polly.adjust_ub260
  br i1 %polly.loop_cond261, label %polly.loop_header254, label %polly.loop_exit256

polly.loop_header263:                             ; preds = %polly.loop_header254, %polly.loop_header263
  %polly.indvar267 = phi i64 [ %polly.indvar_next268, %polly.loop_header263 ], [ %polly.indvar249, %polly.loop_header254 ]
  %p_scevgep75.moved.to. = getelementptr double* %mean, i64 %polly.indvar258
  %p_scevgep72 = getelementptr [1200 x double]* %data, i64 %polly.indvar267, i64 %polly.indvar258
  %_p_scalar_272 = load double* %p_scevgep72
  %_p_scalar_273 = load double* %p_scevgep75.moved.to.
  %p_274 = fadd double %_p_scalar_272, %_p_scalar_273
  store double %p_274, double* %p_scevgep75.moved.to.
  %p_indvar.next68 = add i64 %polly.indvar267, 1
  %polly.indvar_next268 = add nsw i64 %polly.indvar267, 1
  %polly.adjust_ub269 = sub i64 %149, 1
  %polly.loop_cond270 = icmp sle i64 %polly.indvar267, %polly.adjust_ub269
  br i1 %polly.loop_cond270, label %polly.loop_header263, label %polly.loop_exit265

polly.loop_header276:                             ; preds = %polly.merge233, %polly.loop_header276
  %polly.indvar280 = phi i64 [ %polly.indvar_next281, %polly.loop_header276 ], [ 0, %polly.merge233 ]
  %p_scevgep75.moved.to.115 = getelementptr double* %mean, i64 %polly.indvar280
  %_p_scalar_285 = load double* %p_scevgep75.moved.to.115
  %p_286 = fdiv double %_p_scalar_285, %float_n
  store double %p_286, double* %p_scevgep75.moved.to.115
  %p_indvar.next71 = add i64 %polly.indvar280, 1
  %polly.indvar_next281 = add nsw i64 %polly.indvar280, 1
  %polly.adjust_ub282 = sub i64 %1, 1
  %polly.loop_cond283 = icmp sle i64 %polly.indvar280, %polly.adjust_ub282
  br i1 %polly.loop_cond283, label %polly.loop_header276, label %.preheader3
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %m, [1200 x double]* %corr) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([5 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %m, 0
  br i1 %5, label %.preheader.lr.ph, label %22

.preheader.lr.ph:                                 ; preds = %.split
  %6 = zext i32 %m to i64
  %7 = zext i32 %m to i64
  %8 = icmp sgt i32 %m, 0
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
  %scevgep = getelementptr [1200 x double]* %corr, i64 %indvar4, i64 %indvar
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
  %24 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([5 x i8]* @.str3, i64 0, i64 0)) #5
  %25 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %26 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str7, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %25) #4
  ret void
}

; Function Attrs: nounwind
declare void @free(i8*) #2

declare i32 @fprintf(%struct._IO_FILE*, i8*, ...) #1

; Function Attrs: nounwind
declare double @sqrt(double) #2

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
!8 = metadata !{metadata !9}
!9 = metadata !{metadata !9, metadata !10, metadata !"kernel_correlation: %corr"}
!10 = metadata !{metadata !10, metadata !"init_array"}
!11 = metadata !{metadata !12}
!12 = metadata !{metadata !12, metadata !10, metadata !"kernel_correlation: %data"}
