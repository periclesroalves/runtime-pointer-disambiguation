; ModuleID = './datamining/covariance/covariance.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [4 x i8] c"cov\00", align 1
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
  %3 = bitcast i8* %0 to [1200 x double]*
  call void @init_array(i32 1200, i32 1400, double* %float_n, [1200 x double]* %3)
  call void (...)* @polybench_timer_start() #3
  %4 = load double* %float_n, align 8, !tbaa !1
  %5 = bitcast i8* %1 to [1200 x double]*
  %6 = bitcast i8* %2 to double*
  call void @kernel_covariance(i32 1200, i32 1400, double %4, [1200 x double]* %3, [1200 x double]* %5, double* %6)
  call void (...)* @polybench_timer_stop() #3
  call void (...)* @polybench_timer_print() #3
  %7 = icmp sgt i32 %argc, 42
  br i1 %7, label %8, label %12

; <label>:8                                       ; preds = %.split
  %9 = load i8** %argv, align 8, !tbaa !5
  %10 = load i8* %9, align 1, !tbaa !7
  %phitmp = icmp eq i8 %10, 0
  br i1 %phitmp, label %11, label %12

; <label>:11                                      ; preds = %8
  call void @print_array(i32 1200, [1200 x double]* %5)
  br label %12

; <label>:12                                      ; preds = %8, %11, %.split
  call void @free(i8* %0) #3
  call void @free(i8* %1) #3
  call void @free(i8* %2) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %m, i32 %n, double* %float_n, [1200 x double]* noalias %data) #0 {
.split:
  %0 = sitofp i32 %n to double
  store double %0, double* %float_n, align 8, !tbaa !1
  br label %polly.loop_preheader9

polly.loop_exit:                                  ; preds = %polly.loop_exit10
  ret void

polly.loop_exit10:                                ; preds = %polly.loop_exit17
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, 1367
  br i1 %polly.loop_cond, label %polly.loop_preheader9, label %polly.loop_exit

polly.loop_header8:                               ; preds = %polly.loop_exit17, %polly.loop_preheader9
  %polly.indvar11 = phi i64 [ 0, %polly.loop_preheader9 ], [ %polly.indvar_next12, %polly.loop_exit17 ]
  %1 = add i64 %polly.indvar, 31
  %2 = icmp slt i64 1399, %1
  %3 = select i1 %2, i64 1399, i64 %1
  %polly.loop_guard = icmp sle i64 %polly.indvar, %3
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
  %4 = add i64 %polly.indvar11, 31
  %5 = icmp slt i64 1199, %4
  %6 = select i1 %5, i64 1199, i64 %4
  %polly.loop_guard25 = icmp sle i64 %polly.indvar11, %6
  br i1 %polly.loop_guard25, label %polly.loop_header22, label %polly.loop_exit24

polly.loop_exit24:                                ; preds = %polly.loop_header22, %polly.loop_header15
  %polly.indvar_next19 = add nsw i64 %polly.indvar18, 1
  %polly.adjust_ub = sub i64 %3, 1
  %polly.loop_cond20 = icmp sle i64 %polly.indvar18, %polly.adjust_ub
  br i1 %polly.loop_cond20, label %polly.loop_header15, label %polly.loop_exit17

polly.loop_header22:                              ; preds = %polly.loop_header15, %polly.loop_header22
  %polly.indvar26 = phi i64 [ %polly.indvar_next27, %polly.loop_header22 ], [ %polly.indvar11, %polly.loop_header15 ]
  %p_i.02.moved.to. = trunc i64 %polly.indvar18 to i32
  %p_.moved.to. = sitofp i32 %p_i.02.moved.to. to double
  %p_scevgep = getelementptr [1200 x double]* %data, i64 %polly.indvar18, i64 %polly.indvar26
  %p_j.01 = trunc i64 %polly.indvar26 to i32
  %p_ = sitofp i32 %p_j.01 to double
  %p_30 = fmul double %p_.moved.to., %p_
  %p_31 = fdiv double %p_30, 1.200000e+03
  store double %p_31, double* %p_scevgep
  %p_indvar.next = add i64 %polly.indvar26, 1
  %polly.indvar_next27 = add nsw i64 %polly.indvar26, 1
  %polly.adjust_ub28 = sub i64 %6, 1
  %polly.loop_cond29 = icmp sle i64 %polly.indvar26, %polly.adjust_ub28
  br i1 %polly.loop_cond29, label %polly.loop_header22, label %polly.loop_exit24
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_covariance(i32 %m, i32 %n, double %float_n, [1200 x double]* noalias %data, [1200 x double]* noalias %cov, double* noalias %mean) #0 {
polly.split_new_and_old:
  %0 = zext i32 %m to i64
  %1 = zext i32 %n to i64
  %2 = sext i32 %m to i64
  %3 = icmp sge i64 %2, 1
  %4 = icmp sge i64 %0, 1
  %5 = and i1 %3, %4
  br i1 %5, label %polly.then, label %polly.merge

.preheader.lr.ph:                                 ; preds = %polly.merge
  %6 = add i32 %m, -1
  %7 = zext i32 %6 to i64
  %8 = fadd double %float_n, -1.000000e+00
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %polly.merge167
  %.reg2mem.0 = phi double [ undef, %.preheader.lr.ph ], [ %.reg2mem.1, %polly.merge167 ]
  %indvar21 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next22, %polly.merge167 ]
  %9 = mul i64 %indvar21, -1
  %10 = add i64 %7, %9
  %11 = trunc i64 %10 to i32
  %12 = zext i32 %11 to i64
  %13 = mul i64 %indvar21, 9608
  %i.28 = trunc i64 %indvar21 to i32
  %14 = mul i64 %indvar21, 1201
  %15 = add i64 %12, 1
  %16 = icmp slt i32 %i.28, %m
  br i1 %16, label %polly.cond169, label %polly.merge167

polly.merge167:                                   ; preds = %polly.cond407, %polly.then409, %polly.cond404, %.preheader
  %.reg2mem.1 = phi double [ %.reg2mem.7, %polly.then409 ], [ %.reg2mem.7, %polly.cond407 ], [ %.reg2mem.7, %polly.cond404 ], [ %.reg2mem.0, %.preheader ]
  %indvar.next22 = add i64 %indvar21, 1
  %exitcond30 = icmp ne i64 %indvar.next22, %0
  br i1 %exitcond30, label %.preheader, label %._crit_edge9

._crit_edge9:                                     ; preds = %polly.merge167, %polly.merge
  ret void

polly.merge:                                      ; preds = %polly.then122, %polly.loop_exit135, %polly.cond120, %polly.split_new_and_old
  %17 = icmp sgt i32 %m, 0
  br i1 %17, label %.preheader.lr.ph, label %._crit_edge9

polly.then:                                       ; preds = %polly.split_new_and_old
  %18 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %18
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond64

polly.cond64:                                     ; preds = %polly.then, %polly.loop_header
  %19 = sext i32 %n to i64
  %20 = icmp sge i64 %19, 1
  br i1 %20, label %polly.cond67, label %polly.merge65

polly.merge65:                                    ; preds = %polly.then92, %polly.loop_header94, %polly.cond90, %polly.cond64
  br i1 %polly.loop_guard, label %polly.loop_header109, label %polly.cond120

polly.cond120:                                    ; preds = %polly.merge65, %polly.loop_header109
  %21 = icmp sge i64 %1, 1
  %22 = and i1 %20, %21
  br i1 %22, label %polly.then122, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_scevgep54 = getelementptr double* %mean, i64 %polly.indvar
  store double 0.000000e+00, double* %p_scevgep54
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %18, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond64

polly.cond67:                                     ; preds = %polly.cond64
  %23 = icmp sge i64 %1, 1
  br i1 %23, label %polly.then69, label %polly.cond90

polly.cond90:                                     ; preds = %polly.then69, %polly.loop_exit82, %polly.cond67
  %24 = icmp sle i64 %1, 0
  br i1 %24, label %polly.then92, label %polly.merge65

polly.then69:                                     ; preds = %polly.cond67
  br i1 %polly.loop_guard, label %polly.loop_header71, label %polly.cond90

polly.loop_header71:                              ; preds = %polly.then69, %polly.loop_exit82
  %polly.indvar75 = phi i64 [ %polly.indvar_next76, %polly.loop_exit82 ], [ 0, %polly.then69 ]
  %p_scevgep54.moved.to..lr.ph16 = getelementptr double* %mean, i64 %polly.indvar75
  %.promoted50_p_scalar_ = load double* %p_scevgep54.moved.to..lr.ph16
  %25 = add i64 %1, -1
  %polly.loop_guard83 = icmp sle i64 0, %25
  br i1 %polly.loop_guard83, label %polly.loop_header80, label %polly.loop_exit82

polly.loop_exit82:                                ; preds = %polly.loop_header80, %polly.loop_header71
  %.reg2mem55.0 = phi double [ %p_, %polly.loop_header80 ], [ %.promoted50_p_scalar_, %polly.loop_header71 ]
  store double %.reg2mem55.0, double* %p_scevgep54.moved.to..lr.ph16
  %polly.indvar_next76 = add nsw i64 %polly.indvar75, 1
  %polly.adjust_ub77 = sub i64 %18, 1
  %polly.loop_cond78 = icmp sle i64 %polly.indvar75, %polly.adjust_ub77
  br i1 %polly.loop_cond78, label %polly.loop_header71, label %polly.cond90

polly.loop_header80:                              ; preds = %polly.loop_header71, %polly.loop_header80
  %.reg2mem55.1 = phi double [ %.promoted50_p_scalar_, %polly.loop_header71 ], [ %p_, %polly.loop_header80 ]
  %polly.indvar84 = phi i64 [ %polly.indvar_next85, %polly.loop_header80 ], [ 0, %polly.loop_header71 ]
  %p_scevgep49 = getelementptr [1200 x double]* %data, i64 %polly.indvar84, i64 %polly.indvar75
  %_p_scalar_ = load double* %p_scevgep49
  %p_ = fadd double %_p_scalar_, %.reg2mem55.1
  %p_indvar.next45 = add i64 %polly.indvar84, 1
  %polly.indvar_next85 = add nsw i64 %polly.indvar84, 1
  %polly.adjust_ub86 = sub i64 %25, 1
  %polly.loop_cond87 = icmp sle i64 %polly.indvar84, %polly.adjust_ub86
  br i1 %polly.loop_cond87, label %polly.loop_header80, label %polly.loop_exit82

polly.then92:                                     ; preds = %polly.cond90
  br i1 %polly.loop_guard, label %polly.loop_header94, label %polly.merge65

polly.loop_header94:                              ; preds = %polly.then92, %polly.loop_header94
  %polly.indvar98 = phi i64 [ %polly.indvar_next99, %polly.loop_header94 ], [ 0, %polly.then92 ]
  %p_scevgep54.moved.to..lr.ph16103 = getelementptr double* %mean, i64 %polly.indvar98
  %.promoted50_p_scalar_104 = load double* %p_scevgep54.moved.to..lr.ph16103
  store double %.promoted50_p_scalar_104, double* %p_scevgep54.moved.to..lr.ph16103
  %polly.indvar_next99 = add nsw i64 %polly.indvar98, 1
  %polly.adjust_ub100 = sub i64 %18, 1
  %polly.loop_cond101 = icmp sle i64 %polly.indvar98, %polly.adjust_ub100
  br i1 %polly.loop_cond101, label %polly.loop_header94, label %polly.merge65

polly.loop_header109:                             ; preds = %polly.merge65, %polly.loop_header109
  %polly.indvar113 = phi i64 [ %polly.indvar_next114, %polly.loop_header109 ], [ 0, %polly.merge65 ]
  %p_scevgep54.moved.to. = getelementptr double* %mean, i64 %polly.indvar113
  %_p_scalar_118 = load double* %p_scevgep54.moved.to.
  %p_119 = fdiv double %_p_scalar_118, %float_n
  store double %p_119, double* %p_scevgep54.moved.to.
  %p_indvar.next48 = add i64 %polly.indvar113, 1
  %polly.indvar_next114 = add nsw i64 %polly.indvar113, 1
  %polly.adjust_ub115 = sub i64 %18, 1
  %polly.loop_cond116 = icmp sle i64 %polly.indvar113, %polly.adjust_ub115
  br i1 %polly.loop_cond116, label %polly.loop_header109, label %polly.cond120

polly.then122:                                    ; preds = %polly.cond120
  %26 = add i64 %1, -1
  %polly.loop_guard127 = icmp sle i64 0, %26
  br i1 %polly.loop_guard127, label %polly.loop_header124, label %polly.merge

polly.loop_header124:                             ; preds = %polly.then122, %polly.loop_exit135
  %polly.indvar128 = phi i64 [ %polly.indvar_next129, %polly.loop_exit135 ], [ 0, %polly.then122 ]
  %27 = mul i64 -3, %1
  %28 = add i64 %0, %27
  %29 = add i64 %28, 5
  %30 = sub i64 %29, 32
  %31 = add i64 %30, 1
  %32 = icmp slt i64 %29, 0
  %33 = select i1 %32, i64 %31, i64 %29
  %34 = sdiv i64 %33, 32
  %35 = mul i64 -32, %34
  %36 = mul i64 -32, %1
  %37 = add i64 %35, %36
  %38 = mul i64 -32, %polly.indvar128
  %39 = mul i64 -3, %polly.indvar128
  %40 = add i64 %39, %0
  %41 = add i64 %40, 5
  %42 = sub i64 %41, 32
  %43 = add i64 %42, 1
  %44 = icmp slt i64 %41, 0
  %45 = select i1 %44, i64 %43, i64 %41
  %46 = sdiv i64 %45, 32
  %47 = mul i64 -32, %46
  %48 = add i64 %38, %47
  %49 = add i64 %48, -640
  %50 = icmp sgt i64 %37, %49
  %51 = select i1 %50, i64 %37, i64 %49
  %52 = mul i64 -20, %polly.indvar128
  %polly.loop_guard136 = icmp sle i64 %51, %52
  br i1 %polly.loop_guard136, label %polly.loop_header133, label %polly.loop_exit135

polly.loop_exit135:                               ; preds = %polly.loop_exit144, %polly.loop_header124
  %polly.indvar_next129 = add nsw i64 %polly.indvar128, 32
  %polly.adjust_ub130 = sub i64 %26, 32
  %polly.loop_cond131 = icmp sle i64 %polly.indvar128, %polly.adjust_ub130
  br i1 %polly.loop_cond131, label %polly.loop_header124, label %polly.merge

polly.loop_header133:                             ; preds = %polly.loop_header124, %polly.loop_exit144
  %polly.indvar137 = phi i64 [ %polly.indvar_next138, %polly.loop_exit144 ], [ %51, %polly.loop_header124 ]
  %53 = mul i64 -1, %polly.indvar137
  %54 = mul i64 -1, %0
  %55 = add i64 %53, %54
  %56 = add i64 %55, -30
  %57 = add i64 %56, 20
  %58 = sub i64 %57, 1
  %59 = icmp slt i64 %56, 0
  %60 = select i1 %59, i64 %56, i64 %58
  %61 = sdiv i64 %60, 20
  %62 = icmp sgt i64 %61, %polly.indvar128
  %63 = select i1 %62, i64 %61, i64 %polly.indvar128
  %64 = sub i64 %53, 20
  %65 = add i64 %64, 1
  %66 = icmp slt i64 %53, 0
  %67 = select i1 %66, i64 %65, i64 %53
  %68 = sdiv i64 %67, 20
  %69 = add i64 %polly.indvar128, 31
  %70 = icmp slt i64 %68, %69
  %71 = select i1 %70, i64 %68, i64 %69
  %72 = icmp slt i64 %71, %26
  %73 = select i1 %72, i64 %71, i64 %26
  %polly.loop_guard145 = icmp sle i64 %63, %73
  br i1 %polly.loop_guard145, label %polly.loop_header142, label %polly.loop_exit144

polly.loop_exit144:                               ; preds = %polly.loop_exit153, %polly.loop_header133
  %polly.indvar_next138 = add nsw i64 %polly.indvar137, 32
  %polly.adjust_ub139 = sub i64 %52, 32
  %polly.loop_cond140 = icmp sle i64 %polly.indvar137, %polly.adjust_ub139
  br i1 %polly.loop_cond140, label %polly.loop_header133, label %polly.loop_exit135

polly.loop_header142:                             ; preds = %polly.loop_header133, %polly.loop_exit153
  %polly.indvar146 = phi i64 [ %polly.indvar_next147, %polly.loop_exit153 ], [ %63, %polly.loop_header133 ]
  %74 = mul i64 -20, %polly.indvar146
  %75 = add i64 %74, %54
  %76 = add i64 %75, 1
  %77 = icmp sgt i64 %polly.indvar137, %76
  %78 = select i1 %77, i64 %polly.indvar137, i64 %76
  %79 = add i64 %polly.indvar137, 31
  %80 = icmp slt i64 %74, %79
  %81 = select i1 %80, i64 %74, i64 %79
  %polly.loop_guard154 = icmp sle i64 %78, %81
  br i1 %polly.loop_guard154, label %polly.loop_header151, label %polly.loop_exit153

polly.loop_exit153:                               ; preds = %polly.loop_header151, %polly.loop_header142
  %polly.indvar_next147 = add nsw i64 %polly.indvar146, 1
  %polly.adjust_ub148 = sub i64 %73, 1
  %polly.loop_cond149 = icmp sle i64 %polly.indvar146, %polly.adjust_ub148
  br i1 %polly.loop_cond149, label %polly.loop_header142, label %polly.loop_exit144

polly.loop_header151:                             ; preds = %polly.loop_header142, %polly.loop_header151
  %polly.indvar155 = phi i64 [ %polly.indvar_next156, %polly.loop_header151 ], [ %78, %polly.loop_header142 ]
  %82 = mul i64 -1, %polly.indvar155
  %83 = add i64 %74, %82
  %p_scevgep41 = getelementptr [1200 x double]* %data, i64 %polly.indvar146, i64 %83
  %p_scevgep38 = getelementptr double* %mean, i64 %83
  %_p_scalar_160 = load double* %p_scevgep38
  %_p_scalar_161 = load double* %p_scevgep41
  %p_162 = fsub double %_p_scalar_161, %_p_scalar_160
  store double %p_162, double* %p_scevgep41
  %p_indvar.next36 = add i64 %83, 1
  %polly.indvar_next156 = add nsw i64 %polly.indvar155, 1
  %polly.adjust_ub157 = sub i64 %81, 1
  %polly.loop_cond158 = icmp sle i64 %polly.indvar155, %polly.adjust_ub157
  br i1 %polly.loop_cond158, label %polly.loop_header151, label %polly.loop_exit153

polly.cond169:                                    ; preds = %.preheader
  %84 = srem i64 %13, 8
  %85 = icmp eq i64 %84, 0
  br i1 %85, label %polly.cond172, label %polly.cond191

polly.cond191:                                    ; preds = %polly.stmt.175, %polly.loop_header178, %polly.cond172, %polly.cond169
  %.reg2mem.2 = phi double [ %p_190, %polly.loop_header178 ], [ 0.000000e+00, %polly.stmt.175 ], [ %.reg2mem.0, %polly.cond172 ], [ %.reg2mem.0, %polly.cond169 ]
  br i1 %85, label %polly.cond194, label %polly.cond205

polly.cond205:                                    ; preds = %polly.cond194, %polly.stmt.197, %polly.cond191
  %.reg2mem.3 = phi double [ 0.000000e+00, %polly.stmt.197 ], [ %.reg2mem.2, %polly.cond194 ], [ %.reg2mem.2, %polly.cond191 ]
  br i1 %85, label %polly.cond208, label %polly.cond215

polly.cond215:                                    ; preds = %polly.cond208, %polly.stmt.211, %polly.cond205
  br i1 %85, label %polly.cond218, label %polly.cond263

polly.cond263:                                    ; preds = %polly.then220, %polly.loop_exit246, %polly.cond218, %polly.cond215
  %.reg2mem.4 = phi double [ %.reg2mem.10, %polly.loop_exit246 ], [ %.reg2mem.3, %polly.then220 ], [ %.reg2mem.3, %polly.cond218 ], [ %.reg2mem.3, %polly.cond215 ]
  br i1 %85, label %polly.cond266, label %polly.cond299

polly.cond299:                                    ; preds = %polly.then268, %polly.loop_header270, %polly.cond266, %polly.cond263
  %.reg2mem.5 = phi double [ %.promoted_p_scalar_298, %polly.loop_header270 ], [ %.reg2mem.4, %polly.then268 ], [ %.reg2mem.4, %polly.cond266 ], [ %.reg2mem.4, %polly.cond263 ]
  br i1 %85, label %polly.cond302, label %polly.cond327

polly.cond327:                                    ; preds = %polly.then304, %polly.loop_header306, %polly.cond302, %polly.cond299
  %86 = add i64 %13, 7
  %87 = srem i64 %86, 8
  %88 = icmp sle i64 %87, 6
  br i1 %88, label %polly.cond330, label %polly.cond366

polly.cond366:                                    ; preds = %polly.then332, %polly.loop_exit349, %polly.cond330, %polly.cond327
  %.reg2mem.6 = phi double [ %.reg2mem.13, %polly.loop_exit349 ], [ %.reg2mem.5, %polly.then332 ], [ %.reg2mem.5, %polly.cond330 ], [ %.reg2mem.5, %polly.cond327 ]
  br i1 %88, label %polly.cond369, label %polly.cond385

polly.cond385:                                    ; preds = %polly.then371, %polly.loop_header373, %polly.cond369, %polly.cond366
  %.reg2mem.7 = phi double [ %.promoted_p_scalar_384, %polly.loop_header373 ], [ %.reg2mem.6, %polly.then371 ], [ %.reg2mem.6, %polly.cond369 ], [ %.reg2mem.6, %polly.cond366 ]
  br i1 %85, label %polly.cond388, label %polly.cond404

polly.cond404:                                    ; preds = %polly.cond388, %polly.then390, %polly.cond385
  br i1 %85, label %polly.cond407, label %polly.merge167

polly.cond172:                                    ; preds = %polly.cond169
  %89 = sext i32 %n to i64
  %90 = icmp sge i64 %89, 1
  %91 = icmp sge i64 %1, 1
  %92 = and i1 %90, %91
  br i1 %92, label %polly.stmt.175, label %polly.cond191

polly.stmt.175:                                   ; preds = %polly.cond172
  %p_scevgep28 = getelementptr [1200 x double]* %cov, i64 0, i64 %14
  store double 0.000000e+00, double* %p_scevgep28
  %93 = add i64 %1, -1
  %polly.loop_guard181 = icmp sle i64 0, %93
  br i1 %polly.loop_guard181, label %polly.loop_header178, label %polly.cond191

polly.loop_header178:                             ; preds = %polly.stmt.175, %polly.loop_header178
  %.reg2mem.8 = phi double [ 0.000000e+00, %polly.stmt.175 ], [ %p_190, %polly.loop_header178 ]
  %polly.indvar182 = phi i64 [ %polly.indvar_next183, %polly.loop_header178 ], [ 0, %polly.stmt.175 ]
  %p_scevgep25 = getelementptr [1200 x double]* %data, i64 %polly.indvar182, i64 %indvar21
  %_p_scalar_187 = load double* %p_scevgep25
  %p_189 = fmul double %_p_scalar_187, %_p_scalar_187
  %p_190 = fadd double %.reg2mem.8, %p_189
  %p_indvar.next = add i64 %polly.indvar182, 1
  %polly.indvar_next183 = add nsw i64 %polly.indvar182, 1
  %polly.adjust_ub184 = sub i64 %93, 1
  %polly.loop_cond185 = icmp sle i64 %polly.indvar182, %polly.adjust_ub184
  br i1 %polly.loop_cond185, label %polly.loop_header178, label %polly.cond191

polly.cond194:                                    ; preds = %polly.cond191
  %94 = sext i32 %n to i64
  %95 = icmp sge i64 %94, 1
  %96 = icmp sle i64 %1, 0
  %97 = and i1 %95, %96
  br i1 %97, label %polly.stmt.197, label %polly.cond205

polly.stmt.197:                                   ; preds = %polly.cond194
  %p_scevgep28200 = getelementptr [1200 x double]* %cov, i64 0, i64 %14
  store double 0.000000e+00, double* %p_scevgep28200
  br label %polly.cond205

polly.cond208:                                    ; preds = %polly.cond205
  %98 = sext i32 %n to i64
  %99 = icmp sle i64 %98, 0
  br i1 %99, label %polly.stmt.211, label %polly.cond215

polly.stmt.211:                                   ; preds = %polly.cond208
  %p_scevgep28214 = getelementptr [1200 x double]* %cov, i64 0, i64 %14
  store double 0.000000e+00, double* %p_scevgep28214
  br label %polly.cond215

polly.cond218:                                    ; preds = %polly.cond215
  %100 = sext i32 %n to i64
  %101 = icmp sge i64 %100, 1
  %102 = icmp sge i64 %1, 1
  %103 = and i1 %101, %102
  br i1 %103, label %polly.then220, label %polly.cond263

polly.then220:                                    ; preds = %polly.cond218
  %polly.loop_guard225 = icmp sle i64 1, %12
  br i1 %polly.loop_guard225, label %polly.loop_header222, label %polly.cond263

polly.loop_header222:                             ; preds = %polly.then220, %polly.loop_exit246
  %.reg2mem.9 = phi double [ %.reg2mem.3, %polly.then220 ], [ %.reg2mem.10, %polly.loop_exit246 ]
  %polly.indvar226 = phi i64 [ %polly.indvar_next227, %polly.loop_exit246 ], [ 1, %polly.then220 ]
  %p_232 = add i64 %14, %polly.indvar226
  %p_scevgep28233 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_232
  store double 0.000000e+00, double* %p_scevgep28233
  %104 = add i64 %polly.indvar226, -1
  %p_.moved.to.._crit_edge = add i64 %14, %104
  %p_scevgep28.moved.to.._crit_edge = getelementptr [1200 x double]* %cov, i64 0, i64 %p_.moved.to.._crit_edge
  %p_scevgep29.moved.to. = getelementptr [1200 x double]* %cov, i64 %104, i64 %14
  %p_237 = fdiv double %.reg2mem.9, %8
  store double %p_237, double* %p_scevgep28.moved.to.._crit_edge
  %_p_scalar_238 = load double* %p_scevgep28.moved.to.._crit_edge
  store double %_p_scalar_238, double* %p_scevgep29.moved.to.
  %.promoted_p_scalar_242 = load double* %p_scevgep28233
  %105 = add i64 %1, -1
  %polly.loop_guard247 = icmp sle i64 0, %105
  br i1 %polly.loop_guard247, label %polly.loop_header244, label %polly.loop_exit246

polly.loop_exit246:                               ; preds = %polly.loop_header244, %polly.loop_header222
  %.reg2mem.10 = phi double [ %p_260, %polly.loop_header244 ], [ %.promoted_p_scalar_242, %polly.loop_header222 ]
  %polly.indvar_next227 = add nsw i64 %polly.indvar226, 1
  %polly.adjust_ub228 = sub i64 %12, 1
  %polly.loop_cond229 = icmp sle i64 %polly.indvar226, %polly.adjust_ub228
  br i1 %polly.loop_cond229, label %polly.loop_header222, label %polly.cond263

polly.loop_header244:                             ; preds = %polly.loop_header222, %polly.loop_header244
  %.reg2mem.11 = phi double [ %.promoted_p_scalar_242, %polly.loop_header222 ], [ %p_260, %polly.loop_header244 ]
  %polly.indvar248 = phi i64 [ %polly.indvar_next249, %polly.loop_header244 ], [ 0, %polly.loop_header222 ]
  %p_.moved.to.62253 = add i64 %indvar21, %polly.indvar226
  %p_scevgep25255 = getelementptr [1200 x double]* %data, i64 %polly.indvar248, i64 %p_.moved.to.62253
  %p_scevgep256 = getelementptr [1200 x double]* %data, i64 %polly.indvar248, i64 %indvar21
  %_p_scalar_257 = load double* %p_scevgep256
  %_p_scalar_258 = load double* %p_scevgep25255
  %p_259 = fmul double %_p_scalar_257, %_p_scalar_258
  %p_260 = fadd double %.reg2mem.11, %p_259
  %p_indvar.next261 = add i64 %polly.indvar248, 1
  %polly.indvar_next249 = add nsw i64 %polly.indvar248, 1
  %polly.adjust_ub250 = sub i64 %105, 1
  %polly.loop_cond251 = icmp sle i64 %polly.indvar248, %polly.adjust_ub250
  br i1 %polly.loop_cond251, label %polly.loop_header244, label %polly.loop_exit246

polly.cond266:                                    ; preds = %polly.cond263
  %106 = sext i32 %n to i64
  %107 = icmp sge i64 %106, 1
  %108 = icmp sle i64 %1, 0
  %109 = and i1 %107, %108
  br i1 %109, label %polly.then268, label %polly.cond299

polly.then268:                                    ; preds = %polly.cond266
  %polly.loop_guard273 = icmp sle i64 1, %12
  br i1 %polly.loop_guard273, label %polly.loop_header270, label %polly.cond299

polly.loop_header270:                             ; preds = %polly.then268, %polly.loop_header270
  %.reg2mem.12 = phi double [ %.reg2mem.4, %polly.then268 ], [ %.promoted_p_scalar_298, %polly.loop_header270 ]
  %polly.indvar274 = phi i64 [ %polly.indvar_next275, %polly.loop_header270 ], [ 1, %polly.then268 ]
  %p_280 = add i64 %14, %polly.indvar274
  %p_scevgep28281 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_280
  store double 0.000000e+00, double* %p_scevgep28281
  %110 = add i64 %polly.indvar274, -1
  %p_.moved.to.._crit_edge283 = add i64 %14, %110
  %p_scevgep28.moved.to.._crit_edge284 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_.moved.to.._crit_edge283
  %p_scevgep29.moved.to.289 = getelementptr [1200 x double]* %cov, i64 %110, i64 %14
  %p_291 = fdiv double %.reg2mem.12, %8
  store double %p_291, double* %p_scevgep28.moved.to.._crit_edge284
  %_p_scalar_292 = load double* %p_scevgep28.moved.to.._crit_edge284
  store double %_p_scalar_292, double* %p_scevgep29.moved.to.289
  %.promoted_p_scalar_298 = load double* %p_scevgep28281
  %polly.indvar_next275 = add nsw i64 %polly.indvar274, 1
  %polly.adjust_ub276 = sub i64 %12, 1
  %polly.loop_cond277 = icmp sle i64 %polly.indvar274, %polly.adjust_ub276
  br i1 %polly.loop_cond277, label %polly.loop_header270, label %polly.cond299

polly.cond302:                                    ; preds = %polly.cond299
  %111 = sext i32 %n to i64
  %112 = icmp sle i64 %111, 0
  br i1 %112, label %polly.then304, label %polly.cond327

polly.then304:                                    ; preds = %polly.cond302
  %polly.loop_guard309 = icmp sle i64 1, %12
  br i1 %polly.loop_guard309, label %polly.loop_header306, label %polly.cond327

polly.loop_header306:                             ; preds = %polly.then304, %polly.loop_header306
  %polly.indvar310 = phi i64 [ %polly.indvar_next311, %polly.loop_header306 ], [ 1, %polly.then304 ]
  %p_316 = add i64 %14, %polly.indvar310
  %p_scevgep28317 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_316
  store double 0.000000e+00, double* %p_scevgep28317
  %113 = add i64 %polly.indvar310, -1
  %p_.moved.to.63319 = add i64 %14, %113
  %p_scevgep28.moved.to.320 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_.moved.to.63319
  %p_scevgep29.moved.to.321 = getelementptr [1200 x double]* %cov, i64 %113, i64 %14
  %_p_scalar_322 = load double* %p_scevgep28.moved.to.320
  %p_323 = fdiv double %_p_scalar_322, %8
  store double %p_323, double* %p_scevgep28.moved.to.320
  store double %p_323, double* %p_scevgep29.moved.to.321
  %polly.indvar_next311 = add nsw i64 %polly.indvar310, 1
  %polly.adjust_ub312 = sub i64 %12, 1
  %polly.loop_cond313 = icmp sle i64 %polly.indvar310, %polly.adjust_ub312
  br i1 %polly.loop_cond313, label %polly.loop_header306, label %polly.cond327

polly.cond330:                                    ; preds = %polly.cond327
  %114 = sext i32 %n to i64
  %115 = icmp sge i64 %114, 1
  %116 = icmp sge i64 %1, 1
  %117 = and i1 %115, %116
  br i1 %117, label %polly.then332, label %polly.cond366

polly.then332:                                    ; preds = %polly.cond330
  br i1 true, label %polly.loop_header334, label %polly.cond366

polly.loop_header334:                             ; preds = %polly.then332, %polly.loop_exit349
  %polly.indvar338 = phi i64 [ %polly.indvar_next339, %polly.loop_exit349 ], [ 0, %polly.then332 ]
  %p_.moved.to..lr.ph343 = add i64 %14, %polly.indvar338
  %p_scevgep28.moved.to..lr.ph344 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_.moved.to..lr.ph343
  %.promoted_p_scalar_345 = load double* %p_scevgep28.moved.to..lr.ph344
  %118 = add i64 %1, -1
  %polly.loop_guard350 = icmp sle i64 0, %118
  br i1 %polly.loop_guard350, label %polly.loop_header347, label %polly.loop_exit349

polly.loop_exit349:                               ; preds = %polly.loop_header347, %polly.loop_header334
  %.reg2mem.13 = phi double [ %p_363, %polly.loop_header347 ], [ %.promoted_p_scalar_345, %polly.loop_header334 ]
  %polly.indvar_next339 = add nsw i64 %polly.indvar338, 1
  %polly.adjust_ub340 = sub i64 %12, 1
  %polly.loop_cond341 = icmp sle i64 %polly.indvar338, %polly.adjust_ub340
  br i1 %polly.loop_cond341, label %polly.loop_header334, label %polly.cond366

polly.loop_header347:                             ; preds = %polly.loop_header334, %polly.loop_header347
  %.reg2mem.14 = phi double [ %.promoted_p_scalar_345, %polly.loop_header334 ], [ %p_363, %polly.loop_header347 ]
  %polly.indvar351 = phi i64 [ %polly.indvar_next352, %polly.loop_header347 ], [ 0, %polly.loop_header334 ]
  %p_.moved.to.62356 = add i64 %indvar21, %polly.indvar338
  %p_scevgep25358 = getelementptr [1200 x double]* %data, i64 %polly.indvar351, i64 %p_.moved.to.62356
  %p_scevgep359 = getelementptr [1200 x double]* %data, i64 %polly.indvar351, i64 %indvar21
  %_p_scalar_360 = load double* %p_scevgep359
  %_p_scalar_361 = load double* %p_scevgep25358
  %p_362 = fmul double %_p_scalar_360, %_p_scalar_361
  %p_363 = fadd double %.reg2mem.14, %p_362
  %p_indvar.next364 = add i64 %polly.indvar351, 1
  %polly.indvar_next352 = add nsw i64 %polly.indvar351, 1
  %polly.adjust_ub353 = sub i64 %118, 1
  %polly.loop_cond354 = icmp sle i64 %polly.indvar351, %polly.adjust_ub353
  br i1 %polly.loop_cond354, label %polly.loop_header347, label %polly.loop_exit349

polly.cond369:                                    ; preds = %polly.cond366
  %119 = sext i32 %n to i64
  %120 = icmp sge i64 %119, 1
  %121 = icmp sle i64 %1, 0
  %122 = and i1 %120, %121
  br i1 %122, label %polly.then371, label %polly.cond385

polly.then371:                                    ; preds = %polly.cond369
  br i1 true, label %polly.loop_header373, label %polly.cond385

polly.loop_header373:                             ; preds = %polly.then371, %polly.loop_header373
  %polly.indvar377 = phi i64 [ %polly.indvar_next378, %polly.loop_header373 ], [ 0, %polly.then371 ]
  %p_.moved.to..lr.ph382 = add i64 %14, %polly.indvar377
  %p_scevgep28.moved.to..lr.ph383 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_.moved.to..lr.ph382
  %.promoted_p_scalar_384 = load double* %p_scevgep28.moved.to..lr.ph383
  %polly.indvar_next378 = add nsw i64 %polly.indvar377, 1
  %polly.adjust_ub379 = sub i64 %12, 1
  %polly.loop_cond380 = icmp sle i64 %polly.indvar377, %polly.adjust_ub379
  br i1 %polly.loop_cond380, label %polly.loop_header373, label %polly.cond385

polly.cond388:                                    ; preds = %polly.cond385
  %123 = sext i32 %n to i64
  %124 = icmp sge i64 %123, 1
  br i1 %124, label %polly.then390, label %polly.cond404

polly.then390:                                    ; preds = %polly.cond388
  %p_.moved.to.._crit_edge392 = add i64 %14, %12
  %p_scevgep28.moved.to.._crit_edge393 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_.moved.to.._crit_edge392
  %p_scevgep29.moved.to.398 = getelementptr [1200 x double]* %cov, i64 %12, i64 %14
  %p_400 = fdiv double %.reg2mem.7, %8
  store double %p_400, double* %p_scevgep28.moved.to.._crit_edge393
  %_p_scalar_401 = load double* %p_scevgep28.moved.to.._crit_edge393
  store double %_p_scalar_401, double* %p_scevgep29.moved.to.398
  br label %polly.cond404

polly.cond407:                                    ; preds = %polly.cond404
  %125 = sext i32 %n to i64
  %126 = icmp sle i64 %125, 0
  br i1 %126, label %polly.then409, label %polly.merge167

polly.then409:                                    ; preds = %polly.cond407
  %p_.moved.to.63411 = add i64 %14, %12
  %p_scevgep28.moved.to.412 = getelementptr [1200 x double]* %cov, i64 0, i64 %p_.moved.to.63411
  %p_scevgep29.moved.to.413 = getelementptr [1200 x double]* %cov, i64 %12, i64 %14
  %_p_scalar_414 = load double* %p_scevgep28.moved.to.412
  %p_415 = fdiv double %_p_scalar_414, %8
  store double %p_415, double* %p_scevgep28.moved.to.412
  store double %p_415, double* %p_scevgep29.moved.to.413
  br label %polly.merge167
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %m, [1200 x double]* noalias %cov) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([4 x i8]* @.str3, i64 0, i64 0)) #5
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
  %scevgep = getelementptr [1200 x double]* %cov, i64 %indvar4, i64 %indvar
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
  %24 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([4 x i8]* @.str3, i64 0, i64 0)) #5
  %25 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
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
!2 = metadata !{metadata !"double", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{metadata !6, metadata !6, i64 0}
!6 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!7 = metadata !{metadata !3, metadata !3, i64 0}
