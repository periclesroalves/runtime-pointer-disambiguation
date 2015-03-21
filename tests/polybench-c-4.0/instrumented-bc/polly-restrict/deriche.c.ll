; ModuleID = './medley/deriche/deriche.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [7 x i8] c"imgOut\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [7 x i8] c"%0.2f \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %alpha = alloca float, align 4
  %0 = tail call i8* @polybench_alloc_data(i64 8847360, i32 4) #3
  %1 = tail call i8* @polybench_alloc_data(i64 8847360, i32 4) #3
  %2 = tail call i8* @polybench_alloc_data(i64 8847360, i32 4) #3
  %3 = tail call i8* @polybench_alloc_data(i64 8847360, i32 4) #3
  %4 = bitcast i8* %0 to [2160 x float]*
  %5 = bitcast i8* %1 to [2160 x float]*
  call void @init_array(i32 4096, i32 2160, float* %alpha, [2160 x float]* %4, [2160 x float]* %5)
  call void (...)* @polybench_timer_start() #3
  %6 = load float* %alpha, align 4, !tbaa !1
  %7 = bitcast i8* %2 to [2160 x float]*
  %8 = bitcast i8* %3 to [2160 x float]*
  call void @kernel_deriche(i32 4096, i32 2160, float %6, [2160 x float]* %4, [2160 x float]* %5, [2160 x float]* %7, [2160 x float]* %8)
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
  call void @print_array(i32 4096, i32 2160, [2160 x float]* %5)
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
define internal void @init_array(i32 %w, i32 %h, float* %alpha, [2160 x float]* noalias %imgIn, [2160 x float]* noalias %imgOut) #0 {
polly.split_new_and_old:
  %0 = zext i32 %w to i64
  %1 = zext i32 %h to i64
  %2 = sext i32 %h to i64
  %3 = icmp sge i64 %2, 1
  %4 = icmp sge i64 %0, 1
  %5 = and i1 %3, %4
  %6 = icmp sge i64 %1, 1
  %7 = and i1 %5, %6
  %8 = sext i32 %w to i64
  %9 = icmp sge i64 %8, 1
  %10 = and i1 %7, %9
  br i1 %10, label %polly.then, label %polly.stmt..split

polly.stmt..split:                                ; preds = %polly.then, %polly.loop_exit14, %polly.split_new_and_old
  store float 2.500000e-01, float* %alpha
  ret void

polly.then:                                       ; preds = %polly.split_new_and_old
  %11 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %11
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.stmt..split

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit14
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit14 ], [ 0, %polly.then ]
  %12 = mul i64 -3, %0
  %13 = add i64 %12, %1
  %14 = add i64 %13, 5
  %15 = sub i64 %14, 32
  %16 = add i64 %15, 1
  %17 = icmp slt i64 %14, 0
  %18 = select i1 %17, i64 %16, i64 %14
  %19 = sdiv i64 %18, 32
  %20 = mul i64 -32, %19
  %21 = mul i64 -32, %0
  %22 = add i64 %20, %21
  %23 = mul i64 -32, %polly.indvar
  %24 = mul i64 -3, %polly.indvar
  %25 = add i64 %24, %1
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
  %37 = mul i64 -20, %polly.indvar
  %polly.loop_guard15 = icmp sle i64 %36, %37
  br i1 %polly.loop_guard15, label %polly.loop_header12, label %polly.loop_exit14

polly.loop_exit14:                                ; preds = %polly.loop_exit23, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %11, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.stmt..split

polly.loop_header12:                              ; preds = %polly.loop_header, %polly.loop_exit23
  %polly.indvar16 = phi i64 [ %polly.indvar_next17, %polly.loop_exit23 ], [ %36, %polly.loop_header ]
  %38 = mul i64 -1, %polly.indvar16
  %39 = mul i64 -1, %1
  %40 = add i64 %38, %39
  %41 = add i64 %40, -30
  %42 = add i64 %41, 20
  %43 = sub i64 %42, 1
  %44 = icmp slt i64 %41, 0
  %45 = select i1 %44, i64 %41, i64 %43
  %46 = sdiv i64 %45, 20
  %47 = icmp sgt i64 %46, %polly.indvar
  %48 = select i1 %47, i64 %46, i64 %polly.indvar
  %49 = sub i64 %38, 20
  %50 = add i64 %49, 1
  %51 = icmp slt i64 %38, 0
  %52 = select i1 %51, i64 %50, i64 %38
  %53 = sdiv i64 %52, 20
  %54 = add i64 %polly.indvar, 31
  %55 = icmp slt i64 %53, %54
  %56 = select i1 %55, i64 %53, i64 %54
  %57 = icmp slt i64 %56, %11
  %58 = select i1 %57, i64 %56, i64 %11
  %polly.loop_guard24 = icmp sle i64 %48, %58
  br i1 %polly.loop_guard24, label %polly.loop_header21, label %polly.loop_exit23

polly.loop_exit23:                                ; preds = %polly.loop_exit32, %polly.loop_header12
  %polly.indvar_next17 = add nsw i64 %polly.indvar16, 32
  %polly.adjust_ub18 = sub i64 %37, 32
  %polly.loop_cond19 = icmp sle i64 %polly.indvar16, %polly.adjust_ub18
  br i1 %polly.loop_cond19, label %polly.loop_header12, label %polly.loop_exit14

polly.loop_header21:                              ; preds = %polly.loop_header12, %polly.loop_exit32
  %polly.indvar25 = phi i64 [ %polly.indvar_next26, %polly.loop_exit32 ], [ %48, %polly.loop_header12 ]
  %59 = mul i64 -20, %polly.indvar25
  %60 = add i64 %59, %39
  %61 = add i64 %60, 1
  %62 = icmp sgt i64 %polly.indvar16, %61
  %63 = select i1 %62, i64 %polly.indvar16, i64 %61
  %64 = add i64 %polly.indvar16, 31
  %65 = icmp slt i64 %59, %64
  %66 = select i1 %65, i64 %59, i64 %64
  %polly.loop_guard33 = icmp sle i64 %63, %66
  br i1 %polly.loop_guard33, label %polly.loop_header30, label %polly.loop_exit32

polly.loop_exit32:                                ; preds = %polly.loop_header30, %polly.loop_header21
  %polly.indvar_next26 = add nsw i64 %polly.indvar25, 1
  %polly.adjust_ub27 = sub i64 %58, 1
  %polly.loop_cond28 = icmp sle i64 %polly.indvar25, %polly.adjust_ub27
  br i1 %polly.loop_cond28, label %polly.loop_header21, label %polly.loop_exit23

polly.loop_header30:                              ; preds = %polly.loop_header21, %polly.loop_header30
  %polly.indvar34 = phi i64 [ %polly.indvar_next35, %polly.loop_header30 ], [ %63, %polly.loop_header21 ]
  %67 = mul i64 -1, %polly.indvar34
  %68 = add i64 %59, %67
  %p_.moved.to. = mul i64 %polly.indvar25, 313
  %p_ = mul i64 %68, 991
  %p_38 = add i64 %p_.moved.to., %p_
  %p_39 = trunc i64 %p_38 to i32
  %p_scevgep = getelementptr [2160 x float]* %imgIn, i64 %polly.indvar25, i64 %68
  %p_40 = srem i32 %p_39, 65536
  %p_41 = sitofp i32 %p_40 to float
  %p_42 = fdiv float %p_41, 6.553500e+04
  store float %p_42, float* %p_scevgep
  %p_indvar.next = add i64 %68, 1
  %polly.indvar_next35 = add nsw i64 %polly.indvar34, 1
  %polly.adjust_ub36 = sub i64 %66, 1
  %polly.loop_cond37 = icmp sle i64 %polly.indvar34, %polly.adjust_ub36
  br i1 %polly.loop_cond37, label %polly.loop_header30, label %polly.loop_exit32
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_deriche(i32 %w, i32 %h, float %alpha, [2160 x float]* noalias %imgIn, [2160 x float]* noalias %imgOut, [2160 x float]* noalias %y1, [2160 x float]* noalias %y2) #0 {
.split:
  %0 = fsub float -0.000000e+00, %alpha
  %1 = tail call float @expf(float %0) #3
  %2 = fsub float 1.000000e+00, %1
  %3 = tail call float @expf(float %0) #3
  %4 = fsub float 1.000000e+00, %3
  %5 = fmul float %2, %4
  %6 = fmul float %alpha, 2.000000e+00
  %7 = tail call float @expf(float %0) #3
  %8 = fmul float %6, %7
  %9 = fadd float %8, 1.000000e+00
  %10 = tail call float @expf(float %6) #3
  %11 = fsub float %9, %10
  %12 = fdiv float %5, %11
  %13 = tail call float @expf(float %0) #3
  %14 = fmul float %12, %13
  %15 = fadd float %alpha, -1.000000e+00
  %16 = fmul float %15, %14
  %17 = tail call float @expf(float %0) #3
  %18 = fmul float %12, %17
  %19 = fadd float %alpha, 1.000000e+00
  %20 = fmul float %19, %18
  %21 = fmul float %alpha, -2.000000e+00
  %22 = tail call float @expf(float %21) #3
  %23 = fmul float %12, %22
  %24 = fsub float -0.000000e+00, %23
  %exp2f = tail call float @exp2f(float %0) #2
  %25 = tail call float @expf(float %21) #3
  %26 = fsub float -0.000000e+00, %25
  %27 = icmp sgt i32 %w, 0
  br i1 %27, label %.preheader10.lr.ph, label %polly.start

.preheader10.lr.ph:                               ; preds = %.split
  %28 = zext i32 %h to i64
  %29 = zext i32 %w to i64
  %30 = sext i32 %h to i64
  %31 = icmp sge i64 %30, 1
  %32 = icmp sge i64 %29, 1
  %33 = and i1 %31, %32
  br i1 %33, label %polly.cond313, label %polly.start

polly.start:                                      ; preds = %polly.then347, %polly.loop_header349, %polly.cond345, %.preheader10.lr.ph, %.split
  %34 = zext i32 %w to i64
  %35 = zext i32 %h to i64
  %36 = sext i32 %h to i64
  %37 = icmp sge i64 %36, 1
  %38 = sext i32 %w to i64
  %39 = icmp sge i64 %38, 1
  %40 = and i1 %37, %39
  br i1 %40, label %polly.cond123, label %polly.merge

polly.merge:                                      ; preds = %polly.then284, %polly.loop_exit297, %polly.cond282, %polly.start
  ret void

polly.cond123:                                    ; preds = %polly.start
  %41 = icmp sge i64 %34, 1
  br i1 %41, label %polly.cond126, label %polly.cond160

polly.cond160:                                    ; preds = %polly.then149, %polly.loop_header151, %polly.cond147, %polly.cond123
  %42 = icmp sge i64 %35, 1
  %43 = and i1 %41, %42
  br i1 %43, label %polly.then162, label %polly.cond185

polly.cond185:                                    ; preds = %polly.then162, %polly.loop_exit175, %polly.cond160
  br i1 %42, label %polly.cond188, label %polly.cond233

polly.cond233:                                    ; preds = %polly.then222, %polly.loop_header224, %polly.cond220, %polly.cond185
  br i1 %42, label %polly.cond236, label %polly.cond282

polly.cond282:                                    ; preds = %polly.then271, %polly.loop_header273, %polly.cond269, %polly.cond233
  br i1 %43, label %polly.then284, label %polly.merge

polly.cond126:                                    ; preds = %polly.cond123
  %44 = icmp sge i64 %35, 1
  br i1 %44, label %polly.then128, label %polly.cond147

polly.cond147:                                    ; preds = %polly.then128, %polly.loop_exit132, %polly.cond126
  %45 = icmp sle i64 %35, 0
  br i1 %45, label %polly.then149, label %polly.cond160

polly.then128:                                    ; preds = %polly.cond126
  %46 = add i64 %34, -1
  %polly.loop_guard = icmp sle i64 0, %46
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond147

polly.loop_header:                                ; preds = %polly.then128, %polly.loop_exit132
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit132 ], [ 0, %polly.then128 ]
  %47 = add i64 %35, -1
  %polly.loop_guard133 = icmp sle i64 0, %47
  br i1 %polly.loop_guard133, label %polly.loop_header130, label %polly.loop_exit132

polly.loop_exit132:                               ; preds = %polly.loop_header130, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %46, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond147

polly.loop_header130:                             ; preds = %polly.loop_header, %polly.loop_header130
  %yp2.038.reg2mem.0 = phi float [ 0.000000e+00, %polly.loop_header ], [ %yp1.037.reg2mem.0, %polly.loop_header130 ]
  %yp1.037.reg2mem.0 = phi float [ 0.000000e+00, %polly.loop_header ], [ %p_145, %polly.loop_header130 ]
  %xp2.036.reg2mem.0 = phi float [ 0.000000e+00, %polly.loop_header ], [ %xp1.035.reg2mem.0, %polly.loop_header130 ]
  %xp1.035.reg2mem.0 = phi float [ 0.000000e+00, %polly.loop_header ], [ %_p_scalar_146, %polly.loop_header130 ]
  %polly.indvar134 = phi i64 [ %polly.indvar_next135, %polly.loop_header130 ], [ 0, %polly.loop_header ]
  %p_.moved.to.110 = add i64 %36, -1
  %p_ = mul i64 %polly.indvar134, -1
  %p_138 = add i64 %p_.moved.to.110, %p_
  %p_scevgep96 = getelementptr [2160 x float]* %imgIn, i64 %polly.indvar, i64 %p_138
  %p_scevgep95 = getelementptr [2160 x float]* %y2, i64 %polly.indvar, i64 %p_138
  %p_139 = fmul float %20, %xp1.035.reg2mem.0
  %p_140 = fmul float %xp2.036.reg2mem.0, %24
  %p_141 = fadd float %p_139, %p_140
  %p_142 = fmul float %exp2f, %yp1.037.reg2mem.0
  %p_143 = fadd float %p_141, %p_142
  %p_144 = fmul float %yp2.038.reg2mem.0, %26
  %p_145 = fadd float %p_143, %p_144
  store float %p_145, float* %p_scevgep95
  %_p_scalar_146 = load float* %p_scevgep96
  %p_indvar.next91 = add i64 %polly.indvar134, 1
  %polly.indvar_next135 = add nsw i64 %polly.indvar134, 1
  %polly.adjust_ub136 = sub i64 %47, 1
  %polly.loop_cond137 = icmp sle i64 %polly.indvar134, %polly.adjust_ub136
  br i1 %polly.loop_cond137, label %polly.loop_header130, label %polly.loop_exit132

polly.then149:                                    ; preds = %polly.cond147
  %48 = add i64 %34, -1
  %polly.loop_guard154 = icmp sle i64 0, %48
  br i1 %polly.loop_guard154, label %polly.loop_header151, label %polly.cond160

polly.loop_header151:                             ; preds = %polly.then149, %polly.loop_header151
  %polly.indvar155 = phi i64 [ %polly.indvar_next156, %polly.loop_header151 ], [ 0, %polly.then149 ]
  %polly.indvar_next156 = add nsw i64 %polly.indvar155, 1
  %polly.adjust_ub157 = sub i64 %48, 1
  %polly.loop_cond158 = icmp sle i64 %polly.indvar155, %polly.adjust_ub157
  br i1 %polly.loop_cond158, label %polly.loop_header151, label %polly.cond160

polly.then162:                                    ; preds = %polly.cond160
  %49 = add i64 %34, -1
  %polly.loop_guard167 = icmp sle i64 0, %49
  br i1 %polly.loop_guard167, label %polly.loop_header164, label %polly.cond185

polly.loop_header164:                             ; preds = %polly.then162, %polly.loop_exit175
  %polly.indvar168 = phi i64 [ %polly.indvar_next169, %polly.loop_exit175 ], [ 0, %polly.then162 ]
  %50 = add i64 %35, -1
  %polly.loop_guard176 = icmp sle i64 0, %50
  br i1 %polly.loop_guard176, label %polly.loop_header173, label %polly.loop_exit175

polly.loop_exit175:                               ; preds = %polly.loop_header173, %polly.loop_header164
  %polly.indvar_next169 = add nsw i64 %polly.indvar168, 1
  %polly.adjust_ub170 = sub i64 %49, 1
  %polly.loop_cond171 = icmp sle i64 %polly.indvar168, %polly.adjust_ub170
  br i1 %polly.loop_cond171, label %polly.loop_header164, label %polly.cond185

polly.loop_header173:                             ; preds = %polly.loop_header164, %polly.loop_header173
  %polly.indvar177 = phi i64 [ %polly.indvar_next178, %polly.loop_header173 ], [ 0, %polly.loop_header164 ]
  %p_scevgep85 = getelementptr [2160 x float]* %imgOut, i64 %polly.indvar168, i64 %polly.indvar177
  %p_scevgep84 = getelementptr [2160 x float]* %y2, i64 %polly.indvar168, i64 %polly.indvar177
  %p_scevgep83 = getelementptr [2160 x float]* %y1, i64 %polly.indvar168, i64 %polly.indvar177
  %_p_scalar_182 = load float* %p_scevgep83
  %_p_scalar_183 = load float* %p_scevgep84
  %p_184 = fadd float %_p_scalar_182, %_p_scalar_183
  store float %p_184, float* %p_scevgep85
  %p_indvar.next79 = add i64 %polly.indvar177, 1
  %polly.indvar_next178 = add nsw i64 %polly.indvar177, 1
  %polly.adjust_ub179 = sub i64 %50, 1
  %polly.loop_cond180 = icmp sle i64 %polly.indvar177, %polly.adjust_ub179
  br i1 %polly.loop_cond180, label %polly.loop_header173, label %polly.loop_exit175

polly.cond188:                                    ; preds = %polly.cond185
  br i1 %41, label %polly.then190, label %polly.cond220

polly.cond220:                                    ; preds = %polly.then190, %polly.loop_exit203, %polly.cond188
  %51 = icmp sle i64 %34, 0
  br i1 %51, label %polly.then222, label %polly.cond233

polly.then190:                                    ; preds = %polly.cond188
  %52 = add i64 %35, -1
  %polly.loop_guard195 = icmp sle i64 0, %52
  br i1 %polly.loop_guard195, label %polly.loop_header192, label %polly.cond220

polly.loop_header192:                             ; preds = %polly.then190, %polly.loop_exit203
  %polly.indvar196 = phi i64 [ %polly.indvar_next197, %polly.loop_exit203 ], [ 0, %polly.then190 ]
  %53 = add i64 %34, -1
  %polly.loop_guard204 = icmp sle i64 0, %53
  br i1 %polly.loop_guard204, label %polly.loop_header201, label %polly.loop_exit203

polly.loop_exit203:                               ; preds = %polly.loop_header201, %polly.loop_header192
  %polly.indvar_next197 = add nsw i64 %polly.indvar196, 1
  %polly.adjust_ub198 = sub i64 %52, 1
  %polly.loop_cond199 = icmp sle i64 %polly.indvar196, %polly.adjust_ub198
  br i1 %polly.loop_cond199, label %polly.loop_header192, label %polly.cond220

polly.loop_header201:                             ; preds = %polly.loop_header192, %polly.loop_header201
  %ym2.126.reg2mem.0 = phi float [ 0.000000e+00, %polly.loop_header192 ], [ %ym1.123.reg2mem.0, %polly.loop_header201 ]
  %tm1.024.reg2mem.0 = phi float [ 0.000000e+00, %polly.loop_header192 ], [ %_p_scalar_219, %polly.loop_header201 ]
  %ym1.123.reg2mem.0 = phi float [ 0.000000e+00, %polly.loop_header192 ], [ %p_217, %polly.loop_header201 ]
  %polly.indvar205 = phi i64 [ %polly.indvar_next206, %polly.loop_header201 ], [ 0, %polly.loop_header192 ]
  %p_scevgep74 = getelementptr [2160 x float]* %y1, i64 %polly.indvar205, i64 %polly.indvar196
  %p_scevgep73 = getelementptr [2160 x float]* %imgOut, i64 %polly.indvar205, i64 %polly.indvar196
  %_p_scalar_210 = load float* %p_scevgep73
  %p_211 = fmul float %12, %_p_scalar_210
  %p_212 = fmul float %16, %tm1.024.reg2mem.0
  %p_213 = fadd float %p_212, %p_211
  %p_214 = fmul float %exp2f, %ym1.123.reg2mem.0
  %p_215 = fadd float %p_214, %p_213
  %p_216 = fmul float %ym2.126.reg2mem.0, %26
  %p_217 = fadd float %p_216, %p_215
  store float %p_217, float* %p_scevgep74
  %_p_scalar_219 = load float* %p_scevgep73
  %p_indvar.next69 = add i64 %polly.indvar205, 1
  %polly.indvar_next206 = add nsw i64 %polly.indvar205, 1
  %polly.adjust_ub207 = sub i64 %53, 1
  %polly.loop_cond208 = icmp sle i64 %polly.indvar205, %polly.adjust_ub207
  br i1 %polly.loop_cond208, label %polly.loop_header201, label %polly.loop_exit203

polly.then222:                                    ; preds = %polly.cond220
  %54 = add i64 %35, -1
  %polly.loop_guard227 = icmp sle i64 0, %54
  br i1 %polly.loop_guard227, label %polly.loop_header224, label %polly.cond233

polly.loop_header224:                             ; preds = %polly.then222, %polly.loop_header224
  %polly.indvar228 = phi i64 [ %polly.indvar_next229, %polly.loop_header224 ], [ 0, %polly.then222 ]
  %polly.indvar_next229 = add nsw i64 %polly.indvar228, 1
  %polly.adjust_ub230 = sub i64 %54, 1
  %polly.loop_cond231 = icmp sle i64 %polly.indvar228, %polly.adjust_ub230
  br i1 %polly.loop_cond231, label %polly.loop_header224, label %polly.cond233

polly.cond236:                                    ; preds = %polly.cond233
  br i1 %41, label %polly.then238, label %polly.cond269

polly.cond269:                                    ; preds = %polly.then238, %polly.loop_exit251, %polly.cond236
  %55 = icmp sle i64 %34, 0
  br i1 %55, label %polly.then271, label %polly.cond282

polly.then238:                                    ; preds = %polly.cond236
  %56 = add i64 %35, -1
  %polly.loop_guard243 = icmp sle i64 0, %56
  br i1 %polly.loop_guard243, label %polly.loop_header240, label %polly.cond269

polly.loop_header240:                             ; preds = %polly.then238, %polly.loop_exit251
  %polly.indvar244 = phi i64 [ %polly.indvar_next245, %polly.loop_exit251 ], [ 0, %polly.then238 ]
  %57 = add i64 %34, -1
  %polly.loop_guard252 = icmp sle i64 0, %57
  br i1 %polly.loop_guard252, label %polly.loop_header249, label %polly.loop_exit251

polly.loop_exit251:                               ; preds = %polly.loop_header249, %polly.loop_header240
  %polly.indvar_next245 = add nsw i64 %polly.indvar244, 1
  %polly.adjust_ub246 = sub i64 %56, 1
  %polly.loop_cond247 = icmp sle i64 %polly.indvar244, %polly.adjust_ub246
  br i1 %polly.loop_cond247, label %polly.loop_header240, label %polly.cond269

polly.loop_header249:                             ; preds = %polly.loop_header240, %polly.loop_header249
  %yp2.118.reg2mem.0 = phi float [ 0.000000e+00, %polly.loop_header240 ], [ %yp1.117.reg2mem.0, %polly.loop_header249 ]
  %yp1.117.reg2mem.0 = phi float [ 0.000000e+00, %polly.loop_header240 ], [ %p_266, %polly.loop_header249 ]
  %tp2.016.reg2mem.0 = phi float [ 0.000000e+00, %polly.loop_header240 ], [ %tp1.015.reg2mem.0, %polly.loop_header249 ]
  %tp1.015.reg2mem.0 = phi float [ 0.000000e+00, %polly.loop_header240 ], [ %_p_scalar_268, %polly.loop_header249 ]
  %polly.indvar253 = phi i64 [ %polly.indvar_next254, %polly.loop_header249 ], [ 0, %polly.loop_header240 ]
  %p_.moved.to.118 = add i64 %38, -1
  %p_258 = mul i64 %polly.indvar253, -1
  %p_259 = add i64 %p_.moved.to.118, %p_258
  %p_scevgep64 = getelementptr [2160 x float]* %imgOut, i64 %p_259, i64 %polly.indvar244
  %p_scevgep63 = getelementptr [2160 x float]* %y2, i64 %p_259, i64 %polly.indvar244
  %p_260 = fmul float %20, %tp1.015.reg2mem.0
  %p_261 = fmul float %tp2.016.reg2mem.0, %24
  %p_262 = fadd float %p_260, %p_261
  %p_263 = fmul float %exp2f, %yp1.117.reg2mem.0
  %p_264 = fadd float %p_262, %p_263
  %p_265 = fmul float %yp2.118.reg2mem.0, %26
  %p_266 = fadd float %p_264, %p_265
  store float %p_266, float* %p_scevgep63
  %_p_scalar_268 = load float* %p_scevgep64
  %p_indvar.next59 = add i64 %polly.indvar253, 1
  %polly.indvar_next254 = add nsw i64 %polly.indvar253, 1
  %polly.adjust_ub255 = sub i64 %57, 1
  %polly.loop_cond256 = icmp sle i64 %polly.indvar253, %polly.adjust_ub255
  br i1 %polly.loop_cond256, label %polly.loop_header249, label %polly.loop_exit251

polly.then271:                                    ; preds = %polly.cond269
  %58 = add i64 %35, -1
  %polly.loop_guard276 = icmp sle i64 0, %58
  br i1 %polly.loop_guard276, label %polly.loop_header273, label %polly.cond282

polly.loop_header273:                             ; preds = %polly.then271, %polly.loop_header273
  %polly.indvar277 = phi i64 [ %polly.indvar_next278, %polly.loop_header273 ], [ 0, %polly.then271 ]
  %polly.indvar_next278 = add nsw i64 %polly.indvar277, 1
  %polly.adjust_ub279 = sub i64 %58, 1
  %polly.loop_cond280 = icmp sle i64 %polly.indvar277, %polly.adjust_ub279
  br i1 %polly.loop_cond280, label %polly.loop_header273, label %polly.cond282

polly.then284:                                    ; preds = %polly.cond282
  %59 = add i64 %34, -1
  %polly.loop_guard289 = icmp sle i64 0, %59
  br i1 %polly.loop_guard289, label %polly.loop_header286, label %polly.merge

polly.loop_header286:                             ; preds = %polly.then284, %polly.loop_exit297
  %polly.indvar290 = phi i64 [ %polly.indvar_next291, %polly.loop_exit297 ], [ 0, %polly.then284 ]
  %60 = add i64 %35, -1
  %polly.loop_guard298 = icmp sle i64 0, %60
  br i1 %polly.loop_guard298, label %polly.loop_header295, label %polly.loop_exit297

polly.loop_exit297:                               ; preds = %polly.loop_header295, %polly.loop_header286
  %polly.indvar_next291 = add nsw i64 %polly.indvar290, 1
  %polly.adjust_ub292 = sub i64 %59, 1
  %polly.loop_cond293 = icmp sle i64 %polly.indvar290, %polly.adjust_ub292
  br i1 %polly.loop_cond293, label %polly.loop_header286, label %polly.merge

polly.loop_header295:                             ; preds = %polly.loop_header286, %polly.loop_header295
  %polly.indvar299 = phi i64 [ %polly.indvar_next300, %polly.loop_header295 ], [ 0, %polly.loop_header286 ]
  %p_scevgep53 = getelementptr [2160 x float]* %imgOut, i64 %polly.indvar290, i64 %polly.indvar299
  %p_scevgep52 = getelementptr [2160 x float]* %y2, i64 %polly.indvar290, i64 %polly.indvar299
  %p_scevgep = getelementptr [2160 x float]* %y1, i64 %polly.indvar290, i64 %polly.indvar299
  %_p_scalar_304 = load float* %p_scevgep
  %_p_scalar_305 = load float* %p_scevgep52
  %p_306 = fadd float %_p_scalar_304, %_p_scalar_305
  store float %p_306, float* %p_scevgep53
  %p_indvar.next = add i64 %polly.indvar299, 1
  %polly.indvar_next300 = add nsw i64 %polly.indvar299, 1
  %polly.adjust_ub301 = sub i64 %60, 1
  %polly.loop_cond302 = icmp sle i64 %polly.indvar299, %polly.adjust_ub301
  br i1 %polly.loop_cond302, label %polly.loop_header295, label %polly.loop_exit297

polly.cond313:                                    ; preds = %.preheader10.lr.ph
  %61 = icmp sge i64 %28, 1
  br i1 %61, label %polly.then315, label %polly.cond345

polly.cond345:                                    ; preds = %polly.then315, %polly.loop_exit328, %polly.cond313
  %62 = icmp sle i64 %28, 0
  br i1 %62, label %polly.then347, label %polly.start

polly.then315:                                    ; preds = %polly.cond313
  %63 = add i64 %29, -1
  %polly.loop_guard320 = icmp sle i64 0, %63
  br i1 %polly.loop_guard320, label %polly.loop_header317, label %polly.cond345

polly.loop_header317:                             ; preds = %polly.then315, %polly.loop_exit328
  %polly.indvar321 = phi i64 [ %polly.indvar_next322, %polly.loop_exit328 ], [ 0, %polly.then315 ]
  %64 = add i64 %28, -1
  %polly.loop_guard329 = icmp sle i64 0, %64
  br i1 %polly.loop_guard329, label %polly.loop_header326, label %polly.loop_exit328

polly.loop_exit328:                               ; preds = %polly.loop_header326, %polly.loop_header317
  %polly.indvar_next322 = add nsw i64 %polly.indvar321, 1
  %polly.adjust_ub323 = sub i64 %63, 1
  %polly.loop_cond324 = icmp sle i64 %polly.indvar321, %polly.adjust_ub323
  br i1 %polly.loop_cond324, label %polly.loop_header317, label %polly.cond345

polly.loop_header326:                             ; preds = %polly.loop_header317, %polly.loop_header326
  %ym2.046.reg2mem.0 = phi float [ 0.000000e+00, %polly.loop_header317 ], [ %ym1.043.reg2mem.0, %polly.loop_header326 ]
  %xm1.044.reg2mem.0 = phi float [ 0.000000e+00, %polly.loop_header317 ], [ %_p_scalar_344, %polly.loop_header326 ]
  %ym1.043.reg2mem.0 = phi float [ 0.000000e+00, %polly.loop_header317 ], [ %p_342, %polly.loop_header326 ]
  %polly.indvar330 = phi i64 [ %polly.indvar_next331, %polly.loop_header326 ], [ 0, %polly.loop_header317 ]
  %p_scevgep106 = getelementptr [2160 x float]* %y1, i64 %polly.indvar321, i64 %polly.indvar330
  %p_scevgep105 = getelementptr [2160 x float]* %imgIn, i64 %polly.indvar321, i64 %polly.indvar330
  %_p_scalar_335 = load float* %p_scevgep105
  %p_336 = fmul float %12, %_p_scalar_335
  %p_337 = fmul float %16, %xm1.044.reg2mem.0
  %p_338 = fadd float %p_337, %p_336
  %p_339 = fmul float %exp2f, %ym1.043.reg2mem.0
  %p_340 = fadd float %p_339, %p_338
  %p_341 = fmul float %ym2.046.reg2mem.0, %26
  %p_342 = fadd float %p_341, %p_340
  store float %p_342, float* %p_scevgep106
  %_p_scalar_344 = load float* %p_scevgep105
  %p_indvar.next101 = add i64 %polly.indvar330, 1
  %polly.indvar_next331 = add nsw i64 %polly.indvar330, 1
  %polly.adjust_ub332 = sub i64 %64, 1
  %polly.loop_cond333 = icmp sle i64 %polly.indvar330, %polly.adjust_ub332
  br i1 %polly.loop_cond333, label %polly.loop_header326, label %polly.loop_exit328

polly.then347:                                    ; preds = %polly.cond345
  %65 = add i64 %29, -1
  %polly.loop_guard352 = icmp sle i64 0, %65
  br i1 %polly.loop_guard352, label %polly.loop_header349, label %polly.start

polly.loop_header349:                             ; preds = %polly.then347, %polly.loop_header349
  %polly.indvar353 = phi i64 [ %polly.indvar_next354, %polly.loop_header349 ], [ 0, %polly.then347 ]
  %polly.indvar_next354 = add nsw i64 %polly.indvar353, 1
  %polly.adjust_ub355 = sub i64 %65, 1
  %polly.loop_cond356 = icmp sle i64 %polly.indvar353, %polly.adjust_ub355
  br i1 %polly.loop_cond356, label %polly.loop_header349, label %polly.start
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %w, i32 %h, [2160 x float]* noalias %imgOut) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([7 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %w, 0
  br i1 %5, label %.preheader.lr.ph, label %24

.preheader.lr.ph:                                 ; preds = %.split
  %6 = zext i32 %h to i64
  %7 = zext i32 %w to i64
  %8 = zext i32 %h to i64
  %9 = icmp sgt i32 %h, 0
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %23
  %indvar4 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next5, %23 ]
  %10 = mul i64 %8, %indvar4
  br i1 %9, label %.lr.ph, label %23

.lr.ph:                                           ; preds = %.preheader
  br label %11

; <label>:11                                      ; preds = %.lr.ph, %18
  %indvar = phi i64 [ 0, %.lr.ph ], [ %indvar.next, %18 ]
  %12 = add i64 %10, %indvar
  %13 = trunc i64 %12 to i32
  %scevgep = getelementptr [2160 x float]* %imgOut, i64 %indvar4, i64 %indvar
  %14 = srem i32 %13, 20
  %15 = icmp eq i32 %14, 0
  br i1 %15, label %16, label %18

; <label>:16                                      ; preds = %11
  %17 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %17) #4
  br label %18

; <label>:18                                      ; preds = %16, %11
  %19 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %20 = load float* %scevgep, align 4, !tbaa !1
  %21 = fpext float %20 to double
  %22 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %19, i8* getelementptr inbounds ([7 x i8]* @.str5, i64 0, i64 0), double %21) #5
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %6
  br i1 %exitcond, label %11, label %._crit_edge

._crit_edge:                                      ; preds = %18
  br label %23

; <label>:23                                      ; preds = %._crit_edge, %.preheader
  %indvar.next5 = add i64 %indvar4, 1
  %exitcond6 = icmp ne i64 %indvar.next5, %7
  br i1 %exitcond6, label %.preheader, label %._crit_edge3

._crit_edge3:                                     ; preds = %23
  br label %24

; <label>:24                                      ; preds = %._crit_edge3, %.split
  %25 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %26 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %25, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([7 x i8]* @.str3, i64 0, i64 0)) #5
  %27 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %28 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str7, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %27) #4
  ret void
}

; Function Attrs: nounwind
declare void @free(i8*) #2

declare i32 @fprintf(%struct._IO_FILE*, i8*, ...) #1

; Function Attrs: nounwind
declare float @expf(float) #2

; Function Attrs: nounwind
declare float @powf(float, float) #2

declare float @exp2f(float)

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
!2 = metadata !{metadata !"float", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{metadata !6, metadata !6, i64 0}
!6 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!7 = metadata !{metadata !3, metadata !3, i64 0}
