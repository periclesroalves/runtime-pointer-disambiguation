; ModuleID = './stencils/heat-3d/heat-3d.c'
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
  %0 = tail call i8* @polybench_alloc_data(i64 1728000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 1728000, i32 8) #3
  %2 = bitcast i8* %0 to [120 x [120 x double]]*
  %3 = bitcast i8* %1 to [120 x [120 x double]]*
  tail call void @init_array(i32 120, [120 x [120 x double]]* %2, [120 x [120 x double]]* %3)
  tail call void (...)* @polybench_timer_start() #3
  tail call void @kernel_heat_3d(i32 500, i32 120, [120 x [120 x double]]* %2, [120 x [120 x double]]* %3)
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
  tail call void @print_array(i32 120, [120 x [120 x double]]* %2)
  br label %9

; <label>:9                                       ; preds = %5, %8, %.split
  tail call void @free(i8* %0) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %n, [120 x [120 x double]]* noalias %A, [120 x [120 x double]]* noalias %B) #0 {
polly.split_new_and_old:
  %0 = zext i32 %n to i64
  %1 = sext i32 %n to i64
  %2 = icmp sge i64 %1, 1
  %3 = icmp sge i64 %0, 1
  %4 = and i1 %2, %3
  br i1 %4, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit28, %polly.split_new_and_old
  ret void

polly.then:                                       ; preds = %polly.split_new_and_old
  %5 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %5
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit28
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit28 ], [ 0, %polly.then ]
  br i1 %polly.loop_guard, label %polly.loop_header26, label %polly.loop_exit28

polly.loop_exit28:                                ; preds = %polly.loop_exit37, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %5, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header26:                              ; preds = %polly.loop_header, %polly.loop_exit37
  %polly.indvar30 = phi i64 [ %polly.indvar_next31, %polly.loop_exit37 ], [ 0, %polly.loop_header ]
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
  %16 = mul i64 -32, %polly.indvar30
  %17 = mul i64 -3, %polly.indvar30
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
  %30 = mul i64 -20, %polly.indvar30
  %polly.loop_guard38 = icmp sle i64 %29, %30
  br i1 %polly.loop_guard38, label %polly.loop_header35, label %polly.loop_exit37

polly.loop_exit37:                                ; preds = %polly.loop_exit46, %polly.loop_header26
  %polly.indvar_next31 = add nsw i64 %polly.indvar30, 32
  %polly.adjust_ub32 = sub i64 %5, 32
  %polly.loop_cond33 = icmp sle i64 %polly.indvar30, %polly.adjust_ub32
  br i1 %polly.loop_cond33, label %polly.loop_header26, label %polly.loop_exit28

polly.loop_header35:                              ; preds = %polly.loop_header26, %polly.loop_exit46
  %polly.indvar39 = phi i64 [ %polly.indvar_next40, %polly.loop_exit46 ], [ %29, %polly.loop_header26 ]
  %31 = mul i64 -1, %polly.indvar39
  %32 = mul i64 -1, %0
  %33 = add i64 %31, %32
  %34 = add i64 %33, -30
  %35 = add i64 %34, 20
  %36 = sub i64 %35, 1
  %37 = icmp slt i64 %34, 0
  %38 = select i1 %37, i64 %34, i64 %36
  %39 = sdiv i64 %38, 20
  %40 = icmp sgt i64 %39, %polly.indvar30
  %41 = select i1 %40, i64 %39, i64 %polly.indvar30
  %42 = sub i64 %31, 20
  %43 = add i64 %42, 1
  %44 = icmp slt i64 %31, 0
  %45 = select i1 %44, i64 %43, i64 %31
  %46 = sdiv i64 %45, 20
  %47 = add i64 %polly.indvar30, 31
  %48 = icmp slt i64 %46, %47
  %49 = select i1 %48, i64 %46, i64 %47
  %50 = icmp slt i64 %49, %5
  %51 = select i1 %50, i64 %49, i64 %5
  %polly.loop_guard47 = icmp sle i64 %41, %51
  br i1 %polly.loop_guard47, label %polly.loop_header44, label %polly.loop_exit46

polly.loop_exit46:                                ; preds = %polly.loop_exit55, %polly.loop_header35
  %polly.indvar_next40 = add nsw i64 %polly.indvar39, 32
  %polly.adjust_ub41 = sub i64 %30, 32
  %polly.loop_cond42 = icmp sle i64 %polly.indvar39, %polly.adjust_ub41
  br i1 %polly.loop_cond42, label %polly.loop_header35, label %polly.loop_exit37

polly.loop_header44:                              ; preds = %polly.loop_header35, %polly.loop_exit55
  %polly.indvar48 = phi i64 [ %polly.indvar_next49, %polly.loop_exit55 ], [ %41, %polly.loop_header35 ]
  %52 = mul i64 -20, %polly.indvar48
  %53 = add i64 %52, %32
  %54 = add i64 %53, 1
  %55 = icmp sgt i64 %polly.indvar39, %54
  %56 = select i1 %55, i64 %polly.indvar39, i64 %54
  %57 = add i64 %polly.indvar39, 31
  %58 = icmp slt i64 %52, %57
  %59 = select i1 %58, i64 %52, i64 %57
  %polly.loop_guard56 = icmp sle i64 %56, %59
  br i1 %polly.loop_guard56, label %polly.loop_header53, label %polly.loop_exit55

polly.loop_exit55:                                ; preds = %polly.loop_header53, %polly.loop_header44
  %polly.indvar_next49 = add nsw i64 %polly.indvar48, 1
  %polly.adjust_ub50 = sub i64 %51, 1
  %polly.loop_cond51 = icmp sle i64 %polly.indvar48, %polly.adjust_ub50
  br i1 %polly.loop_cond51, label %polly.loop_header44, label %polly.loop_exit46

polly.loop_header53:                              ; preds = %polly.loop_header44, %polly.loop_header53
  %polly.indvar57 = phi i64 [ %polly.indvar_next58, %polly.loop_header53 ], [ %56, %polly.loop_header44 ]
  %60 = mul i64 -1, %polly.indvar57
  %61 = add i64 %52, %60
  %p_.moved.to.19 = add i64 %0, %polly.indvar
  %p_.moved.to.20 = add i64 %p_.moved.to.19, %polly.indvar48
  %p_.moved.to.21 = sitofp i32 %n to double
  %p_ = mul i64 %61, -1
  %p_61 = add i64 %p_.moved.to.20, %p_
  %p_62 = trunc i64 %p_61 to i32
  %p_scevgep = getelementptr [120 x [120 x double]]* %B, i64 %polly.indvar, i64 %polly.indvar48, i64 %61
  %p_scevgep12 = getelementptr [120 x [120 x double]]* %A, i64 %polly.indvar, i64 %polly.indvar48, i64 %61
  %p_63 = sitofp i32 %p_62 to double
  %p_64 = fmul double %p_63, 1.000000e+01
  %p_65 = fdiv double %p_64, %p_.moved.to.21
  store double %p_65, double* %p_scevgep
  store double %p_65, double* %p_scevgep12
  %p_indvar.next = add i64 %61, 1
  %polly.indvar_next58 = add nsw i64 %polly.indvar57, 1
  %polly.adjust_ub59 = sub i64 %59, 1
  %polly.loop_cond60 = icmp sle i64 %polly.indvar57, %polly.adjust_ub59
  br i1 %polly.loop_cond60, label %polly.loop_header53, label %polly.loop_exit55
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_heat_3d(i32 %tsteps, i32 %n, [120 x [120 x double]]* noalias %A, [120 x [120 x double]]* noalias %B) #0 {
.split:
  %0 = add i32 %n, -3
  %1 = zext i32 %0 to i64
  %2 = add i64 %1, 1
  %3 = add nsw i32 %n, -1
  %4 = sext i32 %n to i64
  %5 = icmp sge i64 %4, 3
  br i1 %5, label %polly.loop_header, label %polly.merge

polly.merge:                                      ; preds = %polly.loop_exit147, %.split
  ret void

polly.loop_header:                                ; preds = %.split, %polly.loop_exit147
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit147 ], [ 0, %.split ]
  br i1 true, label %polly.loop_header95, label %polly.loop_exit97

polly.loop_exit97:                                ; preds = %polly.loop_exit104, %polly.loop_header
  br i1 true, label %polly.loop_header145, label %polly.loop_exit147

polly.loop_exit147:                               ; preds = %polly.loop_exit156, %polly.loop_exit97
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, 498
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header95:                              ; preds = %polly.loop_header, %polly.loop_exit104
  %polly.indvar98 = phi i64 [ %polly.indvar_next99, %polly.loop_exit104 ], [ 0, %polly.loop_header ]
  br i1 true, label %polly.loop_header102, label %polly.loop_exit104

polly.loop_exit104:                               ; preds = %polly.loop_exit113, %polly.loop_header95
  %polly.indvar_next99 = add nsw i64 %polly.indvar98, 1
  %polly.adjust_ub = sub i64 %1, 1
  %polly.loop_cond100 = icmp sle i64 %polly.indvar98, %polly.adjust_ub
  br i1 %polly.loop_cond100, label %polly.loop_header95, label %polly.loop_exit97

polly.loop_header102:                             ; preds = %polly.loop_header95, %polly.loop_exit113
  %polly.indvar106 = phi i64 [ %polly.indvar_next107, %polly.loop_exit113 ], [ 0, %polly.loop_header95 ]
  br i1 true, label %polly.loop_header111, label %polly.loop_exit113

polly.loop_exit113:                               ; preds = %polly.loop_header111, %polly.loop_header102
  %polly.indvar_next107 = add nsw i64 %polly.indvar106, 1
  %polly.adjust_ub108 = sub i64 %1, 1
  %polly.loop_cond109 = icmp sle i64 %polly.indvar106, %polly.adjust_ub108
  br i1 %polly.loop_cond109, label %polly.loop_header102, label %polly.loop_exit104

polly.loop_header111:                             ; preds = %polly.loop_header102, %polly.loop_header111
  %polly.indvar115 = phi i64 [ %polly.indvar_next116, %polly.loop_header111 ], [ 0, %polly.loop_header102 ]
  %p_.moved.to. = add i64 %polly.indvar98, 2
  %p_.moved.to.87 = add i64 %polly.indvar106, 1
  %p_.moved.to.88 = add i64 %polly.indvar98, 1
  %p_.moved.to.89 = add i64 %polly.indvar106, 2
  %p_ = add i64 %polly.indvar115, 1
  %p_scevgep = getelementptr [120 x [120 x double]]* %A, i64 %p_.moved.to., i64 %p_.moved.to.87, i64 %p_
  %p_scevgep27 = getelementptr [120 x [120 x double]]* %A, i64 %polly.indvar98, i64 %p_.moved.to.87, i64 %p_
  %p_scevgep26 = getelementptr [120 x [120 x double]]* %A, i64 %p_.moved.to.88, i64 %p_.moved.to.87, i64 %p_
  %p_119 = add i64 %polly.indvar115, 2
  %p_scevgep30 = getelementptr [120 x [120 x double]]* %A, i64 %p_.moved.to.88, i64 %p_.moved.to.87, i64 %p_119
  %p_scevgep31 = getelementptr [120 x [120 x double]]* %B, i64 %p_.moved.to.88, i64 %p_.moved.to.87, i64 %p_
  %p_scevgep32 = getelementptr [120 x [120 x double]]* %A, i64 %p_.moved.to.88, i64 %p_.moved.to.87, i64 %polly.indvar115
  %p_scevgep28 = getelementptr [120 x [120 x double]]* %A, i64 %p_.moved.to.88, i64 %p_.moved.to.89, i64 %p_
  %p_scevgep29 = getelementptr [120 x [120 x double]]* %A, i64 %p_.moved.to.88, i64 %polly.indvar106, i64 %p_
  %_p_scalar_ = load double* %p_scevgep
  %_p_scalar_120 = load double* %p_scevgep26
  %p_121 = fmul double %_p_scalar_120, 2.000000e+00
  %p_122 = fsub double %_p_scalar_, %p_121
  %_p_scalar_123 = load double* %p_scevgep27
  %p_124 = fadd double %_p_scalar_123, %p_122
  %p_125 = fmul double %p_124, 1.250000e-01
  %_p_scalar_126 = load double* %p_scevgep28
  %p_129 = fsub double %_p_scalar_126, %p_121
  %_p_scalar_130 = load double* %p_scevgep29
  %p_131 = fadd double %_p_scalar_130, %p_129
  %p_132 = fmul double %p_131, 1.250000e-01
  %p_133 = fadd double %p_125, %p_132
  %_p_scalar_134 = load double* %p_scevgep30
  %p_137 = fsub double %_p_scalar_134, %p_121
  %_p_scalar_138 = load double* %p_scevgep32
  %p_139 = fadd double %_p_scalar_138, %p_137
  %p_140 = fmul double %p_139, 1.250000e-01
  %p_141 = fadd double %p_133, %p_140
  %p_143 = fadd double %_p_scalar_120, %p_141
  store double %p_143, double* %p_scevgep31
  %polly.indvar_next116 = add nsw i64 %polly.indvar115, 1
  %polly.adjust_ub117 = sub i64 %1, 1
  %polly.loop_cond118 = icmp sle i64 %polly.indvar115, %polly.adjust_ub117
  br i1 %polly.loop_cond118, label %polly.loop_header111, label %polly.loop_exit113

polly.loop_header145:                             ; preds = %polly.loop_exit97, %polly.loop_exit156
  %polly.indvar149 = phi i64 [ %polly.indvar_next150, %polly.loop_exit156 ], [ 0, %polly.loop_exit97 ]
  br i1 true, label %polly.loop_header154, label %polly.loop_exit156

polly.loop_exit156:                               ; preds = %polly.loop_exit165, %polly.loop_header145
  %polly.indvar_next150 = add nsw i64 %polly.indvar149, 1
  %polly.adjust_ub151 = sub i64 %1, 1
  %polly.loop_cond152 = icmp sle i64 %polly.indvar149, %polly.adjust_ub151
  br i1 %polly.loop_cond152, label %polly.loop_header145, label %polly.loop_exit147

polly.loop_header154:                             ; preds = %polly.loop_header145, %polly.loop_exit165
  %polly.indvar158 = phi i64 [ %polly.indvar_next159, %polly.loop_exit165 ], [ 0, %polly.loop_header145 ]
  br i1 true, label %polly.loop_header163, label %polly.loop_exit165

polly.loop_exit165:                               ; preds = %polly.loop_header163, %polly.loop_header154
  %polly.indvar_next159 = add nsw i64 %polly.indvar158, 1
  %polly.adjust_ub160 = sub i64 %1, 1
  %polly.loop_cond161 = icmp sle i64 %polly.indvar158, %polly.adjust_ub160
  br i1 %polly.loop_cond161, label %polly.loop_header154, label %polly.loop_exit156

polly.loop_header163:                             ; preds = %polly.loop_header154, %polly.loop_header163
  %polly.indvar167 = phi i64 [ %polly.indvar_next168, %polly.loop_header163 ], [ 0, %polly.loop_header154 ]
  %p_.moved.to.90 = add i64 %polly.indvar149, 2
  %p_.moved.to.91 = add i64 %polly.indvar158, 1
  %p_.moved.to.92 = add i64 %polly.indvar149, 1
  %p_.moved.to.93 = add i64 %polly.indvar158, 2
  %p_172 = add i64 %polly.indvar167, 1
  %p_scevgep58 = getelementptr [120 x [120 x double]]* %B, i64 %p_.moved.to.90, i64 %p_.moved.to.91, i64 %p_172
  %p_scevgep60 = getelementptr [120 x [120 x double]]* %B, i64 %polly.indvar149, i64 %p_.moved.to.91, i64 %p_172
  %p_scevgep59 = getelementptr [120 x [120 x double]]* %B, i64 %p_.moved.to.92, i64 %p_.moved.to.91, i64 %p_172
  %p_173 = add i64 %polly.indvar167, 2
  %p_scevgep63 = getelementptr [120 x [120 x double]]* %B, i64 %p_.moved.to.92, i64 %p_.moved.to.91, i64 %p_173
  %p_scevgep64 = getelementptr [120 x [120 x double]]* %A, i64 %p_.moved.to.92, i64 %p_.moved.to.91, i64 %p_172
  %p_scevgep65 = getelementptr [120 x [120 x double]]* %B, i64 %p_.moved.to.92, i64 %p_.moved.to.91, i64 %polly.indvar167
  %p_scevgep61 = getelementptr [120 x [120 x double]]* %B, i64 %p_.moved.to.92, i64 %p_.moved.to.93, i64 %p_172
  %p_scevgep62 = getelementptr [120 x [120 x double]]* %B, i64 %p_.moved.to.92, i64 %polly.indvar158, i64 %p_172
  %_p_scalar_174 = load double* %p_scevgep58
  %_p_scalar_175 = load double* %p_scevgep59
  %p_176 = fmul double %_p_scalar_175, 2.000000e+00
  %p_177 = fsub double %_p_scalar_174, %p_176
  %_p_scalar_178 = load double* %p_scevgep60
  %p_179 = fadd double %_p_scalar_178, %p_177
  %p_180 = fmul double %p_179, 1.250000e-01
  %_p_scalar_181 = load double* %p_scevgep61
  %p_184 = fsub double %_p_scalar_181, %p_176
  %_p_scalar_185 = load double* %p_scevgep62
  %p_186 = fadd double %_p_scalar_185, %p_184
  %p_187 = fmul double %p_186, 1.250000e-01
  %p_188 = fadd double %p_180, %p_187
  %_p_scalar_189 = load double* %p_scevgep63
  %p_192 = fsub double %_p_scalar_189, %p_176
  %_p_scalar_193 = load double* %p_scevgep65
  %p_194 = fadd double %_p_scalar_193, %p_192
  %p_195 = fmul double %p_194, 1.250000e-01
  %p_196 = fadd double %p_188, %p_195
  %p_198 = fadd double %_p_scalar_175, %p_196
  store double %p_198, double* %p_scevgep64
  %polly.indvar_next168 = add nsw i64 %polly.indvar167, 1
  %polly.adjust_ub169 = sub i64 %1, 1
  %polly.loop_cond170 = icmp sle i64 %polly.indvar167, %polly.adjust_ub169
  br i1 %polly.loop_cond170, label %polly.loop_header163, label %polly.loop_exit165
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, [120 x [120 x double]]* noalias %A) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %n, 0
  br i1 %5, label %.preheader1.lr.ph, label %29

.preheader1.lr.ph:                                ; preds = %.split
  %6 = zext i32 %n to i64
  %7 = mul i32 %n, %n
  %8 = zext i32 %n to i64
  %9 = zext i32 %n to i64
  %10 = zext i32 %7 to i64
  %11 = icmp sgt i32 %n, 0
  %12 = icmp sgt i32 %n, 0
  br label %.preheader1

.preheader1:                                      ; preds = %.preheader1.lr.ph, %28
  %indvar8 = phi i64 [ 0, %.preheader1.lr.ph ], [ %indvar.next9, %28 ]
  %13 = mul i64 %10, %indvar8
  br i1 %11, label %.preheader.lr.ph, label %28

.preheader.lr.ph:                                 ; preds = %.preheader1
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %27
  %indvar10 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next11, %27 ]
  %14 = mul i64 %9, %indvar10
  %15 = add i64 %13, %14
  br i1 %12, label %.lr.ph, label %27

.lr.ph:                                           ; preds = %.preheader
  br label %16

; <label>:16                                      ; preds = %.lr.ph, %23
  %indvar = phi i64 [ 0, %.lr.ph ], [ %indvar.next, %23 ]
  %scevgep = getelementptr [120 x [120 x double]]* %A, i64 %indvar8, i64 %indvar10, i64 %indvar
  %17 = add i64 %15, %indvar
  %18 = trunc i64 %17 to i32
  %19 = srem i32 %18, 20
  %20 = icmp eq i32 %19, 0
  br i1 %20, label %21, label %23

; <label>:21                                      ; preds = %16
  %22 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %22) #4
  br label %23

; <label>:23                                      ; preds = %21, %16
  %24 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %25 = load double* %scevgep, align 8, !tbaa !6
  %26 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %24, i8* getelementptr inbounds ([8 x i8]* @.str5, i64 0, i64 0), double %25) #5
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %6
  br i1 %exitcond, label %16, label %._crit_edge

._crit_edge:                                      ; preds = %23
  br label %27

; <label>:27                                      ; preds = %._crit_edge, %.preheader
  %indvar.next11 = add i64 %indvar10, 1
  %exitcond12 = icmp ne i64 %indvar.next11, %8
  br i1 %exitcond12, label %.preheader, label %._crit_edge5

._crit_edge5:                                     ; preds = %27
  br label %28

; <label>:28                                      ; preds = %._crit_edge5, %.preheader1
  %indvar.next9 = add i64 %indvar8, 1
  %exitcond14 = icmp ne i64 %indvar.next9, %9
  br i1 %exitcond14, label %.preheader1, label %._crit_edge7

._crit_edge7:                                     ; preds = %28
  br label %29

; <label>:29                                      ; preds = %._crit_edge7, %.split
  %30 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %31 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %30, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %32 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %33 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str7, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %32) #4
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
