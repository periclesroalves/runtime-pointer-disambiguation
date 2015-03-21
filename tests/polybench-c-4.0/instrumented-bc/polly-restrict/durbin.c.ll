; ModuleID = './linear-algebra/solvers/durbin/durbin.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [2 x i8] c"y\00", align 1
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
  tail call void @init_array(i32 2000, double* %2)
  tail call void (...)* @polybench_timer_start() #3
  %3 = bitcast i8* %1 to double*
  tail call void @kernel_durbin(i32 2000, double* %2, double* %3)
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
  tail call void @print_array(i32 2000, double* %3)
  br label %9

; <label>:9                                       ; preds = %5, %8, %.split
  tail call void @free(i8* %0) #3
  tail call void @free(i8* %1) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %n, double* noalias %r) #0 {
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
  %p_.moved.to. = add i32 %n, 1
  %p_.moved.to.2 = zext i32 %p_.moved.to. to i64
  %p_ = mul i64 %polly.indvar, -1
  %p_4 = add i64 %p_.moved.to.2, %p_
  %p_5 = trunc i64 %p_4 to i32
  %p_scevgep = getelementptr double* %r, i64 %polly.indvar
  %p_6 = sitofp i32 %p_5 to double
  store double %p_6, double* %p_scevgep
  %p_indvar.next = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %5, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_durbin(i32 %n, double* noalias %r, double* noalias %y) #0 {
.split:
  %z = alloca [2000 x double], align 16
  %0 = bitcast [2000 x double]* %z to i8*
  call void @llvm.lifetime.start(i64 16000, i8* %0) #3
  %1 = load double* %r, align 8, !tbaa !6
  %2 = fsub double -0.000000e+00, %1
  store double %2, double* %y, align 8, !tbaa !6
  %3 = icmp sgt i32 %n, 1
  br i1 %3, label %.lr.ph13, label %polly.merge

.lr.ph13:                                         ; preds = %.split
  %4 = load double* %r, align 8, !tbaa !6
  %5 = fsub double -0.000000e+00, %4
  %6 = add i32 %n, -2
  %7 = zext i32 %6 to i64
  %8 = add i64 %7, 1
  br i1 true, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit96, %.lr.ph13, %.split
  call void @llvm.lifetime.end(i64 16000, i8* %0) #3
  ret void

polly.then:                                       ; preds = %.lr.ph13
  br i1 true, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit96
  %beta.09.reg2mem.0 = phi double [ 1.000000e+00, %polly.then ], [ %p_.moved.to.47, %polly.loop_exit96 ]
  %alpha.010.reg2mem.0 = phi double [ %5, %polly.then ], [ %p_.moved.to.48, %polly.loop_exit96 ]
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit96 ], [ 0, %polly.then ]
  %polly.loop_guard60 = icmp sle i64 0, %polly.indvar
  br i1 %polly.loop_guard60, label %polly.loop_header57, label %polly.loop_exit59

polly.loop_exit59:                                ; preds = %polly.loop_header57, %polly.loop_header
  %sum.01.reg2mem.0 = phi double [ %p_68, %polly.loop_header57 ], [ 0.000000e+00, %polly.loop_header ]
  %p_70 = add i64 %polly.indvar, 1
  %p_k.011 = trunc i64 %p_70 to i32
  %p_scevgep32.moved.to. = getelementptr double* %r, i64 %p_70
  %_p_scalar_74 = load double* %p_scevgep32.moved.to.
  %p_.moved.to.43 = fadd double %sum.01.reg2mem.0, %_p_scalar_74
  %p_.moved.to.44 = fsub double -0.000000e+00, %p_.moved.to.43
  %p_.moved.to.45 = fmul double %alpha.010.reg2mem.0, %alpha.010.reg2mem.0
  %p_.moved.to.46 = fsub double 1.000000e+00, %p_.moved.to.45
  %p_.moved.to.47 = fmul double %beta.09.reg2mem.0, %p_.moved.to.46
  %p_.moved.to.48 = fdiv double %p_.moved.to.44, %p_.moved.to.47
  %p_scevgep33.moved.to. = getelementptr double* %y, i64 %p_70
  store double %p_.moved.to.48, double* %p_scevgep33.moved.to.
  br i1 %polly.loop_guard60, label %polly.loop_header78, label %polly.loop_exit80

polly.loop_exit80:                                ; preds = %polly.loop_header78, %polly.loop_exit59
  br i1 %polly.loop_guard60, label %polly.loop_header94, label %polly.loop_exit96

polly.loop_exit96:                                ; preds = %polly.loop_header94, %polly.loop_exit80
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %7, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header57:                              ; preds = %polly.loop_header, %polly.loop_header57
  %sum.01.reg2mem.1 = phi double [ 0.000000e+00, %polly.loop_header ], [ %p_68, %polly.loop_header57 ]
  %polly.indvar61 = phi i64 [ %polly.indvar_next62, %polly.loop_header57 ], [ 0, %polly.loop_header ]
  %p_.moved.to. = add i64 %polly.indvar, 1
  %p_ = mul i64 %polly.indvar61, -1
  %p_65 = add i64 %polly.indvar, %p_
  %p_scevgep = getelementptr double* %r, i64 %p_65
  %p_scevgep17 = getelementptr double* %y, i64 %polly.indvar61
  %_p_scalar_ = load double* %p_scevgep
  %_p_scalar_66 = load double* %p_scevgep17
  %p_67 = fmul double %_p_scalar_, %_p_scalar_66
  %p_68 = fadd double %sum.01.reg2mem.1, %p_67
  %p_indvar.next = add i64 %polly.indvar61, 1
  %polly.indvar_next62 = add nsw i64 %polly.indvar61, 1
  %polly.adjust_ub63 = sub i64 %polly.indvar, 1
  %polly.loop_cond64 = icmp sle i64 %polly.indvar61, %polly.adjust_ub63
  br i1 %polly.loop_cond64, label %polly.loop_header57, label %polly.loop_exit59

polly.loop_header78:                              ; preds = %polly.loop_exit59, %polly.loop_header78
  %polly.indvar82 = phi i64 [ %polly.indvar_next83, %polly.loop_header78 ], [ 0, %polly.loop_exit59 ]
  %p_87 = mul i64 %polly.indvar82, -1
  %p_88 = add i64 %polly.indvar, %p_87
  %p_scevgep21 = getelementptr double* %y, i64 %p_88
  %p_scevgep22 = getelementptr double* %y, i64 %polly.indvar82
  %p_scevgep23 = getelementptr [2000 x double]* %z, i64 0, i64 %polly.indvar82
  %_p_scalar_89 = load double* %p_scevgep22
  %_p_scalar_90 = load double* %p_scevgep21
  %p_91 = fmul double %p_.moved.to.48, %_p_scalar_90
  %p_92 = fadd double %_p_scalar_89, %p_91
  store double %p_92, double* %p_scevgep23
  %p_indvar.next19 = add i64 %polly.indvar82, 1
  %polly.indvar_next83 = add nsw i64 %polly.indvar82, 1
  %polly.adjust_ub84 = sub i64 %polly.indvar, 1
  %polly.loop_cond85 = icmp sle i64 %polly.indvar82, %polly.adjust_ub84
  br i1 %polly.loop_cond85, label %polly.loop_header78, label %polly.loop_exit80

polly.loop_header94:                              ; preds = %polly.loop_exit80, %polly.loop_header94
  %polly.indvar98 = phi i64 [ %polly.indvar_next99, %polly.loop_header94 ], [ 0, %polly.loop_exit80 ]
  %p_scevgep27 = getelementptr [2000 x double]* %z, i64 0, i64 %polly.indvar98
  %p_scevgep28 = getelementptr double* %y, i64 %polly.indvar98
  %_p_scalar_103 = load double* %p_scevgep27
  store double %_p_scalar_103, double* %p_scevgep28
  %p_indvar.next25 = add i64 %polly.indvar98, 1
  %polly.indvar_next99 = add nsw i64 %polly.indvar98, 1
  %polly.adjust_ub100 = sub i64 %polly.indvar, 1
  %polly.loop_cond101 = icmp sle i64 %polly.indvar98, %polly.adjust_ub100
  br i1 %polly.loop_cond101, label %polly.loop_header94, label %polly.loop_exit96
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, double* noalias %y) #0 {
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
  %scevgep = getelementptr double* %y, i64 %indvar
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
declare void @llvm.lifetime.start(i64, i8* nocapture) #3

; Function Attrs: nounwind
declare void @llvm.lifetime.end(i64, i8* nocapture) #3

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
