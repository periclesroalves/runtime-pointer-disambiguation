; ModuleID = './datamining/covariance/covariance.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [4 x i8] c"cov\00", align 1
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
  %3 = bitcast i8* %0 to [1200 x double]*
  call void @init_array(i32 1200, i32 1400, double* %float_n, [1200 x double]* %3)
  call void (...)* @polybench_timer_start() #3
  %4 = load double* %float_n, align 8, !tbaa !1
  %5 = bitcast i8* %1 to [1200 x double]*
  %6 = bitcast i8* %2 to double*
  call void @kernel_covariance(i32 1200, i32 1400, double %4, [1200 x double]* %3, [1200 x double]* %5, double* %6)
  call void (...)* @polybench_timer_stop() #3
  call void (...)* @polybench_timer_print() #3
  %7 = icmp sgt i32 %argc, 42
  br i1 %7, label %8, label %12

; <label>:8                                       ; preds = %.split
  %9 = load i8** %argv, align 8, !tbaa !5
  %10 = load i8* %9, align 1, !tbaa !7
  %phitmp = icmp eq i8 %10, 0
  br i1 %phitmp, label %11, label %12

; <label>:11                                      ; preds = %8
  call void @print_array(i32 1200, [1200 x double]* %5)
  br label %12

; <label>:12                                      ; preds = %8, %11, %.split
  call void @free(i8* %0) #3
  call void @free(i8* %1) #3
  call void @free(i8* %2) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %m, i32 %n, double* %float_n, [1200 x double]* %data) #0 {
.split:
  %0 = sitofp i32 %n to double
  store double %0, double* %float_n, align 8, !tbaa !1
  br label %polly.loop_preheader10

polly.loop_exit:                                  ; preds = %polly.loop_exit11
  ret void

polly.loop_exit11:                                ; preds = %polly.loop_exit18
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, 1367
  br i1 %polly.loop_cond, label %polly.loop_preheader10, label %polly.loop_exit

polly.loop_header9:                               ; preds = %polly.loop_exit18, %polly.loop_preheader10
  %polly.indvar12 = phi i64 [ 0, %polly.loop_preheader10 ], [ %polly.indvar_next13, %polly.loop_exit18 ]
  %1 = add i64 %polly.indvar, 31
  %2 = icmp slt i64 1399, %1
  %3 = select i1 %2, i64 1399, i64 %1
  %polly.loop_guard = icmp sle i64 %polly.indvar, %3
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
  %4 = add i64 %polly.indvar12, 31
  %5 = icmp slt i64 1199, %4
  %6 = select i1 %5, i64 1199, i64 %4
  %polly.loop_guard26 = icmp sle i64 %polly.indvar12, %6
  br i1 %polly.loop_guard26, label %polly.loop_header23, label %polly.loop_exit25

polly.loop_exit25:                                ; preds = %polly.loop_header23, %polly.loop_header16
  %polly.indvar_next20 = add nsw i64 %polly.indvar19, 1
  %polly.adjust_ub = sub i64 %3, 1
  %polly.loop_cond21 = icmp sle i64 %polly.indvar19, %polly.adjust_ub
  br i1 %polly.loop_cond21, label %polly.loop_header16, label %polly.loop_exit18

polly.loop_header23:                              ; preds = %polly.loop_header16, %polly.loop_header23
  %polly.indvar27 = phi i64 [ %polly.indvar_next28, %polly.loop_header23 ], [ %polly.indvar12, %polly.loop_header16 ]
  %p_i.02.moved.to. = trunc i64 %polly.indvar19 to i32
  %p_.moved.to. = sitofp i32 %p_i.02.moved.to. to double
  %p_scevgep = getelementptr [1200 x double]* %data, i64 %polly.indvar19, i64 %polly.indvar27
  %p_j.01 = trunc i64 %polly.indvar27 to i32
  %p_ = sitofp i32 %p_j.01 to double
  %p_31 = fmul double %p_.moved.to., %p_
  %p_32 = fdiv double %p_31, 1.200000e+03
  store double %p_32, double* %p_scevgep
  %p_indvar.next = add i64 %polly.indvar27, 1
  %polly.indvar_next28 = add nsw i64 %polly.indvar27, 1
  %polly.adjust_ub29 = sub i64 %6, 1
  %polly.loop_cond30 = icmp sle i64 %polly.indvar27, %polly.adjust_ub29
  br i1 %polly.loop_cond30, label %polly.loop_header23, label %polly.loop_exit25
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_covariance(i32 %m, i32 %n, double %float_n, [1200 x double]* %data, [1200 x double]* %cov, double* %mean) #0 {
.split:
  %cov59 = ptrtoint [1200 x double]* %cov to i64
  %data53 = ptrtoint [1200 x double]* %data to i64
  %data55 = bitcast [1200 x double]* %data to i8*
  %mean56 = bitcast double* %mean to i8*
  %mean54 = ptrtoint double* %mean to i64
  %0 = zext i32 %m to i64
  %1 = add i64 %0, -1
  %2 = mul i64 8, %1
  %3 = add i64 %data53, %2
  %4 = zext i32 %n to i64
  %5 = add i64 %4, -1
  %6 = mul i64 9600, %5
  %7 = add i64 %3, %6
  %8 = inttoptr i64 %7 to i8*
  %9 = add i64 %mean54, %2
  %10 = inttoptr i64 %9 to i8*
  %11 = icmp ult i8* %8, %mean56
  %12 = icmp ult i8* %10, %data55
  %pair-no-alias = or i1 %11, %12
  br i1 %pair-no-alias, label %polly.start407, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  %13 = icmp sgt i32 %m, 0
  br i1 %13, label %.lr.ph20.clone, label %.preheader3

.lr.ph20.clone:                                   ; preds = %.split.split.clone
  %14 = icmp sgt i32 %n, 0
  br label %15

; <label>:15                                      ; preds = %._crit_edge17.clone, %.lr.ph20.clone
  %indvar47.clone = phi i64 [ 0, %.lr.ph20.clone ], [ %indvar.next48.clone, %._crit_edge17.clone ]
  %scevgep52.clone = getelementptr double* %mean, i64 %indvar47.clone
  store double 0.000000e+00, double* %scevgep52.clone, align 8, !tbaa !1
  br i1 %14, label %.lr.ph16.clone, label %._crit_edge17.clone

.lr.ph16.clone:                                   ; preds = %15, %.lr.ph16.clone
  %indvar44.clone = phi i64 [ %indvar.next45.clone, %.lr.ph16.clone ], [ 0, %15 ]
  %scevgep49.clone = getelementptr [1200 x double]* %data, i64 %indvar44.clone, i64 %indvar47.clone
  %16 = load double* %scevgep49.clone, align 8, !tbaa !1
  %17 = load double* %scevgep52.clone, align 8, !tbaa !1
  %18 = fadd double %16, %17
  store double %18, double* %scevgep52.clone, align 8, !tbaa !1
  %indvar.next45.clone = add i64 %indvar44.clone, 1
  %exitcond46.clone = icmp ne i64 %indvar.next45.clone, %4
  br i1 %exitcond46.clone, label %.lr.ph16.clone, label %._crit_edge17.clone

._crit_edge17.clone:                              ; preds = %.lr.ph16.clone, %15
  %19 = load double* %scevgep52.clone, align 8, !tbaa !1
  %20 = fdiv double %19, %float_n
  store double %20, double* %scevgep52.clone, align 8, !tbaa !1
  %indvar.next48.clone = add i64 %indvar47.clone, 1
  %exitcond50.clone = icmp ne i64 %indvar.next48.clone, %0
  br i1 %exitcond50.clone, label %15, label %.preheader3

.preheader3:                                      ; preds = %polly.merge423, %polly.loop_header466, %polly.start407, %.split.split.clone, %._crit_edge17.clone
  %21 = add i64 %data53, %6
  %22 = add i64 %21, %2
  %23 = inttoptr i64 %22 to i8*
  %24 = icmp ult i8* %23, %mean56
  %pair-no-alias57 = or i1 %24, %12
  br i1 %pair-no-alias57, label %polly.start379, label %.preheader3.split.clone

.preheader3.split.clone:                          ; preds = %.preheader3
  %25 = icmp sgt i32 %n, 0
  br i1 %25, label %.preheader2.lr.ph.clone, label %.preheader1

.preheader2.lr.ph.clone:                          ; preds = %.preheader3.split.clone
  %26 = icmp sgt i32 %m, 0
  br label %.preheader2.clone

.preheader2.clone:                                ; preds = %._crit_edge12.clone, %.preheader2.lr.ph.clone
  %indvar39.clone = phi i64 [ 0, %.preheader2.lr.ph.clone ], [ %indvar.next40.clone, %._crit_edge12.clone ]
  br i1 %26, label %.lr.ph11.clone, label %._crit_edge12.clone

.lr.ph11.clone:                                   ; preds = %.preheader2.clone, %.lr.ph11.clone
  %indvar35.clone = phi i64 [ %indvar.next36.clone, %.lr.ph11.clone ], [ 0, %.preheader2.clone ]
  %scevgep41.clone = getelementptr [1200 x double]* %data, i64 %indvar39.clone, i64 %indvar35.clone
  %scevgep38.clone = getelementptr double* %mean, i64 %indvar35.clone
  %27 = load double* %scevgep38.clone, align 8, !tbaa !1
  %28 = load double* %scevgep41.clone, align 8, !tbaa !1
  %29 = fsub double %28, %27
  store double %29, double* %scevgep41.clone, align 8, !tbaa !1
  %indvar.next36.clone = add i64 %indvar35.clone, 1
  %exitcond37.clone = icmp ne i64 %indvar.next36.clone, %0
  br i1 %exitcond37.clone, label %.lr.ph11.clone, label %._crit_edge12.clone

._crit_edge12.clone:                              ; preds = %.lr.ph11.clone, %.preheader2.clone
  %indvar.next40.clone = add i64 %indvar39.clone, 1
  %exitcond42.clone = icmp ne i64 %indvar.next40.clone, %4
  br i1 %exitcond42.clone, label %.preheader2.clone, label %.preheader1

.preheader1:                                      ; preds = %polly.then383, %polly.loop_exit396, %polly.start379, %.preheader3.split.clone, %._crit_edge12.clone
  %30 = add i32 %m, -1
  %31 = mul i32 -1, %30
  %32 = add i32 %30, %31
  %33 = zext i32 %32 to i64
  %34 = mul i64 8, %33
  %35 = add i64 %3, %34
  %36 = add i64 %35, %6
  %37 = icmp ugt i64 %36, %7
  %umax = select i1 %37, i64 %36, i64 %7
  %umax62 = inttoptr i64 %umax to i8*
  %umin5863 = bitcast [1200 x double]* %cov to i8*
  %38 = mul i64 9608, %1
  %39 = add i64 %cov59, %38
  %40 = add i64 %39, %34
  %41 = mul i64 9600, %33
  %42 = add i64 %39, %41
  %43 = icmp ugt i64 %42, %40
  %umax60 = select i1 %43, i64 %42, i64 %40
  %umax6064 = inttoptr i64 %umax60 to i8*
  %44 = icmp ult i8* %umax62, %umin5863
  %45 = icmp ult i8* %umax6064, %data55
  %pair-no-alias65 = or i1 %44, %45
  %46 = icmp sgt i32 %m, 0
  br i1 %pair-no-alias65, label %.preheader1.split, label %.preheader1.split.clone

.preheader1.split.clone:                          ; preds = %.preheader1
  br i1 %46, label %.preheader.lr.ph.clone, label %.region.clone

.preheader.lr.ph.clone:                           ; preds = %.preheader1.split.clone
  %47 = zext i32 %30 to i64
  %48 = icmp sgt i32 %n, 0
  %49 = fadd double %float_n, -1.000000e+00
  br label %.preheader.clone

.preheader.clone:                                 ; preds = %._crit_edge7.clone, %.preheader.lr.ph.clone
  %indvar21.clone = phi i64 [ 0, %.preheader.lr.ph.clone ], [ %indvar.next22.clone, %._crit_edge7.clone ]
  %i.28.clone = trunc i64 %indvar21.clone to i32
  %50 = mul i64 %indvar21.clone, 1201
  %51 = mul i64 %indvar21.clone, -1
  %52 = add i64 %47, %51
  %53 = trunc i64 %52 to i32
  %54 = zext i32 %53 to i64
  %55 = add i64 %54, 1
  %56 = icmp slt i32 %i.28.clone, %m
  br i1 %56, label %.lr.ph6.clone, label %._crit_edge7.clone

.lr.ph6.clone:                                    ; preds = %.preheader.clone, %._crit_edge.clone
  %indvar23.clone = phi i64 [ %indvar.next24.clone, %._crit_edge.clone ], [ 0, %.preheader.clone ]
  %scevgep29.clone = getelementptr [1200 x double]* %cov, i64 %indvar23.clone, i64 %50
  %57 = add i64 %50, %indvar23.clone
  %scevgep28.clone = getelementptr [1200 x double]* %cov, i64 0, i64 %57
  %58 = add i64 %indvar21.clone, %indvar23.clone
  store double 0.000000e+00, double* %scevgep28.clone, align 8, !tbaa !1
  br i1 %48, label %.lr.ph.clone, label %._crit_edge.clone

.lr.ph.clone:                                     ; preds = %.lr.ph6.clone, %.lr.ph.clone
  %indvar.clone = phi i64 [ %indvar.next.clone, %.lr.ph.clone ], [ 0, %.lr.ph6.clone ]
  %scevgep25.clone = getelementptr [1200 x double]* %data, i64 %indvar.clone, i64 %58
  %scevgep.clone = getelementptr [1200 x double]* %data, i64 %indvar.clone, i64 %indvar21.clone
  %59 = load double* %scevgep.clone, align 8, !tbaa !1
  %60 = load double* %scevgep25.clone, align 8, !tbaa !1
  %61 = fmul double %59, %60
  %62 = load double* %scevgep28.clone, align 8, !tbaa !1
  %63 = fadd double %62, %61
  store double %63, double* %scevgep28.clone, align 8, !tbaa !1
  %indvar.next.clone = add i64 %indvar.clone, 1
  %exitcond.clone = icmp ne i64 %indvar.next.clone, %4
  br i1 %exitcond.clone, label %.lr.ph.clone, label %._crit_edge.clone

._crit_edge.clone:                                ; preds = %.lr.ph.clone, %.lr.ph6.clone
  %64 = load double* %scevgep28.clone, align 8, !tbaa !1
  %65 = fdiv double %64, %49
  store double %65, double* %scevgep28.clone, align 8, !tbaa !1
  store double %65, double* %scevgep29.clone, align 8, !tbaa !1
  %indvar.next24.clone = add i64 %indvar23.clone, 1
  %exitcond26.clone = icmp ne i64 %indvar.next24.clone, %55
  br i1 %exitcond26.clone, label %.lr.ph6.clone, label %._crit_edge7.clone

._crit_edge7.clone:                               ; preds = %._crit_edge.clone, %.preheader.clone
  %indvar.next22.clone = add i64 %indvar21.clone, 1
  %exitcond30.clone = icmp ne i64 %indvar.next22.clone, %0
  br i1 %exitcond30.clone, label %.preheader.clone, label %.region.clone

.preheader1.split:                                ; preds = %.preheader1
  br i1 %46, label %.preheader.lr.ph, label %.region.clone

.preheader.lr.ph:                                 ; preds = %.preheader1.split
  %66 = zext i32 %30 to i64
  %67 = fadd double %float_n, -1.000000e+00
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %polly.merge
  %indvar21 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next22, %polly.merge ]
  %68 = mul i64 %indvar21, -1
  %69 = add i64 %66, %68
  %70 = trunc i64 %69 to i32
  %71 = zext i32 %70 to i64
  %72 = mul i64 %indvar21, 9608
  %i.28 = trunc i64 %indvar21 to i32
  %73 = mul i64 %indvar21, 1201
  %74 = add i64 %71, 1
  %75 = icmp slt i32 %i.28, %m
  br i1 %75, label %polly.cond, label %polly.merge

polly.merge:                                      ; preds = %polly.then359, %polly.loop_header361, %polly.cond357, %polly.cond, %.preheader
  %indvar.next22 = add i64 %indvar21, 1
  %exitcond30 = icmp ne i64 %indvar.next22, %0
  br i1 %exitcond30, label %.preheader, label %.region.clone

.region.clone:                                    ; preds = %.preheader1.split, %polly.merge, %.preheader1.split.clone, %._crit_edge7.clone
  ret void

polly.cond:                                       ; preds = %.preheader
  %76 = srem i64 %72, 8
  %77 = icmp eq i64 %76, 0
  br i1 %77, label %polly.cond81, label %polly.merge

polly.cond81:                                     ; preds = %polly.cond
  %78 = sext i32 %n to i64
  %79 = icmp sge i64 %78, 1
  %80 = icmp sge i64 %4, 1
  %81 = and i1 %79, %80
  br i1 %81, label %polly.then83, label %polly.cond84

polly.cond84:                                     ; preds = %polly.then83, %polly.loop_header, %polly.cond81
  %82 = icmp sle i64 %78, 0
  %83 = and i1 %82, %80
  br i1 %83, label %polly.then86, label %polly.cond100

polly.cond100:                                    ; preds = %polly.then86, %polly.loop_header88, %polly.cond84
  %84 = icmp sle i64 %4, 0
  br i1 %84, label %polly.then102, label %polly.cond116

polly.cond116:                                    ; preds = %polly.then102, %polly.loop_header104, %polly.cond100
  br i1 %81, label %polly.then118, label %polly.cond146

polly.cond146:                                    ; preds = %polly.then118, %polly.loop_exit135, %polly.cond116
  br i1 %83, label %polly.then148, label %polly.cond166

polly.cond166:                                    ; preds = %polly.then148, %polly.loop_header150, %polly.cond146
  br i1 %84, label %polly.then168, label %polly.cond191

polly.cond191:                                    ; preds = %polly.then168, %polly.loop_header170, %polly.cond166
  br i1 %81, label %polly.then193, label %polly.cond225

polly.cond225:                                    ; preds = %polly.then193, %polly.loop_exit206, %polly.cond191
  br i1 %83, label %polly.then227, label %polly.cond246

polly.cond246:                                    ; preds = %polly.then227, %polly.loop_header229, %polly.cond225
  br i1 %84, label %polly.then248, label %polly.cond267

polly.cond267:                                    ; preds = %polly.then248, %polly.loop_header250, %polly.cond246
  br i1 %81, label %polly.then269, label %polly.cond314

polly.cond314:                                    ; preds = %polly.then269, %polly.loop_exit295, %polly.cond267
  br i1 %81, label %polly.then316, label %polly.cond357

polly.cond357:                                    ; preds = %polly.then316, %polly.loop_exit338, %polly.cond314
  br i1 %81, label %polly.then359, label %polly.merge

polly.then83:                                     ; preds = %polly.cond81
  %85 = icmp slt i64 398, %71
  %86 = select i1 %85, i64 398, i64 %71
  br i1 true, label %polly.loop_header, label %polly.cond84

polly.loop_header:                                ; preds = %polly.then83, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then83 ]
  %p_ = add i64 %73, %polly.indvar
  %p_scevgep28 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_
  store double 0.000000e+00, double* %p_scevgep28
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %86, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond84

polly.then86:                                     ; preds = %polly.cond84
  %87 = icmp slt i64 798, %71
  %88 = select i1 %87, i64 798, i64 %71
  br i1 true, label %polly.loop_header88, label %polly.cond100

polly.loop_header88:                              ; preds = %polly.then86, %polly.loop_header88
  %polly.indvar92 = phi i64 [ %polly.indvar_next93, %polly.loop_header88 ], [ 0, %polly.then86 ]
  %p_98 = add i64 %73, %polly.indvar92
  %p_scevgep2899 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_98
  store double 0.000000e+00, double* %p_scevgep2899
  %polly.indvar_next93 = add nsw i64 %polly.indvar92, 1
  %polly.adjust_ub94 = sub i64 %88, 1
  %polly.loop_cond95 = icmp sle i64 %polly.indvar92, %polly.adjust_ub94
  br i1 %polly.loop_cond95, label %polly.loop_header88, label %polly.cond100

polly.then102:                                    ; preds = %polly.cond100
  %89 = icmp slt i64 798, %71
  %90 = select i1 %89, i64 798, i64 %71
  br i1 true, label %polly.loop_header104, label %polly.cond116

polly.loop_header104:                             ; preds = %polly.then102, %polly.loop_header104
  %polly.indvar108 = phi i64 [ %polly.indvar_next109, %polly.loop_header104 ], [ 0, %polly.then102 ]
  %p_114 = add i64 %73, %polly.indvar108
  %p_scevgep28115 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_114
  store double 0.000000e+00, double* %p_scevgep28115
  %polly.indvar_next109 = add nsw i64 %polly.indvar108, 1
  %polly.adjust_ub110 = sub i64 %90, 1
  %polly.loop_cond111 = icmp sle i64 %polly.indvar108, %polly.adjust_ub110
  br i1 %polly.loop_cond111, label %polly.loop_header104, label %polly.cond116

polly.then118:                                    ; preds = %polly.cond116
  %91 = icmp slt i64 798, %71
  %92 = select i1 %91, i64 798, i64 %71
  %polly.loop_guard123 = icmp sle i64 399, %92
  br i1 %polly.loop_guard123, label %polly.loop_header120, label %polly.cond146

polly.loop_header120:                             ; preds = %polly.then118, %polly.loop_exit135
  %polly.indvar124 = phi i64 [ %polly.indvar_next125, %polly.loop_exit135 ], [ 399, %polly.then118 ]
  %p_130 = add i64 %73, %polly.indvar124
  %p_scevgep28131 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_130
  store double 0.000000e+00, double* %p_scevgep28131
  %polly.loop_guard136 = icmp sle i64 0, %5
  br i1 %polly.loop_guard136, label %polly.loop_header133, label %polly.loop_exit135

polly.loop_exit135:                               ; preds = %polly.loop_header133, %polly.loop_header120
  %polly.indvar_next125 = add nsw i64 %polly.indvar124, 1
  %polly.adjust_ub126 = sub i64 %92, 1
  %polly.loop_cond127 = icmp sle i64 %polly.indvar124, %polly.adjust_ub126
  br i1 %polly.loop_cond127, label %polly.loop_header120, label %polly.cond146

polly.loop_header133:                             ; preds = %polly.loop_header120, %polly.loop_header133
  %polly.indvar137 = phi i64 [ %polly.indvar_next138, %polly.loop_header133 ], [ 0, %polly.loop_header120 ]
  %93 = add i64 %polly.indvar124, -399
  %p_.moved.to.66 = add i64 %indvar21, %93
  %p_.moved.to.67 = add i64 %73, %93
  %p_scevgep28.moved.to. = getelementptr [1200 x double]* %cov, i64 0, i64 %p_.moved.to.67
  %p_scevgep25 = getelementptr [1200 x double]* %data, i64 %polly.indvar137, i64 %p_.moved.to.66
  %p_scevgep = getelementptr [1200 x double]* %data, i64 %polly.indvar137, i64 %indvar21
  %_p_scalar_ = load double* %p_scevgep
  %_p_scalar_142 = load double* %p_scevgep25
  %p_143 = fmul double %_p_scalar_, %_p_scalar_142
  %_p_scalar_144 = load double* %p_scevgep28.moved.to.
  %p_145 = fadd double %_p_scalar_144, %p_143
  store double %p_145, double* %p_scevgep28.moved.to.
  %p_indvar.next = add i64 %polly.indvar137, 1
  %polly.indvar_next138 = add nsw i64 %polly.indvar137, 1
  %polly.adjust_ub139 = sub i64 %5, 1
  %polly.loop_cond140 = icmp sle i64 %polly.indvar137, %polly.adjust_ub139
  br i1 %polly.loop_cond140, label %polly.loop_header133, label %polly.loop_exit135

polly.then148:                                    ; preds = %polly.cond146
  %polly.loop_guard153 = icmp sle i64 799, %71
  br i1 %polly.loop_guard153, label %polly.loop_header150, label %polly.cond166

polly.loop_header150:                             ; preds = %polly.then148, %polly.loop_header150
  %polly.indvar154 = phi i64 [ %polly.indvar_next155, %polly.loop_header150 ], [ 799, %polly.then148 ]
  %p_160 = add i64 %73, %polly.indvar154
  %p_scevgep28161 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_160
  store double 0.000000e+00, double* %p_scevgep28161
  %94 = add i64 %polly.indvar154, -799
  %p_.moved.to.68 = add i64 %73, %94
  %p_scevgep28.moved.to.69 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_.moved.to.68
  %p_scevgep29.moved.to. = getelementptr [1200 x double]* %cov, i64 %94, i64 %73
  %_p_scalar_163 = load double* %p_scevgep28.moved.to.69
  %p_164 = fdiv double %_p_scalar_163, %67
  store double %p_164, double* %p_scevgep28.moved.to.69
  store double %p_164, double* %p_scevgep29.moved.to.
  %p_indvar.next24 = add i64 %94, 1
  %polly.indvar_next155 = add nsw i64 %polly.indvar154, 1
  %polly.adjust_ub156 = sub i64 %71, 1
  %polly.loop_cond157 = icmp sle i64 %polly.indvar154, %polly.adjust_ub156
  br i1 %polly.loop_cond157, label %polly.loop_header150, label %polly.cond166

polly.then168:                                    ; preds = %polly.cond166
  %polly.loop_guard173 = icmp sle i64 799, %71
  br i1 %polly.loop_guard173, label %polly.loop_header170, label %polly.cond191

polly.loop_header170:                             ; preds = %polly.then168, %polly.loop_header170
  %polly.indvar174 = phi i64 [ %polly.indvar_next175, %polly.loop_header170 ], [ 799, %polly.then168 ]
  %p_180 = add i64 %73, %polly.indvar174
  %p_scevgep28181 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_180
  store double 0.000000e+00, double* %p_scevgep28181
  %95 = add i64 %polly.indvar174, -799
  %p_.moved.to.68183 = add i64 %73, %95
  %p_scevgep28.moved.to.69184 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_.moved.to.68183
  %p_scevgep29.moved.to.185 = getelementptr [1200 x double]* %cov, i64 %95, i64 %73
  %_p_scalar_186 = load double* %p_scevgep28.moved.to.69184
  %p_187 = fdiv double %_p_scalar_186, %67
  store double %p_187, double* %p_scevgep28.moved.to.69184
  store double %p_187, double* %p_scevgep29.moved.to.185
  %p_indvar.next24189 = add i64 %95, 1
  %polly.indvar_next175 = add nsw i64 %polly.indvar174, 1
  %polly.adjust_ub176 = sub i64 %71, 1
  %polly.loop_cond177 = icmp sle i64 %polly.indvar174, %polly.adjust_ub176
  br i1 %polly.loop_cond177, label %polly.loop_header170, label %polly.cond191

polly.then193:                                    ; preds = %polly.cond191
  %96 = icmp sgt i64 399, %74
  %97 = select i1 %96, i64 399, i64 %74
  %98 = add i64 %71, 399
  %99 = icmp slt i64 798, %98
  %100 = select i1 %99, i64 798, i64 %98
  %polly.loop_guard198 = icmp sle i64 %97, %100
  br i1 %polly.loop_guard198, label %polly.loop_header195, label %polly.cond225

polly.loop_header195:                             ; preds = %polly.then193, %polly.loop_exit206
  %polly.indvar199 = phi i64 [ %polly.indvar_next200, %polly.loop_exit206 ], [ %97, %polly.then193 ]
  %polly.loop_guard207 = icmp sle i64 0, %5
  br i1 %polly.loop_guard207, label %polly.loop_header204, label %polly.loop_exit206

polly.loop_exit206:                               ; preds = %polly.loop_header204, %polly.loop_header195
  %polly.indvar_next200 = add nsw i64 %polly.indvar199, 1
  %polly.adjust_ub201 = sub i64 %100, 1
  %polly.loop_cond202 = icmp sle i64 %polly.indvar199, %polly.adjust_ub201
  br i1 %polly.loop_cond202, label %polly.loop_header195, label %polly.cond225

polly.loop_header204:                             ; preds = %polly.loop_header195, %polly.loop_header204
  %polly.indvar208 = phi i64 [ %polly.indvar_next209, %polly.loop_header204 ], [ 0, %polly.loop_header195 ]
  %101 = add i64 %polly.indvar199, -399
  %p_.moved.to.66213 = add i64 %indvar21, %101
  %p_.moved.to.67214 = add i64 %73, %101
  %p_scevgep28.moved.to.215 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_.moved.to.67214
  %p_scevgep25216 = getelementptr [1200 x double]* %data, i64 %polly.indvar208, i64 %p_.moved.to.66213
  %p_scevgep217 = getelementptr [1200 x double]* %data, i64 %polly.indvar208, i64 %indvar21
  %_p_scalar_218 = load double* %p_scevgep217
  %_p_scalar_219 = load double* %p_scevgep25216
  %p_220 = fmul double %_p_scalar_218, %_p_scalar_219
  %_p_scalar_221 = load double* %p_scevgep28.moved.to.215
  %p_222 = fadd double %_p_scalar_221, %p_220
  store double %p_222, double* %p_scevgep28.moved.to.215
  %p_indvar.next223 = add i64 %polly.indvar208, 1
  %polly.indvar_next209 = add nsw i64 %polly.indvar208, 1
  %polly.adjust_ub210 = sub i64 %5, 1
  %polly.loop_cond211 = icmp sle i64 %polly.indvar208, %polly.adjust_ub210
  br i1 %polly.loop_cond211, label %polly.loop_header204, label %polly.loop_exit206

polly.then227:                                    ; preds = %polly.cond225
  %102 = icmp sgt i64 799, %74
  %103 = select i1 %102, i64 799, i64 %74
  %104 = add i64 %71, 799
  %polly.loop_guard232 = icmp sle i64 %103, %104
  br i1 %polly.loop_guard232, label %polly.loop_header229, label %polly.cond246

polly.loop_header229:                             ; preds = %polly.then227, %polly.loop_header229
  %polly.indvar233 = phi i64 [ %polly.indvar_next234, %polly.loop_header229 ], [ %103, %polly.then227 ]
  %105 = add i64 %polly.indvar233, -799
  %p_.moved.to.68238 = add i64 %73, %105
  %p_scevgep28.moved.to.69239 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_.moved.to.68238
  %p_scevgep29.moved.to.240 = getelementptr [1200 x double]* %cov, i64 %105, i64 %73
  %_p_scalar_241 = load double* %p_scevgep28.moved.to.69239
  %p_242 = fdiv double %_p_scalar_241, %67
  store double %p_242, double* %p_scevgep28.moved.to.69239
  store double %p_242, double* %p_scevgep29.moved.to.240
  %p_indvar.next24244 = add i64 %105, 1
  %polly.indvar_next234 = add nsw i64 %polly.indvar233, 1
  %polly.adjust_ub235 = sub i64 %104, 1
  %polly.loop_cond236 = icmp sle i64 %polly.indvar233, %polly.adjust_ub235
  br i1 %polly.loop_cond236, label %polly.loop_header229, label %polly.cond246

polly.then248:                                    ; preds = %polly.cond246
  %106 = icmp sgt i64 799, %74
  %107 = select i1 %106, i64 799, i64 %74
  %108 = add i64 %71, 799
  %polly.loop_guard253 = icmp sle i64 %107, %108
  br i1 %polly.loop_guard253, label %polly.loop_header250, label %polly.cond267

polly.loop_header250:                             ; preds = %polly.then248, %polly.loop_header250
  %polly.indvar254 = phi i64 [ %polly.indvar_next255, %polly.loop_header250 ], [ %107, %polly.then248 ]
  %109 = add i64 %polly.indvar254, -799
  %p_.moved.to.68259 = add i64 %73, %109
  %p_scevgep28.moved.to.69260 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_.moved.to.68259
  %p_scevgep29.moved.to.261 = getelementptr [1200 x double]* %cov, i64 %109, i64 %73
  %_p_scalar_262 = load double* %p_scevgep28.moved.to.69260
  %p_263 = fdiv double %_p_scalar_262, %67
  store double %p_263, double* %p_scevgep28.moved.to.69260
  store double %p_263, double* %p_scevgep29.moved.to.261
  %p_indvar.next24265 = add i64 %109, 1
  %polly.indvar_next255 = add nsw i64 %polly.indvar254, 1
  %polly.adjust_ub256 = sub i64 %108, 1
  %polly.loop_cond257 = icmp sle i64 %polly.indvar254, %polly.adjust_ub256
  br i1 %polly.loop_cond257, label %polly.loop_header250, label %polly.cond267

polly.then269:                                    ; preds = %polly.cond267
  %polly.loop_guard274 = icmp sle i64 799, %71
  br i1 %polly.loop_guard274, label %polly.loop_header271, label %polly.cond314

polly.loop_header271:                             ; preds = %polly.then269, %polly.loop_exit295
  %polly.indvar275 = phi i64 [ %polly.indvar_next276, %polly.loop_exit295 ], [ 799, %polly.then269 ]
  %p_281 = add i64 %73, %polly.indvar275
  %p_scevgep28282 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_281
  store double 0.000000e+00, double* %p_scevgep28282
  %110 = add i64 %polly.indvar275, -799
  %p_.moved.to.68284 = add i64 %73, %110
  %p_scevgep28.moved.to.69285 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_.moved.to.68284
  %p_scevgep29.moved.to.286 = getelementptr [1200 x double]* %cov, i64 %110, i64 %73
  %_p_scalar_287 = load double* %p_scevgep28.moved.to.69285
  %p_288 = fdiv double %_p_scalar_287, %67
  store double %p_288, double* %p_scevgep28.moved.to.69285
  store double %p_288, double* %p_scevgep29.moved.to.286
  %p_indvar.next24290 = add i64 %110, 1
  %polly.loop_guard296 = icmp sle i64 0, %5
  br i1 %polly.loop_guard296, label %polly.loop_header293, label %polly.loop_exit295

polly.loop_exit295:                               ; preds = %polly.loop_header293, %polly.loop_header271
  %polly.indvar_next276 = add nsw i64 %polly.indvar275, 1
  %polly.adjust_ub277 = sub i64 %71, 1
  %polly.loop_cond278 = icmp sle i64 %polly.indvar275, %polly.adjust_ub277
  br i1 %polly.loop_cond278, label %polly.loop_header271, label %polly.cond314

polly.loop_header293:                             ; preds = %polly.loop_header271, %polly.loop_header293
  %polly.indvar297 = phi i64 [ %polly.indvar_next298, %polly.loop_header293 ], [ 0, %polly.loop_header271 ]
  %111 = add i64 %polly.indvar275, -399
  %p_.moved.to.66302 = add i64 %indvar21, %111
  %p_.moved.to.67303 = add i64 %73, %111
  %p_scevgep28.moved.to.304 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_.moved.to.67303
  %p_scevgep25305 = getelementptr [1200 x double]* %data, i64 %polly.indvar297, i64 %p_.moved.to.66302
  %p_scevgep306 = getelementptr [1200 x double]* %data, i64 %polly.indvar297, i64 %indvar21
  %_p_scalar_307 = load double* %p_scevgep306
  %_p_scalar_308 = load double* %p_scevgep25305
  %p_309 = fmul double %_p_scalar_307, %_p_scalar_308
  %_p_scalar_310 = load double* %p_scevgep28.moved.to.304
  %p_311 = fadd double %_p_scalar_310, %p_309
  store double %p_311, double* %p_scevgep28.moved.to.304
  %p_indvar.next312 = add i64 %polly.indvar297, 1
  %polly.indvar_next298 = add nsw i64 %polly.indvar297, 1
  %polly.adjust_ub299 = sub i64 %5, 1
  %polly.loop_cond300 = icmp sle i64 %polly.indvar297, %polly.adjust_ub299
  br i1 %polly.loop_cond300, label %polly.loop_header293, label %polly.loop_exit295

polly.then316:                                    ; preds = %polly.cond314
  %112 = icmp sgt i64 799, %74
  %113 = select i1 %112, i64 799, i64 %74
  %114 = add i64 %71, 399
  %polly.loop_guard321 = icmp sle i64 %113, %114
  br i1 %polly.loop_guard321, label %polly.loop_header318, label %polly.cond357

polly.loop_header318:                             ; preds = %polly.then316, %polly.loop_exit338
  %polly.indvar322 = phi i64 [ %polly.indvar_next323, %polly.loop_exit338 ], [ %113, %polly.then316 ]
  %115 = add i64 %polly.indvar322, -799
  %p_.moved.to.68327 = add i64 %73, %115
  %p_scevgep28.moved.to.69328 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_.moved.to.68327
  %p_scevgep29.moved.to.329 = getelementptr [1200 x double]* %cov, i64 %115, i64 %73
  %_p_scalar_330 = load double* %p_scevgep28.moved.to.69328
  %p_331 = fdiv double %_p_scalar_330, %67
  store double %p_331, double* %p_scevgep28.moved.to.69328
  store double %p_331, double* %p_scevgep29.moved.to.329
  %p_indvar.next24333 = add i64 %115, 1
  %polly.loop_guard339 = icmp sle i64 0, %5
  br i1 %polly.loop_guard339, label %polly.loop_header336, label %polly.loop_exit338

polly.loop_exit338:                               ; preds = %polly.loop_header336, %polly.loop_header318
  %polly.indvar_next323 = add nsw i64 %polly.indvar322, 1
  %polly.adjust_ub324 = sub i64 %114, 1
  %polly.loop_cond325 = icmp sle i64 %polly.indvar322, %polly.adjust_ub324
  br i1 %polly.loop_cond325, label %polly.loop_header318, label %polly.cond357

polly.loop_header336:                             ; preds = %polly.loop_header318, %polly.loop_header336
  %polly.indvar340 = phi i64 [ %polly.indvar_next341, %polly.loop_header336 ], [ 0, %polly.loop_header318 ]
  %116 = add i64 %polly.indvar322, -399
  %p_.moved.to.66345 = add i64 %indvar21, %116
  %p_.moved.to.67346 = add i64 %73, %116
  %p_scevgep28.moved.to.347 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_.moved.to.67346
  %p_scevgep25348 = getelementptr [1200 x double]* %data, i64 %polly.indvar340, i64 %p_.moved.to.66345
  %p_scevgep349 = getelementptr [1200 x double]* %data, i64 %polly.indvar340, i64 %indvar21
  %_p_scalar_350 = load double* %p_scevgep349
  %_p_scalar_351 = load double* %p_scevgep25348
  %p_352 = fmul double %_p_scalar_350, %_p_scalar_351
  %_p_scalar_353 = load double* %p_scevgep28.moved.to.347
  %p_354 = fadd double %_p_scalar_353, %p_352
  store double %p_354, double* %p_scevgep28.moved.to.347
  %p_indvar.next355 = add i64 %polly.indvar340, 1
  %polly.indvar_next341 = add nsw i64 %polly.indvar340, 1
  %polly.adjust_ub342 = sub i64 %5, 1
  %polly.loop_cond343 = icmp sle i64 %polly.indvar340, %polly.adjust_ub342
  br i1 %polly.loop_cond343, label %polly.loop_header336, label %polly.loop_exit338

polly.then359:                                    ; preds = %polly.cond357
  %117 = add i64 %71, 400
  %118 = icmp sgt i64 799, %117
  %119 = select i1 %118, i64 799, i64 %117
  %120 = add i64 %71, 799
  %polly.loop_guard364 = icmp sle i64 %119, %120
  br i1 %polly.loop_guard364, label %polly.loop_header361, label %polly.merge

polly.loop_header361:                             ; preds = %polly.then359, %polly.loop_header361
  %polly.indvar365 = phi i64 [ %polly.indvar_next366, %polly.loop_header361 ], [ %119, %polly.then359 ]
  %121 = add i64 %polly.indvar365, -799
  %p_.moved.to.68370 = add i64 %73, %121
  %p_scevgep28.moved.to.69371 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_.moved.to.68370
  %p_scevgep29.moved.to.372 = getelementptr [1200 x double]* %cov, i64 %121, i64 %73
  %_p_scalar_373 = load double* %p_scevgep28.moved.to.69371
  %p_374 = fdiv double %_p_scalar_373, %67
  store double %p_374, double* %p_scevgep28.moved.to.69371
  store double %p_374, double* %p_scevgep29.moved.to.372
  %p_indvar.next24376 = add i64 %121, 1
  %polly.indvar_next366 = add nsw i64 %polly.indvar365, 1
  %polly.adjust_ub367 = sub i64 %120, 1
  %polly.loop_cond368 = icmp sle i64 %polly.indvar365, %polly.adjust_ub367
  br i1 %polly.loop_cond368, label %polly.loop_header361, label %polly.merge

polly.start379:                                   ; preds = %.preheader3
  %122 = sext i32 %m to i64
  %123 = icmp sge i64 %122, 1
  %124 = sext i32 %n to i64
  %125 = icmp sge i64 %124, 1
  %126 = and i1 %123, %125
  %127 = icmp sge i64 %4, 1
  %128 = and i1 %126, %127
  %129 = icmp sge i64 %0, 1
  %130 = and i1 %128, %129
  br i1 %130, label %polly.then383, label %.preheader1

polly.then383:                                    ; preds = %polly.start379
  %polly.loop_guard388 = icmp sle i64 0, %5
  br i1 %polly.loop_guard388, label %polly.loop_header385, label %.preheader1

polly.loop_header385:                             ; preds = %polly.then383, %polly.loop_exit396
  %polly.indvar389 = phi i64 [ %polly.indvar_next390, %polly.loop_exit396 ], [ 0, %polly.then383 ]
  %polly.loop_guard397 = icmp sle i64 0, %1
  br i1 %polly.loop_guard397, label %polly.loop_header394, label %polly.loop_exit396

polly.loop_exit396:                               ; preds = %polly.loop_header394, %polly.loop_header385
  %polly.indvar_next390 = add nsw i64 %polly.indvar389, 1
  %polly.adjust_ub391 = sub i64 %5, 1
  %polly.loop_cond392 = icmp sle i64 %polly.indvar389, %polly.adjust_ub391
  br i1 %polly.loop_cond392, label %polly.loop_header385, label %.preheader1

polly.loop_header394:                             ; preds = %polly.loop_header385, %polly.loop_header394
  %polly.indvar398 = phi i64 [ %polly.indvar_next399, %polly.loop_header394 ], [ 0, %polly.loop_header385 ]
  %p_scevgep41 = getelementptr [1200 x double]* %data, i64 %polly.indvar389, i64 %polly.indvar398
  %p_scevgep38 = getelementptr double* %mean, i64 %polly.indvar398
  %_p_scalar_403 = load double* %p_scevgep38
  %_p_scalar_404 = load double* %p_scevgep41
  %p_405 = fsub double %_p_scalar_404, %_p_scalar_403
  store double %p_405, double* %p_scevgep41
  %p_indvar.next36 = add i64 %polly.indvar398, 1
  %polly.indvar_next399 = add nsw i64 %polly.indvar398, 1
  %polly.adjust_ub400 = sub i64 %1, 1
  %polly.loop_cond401 = icmp sle i64 %polly.indvar398, %polly.adjust_ub400
  br i1 %polly.loop_cond401, label %polly.loop_header394, label %polly.loop_exit396

polly.start407:                                   ; preds = %.split
  %131 = sext i32 %m to i64
  %132 = icmp sge i64 %131, 1
  %133 = icmp sge i64 %0, 1
  %134 = and i1 %132, %133
  br i1 %134, label %polly.then411, label %.preheader3

polly.then411:                                    ; preds = %polly.start407
  %polly.loop_guard416 = icmp sle i64 0, %1
  br i1 %polly.loop_guard416, label %polly.loop_header413, label %polly.cond422

polly.cond422:                                    ; preds = %polly.then411, %polly.loop_header413
  %135 = sext i32 %n to i64
  %136 = icmp sge i64 %135, 1
  %137 = icmp sge i64 %4, 1
  %138 = and i1 %136, %137
  br i1 %138, label %polly.then424, label %polly.merge423

polly.merge423:                                   ; preds = %polly.then424, %polly.loop_exit437, %polly.cond422
  br i1 %polly.loop_guard416, label %polly.loop_header466, label %.preheader3

polly.loop_header413:                             ; preds = %polly.then411, %polly.loop_header413
  %polly.indvar417 = phi i64 [ %polly.indvar_next418, %polly.loop_header413 ], [ 0, %polly.then411 ]
  %p_scevgep52 = getelementptr double* %mean, i64 %polly.indvar417
  store double 0.000000e+00, double* %p_scevgep52
  %polly.indvar_next418 = add nsw i64 %polly.indvar417, 1
  %polly.adjust_ub419 = sub i64 %1, 1
  %polly.loop_cond420 = icmp sle i64 %polly.indvar417, %polly.adjust_ub419
  br i1 %polly.loop_cond420, label %polly.loop_header413, label %polly.cond422

polly.then424:                                    ; preds = %polly.cond422
  br i1 %polly.loop_guard416, label %polly.loop_header426, label %polly.merge423

polly.loop_header426:                             ; preds = %polly.then424, %polly.loop_exit437
  %polly.indvar430 = phi i64 [ %polly.indvar_next431, %polly.loop_exit437 ], [ 0, %polly.then424 ]
  %polly.loop_guard438 = icmp sle i64 0, %5
  br i1 %polly.loop_guard438, label %polly.loop_header435, label %polly.loop_exit437

polly.loop_exit437:                               ; preds = %polly.loop_exit446, %polly.loop_header426
  %polly.indvar_next431 = add nsw i64 %polly.indvar430, 32
  %polly.adjust_ub432 = sub i64 %1, 32
  %polly.loop_cond433 = icmp sle i64 %polly.indvar430, %polly.adjust_ub432
  br i1 %polly.loop_cond433, label %polly.loop_header426, label %polly.merge423

polly.loop_header435:                             ; preds = %polly.loop_header426, %polly.loop_exit446
  %polly.indvar439 = phi i64 [ %polly.indvar_next440, %polly.loop_exit446 ], [ 0, %polly.loop_header426 ]
  %139 = add i64 %polly.indvar430, 31
  %140 = icmp slt i64 %139, %1
  %141 = select i1 %140, i64 %139, i64 %1
  %polly.loop_guard447 = icmp sle i64 %polly.indvar430, %141
  br i1 %polly.loop_guard447, label %polly.loop_header444, label %polly.loop_exit446

polly.loop_exit446:                               ; preds = %polly.loop_exit455, %polly.loop_header435
  %polly.indvar_next440 = add nsw i64 %polly.indvar439, 32
  %polly.adjust_ub441 = sub i64 %5, 32
  %polly.loop_cond442 = icmp sle i64 %polly.indvar439, %polly.adjust_ub441
  br i1 %polly.loop_cond442, label %polly.loop_header435, label %polly.loop_exit437

polly.loop_header444:                             ; preds = %polly.loop_header435, %polly.loop_exit455
  %polly.indvar448 = phi i64 [ %polly.indvar_next449, %polly.loop_exit455 ], [ %polly.indvar430, %polly.loop_header435 ]
  %142 = add i64 %polly.indvar439, 31
  %143 = icmp slt i64 %142, %5
  %144 = select i1 %143, i64 %142, i64 %5
  %polly.loop_guard456 = icmp sle i64 %polly.indvar439, %144
  br i1 %polly.loop_guard456, label %polly.loop_header453, label %polly.loop_exit455

polly.loop_exit455:                               ; preds = %polly.loop_header453, %polly.loop_header444
  %polly.indvar_next449 = add nsw i64 %polly.indvar448, 1
  %polly.adjust_ub450 = sub i64 %141, 1
  %polly.loop_cond451 = icmp sle i64 %polly.indvar448, %polly.adjust_ub450
  br i1 %polly.loop_cond451, label %polly.loop_header444, label %polly.loop_exit446

polly.loop_header453:                             ; preds = %polly.loop_header444, %polly.loop_header453
  %polly.indvar457 = phi i64 [ %polly.indvar_next458, %polly.loop_header453 ], [ %polly.indvar439, %polly.loop_header444 ]
  %p_scevgep52.moved.to. = getelementptr double* %mean, i64 %polly.indvar448
  %p_scevgep49 = getelementptr [1200 x double]* %data, i64 %polly.indvar457, i64 %polly.indvar448
  %_p_scalar_462 = load double* %p_scevgep49
  %_p_scalar_463 = load double* %p_scevgep52.moved.to.
  %p_464 = fadd double %_p_scalar_462, %_p_scalar_463
  store double %p_464, double* %p_scevgep52.moved.to.
  %p_indvar.next45 = add i64 %polly.indvar457, 1
  %polly.indvar_next458 = add nsw i64 %polly.indvar457, 1
  %polly.adjust_ub459 = sub i64 %144, 1
  %polly.loop_cond460 = icmp sle i64 %polly.indvar457, %polly.adjust_ub459
  br i1 %polly.loop_cond460, label %polly.loop_header453, label %polly.loop_exit455

polly.loop_header466:                             ; preds = %polly.merge423, %polly.loop_header466
  %polly.indvar470 = phi i64 [ %polly.indvar_next471, %polly.loop_header466 ], [ 0, %polly.merge423 ]
  %p_scevgep52.moved.to.72 = getelementptr double* %mean, i64 %polly.indvar470
  %_p_scalar_475 = load double* %p_scevgep52.moved.to.72
  %p_476 = fdiv double %_p_scalar_475, %float_n
  store double %p_476, double* %p_scevgep52.moved.to.72
  %p_indvar.next48 = add i64 %polly.indvar470, 1
  %polly.indvar_next471 = add nsw i64 %polly.indvar470, 1
  %polly.adjust_ub472 = sub i64 %1, 1
  %polly.loop_cond473 = icmp sle i64 %polly.indvar470, %polly.adjust_ub472
  br i1 %polly.loop_cond473, label %polly.loop_header466, label %.preheader3
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %m, [1200 x double]* %cov) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([4 x i8]* @.str3, i64 0, i64 0)) #5
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
  %scevgep = getelementptr [1200 x double]* %cov, i64 %indvar4, i64 %indvar
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
  %24 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([4 x i8]* @.str3, i64 0, i64 0)) #5
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
