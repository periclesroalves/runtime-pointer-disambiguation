; ModuleID = './datamining/correlation/correlation.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [5 x i8] c"corr\00", align 1
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
  %3 = tail call i8* @polybench_alloc_data(i64 1200, i32 8) #3
  %4 = bitcast i8* %0 to [1200 x double]*
  call void @init_array(i32 1200, i32 1400, double* %float_n, [1200 x double]* %4)
  call void (...)* @polybench_timer_start() #3
  %5 = load double* %float_n, align 8, !tbaa !1
  %6 = bitcast i8* %1 to [1200 x double]*
  %7 = bitcast i8* %2 to double*
  %8 = bitcast i8* %3 to double*
  call void @kernel_correlation(i32 1200, i32 1400, double %5, [1200 x double]* %4, [1200 x double]* %6, double* %7, double* %8)
  call void (...)* @polybench_timer_stop() #3
  call void (...)* @polybench_timer_print() #3
  %9 = icmp sgt i32 %argc, 42
  br i1 %9, label %10, label %14

; <label>:10                                      ; preds = %.split
  %11 = load i8** %argv, align 8, !tbaa !5
  %12 = load i8* %11, align 1, !tbaa !7
  %phitmp = icmp eq i8 %12, 0
  br i1 %phitmp, label %13, label %14

; <label>:13                                      ; preds = %10
  call void @print_array(i32 1200, [1200 x double]* %6)
  br label %14

; <label>:14                                      ; preds = %10, %13, %.split
  call void @free(i8* %0) #3
  call void @free(i8* %1) #3
  call void @free(i8* %2) #3
  call void @free(i8* %3) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %m, i32 %n, double* %float_n, [1200 x double]* noalias %data) #0 {
.split:
  store double 1.400000e+03, double* %float_n, align 8, !tbaa !1
  br label %polly.loop_preheader9

polly.loop_exit:                                  ; preds = %polly.loop_exit10
  ret void

polly.loop_exit10:                                ; preds = %polly.loop_exit17
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, 1367
  br i1 %polly.loop_cond, label %polly.loop_preheader9, label %polly.loop_exit

polly.loop_header8:                               ; preds = %polly.loop_exit17, %polly.loop_preheader9
  %polly.indvar11 = phi i64 [ 0, %polly.loop_preheader9 ], [ %polly.indvar_next12, %polly.loop_exit17 ]
  %0 = add i64 %polly.indvar, 31
  %1 = icmp slt i64 1399, %0
  %2 = select i1 %1, i64 1399, i64 %0
  %polly.loop_guard = icmp sle i64 %polly.indvar, %2
  br i1 %polly.loop_guard, label %polly.loop_header15, label %polly.loop_exit17

polly.loop_exit17:                                ; preds = %polly.loop_exit24, %polly.loop_header8
  %polly.indvar_next12 = add nsw i64 %polly.indvar11, 32
  %polly.loop_cond13 = icmp sle i64 %polly.indvar11, 1167
  br i1 %polly.loop_cond13, label %polly.loop_header8, label %polly.loop_exit10

polly.loop_preheader9:                            ; preds = %polly.loop_exit10, %.split
  %polly.indvar = phi i64 [ 0, %.split ], [ %polly.indvar_next, %polly.loop_exit10 ]
  br label %polly.loop_header8

polly.loop_header15:                              ; preds = %polly.loop_header8, %polly.loop_exit24
  %polly.indvar18 = phi i64 [ %polly.indvar_next19, %polly.loop_exit24 ], [ %polly.indvar, %polly.loop_header8 ]
  %3 = add i64 %polly.indvar11, 31
  %4 = icmp slt i64 1199, %3
  %5 = select i1 %4, i64 1199, i64 %3
  %polly.loop_guard25 = icmp sle i64 %polly.indvar11, %5
  br i1 %polly.loop_guard25, label %polly.loop_header22, label %polly.loop_exit24

polly.loop_exit24:                                ; preds = %polly.loop_header22, %polly.loop_header15
  %polly.indvar_next19 = add nsw i64 %polly.indvar18, 1
  %polly.adjust_ub = sub i64 %2, 1
  %polly.loop_cond20 = icmp sle i64 %polly.indvar18, %polly.adjust_ub
  br i1 %polly.loop_cond20, label %polly.loop_header15, label %polly.loop_exit17

polly.loop_header22:                              ; preds = %polly.loop_header15, %polly.loop_header22
  %polly.indvar26 = phi i64 [ %polly.indvar_next27, %polly.loop_header22 ], [ %polly.indvar11, %polly.loop_header15 ]
  %p_i.02.moved.to. = trunc i64 %polly.indvar18 to i32
  %p_.moved.to. = sitofp i32 %p_i.02.moved.to. to double
  %p_scevgep = getelementptr [1200 x double]* %data, i64 %polly.indvar18, i64 %polly.indvar26
  %p_ = mul i64 %polly.indvar18, %polly.indvar26
  %p_30 = trunc i64 %p_ to i32
  %p_31 = sitofp i32 %p_30 to double
  %p_32 = fdiv double %p_31, 1.200000e+03
  %p_33 = fadd double %p_.moved.to., %p_32
  store double %p_33, double* %p_scevgep
  %p_indvar.next = add i64 %polly.indvar26, 1
  %polly.indvar_next27 = add nsw i64 %polly.indvar26, 1
  %polly.adjust_ub28 = sub i64 %5, 1
  %polly.loop_cond29 = icmp sle i64 %polly.indvar26, %polly.adjust_ub28
  br i1 %polly.loop_cond29, label %polly.loop_header22, label %polly.loop_exit24
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_correlation(i32 %m, i32 %n, double %float_n, [1200 x double]* noalias %data, [1200 x double]* noalias %corr, double* noalias %mean, double* noalias %stddev) #0 {
polly.split_new_and_old260:
  %0 = zext i32 %m to i64
  %1 = zext i32 %n to i64
  %2 = sext i32 %m to i64
  %3 = icmp sge i64 %2, 1
  %4 = icmp sge i64 %0, 1
  %5 = and i1 %3, %4
  br i1 %5, label %polly.then265, label %polly.merge264

.lr.ph23:                                         ; preds = %polly.merge264
  %6 = icmp sgt i32 %n, 0
  br label %8

.preheader2:                                      ; preds = %17, %polly.merge264
  %7 = icmp sgt i32 %n, 0
  br i1 %7, label %.preheader1.lr.ph, label %.preheader

.preheader1.lr.ph:                                ; preds = %.preheader2
  br label %.preheader1

; <label>:8                                       ; preds = %.lr.ph23, %17
  %indvar60 = phi i64 [ 0, %.lr.ph23 ], [ %indvar.next61, %17 ]
  %9 = mul i64 %indvar60, 8
  %scevgep67 = getelementptr double* %stddev, i64 %indvar60
  %scevgep68 = getelementptr double* %mean, i64 %indvar60
  store double 0.000000e+00, double* %scevgep67, align 8, !tbaa !1
  br i1 %6, label %.lr.ph20, label %polly.merge257

.lr.ph20:                                         ; preds = %8
  %10 = load double* %scevgep68, align 8, !tbaa !1
  %11 = icmp sge i64 %1, 1
  br i1 %11, label %polly.then239, label %polly.cond256

polly.merge257:                                   ; preds = %polly.cond256, %polly.stmt.._crit_edge21, %8
  %12 = load double* %scevgep67, align 8, !tbaa !1
  %13 = fdiv double %12, %float_n
  store double %13, double* %scevgep67, align 8, !tbaa !1
  %14 = tail call double @sqrt(double %13) #3
  store double %14, double* %scevgep67, align 8, !tbaa !1
  %15 = fcmp ugt double %14, 1.000000e-01
  br i1 %15, label %16, label %17

; <label>:16                                      ; preds = %polly.merge257
  br label %17

; <label>:17                                      ; preds = %polly.merge257, %16
  %.reg2mem80.0 = phi double [ %14, %16 ], [ 1.000000e+00, %polly.merge257 ]
  store double %.reg2mem80.0, double* %scevgep67, align 8, !tbaa !1
  %indvar.next61 = add i64 %indvar60, 1
  %exitcond65 = icmp ne i64 %indvar.next61, %0
  br i1 %exitcond65, label %8, label %.preheader2

.preheader1:                                      ; preds = %.preheader1.lr.ph, %._crit_edge16
  %indvar51 = phi i64 [ 0, %.preheader1.lr.ph ], [ %indvar.next52, %._crit_edge16 ]
  br i1 %73, label %.lr.ph15, label %._crit_edge16

.preheader:                                       ; preds = %._crit_edge16, %.preheader2
  %18 = add nsw i32 %m, -1
  %19 = icmp sgt i32 %18, 0
  br i1 %19, label %.lr.ph12, label %._crit_edge13

.lr.ph12:                                         ; preds = %.preheader
  %20 = add i32 %m, -2
  %21 = add i32 %m, -1
  %22 = zext i32 %21 to i64
  %23 = zext i32 %20 to i64
  br label %32

.lr.ph15:                                         ; preds = %.preheader1, %.lr.ph15
  %indvar47 = phi i64 [ %indvar.next48, %.lr.ph15 ], [ 0, %.preheader1 ]
  %scevgep53 = getelementptr [1200 x double]* %data, i64 %indvar51, i64 %indvar47
  %scevgep50 = getelementptr double* %mean, i64 %indvar47
  %scevgep54 = getelementptr double* %stddev, i64 %indvar47
  %24 = load double* %scevgep50, align 8, !tbaa !1
  %25 = load double* %scevgep53, align 8, !tbaa !1
  %26 = fsub double %25, %24
  store double %26, double* %scevgep53, align 8, !tbaa !1
  %27 = tail call double @sqrt(double %float_n) #3
  %28 = load double* %scevgep54, align 8, !tbaa !1
  %29 = fmul double %27, %28
  %30 = load double* %scevgep53, align 8, !tbaa !1
  %31 = fdiv double %30, %29
  store double %31, double* %scevgep53, align 8, !tbaa !1
  %indvar.next48 = add i64 %indvar47, 1
  %exitcond49 = icmp ne i64 %indvar.next48, %0
  br i1 %exitcond49, label %.lr.ph15, label %._crit_edge16

._crit_edge16:                                    ; preds = %.lr.ph15, %.preheader1
  %indvar.next52 = add i64 %indvar51, 1
  %exitcond55 = icmp ne i64 %indvar.next52, %1
  br i1 %exitcond55, label %.preheader1, label %.preheader

; <label>:32                                      ; preds = %.lr.ph12, %polly.merge
  %indvar32 = phi i64 [ 0, %.lr.ph12 ], [ %40, %polly.merge ]
  %33 = mul i64 %indvar32, -1
  %34 = add i64 %23, %33
  %35 = trunc i64 %34 to i32
  %36 = zext i32 %35 to i64
  %37 = mul i64 %indvar32, 9608
  %38 = mul i64 %indvar32, 1201
  %39 = add i64 %38, 1
  %40 = add i64 %indvar32, 1
  %j.36 = trunc i64 %40 to i32
  %scevgep46 = getelementptr [1200 x double]* %corr, i64 0, i64 %38
  %41 = add i64 %36, 1
  store double 1.000000e+00, double* %scevgep46, align 8, !tbaa !1
  %42 = icmp slt i32 %j.36, %m
  br i1 %42, label %polly.cond92, label %polly.merge

polly.merge:                                      ; preds = %polly.then220, %polly.loop_header222, %polly.cond218, %polly.cond215, %32
  %exitcond41 = icmp ne i64 %40, %22
  br i1 %exitcond41, label %32, label %._crit_edge13

._crit_edge13:                                    ; preds = %polly.merge, %.preheader
  %43 = sext i32 %18 to i64
  %44 = getelementptr inbounds [1200 x double]* %corr, i64 %43, i64 %43
  store double 1.000000e+00, double* %44, align 8, !tbaa !1
  ret void

polly.cond92:                                     ; preds = %32
  %45 = srem i64 %37, 8
  %46 = icmp eq i64 %45, 0
  br i1 %46, label %polly.cond95, label %polly.cond114

polly.cond114:                                    ; preds = %polly.then97, %polly.loop_exit101, %polly.cond95, %polly.cond92
  br i1 %46, label %polly.cond117, label %polly.cond149

polly.cond149:                                    ; preds = %polly.then119, %polly.loop_header121, %polly.cond117, %polly.cond114
  br i1 %46, label %polly.cond152, label %polly.cond176

polly.cond176:                                    ; preds = %polly.then154, %polly.loop_header156, %polly.cond152, %polly.cond149
  %47 = add i64 %37, 7
  %48 = srem i64 %47, 8
  %49 = icmp sle i64 %48, 6
  br i1 %49, label %polly.cond179, label %polly.cond215

polly.cond215:                                    ; preds = %polly.then181, %polly.loop_exit198, %polly.cond179, %polly.cond176
  br i1 %49, label %polly.cond218, label %polly.merge

polly.cond95:                                     ; preds = %polly.cond92
  %50 = sext i32 %n to i64
  %51 = icmp sge i64 %50, 1
  %52 = icmp sge i64 %1, 1
  %53 = and i1 %51, %52
  br i1 %53, label %polly.then97, label %polly.cond114

polly.then97:                                     ; preds = %polly.cond95
  br i1 true, label %polly.loop_header, label %polly.cond114

polly.loop_header:                                ; preds = %polly.then97, %polly.loop_exit101
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit101 ], [ 0, %polly.then97 ]
  %p_ = add i64 %39, %polly.indvar
  %p_scevgep40 = getelementptr [1200 x double]* %corr, i64 0, i64 %p_
  store double 0.000000e+00, double* %p_scevgep40
  %54 = add i64 %1, -1
  %polly.loop_guard102 = icmp sle i64 0, %54
  br i1 %polly.loop_guard102, label %polly.loop_header99, label %polly.loop_exit101

polly.loop_exit101:                               ; preds = %polly.loop_header99, %polly.loop_header
  %.reg2mem.0 = phi double [ %p_110, %polly.loop_header99 ], [ 0.000000e+00, %polly.loop_header ]
  store double %.reg2mem.0, double* %p_scevgep40
  %p_.moved.to.88 = add i64 %polly.indvar, 1
  %p_scevgep39.moved.to. = getelementptr [1200 x double]* %corr, i64 %p_.moved.to.88, i64 %38
  store double %.reg2mem.0, double* %p_scevgep39.moved.to.
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %36, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond114

polly.loop_header99:                              ; preds = %polly.loop_header, %polly.loop_header99
  %.reg2mem.1 = phi double [ 0.000000e+00, %polly.loop_header ], [ %p_110, %polly.loop_header99 ]
  %polly.indvar103 = phi i64 [ %polly.indvar_next104, %polly.loop_header99 ], [ 0, %polly.loop_header ]
  %p_.moved.to.86 = add i64 %40, %polly.indvar
  %p_scevgep36 = getelementptr [1200 x double]* %data, i64 %polly.indvar103, i64 %p_.moved.to.86
  %p_scevgep = getelementptr [1200 x double]* %data, i64 %polly.indvar103, i64 %indvar32
  %_p_scalar_ = load double* %p_scevgep
  %_p_scalar_108 = load double* %p_scevgep36
  %p_109 = fmul double %_p_scalar_, %_p_scalar_108
  %p_110 = fadd double %.reg2mem.1, %p_109
  %p_indvar.next = add i64 %polly.indvar103, 1
  %polly.indvar_next104 = add nsw i64 %polly.indvar103, 1
  %polly.adjust_ub105 = sub i64 %54, 1
  %polly.loop_cond106 = icmp sle i64 %polly.indvar103, %polly.adjust_ub105
  br i1 %polly.loop_cond106, label %polly.loop_header99, label %polly.loop_exit101

polly.cond117:                                    ; preds = %polly.cond114
  %55 = sext i32 %n to i64
  %56 = icmp sge i64 %55, 1
  %57 = icmp sle i64 %1, 0
  %58 = and i1 %56, %57
  br i1 %58, label %polly.then119, label %polly.cond149

polly.then119:                                    ; preds = %polly.cond117
  br i1 true, label %polly.loop_header121, label %polly.cond149

polly.loop_header121:                             ; preds = %polly.then119, %polly.loop_header121
  %polly.indvar125 = phi i64 [ %polly.indvar_next126, %polly.loop_header121 ], [ 0, %polly.then119 ]
  %p_131 = add i64 %39, %polly.indvar125
  %p_scevgep40132 = getelementptr [1200 x double]* %corr, i64 0, i64 %p_131
  store double 0.000000e+00, double* %p_scevgep40132
  %p_.moved.to.88144 = add i64 %polly.indvar125, 1
  %p_scevgep39.moved.to.145 = getelementptr [1200 x double]* %corr, i64 %p_.moved.to.88144, i64 %38
  %_p_scalar_146 = load double* %p_scevgep40132
  store double %_p_scalar_146, double* %p_scevgep39.moved.to.145
  %polly.indvar_next126 = add nsw i64 %polly.indvar125, 1
  %polly.adjust_ub127 = sub i64 %36, 1
  %polly.loop_cond128 = icmp sle i64 %polly.indvar125, %polly.adjust_ub127
  br i1 %polly.loop_cond128, label %polly.loop_header121, label %polly.cond149

polly.cond152:                                    ; preds = %polly.cond149
  %59 = sext i32 %n to i64
  %60 = icmp sle i64 %59, 0
  br i1 %60, label %polly.then154, label %polly.cond176

polly.then154:                                    ; preds = %polly.cond152
  br i1 true, label %polly.loop_header156, label %polly.cond176

polly.loop_header156:                             ; preds = %polly.then154, %polly.loop_header156
  %polly.indvar160 = phi i64 [ %polly.indvar_next161, %polly.loop_header156 ], [ 0, %polly.then154 ]
  %p_166 = add i64 %39, %polly.indvar160
  %p_scevgep40167 = getelementptr [1200 x double]* %corr, i64 0, i64 %p_166
  store double 0.000000e+00, double* %p_scevgep40167
  %p_.moved.to.88171 = add i64 %polly.indvar160, 1
  %p_scevgep39.moved.to.172 = getelementptr [1200 x double]* %corr, i64 %p_.moved.to.88171, i64 %38
  store double 0.000000e+00, double* %p_scevgep39.moved.to.172
  %polly.indvar_next161 = add nsw i64 %polly.indvar160, 1
  %polly.adjust_ub162 = sub i64 %36, 1
  %polly.loop_cond163 = icmp sle i64 %polly.indvar160, %polly.adjust_ub162
  br i1 %polly.loop_cond163, label %polly.loop_header156, label %polly.cond176

polly.cond179:                                    ; preds = %polly.cond176
  %61 = sext i32 %n to i64
  %62 = icmp sge i64 %61, 1
  %63 = icmp sge i64 %1, 1
  %64 = and i1 %62, %63
  br i1 %64, label %polly.then181, label %polly.cond215

polly.then181:                                    ; preds = %polly.cond179
  br i1 true, label %polly.loop_header183, label %polly.cond215

polly.loop_header183:                             ; preds = %polly.then181, %polly.loop_exit198
  %polly.indvar187 = phi i64 [ %polly.indvar_next188, %polly.loop_exit198 ], [ 0, %polly.then181 ]
  %p_.moved.to..lr.ph192 = add i64 %39, %polly.indvar187
  %p_scevgep40.moved.to..lr.ph193 = getelementptr [1200 x double]* %corr, i64 0, i64 %p_.moved.to..lr.ph192
  %.promoted_p_scalar_194 = load double* %p_scevgep40.moved.to..lr.ph193
  %65 = add i64 %1, -1
  %polly.loop_guard199 = icmp sle i64 0, %65
  br i1 %polly.loop_guard199, label %polly.loop_header196, label %polly.loop_exit198

polly.loop_exit198:                               ; preds = %polly.loop_header196, %polly.loop_header183
  %polly.indvar_next188 = add nsw i64 %polly.indvar187, 1
  %polly.adjust_ub189 = sub i64 %36, 1
  %polly.loop_cond190 = icmp sle i64 %polly.indvar187, %polly.adjust_ub189
  br i1 %polly.loop_cond190, label %polly.loop_header183, label %polly.cond215

polly.loop_header196:                             ; preds = %polly.loop_header183, %polly.loop_header196
  %.reg2mem.2 = phi double [ %.promoted_p_scalar_194, %polly.loop_header183 ], [ %p_212, %polly.loop_header196 ]
  %polly.indvar200 = phi i64 [ %polly.indvar_next201, %polly.loop_header196 ], [ 0, %polly.loop_header183 ]
  %p_.moved.to.86205 = add i64 %40, %polly.indvar187
  %p_scevgep36207 = getelementptr [1200 x double]* %data, i64 %polly.indvar200, i64 %p_.moved.to.86205
  %p_scevgep208 = getelementptr [1200 x double]* %data, i64 %polly.indvar200, i64 %indvar32
  %_p_scalar_209 = load double* %p_scevgep208
  %_p_scalar_210 = load double* %p_scevgep36207
  %p_211 = fmul double %_p_scalar_209, %_p_scalar_210
  %p_212 = fadd double %.reg2mem.2, %p_211
  %p_indvar.next213 = add i64 %polly.indvar200, 1
  %polly.indvar_next201 = add nsw i64 %polly.indvar200, 1
  %polly.adjust_ub202 = sub i64 %65, 1
  %polly.loop_cond203 = icmp sle i64 %polly.indvar200, %polly.adjust_ub202
  br i1 %polly.loop_cond203, label %polly.loop_header196, label %polly.loop_exit198

polly.cond218:                                    ; preds = %polly.cond215
  %66 = sext i32 %n to i64
  %67 = icmp sge i64 %66, 1
  %68 = icmp sle i64 %1, 0
  %69 = and i1 %67, %68
  br i1 %69, label %polly.then220, label %polly.merge

polly.then220:                                    ; preds = %polly.cond218
  br i1 true, label %polly.loop_header222, label %polly.merge

polly.loop_header222:                             ; preds = %polly.then220, %polly.loop_header222
  %polly.indvar226 = phi i64 [ %polly.indvar_next227, %polly.loop_header222 ], [ 0, %polly.then220 ]
  %p_.moved.to..lr.ph231 = add i64 %39, %polly.indvar226
  %p_scevgep40.moved.to..lr.ph232 = getelementptr [1200 x double]* %corr, i64 0, i64 %p_.moved.to..lr.ph231
  %polly.indvar_next227 = add nsw i64 %polly.indvar226, 1
  %polly.adjust_ub228 = sub i64 %36, 1
  %polly.loop_cond229 = icmp sle i64 %polly.indvar226, %polly.adjust_ub228
  br i1 %polly.loop_cond229, label %polly.loop_header222, label %polly.merge

polly.cond256:                                    ; preds = %polly.then239, %polly.loop_header241, %.lr.ph20
  %.reg2mem82.0 = phi double [ %p_255, %polly.loop_header241 ], [ 0.000000e+00, %polly.then239 ], [ 0.000000e+00, %.lr.ph20 ]
  %70 = srem i64 %9, 8
  %71 = icmp eq i64 %70, 0
  br i1 %71, label %polly.stmt.._crit_edge21, label %polly.merge257

polly.then239:                                    ; preds = %.lr.ph20
  %72 = add i64 %1, -1
  %polly.loop_guard244 = icmp sle i64 0, %72
  br i1 %polly.loop_guard244, label %polly.loop_header241, label %polly.cond256

polly.loop_header241:                             ; preds = %polly.then239, %polly.loop_header241
  %.reg2mem82.1 = phi double [ 0.000000e+00, %polly.then239 ], [ %p_255, %polly.loop_header241 ]
  %polly.indvar245 = phi i64 [ %polly.indvar_next246, %polly.loop_header241 ], [ 0, %polly.then239 ]
  %p_scevgep62 = getelementptr [1200 x double]* %data, i64 %polly.indvar245, i64 %indvar60
  %_p_scalar_250 = load double* %p_scevgep62
  %p_251 = fsub double %_p_scalar_250, %10
  %p_254 = fmul double %p_251, %p_251
  %p_255 = fadd double %.reg2mem82.1, %p_254
  %p_indvar.next58 = add i64 %polly.indvar245, 1
  %polly.indvar_next246 = add nsw i64 %polly.indvar245, 1
  %polly.adjust_ub247 = sub i64 %72, 1
  %polly.loop_cond248 = icmp sle i64 %polly.indvar245, %polly.adjust_ub247
  br i1 %polly.loop_cond248, label %polly.loop_header241, label %polly.cond256

polly.stmt.._crit_edge21:                         ; preds = %polly.cond256
  store double %.reg2mem82.0, double* %scevgep67
  br label %polly.merge257

polly.merge264:                                   ; preds = %polly.merge277, %polly.loop_header323, %polly.split_new_and_old260
  %73 = icmp sgt i32 %m, 0
  br i1 %73, label %.lr.ph23, label %.preheader2

polly.then265:                                    ; preds = %polly.split_new_and_old260
  %74 = add i64 %0, -1
  %polly.loop_guard270 = icmp sle i64 0, %74
  br i1 %polly.loop_guard270, label %polly.loop_header267, label %polly.cond276

polly.cond276:                                    ; preds = %polly.then265, %polly.loop_header267
  %75 = sext i32 %n to i64
  %76 = icmp sge i64 %75, 1
  br i1 %76, label %polly.cond279, label %polly.merge277

polly.merge277:                                   ; preds = %polly.then306, %polly.loop_header308, %polly.cond304, %polly.cond276
  br i1 %polly.loop_guard270, label %polly.loop_header323, label %polly.merge264

polly.loop_header267:                             ; preds = %polly.then265, %polly.loop_header267
  %polly.indvar271 = phi i64 [ %polly.indvar_next272, %polly.loop_header267 ], [ 0, %polly.then265 ]
  %p_scevgep79 = getelementptr double* %mean, i64 %polly.indvar271
  store double 0.000000e+00, double* %p_scevgep79
  %polly.indvar_next272 = add nsw i64 %polly.indvar271, 1
  %polly.adjust_ub273 = sub i64 %74, 1
  %polly.loop_cond274 = icmp sle i64 %polly.indvar271, %polly.adjust_ub273
  br i1 %polly.loop_cond274, label %polly.loop_header267, label %polly.cond276

polly.cond279:                                    ; preds = %polly.cond276
  %77 = icmp sge i64 %1, 1
  br i1 %77, label %polly.then281, label %polly.cond304

polly.cond304:                                    ; preds = %polly.then281, %polly.loop_exit294, %polly.cond279
  %78 = icmp sle i64 %1, 0
  br i1 %78, label %polly.then306, label %polly.merge277

polly.then281:                                    ; preds = %polly.cond279
  br i1 %polly.loop_guard270, label %polly.loop_header283, label %polly.cond304

polly.loop_header283:                             ; preds = %polly.then281, %polly.loop_exit294
  %polly.indvar287 = phi i64 [ %polly.indvar_next288, %polly.loop_exit294 ], [ 0, %polly.then281 ]
  %p_scevgep79.moved.to..lr.ph26 = getelementptr double* %mean, i64 %polly.indvar287
  %.promoted75_p_scalar_ = load double* %p_scevgep79.moved.to..lr.ph26
  %79 = add i64 %1, -1
  %polly.loop_guard295 = icmp sle i64 0, %79
  br i1 %polly.loop_guard295, label %polly.loop_header292, label %polly.loop_exit294

polly.loop_exit294:                               ; preds = %polly.loop_header292, %polly.loop_header283
  %.reg2mem84.0 = phi double [ %p_302, %polly.loop_header292 ], [ %.promoted75_p_scalar_, %polly.loop_header283 ]
  store double %.reg2mem84.0, double* %p_scevgep79.moved.to..lr.ph26
  %polly.indvar_next288 = add nsw i64 %polly.indvar287, 1
  %polly.adjust_ub289 = sub i64 %74, 1
  %polly.loop_cond290 = icmp sle i64 %polly.indvar287, %polly.adjust_ub289
  br i1 %polly.loop_cond290, label %polly.loop_header283, label %polly.cond304

polly.loop_header292:                             ; preds = %polly.loop_header283, %polly.loop_header292
  %.reg2mem84.1 = phi double [ %.promoted75_p_scalar_, %polly.loop_header283 ], [ %p_302, %polly.loop_header292 ]
  %polly.indvar296 = phi i64 [ %polly.indvar_next297, %polly.loop_header292 ], [ 0, %polly.loop_header283 ]
  %p_scevgep74 = getelementptr [1200 x double]* %data, i64 %polly.indvar296, i64 %polly.indvar287
  %_p_scalar_301 = load double* %p_scevgep74
  %p_302 = fadd double %_p_scalar_301, %.reg2mem84.1
  %p_indvar.next70 = add i64 %polly.indvar296, 1
  %polly.indvar_next297 = add nsw i64 %polly.indvar296, 1
  %polly.adjust_ub298 = sub i64 %79, 1
  %polly.loop_cond299 = icmp sle i64 %polly.indvar296, %polly.adjust_ub298
  br i1 %polly.loop_cond299, label %polly.loop_header292, label %polly.loop_exit294

polly.then306:                                    ; preds = %polly.cond304
  br i1 %polly.loop_guard270, label %polly.loop_header308, label %polly.merge277

polly.loop_header308:                             ; preds = %polly.then306, %polly.loop_header308
  %polly.indvar312 = phi i64 [ %polly.indvar_next313, %polly.loop_header308 ], [ 0, %polly.then306 ]
  %p_scevgep79.moved.to..lr.ph26317 = getelementptr double* %mean, i64 %polly.indvar312
  %.promoted75_p_scalar_318 = load double* %p_scevgep79.moved.to..lr.ph26317
  store double %.promoted75_p_scalar_318, double* %p_scevgep79.moved.to..lr.ph26317
  %polly.indvar_next313 = add nsw i64 %polly.indvar312, 1
  %polly.adjust_ub314 = sub i64 %74, 1
  %polly.loop_cond315 = icmp sle i64 %polly.indvar312, %polly.adjust_ub314
  br i1 %polly.loop_cond315, label %polly.loop_header308, label %polly.merge277

polly.loop_header323:                             ; preds = %polly.merge277, %polly.loop_header323
  %polly.indvar327 = phi i64 [ %polly.indvar_next328, %polly.loop_header323 ], [ 0, %polly.merge277 ]
  %p_scevgep79.moved.to. = getelementptr double* %mean, i64 %polly.indvar327
  %_p_scalar_332 = load double* %p_scevgep79.moved.to.
  %p_333 = fdiv double %_p_scalar_332, %float_n
  store double %p_333, double* %p_scevgep79.moved.to.
  %p_indvar.next73 = add i64 %polly.indvar327, 1
  %polly.indvar_next328 = add nsw i64 %polly.indvar327, 1
  %polly.adjust_ub329 = sub i64 %74, 1
  %polly.loop_cond330 = icmp sle i64 %polly.indvar327, %polly.adjust_ub329
  br i1 %polly.loop_cond330, label %polly.loop_header323, label %polly.merge264
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %m, [1200 x double]* noalias %corr) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([5 x i8]* @.str3, i64 0, i64 0)) #5
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
  %scevgep = getelementptr [1200 x double]* %corr, i64 %indvar4, i64 %indvar
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
  %24 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([5 x i8]* @.str3, i64 0, i64 0)) #5
  %25 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %26 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str7, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %25) #4
  ret void
}

; Function Attrs: nounwind
declare void @free(i8*) #2

declare i32 @fprintf(%struct._IO_FILE*, i8*, ...) #1

; Function Attrs: nounwind
declare double @sqrt(double) #2

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
