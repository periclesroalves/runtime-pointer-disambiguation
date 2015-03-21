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
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.lr.ph5, label %._crit_edge6

.lr.ph5:                                          ; preds = %.split
  %1 = add i32 %n, 1
  %2 = zext i32 %n to i64
  %3 = zext i32 %1 to i64
  %4 = sitofp i32 %n to double
  br label %5

; <label>:5                                       ; preds = %.lr.ph5, %polly.merge
  %indvar7 = phi i64 [ 0, %.lr.ph5 ], [ %8, %polly.merge ]
  %6 = mul i64 %indvar7, 16000
  %i.02 = trunc i64 %indvar7 to i32
  %7 = add i64 %3, %indvar7
  %8 = add i64 %indvar7, 1
  %scevgep11 = getelementptr double* %x, i64 %indvar7
  %scevgep12 = getelementptr double* %b, i64 %indvar7
  store double -9.990000e+02, double* %scevgep11, align 8, !tbaa !6
  %9 = sitofp i32 %i.02 to double
  store double %9, double* %scevgep12, align 8, !tbaa !6
  %10 = icmp slt i32 %i.02, 0
  br i1 %10, label %polly.merge, label %polly.cond

polly.merge:                                      ; preds = %polly.then15, %polly.loop_header, %polly.cond, %5
  %exitcond9 = icmp ne i64 %8, %2
  br i1 %exitcond9, label %5, label %._crit_edge6

._crit_edge6:                                     ; preds = %polly.merge, %.split
  ret void

polly.cond:                                       ; preds = %5
  %11 = srem i64 %6, 8
  %12 = icmp eq i64 %11, 0
  %13 = icmp sge i64 %indvar7, 0
  %or.cond = and i1 %12, %13
  br i1 %or.cond, label %polly.then15, label %polly.merge

polly.then15:                                     ; preds = %polly.cond
  br i1 %13, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then15, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then15 ]
  %p_scevgep = getelementptr [2000 x double]* %L, i64 %indvar7, i64 %polly.indvar
  %p_ = mul i64 %polly.indvar, -1
  %p_16 = add i64 %7, %p_
  %p_17 = trunc i64 %p_16 to i32
  %p_18 = sitofp i32 %p_17 to double
  %p_19 = fmul double %p_18, 2.000000e+00
  %p_20 = fdiv double %p_19, %4
  store double %p_20, double* %p_scevgep
  %p_indvar.next = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %indvar7, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_trisolv(i32 %n, [2000 x double]* %L, double* %x, double* %b) #0 {
.split:
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.lr.ph4, label %._crit_edge5

.lr.ph4:                                          ; preds = %.split
  %1 = zext i32 %n to i64
  br label %2

; <label>:2                                       ; preds = %.lr.ph4, %._crit_edge
  %3 = phi i64 [ 0, %.lr.ph4 ], [ %indvar.next7, %._crit_edge ]
  %i.02 = trunc i64 %3 to i32
  %scevgep11 = getelementptr double* %b, i64 %3
  %scevgep12 = getelementptr double* %x, i64 %3
  %4 = mul i64 %3, 2001
  %scevgep13 = getelementptr [2000 x double]* %L, i64 0, i64 %4
  %5 = load double* %scevgep11, align 8, !tbaa !6
  store double %5, double* %scevgep12, align 8, !tbaa !6
  %6 = icmp sgt i32 %i.02, 0
  br i1 %6, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %2, %.lr.ph
  %indvar = phi i64 [ %indvar.next, %.lr.ph ], [ 0, %2 ]
  %scevgep = getelementptr [2000 x double]* %L, i64 %3, i64 %indvar
  %scevgep8 = getelementptr double* %x, i64 %indvar
  %7 = load double* %scevgep, align 8, !tbaa !6
  %8 = load double* %scevgep8, align 8, !tbaa !6
  %9 = fmul double %7, %8
  %10 = load double* %scevgep12, align 8, !tbaa !6
  %11 = fsub double %10, %9
  store double %11, double* %scevgep12, align 8, !tbaa !6
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %3
  br i1 %exitcond, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %2
  %12 = load double* %scevgep12, align 8, !tbaa !6
  %13 = load double* %scevgep13, align 8, !tbaa !6
  %14 = fdiv double %12, %13
  store double %14, double* %scevgep12, align 8, !tbaa !6
  %indvar.next7 = add i64 %3, 1
  %exitcond9 = icmp ne i64 %indvar.next7, %1
  br i1 %exitcond9, label %2, label %._crit_edge5

._crit_edge5:                                     ; preds = %._crit_edge, %.split
  ret void
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
