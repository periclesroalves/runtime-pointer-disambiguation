; ModuleID = './stencils/jacobi-1d/jacobi-1d.c'
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
  %0 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %2 = bitcast i8* %0 to double*
  %3 = bitcast i8* %1 to double*
  tail call void @init_array(i32 2000, double* %2, double* %3)
  tail call void (...)* @polybench_timer_start() #3
  tail call void @kernel_jacobi_1d(i32 500, i32 2000, double* %2, double* %3)
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
  tail call void @print_array(i32 2000, double* %2)
  br label %9

; <label>:9                                       ; preds = %5, %8, %.split
  tail call void @free(i8* %0) #3
  tail call void @free(i8* %1) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %n, double* %A, double* %B) #0 {
.split:
  %A5 = bitcast double* %A to i8*
  %B6 = bitcast double* %B to i8*
  %B4 = ptrtoint double* %B to i64
  %A3 = ptrtoint double* %A to i64
  %0 = zext i32 %n to i64
  %1 = add i64 %0, -1
  %2 = mul i64 8, %1
  %3 = add i64 %A3, %2
  %4 = inttoptr i64 %3 to i8*
  %5 = add i64 %B4, %2
  %6 = inttoptr i64 %5 to i8*
  %7 = icmp ult i8* %4, %B6
  %8 = icmp ult i8* %6, %A5
  %pair-no-alias = or i1 %7, %8
  br i1 %pair-no-alias, label %polly.start, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  %9 = icmp sgt i32 %n, 0
  br i1 %9, label %.lr.ph.clone, label %.region.clone

.lr.ph.clone:                                     ; preds = %.split.split.clone
  %10 = sitofp i32 %n to double
  br label %11

; <label>:11                                      ; preds = %11, %.lr.ph.clone
  %indvar.clone = phi i64 [ 0, %.lr.ph.clone ], [ %indvar.next.clone, %11 ]
  %i.01.clone = trunc i64 %indvar.clone to i32
  %scevgep.clone = getelementptr double* %A, i64 %indvar.clone
  %scevgep2.clone = getelementptr double* %B, i64 %indvar.clone
  %12 = sitofp i32 %i.01.clone to double
  %13 = fadd double %12, 2.000000e+00
  %14 = fdiv double %13, %10
  store double %14, double* %scevgep.clone, align 8, !tbaa !6
  %15 = fadd double %12, 3.000000e+00
  %16 = fdiv double %15, %10
  store double %16, double* %scevgep2.clone, align 8, !tbaa !6
  %indvar.next.clone = add i64 %indvar.clone, 1
  %exitcond.clone = icmp ne i64 %indvar.next.clone, %0
  br i1 %exitcond.clone, label %11, label %.region.clone

.region.clone:                                    ; preds = %polly.then, %polly.loop_header, %polly.start, %.split.split.clone, %11
  ret void

polly.start:                                      ; preds = %.split
  %17 = sext i32 %n to i64
  %18 = icmp sge i64 %17, 1
  %19 = icmp sge i64 %0, 1
  %20 = and i1 %18, %19
  br i1 %20, label %polly.then, label %.region.clone

polly.then:                                       ; preds = %polly.start
  %polly.loop_guard = icmp sle i64 0, %1
  br i1 %polly.loop_guard, label %polly.loop_header, label %.region.clone

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_.moved.to. = sitofp i32 %n to double
  %p_i.01 = trunc i64 %polly.indvar to i32
  %p_scevgep = getelementptr double* %A, i64 %polly.indvar
  %p_scevgep2 = getelementptr double* %B, i64 %polly.indvar
  %p_ = sitofp i32 %p_i.01 to double
  %p_9 = fadd double %p_, 2.000000e+00
  %p_10 = fdiv double %p_9, %p_.moved.to.
  store double %p_10, double* %p_scevgep
  %p_12 = fadd double %p_, 3.000000e+00
  %p_13 = fdiv double %p_12, %p_.moved.to.
  store double %p_13, double* %p_scevgep2
  %p_indvar.next = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %1, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %.region.clone
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_jacobi_1d(i32 %tsteps, i32 %n, double* %A, double* %B) #0 {
.split:
  %A18 = ptrtoint double* %A to i64
  %0 = icmp sgt i32 %tsteps, 0
  br i1 %0, label %.preheader1.lr.ph, label %._crit_edge6

.preheader1.lr.ph:                                ; preds = %.split
  %1 = add i32 %n, -1
  %2 = add i32 %n, -3
  %3 = zext i32 %2 to i64
  %4 = add i64 %3, 1
  %5 = add nsw i32 %n, -1
  %6 = icmp sgt i32 %5, 1
  %scevgep15 = getelementptr double* %A, i64 1
  %scevgep16 = getelementptr double* %A, i64 2
  %scevgep1920 = ptrtoint double* %scevgep15 to i64
  %scevgep2122 = ptrtoint double* %scevgep16 to i64
  %scevgep24 = getelementptr double* %B, i64 1
  %scevgep2429 = bitcast double* %scevgep24 to i8*
  %scevgep2526 = ptrtoint double* %scevgep24 to i64
  %scevgep3043 = bitcast double* %scevgep15 to i8*
  br label %.preheader1

.preheader1:                                      ; preds = %.preheader1.lr.ph, %._crit_edge
  %t.05 = phi i32 [ 0, %.preheader1.lr.ph ], [ %54, %._crit_edge ]
  %7 = icmp ult double* %scevgep15, %A
  %umin = select i1 %7, double* %scevgep15, double* %A
  %8 = icmp ult double* %scevgep16, %umin
  %umin17 = select i1 %8, double* %scevgep16, double* %umin
  %umin1727 = bitcast double* %umin17 to i8*
  %9 = mul i64 8, %3
  %10 = add i64 %A18, %9
  %11 = add i64 %scevgep1920, %9
  %12 = icmp ugt i64 %11, %10
  %umax = select i1 %12, i64 %11, i64 %10
  %13 = add i64 %scevgep2122, %9
  %14 = icmp ugt i64 %13, %umax
  %umax23 = select i1 %14, i64 %13, i64 %umax
  %umax2328 = inttoptr i64 %umax23 to i8*
  %15 = add i64 %scevgep2526, %9
  %16 = inttoptr i64 %15 to i8*
  %17 = icmp ult i8* %umax2328, %scevgep2429
  %18 = icmp ult i8* %16, %umin1727
  %pair-no-alias = or i1 %17, %18
  br i1 %pair-no-alias, label %polly.cond56, label %.preheader1.split.clone

.preheader1.split.clone:                          ; preds = %.preheader1
  br i1 %6, label %.lr.ph.clone, label %.preheader

.lr.ph.clone:                                     ; preds = %.preheader1.split.clone, %.lr.ph.clone
  %indvar.clone = phi i64 [ %19, %.lr.ph.clone ], [ 0, %.preheader1.split.clone ]
  %19 = add i64 %indvar.clone, 1
  %scevgep.clone = getelementptr double* %A, i64 %19
  %20 = add i64 %indvar.clone, 2
  %scevgep7.clone = getelementptr double* %A, i64 %20
  %scevgep8.clone = getelementptr double* %B, i64 %19
  %scevgep9.clone = getelementptr double* %A, i64 %indvar.clone
  %21 = load double* %scevgep9.clone, align 8, !tbaa !6
  %22 = load double* %scevgep.clone, align 8, !tbaa !6
  %23 = fadd double %21, %22
  %24 = load double* %scevgep7.clone, align 8, !tbaa !6
  %25 = fadd double %23, %24
  %26 = fmul double %25, 3.333300e-01
  store double %26, double* %scevgep8.clone, align 8, !tbaa !6
  %exitcond.clone = icmp ne i64 %19, %4
  br i1 %exitcond.clone, label %.lr.ph.clone, label %..preheader_crit_edge.clone

..preheader_crit_edge.clone:                      ; preds = %.lr.ph.clone
  br label %.preheader

.preheader:                                       ; preds = %polly.stmt..preheader1.split, %.preheader1.split.clone, %..preheader_crit_edge.clone
  %i.0.lcssa.reg2mem.0 = phi i32 [ %., %polly.stmt..preheader1.split ], [ %1, %..preheader_crit_edge.clone ], [ 1, %.preheader1.split.clone ]
  br i1 %6, label %.lr.ph4, label %._crit_edge

.lr.ph4:                                          ; preds = %.preheader
  %27 = add nsw i32 %i.0.lcssa.reg2mem.0, -1
  %28 = sext i32 %27 to i64
  %29 = getelementptr inbounds double* %B, i64 %28
  %30 = sext i32 %i.0.lcssa.reg2mem.0 to i64
  %31 = getelementptr inbounds double* %B, i64 %30
  %32 = add nsw i32 %i.0.lcssa.reg2mem.0, 1
  %33 = sext i32 %32 to i64
  %34 = getelementptr inbounds double* %B, i64 %33
  %35 = inttoptr i64 %11 to i8*
  %36 = add i32 %i.0.lcssa.reg2mem.0, -1
  %37 = sext i32 %36 to i64
  %scevgep33 = getelementptr double* %B, i64 %37
  %scevgep34 = getelementptr double* %B, i64 %30
  %38 = icmp ult double* %scevgep34, %scevgep33
  %umin35 = select i1 %38, double* %scevgep34, double* %scevgep33
  %39 = add i32 %i.0.lcssa.reg2mem.0, 1
  %40 = sext i32 %39 to i64
  %scevgep36 = getelementptr double* %B, i64 %40
  %41 = icmp ult double* %scevgep36, %umin35
  %umin37 = select i1 %41, double* %scevgep36, double* %umin35
  %umin3744 = bitcast double* %umin37 to i8*
  %42 = icmp ugt double* %scevgep34, %scevgep33
  %umax40 = select i1 %42, double* %scevgep34, double* %scevgep33
  %43 = icmp ugt double* %scevgep36, %umax40
  %umax42 = select i1 %43, double* %scevgep36, double* %umax40
  %umax4245 = bitcast double* %umax42 to i8*
  %44 = icmp ult i8* %35, %umin3744
  %45 = icmp ult i8* %umax4245, %scevgep3043
  %pair-no-alias46 = or i1 %44, %45
  br i1 %pair-no-alias46, label %polly.cond, label %46

; <label>:46                                      ; preds = %.lr.ph4, %46
  %indvar10.clone = phi i64 [ 0, %.lr.ph4 ], [ %47, %46 ]
  %47 = add i64 %indvar10.clone, 1
  %scevgep13.clone = getelementptr double* %A, i64 %47
  %48 = load double* %29, align 8, !tbaa !6
  %49 = load double* %31, align 8, !tbaa !6
  %50 = fadd double %48, %49
  %51 = load double* %34, align 8, !tbaa !6
  %52 = fadd double %50, %51
  %53 = fmul double %52, 3.333300e-01
  store double %53, double* %scevgep13.clone, align 8, !tbaa !6
  %exitcond12.clone = icmp ne i64 %47, %4
  br i1 %exitcond12.clone, label %46, label %._crit_edge

._crit_edge:                                      ; preds = %polly.then, %polly.loop_header, %polly.cond, %46, %.preheader
  %54 = add nsw i32 %t.05, 1
  %exitcond14 = icmp ne i32 %54, %tsteps
  br i1 %exitcond14, label %.preheader1, label %._crit_edge6

._crit_edge6:                                     ; preds = %._crit_edge, %.split
  ret void

polly.cond:                                       ; preds = %.lr.ph4
  br i1 true, label %polly.then, label %._crit_edge

polly.then:                                       ; preds = %polly.cond
  br i1 true, label %polly.loop_header, label %._crit_edge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_ = add i64 %polly.indvar, 1
  %p_scevgep13 = getelementptr double* %A, i64 %p_
  %_p_scalar_ = load double* %29
  %_p_scalar_48 = load double* %31
  %p_49 = fadd double %_p_scalar_, %_p_scalar_48
  %_p_scalar_50 = load double* %34
  %p_51 = fadd double %p_49, %_p_scalar_50
  %p_52 = fmul double %p_51, 3.333300e-01
  store double %p_52, double* %p_scevgep13
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %3, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %._crit_edge

polly.cond56:                                     ; preds = %.preheader1
  %55 = sext i32 %n to i64
  %56 = icmp sge i64 %55, 3
  br i1 %56, label %polly.then58, label %polly.stmt..preheader1.split

polly.stmt..preheader1.split:                     ; preds = %polly.then58, %polly.loop_header60, %polly.cond56
  %. = select i1 %56, i32 %1, i32 1
  br label %.preheader

polly.then58:                                     ; preds = %polly.cond56
  br i1 true, label %polly.loop_header60, label %polly.stmt..preheader1.split

polly.loop_header60:                              ; preds = %polly.then58, %polly.loop_header60
  %polly.indvar64 = phi i64 [ %polly.indvar_next65, %polly.loop_header60 ], [ 0, %polly.then58 ]
  %p_69 = add i64 %polly.indvar64, 1
  %p_scevgep = getelementptr double* %A, i64 %p_69
  %p_70 = add i64 %polly.indvar64, 2
  %p_scevgep7 = getelementptr double* %A, i64 %p_70
  %p_scevgep8 = getelementptr double* %B, i64 %p_69
  %p_scevgep9 = getelementptr double* %A, i64 %polly.indvar64
  %_p_scalar_71 = load double* %p_scevgep9
  %_p_scalar_72 = load double* %p_scevgep
  %p_73 = fadd double %_p_scalar_71, %_p_scalar_72
  %_p_scalar_74 = load double* %p_scevgep7
  %p_75 = fadd double %p_73, %_p_scalar_74
  %p_76 = fmul double %p_75, 3.333300e-01
  store double %p_76, double* %p_scevgep8
  %polly.indvar_next65 = add nsw i64 %polly.indvar64, 1
  %polly.adjust_ub66 = sub i64 %3, 1
  %polly.loop_cond67 = icmp sle i64 %polly.indvar64, %polly.adjust_ub66
  br i1 %polly.loop_cond67, label %polly.loop_header60, label %polly.stmt..preheader1.split
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, double* %A) #0 {
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
  %scevgep = getelementptr double* %A, i64 %indvar
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
