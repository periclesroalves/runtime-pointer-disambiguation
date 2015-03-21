; ModuleID = './linear-algebra/solvers/cholesky/cholesky.c'
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
  %0 = tail call i8* @polybench_alloc_data(i64 4000000, i32 8) #3
  %1 = bitcast i8* %0 to [2000 x double]*
  tail call void @init_array(i32 2000, [2000 x double]* %1)
  tail call void (...)* @polybench_timer_start() #3
  tail call void @kernel_cholesky(i32 2000, [2000 x double]* %1)
  tail call void (...)* @polybench_timer_stop() #3
  tail call void (...)* @polybench_timer_print() #3
  %2 = icmp sgt i32 %argc, 42
  br i1 %2, label %3, label %7

; <label>:3                                       ; preds = %.split
  %4 = load i8** %argv, align 8, !tbaa !1
  %5 = load i8* %4, align 1, !tbaa !5
  %phitmp = icmp eq i8 %5, 0
  br i1 %phitmp, label %6, label %7

; <label>:6                                       ; preds = %3
  tail call void @print_array(i32 2000, [2000 x double]* %1)
  br label %7

; <label>:7                                       ; preds = %3, %6, %.split
  tail call void @free(i8* %0) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %n, [2000 x double]* %A) #0 {
.split:
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.preheader7.lr.ph, label %._crit_edge28

.preheader7.lr.ph:                                ; preds = %.split
  %1 = add i32 %n, -2
  %2 = zext i32 %n to i64
  %3 = zext i32 %1 to i64
  %4 = sitofp i32 %n to double
  br label %.preheader7

.preheader7:                                      ; preds = %.preheader7.lr.ph, %polly.merge109
  %indvar65 = phi i64 [ 0, %.preheader7.lr.ph ], [ %13, %polly.merge109 ]
  %5 = mul i64 %indvar65, 16000
  %6 = mul i64 %indvar65, -1
  %7 = add i64 %3, %6
  %8 = trunc i64 %7 to i32
  %9 = zext i32 %8 to i64
  %10 = mul i64 %indvar65, 16008
  %i.027 = trunc i64 %indvar65 to i32
  %11 = mul i64 %indvar65, 2001
  %12 = add i64 %11, 1
  %13 = add i64 %indvar65, 1
  %j.123 = trunc i64 %13 to i32
  %scevgep76 = getelementptr [2000 x double]* %A, i64 0, i64 %11
  %14 = add i64 %9, 1
  %15 = icmp slt i32 %i.027, 0
  br i1 %15, label %.preheader6, label %polly.cond128

.preheader6:                                      ; preds = %polly.then133, %polly.loop_header135, %polly.cond128, %.preheader7
  %16 = icmp slt i32 %j.123, %n
  br i1 %16, label %polly.cond108, label %polly.merge109

polly.merge109:                                   ; preds = %polly.then113, %polly.loop_header115, %polly.cond108, %.preheader6
  store double 1.000000e+00, double* %scevgep76, align 8, !tbaa !6
  %exitcond73 = icmp ne i64 %13, %2
  br i1 %exitcond73, label %.preheader7, label %._crit_edge28

._crit_edge28:                                    ; preds = %polly.merge109, %.split
  %17 = tail call i8* @polybench_alloc_data(i64 4000000, i32 8) #3
  br i1 %0, label %.preheader5.lr.ph, label %.preheader4

.preheader5.lr.ph:                                ; preds = %._crit_edge28
  %18 = zext i32 %n to i64
  %19 = sext i32 %n to i64
  %20 = icmp sge i64 %19, 1
  %21 = icmp sge i64 %18, 1
  %22 = and i1 %20, %21
  br i1 %22, label %polly.then, label %.preheader4

.preheader4:                                      ; preds = %polly.then, %polly.loop_exit80, %.preheader5.lr.ph, %._crit_edge28
  br i1 %0, label %.preheader3.lr.ph, label %.preheader1

.preheader3.lr.ph:                                ; preds = %.preheader4
  %23 = zext i32 %n to i64
  br label %.preheader3

.preheader3:                                      ; preds = %.preheader3.lr.ph, %._crit_edge15
  %indvar40 = phi i64 [ 0, %.preheader3.lr.ph ], [ %indvar.next41, %._crit_edge15 ]
  br i1 %0, label %.preheader2, label %._crit_edge15

.preheader1:                                      ; preds = %._crit_edge15, %.preheader4
  br i1 %0, label %.preheader.lr.ph, label %._crit_edge10

.preheader.lr.ph:                                 ; preds = %.preheader1
  %24 = zext i32 %n to i64
  br label %.preheader

.preheader2:                                      ; preds = %.preheader3, %._crit_edge13
  %indvar42 = phi i64 [ %indvar.next43, %._crit_edge13 ], [ 0, %.preheader3 ]
  %scevgep49 = getelementptr [2000 x double]* %A, i64 %indvar42, i64 %indvar40
  %25 = mul i64 %indvar42, 16000
  br i1 %0, label %.lr.ph12, label %._crit_edge13

.lr.ph12:                                         ; preds = %.preheader2, %.lr.ph12
  %indvar37 = phi i64 [ %indvar.next38, %.lr.ph12 ], [ 0, %.preheader2 ]
  %scevgep = getelementptr [2000 x double]* %A, i64 %indvar37, i64 %indvar40
  %26 = mul i64 %indvar37, 8
  %27 = add i64 %25, %26
  %scevgep47 = getelementptr i8* %17, i64 %27
  %scevgep4445 = bitcast i8* %scevgep47 to double*
  %28 = load double* %scevgep49, align 8, !tbaa !6
  %29 = load double* %scevgep, align 8, !tbaa !6
  %30 = fmul double %28, %29
  %31 = load double* %scevgep4445, align 8, !tbaa !6
  %32 = fadd double %31, %30
  store double %32, double* %scevgep4445, align 8, !tbaa !6
  %indvar.next38 = add i64 %indvar37, 1
  %exitcond39 = icmp ne i64 %indvar.next38, %23
  br i1 %exitcond39, label %.lr.ph12, label %._crit_edge13

._crit_edge13:                                    ; preds = %.lr.ph12, %.preheader2
  %indvar.next43 = add i64 %indvar42, 1
  %exitcond46 = icmp ne i64 %indvar.next43, %23
  br i1 %exitcond46, label %.preheader2, label %._crit_edge15

._crit_edge15:                                    ; preds = %._crit_edge13, %.preheader3
  %indvar.next41 = add i64 %indvar40, 1
  %exitcond50 = icmp ne i64 %indvar.next41, %23
  br i1 %exitcond50, label %.preheader3, label %.preheader1

.preheader:                                       ; preds = %.preheader.lr.ph, %._crit_edge
  %indvar29 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next30, %._crit_edge ]
  %33 = mul i64 %indvar29, 16000
  br i1 %0, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %.preheader, %.lr.ph
  %indvar = phi i64 [ %indvar.next, %.lr.ph ], [ 0, %.preheader ]
  %scevgep32 = getelementptr [2000 x double]* %A, i64 %indvar29, i64 %indvar
  %34 = mul i64 %indvar, 8
  %35 = add i64 %33, %34
  %scevgep35 = getelementptr i8* %17, i64 %35
  %scevgep31 = bitcast i8* %scevgep35 to double*
  %36 = load double* %scevgep31, align 8, !tbaa !6
  store double %36, double* %scevgep32, align 8, !tbaa !6
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %24
  br i1 %exitcond, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %.preheader
  %indvar.next30 = add i64 %indvar29, 1
  %exitcond33 = icmp ne i64 %indvar.next30, %24
  br i1 %exitcond33, label %.preheader, label %._crit_edge10

._crit_edge10:                                    ; preds = %._crit_edge, %.preheader1
  tail call void @free(i8* %17) #3
  ret void

polly.then:                                       ; preds = %.preheader5.lr.ph
  %37 = add i64 %18, -1
  %polly.loop_guard = icmp sle i64 0, %37
  br i1 %polly.loop_guard, label %polly.loop_header, label %.preheader4

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit80
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit80 ], [ 0, %polly.then ]
  %38 = mul i64 -11, %18
  %39 = add i64 %38, 5
  %40 = sub i64 %39, 32
  %41 = add i64 %40, 1
  %42 = icmp slt i64 %39, 0
  %43 = select i1 %42, i64 %41, i64 %39
  %44 = sdiv i64 %43, 32
  %45 = mul i64 -32, %44
  %46 = mul i64 -32, %18
  %47 = add i64 %45, %46
  %48 = mul i64 -32, %polly.indvar
  %49 = mul i64 -3, %polly.indvar
  %50 = add i64 %49, %18
  %51 = add i64 %50, 5
  %52 = sub i64 %51, 32
  %53 = add i64 %52, 1
  %54 = icmp slt i64 %51, 0
  %55 = select i1 %54, i64 %53, i64 %51
  %56 = sdiv i64 %55, 32
  %57 = mul i64 -32, %56
  %58 = add i64 %48, %57
  %59 = add i64 %58, -640
  %60 = icmp sgt i64 %47, %59
  %61 = select i1 %60, i64 %47, i64 %59
  %62 = mul i64 -20, %polly.indvar
  %polly.loop_guard81 = icmp sle i64 %61, %62
  br i1 %polly.loop_guard81, label %polly.loop_header78, label %polly.loop_exit80

polly.loop_exit80:                                ; preds = %polly.loop_exit89, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %37, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %.preheader4

polly.loop_header78:                              ; preds = %polly.loop_header, %polly.loop_exit89
  %polly.indvar82 = phi i64 [ %polly.indvar_next83, %polly.loop_exit89 ], [ %61, %polly.loop_header ]
  %63 = mul i64 -1, %polly.indvar82
  %64 = mul i64 -1, %18
  %65 = add i64 %63, %64
  %66 = add i64 %65, -30
  %67 = add i64 %66, 20
  %68 = sub i64 %67, 1
  %69 = icmp slt i64 %66, 0
  %70 = select i1 %69, i64 %66, i64 %68
  %71 = sdiv i64 %70, 20
  %72 = icmp sgt i64 %71, %polly.indvar
  %73 = select i1 %72, i64 %71, i64 %polly.indvar
  %74 = sub i64 %63, 20
  %75 = add i64 %74, 1
  %76 = icmp slt i64 %63, 0
  %77 = select i1 %76, i64 %75, i64 %63
  %78 = sdiv i64 %77, 20
  %79 = add i64 %polly.indvar, 31
  %80 = icmp slt i64 %78, %79
  %81 = select i1 %80, i64 %78, i64 %79
  %82 = icmp slt i64 %81, %37
  %83 = select i1 %82, i64 %81, i64 %37
  %polly.loop_guard90 = icmp sle i64 %73, %83
  br i1 %polly.loop_guard90, label %polly.loop_header87, label %polly.loop_exit89

polly.loop_exit89:                                ; preds = %polly.loop_exit98, %polly.loop_header78
  %polly.indvar_next83 = add nsw i64 %polly.indvar82, 32
  %polly.adjust_ub84 = sub i64 %62, 32
  %polly.loop_cond85 = icmp sle i64 %polly.indvar82, %polly.adjust_ub84
  br i1 %polly.loop_cond85, label %polly.loop_header78, label %polly.loop_exit80

polly.loop_header87:                              ; preds = %polly.loop_header78, %polly.loop_exit98
  %polly.indvar91 = phi i64 [ %polly.indvar_next92, %polly.loop_exit98 ], [ %73, %polly.loop_header78 ]
  %84 = mul i64 -20, %polly.indvar91
  %85 = add i64 %84, %64
  %86 = add i64 %85, 1
  %87 = icmp sgt i64 %polly.indvar82, %86
  %88 = select i1 %87, i64 %polly.indvar82, i64 %86
  %89 = add i64 %polly.indvar82, 31
  %90 = icmp slt i64 %84, %89
  %91 = select i1 %90, i64 %84, i64 %89
  %polly.loop_guard99 = icmp sle i64 %88, %91
  br i1 %polly.loop_guard99, label %polly.loop_header96, label %polly.loop_exit98

polly.loop_exit98:                                ; preds = %polly.loop_header96, %polly.loop_header87
  %polly.indvar_next92 = add nsw i64 %polly.indvar91, 1
  %polly.adjust_ub93 = sub i64 %83, 1
  %polly.loop_cond94 = icmp sle i64 %polly.indvar91, %polly.adjust_ub93
  br i1 %polly.loop_cond94, label %polly.loop_header87, label %polly.loop_exit89

polly.loop_header96:                              ; preds = %polly.loop_header87, %polly.loop_header96
  %polly.indvar100 = phi i64 [ %polly.indvar_next101, %polly.loop_header96 ], [ %88, %polly.loop_header87 ]
  %92 = mul i64 -1, %polly.indvar100
  %93 = add i64 %84, %92
  %p_.moved.to. = mul i64 %polly.indvar91, 16000
  %p_ = mul i64 %93, 8
  %p_104 = add i64 %p_.moved.to., %p_
  %p_scevgep61 = getelementptr i8* %17, i64 %p_104
  %p_scevgep5859 = bitcast i8* %p_scevgep61 to double*
  store double 0.000000e+00, double* %p_scevgep5859
  %p_indvar.next54 = add i64 %93, 1
  %polly.indvar_next101 = add nsw i64 %polly.indvar100, 1
  %polly.adjust_ub102 = sub i64 %91, 1
  %polly.loop_cond103 = icmp sle i64 %polly.indvar100, %polly.adjust_ub102
  br i1 %polly.loop_cond103, label %polly.loop_header96, label %polly.loop_exit98

polly.cond108:                                    ; preds = %.preheader6
  %94 = srem i64 %10, 8
  %95 = icmp eq i64 %94, 0
  br i1 %95, label %polly.then113, label %polly.merge109

polly.then113:                                    ; preds = %polly.cond108
  br i1 true, label %polly.loop_header115, label %polly.merge109

polly.loop_header115:                             ; preds = %polly.then113, %polly.loop_header115
  %polly.indvar119 = phi i64 [ %polly.indvar_next120, %polly.loop_header115 ], [ 0, %polly.then113 ]
  %p_124 = add i64 %12, %polly.indvar119
  %p_scevgep72 = getelementptr [2000 x double]* %A, i64 0, i64 %p_124
  store double 0.000000e+00, double* %p_scevgep72
  %p_indvar.next70 = add i64 %polly.indvar119, 1
  %polly.indvar_next120 = add nsw i64 %polly.indvar119, 1
  %polly.adjust_ub121 = sub i64 %9, 1
  %polly.loop_cond122 = icmp sle i64 %polly.indvar119, %polly.adjust_ub121
  br i1 %polly.loop_cond122, label %polly.loop_header115, label %polly.merge109

polly.cond128:                                    ; preds = %.preheader7
  %96 = srem i64 %5, 8
  %97 = icmp eq i64 %96, 0
  %98 = icmp sge i64 %indvar65, 0
  %or.cond152 = and i1 %97, %98
  br i1 %or.cond152, label %polly.then133, label %.preheader6

polly.then133:                                    ; preds = %polly.cond128
  br i1 %98, label %polly.loop_header135, label %.preheader6

polly.loop_header135:                             ; preds = %polly.then133, %polly.loop_header135
  %polly.indvar139 = phi i64 [ %polly.indvar_next140, %polly.loop_header135 ], [ 0, %polly.then133 ]
  %p_scevgep68 = getelementptr [2000 x double]* %A, i64 %indvar65, i64 %polly.indvar139
  %p_144 = mul i64 %polly.indvar139, -1
  %p_145 = trunc i64 %p_144 to i32
  %p_146 = srem i32 %p_145, %n
  %p_147 = sitofp i32 %p_146 to double
  %p_148 = fdiv double %p_147, %4
  %p_149 = fadd double %p_148, 1.000000e+00
  store double %p_149, double* %p_scevgep68
  %p_indvar.next64 = add i64 %polly.indvar139, 1
  %polly.indvar_next140 = add nsw i64 %polly.indvar139, 1
  %polly.adjust_ub141 = sub i64 %indvar65, 1
  %polly.loop_cond142 = icmp sle i64 %polly.indvar139, %polly.adjust_ub141
  br i1 %polly.loop_cond142, label %polly.loop_header135, label %.preheader6
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_cholesky(i32 %n, [2000 x double]* %A) #0 {
.split:
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.preheader.lr.ph, label %._crit_edge10

.preheader.lr.ph:                                 ; preds = %.split
  %1 = zext i32 %n to i64
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %polly.merge
  %2 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next14, %polly.merge ]
  %3 = mul i64 %2, 16000
  %4 = mul i64 %2, 16008
  %i.09 = trunc i64 %2 to i32
  %5 = mul i64 %2, 2001
  %scevgep28 = getelementptr [2000 x double]* %A, i64 0, i64 %5
  %6 = icmp sgt i32 %i.09, 0
  br i1 %6, label %polly.cond39, label %polly.merge40

polly.merge40:                                    ; preds = %polly.stmt.45, %polly.loop_exit69, %polly.cond39, %.preheader
  %7 = load double* %scevgep28, align 8, !tbaa !6
  store double %7, double* %scevgep28, align 8, !tbaa !6
  br i1 %6, label %polly.cond, label %polly.merge

polly.merge:                                      ; preds = %polly.then32, %polly.loop_header, %polly.cond, %polly.merge40
  %8 = load double* %scevgep28, align 8, !tbaa !6
  %9 = tail call double @sqrt(double %8) #3
  store double %9, double* %scevgep28, align 8, !tbaa !6
  %indvar.next14 = add i64 %2, 1
  %exitcond24 = icmp ne i64 %indvar.next14, %1
  br i1 %exitcond24, label %.preheader, label %._crit_edge10

._crit_edge10:                                    ; preds = %polly.merge, %.split
  ret void

polly.cond:                                       ; preds = %polly.merge40
  %10 = srem i64 %4, 8
  %11 = icmp eq i64 %10, 0
  %12 = icmp sge i64 %2, 1
  %or.cond = and i1 %11, %12
  br i1 %or.cond, label %polly.then32, label %polly.merge

polly.then32:                                     ; preds = %polly.cond
  %13 = add i64 %2, -1
  %polly.loop_guard = icmp sle i64 0, %13
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then32, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then32 ]
  %p_scevgep23 = getelementptr [2000 x double]* %A, i64 %2, i64 %polly.indvar
  %_p_scalar_ = load double* %p_scevgep23
  %p_ = fmul double %_p_scalar_, %_p_scalar_
  %_p_scalar_34 = load double* %scevgep28
  %p_35 = fsub double %_p_scalar_34, %p_
  store double %p_35, double* %scevgep28
  %p_indvar.next21 = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %13, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.cond39:                                     ; preds = %.preheader
  %14 = srem i64 %3, 8
  %15 = icmp eq i64 %14, 0
  %16 = icmp sge i64 %2, 1
  %or.cond92 = and i1 %15, %16
  br i1 %or.cond92, label %polly.stmt.45, label %polly.merge40

polly.stmt.45:                                    ; preds = %polly.cond39
  %p_scevgep18 = getelementptr [2000 x double]* %A, i64 %2, i64 0
  %_p_scalar_46 = load double* %p_scevgep18
  store double %_p_scalar_46, double* %p_scevgep18
  %p_scevgep19.moved.to. = getelementptr [2000 x double]* %A, i64 0, i64 0
  %_p_scalar_49 = load double* %p_scevgep19.moved.to.
  %p_51 = fdiv double %_p_scalar_46, %_p_scalar_49
  store double %p_51, double* %p_scevgep18
  %17 = add i64 %2, -1
  %polly.loop_guard56 = icmp sle i64 1, %17
  br i1 %polly.loop_guard56, label %polly.loop_header53, label %polly.merge40

polly.loop_header53:                              ; preds = %polly.stmt.45, %polly.loop_exit69
  %polly.indvar57 = phi i64 [ %polly.indvar_next58, %polly.loop_exit69 ], [ 1, %polly.stmt.45 ]
  %p_scevgep1862 = getelementptr [2000 x double]* %A, i64 %2, i64 %polly.indvar57
  %p_j.0263 = trunc i64 %polly.indvar57 to i32
  %_p_scalar_64 = load double* %p_scevgep1862
  store double %_p_scalar_64, double* %p_scevgep1862
  %18 = add i64 %polly.indvar57, -1
  %polly.loop_guard70 = icmp sle i64 0, %18
  br i1 %polly.loop_guard70, label %polly.loop_header67, label %polly.loop_exit69

polly.loop_exit69:                                ; preds = %polly.loop_header67, %polly.loop_header53
  %p_.moved.to.82 = mul i64 %polly.indvar57, 2001
  %p_scevgep19.moved.to.83 = getelementptr [2000 x double]* %A, i64 0, i64 %p_.moved.to.82
  %_p_scalar_85 = load double* %p_scevgep19.moved.to.83
  %_p_scalar_86 = load double* %p_scevgep1862
  %p_87 = fdiv double %_p_scalar_86, %_p_scalar_85
  store double %p_87, double* %p_scevgep1862
  %p_indvar.next1288 = add i64 %polly.indvar57, 1
  %polly.indvar_next58 = add nsw i64 %polly.indvar57, 1
  %polly.adjust_ub59 = sub i64 %17, 1
  %polly.loop_cond60 = icmp sle i64 %polly.indvar57, %polly.adjust_ub59
  br i1 %polly.loop_cond60, label %polly.loop_header53, label %polly.merge40

polly.loop_header67:                              ; preds = %polly.loop_header53, %polly.loop_header67
  %polly.indvar71 = phi i64 [ %polly.indvar_next72, %polly.loop_header67 ], [ 0, %polly.loop_header53 ]
  %p_scevgep = getelementptr [2000 x double]* %A, i64 %2, i64 %polly.indvar71
  %p_scevgep15 = getelementptr [2000 x double]* %A, i64 %polly.indvar57, i64 %polly.indvar71
  %_p_scalar_76 = load double* %p_scevgep
  %_p_scalar_77 = load double* %p_scevgep15
  %p_78 = fmul double %_p_scalar_76, %_p_scalar_77
  %_p_scalar_79 = load double* %p_scevgep1862
  %p_80 = fsub double %_p_scalar_79, %p_78
  store double %p_80, double* %p_scevgep1862
  %p_indvar.next = add i64 %polly.indvar71, 1
  %polly.indvar_next72 = add nsw i64 %polly.indvar71, 1
  %polly.adjust_ub73 = sub i64 %18, 1
  %polly.loop_cond74 = icmp sle i64 %polly.indvar71, %polly.adjust_ub73
  br i1 %polly.loop_cond74, label %polly.loop_header67, label %polly.loop_exit69
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, [2000 x double]* %A) #0 {
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
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %21
  %indvar4 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next5, %21 ]
  %i.02 = trunc i64 %indvar4 to i32
  %7 = mul i64 %6, %indvar4
  %8 = add i64 %indvar4, 1
  %9 = icmp slt i32 %i.02, 0
  br i1 %9, label %21, label %.lr.ph

.lr.ph:                                           ; preds = %.preheader
  br label %10

; <label>:10                                      ; preds = %17, %.lr.ph
  %indvar = phi i64 [ %indvar.next, %17 ], [ 0, %.lr.ph ]
  %11 = add i64 %7, %indvar
  %12 = trunc i64 %11 to i32
  %scevgep = getelementptr [2000 x double]* %A, i64 %indvar4, i64 %indvar
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
  %exitcond = icmp ne i64 %indvar.next, %8
  br i1 %exitcond, label %10, label %._crit_edge

._crit_edge:                                      ; preds = %17
  br label %21

; <label>:21                                      ; preds = %._crit_edge, %.preheader
  %indvar.next5 = add i64 %indvar4, 1
  %exitcond6 = icmp ne i64 %indvar.next5, %6
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
!2 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{metadata !3, metadata !3, i64 0}
!6 = metadata !{metadata !7, metadata !7, i64 0}
!7 = metadata !{metadata !"double", metadata !3, i64 0}
