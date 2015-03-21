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
define internal void @init_array(i32 %w, i32 %h, float* %alpha, [2160 x float]* %imgIn, [2160 x float]* %imgOut) #0 {
.split:
  store float 2.500000e-01, float* %alpha, align 4, !tbaa !1
  %0 = icmp sgt i32 %w, 0
  br i1 %0, label %.preheader.lr.ph, label %polly.merge

.preheader.lr.ph:                                 ; preds = %.split
  %1 = zext i32 %h to i64
  %2 = zext i32 %w to i64
  %3 = sext i32 %h to i64
  %4 = icmp sge i64 %3, 1
  %5 = icmp sge i64 %2, 1
  %6 = and i1 %4, %5
  %7 = icmp sge i64 %1, 1
  %8 = and i1 %6, %7
  br i1 %8, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit12, %.preheader.lr.ph, %.split
  ret void

polly.then:                                       ; preds = %.preheader.lr.ph
  %9 = add i64 %2, -1
  %polly.loop_guard = icmp sle i64 0, %9
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit12
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit12 ], [ 0, %polly.then ]
  %10 = mul i64 -3, %2
  %11 = add i64 %10, %1
  %12 = add i64 %11, 5
  %13 = sub i64 %12, 32
  %14 = add i64 %13, 1
  %15 = icmp slt i64 %12, 0
  %16 = select i1 %15, i64 %14, i64 %12
  %17 = sdiv i64 %16, 32
  %18 = mul i64 -32, %17
  %19 = mul i64 -32, %2
  %20 = add i64 %18, %19
  %21 = mul i64 -32, %polly.indvar
  %22 = mul i64 -3, %polly.indvar
  %23 = add i64 %22, %1
  %24 = add i64 %23, 5
  %25 = sub i64 %24, 32
  %26 = add i64 %25, 1
  %27 = icmp slt i64 %24, 0
  %28 = select i1 %27, i64 %26, i64 %24
  %29 = sdiv i64 %28, 32
  %30 = mul i64 -32, %29
  %31 = add i64 %21, %30
  %32 = add i64 %31, -640
  %33 = icmp sgt i64 %20, %32
  %34 = select i1 %33, i64 %20, i64 %32
  %35 = mul i64 -20, %polly.indvar
  %polly.loop_guard13 = icmp sle i64 %34, %35
  br i1 %polly.loop_guard13, label %polly.loop_header10, label %polly.loop_exit12

polly.loop_exit12:                                ; preds = %polly.loop_exit21, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %9, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header10:                              ; preds = %polly.loop_header, %polly.loop_exit21
  %polly.indvar14 = phi i64 [ %polly.indvar_next15, %polly.loop_exit21 ], [ %34, %polly.loop_header ]
  %36 = mul i64 -1, %polly.indvar14
  %37 = mul i64 -1, %1
  %38 = add i64 %36, %37
  %39 = add i64 %38, -30
  %40 = add i64 %39, 20
  %41 = sub i64 %40, 1
  %42 = icmp slt i64 %39, 0
  %43 = select i1 %42, i64 %39, i64 %41
  %44 = sdiv i64 %43, 20
  %45 = icmp sgt i64 %44, %polly.indvar
  %46 = select i1 %45, i64 %44, i64 %polly.indvar
  %47 = sub i64 %36, 20
  %48 = add i64 %47, 1
  %49 = icmp slt i64 %36, 0
  %50 = select i1 %49, i64 %48, i64 %36
  %51 = sdiv i64 %50, 20
  %52 = add i64 %polly.indvar, 31
  %53 = icmp slt i64 %51, %52
  %54 = select i1 %53, i64 %51, i64 %52
  %55 = icmp slt i64 %54, %9
  %56 = select i1 %55, i64 %54, i64 %9
  %polly.loop_guard22 = icmp sle i64 %46, %56
  br i1 %polly.loop_guard22, label %polly.loop_header19, label %polly.loop_exit21

polly.loop_exit21:                                ; preds = %polly.loop_exit30, %polly.loop_header10
  %polly.indvar_next15 = add nsw i64 %polly.indvar14, 32
  %polly.adjust_ub16 = sub i64 %35, 32
  %polly.loop_cond17 = icmp sle i64 %polly.indvar14, %polly.adjust_ub16
  br i1 %polly.loop_cond17, label %polly.loop_header10, label %polly.loop_exit12

polly.loop_header19:                              ; preds = %polly.loop_header10, %polly.loop_exit30
  %polly.indvar23 = phi i64 [ %polly.indvar_next24, %polly.loop_exit30 ], [ %46, %polly.loop_header10 ]
  %57 = mul i64 -20, %polly.indvar23
  %58 = add i64 %57, %37
  %59 = add i64 %58, 1
  %60 = icmp sgt i64 %polly.indvar14, %59
  %61 = select i1 %60, i64 %polly.indvar14, i64 %59
  %62 = add i64 %polly.indvar14, 31
  %63 = icmp slt i64 %57, %62
  %64 = select i1 %63, i64 %57, i64 %62
  %polly.loop_guard31 = icmp sle i64 %61, %64
  br i1 %polly.loop_guard31, label %polly.loop_header28, label %polly.loop_exit30

polly.loop_exit30:                                ; preds = %polly.loop_header28, %polly.loop_header19
  %polly.indvar_next24 = add nsw i64 %polly.indvar23, 1
  %polly.adjust_ub25 = sub i64 %56, 1
  %polly.loop_cond26 = icmp sle i64 %polly.indvar23, %polly.adjust_ub25
  br i1 %polly.loop_cond26, label %polly.loop_header19, label %polly.loop_exit21

polly.loop_header28:                              ; preds = %polly.loop_header19, %polly.loop_header28
  %polly.indvar32 = phi i64 [ %polly.indvar_next33, %polly.loop_header28 ], [ %61, %polly.loop_header19 ]
  %65 = mul i64 -1, %polly.indvar32
  %66 = add i64 %57, %65
  %p_.moved.to. = mul i64 %polly.indvar23, 313
  %p_ = mul i64 %66, 991
  %p_36 = add i64 %p_.moved.to., %p_
  %p_37 = trunc i64 %p_36 to i32
  %p_scevgep = getelementptr [2160 x float]* %imgIn, i64 %polly.indvar23, i64 %66
  %p_38 = srem i32 %p_37, 65536
  %p_39 = sitofp i32 %p_38 to float
  %p_40 = fdiv float %p_39, 6.553500e+04
  store float %p_40, float* %p_scevgep
  %p_indvar.next = add i64 %66, 1
  %polly.indvar_next33 = add nsw i64 %polly.indvar32, 1
  %polly.adjust_ub34 = sub i64 %64, 1
  %polly.loop_cond35 = icmp sle i64 %polly.indvar32, %polly.adjust_ub34
  br i1 %polly.loop_cond35, label %polly.loop_header28, label %polly.loop_exit30
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_deriche(i32 %w, i32 %h, float %alpha, [2160 x float]* %imgIn, [2160 x float]* %imgOut, [2160 x float]* %y1, [2160 x float]* %y2) #0 {
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
  br i1 %27, label %.preheader10.lr.ph, label %.preheader9

.preheader10.lr.ph:                               ; preds = %.split
  %28 = zext i32 %h to i64
  %29 = zext i32 %w to i64
  %30 = icmp sgt i32 %h, 0
  br label %.preheader10

.preheader10:                                     ; preds = %.preheader10.lr.ph, %._crit_edge48
  %indvar103 = phi i64 [ 0, %.preheader10.lr.ph ], [ %indvar.next104, %._crit_edge48 ]
  br i1 %30, label %.lr.ph47, label %._crit_edge48

.lr.ph47:                                         ; preds = %.preheader10
  br label %36

.preheader9:                                      ; preds = %._crit_edge48, %.split
  br i1 %27, label %.preheader8.lr.ph, label %.preheader7

.preheader8.lr.ph:                                ; preds = %.preheader9
  %31 = zext i32 %h to i64
  %32 = zext i32 %w to i64
  %33 = sext i32 %h to i64
  %34 = add i64 %33, -1
  %35 = icmp sgt i32 %h, 0
  br label %.preheader8

; <label>:36                                      ; preds = %.lr.ph47, %36
  %ym2.046.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph47 ], [ %ym1.043.reg2mem.0, %36 ]
  %xm1.044.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph47 ], [ %45, %36 ]
  %ym1.043.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph47 ], [ %44, %36 ]
  %indvar100 = phi i64 [ 0, %.lr.ph47 ], [ %indvar.next101, %36 ]
  %scevgep106 = getelementptr [2160 x float]* %y1, i64 %indvar103, i64 %indvar100
  %scevgep105 = getelementptr [2160 x float]* %imgIn, i64 %indvar103, i64 %indvar100
  %37 = load float* %scevgep105, align 4, !tbaa !1
  %38 = fmul float %12, %37
  %39 = fmul float %16, %xm1.044.reg2mem.0
  %40 = fadd float %39, %38
  %41 = fmul float %exp2f, %ym1.043.reg2mem.0
  %42 = fadd float %41, %40
  %43 = fmul float %ym2.046.reg2mem.0, %26
  %44 = fadd float %43, %42
  store float %44, float* %scevgep106, align 4, !tbaa !1
  %45 = load float* %scevgep105, align 4, !tbaa !1
  %indvar.next101 = add i64 %indvar100, 1
  %exitcond102 = icmp ne i64 %indvar.next101, %28
  br i1 %exitcond102, label %36, label %._crit_edge48

._crit_edge48:                                    ; preds = %36, %.preheader10
  %indvar.next104 = add i64 %indvar103, 1
  %exitcond107 = icmp ne i64 %indvar.next104, %29
  br i1 %exitcond107, label %.preheader10, label %.preheader9

.preheader8:                                      ; preds = %.preheader8.lr.ph, %._crit_edge41
  %indvar93 = phi i64 [ 0, %.preheader8.lr.ph ], [ %indvar.next94, %._crit_edge41 ]
  br i1 %35, label %.lr.ph40, label %._crit_edge41

.lr.ph40:                                         ; preds = %.preheader8
  br label %49

.preheader7:                                      ; preds = %._crit_edge41, %.preheader9
  br i1 %27, label %.preheader6.lr.ph, label %.preheader5

.preheader6.lr.ph:                                ; preds = %.preheader7
  %46 = zext i32 %h to i64
  %47 = zext i32 %w to i64
  %48 = icmp sgt i32 %h, 0
  br label %.preheader6

; <label>:49                                      ; preds = %.lr.ph40, %49
  %yp2.038.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph40 ], [ %yp1.037.reg2mem.0, %49 ]
  %yp1.037.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph40 ], [ %58, %49 ]
  %xp2.036.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph40 ], [ %xp1.035.reg2mem.0, %49 ]
  %xp1.035.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph40 ], [ %59, %49 ]
  %indvar90 = phi i64 [ 0, %.lr.ph40 ], [ %indvar.next91, %49 ]
  %50 = mul i64 %indvar90, -1
  %51 = add i64 %34, %50
  %scevgep96 = getelementptr [2160 x float]* %imgIn, i64 %indvar93, i64 %51
  %scevgep95 = getelementptr [2160 x float]* %y2, i64 %indvar93, i64 %51
  %52 = fmul float %20, %xp1.035.reg2mem.0
  %53 = fmul float %xp2.036.reg2mem.0, %24
  %54 = fadd float %52, %53
  %55 = fmul float %exp2f, %yp1.037.reg2mem.0
  %56 = fadd float %54, %55
  %57 = fmul float %yp2.038.reg2mem.0, %26
  %58 = fadd float %56, %57
  store float %58, float* %scevgep95, align 4, !tbaa !1
  %59 = load float* %scevgep96, align 4, !tbaa !1
  %indvar.next91 = add i64 %indvar90, 1
  %exitcond92 = icmp ne i64 %indvar.next91, %31
  br i1 %exitcond92, label %49, label %._crit_edge41

._crit_edge41:                                    ; preds = %49, %.preheader8
  %indvar.next94 = add i64 %indvar93, 1
  %exitcond97 = icmp ne i64 %indvar.next94, %32
  br i1 %exitcond97, label %.preheader8, label %.preheader7

.preheader6:                                      ; preds = %.preheader6.lr.ph, %._crit_edge32
  %indvar81 = phi i64 [ 0, %.preheader6.lr.ph ], [ %indvar.next82, %._crit_edge32 ]
  br i1 %48, label %.lr.ph31, label %._crit_edge32

.preheader5:                                      ; preds = %._crit_edge32, %.preheader7
  %60 = icmp sgt i32 %h, 0
  br i1 %60, label %.preheader4.lr.ph, label %.preheader3

.preheader4.lr.ph:                                ; preds = %.preheader5
  %61 = zext i32 %w to i64
  %62 = zext i32 %h to i64
  br label %.preheader4

.lr.ph31:                                         ; preds = %.preheader6, %.lr.ph31
  %indvar78 = phi i64 [ %indvar.next79, %.lr.ph31 ], [ 0, %.preheader6 ]
  %scevgep85 = getelementptr [2160 x float]* %imgOut, i64 %indvar81, i64 %indvar78
  %scevgep84 = getelementptr [2160 x float]* %y2, i64 %indvar81, i64 %indvar78
  %scevgep83 = getelementptr [2160 x float]* %y1, i64 %indvar81, i64 %indvar78
  %63 = load float* %scevgep83, align 4, !tbaa !1
  %64 = load float* %scevgep84, align 4, !tbaa !1
  %65 = fadd float %63, %64
  store float %65, float* %scevgep85, align 4, !tbaa !1
  %indvar.next79 = add i64 %indvar78, 1
  %exitcond80 = icmp ne i64 %indvar.next79, %46
  br i1 %exitcond80, label %.lr.ph31, label %._crit_edge32

._crit_edge32:                                    ; preds = %.lr.ph31, %.preheader6
  %indvar.next82 = add i64 %indvar81, 1
  %exitcond86 = icmp ne i64 %indvar.next82, %47
  br i1 %exitcond86, label %.preheader6, label %.preheader5

.preheader4:                                      ; preds = %.preheader4.lr.ph, %._crit_edge28
  %indvar71 = phi i64 [ 0, %.preheader4.lr.ph ], [ %indvar.next72, %._crit_edge28 ]
  br i1 %27, label %.lr.ph27, label %._crit_edge28

.lr.ph27:                                         ; preds = %.preheader4
  br label %70

.preheader3:                                      ; preds = %._crit_edge28, %.preheader5
  br i1 %60, label %.preheader2.lr.ph, label %.preheader1

.preheader2.lr.ph:                                ; preds = %.preheader3
  %66 = zext i32 %w to i64
  %67 = zext i32 %h to i64
  %68 = sext i32 %w to i64
  %69 = add i64 %68, -1
  br label %.preheader2

; <label>:70                                      ; preds = %.lr.ph27, %70
  %ym2.126.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph27 ], [ %ym1.123.reg2mem.0, %70 ]
  %tm1.024.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph27 ], [ %79, %70 ]
  %ym1.123.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph27 ], [ %78, %70 ]
  %indvar68 = phi i64 [ 0, %.lr.ph27 ], [ %indvar.next69, %70 ]
  %scevgep74 = getelementptr [2160 x float]* %y1, i64 %indvar68, i64 %indvar71
  %scevgep73 = getelementptr [2160 x float]* %imgOut, i64 %indvar68, i64 %indvar71
  %71 = load float* %scevgep73, align 4, !tbaa !1
  %72 = fmul float %12, %71
  %73 = fmul float %16, %tm1.024.reg2mem.0
  %74 = fadd float %73, %72
  %75 = fmul float %exp2f, %ym1.123.reg2mem.0
  %76 = fadd float %75, %74
  %77 = fmul float %ym2.126.reg2mem.0, %26
  %78 = fadd float %77, %76
  store float %78, float* %scevgep74, align 4, !tbaa !1
  %79 = load float* %scevgep73, align 4, !tbaa !1
  %indvar.next69 = add i64 %indvar68, 1
  %exitcond70 = icmp ne i64 %indvar.next69, %61
  br i1 %exitcond70, label %70, label %._crit_edge28

._crit_edge28:                                    ; preds = %70, %.preheader4
  %indvar.next72 = add i64 %indvar71, 1
  %exitcond75 = icmp ne i64 %indvar.next72, %62
  br i1 %exitcond75, label %.preheader4, label %.preheader3

.preheader2:                                      ; preds = %.preheader2.lr.ph, %._crit_edge21
  %indvar61 = phi i64 [ 0, %.preheader2.lr.ph ], [ %indvar.next62, %._crit_edge21 ]
  br i1 %27, label %.lr.ph20, label %._crit_edge21

.lr.ph20:                                         ; preds = %.preheader2
  br label %82

.preheader1:                                      ; preds = %._crit_edge21, %.preheader3
  br i1 %27, label %.preheader.lr.ph, label %._crit_edge13

.preheader.lr.ph:                                 ; preds = %.preheader1
  %80 = zext i32 %h to i64
  %81 = zext i32 %w to i64
  br label %.preheader

; <label>:82                                      ; preds = %.lr.ph20, %82
  %yp2.118.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph20 ], [ %yp1.117.reg2mem.0, %82 ]
  %yp1.117.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph20 ], [ %91, %82 ]
  %tp2.016.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph20 ], [ %tp1.015.reg2mem.0, %82 ]
  %tp1.015.reg2mem.0 = phi float [ 0.000000e+00, %.lr.ph20 ], [ %92, %82 ]
  %indvar58 = phi i64 [ 0, %.lr.ph20 ], [ %indvar.next59, %82 ]
  %83 = mul i64 %indvar58, -1
  %84 = add i64 %69, %83
  %scevgep64 = getelementptr [2160 x float]* %imgOut, i64 %84, i64 %indvar61
  %scevgep63 = getelementptr [2160 x float]* %y2, i64 %84, i64 %indvar61
  %85 = fmul float %20, %tp1.015.reg2mem.0
  %86 = fmul float %tp2.016.reg2mem.0, %24
  %87 = fadd float %85, %86
  %88 = fmul float %exp2f, %yp1.117.reg2mem.0
  %89 = fadd float %87, %88
  %90 = fmul float %yp2.118.reg2mem.0, %26
  %91 = fadd float %89, %90
  store float %91, float* %scevgep63, align 4, !tbaa !1
  %92 = load float* %scevgep64, align 4, !tbaa !1
  %indvar.next59 = add i64 %indvar58, 1
  %exitcond60 = icmp ne i64 %indvar.next59, %66
  br i1 %exitcond60, label %82, label %._crit_edge21

._crit_edge21:                                    ; preds = %82, %.preheader2
  %indvar.next62 = add i64 %indvar61, 1
  %exitcond65 = icmp ne i64 %indvar.next62, %67
  br i1 %exitcond65, label %.preheader2, label %.preheader1

.preheader:                                       ; preds = %.preheader.lr.ph, %._crit_edge
  %indvar50 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next51, %._crit_edge ]
  br i1 %60, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %.preheader, %.lr.ph
  %indvar = phi i64 [ %indvar.next, %.lr.ph ], [ 0, %.preheader ]
  %scevgep53 = getelementptr [2160 x float]* %imgOut, i64 %indvar50, i64 %indvar
  %scevgep52 = getelementptr [2160 x float]* %y2, i64 %indvar50, i64 %indvar
  %scevgep = getelementptr [2160 x float]* %y1, i64 %indvar50, i64 %indvar
  %93 = load float* %scevgep, align 4, !tbaa !1
  %94 = load float* %scevgep52, align 4, !tbaa !1
  %95 = fadd float %93, %94
  store float %95, float* %scevgep53, align 4, !tbaa !1
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %80
  br i1 %exitcond, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %.preheader
  %indvar.next51 = add i64 %indvar50, 1
  %exitcond54 = icmp ne i64 %indvar.next51, %81
  br i1 %exitcond54, label %.preheader, label %._crit_edge13

._crit_edge13:                                    ; preds = %._crit_edge, %.preheader1
  ret void
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %w, i32 %h, [2160 x float]* %imgOut) #0 {
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
