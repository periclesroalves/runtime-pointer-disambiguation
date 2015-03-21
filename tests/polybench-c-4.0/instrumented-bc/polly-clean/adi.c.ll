; ModuleID = './stencils/adi/adi.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [2 x i8] c"u\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %0 = tail call i8* @polybench_alloc_data(i64 1000000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 1000000, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 1000000, i32 8) #3
  %3 = tail call i8* @polybench_alloc_data(i64 1000000, i32 8) #3
  %4 = bitcast i8* %0 to [1000 x double]*
  tail call void @init_array(i32 1000, [1000 x double]* %4)
  tail call void (...)* @polybench_timer_start() #3
  %5 = bitcast i8* %1 to [1000 x double]*
  %6 = bitcast i8* %2 to [1000 x double]*
  %7 = bitcast i8* %3 to [1000 x double]*
  tail call void @kernel_adi(i32 500, i32 1000, [1000 x double]* %4, [1000 x double]* %5, [1000 x double]* %6, [1000 x double]* %7)
  tail call void (...)* @polybench_timer_stop() #3
  tail call void (...)* @polybench_timer_print() #3
  %8 = icmp sgt i32 %argc, 42
  br i1 %8, label %9, label %13

; <label>:9                                       ; preds = %.split
  %10 = load i8** %argv, align 8, !tbaa !1
  %11 = load i8* %10, align 1, !tbaa !5
  %phitmp = icmp eq i8 %11, 0
  br i1 %phitmp, label %12, label %13

; <label>:12                                      ; preds = %9
  tail call void @print_array(i32 1000, [1000 x double]* %4)
  br label %13

; <label>:13                                      ; preds = %9, %12, %.split
  tail call void @free(i8* %0) #3
  tail call void @free(i8* %1) #3
  tail call void @free(i8* %2) #3
  tail call void @free(i8* %3) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %n, [1000 x double]* %u) #0 {
polly.split_new_and_old:
  %0 = zext i32 %n to i64
  %1 = sext i32 %n to i64
  %2 = icmp sge i64 %1, 1
  %3 = icmp sge i64 %0, 1
  %4 = and i1 %2, %3
  br i1 %4, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit15, %polly.split_new_and_old
  ret void

polly.then:                                       ; preds = %polly.split_new_and_old
  %5 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %5
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit15
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit15 ], [ 0, %polly.then ]
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
  %17 = mul i64 -3, %polly.indvar
  %18 = add i64 %17, %0
  %19 = add i64 %18, 5
  %20 = sub i64 %19, 32
  %21 = add i64 %20, 1
  %22 = icmp slt i64 %19, 0
  %23 = select i1 %22, i64 %21, i64 %19
  %24 = sdiv i64 %23, 32
  %25 = mul i64 -32, %24
  %26 = add i64 %16, %25
  %27 = add i64 %26, -640
  %28 = icmp sgt i64 %15, %27
  %29 = select i1 %28, i64 %15, i64 %27
  %30 = mul i64 -20, %polly.indvar
  %polly.loop_guard16 = icmp sle i64 %29, %30
  br i1 %polly.loop_guard16, label %polly.loop_header13, label %polly.loop_exit15

polly.loop_exit15:                                ; preds = %polly.loop_exit24, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %5, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header13:                              ; preds = %polly.loop_header, %polly.loop_exit24
  %polly.indvar17 = phi i64 [ %polly.indvar_next18, %polly.loop_exit24 ], [ %29, %polly.loop_header ]
  %31 = mul i64 -1, %polly.indvar17
  %32 = mul i64 -1, %0
  %33 = add i64 %31, %32
  %34 = add i64 %33, -30
  %35 = add i64 %34, 20
  %36 = sub i64 %35, 1
  %37 = icmp slt i64 %34, 0
  %38 = select i1 %37, i64 %34, i64 %36
  %39 = sdiv i64 %38, 20
  %40 = icmp sgt i64 %39, %polly.indvar
  %41 = select i1 %40, i64 %39, i64 %polly.indvar
  %42 = sub i64 %31, 20
  %43 = add i64 %42, 1
  %44 = icmp slt i64 %31, 0
  %45 = select i1 %44, i64 %43, i64 %31
  %46 = sdiv i64 %45, 20
  %47 = add i64 %polly.indvar, 31
  %48 = icmp slt i64 %46, %47
  %49 = select i1 %48, i64 %46, i64 %47
  %50 = icmp slt i64 %49, %5
  %51 = select i1 %50, i64 %49, i64 %5
  %polly.loop_guard25 = icmp sle i64 %41, %51
  br i1 %polly.loop_guard25, label %polly.loop_header22, label %polly.loop_exit24

polly.loop_exit24:                                ; preds = %polly.loop_exit33, %polly.loop_header13
  %polly.indvar_next18 = add nsw i64 %polly.indvar17, 32
  %polly.adjust_ub19 = sub i64 %30, 32
  %polly.loop_cond20 = icmp sle i64 %polly.indvar17, %polly.adjust_ub19
  br i1 %polly.loop_cond20, label %polly.loop_header13, label %polly.loop_exit15

polly.loop_header22:                              ; preds = %polly.loop_header13, %polly.loop_exit33
  %polly.indvar26 = phi i64 [ %polly.indvar_next27, %polly.loop_exit33 ], [ %41, %polly.loop_header13 ]
  %52 = mul i64 -20, %polly.indvar26
  %53 = add i64 %52, %32
  %54 = add i64 %53, 1
  %55 = icmp sgt i64 %polly.indvar17, %54
  %56 = select i1 %55, i64 %polly.indvar17, i64 %54
  %57 = add i64 %polly.indvar17, 31
  %58 = icmp slt i64 %52, %57
  %59 = select i1 %58, i64 %52, i64 %57
  %polly.loop_guard34 = icmp sle i64 %56, %59
  br i1 %polly.loop_guard34, label %polly.loop_header31, label %polly.loop_exit33

polly.loop_exit33:                                ; preds = %polly.loop_header31, %polly.loop_header22
  %polly.indvar_next27 = add nsw i64 %polly.indvar26, 1
  %polly.adjust_ub28 = sub i64 %51, 1
  %polly.loop_cond29 = icmp sle i64 %polly.indvar26, %polly.adjust_ub28
  br i1 %polly.loop_cond29, label %polly.loop_header22, label %polly.loop_exit24

polly.loop_header31:                              ; preds = %polly.loop_header22, %polly.loop_header31
  %polly.indvar35 = phi i64 [ %polly.indvar_next36, %polly.loop_header31 ], [ %56, %polly.loop_header22 ]
  %60 = mul i64 -1, %polly.indvar35
  %61 = add i64 %52, %60
  %p_.moved.to.8 = add i64 %0, %polly.indvar26
  %p_.moved.to.9 = sitofp i32 %n to double
  %p_scevgep = getelementptr [1000 x double]* %u, i64 %polly.indvar26, i64 %61
  %p_ = mul i64 %61, -1
  %p_39 = add i64 %p_.moved.to.8, %p_
  %p_40 = trunc i64 %p_39 to i32
  %p_41 = sitofp i32 %p_40 to double
  %p_42 = fdiv double %p_41, %p_.moved.to.9
  store double %p_42, double* %p_scevgep
  %p_indvar.next = add i64 %61, 1
  %polly.indvar_next36 = add nsw i64 %polly.indvar35, 1
  %polly.adjust_ub37 = sub i64 %59, 1
  %polly.loop_cond38 = icmp sle i64 %polly.indvar35, %polly.adjust_ub37
  br i1 %polly.loop_cond38, label %polly.loop_header31, label %polly.loop_exit33
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_adi(i32 %tsteps, i32 %n, [1000 x double]* %u, [1000 x double]* %v, [1000 x double]* %p, [1000 x double]* %q) #0 {
.split:
  %0 = sitofp i32 %n to double
  %1 = fdiv double 1.000000e+00, %0
  %2 = sitofp i32 %tsteps to double
  %3 = fdiv double 1.000000e+00, %2
  %4 = fmul double %3, 2.000000e+00
  %5 = fmul double %1, %1
  %6 = fdiv double %4, %5
  %7 = fdiv double %3, %5
  %8 = fmul double %6, -5.000000e-01
  %9 = fadd double %6, 1.000000e+00
  %10 = fmul double %7, -5.000000e-01
  %11 = fadd double %7, 1.000000e+00
  %12 = icmp slt i32 %tsteps, 1
  br i1 %12, label %._crit_edge23, label %.preheader1.lr.ph

.preheader1.lr.ph:                                ; preds = %.split
  %13 = add i32 %n, -3
  %14 = zext i32 %13 to i64
  %15 = add i64 %14, 1
  %16 = add i32 %n, -2
  %17 = zext i32 %16 to i64
  %18 = sext i32 %16 to i64
  %19 = add i32 %n, -1
  %20 = zext i32 %19 to i64
  %21 = sext i32 %19 to i64
  %22 = add nsw i32 %n, -1
  %23 = icmp sgt i32 %22, 1
  %24 = add nsw i32 %n, -2
  %25 = icmp sgt i32 %24, 0
  %26 = fsub double -0.000000e+00, %10
  %27 = fmul double %8, 2.000000e+00
  %28 = fadd double %27, 1.000000e+00
  %29 = fsub double -0.000000e+00, %8
  %30 = fmul double %10, 2.000000e+00
  %31 = fadd double %30, 1.000000e+00
  br label %.preheader1

.preheader1:                                      ; preds = %._crit_edge21, %.preheader1.lr.ph
  %indvar88 = phi i32 [ %indvar.next89, %._crit_edge21 ], [ 0, %.preheader1.lr.ph ]
  br i1 %23, label %.lr.ph9, label %.preheader

.preheader:                                       ; preds = %._crit_edge6, %.preheader1
  br i1 %23, label %.lr.ph20, label %._crit_edge21

.lr.ph9:                                          ; preds = %.preheader1, %._crit_edge6
  %indvar24 = phi i64 [ %32, %._crit_edge6 ], [ 0, %.preheader1 ]
  %32 = add i64 %indvar24, 1
  %33 = add i64 %indvar24, 2
  %scevgep49 = getelementptr [1000 x double]* %v, i64 0, i64 %32
  %scevgep51 = getelementptr [1000 x double]* %p, i64 %32, i64 0
  %scevgep52 = getelementptr [1000 x double]* %q, i64 %32, i64 0
  %scevgep53 = getelementptr [1000 x double]* %v, i64 %21, i64 %32
  store double 1.000000e+00, double* %scevgep49, align 8, !tbaa !6
  store double 0.000000e+00, double* %scevgep51, align 8, !tbaa !6
  %34 = load double* %scevgep49, align 8, !tbaa !6
  store double %34, double* %scevgep52, align 8, !tbaa !6
  br i1 %23, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %.lr.ph9, %.lr.ph
  %indvar = phi i64 [ %35, %.lr.ph ], [ 0, %.lr.ph9 ]
  %35 = add i64 %indvar, 1
  %scevgep28 = getelementptr [1000 x double]* %u, i64 %35, i64 %33
  %scevgep26 = getelementptr [1000 x double]* %u, i64 %35, i64 %indvar24
  %scevgep31 = getelementptr [1000 x double]* %q, i64 %32, i64 %indvar
  %scevgep30 = getelementptr [1000 x double]* %p, i64 %32, i64 %indvar
  %scevgep29 = getelementptr [1000 x double]* %q, i64 %32, i64 %35
  %scevgep27 = getelementptr [1000 x double]* %u, i64 %35, i64 %32
  %scevgep = getelementptr [1000 x double]* %p, i64 %32, i64 %35
  %36 = load double* %scevgep30, align 8, !tbaa !6
  %37 = fmul double %8, %36
  %38 = fadd double %9, %37
  %39 = fdiv double %29, %38
  store double %39, double* %scevgep, align 8, !tbaa !6
  %40 = load double* %scevgep26, align 8, !tbaa !6
  %41 = fmul double %10, %40
  %42 = load double* %scevgep27, align 8, !tbaa !6
  %43 = fmul double %31, %42
  %44 = fsub double %43, %41
  %45 = load double* %scevgep28, align 8, !tbaa !6
  %46 = fmul double %10, %45
  %47 = fsub double %44, %46
  %48 = load double* %scevgep31, align 8, !tbaa !6
  %49 = fmul double %8, %48
  %50 = fsub double %47, %49
  %51 = load double* %scevgep30, align 8, !tbaa !6
  %52 = fmul double %8, %51
  %53 = fadd double %9, %52
  %54 = fdiv double %50, %53
  store double %54, double* %scevgep29, align 8, !tbaa !6
  %exitcond = icmp ne i64 %35, %15
  br i1 %exitcond, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %.lr.ph9
  store double 1.000000e+00, double* %scevgep53, align 8, !tbaa !6
  br i1 %25, label %.lr.ph5, label %._crit_edge6

.lr.ph5:                                          ; preds = %._crit_edge, %.lr.ph5
  %indvar32 = phi i64 [ %indvar.next33, %.lr.ph5 ], [ 0, %._crit_edge ]
  %55 = mul i64 %indvar32, -1
  %56 = add i64 %18, %55
  %scevgep37 = getelementptr [1000 x double]* %v, i64 %56, i64 %32
  %scevgep36 = getelementptr [1000 x double]* %q, i64 %32, i64 %56
  %scevgep35 = getelementptr [1000 x double]* %p, i64 %32, i64 %56
  %57 = add i64 %20, %55
  %58 = trunc i64 %57 to i32
  %59 = sext i32 %58 to i64
  %60 = mul i64 %59, 1000
  %scevgep50 = getelementptr double* %scevgep49, i64 %60
  %61 = load double* %scevgep35, align 8, !tbaa !6
  %62 = load double* %scevgep50, align 8, !tbaa !6
  %63 = fmul double %61, %62
  %64 = load double* %scevgep36, align 8, !tbaa !6
  %65 = fadd double %63, %64
  store double %65, double* %scevgep37, align 8, !tbaa !6
  %indvar.next33 = add i64 %indvar32, 1
  %exitcond34 = icmp ne i64 %indvar.next33, %17
  br i1 %exitcond34, label %.lr.ph5, label %._crit_edge6

._crit_edge6:                                     ; preds = %.lr.ph5, %._crit_edge
  %exitcond38 = icmp ne i64 %32, %15
  br i1 %exitcond38, label %.lr.ph9, label %.preheader

.lr.ph20:                                         ; preds = %.preheader, %._crit_edge17
  %indvar57 = phi i64 [ %66, %._crit_edge17 ], [ 0, %.preheader ]
  %66 = add i64 %indvar57, 1
  %67 = add i64 %indvar57, 2
  %scevgep83 = getelementptr [1000 x double]* %u, i64 %66, i64 0
  %scevgep85 = getelementptr [1000 x double]* %p, i64 %66, i64 0
  %scevgep86 = getelementptr [1000 x double]* %q, i64 %66, i64 0
  %scevgep87 = getelementptr [1000 x double]* %u, i64 %66, i64 %21
  store double 1.000000e+00, double* %scevgep83, align 8, !tbaa !6
  store double 0.000000e+00, double* %scevgep85, align 8, !tbaa !6
  %68 = load double* %scevgep83, align 8, !tbaa !6
  store double %68, double* %scevgep86, align 8, !tbaa !6
  br i1 %23, label %.lr.ph12, label %._crit_edge13

.lr.ph12:                                         ; preds = %.lr.ph20, %.lr.ph12
  %indvar54 = phi i64 [ %69, %.lr.ph12 ], [ 0, %.lr.ph20 ]
  %69 = add i64 %indvar54, 1
  %scevgep62 = getelementptr [1000 x double]* %v, i64 %67, i64 %69
  %scevgep60 = getelementptr [1000 x double]* %v, i64 %indvar57, i64 %69
  %scevgep65 = getelementptr [1000 x double]* %q, i64 %66, i64 %indvar54
  %scevgep64 = getelementptr [1000 x double]* %p, i64 %66, i64 %indvar54
  %scevgep63 = getelementptr [1000 x double]* %q, i64 %66, i64 %69
  %scevgep61 = getelementptr [1000 x double]* %v, i64 %66, i64 %69
  %scevgep59 = getelementptr [1000 x double]* %p, i64 %66, i64 %69
  %70 = load double* %scevgep64, align 8, !tbaa !6
  %71 = fmul double %10, %70
  %72 = fadd double %11, %71
  %73 = fdiv double %26, %72
  store double %73, double* %scevgep59, align 8, !tbaa !6
  %74 = load double* %scevgep60, align 8, !tbaa !6
  %75 = fmul double %8, %74
  %76 = load double* %scevgep61, align 8, !tbaa !6
  %77 = fmul double %28, %76
  %78 = fsub double %77, %75
  %79 = load double* %scevgep62, align 8, !tbaa !6
  %80 = fmul double %8, %79
  %81 = fsub double %78, %80
  %82 = load double* %scevgep65, align 8, !tbaa !6
  %83 = fmul double %10, %82
  %84 = fsub double %81, %83
  %85 = load double* %scevgep64, align 8, !tbaa !6
  %86 = fmul double %10, %85
  %87 = fadd double %11, %86
  %88 = fdiv double %84, %87
  store double %88, double* %scevgep63, align 8, !tbaa !6
  %exitcond56 = icmp ne i64 %69, %15
  br i1 %exitcond56, label %.lr.ph12, label %._crit_edge13

._crit_edge13:                                    ; preds = %.lr.ph12, %.lr.ph20
  store double 1.000000e+00, double* %scevgep87, align 8, !tbaa !6
  br i1 %25, label %.lr.ph16, label %._crit_edge17

.lr.ph16:                                         ; preds = %._crit_edge13, %.lr.ph16
  %indvar66 = phi i64 [ %indvar.next67, %.lr.ph16 ], [ 0, %._crit_edge13 ]
  %89 = mul i64 %indvar66, -1
  %90 = add i64 %18, %89
  %scevgep71 = getelementptr [1000 x double]* %u, i64 %66, i64 %90
  %scevgep70 = getelementptr [1000 x double]* %q, i64 %66, i64 %90
  %scevgep69 = getelementptr [1000 x double]* %p, i64 %66, i64 %90
  %91 = add i64 %20, %89
  %92 = trunc i64 %91 to i32
  %93 = sext i32 %92 to i64
  %scevgep84 = getelementptr double* %scevgep83, i64 %93
  %94 = load double* %scevgep69, align 8, !tbaa !6
  %95 = load double* %scevgep84, align 8, !tbaa !6
  %96 = fmul double %94, %95
  %97 = load double* %scevgep70, align 8, !tbaa !6
  %98 = fadd double %96, %97
  store double %98, double* %scevgep71, align 8, !tbaa !6
  %indvar.next67 = add i64 %indvar66, 1
  %exitcond68 = icmp ne i64 %indvar.next67, %17
  br i1 %exitcond68, label %.lr.ph16, label %._crit_edge17

._crit_edge17:                                    ; preds = %.lr.ph16, %._crit_edge13
  %exitcond72 = icmp ne i64 %66, %15
  br i1 %exitcond72, label %.lr.ph20, label %._crit_edge21

._crit_edge21:                                    ; preds = %._crit_edge17, %.preheader
  %indvar.next89 = add i32 %indvar88, 1
  %exitcond90 = icmp ne i32 %indvar.next89, %tsteps
  br i1 %exitcond90, label %.preheader1, label %._crit_edge23

._crit_edge23:                                    ; preds = %._crit_edge21, %.split
  ret void
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, [1000 x double]* %u) #0 {
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
  %scevgep = getelementptr [1000 x double]* %u, i64 %indvar4, i64 %indvar
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
