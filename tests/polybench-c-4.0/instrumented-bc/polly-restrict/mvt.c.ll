; ModuleID = './linear-algebra/kernels/mvt/mvt.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [3 x i8] c"x1\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [3 x i8] c"x2\00", align 1
@.str8 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %0 = tail call i8* @polybench_alloc_data(i64 4000000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %3 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %4 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %5 = bitcast i8* %1 to double*
  %6 = bitcast i8* %2 to double*
  %7 = bitcast i8* %3 to double*
  %8 = bitcast i8* %4 to double*
  %9 = bitcast i8* %0 to [2000 x double]*
  tail call void @init_array(i32 2000, double* %5, double* %6, double* %7, double* %8, [2000 x double]* %9)
  tail call void (...)* @polybench_timer_start() #3
  tail call void @kernel_mvt(i32 2000, double* %5, double* %6, double* %7, double* %8, [2000 x double]* %9)
  tail call void (...)* @polybench_timer_stop() #3
  tail call void (...)* @polybench_timer_print() #3
  %10 = icmp sgt i32 %argc, 42
  br i1 %10, label %11, label %15

; <label>:11                                      ; preds = %.split
  %12 = load i8** %argv, align 8, !tbaa !1
  %13 = load i8* %12, align 1, !tbaa !5
  %phitmp = icmp eq i8 %13, 0
  br i1 %phitmp, label %14, label %15

; <label>:14                                      ; preds = %11
  tail call void @print_array(i32 2000, double* %5, double* %6)
  br label %15

; <label>:15                                      ; preds = %11, %14, %.split
  tail call void @free(i8* %0) #3
  tail call void @free(i8* %1) #3
  tail call void @free(i8* %2) #3
  tail call void @free(i8* %3) #3
  tail call void @free(i8* %4) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %n, double* noalias %x1, double* noalias %x2, double* noalias %y_1, double* noalias %y_2, [2000 x double]* noalias %A) #0 {
polly.split_new_and_old:
  %0 = zext i32 %n to i64
  %1 = sext i32 %n to i64
  %2 = icmp sge i64 %1, 1
  %3 = icmp sge i64 %0, 1
  %4 = and i1 %2, %3
  br i1 %4, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.loop_exit, %polly.loop_header54, %polly.split_new_and_old
  ret void

polly.then:                                       ; preds = %polly.split_new_and_old
  %5 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %5
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.loop_exit

polly.loop_exit:                                  ; preds = %polly.loop_exit25, %polly.then
  br i1 %polly.loop_guard, label %polly.loop_header54, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit25
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit25 ], [ 0, %polly.then ]
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
  %polly.loop_guard26 = icmp sle i64 %29, %30
  br i1 %polly.loop_guard26, label %polly.loop_header23, label %polly.loop_exit25

polly.loop_exit25:                                ; preds = %polly.loop_exit34, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %5, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.loop_exit

polly.loop_header23:                              ; preds = %polly.loop_header, %polly.loop_exit34
  %polly.indvar27 = phi i64 [ %polly.indvar_next28, %polly.loop_exit34 ], [ %29, %polly.loop_header ]
  %31 = mul i64 -1, %polly.indvar27
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
  %polly.loop_guard35 = icmp sle i64 %41, %51
  br i1 %polly.loop_guard35, label %polly.loop_header32, label %polly.loop_exit34

polly.loop_exit34:                                ; preds = %polly.loop_exit43, %polly.loop_header23
  %polly.indvar_next28 = add nsw i64 %polly.indvar27, 32
  %polly.adjust_ub29 = sub i64 %30, 32
  %polly.loop_cond30 = icmp sle i64 %polly.indvar27, %polly.adjust_ub29
  br i1 %polly.loop_cond30, label %polly.loop_header23, label %polly.loop_exit25

polly.loop_header32:                              ; preds = %polly.loop_header23, %polly.loop_exit43
  %polly.indvar36 = phi i64 [ %polly.indvar_next37, %polly.loop_exit43 ], [ %41, %polly.loop_header23 ]
  %52 = mul i64 -20, %polly.indvar36
  %53 = add i64 %52, %32
  %54 = add i64 %53, 1
  %55 = icmp sgt i64 %polly.indvar27, %54
  %56 = select i1 %55, i64 %polly.indvar27, i64 %54
  %57 = add i64 %polly.indvar27, 31
  %58 = icmp slt i64 %52, %57
  %59 = select i1 %58, i64 %52, i64 %57
  %polly.loop_guard44 = icmp sle i64 %56, %59
  br i1 %polly.loop_guard44, label %polly.loop_header41, label %polly.loop_exit43

polly.loop_exit43:                                ; preds = %polly.loop_header41, %polly.loop_header32
  %polly.indvar_next37 = add nsw i64 %polly.indvar36, 1
  %polly.adjust_ub38 = sub i64 %51, 1
  %polly.loop_cond39 = icmp sle i64 %polly.indvar36, %polly.adjust_ub38
  br i1 %polly.loop_cond39, label %polly.loop_header32, label %polly.loop_exit34

polly.loop_header41:                              ; preds = %polly.loop_header32, %polly.loop_header41
  %polly.indvar45 = phi i64 [ %polly.indvar_next46, %polly.loop_header41 ], [ %56, %polly.loop_header32 ]
  %60 = mul i64 -1, %polly.indvar45
  %61 = add i64 %52, %60
  %p_.moved.to.19 = sitofp i32 %n to double
  %p_scevgep = getelementptr [2000 x double]* %A, i64 %polly.indvar36, i64 %61
  %p_ = mul i64 %polly.indvar36, %61
  %p_49 = trunc i64 %p_ to i32
  %p_50 = srem i32 %p_49, %n
  %p_51 = sitofp i32 %p_50 to double
  %p_52 = fdiv double %p_51, %p_.moved.to.19
  store double %p_52, double* %p_scevgep
  %p_indvar.next = add i64 %61, 1
  %polly.indvar_next46 = add nsw i64 %polly.indvar45, 1
  %polly.adjust_ub47 = sub i64 %59, 1
  %polly.loop_cond48 = icmp sle i64 %polly.indvar45, %polly.adjust_ub47
  br i1 %polly.loop_cond48, label %polly.loop_header41, label %polly.loop_exit43

polly.loop_header54:                              ; preds = %polly.loop_exit, %polly.loop_header54
  %polly.indvar58 = phi i64 [ %polly.indvar_next59, %polly.loop_header54 ], [ 0, %polly.loop_exit ]
  %p_.moved.to. = sitofp i32 %n to double
  %p_i.02 = trunc i64 %polly.indvar58 to i32
  %p_63 = add i64 %polly.indvar58, 1
  %p_64 = trunc i64 %p_63 to i32
  %p_scevgep11 = getelementptr double* %x1, i64 %polly.indvar58
  %p_scevgep12 = getelementptr double* %x2, i64 %polly.indvar58
  %p_65 = add i64 %polly.indvar58, 3
  %p_66 = trunc i64 %p_65 to i32
  %p_scevgep13 = getelementptr double* %y_1, i64 %polly.indvar58
  %p_67 = add i64 %polly.indvar58, 4
  %p_68 = trunc i64 %p_67 to i32
  %p_scevgep14 = getelementptr double* %y_2, i64 %polly.indvar58
  %p_69 = srem i32 %p_i.02, %n
  %p_70 = sitofp i32 %p_69 to double
  %p_71 = fdiv double %p_70, %p_.moved.to.
  store double %p_71, double* %p_scevgep11
  %p_72 = srem i32 %p_64, %n
  %p_73 = sitofp i32 %p_72 to double
  %p_74 = fdiv double %p_73, %p_.moved.to.
  store double %p_74, double* %p_scevgep12
  %p_75 = srem i32 %p_66, %n
  %p_76 = sitofp i32 %p_75 to double
  %p_77 = fdiv double %p_76, %p_.moved.to.
  store double %p_77, double* %p_scevgep13
  %p_78 = srem i32 %p_68, %n
  %p_79 = sitofp i32 %p_78 to double
  %p_80 = fdiv double %p_79, %p_.moved.to.
  store double %p_80, double* %p_scevgep14
  %polly.indvar_next59 = add nsw i64 %polly.indvar58, 1
  %polly.adjust_ub60 = sub i64 %5, 1
  %polly.loop_cond61 = icmp sle i64 %polly.indvar58, %polly.adjust_ub60
  br i1 %polly.loop_cond61, label %polly.loop_header54, label %polly.merge
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_mvt(i32 %n, double* noalias %x1, double* noalias %x2, double* noalias %y_1, double* noalias %y_2, [2000 x double]* noalias %A) #0 {
polly.split_new_and_old:
  %0 = zext i32 %n to i64
  %1 = sext i32 %n to i64
  %2 = icmp sge i64 %1, 1
  br i1 %2, label %polly.cond33, label %polly.merge

polly.merge:                                      ; preds = %polly.then91, %polly.loop_header93, %polly.stmt..preheader.lr.ph, %polly.split_new_and_old
  ret void

polly.cond33:                                     ; preds = %polly.split_new_and_old
  %3 = icmp sge i64 %0, 1
  br i1 %3, label %polly.then35, label %polly.stmt..preheader2.lr.ph

polly.stmt..preheader2.lr.ph:                     ; preds = %polly.then35, %polly.loop_exit39, %polly.cond33
  br i1 %3, label %polly.then50, label %polly.cond62

polly.cond62:                                     ; preds = %polly.then50, %polly.loop_header52, %polly.stmt..preheader2.lr.ph
  br i1 %3, label %polly.then64, label %polly.stmt..preheader.lr.ph

polly.stmt..preheader.lr.ph:                      ; preds = %polly.then64, %polly.loop_exit77, %polly.cond62
  br i1 %3, label %polly.then91, label %polly.merge

polly.then35:                                     ; preds = %polly.cond33
  %4 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %4
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.stmt..preheader2.lr.ph

polly.loop_header:                                ; preds = %polly.then35, %polly.loop_exit39
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit39 ], [ 0, %polly.then35 ]
  %p_scevgep15.moved.to..lr.ph = getelementptr double* %x2, i64 %polly.indvar
  %.promoted_p_scalar_ = load double* %p_scevgep15.moved.to..lr.ph
  br i1 %polly.loop_guard, label %polly.loop_header37, label %polly.loop_exit39

polly.loop_exit39:                                ; preds = %polly.loop_header37, %polly.loop_header
  %.reg2mem.0 = phi double [ %p_46, %polly.loop_header37 ], [ %.promoted_p_scalar_, %polly.loop_header ]
  store double %.reg2mem.0, double* %p_scevgep15.moved.to..lr.ph
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %4, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.stmt..preheader2.lr.ph

polly.loop_header37:                              ; preds = %polly.loop_header, %polly.loop_header37
  %.reg2mem.1 = phi double [ %.promoted_p_scalar_, %polly.loop_header ], [ %p_46, %polly.loop_header37 ]
  %polly.indvar41 = phi i64 [ %polly.indvar_next42, %polly.loop_header37 ], [ 0, %polly.loop_header ]
  %p_scevgep = getelementptr [2000 x double]* %A, i64 %polly.indvar41, i64 %polly.indvar
  %p_scevgep12 = getelementptr double* %y_2, i64 %polly.indvar41
  %_p_scalar_ = load double* %p_scevgep
  %_p_scalar_45 = load double* %p_scevgep12
  %p_ = fmul double %_p_scalar_, %_p_scalar_45
  %p_46 = fadd double %.reg2mem.1, %p_
  %p_indvar.next = add i64 %polly.indvar41, 1
  %polly.indvar_next42 = add nsw i64 %polly.indvar41, 1
  %polly.adjust_ub43 = sub i64 %4, 1
  %polly.loop_cond44 = icmp sle i64 %polly.indvar41, %polly.adjust_ub43
  br i1 %polly.loop_cond44, label %polly.loop_header37, label %polly.loop_exit39

polly.then50:                                     ; preds = %polly.stmt..preheader2.lr.ph
  %5 = add i64 %0, -1
  %polly.loop_guard55 = icmp sle i64 0, %5
  br i1 %polly.loop_guard55, label %polly.loop_header52, label %polly.cond62

polly.loop_header52:                              ; preds = %polly.then50, %polly.loop_header52
  %i.09.reg2mem.0 = phi i32 [ 0, %polly.then50 ], [ %p_61, %polly.loop_header52 ]
  %polly.indvar56 = phi i64 [ %polly.indvar_next57, %polly.loop_header52 ], [ 0, %polly.then50 ]
  %p_61 = add nsw i32 %i.09.reg2mem.0, 1
  %p_indvar.next20 = add i64 %polly.indvar56, 1
  %polly.indvar_next57 = add nsw i64 %polly.indvar56, 1
  %polly.adjust_ub58 = sub i64 %5, 1
  %polly.loop_cond59 = icmp sle i64 %polly.indvar56, %polly.adjust_ub58
  br i1 %polly.loop_cond59, label %polly.loop_header52, label %polly.cond62

polly.then64:                                     ; preds = %polly.cond62
  %6 = add i64 %0, -1
  %polly.loop_guard69 = icmp sle i64 0, %6
  br i1 %polly.loop_guard69, label %polly.loop_header66, label %polly.stmt..preheader.lr.ph

polly.loop_header66:                              ; preds = %polly.then64, %polly.loop_exit77
  %polly.indvar70 = phi i64 [ %polly.indvar_next71, %polly.loop_exit77 ], [ 0, %polly.then64 ]
  %p_scevgep27.moved.to..lr.ph7 = getelementptr double* %x1, i64 %polly.indvar70
  %.promoted23_p_scalar_ = load double* %p_scevgep27.moved.to..lr.ph7
  br i1 %polly.loop_guard69, label %polly.loop_header75, label %polly.loop_exit77

polly.loop_exit77:                                ; preds = %polly.loop_header75, %polly.loop_header66
  %.reg2mem28.0 = phi double [ %p_87, %polly.loop_header75 ], [ %.promoted23_p_scalar_, %polly.loop_header66 ]
  store double %.reg2mem28.0, double* %p_scevgep27.moved.to..lr.ph7
  %polly.indvar_next71 = add nsw i64 %polly.indvar70, 1
  %polly.adjust_ub72 = sub i64 %6, 1
  %polly.loop_cond73 = icmp sle i64 %polly.indvar70, %polly.adjust_ub72
  br i1 %polly.loop_cond73, label %polly.loop_header66, label %polly.stmt..preheader.lr.ph

polly.loop_header75:                              ; preds = %polly.loop_header66, %polly.loop_header75
  %.reg2mem28.1 = phi double [ %.promoted23_p_scalar_, %polly.loop_header66 ], [ %p_87, %polly.loop_header75 ]
  %polly.indvar79 = phi i64 [ %polly.indvar_next80, %polly.loop_header75 ], [ 0, %polly.loop_header66 ]
  %p_scevgep21 = getelementptr [2000 x double]* %A, i64 %polly.indvar70, i64 %polly.indvar79
  %p_scevgep22 = getelementptr double* %y_1, i64 %polly.indvar79
  %_p_scalar_84 = load double* %p_scevgep21
  %_p_scalar_85 = load double* %p_scevgep22
  %p_86 = fmul double %_p_scalar_84, %_p_scalar_85
  %p_87 = fadd double %.reg2mem28.1, %p_86
  %p_indvar.next17 = add i64 %polly.indvar79, 1
  %polly.indvar_next80 = add nsw i64 %polly.indvar79, 1
  %polly.adjust_ub81 = sub i64 %6, 1
  %polly.loop_cond82 = icmp sle i64 %polly.indvar79, %polly.adjust_ub81
  br i1 %polly.loop_cond82, label %polly.loop_header75, label %polly.loop_exit77

polly.then91:                                     ; preds = %polly.stmt..preheader.lr.ph
  %7 = add i64 %0, -1
  %polly.loop_guard96 = icmp sle i64 0, %7
  br i1 %polly.loop_guard96, label %polly.loop_header93, label %polly.merge

polly.loop_header93:                              ; preds = %polly.then91, %polly.loop_header93
  %i.14.reg2mem.0 = phi i32 [ 0, %polly.then91 ], [ %p_102, %polly.loop_header93 ]
  %polly.indvar97 = phi i64 [ %polly.indvar_next98, %polly.loop_header93 ], [ 0, %polly.then91 ]
  %p_102 = add nsw i32 %i.14.reg2mem.0, 1
  %p_indvar.next11 = add i64 %polly.indvar97, 1
  %polly.indvar_next98 = add nsw i64 %polly.indvar97, 1
  %polly.adjust_ub99 = sub i64 %7, 1
  %polly.loop_cond100 = icmp sle i64 %polly.indvar97, %polly.adjust_ub99
  br i1 %polly.loop_cond100, label %polly.loop_header93, label %polly.merge
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, double* noalias %x1, double* noalias %x2) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([3 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %n, 0
  br i1 %5, label %.lr.ph7, label %16

.lr.ph7:                                          ; preds = %.split
  %6 = zext i32 %n to i64
  br label %7

; <label>:7                                       ; preds = %.lr.ph7, %12
  %indvar9 = phi i64 [ 0, %.lr.ph7 ], [ %indvar.next10, %12 ]
  %i.05 = trunc i64 %indvar9 to i32
  %scevgep12 = getelementptr double* %x1, i64 %indvar9
  %8 = srem i32 %i.05, 20
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %10, label %12

; <label>:10                                      ; preds = %7
  %11 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %fputc3 = tail call i32 @fputc(i32 10, %struct._IO_FILE* %11) #4
  br label %12

; <label>:12                                      ; preds = %10, %7
  %13 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %14 = load double* %scevgep12, align 8, !tbaa !6
  %15 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %13, i8* getelementptr inbounds ([8 x i8]* @.str5, i64 0, i64 0), double %14) #5
  %indvar.next10 = add i64 %indvar9, 1
  %exitcond11 = icmp ne i64 %indvar.next10, %6
  br i1 %exitcond11, label %7, label %._crit_edge8

._crit_edge8:                                     ; preds = %12
  br label %16

; <label>:16                                      ; preds = %._crit_edge8, %.split
  %17 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %18 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %17, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([3 x i8]* @.str3, i64 0, i64 0)) #5
  %19 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %20 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %19, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([3 x i8]* @.str7, i64 0, i64 0)) #5
  %21 = icmp sgt i32 %n, 0
  br i1 %21, label %.lr.ph, label %32

.lr.ph:                                           ; preds = %16
  %22 = zext i32 %n to i64
  br label %23

; <label>:23                                      ; preds = %.lr.ph, %28
  %indvar = phi i64 [ 0, %.lr.ph ], [ %indvar.next, %28 ]
  %i.14 = trunc i64 %indvar to i32
  %scevgep = getelementptr double* %x2, i64 %indvar
  %24 = srem i32 %i.14, 20
  %25 = icmp eq i32 %24, 0
  br i1 %25, label %26, label %28

; <label>:26                                      ; preds = %23
  %27 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %27) #4
  br label %28

; <label>:28                                      ; preds = %26, %23
  %29 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %30 = load double* %scevgep, align 8, !tbaa !6
  %31 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %29, i8* getelementptr inbounds ([8 x i8]* @.str5, i64 0, i64 0), double %30) #5
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %22
  br i1 %exitcond, label %23, label %._crit_edge

._crit_edge:                                      ; preds = %28
  br label %32

; <label>:32                                      ; preds = %._crit_edge, %16
  %33 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %34 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %33, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([3 x i8]* @.str7, i64 0, i64 0)) #5
  %35 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %36 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str8, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %35) #4
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
