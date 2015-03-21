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
define internal void @init_array(i32 %n, [1000 x double]* noalias %u) #0 {
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
define internal void @kernel_adi(i32 %tsteps, i32 %n, [1000 x double]* noalias %u, [1000 x double]* noalias %v, [1000 x double]* noalias %p, [1000 x double]* noalias %q) #0 {
polly.split_new_and_old:
  %0 = add i32 %n, -3
  %1 = zext i32 %0 to i64
  %2 = add i32 %n, -2
  %3 = zext i32 %2 to i64
  %4 = sext i32 %n to i64
  %5 = icmp sge i64 %4, 3
  %6 = sext i32 %tsteps to i64
  %7 = icmp sge i64 %6, 1
  %8 = and i1 %5, %7
  br i1 %8, label %polly.cond170, label %polly.merge

polly.merge:                                      ; preds = %polly.then299, %polly.loop_exit397, %polly.cond297, %polly.split_new_and_old
  ret void

polly.cond170:                                    ; preds = %polly.split_new_and_old
  %9 = icmp sge i64 %3, 1
  br i1 %9, label %polly.then172, label %polly.cond297

polly.cond297:                                    ; preds = %polly.then172, %polly.loop_exit237, %polly.cond170
  %10 = icmp sle i64 %3, 0
  br i1 %10, label %polly.then299, label %polly.merge

polly.then172:                                    ; preds = %polly.cond170
  %11 = add i64 %6, -1
  %polly.loop_guard = icmp sle i64 0, %11
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond297

polly.loop_header:                                ; preds = %polly.then172, %polly.loop_exit237
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit237 ], [ 0, %polly.then172 ]
  br i1 true, label %polly.loop_header174, label %polly.loop_exit176

polly.loop_exit176:                               ; preds = %polly.loop_exit216, %polly.loop_header
  br i1 true, label %polly.loop_header235, label %polly.loop_exit237

polly.loop_exit237:                               ; preds = %polly.loop_exit280, %polly.loop_exit176
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %11, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond297

polly.loop_header174:                             ; preds = %polly.loop_header, %polly.loop_exit216
  %polly.indvar178 = phi i64 [ %polly.indvar_next179, %polly.loop_exit216 ], [ 0, %polly.loop_header ]
  %p_.moved.to. = add nsw i32 %n, -1
  %p_ = add i64 %polly.indvar178, 1
  %p_scevgep49 = getelementptr [1000 x double]* %v, i64 0, i64 %p_
  %p_scevgep51 = getelementptr [1000 x double]* %p, i64 %p_, i64 0
  %p_scevgep52 = getelementptr [1000 x double]* %q, i64 %p_, i64 0
  store double 1.000000e+00, double* %p_scevgep49
  store double 0.000000e+00, double* %p_scevgep51
  %_p_scalar_ = load double* %p_scevgep49
  store double %_p_scalar_, double* %p_scevgep52
  br i1 true, label %polly.loop_header183, label %polly.loop_exit185

polly.loop_exit185:                               ; preds = %polly.loop_header183, %polly.loop_header174
  %p_.moved.to.115 = add i32 %n, -1
  %p_.moved.to.116 = sext i32 %p_.moved.to.115 to i64
  %p_scevgep53.moved.to. = getelementptr [1000 x double]* %v, i64 %p_.moved.to.116, i64 %p_
  %p_.moved.to.118 = add nsw i32 %n, -2
  store double 1.000000e+00, double* %p_scevgep53.moved.to.
  %12 = add i64 %3, -1
  %polly.loop_guard217 = icmp sle i64 0, %12
  br i1 %polly.loop_guard217, label %polly.loop_header214, label %polly.loop_exit216

polly.loop_exit216:                               ; preds = %polly.loop_header214, %polly.loop_exit185
  %polly.indvar_next179 = add nsw i64 %polly.indvar178, 1
  %polly.adjust_ub180 = sub i64 %1, 1
  %polly.loop_cond181 = icmp sle i64 %polly.indvar178, %polly.adjust_ub180
  br i1 %polly.loop_cond181, label %polly.loop_header174, label %polly.loop_exit176

polly.loop_header183:                             ; preds = %polly.loop_header174, %polly.loop_header183
  %polly.indvar187 = phi i64 [ %polly.indvar_next188, %polly.loop_header183 ], [ 0, %polly.loop_header174 ]
  %p_.moved.to.94 = sitofp i32 %tsteps to double
  %p_.moved.to.95 = fdiv double 1.000000e+00, %p_.moved.to.94
  %p_.moved.to.96 = fmul double %p_.moved.to.95, 2.000000e+00
  %p_.moved.to.97 = sitofp i32 %n to double
  %p_.moved.to.98 = fdiv double 1.000000e+00, %p_.moved.to.97
  %p_.moved.to.99 = fmul double %p_.moved.to.98, %p_.moved.to.98
  %p_.moved.to.100 = fdiv double %p_.moved.to.96, %p_.moved.to.99
  %p_.moved.to.101 = fmul double %p_.moved.to.100, -5.000000e-01
  %p_.moved.to.102 = fsub double -0.000000e+00, %p_.moved.to.101
  %p_.moved.to.103 = fadd double %p_.moved.to.100, 1.000000e+00
  %p_.moved.to.104 = add i64 %polly.indvar178, 2
  %p_.moved.to.108 = fdiv double %p_.moved.to.95, %p_.moved.to.99
  %p_.moved.to.109 = fmul double %p_.moved.to.108, -5.000000e-01
  %p_.moved.to.110 = fmul double %p_.moved.to.109, 2.000000e+00
  %p_.moved.to.111 = fadd double %p_.moved.to.110, 1.000000e+00
  %p_.moved.to.114 = add i64 %1, 1
  %p_192 = add i64 %polly.indvar187, 1
  %p_scevgep28 = getelementptr [1000 x double]* %u, i64 %p_192, i64 %p_.moved.to.104
  %p_scevgep26 = getelementptr [1000 x double]* %u, i64 %p_192, i64 %polly.indvar178
  %p_scevgep31 = getelementptr [1000 x double]* %q, i64 %p_, i64 %polly.indvar187
  %p_scevgep30 = getelementptr [1000 x double]* %p, i64 %p_, i64 %polly.indvar187
  %p_scevgep29 = getelementptr [1000 x double]* %q, i64 %p_, i64 %p_192
  %p_scevgep27 = getelementptr [1000 x double]* %u, i64 %p_192, i64 %p_
  %p_scevgep = getelementptr [1000 x double]* %p, i64 %p_, i64 %p_192
  %_p_scalar_193 = load double* %p_scevgep30
  %p_194 = fmul double %p_.moved.to.101, %_p_scalar_193
  %p_195 = fadd double %p_.moved.to.103, %p_194
  %p_196 = fdiv double %p_.moved.to.102, %p_195
  store double %p_196, double* %p_scevgep
  %_p_scalar_197 = load double* %p_scevgep26
  %p_198 = fmul double %p_.moved.to.109, %_p_scalar_197
  %_p_scalar_199 = load double* %p_scevgep27
  %p_200 = fmul double %p_.moved.to.111, %_p_scalar_199
  %p_201 = fsub double %p_200, %p_198
  %_p_scalar_202 = load double* %p_scevgep28
  %p_203 = fmul double %p_.moved.to.109, %_p_scalar_202
  %p_204 = fsub double %p_201, %p_203
  %_p_scalar_205 = load double* %p_scevgep31
  %p_206 = fmul double %p_.moved.to.101, %_p_scalar_205
  %p_207 = fsub double %p_204, %p_206
  %_p_scalar_208 = load double* %p_scevgep30
  %p_209 = fmul double %p_.moved.to.101, %_p_scalar_208
  %p_210 = fadd double %p_.moved.to.103, %p_209
  %p_211 = fdiv double %p_207, %p_210
  store double %p_211, double* %p_scevgep29
  %polly.indvar_next188 = add nsw i64 %polly.indvar187, 1
  %polly.adjust_ub189 = sub i64 %1, 1
  %polly.loop_cond190 = icmp sle i64 %polly.indvar187, %polly.adjust_ub189
  br i1 %polly.loop_cond190, label %polly.loop_header183, label %polly.loop_exit185

polly.loop_header214:                             ; preds = %polly.loop_exit185, %polly.loop_header214
  %polly.indvar218 = phi i64 [ %polly.indvar_next219, %polly.loop_header214 ], [ 0, %polly.loop_exit185 ]
  %p_.moved.to.122 = sext i32 %2 to i64
  %p_.moved.to.124 = zext i32 %p_.moved.to.115 to i64
  %p_223 = mul i64 %polly.indvar218, -1
  %p_224 = add i64 %p_.moved.to.122, %p_223
  %p_scevgep37 = getelementptr [1000 x double]* %v, i64 %p_224, i64 %p_
  %p_scevgep36 = getelementptr [1000 x double]* %q, i64 %p_, i64 %p_224
  %p_scevgep35 = getelementptr [1000 x double]* %p, i64 %p_, i64 %p_224
  %p_225 = add i64 %p_.moved.to.124, %p_223
  %p_226 = trunc i64 %p_225 to i32
  %p_227 = sext i32 %p_226 to i64
  %p_228 = mul i64 %p_227, 1000
  %p_scevgep50 = getelementptr double* %p_scevgep49, i64 %p_228
  %_p_scalar_229 = load double* %p_scevgep35
  %_p_scalar_230 = load double* %p_scevgep50
  %p_231 = fmul double %_p_scalar_229, %_p_scalar_230
  %_p_scalar_232 = load double* %p_scevgep36
  %p_233 = fadd double %p_231, %_p_scalar_232
  store double %p_233, double* %p_scevgep37
  %p_indvar.next33 = add i64 %polly.indvar218, 1
  %polly.indvar_next219 = add nsw i64 %polly.indvar218, 1
  %polly.adjust_ub220 = sub i64 %12, 1
  %polly.loop_cond221 = icmp sle i64 %polly.indvar218, %polly.adjust_ub220
  br i1 %polly.loop_cond221, label %polly.loop_header214, label %polly.loop_exit216

polly.loop_header235:                             ; preds = %polly.loop_exit176, %polly.loop_exit280
  %polly.indvar239 = phi i64 [ %polly.indvar_next240, %polly.loop_exit280 ], [ 0, %polly.loop_exit176 ]
  %p_.moved.to.131 = add nsw i32 %n, -1
  %p_244 = add i64 %polly.indvar239, 1
  %p_scevgep83 = getelementptr [1000 x double]* %u, i64 %p_244, i64 0
  %p_scevgep85 = getelementptr [1000 x double]* %p, i64 %p_244, i64 0
  %p_scevgep86 = getelementptr [1000 x double]* %q, i64 %p_244, i64 0
  store double 1.000000e+00, double* %p_scevgep83
  store double 0.000000e+00, double* %p_scevgep85
  %_p_scalar_245 = load double* %p_scevgep83
  store double %_p_scalar_245, double* %p_scevgep86
  br i1 true, label %polly.loop_header247, label %polly.loop_exit249

polly.loop_exit249:                               ; preds = %polly.loop_header247, %polly.loop_header235
  %p_.moved.to.156 = add i32 %n, -1
  %p_.moved.to.157 = sext i32 %p_.moved.to.156 to i64
  %p_scevgep87.moved.to. = getelementptr [1000 x double]* %u, i64 %p_244, i64 %p_.moved.to.157
  %p_.moved.to.158 = add nsw i32 %n, -2
  store double 1.000000e+00, double* %p_scevgep87.moved.to.
  %13 = add i64 %3, -1
  %polly.loop_guard281 = icmp sle i64 0, %13
  br i1 %polly.loop_guard281, label %polly.loop_header278, label %polly.loop_exit280

polly.loop_exit280:                               ; preds = %polly.loop_header278, %polly.loop_exit249
  %polly.indvar_next240 = add nsw i64 %polly.indvar239, 1
  %polly.adjust_ub241 = sub i64 %1, 1
  %polly.loop_cond242 = icmp sle i64 %polly.indvar239, %polly.adjust_ub241
  br i1 %polly.loop_cond242, label %polly.loop_header235, label %polly.loop_exit237

polly.loop_header247:                             ; preds = %polly.loop_header235, %polly.loop_header247
  %polly.indvar251 = phi i64 [ %polly.indvar_next252, %polly.loop_header247 ], [ 0, %polly.loop_header235 ]
  %p_.moved.to.134 = sitofp i32 %tsteps to double
  %p_.moved.to.135 = fdiv double 1.000000e+00, %p_.moved.to.134
  %p_.moved.to.136 = sitofp i32 %n to double
  %p_.moved.to.137 = fdiv double 1.000000e+00, %p_.moved.to.136
  %p_.moved.to.138 = fmul double %p_.moved.to.137, %p_.moved.to.137
  %p_.moved.to.139 = fdiv double %p_.moved.to.135, %p_.moved.to.138
  %p_.moved.to.140 = fmul double %p_.moved.to.139, -5.000000e-01
  %p_.moved.to.141 = fsub double -0.000000e+00, %p_.moved.to.140
  %p_.moved.to.142 = fadd double %p_.moved.to.139, 1.000000e+00
  %p_.moved.to.143 = add i64 %polly.indvar239, 2
  %p_.moved.to.144 = fmul double %p_.moved.to.135, 2.000000e+00
  %p_.moved.to.148 = fdiv double %p_.moved.to.144, %p_.moved.to.138
  %p_.moved.to.149 = fmul double %p_.moved.to.148, -5.000000e-01
  %p_.moved.to.150 = fmul double %p_.moved.to.149, 2.000000e+00
  %p_.moved.to.151 = fadd double %p_.moved.to.150, 1.000000e+00
  %p_.moved.to.154 = add i64 %1, 1
  %p_256 = add i64 %polly.indvar251, 1
  %p_scevgep62 = getelementptr [1000 x double]* %v, i64 %p_.moved.to.143, i64 %p_256
  %p_scevgep60 = getelementptr [1000 x double]* %v, i64 %polly.indvar239, i64 %p_256
  %p_scevgep65 = getelementptr [1000 x double]* %q, i64 %p_244, i64 %polly.indvar251
  %p_scevgep64 = getelementptr [1000 x double]* %p, i64 %p_244, i64 %polly.indvar251
  %p_scevgep63 = getelementptr [1000 x double]* %q, i64 %p_244, i64 %p_256
  %p_scevgep61 = getelementptr [1000 x double]* %v, i64 %p_244, i64 %p_256
  %p_scevgep59 = getelementptr [1000 x double]* %p, i64 %p_244, i64 %p_256
  %_p_scalar_257 = load double* %p_scevgep64
  %p_258 = fmul double %p_.moved.to.140, %_p_scalar_257
  %p_259 = fadd double %p_.moved.to.142, %p_258
  %p_260 = fdiv double %p_.moved.to.141, %p_259
  store double %p_260, double* %p_scevgep59
  %_p_scalar_261 = load double* %p_scevgep60
  %p_262 = fmul double %p_.moved.to.149, %_p_scalar_261
  %_p_scalar_263 = load double* %p_scevgep61
  %p_264 = fmul double %p_.moved.to.151, %_p_scalar_263
  %p_265 = fsub double %p_264, %p_262
  %_p_scalar_266 = load double* %p_scevgep62
  %p_267 = fmul double %p_.moved.to.149, %_p_scalar_266
  %p_268 = fsub double %p_265, %p_267
  %_p_scalar_269 = load double* %p_scevgep65
  %p_270 = fmul double %p_.moved.to.140, %_p_scalar_269
  %p_271 = fsub double %p_268, %p_270
  %_p_scalar_272 = load double* %p_scevgep64
  %p_273 = fmul double %p_.moved.to.140, %_p_scalar_272
  %p_274 = fadd double %p_.moved.to.142, %p_273
  %p_275 = fdiv double %p_271, %p_274
  store double %p_275, double* %p_scevgep63
  %polly.indvar_next252 = add nsw i64 %polly.indvar251, 1
  %polly.adjust_ub253 = sub i64 %1, 1
  %polly.loop_cond254 = icmp sle i64 %polly.indvar251, %polly.adjust_ub253
  br i1 %polly.loop_cond254, label %polly.loop_header247, label %polly.loop_exit249

polly.loop_header278:                             ; preds = %polly.loop_exit249, %polly.loop_header278
  %polly.indvar282 = phi i64 [ %polly.indvar_next283, %polly.loop_header278 ], [ 0, %polly.loop_exit249 ]
  %p_.moved.to.162 = sext i32 %2 to i64
  %p_.moved.to.164 = zext i32 %p_.moved.to.156 to i64
  %p_287 = mul i64 %polly.indvar282, -1
  %p_288 = add i64 %p_.moved.to.162, %p_287
  %p_scevgep71 = getelementptr [1000 x double]* %u, i64 %p_244, i64 %p_288
  %p_scevgep70 = getelementptr [1000 x double]* %q, i64 %p_244, i64 %p_288
  %p_scevgep69 = getelementptr [1000 x double]* %p, i64 %p_244, i64 %p_288
  %p_289 = add i64 %p_.moved.to.164, %p_287
  %p_290 = trunc i64 %p_289 to i32
  %p_291 = sext i32 %p_290 to i64
  %p_scevgep84 = getelementptr double* %p_scevgep83, i64 %p_291
  %_p_scalar_292 = load double* %p_scevgep69
  %_p_scalar_293 = load double* %p_scevgep84
  %p_294 = fmul double %_p_scalar_292, %_p_scalar_293
  %_p_scalar_295 = load double* %p_scevgep70
  %p_296 = fadd double %p_294, %_p_scalar_295
  store double %p_296, double* %p_scevgep71
  %p_indvar.next67 = add i64 %polly.indvar282, 1
  %polly.indvar_next283 = add nsw i64 %polly.indvar282, 1
  %polly.adjust_ub284 = sub i64 %13, 1
  %polly.loop_cond285 = icmp sle i64 %polly.indvar282, %polly.adjust_ub284
  br i1 %polly.loop_cond285, label %polly.loop_header278, label %polly.loop_exit280

polly.then299:                                    ; preds = %polly.cond297
  %14 = add i64 %6, -1
  %polly.loop_guard304 = icmp sle i64 0, %14
  br i1 %polly.loop_guard304, label %polly.loop_header301, label %polly.merge

polly.loop_header301:                             ; preds = %polly.then299, %polly.loop_exit397
  %polly.indvar305 = phi i64 [ %polly.indvar_next306, %polly.loop_exit397 ], [ 0, %polly.then299 ]
  br i1 true, label %polly.loop_header310, label %polly.loop_exit312

polly.loop_exit312:                               ; preds = %polly.loop_exit329, %polly.loop_header301
  br i1 true, label %polly.loop_header395, label %polly.loop_exit397

polly.loop_exit397:                               ; preds = %polly.loop_exit414, %polly.loop_exit312
  %polly.indvar_next306 = add nsw i64 %polly.indvar305, 1
  %polly.adjust_ub307 = sub i64 %14, 1
  %polly.loop_cond308 = icmp sle i64 %polly.indvar305, %polly.adjust_ub307
  br i1 %polly.loop_cond308, label %polly.loop_header301, label %polly.merge

polly.loop_header310:                             ; preds = %polly.loop_header301, %polly.loop_exit329
  %polly.indvar314 = phi i64 [ %polly.indvar_next315, %polly.loop_exit329 ], [ 0, %polly.loop_header301 ]
  %p_.moved.to.319 = add nsw i32 %n, -1
  %p_321 = add i64 %polly.indvar314, 1
  %p_scevgep49322 = getelementptr [1000 x double]* %v, i64 0, i64 %p_321
  %p_scevgep51323 = getelementptr [1000 x double]* %p, i64 %p_321, i64 0
  %p_scevgep52324 = getelementptr [1000 x double]* %q, i64 %p_321, i64 0
  store double 1.000000e+00, double* %p_scevgep49322
  store double 0.000000e+00, double* %p_scevgep51323
  %_p_scalar_325 = load double* %p_scevgep49322
  store double %_p_scalar_325, double* %p_scevgep52324
  br i1 true, label %polly.loop_header327, label %polly.loop_exit329

polly.loop_exit329:                               ; preds = %polly.loop_header327, %polly.loop_header310
  %p_.moved.to.115388 = add i32 %n, -1
  %p_.moved.to.116389 = sext i32 %p_.moved.to.115388 to i64
  %p_scevgep53.moved.to.391 = getelementptr [1000 x double]* %v, i64 %p_.moved.to.116389, i64 %p_321
  %p_.moved.to.118392 = add nsw i32 %n, -2
  store double 1.000000e+00, double* %p_scevgep53.moved.to.391
  %polly.indvar_next315 = add nsw i64 %polly.indvar314, 1
  %polly.adjust_ub316 = sub i64 %1, 1
  %polly.loop_cond317 = icmp sle i64 %polly.indvar314, %polly.adjust_ub316
  br i1 %polly.loop_cond317, label %polly.loop_header310, label %polly.loop_exit312

polly.loop_header327:                             ; preds = %polly.loop_header310, %polly.loop_header327
  %polly.indvar331 = phi i64 [ %polly.indvar_next332, %polly.loop_header327 ], [ 0, %polly.loop_header310 ]
  %p_.moved.to.94337 = sitofp i32 %tsteps to double
  %p_.moved.to.95338 = fdiv double 1.000000e+00, %p_.moved.to.94337
  %p_.moved.to.96339 = fmul double %p_.moved.to.95338, 2.000000e+00
  %p_.moved.to.97340 = sitofp i32 %n to double
  %p_.moved.to.98341 = fdiv double 1.000000e+00, %p_.moved.to.97340
  %p_.moved.to.99342 = fmul double %p_.moved.to.98341, %p_.moved.to.98341
  %p_.moved.to.100343 = fdiv double %p_.moved.to.96339, %p_.moved.to.99342
  %p_.moved.to.101344 = fmul double %p_.moved.to.100343, -5.000000e-01
  %p_.moved.to.102345 = fsub double -0.000000e+00, %p_.moved.to.101344
  %p_.moved.to.103346 = fadd double %p_.moved.to.100343, 1.000000e+00
  %p_.moved.to.104347 = add i64 %polly.indvar314, 2
  %p_.moved.to.108351 = fdiv double %p_.moved.to.95338, %p_.moved.to.99342
  %p_.moved.to.109352 = fmul double %p_.moved.to.108351, -5.000000e-01
  %p_.moved.to.110353 = fmul double %p_.moved.to.109352, 2.000000e+00
  %p_.moved.to.111354 = fadd double %p_.moved.to.110353, 1.000000e+00
  %p_.moved.to.114357 = add i64 %1, 1
  %p_358 = add i64 %polly.indvar331, 1
  %p_scevgep28359 = getelementptr [1000 x double]* %u, i64 %p_358, i64 %p_.moved.to.104347
  %p_scevgep26360 = getelementptr [1000 x double]* %u, i64 %p_358, i64 %polly.indvar314
  %p_scevgep31361 = getelementptr [1000 x double]* %q, i64 %p_321, i64 %polly.indvar331
  %p_scevgep30362 = getelementptr [1000 x double]* %p, i64 %p_321, i64 %polly.indvar331
  %p_scevgep29363 = getelementptr [1000 x double]* %q, i64 %p_321, i64 %p_358
  %p_scevgep27364 = getelementptr [1000 x double]* %u, i64 %p_358, i64 %p_321
  %p_scevgep365 = getelementptr [1000 x double]* %p, i64 %p_321, i64 %p_358
  %_p_scalar_366 = load double* %p_scevgep30362
  %p_367 = fmul double %p_.moved.to.101344, %_p_scalar_366
  %p_368 = fadd double %p_.moved.to.103346, %p_367
  %p_369 = fdiv double %p_.moved.to.102345, %p_368
  store double %p_369, double* %p_scevgep365
  %_p_scalar_370 = load double* %p_scevgep26360
  %p_371 = fmul double %p_.moved.to.109352, %_p_scalar_370
  %_p_scalar_372 = load double* %p_scevgep27364
  %p_373 = fmul double %p_.moved.to.111354, %_p_scalar_372
  %p_374 = fsub double %p_373, %p_371
  %_p_scalar_375 = load double* %p_scevgep28359
  %p_376 = fmul double %p_.moved.to.109352, %_p_scalar_375
  %p_377 = fsub double %p_374, %p_376
  %_p_scalar_378 = load double* %p_scevgep31361
  %p_379 = fmul double %p_.moved.to.101344, %_p_scalar_378
  %p_380 = fsub double %p_377, %p_379
  %_p_scalar_381 = load double* %p_scevgep30362
  %p_382 = fmul double %p_.moved.to.101344, %_p_scalar_381
  %p_383 = fadd double %p_.moved.to.103346, %p_382
  %p_384 = fdiv double %p_380, %p_383
  store double %p_384, double* %p_scevgep29363
  %polly.indvar_next332 = add nsw i64 %polly.indvar331, 1
  %polly.adjust_ub333 = sub i64 %1, 1
  %polly.loop_cond334 = icmp sle i64 %polly.indvar331, %polly.adjust_ub333
  br i1 %polly.loop_cond334, label %polly.loop_header327, label %polly.loop_exit329

polly.loop_header395:                             ; preds = %polly.loop_exit312, %polly.loop_exit414
  %polly.indvar399 = phi i64 [ %polly.indvar_next400, %polly.loop_exit414 ], [ 0, %polly.loop_exit312 ]
  %p_.moved.to.131404 = add nsw i32 %n, -1
  %p_406 = add i64 %polly.indvar399, 1
  %p_scevgep83407 = getelementptr [1000 x double]* %u, i64 %p_406, i64 0
  %p_scevgep85408 = getelementptr [1000 x double]* %p, i64 %p_406, i64 0
  %p_scevgep86409 = getelementptr [1000 x double]* %q, i64 %p_406, i64 0
  store double 1.000000e+00, double* %p_scevgep83407
  store double 0.000000e+00, double* %p_scevgep85408
  %_p_scalar_410 = load double* %p_scevgep83407
  store double %_p_scalar_410, double* %p_scevgep86409
  br i1 true, label %polly.loop_header412, label %polly.loop_exit414

polly.loop_exit414:                               ; preds = %polly.loop_header412, %polly.loop_header395
  %p_.moved.to.156474 = add i32 %n, -1
  %p_.moved.to.157475 = sext i32 %p_.moved.to.156474 to i64
  %p_scevgep87.moved.to.476 = getelementptr [1000 x double]* %u, i64 %p_406, i64 %p_.moved.to.157475
  %p_.moved.to.158477 = add nsw i32 %n, -2
  store double 1.000000e+00, double* %p_scevgep87.moved.to.476
  %polly.indvar_next400 = add nsw i64 %polly.indvar399, 1
  %polly.adjust_ub401 = sub i64 %1, 1
  %polly.loop_cond402 = icmp sle i64 %polly.indvar399, %polly.adjust_ub401
  br i1 %polly.loop_cond402, label %polly.loop_header395, label %polly.loop_exit397

polly.loop_header412:                             ; preds = %polly.loop_header395, %polly.loop_header412
  %polly.indvar416 = phi i64 [ %polly.indvar_next417, %polly.loop_header412 ], [ 0, %polly.loop_header395 ]
  %p_.moved.to.134422 = sitofp i32 %tsteps to double
  %p_.moved.to.135423 = fdiv double 1.000000e+00, %p_.moved.to.134422
  %p_.moved.to.136424 = sitofp i32 %n to double
  %p_.moved.to.137425 = fdiv double 1.000000e+00, %p_.moved.to.136424
  %p_.moved.to.138426 = fmul double %p_.moved.to.137425, %p_.moved.to.137425
  %p_.moved.to.139427 = fdiv double %p_.moved.to.135423, %p_.moved.to.138426
  %p_.moved.to.140428 = fmul double %p_.moved.to.139427, -5.000000e-01
  %p_.moved.to.141429 = fsub double -0.000000e+00, %p_.moved.to.140428
  %p_.moved.to.142430 = fadd double %p_.moved.to.139427, 1.000000e+00
  %p_.moved.to.143431 = add i64 %polly.indvar399, 2
  %p_.moved.to.144432 = fmul double %p_.moved.to.135423, 2.000000e+00
  %p_.moved.to.148436 = fdiv double %p_.moved.to.144432, %p_.moved.to.138426
  %p_.moved.to.149437 = fmul double %p_.moved.to.148436, -5.000000e-01
  %p_.moved.to.150438 = fmul double %p_.moved.to.149437, 2.000000e+00
  %p_.moved.to.151439 = fadd double %p_.moved.to.150438, 1.000000e+00
  %p_.moved.to.154442 = add i64 %1, 1
  %p_443 = add i64 %polly.indvar416, 1
  %p_scevgep62444 = getelementptr [1000 x double]* %v, i64 %p_.moved.to.143431, i64 %p_443
  %p_scevgep60445 = getelementptr [1000 x double]* %v, i64 %polly.indvar399, i64 %p_443
  %p_scevgep65446 = getelementptr [1000 x double]* %q, i64 %p_406, i64 %polly.indvar416
  %p_scevgep64447 = getelementptr [1000 x double]* %p, i64 %p_406, i64 %polly.indvar416
  %p_scevgep63448 = getelementptr [1000 x double]* %q, i64 %p_406, i64 %p_443
  %p_scevgep61449 = getelementptr [1000 x double]* %v, i64 %p_406, i64 %p_443
  %p_scevgep59450 = getelementptr [1000 x double]* %p, i64 %p_406, i64 %p_443
  %_p_scalar_451 = load double* %p_scevgep64447
  %p_452 = fmul double %p_.moved.to.140428, %_p_scalar_451
  %p_453 = fadd double %p_.moved.to.142430, %p_452
  %p_454 = fdiv double %p_.moved.to.141429, %p_453
  store double %p_454, double* %p_scevgep59450
  %_p_scalar_455 = load double* %p_scevgep60445
  %p_456 = fmul double %p_.moved.to.149437, %_p_scalar_455
  %_p_scalar_457 = load double* %p_scevgep61449
  %p_458 = fmul double %p_.moved.to.151439, %_p_scalar_457
  %p_459 = fsub double %p_458, %p_456
  %_p_scalar_460 = load double* %p_scevgep62444
  %p_461 = fmul double %p_.moved.to.149437, %_p_scalar_460
  %p_462 = fsub double %p_459, %p_461
  %_p_scalar_463 = load double* %p_scevgep65446
  %p_464 = fmul double %p_.moved.to.140428, %_p_scalar_463
  %p_465 = fsub double %p_462, %p_464
  %_p_scalar_466 = load double* %p_scevgep64447
  %p_467 = fmul double %p_.moved.to.140428, %_p_scalar_466
  %p_468 = fadd double %p_.moved.to.142430, %p_467
  %p_469 = fdiv double %p_465, %p_468
  store double %p_469, double* %p_scevgep63448
  %polly.indvar_next417 = add nsw i64 %polly.indvar416, 1
  %polly.adjust_ub418 = sub i64 %1, 1
  %polly.loop_cond419 = icmp sle i64 %polly.indvar416, %polly.adjust_ub418
  br i1 %polly.loop_cond419, label %polly.loop_header412, label %polly.loop_exit414
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, [1000 x double]* noalias %u) #0 {
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
