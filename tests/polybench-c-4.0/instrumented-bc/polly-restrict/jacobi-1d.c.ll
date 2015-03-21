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
define internal void @init_array(i32 %n, double* noalias %A, double* noalias %B) #0 {
polly.split_new_and_old:
  %0 = zext i32 %n to i64
  %1 = sext i32 %n to i64
  %2 = icmp sge i64 %1, 1
  %3 = icmp sge i64 %0, 1
  %4 = and i1 %2, %3
  br i1 %4, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.then, %polly.loop_header, %polly.split_new_and_old
  ret void

polly.then:                                       ; preds = %polly.split_new_and_old
  %5 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %5
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_.moved.to. = sitofp i32 %n to double
  %p_i.01 = trunc i64 %polly.indvar to i32
  %p_scevgep = getelementptr double* %A, i64 %polly.indvar
  %p_scevgep2 = getelementptr double* %B, i64 %polly.indvar
  %p_ = sitofp i32 %p_i.01 to double
  %p_5 = fadd double %p_, 2.000000e+00
  %p_6 = fdiv double %p_5, %p_.moved.to.
  store double %p_6, double* %p_scevgep
  %p_8 = fadd double %p_, 3.000000e+00
  %p_9 = fdiv double %p_8, %p_.moved.to.
  store double %p_9, double* %p_scevgep2
  %p_indvar.next = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %5, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_jacobi_1d(i32 %tsteps, i32 %n, double* noalias %A, double* noalias %B) #0 {
.split:
  %0 = icmp sgt i32 %tsteps, 0
  br i1 %0, label %.preheader1.lr.ph, label %._crit_edge6

.preheader1.lr.ph:                                ; preds = %.split
  %1 = add i32 %n, -1
  %2 = add i32 %n, -3
  %3 = zext i32 %2 to i64
  %4 = add i64 %3, 1
  %5 = add nsw i32 %n, -1
  %6 = icmp sgt i32 %5, 1
  br label %.preheader1

.preheader1:                                      ; preds = %.preheader1.lr.ph, %polly.merge
  %t.05 = phi i32 [ 0, %.preheader1.lr.ph ], [ %21, %polly.merge ]
  br i1 %6, label %polly.stmt...preheader_crit_edge, label %.preheader

.preheader:                                       ; preds = %polly.then20, %polly.loop_header22, %polly.stmt...preheader_crit_edge, %.preheader1
  %i.0.lcssa.reg2mem.0 = phi i32 [ %1, %polly.loop_header22 ], [ %1, %polly.then20 ], [ %1, %polly.stmt...preheader_crit_edge ], [ 1, %.preheader1 ]
  br i1 %6, label %.lr.ph4, label %polly.merge

.lr.ph4:                                          ; preds = %.preheader
  %7 = add nsw i32 %i.0.lcssa.reg2mem.0, -1
  %8 = sext i32 %7 to i64
  %9 = getelementptr inbounds double* %B, i64 %8
  %10 = load double* %9, align 8, !tbaa !6
  %11 = sext i32 %i.0.lcssa.reg2mem.0 to i64
  %12 = getelementptr inbounds double* %B, i64 %11
  %13 = load double* %12, align 8, !tbaa !6
  %14 = fadd double %10, %13
  %15 = add nsw i32 %i.0.lcssa.reg2mem.0, 1
  %16 = sext i32 %15 to i64
  %17 = getelementptr inbounds double* %B, i64 %16
  %18 = load double* %17, align 8, !tbaa !6
  %19 = fadd double %14, %18
  %20 = fmul double %19, 3.333300e-01
  br i1 true, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.then, %polly.loop_header, %.lr.ph4, %.preheader
  %21 = add nsw i32 %t.05, 1
  %exitcond14 = icmp ne i32 %21, %tsteps
  br i1 %exitcond14, label %.preheader1, label %._crit_edge6

._crit_edge6:                                     ; preds = %polly.merge, %.split
  ret void

polly.then:                                       ; preds = %.lr.ph4
  br i1 true, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_ = add i64 %polly.indvar, 1
  %p_scevgep13 = getelementptr double* %A, i64 %p_
  store double %20, double* %p_scevgep13
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %3, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.stmt...preheader_crit_edge:                 ; preds = %.preheader1
  br i1 true, label %polly.then20, label %.preheader

polly.then20:                                     ; preds = %polly.stmt...preheader_crit_edge
  br i1 true, label %polly.loop_header22, label %.preheader

polly.loop_header22:                              ; preds = %polly.then20, %polly.loop_header22
  %polly.indvar26 = phi i64 [ %polly.indvar_next27, %polly.loop_header22 ], [ 0, %polly.then20 ]
  %p_31 = add i64 %polly.indvar26, 1
  %p_scevgep = getelementptr double* %A, i64 %p_31
  %p_32 = add i64 %polly.indvar26, 2
  %p_scevgep7 = getelementptr double* %A, i64 %p_32
  %p_scevgep8 = getelementptr double* %B, i64 %p_31
  %p_scevgep9 = getelementptr double* %A, i64 %polly.indvar26
  %_p_scalar_ = load double* %p_scevgep9
  %_p_scalar_33 = load double* %p_scevgep
  %p_34 = fadd double %_p_scalar_, %_p_scalar_33
  %_p_scalar_35 = load double* %p_scevgep7
  %p_36 = fadd double %p_34, %_p_scalar_35
  %p_37 = fmul double %p_36, 3.333300e-01
  store double %p_37, double* %p_scevgep8
  %polly.indvar_next27 = add nsw i64 %polly.indvar26, 1
  %polly.adjust_ub28 = sub i64 %3, 1
  %polly.loop_cond29 = icmp sle i64 %polly.indvar26, %polly.adjust_ub28
  br i1 %polly.loop_cond29, label %polly.loop_header22, label %.preheader
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, double* noalias %A) #0 {
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
