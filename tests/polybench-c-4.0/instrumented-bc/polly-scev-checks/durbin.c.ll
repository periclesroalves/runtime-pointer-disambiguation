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
define internal void @init_array(i32 %n, double* %r) #0 {
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
  %p_9 = add i64 %p_.moved.to.2, %p_
  %p_10 = trunc i64 %p_9 to i32
  %p_scevgep = getelementptr double* %r, i64 %polly.indvar
  %p_11 = sitofp i32 %p_10 to double
  store double %p_11, double* %p_scevgep
  %p_indvar.next = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %5, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_durbin(i32 %n, double* %r, double* %y) #0 {
.split:
  %y43 = ptrtoint double* %y to i64
  %r35 = ptrtoint double* %r to i64
  %z = alloca [2000 x double], align 16
  %0 = bitcast [2000 x double]* %z to i8*
  call void @llvm.lifetime.start(i64 16000, i8* %0) #3
  %1 = load double* %r, align 8, !tbaa !6
  %2 = fsub double -0.000000e+00, %1
  store double %2, double* %y, align 8, !tbaa !6
  %3 = icmp sgt i32 %n, 1
  br i1 %3, label %.lr.ph13, label %._crit_edge14

.lr.ph13:                                         ; preds = %.split
  %4 = load double* %r, align 8, !tbaa !6
  %5 = fsub double -0.000000e+00, %4
  %6 = add i32 %n, -2
  %7 = zext i32 %6 to i64
  %8 = add i64 %7, 1
  %scevgep34 = getelementptr double* %r, i64 1
  %9 = icmp ult double* %scevgep34, %r
  %umin = select i1 %9, double* %scevgep34, double* %r
  %umin50 = bitcast double* %umin to i8*
  %10 = mul i64 8, %7
  %11 = add i64 %r35, %10
  %12 = mul i64 -8, %7
  %13 = add i64 %11, %12
  %scevgep3637 = ptrtoint double* %scevgep34 to i64
  %14 = add i64 %scevgep3637, %10
  %15 = icmp ugt i64 %14, %13
  %umax = select i1 %15, i64 %14, i64 %13
  %umax51 = inttoptr i64 %umax to i8*
  %scevgep41 = getelementptr double* %y, i64 1
  %16 = icmp ult double* %scevgep41, %y
  %umin42 = select i1 %16, double* %scevgep41, double* %y
  %umin4252 = bitcast double* %umin42 to i8*
  %17 = add i64 %y43, %10
  %18 = add i64 %17, %12
  %19 = icmp ugt i64 %18, %17
  %umax45 = select i1 %19, i64 %18, i64 %17
  %scevgep4748 = ptrtoint double* %scevgep41 to i64
  %20 = add i64 %scevgep4748, %10
  %21 = icmp ugt i64 %20, %umax45
  %umax49 = select i1 %21, i64 %20, i64 %umax45
  %umax4953 = inttoptr i64 %umax49 to i8*
  %22 = icmp ult i8* %umax51, %umin4252
  %23 = icmp ult i8* %umax4953, %umin50
  %pair-no-alias = or i1 %22, %23
  br i1 %pair-no-alias, label %polly.start98, label %24

; <label>:24                                      ; preds = %.lr.ph13, %polly.merge
  %alpha.010.reg2mem.0 = phi double [ %5, %.lr.ph13 ], [ %41, %polly.merge ]
  %beta.09.reg2mem.0 = phi double [ 1.000000e+00, %.lr.ph13 ], [ %28, %polly.merge ]
  %indvar15.clone = phi i64 [ 0, %.lr.ph13 ], [ %25, %polly.merge ]
  %25 = add i64 %indvar15.clone, 1
  %k.011.clone = trunc i64 %25 to i32
  %scevgep32.clone = getelementptr double* %r, i64 %25
  %scevgep33.clone = getelementptr double* %y, i64 %25
  %26 = fmul double %alpha.010.reg2mem.0, %alpha.010.reg2mem.0
  %27 = fsub double 1.000000e+00, %26
  %28 = fmul double %beta.09.reg2mem.0, %27
  %29 = icmp sgt i32 %k.011.clone, 0
  br i1 %29, label %.lr.ph.clone, label %37

.lr.ph.clone:                                     ; preds = %24
  br label %30

; <label>:30                                      ; preds = %30, %.lr.ph.clone
  %sum.01.reg2mem.0 = phi double [ 0.000000e+00, %.lr.ph.clone ], [ %36, %30 ]
  %indvar.clone = phi i64 [ 0, %.lr.ph.clone ], [ %indvar.next.clone, %30 ]
  %31 = mul i64 %indvar.clone, -1
  %32 = add i64 %indvar15.clone, %31
  %scevgep.clone = getelementptr double* %r, i64 %32
  %scevgep17.clone = getelementptr double* %y, i64 %indvar.clone
  %33 = load double* %scevgep.clone, align 8, !tbaa !6
  %34 = load double* %scevgep17.clone, align 8, !tbaa !6
  %35 = fmul double %33, %34
  %36 = fadd double %sum.01.reg2mem.0, %35
  %indvar.next.clone = add i64 %indvar.clone, 1
  %exitcond.clone = icmp ne i64 %indvar.next.clone, %25
  br i1 %exitcond.clone, label %30, label %._crit_edge.clone

._crit_edge.clone:                                ; preds = %30
  br label %37

; <label>:37                                      ; preds = %._crit_edge.clone, %24
  %sum.0.lcssa.reg2mem.0 = phi double [ %36, %._crit_edge.clone ], [ 0.000000e+00, %24 ]
  %38 = load double* %scevgep32.clone, align 8, !tbaa !6
  %39 = fadd double %sum.0.lcssa.reg2mem.0, %38
  %40 = fsub double -0.000000e+00, %39
  %41 = fdiv double %40, %28
  %42 = icmp sge i64 %indvar15.clone, 0
  %or.cond165 = and i1 %29, %42
  br i1 %or.cond165, label %polly.then81, label %.preheader.clone

.preheader.clone:                                 ; preds = %polly.then81, %polly.loop_header83, %37
  br i1 %or.cond165, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.then, %polly.loop_header, %.preheader.clone
  store double %41, double* %scevgep33.clone, align 8, !tbaa !6
  %exitcond29.clone = icmp ne i64 %25, %8
  br i1 %exitcond29.clone, label %24, label %._crit_edge14

._crit_edge14:                                    ; preds = %polly.then102, %polly.loop_exit154, %polly.start98, %polly.merge, %.split
  call void @llvm.lifetime.end(i64 16000, i8* %0) #3
  ret void

polly.then:                                       ; preds = %.preheader.clone
  br i1 %42, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_scevgep27.clone = getelementptr [2000 x double]* %z, i64 0, i64 %polly.indvar
  %p_scevgep28.clone = getelementptr double* %y, i64 %polly.indvar
  %_p_scalar_ = load double* %p_scevgep27.clone
  store double %_p_scalar_, double* %p_scevgep28.clone
  %p_indvar.next25.clone = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %indvar15.clone, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.then81:                                     ; preds = %37
  br i1 %42, label %polly.loop_header83, label %.preheader.clone

polly.loop_header83:                              ; preds = %polly.then81, %polly.loop_header83
  %polly.indvar87 = phi i64 [ %polly.indvar_next88, %polly.loop_header83 ], [ 0, %polly.then81 ]
  %p_ = mul i64 %polly.indvar87, -1
  %p_92 = add i64 %indvar15.clone, %p_
  %p_scevgep21.clone = getelementptr double* %y, i64 %p_92
  %p_scevgep22.clone = getelementptr double* %y, i64 %polly.indvar87
  %p_scevgep23.clone = getelementptr [2000 x double]* %z, i64 0, i64 %polly.indvar87
  %_p_scalar_93 = load double* %p_scevgep22.clone
  %_p_scalar_94 = load double* %p_scevgep21.clone
  %p_95 = fmul double %41, %_p_scalar_94
  %p_96 = fadd double %_p_scalar_93, %p_95
  store double %p_96, double* %p_scevgep23.clone
  %p_indvar.next19.clone = add i64 %polly.indvar87, 1
  %polly.indvar_next88 = add nsw i64 %polly.indvar87, 1
  %polly.adjust_ub89 = sub i64 %indvar15.clone, 1
  %polly.loop_cond90 = icmp sle i64 %polly.indvar87, %polly.adjust_ub89
  br i1 %polly.loop_cond90, label %polly.loop_header83, label %.preheader.clone

polly.start98:                                    ; preds = %.lr.ph13
  br i1 true, label %polly.then102, label %._crit_edge14

polly.then102:                                    ; preds = %polly.start98
  br i1 true, label %polly.loop_header104, label %._crit_edge14

polly.loop_header104:                             ; preds = %polly.then102, %polly.loop_exit154
  %alpha.010.reg2mem.1 = phi double [ %5, %polly.then102 ], [ %p_.moved.to.68, %polly.loop_exit154 ]
  %beta.09.reg2mem.1 = phi double [ 1.000000e+00, %polly.then102 ], [ %p_.moved.to.67, %polly.loop_exit154 ]
  %polly.indvar108 = phi i64 [ %polly.indvar_next109, %polly.loop_exit154 ], [ 0, %polly.then102 ]
  %polly.loop_guard116 = icmp sle i64 0, %polly.indvar108
  br i1 %polly.loop_guard116, label %polly.loop_header113, label %polly.loop_exit115

polly.loop_exit115:                               ; preds = %polly.loop_header113, %polly.loop_header104
  %sum.01.reg2mem.1 = phi double [ %p_127, %polly.loop_header113 ], [ 0.000000e+00, %polly.loop_header104 ]
  %p_129 = add i64 %polly.indvar108, 1
  %p_k.011 = trunc i64 %p_129 to i32
  %p_scevgep32.moved.to. = getelementptr double* %r, i64 %p_129
  %_p_scalar_133 = load double* %p_scevgep32.moved.to.
  br i1 %polly.loop_guard116, label %polly.loop_header136, label %polly.loop_exit138

polly.loop_exit138:                               ; preds = %polly.loop_header136, %polly.loop_exit115
  br i1 %polly.loop_guard116, label %polly.loop_header152, label %polly.loop_exit154

polly.loop_exit154:                               ; preds = %polly.loop_header152, %polly.loop_exit138
  %p_.moved.to.63 = fadd double %sum.01.reg2mem.1, %_p_scalar_133
  %p_.moved.to.64 = fsub double -0.000000e+00, %p_.moved.to.63
  %p_.moved.to.65 = fmul double %alpha.010.reg2mem.1, %alpha.010.reg2mem.1
  %p_.moved.to.66 = fsub double 1.000000e+00, %p_.moved.to.65
  %p_.moved.to.67 = fmul double %beta.09.reg2mem.1, %p_.moved.to.66
  %p_.moved.to.68 = fdiv double %p_.moved.to.64, %p_.moved.to.67
  %p_scevgep33.moved.to. = getelementptr double* %y, i64 %p_129
  store double %p_.moved.to.68, double* %p_scevgep33.moved.to.
  %polly.indvar_next109 = add nsw i64 %polly.indvar108, 1
  %polly.adjust_ub110 = sub i64 %7, 1
  %polly.loop_cond111 = icmp sle i64 %polly.indvar108, %polly.adjust_ub110
  br i1 %polly.loop_cond111, label %polly.loop_header104, label %._crit_edge14

polly.loop_header113:                             ; preds = %polly.loop_header104, %polly.loop_header113
  %sum.01.reg2mem.2 = phi double [ 0.000000e+00, %polly.loop_header104 ], [ %p_127, %polly.loop_header113 ]
  %polly.indvar117 = phi i64 [ %polly.indvar_next118, %polly.loop_header113 ], [ 0, %polly.loop_header104 ]
  %p_.moved.to. = add i64 %polly.indvar108, 1
  %p_122 = mul i64 %polly.indvar117, -1
  %p_123 = add i64 %polly.indvar108, %p_122
  %p_scevgep = getelementptr double* %r, i64 %p_123
  %p_scevgep17 = getelementptr double* %y, i64 %polly.indvar117
  %_p_scalar_124 = load double* %p_scevgep
  %_p_scalar_125 = load double* %p_scevgep17
  %p_126 = fmul double %_p_scalar_124, %_p_scalar_125
  %p_127 = fadd double %sum.01.reg2mem.2, %p_126
  %p_indvar.next = add i64 %polly.indvar117, 1
  %polly.indvar_next118 = add nsw i64 %polly.indvar117, 1
  %polly.adjust_ub119 = sub i64 %polly.indvar108, 1
  %polly.loop_cond120 = icmp sle i64 %polly.indvar117, %polly.adjust_ub119
  br i1 %polly.loop_cond120, label %polly.loop_header113, label %polly.loop_exit115

polly.loop_header136:                             ; preds = %polly.loop_exit115, %polly.loop_header136
  %polly.indvar140 = phi i64 [ %polly.indvar_next141, %polly.loop_header136 ], [ 0, %polly.loop_exit115 ]
  %p_.moved.to.55 = fadd double %sum.01.reg2mem.1, %_p_scalar_133
  %p_.moved.to.56 = fsub double -0.000000e+00, %p_.moved.to.55
  %p_.moved.to.57 = fmul double %alpha.010.reg2mem.1, %alpha.010.reg2mem.1
  %p_.moved.to.58 = fsub double 1.000000e+00, %p_.moved.to.57
  %p_.moved.to.59 = fmul double %beta.09.reg2mem.1, %p_.moved.to.58
  %p_.moved.to.60 = fdiv double %p_.moved.to.56, %p_.moved.to.59
  %p_145 = mul i64 %polly.indvar140, -1
  %p_146 = add i64 %polly.indvar108, %p_145
  %p_scevgep21 = getelementptr double* %y, i64 %p_146
  %p_scevgep22 = getelementptr double* %y, i64 %polly.indvar140
  %p_scevgep23 = getelementptr [2000 x double]* %z, i64 0, i64 %polly.indvar140
  %_p_scalar_147 = load double* %p_scevgep22
  %_p_scalar_148 = load double* %p_scevgep21
  %p_149 = fmul double %p_.moved.to.60, %_p_scalar_148
  %p_150 = fadd double %_p_scalar_147, %p_149
  store double %p_150, double* %p_scevgep23
  %p_indvar.next19 = add i64 %polly.indvar140, 1
  %polly.indvar_next141 = add nsw i64 %polly.indvar140, 1
  %polly.adjust_ub142 = sub i64 %polly.indvar108, 1
  %polly.loop_cond143 = icmp sle i64 %polly.indvar140, %polly.adjust_ub142
  br i1 %polly.loop_cond143, label %polly.loop_header136, label %polly.loop_exit138

polly.loop_header152:                             ; preds = %polly.loop_exit138, %polly.loop_header152
  %polly.indvar156 = phi i64 [ %polly.indvar_next157, %polly.loop_header152 ], [ 0, %polly.loop_exit138 ]
  %p_scevgep27 = getelementptr [2000 x double]* %z, i64 0, i64 %polly.indvar156
  %p_scevgep28 = getelementptr double* %y, i64 %polly.indvar156
  %_p_scalar_161 = load double* %p_scevgep27
  store double %_p_scalar_161, double* %p_scevgep28
  %p_indvar.next25 = add i64 %polly.indvar156, 1
  %polly.indvar_next157 = add nsw i64 %polly.indvar156, 1
  %polly.adjust_ub158 = sub i64 %polly.indvar108, 1
  %polly.loop_cond159 = icmp sle i64 %polly.indvar156, %polly.adjust_ub158
  br i1 %polly.loop_cond159, label %polly.loop_header152, label %polly.loop_exit154
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, double* %y) #0 {
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
