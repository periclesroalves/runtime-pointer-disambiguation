; ModuleID = './linear-algebra/kernels/atax/atax.c'
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
  %0 = tail call i8* @polybench_alloc_data(i64 3990000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 2100, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 2100, i32 8) #3
  %3 = tail call i8* @polybench_alloc_data(i64 1900, i32 8) #3
  %4 = bitcast i8* %0 to [2100 x double]*
  %5 = bitcast i8* %1 to double*
  tail call void @init_array(i32 1900, i32 2100, [2100 x double]* %4, double* %5)
  tail call void (...)* @polybench_timer_start() #3
  %6 = bitcast i8* %2 to double*
  %7 = bitcast i8* %3 to double*
  tail call void @kernel_atax(i32 1900, i32 2100, [2100 x double]* %4, double* %5, double* %6, double* %7)
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
  tail call void @print_array(i32 2100, double* %6)
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
define internal void @init_array(i32 %m, i32 %n, [2100 x double]* noalias %A, double* noalias %x) #0 {
polly.split_new_and_old:
  %0 = zext i32 %n to i64
  %1 = zext i32 %m to i64
  %2 = sext i32 %n to i64
  %3 = icmp sge i64 %2, 1
  %4 = icmp sge i64 %0, 1
  %5 = and i1 %3, %4
  br i1 %5, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.then26, %polly.loop_exit39, %polly.cond24, %polly.split_new_and_old
  ret void

polly.then:                                       ; preds = %polly.split_new_and_old
  %6 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %6
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond24

polly.cond24:                                     ; preds = %polly.then, %polly.loop_header
  %7 = sext i32 %m to i64
  %8 = icmp sge i64 %7, 1
  %9 = icmp sge i64 %1, 1
  %10 = and i1 %8, %9
  br i1 %10, label %polly.then26, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_.moved.to. = sitofp i32 %n to double
  %p_i.06 = trunc i64 %polly.indvar to i32
  %p_scevgep16 = getelementptr double* %x, i64 %polly.indvar
  %p_ = sitofp i32 %p_i.06 to double
  %p_22 = fdiv double %p_, %p_.moved.to.
  %p_23 = fadd double %p_22, 1.000000e+00
  store double %p_23, double* %p_scevgep16
  %p_indvar.next14 = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %6, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond24

polly.then26:                                     ; preds = %polly.cond24
  %11 = add i64 %1, -1
  %polly.loop_guard31 = icmp sle i64 0, %11
  br i1 %polly.loop_guard31, label %polly.loop_header28, label %polly.merge

polly.loop_header28:                              ; preds = %polly.then26, %polly.loop_exit39
  %polly.indvar32 = phi i64 [ %polly.indvar_next33, %polly.loop_exit39 ], [ 0, %polly.then26 ]
  %12 = mul i64 -3, %1
  %13 = add i64 %0, %12
  %14 = add i64 %13, 5
  %15 = sub i64 %14, 32
  %16 = add i64 %15, 1
  %17 = icmp slt i64 %14, 0
  %18 = select i1 %17, i64 %16, i64 %14
  %19 = sdiv i64 %18, 32
  %20 = mul i64 -32, %19
  %21 = mul i64 -32, %1
  %22 = add i64 %20, %21
  %23 = mul i64 -32, %polly.indvar32
  %24 = mul i64 -3, %polly.indvar32
  %25 = add i64 %24, %0
  %26 = add i64 %25, 5
  %27 = sub i64 %26, 32
  %28 = add i64 %27, 1
  %29 = icmp slt i64 %26, 0
  %30 = select i1 %29, i64 %28, i64 %26
  %31 = sdiv i64 %30, 32
  %32 = mul i64 -32, %31
  %33 = add i64 %23, %32
  %34 = add i64 %33, -640
  %35 = icmp sgt i64 %22, %34
  %36 = select i1 %35, i64 %22, i64 %34
  %37 = mul i64 -20, %polly.indvar32
  %polly.loop_guard40 = icmp sle i64 %36, %37
  br i1 %polly.loop_guard40, label %polly.loop_header37, label %polly.loop_exit39

polly.loop_exit39:                                ; preds = %polly.loop_exit48, %polly.loop_header28
  %polly.indvar_next33 = add nsw i64 %polly.indvar32, 32
  %polly.adjust_ub34 = sub i64 %11, 32
  %polly.loop_cond35 = icmp sle i64 %polly.indvar32, %polly.adjust_ub34
  br i1 %polly.loop_cond35, label %polly.loop_header28, label %polly.merge

polly.loop_header37:                              ; preds = %polly.loop_header28, %polly.loop_exit48
  %polly.indvar41 = phi i64 [ %polly.indvar_next42, %polly.loop_exit48 ], [ %36, %polly.loop_header28 ]
  %38 = mul i64 -1, %polly.indvar41
  %39 = mul i64 -1, %0
  %40 = add i64 %38, %39
  %41 = add i64 %40, -30
  %42 = add i64 %41, 20
  %43 = sub i64 %42, 1
  %44 = icmp slt i64 %41, 0
  %45 = select i1 %44, i64 %41, i64 %43
  %46 = sdiv i64 %45, 20
  %47 = icmp sgt i64 %46, %polly.indvar32
  %48 = select i1 %47, i64 %46, i64 %polly.indvar32
  %49 = sub i64 %38, 20
  %50 = add i64 %49, 1
  %51 = icmp slt i64 %38, 0
  %52 = select i1 %51, i64 %50, i64 %38
  %53 = sdiv i64 %52, 20
  %54 = add i64 %polly.indvar32, 31
  %55 = icmp slt i64 %53, %54
  %56 = select i1 %55, i64 %53, i64 %54
  %57 = icmp slt i64 %56, %11
  %58 = select i1 %57, i64 %56, i64 %11
  %polly.loop_guard49 = icmp sle i64 %48, %58
  br i1 %polly.loop_guard49, label %polly.loop_header46, label %polly.loop_exit48

polly.loop_exit48:                                ; preds = %polly.loop_exit57, %polly.loop_header37
  %polly.indvar_next42 = add nsw i64 %polly.indvar41, 32
  %polly.adjust_ub43 = sub i64 %37, 32
  %polly.loop_cond44 = icmp sle i64 %polly.indvar41, %polly.adjust_ub43
  br i1 %polly.loop_cond44, label %polly.loop_header37, label %polly.loop_exit39

polly.loop_header46:                              ; preds = %polly.loop_header37, %polly.loop_exit57
  %polly.indvar50 = phi i64 [ %polly.indvar_next51, %polly.loop_exit57 ], [ %48, %polly.loop_header37 ]
  %59 = mul i64 -20, %polly.indvar50
  %60 = add i64 %59, %39
  %61 = add i64 %60, 1
  %62 = icmp sgt i64 %polly.indvar41, %61
  %63 = select i1 %62, i64 %polly.indvar41, i64 %61
  %64 = add i64 %polly.indvar41, 31
  %65 = icmp slt i64 %59, %64
  %66 = select i1 %65, i64 %59, i64 %64
  %polly.loop_guard58 = icmp sle i64 %63, %66
  br i1 %polly.loop_guard58, label %polly.loop_header55, label %polly.loop_exit57

polly.loop_exit57:                                ; preds = %polly.loop_header55, %polly.loop_header46
  %polly.indvar_next51 = add nsw i64 %polly.indvar50, 1
  %polly.adjust_ub52 = sub i64 %58, 1
  %polly.loop_cond53 = icmp sle i64 %polly.indvar50, %polly.adjust_ub52
  br i1 %polly.loop_cond53, label %polly.loop_header46, label %polly.loop_exit48

polly.loop_header55:                              ; preds = %polly.loop_header46, %polly.loop_header55
  %polly.indvar59 = phi i64 [ %polly.indvar_next60, %polly.loop_header55 ], [ %63, %polly.loop_header46 ]
  %67 = mul i64 -1, %polly.indvar59
  %68 = add i64 %59, %67
  %p_.moved.to.18 = mul nsw i32 %m, 5
  %p_.moved.to.19 = sitofp i32 %p_.moved.to.18 to double
  %p_64 = add i64 %polly.indvar50, %68
  %p_65 = trunc i64 %p_64 to i32
  %p_scevgep = getelementptr [2100 x double]* %A, i64 %polly.indvar50, i64 %68
  %p_66 = srem i32 %p_65, %n
  %p_67 = sitofp i32 %p_66 to double
  %p_68 = fdiv double %p_67, %p_.moved.to.19
  store double %p_68, double* %p_scevgep
  %p_indvar.next = add i64 %68, 1
  %polly.indvar_next60 = add nsw i64 %polly.indvar59, 1
  %polly.adjust_ub61 = sub i64 %66, 1
  %polly.loop_cond62 = icmp sle i64 %polly.indvar59, %polly.adjust_ub61
  br i1 %polly.loop_cond62, label %polly.loop_header55, label %polly.loop_exit57
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_atax(i32 %m, i32 %n, [2100 x double]* noalias %A, double* noalias %x, double* noalias %y, double* noalias %tmp) #0 {
polly.split_new_and_old:
  %0 = zext i32 %n to i64
  %1 = zext i32 %m to i64
  %2 = sext i32 %m to i64
  %3 = icmp sge i64 %2, 1
  br i1 %3, label %polly.stmt..lr.ph6, label %polly.cond31

polly.cond31:                                     ; preds = %polly.split_new_and_old, %polly.stmt..lr.ph6
  %4 = icmp sge i64 %1, 1
  %5 = and i1 %3, %4
  br i1 %5, label %polly.then33, label %polly.cond35

polly.cond35:                                     ; preds = %polly.then33, %polly.loop_header, %polly.cond31
  %6 = sext i32 %n to i64
  %7 = icmp sge i64 %6, 1
  %8 = icmp sge i64 %0, 1
  %9 = and i1 %7, %8
  br i1 %9, label %polly.then37, label %polly.cond48

polly.cond48:                                     ; preds = %polly.then37, %polly.loop_header39, %polly.cond35
  %10 = and i1 %3, %7
  %11 = and i1 %10, %4
  br i1 %11, label %polly.cond51, label %polly.cond95

polly.cond95:                                     ; preds = %polly.then79, %polly.loop_header81, %polly.cond77, %polly.cond48
  br i1 %11, label %polly.cond98, label %polly.merge96

polly.merge96:                                    ; preds = %polly.then127, %polly.loop_header129, %polly.cond125, %polly.cond95
  ret void

polly.stmt..lr.ph6:                               ; preds = %polly.split_new_and_old
  br label %polly.cond31

polly.then33:                                     ; preds = %polly.cond31
  %12 = add i64 %1, -1
  %polly.loop_guard = icmp sle i64 0, %12
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond35

polly.loop_header:                                ; preds = %polly.then33, %polly.loop_header
  %i.15.reg2mem.1 = phi i32 [ 0, %polly.then33 ], [ %p_, %polly.loop_header ]
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then33 ]
  %p_scevgep22 = getelementptr double* %tmp, i64 %polly.indvar
  store double 0.000000e+00, double* %p_scevgep22
  %p_ = add nsw i32 %i.15.reg2mem.1, 1
  %p_indvar.next12 = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %12, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond35

polly.then37:                                     ; preds = %polly.cond35
  %13 = add i64 %0, -1
  %polly.loop_guard42 = icmp sle i64 0, %13
  br i1 %polly.loop_guard42, label %polly.loop_header39, label %polly.cond48

polly.loop_header39:                              ; preds = %polly.then37, %polly.loop_header39
  %polly.indvar43 = phi i64 [ %polly.indvar_next44, %polly.loop_header39 ], [ 0, %polly.then37 ]
  %p_scevgep26 = getelementptr double* %y, i64 %polly.indvar43
  store double 0.000000e+00, double* %p_scevgep26
  %p_indvar.next24 = add i64 %polly.indvar43, 1
  %polly.indvar_next44 = add nsw i64 %polly.indvar43, 1
  %polly.adjust_ub45 = sub i64 %13, 1
  %polly.loop_cond46 = icmp sle i64 %polly.indvar43, %polly.adjust_ub45
  br i1 %polly.loop_cond46, label %polly.loop_header39, label %polly.cond48

polly.cond51:                                     ; preds = %polly.cond48
  br i1 %8, label %polly.then53, label %polly.cond77

polly.cond77:                                     ; preds = %polly.then53, %polly.loop_exit66, %polly.cond51
  %14 = icmp sle i64 %0, 0
  br i1 %14, label %polly.then79, label %polly.cond95

polly.then53:                                     ; preds = %polly.cond51
  %15 = add i64 %1, -1
  %polly.loop_guard58 = icmp sle i64 0, %15
  br i1 %polly.loop_guard58, label %polly.loop_header55, label %polly.cond77

polly.loop_header55:                              ; preds = %polly.then53, %polly.loop_exit66
  %polly.indvar59 = phi i64 [ %polly.indvar_next60, %polly.loop_exit66 ], [ 0, %polly.then53 ]
  %p_scevgep22.moved.to..lr.ph = getelementptr double* %tmp, i64 %polly.indvar59
  %.promoted_p_scalar_ = load double* %p_scevgep22.moved.to..lr.ph
  %16 = add i64 %0, -1
  %polly.loop_guard67 = icmp sle i64 0, %16
  br i1 %polly.loop_guard67, label %polly.loop_header64, label %polly.loop_exit66

polly.loop_exit66:                                ; preds = %polly.loop_header64, %polly.loop_header55
  %.reg2mem.0 = phi double [ %p_75, %polly.loop_header64 ], [ %.promoted_p_scalar_, %polly.loop_header55 ]
  store double %.reg2mem.0, double* %p_scevgep22.moved.to..lr.ph
  %polly.indvar_next60 = add nsw i64 %polly.indvar59, 1
  %polly.adjust_ub61 = sub i64 %15, 1
  %polly.loop_cond62 = icmp sle i64 %polly.indvar59, %polly.adjust_ub61
  br i1 %polly.loop_cond62, label %polly.loop_header55, label %polly.cond77

polly.loop_header64:                              ; preds = %polly.loop_header55, %polly.loop_header64
  %.reg2mem.1 = phi double [ %.promoted_p_scalar_, %polly.loop_header55 ], [ %p_75, %polly.loop_header64 ]
  %polly.indvar68 = phi i64 [ %polly.indvar_next69, %polly.loop_header64 ], [ 0, %polly.loop_header55 ]
  %p_scevgep = getelementptr [2100 x double]* %A, i64 %polly.indvar59, i64 %polly.indvar68
  %p_scevgep13 = getelementptr double* %x, i64 %polly.indvar68
  %_p_scalar_ = load double* %p_scevgep
  %_p_scalar_73 = load double* %p_scevgep13
  %p_74 = fmul double %_p_scalar_, %_p_scalar_73
  %p_75 = fadd double %.reg2mem.1, %p_74
  %p_indvar.next = add i64 %polly.indvar68, 1
  %polly.indvar_next69 = add nsw i64 %polly.indvar68, 1
  %polly.adjust_ub70 = sub i64 %16, 1
  %polly.loop_cond71 = icmp sle i64 %polly.indvar68, %polly.adjust_ub70
  br i1 %polly.loop_cond71, label %polly.loop_header64, label %polly.loop_exit66

polly.then79:                                     ; preds = %polly.cond77
  %17 = add i64 %1, -1
  %polly.loop_guard84 = icmp sle i64 0, %17
  br i1 %polly.loop_guard84, label %polly.loop_header81, label %polly.cond95

polly.loop_header81:                              ; preds = %polly.then79, %polly.loop_header81
  %polly.indvar85 = phi i64 [ %polly.indvar_next86, %polly.loop_header81 ], [ 0, %polly.then79 ]
  %p_scevgep22.moved.to..lr.ph90 = getelementptr double* %tmp, i64 %polly.indvar85
  %.promoted_p_scalar_91 = load double* %p_scevgep22.moved.to..lr.ph90
  store double %.promoted_p_scalar_91, double* %p_scevgep22.moved.to..lr.ph90
  %polly.indvar_next86 = add nsw i64 %polly.indvar85, 1
  %polly.adjust_ub87 = sub i64 %17, 1
  %polly.loop_cond88 = icmp sle i64 %polly.indvar85, %polly.adjust_ub87
  br i1 %polly.loop_cond88, label %polly.loop_header81, label %polly.cond95

polly.cond98:                                     ; preds = %polly.cond95
  br i1 %8, label %polly.then100, label %polly.cond125

polly.cond125:                                    ; preds = %polly.then100, %polly.loop_exit114, %polly.cond98
  %18 = icmp sle i64 %0, 0
  br i1 %18, label %polly.then127, label %polly.merge96

polly.then100:                                    ; preds = %polly.cond98
  %19 = add i64 %1, -1
  %polly.loop_guard105 = icmp sle i64 0, %19
  br i1 %polly.loop_guard105, label %polly.loop_header102, label %polly.cond125

polly.loop_header102:                             ; preds = %polly.then100, %polly.loop_exit114
  %polly.indvar106 = phi i64 [ %polly.indvar_next107, %polly.loop_exit114 ], [ 0, %polly.then100 ]
  %p_scevgep22.moved.to..lr.ph4 = getelementptr double* %tmp, i64 %polly.indvar106
  %_p_scalar_110 = load double* %p_scevgep22.moved.to..lr.ph4
  %20 = add i64 %0, -1
  %polly.loop_guard115 = icmp sle i64 0, %20
  br i1 %polly.loop_guard115, label %polly.loop_header112, label %polly.loop_exit114

polly.loop_exit114:                               ; preds = %polly.loop_header112, %polly.loop_header102
  %polly.indvar_next107 = add nsw i64 %polly.indvar106, 1
  %polly.adjust_ub108 = sub i64 %19, 1
  %polly.loop_cond109 = icmp sle i64 %polly.indvar106, %polly.adjust_ub108
  br i1 %polly.loop_cond109, label %polly.loop_header102, label %polly.cond125

polly.loop_header112:                             ; preds = %polly.loop_header102, %polly.loop_header112
  %polly.indvar116 = phi i64 [ %polly.indvar_next117, %polly.loop_header112 ], [ 0, %polly.loop_header102 ]
  %p_scevgep18 = getelementptr [2100 x double]* %A, i64 %polly.indvar106, i64 %polly.indvar116
  %p_scevgep17 = getelementptr double* %y, i64 %polly.indvar116
  %_p_scalar_121 = load double* %p_scevgep17
  %_p_scalar_122 = load double* %p_scevgep18
  %p_123 = fmul double %_p_scalar_122, %_p_scalar_110
  %p_124 = fadd double %_p_scalar_121, %p_123
  store double %p_124, double* %p_scevgep17
  %p_indvar.next15 = add i64 %polly.indvar116, 1
  %polly.indvar_next117 = add nsw i64 %polly.indvar116, 1
  %polly.adjust_ub118 = sub i64 %20, 1
  %polly.loop_cond119 = icmp sle i64 %polly.indvar116, %polly.adjust_ub118
  br i1 %polly.loop_cond119, label %polly.loop_header112, label %polly.loop_exit114

polly.then127:                                    ; preds = %polly.cond125
  %21 = add i64 %1, -1
  %polly.loop_guard132 = icmp sle i64 0, %21
  br i1 %polly.loop_guard132, label %polly.loop_header129, label %polly.merge96

polly.loop_header129:                             ; preds = %polly.then127, %polly.loop_header129
  %polly.indvar133 = phi i64 [ %polly.indvar_next134, %polly.loop_header129 ], [ 0, %polly.then127 ]
  %p_scevgep22.moved.to..lr.ph4138 = getelementptr double* %tmp, i64 %polly.indvar133
  %polly.indvar_next134 = add nsw i64 %polly.indvar133, 1
  %polly.adjust_ub135 = sub i64 %21, 1
  %polly.loop_cond136 = icmp sle i64 %polly.indvar133, %polly.adjust_ub135
  br i1 %polly.loop_cond136, label %polly.loop_header129, label %polly.merge96
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
