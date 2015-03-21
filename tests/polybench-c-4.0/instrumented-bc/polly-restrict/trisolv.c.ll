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
define internal void @init_array(i32 %n, [2000 x double]* noalias %L, double* noalias %x, double* noalias %b) #0 {
polly.split_new_and_old:
  %0 = zext i32 %n to i64
  %1 = sext i32 %n to i64
  %2 = icmp sge i64 %1, 1
  %3 = icmp sge i64 %0, 1
  %4 = and i1 %2, %3
  br i1 %4, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.loop_exit, %polly.loop_header51, %polly.split_new_and_old
  ret void

polly.then:                                       ; preds = %polly.split_new_and_old
  %5 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %5
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.loop_exit

polly.loop_exit:                                  ; preds = %polly.loop_exit21, %polly.then
  br i1 %polly.loop_guard, label %polly.loop_header51, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit21
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit21 ], [ 0, %polly.then ]
  %6 = mul i64 -11, %0
  %7 = add i64 %6, 5
  %8 = sub i64 %7, 32
  %9 = add i64 %8, 1
  %10 = icmp slt i64 %7, 0
  %11 = select i1 %10, i64 %9, i64 %7
  %12 = sdiv i64 %11, 32
  %13 = mul i64 -32, %12
  %14 = mul i64 -32, %0
  %15 = add i64 %13, %14
  %16 = mul i64 -32, %polly.indvar
  %17 = mul i64 11, %polly.indvar
  %18 = add i64 %17, -1
  %19 = sub i64 %18, 32
  %20 = add i64 %19, 1
  %21 = icmp slt i64 %18, 0
  %22 = select i1 %21, i64 %20, i64 %18
  %23 = sdiv i64 %22, 32
  %24 = mul i64 32, %23
  %25 = add i64 %16, %24
  %26 = add i64 %25, -640
  %27 = icmp sgt i64 %15, %26
  %28 = select i1 %27, i64 %15, i64 %26
  %29 = mul i64 -20, %polly.indvar
  %polly.loop_guard22 = icmp sle i64 %28, %29
  br i1 %polly.loop_guard22, label %polly.loop_header19, label %polly.loop_exit21

polly.loop_exit21:                                ; preds = %polly.loop_exit30, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %5, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.loop_exit

polly.loop_header19:                              ; preds = %polly.loop_header, %polly.loop_exit30
  %polly.indvar23 = phi i64 [ %polly.indvar_next24, %polly.loop_exit30 ], [ %28, %polly.loop_header ]
  %30 = mul i64 -1, %polly.indvar23
  %31 = add i64 %30, -31
  %32 = add i64 %31, 21
  %33 = sub i64 %32, 1
  %34 = icmp slt i64 %31, 0
  %35 = select i1 %34, i64 %31, i64 %33
  %36 = sdiv i64 %35, 21
  %37 = icmp sgt i64 %36, %polly.indvar
  %38 = select i1 %37, i64 %36, i64 %polly.indvar
  %39 = sub i64 %30, 20
  %40 = add i64 %39, 1
  %41 = icmp slt i64 %30, 0
  %42 = select i1 %41, i64 %40, i64 %30
  %43 = sdiv i64 %42, 20
  %44 = add i64 %polly.indvar, 31
  %45 = icmp slt i64 %43, %44
  %46 = select i1 %45, i64 %43, i64 %44
  %47 = icmp slt i64 %46, %5
  %48 = select i1 %47, i64 %46, i64 %5
  %polly.loop_guard31 = icmp sle i64 %38, %48
  br i1 %polly.loop_guard31, label %polly.loop_header28, label %polly.loop_exit30

polly.loop_exit30:                                ; preds = %polly.loop_exit39, %polly.loop_header19
  %polly.indvar_next24 = add nsw i64 %polly.indvar23, 32
  %polly.adjust_ub25 = sub i64 %29, 32
  %polly.loop_cond26 = icmp sle i64 %polly.indvar23, %polly.adjust_ub25
  br i1 %polly.loop_cond26, label %polly.loop_header19, label %polly.loop_exit21

polly.loop_header28:                              ; preds = %polly.loop_header19, %polly.loop_exit39
  %polly.indvar32 = phi i64 [ %polly.indvar_next33, %polly.loop_exit39 ], [ %38, %polly.loop_header19 ]
  %49 = mul i64 -21, %polly.indvar32
  %50 = icmp sgt i64 %polly.indvar23, %49
  %51 = select i1 %50, i64 %polly.indvar23, i64 %49
  %52 = mul i64 -20, %polly.indvar32
  %53 = add i64 %polly.indvar23, 31
  %54 = icmp slt i64 %52, %53
  %55 = select i1 %54, i64 %52, i64 %53
  %polly.loop_guard40 = icmp sle i64 %51, %55
  br i1 %polly.loop_guard40, label %polly.loop_header37, label %polly.loop_exit39

polly.loop_exit39:                                ; preds = %polly.loop_header37, %polly.loop_header28
  %polly.indvar_next33 = add nsw i64 %polly.indvar32, 1
  %polly.adjust_ub34 = sub i64 %48, 1
  %polly.loop_cond35 = icmp sle i64 %polly.indvar32, %polly.adjust_ub34
  br i1 %polly.loop_cond35, label %polly.loop_header28, label %polly.loop_exit30

polly.loop_header37:                              ; preds = %polly.loop_header28, %polly.loop_header37
  %polly.indvar41 = phi i64 [ %polly.indvar_next42, %polly.loop_header37 ], [ %51, %polly.loop_header28 ]
  %56 = mul i64 -1, %polly.indvar41
  %57 = add i64 %52, %56
  %p_.moved.to.13 = add i32 %n, 1
  %p_.moved.to.14 = zext i32 %p_.moved.to.13 to i64
  %p_.moved.to.15 = add i64 %p_.moved.to.14, %polly.indvar32
  %p_.moved.to.16 = sitofp i32 %n to double
  %p_.moved.to.17 = add i64 %polly.indvar32, 1
  %p_scevgep = getelementptr [2000 x double]* %L, i64 %polly.indvar32, i64 %57
  %p_ = mul i64 %57, -1
  %p_45 = add i64 %p_.moved.to.15, %p_
  %p_46 = trunc i64 %p_45 to i32
  %p_47 = sitofp i32 %p_46 to double
  %p_48 = fmul double %p_47, 2.000000e+00
  %p_49 = fdiv double %p_48, %p_.moved.to.16
  store double %p_49, double* %p_scevgep
  %p_indvar.next = add i64 %57, 1
  %polly.indvar_next42 = add nsw i64 %polly.indvar41, 1
  %polly.adjust_ub43 = sub i64 %55, 1
  %polly.loop_cond44 = icmp sle i64 %polly.indvar41, %polly.adjust_ub43
  br i1 %polly.loop_cond44, label %polly.loop_header37, label %polly.loop_exit39

polly.loop_header51:                              ; preds = %polly.loop_exit, %polly.loop_header51
  %polly.indvar55 = phi i64 [ %polly.indvar_next56, %polly.loop_header51 ], [ 0, %polly.loop_exit ]
  %p_i.02 = trunc i64 %polly.indvar55 to i32
  %p_scevgep11 = getelementptr double* %x, i64 %polly.indvar55
  %p_scevgep12 = getelementptr double* %b, i64 %polly.indvar55
  store double -9.990000e+02, double* %p_scevgep11
  %p_60 = sitofp i32 %p_i.02 to double
  store double %p_60, double* %p_scevgep12
  %polly.indvar_next56 = add nsw i64 %polly.indvar55, 1
  %polly.adjust_ub57 = sub i64 %5, 1
  %polly.loop_cond58 = icmp sle i64 %polly.indvar55, %polly.adjust_ub57
  br i1 %polly.loop_cond58, label %polly.loop_header51, label %polly.merge
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_trisolv(i32 %n, [2000 x double]* noalias %L, double* noalias %x, double* noalias %b) #0 {
polly.split_new_and_old:
  %0 = zext i32 %n to i64
  %1 = sext i32 %n to i64
  %2 = icmp sge i64 %1, 1
  %3 = icmp sge i64 %0, 1
  %4 = and i1 %2, %3
  br i1 %4, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.loop_exit19, %polly.split_new_and_old
  ret void

polly.then:                                       ; preds = %polly.split_new_and_old
  %5 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %5
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.loop_exit

polly.loop_exit:                                  ; preds = %polly.loop_header, %polly.then
  %6 = add i64 %0, -2
  %polly.loop_guard20 = icmp sle i64 0, %6
  br i1 %polly.loop_guard20, label %polly.loop_header17, label %polly.loop_exit19

polly.loop_exit19:                                ; preds = %polly.loop_exit32, %polly.loop_exit
  %p_scevgep12.moved.to.1445 = getelementptr double* %x, i64 %5
  %p_.moved.to.46 = mul i64 %5, 2001
  %p_scevgep13.moved.to.47 = getelementptr [2000 x double]* %L, i64 0, i64 %p_.moved.to.46
  %_p_scalar_49 = load double* %p_scevgep12.moved.to.1445
  %_p_scalar_50 = load double* %p_scevgep13.moved.to.47
  %p_51 = fdiv double %_p_scalar_49, %_p_scalar_50
  store double %p_51, double* %p_scevgep12.moved.to.1445
  br label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_i.02 = trunc i64 %polly.indvar to i32
  %p_scevgep11 = getelementptr double* %b, i64 %polly.indvar
  %p_scevgep12 = getelementptr double* %x, i64 %polly.indvar
  %_p_scalar_ = load double* %p_scevgep11
  store double %_p_scalar_, double* %p_scevgep12
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %5, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.loop_exit

polly.loop_header17:                              ; preds = %polly.loop_exit, %polly.loop_exit32
  %polly.indvar21 = phi i64 [ %polly.indvar_next22, %polly.loop_exit32 ], [ 0, %polly.loop_exit ]
  %p_scevgep12.moved.to.14 = getelementptr double* %x, i64 %polly.indvar21
  %p_.moved.to. = mul i64 %polly.indvar21, 2001
  %p_scevgep13.moved.to. = getelementptr [2000 x double]* %L, i64 0, i64 %p_.moved.to.
  %_p_scalar_26 = load double* %p_scevgep12.moved.to.14
  %_p_scalar_27 = load double* %p_scevgep13.moved.to.
  %p_28 = fdiv double %_p_scalar_26, %_p_scalar_27
  store double %p_28, double* %p_scevgep12.moved.to.14
  %p_indvar.next7 = add i64 %polly.indvar21, 1
  %polly.loop_guard33 = icmp sle i64 %p_indvar.next7, %5
  br i1 %polly.loop_guard33, label %polly.loop_header30, label %polly.loop_exit32

polly.loop_exit32:                                ; preds = %polly.loop_header30, %polly.loop_header17
  %polly.indvar_next22 = add nsw i64 %polly.indvar21, 1
  %polly.adjust_ub23 = sub i64 %6, 1
  %polly.loop_cond24 = icmp sle i64 %polly.indvar21, %polly.adjust_ub23
  br i1 %polly.loop_cond24, label %polly.loop_header17, label %polly.loop_exit19

polly.loop_header30:                              ; preds = %polly.loop_header17, %polly.loop_header30
  %polly.indvar34 = phi i64 [ %polly.indvar_next35, %polly.loop_header30 ], [ %p_indvar.next7, %polly.loop_header17 ]
  %p_scevgep12.moved.to. = getelementptr double* %x, i64 %polly.indvar34
  %p_scevgep = getelementptr [2000 x double]* %L, i64 %polly.indvar34, i64 %polly.indvar21
  %_p_scalar_39 = load double* %p_scevgep
  %_p_scalar_40 = load double* %p_scevgep12.moved.to.14
  %p_41 = fmul double %_p_scalar_39, %_p_scalar_40
  %_p_scalar_42 = load double* %p_scevgep12.moved.to.
  %p_43 = fsub double %_p_scalar_42, %p_41
  store double %p_43, double* %p_scevgep12.moved.to.
  %polly.indvar_next35 = add nsw i64 %polly.indvar34, 1
  %polly.adjust_ub36 = sub i64 %5, 1
  %polly.loop_cond37 = icmp sle i64 %polly.indvar34, %polly.adjust_ub36
  br i1 %polly.loop_cond37, label %polly.loop_header30, label %polly.loop_exit32
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, double* noalias %x) #0 {
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
