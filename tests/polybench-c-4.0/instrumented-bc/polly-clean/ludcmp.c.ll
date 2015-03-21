; ModuleID = './linear-algebra/solvers/ludcmp/ludcmp.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %0 = tail call i8* @polybench_alloc_data(i64 4000000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %3 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %4 = bitcast i8* %0 to [2000 x double]*
  %5 = bitcast i8* %1 to double*
  %6 = bitcast i8* %2 to double*
  %7 = bitcast i8* %3 to double*
  tail call void @init_array(i32 2000, [2000 x double]* %4, double* %5, double* %6, double* %7)
  tail call void (...)* @polybench_timer_start() #3
  tail call void @kernel_ludcmp(i32 2000, [2000 x double]* %4, double* %5, double* %6, double* %7)
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
  tail call void @print_array(i32 2000, double* %6)
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
define internal void @init_array(i32 %n, [2000 x double]* %A, double* %b, double* %x, double* %y) #0 {
.split:
  %0 = sitofp i32 %n to double
  %1 = icmp sgt i32 %n, 0
  br i1 %1, label %.lr.ph32, label %.preheader8

.lr.ph32:                                         ; preds = %.split
  %2 = zext i32 %n to i64
  br label %6

.preheader8:                                      ; preds = %6, %.split
  br i1 %1, label %.preheader7.lr.ph, label %._crit_edge29

.preheader7.lr.ph:                                ; preds = %.preheader8
  %3 = add i32 %n, -2
  %4 = zext i32 %n to i64
  %5 = zext i32 %3 to i64
  br label %.preheader7

; <label>:6                                       ; preds = %.lr.ph32, %6
  %indvar81 = phi i64 [ 0, %.lr.ph32 ], [ %7, %6 ]
  %scevgep84 = getelementptr double* %x, i64 %indvar81
  %scevgep85 = getelementptr double* %y, i64 %indvar81
  %7 = add i64 %indvar81, 1
  %8 = trunc i64 %7 to i32
  %scevgep86 = getelementptr double* %b, i64 %indvar81
  store double 0.000000e+00, double* %scevgep84, align 8, !tbaa !6
  store double 0.000000e+00, double* %scevgep85, align 8, !tbaa !6
  %9 = sitofp i32 %8 to double
  %10 = fdiv double %9, %0
  %11 = fmul double %10, 5.000000e-01
  %12 = fadd double %11, 4.000000e+00
  store double %12, double* %scevgep86, align 8, !tbaa !6
  %exitcond83 = icmp ne i64 %7, %2
  br i1 %exitcond83, label %6, label %.preheader8

.preheader7:                                      ; preds = %.preheader7.lr.ph, %polly.merge119
  %indvar69 = phi i64 [ 0, %.preheader7.lr.ph ], [ %21, %polly.merge119 ]
  %13 = mul i64 %indvar69, 16000
  %14 = mul i64 %indvar69, -1
  %15 = add i64 %5, %14
  %16 = trunc i64 %15 to i32
  %17 = zext i32 %16 to i64
  %18 = mul i64 %indvar69, 16008
  %i.128 = trunc i64 %indvar69 to i32
  %19 = mul i64 %indvar69, 2001
  %20 = add i64 %19, 1
  %21 = add i64 %indvar69, 1
  %j.124 = trunc i64 %21 to i32
  %scevgep80 = getelementptr [2000 x double]* %A, i64 0, i64 %19
  %22 = add i64 %17, 1
  %23 = icmp slt i32 %i.128, 0
  br i1 %23, label %.preheader6, label %polly.cond138

.preheader6:                                      ; preds = %polly.then143, %polly.loop_header145, %polly.cond138, %.preheader7
  %24 = icmp slt i32 %j.124, %n
  br i1 %24, label %polly.cond118, label %polly.merge119

polly.merge119:                                   ; preds = %polly.then123, %polly.loop_header125, %polly.cond118, %.preheader6
  store double 1.000000e+00, double* %scevgep80, align 8, !tbaa !6
  %exitcond77 = icmp ne i64 %21, %4
  br i1 %exitcond77, label %.preheader7, label %._crit_edge29

._crit_edge29:                                    ; preds = %polly.merge119, %.preheader8
  %25 = tail call i8* @polybench_alloc_data(i64 4000000, i32 8) #3
  br i1 %1, label %.preheader5.lr.ph, label %.preheader4

.preheader5.lr.ph:                                ; preds = %._crit_edge29
  %26 = zext i32 %n to i64
  %27 = sext i32 %n to i64
  %28 = icmp sge i64 %27, 1
  %29 = icmp sge i64 %26, 1
  %30 = and i1 %28, %29
  br i1 %30, label %polly.then, label %.preheader4

.preheader4:                                      ; preds = %polly.then, %polly.loop_exit90, %.preheader5.lr.ph, %._crit_edge29
  br i1 %1, label %.preheader3.lr.ph, label %.preheader1

.preheader3.lr.ph:                                ; preds = %.preheader4
  %31 = zext i32 %n to i64
  br label %.preheader3

.preheader3:                                      ; preds = %.preheader3.lr.ph, %._crit_edge16
  %indvar44 = phi i64 [ 0, %.preheader3.lr.ph ], [ %indvar.next45, %._crit_edge16 ]
  br i1 %1, label %.preheader2, label %._crit_edge16

.preheader1:                                      ; preds = %._crit_edge16, %.preheader4
  br i1 %1, label %.preheader.lr.ph, label %._crit_edge11

.preheader.lr.ph:                                 ; preds = %.preheader1
  %32 = zext i32 %n to i64
  br label %.preheader

.preheader2:                                      ; preds = %.preheader3, %._crit_edge14
  %indvar46 = phi i64 [ %indvar.next47, %._crit_edge14 ], [ 0, %.preheader3 ]
  %scevgep53 = getelementptr [2000 x double]* %A, i64 %indvar46, i64 %indvar44
  %33 = mul i64 %indvar46, 16000
  br i1 %1, label %.lr.ph13, label %._crit_edge14

.lr.ph13:                                         ; preds = %.preheader2, %.lr.ph13
  %indvar41 = phi i64 [ %indvar.next42, %.lr.ph13 ], [ 0, %.preheader2 ]
  %scevgep = getelementptr [2000 x double]* %A, i64 %indvar41, i64 %indvar44
  %34 = mul i64 %indvar41, 8
  %35 = add i64 %33, %34
  %scevgep51 = getelementptr i8* %25, i64 %35
  %scevgep4849 = bitcast i8* %scevgep51 to double*
  %36 = load double* %scevgep53, align 8, !tbaa !6
  %37 = load double* %scevgep, align 8, !tbaa !6
  %38 = fmul double %36, %37
  %39 = load double* %scevgep4849, align 8, !tbaa !6
  %40 = fadd double %39, %38
  store double %40, double* %scevgep4849, align 8, !tbaa !6
  %indvar.next42 = add i64 %indvar41, 1
  %exitcond43 = icmp ne i64 %indvar.next42, %31
  br i1 %exitcond43, label %.lr.ph13, label %._crit_edge14

._crit_edge14:                                    ; preds = %.lr.ph13, %.preheader2
  %indvar.next47 = add i64 %indvar46, 1
  %exitcond50 = icmp ne i64 %indvar.next47, %31
  br i1 %exitcond50, label %.preheader2, label %._crit_edge16

._crit_edge16:                                    ; preds = %._crit_edge14, %.preheader3
  %indvar.next45 = add i64 %indvar44, 1
  %exitcond54 = icmp ne i64 %indvar.next45, %31
  br i1 %exitcond54, label %.preheader3, label %.preheader1

.preheader:                                       ; preds = %.preheader.lr.ph, %._crit_edge
  %indvar33 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next34, %._crit_edge ]
  %41 = mul i64 %indvar33, 16000
  br i1 %1, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %.preheader, %.lr.ph
  %indvar = phi i64 [ %indvar.next, %.lr.ph ], [ 0, %.preheader ]
  %scevgep36 = getelementptr [2000 x double]* %A, i64 %indvar33, i64 %indvar
  %42 = mul i64 %indvar, 8
  %43 = add i64 %41, %42
  %scevgep39 = getelementptr i8* %25, i64 %43
  %scevgep35 = bitcast i8* %scevgep39 to double*
  %44 = load double* %scevgep35, align 8, !tbaa !6
  store double %44, double* %scevgep36, align 8, !tbaa !6
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %32
  br i1 %exitcond, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %.preheader
  %indvar.next34 = add i64 %indvar33, 1
  %exitcond37 = icmp ne i64 %indvar.next34, %32
  br i1 %exitcond37, label %.preheader, label %._crit_edge11

._crit_edge11:                                    ; preds = %._crit_edge, %.preheader1
  tail call void @free(i8* %25) #3
  ret void

polly.then:                                       ; preds = %.preheader5.lr.ph
  %45 = add i64 %26, -1
  %polly.loop_guard = icmp sle i64 0, %45
  br i1 %polly.loop_guard, label %polly.loop_header, label %.preheader4

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit90
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit90 ], [ 0, %polly.then ]
  %46 = mul i64 -11, %26
  %47 = add i64 %46, 5
  %48 = sub i64 %47, 32
  %49 = add i64 %48, 1
  %50 = icmp slt i64 %47, 0
  %51 = select i1 %50, i64 %49, i64 %47
  %52 = sdiv i64 %51, 32
  %53 = mul i64 -32, %52
  %54 = mul i64 -32, %26
  %55 = add i64 %53, %54
  %56 = mul i64 -32, %polly.indvar
  %57 = mul i64 -3, %polly.indvar
  %58 = add i64 %57, %26
  %59 = add i64 %58, 5
  %60 = sub i64 %59, 32
  %61 = add i64 %60, 1
  %62 = icmp slt i64 %59, 0
  %63 = select i1 %62, i64 %61, i64 %59
  %64 = sdiv i64 %63, 32
  %65 = mul i64 -32, %64
  %66 = add i64 %56, %65
  %67 = add i64 %66, -640
  %68 = icmp sgt i64 %55, %67
  %69 = select i1 %68, i64 %55, i64 %67
  %70 = mul i64 -20, %polly.indvar
  %polly.loop_guard91 = icmp sle i64 %69, %70
  br i1 %polly.loop_guard91, label %polly.loop_header88, label %polly.loop_exit90

polly.loop_exit90:                                ; preds = %polly.loop_exit99, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %45, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %.preheader4

polly.loop_header88:                              ; preds = %polly.loop_header, %polly.loop_exit99
  %polly.indvar92 = phi i64 [ %polly.indvar_next93, %polly.loop_exit99 ], [ %69, %polly.loop_header ]
  %71 = mul i64 -1, %polly.indvar92
  %72 = mul i64 -1, %26
  %73 = add i64 %71, %72
  %74 = add i64 %73, -30
  %75 = add i64 %74, 20
  %76 = sub i64 %75, 1
  %77 = icmp slt i64 %74, 0
  %78 = select i1 %77, i64 %74, i64 %76
  %79 = sdiv i64 %78, 20
  %80 = icmp sgt i64 %79, %polly.indvar
  %81 = select i1 %80, i64 %79, i64 %polly.indvar
  %82 = sub i64 %71, 20
  %83 = add i64 %82, 1
  %84 = icmp slt i64 %71, 0
  %85 = select i1 %84, i64 %83, i64 %71
  %86 = sdiv i64 %85, 20
  %87 = add i64 %polly.indvar, 31
  %88 = icmp slt i64 %86, %87
  %89 = select i1 %88, i64 %86, i64 %87
  %90 = icmp slt i64 %89, %45
  %91 = select i1 %90, i64 %89, i64 %45
  %polly.loop_guard100 = icmp sle i64 %81, %91
  br i1 %polly.loop_guard100, label %polly.loop_header97, label %polly.loop_exit99

polly.loop_exit99:                                ; preds = %polly.loop_exit108, %polly.loop_header88
  %polly.indvar_next93 = add nsw i64 %polly.indvar92, 32
  %polly.adjust_ub94 = sub i64 %70, 32
  %polly.loop_cond95 = icmp sle i64 %polly.indvar92, %polly.adjust_ub94
  br i1 %polly.loop_cond95, label %polly.loop_header88, label %polly.loop_exit90

polly.loop_header97:                              ; preds = %polly.loop_header88, %polly.loop_exit108
  %polly.indvar101 = phi i64 [ %polly.indvar_next102, %polly.loop_exit108 ], [ %81, %polly.loop_header88 ]
  %92 = mul i64 -20, %polly.indvar101
  %93 = add i64 %92, %72
  %94 = add i64 %93, 1
  %95 = icmp sgt i64 %polly.indvar92, %94
  %96 = select i1 %95, i64 %polly.indvar92, i64 %94
  %97 = add i64 %polly.indvar92, 31
  %98 = icmp slt i64 %92, %97
  %99 = select i1 %98, i64 %92, i64 %97
  %polly.loop_guard109 = icmp sle i64 %96, %99
  br i1 %polly.loop_guard109, label %polly.loop_header106, label %polly.loop_exit108

polly.loop_exit108:                               ; preds = %polly.loop_header106, %polly.loop_header97
  %polly.indvar_next102 = add nsw i64 %polly.indvar101, 1
  %polly.adjust_ub103 = sub i64 %91, 1
  %polly.loop_cond104 = icmp sle i64 %polly.indvar101, %polly.adjust_ub103
  br i1 %polly.loop_cond104, label %polly.loop_header97, label %polly.loop_exit99

polly.loop_header106:                             ; preds = %polly.loop_header97, %polly.loop_header106
  %polly.indvar110 = phi i64 [ %polly.indvar_next111, %polly.loop_header106 ], [ %96, %polly.loop_header97 ]
  %100 = mul i64 -1, %polly.indvar110
  %101 = add i64 %92, %100
  %p_.moved.to. = mul i64 %polly.indvar101, 16000
  %p_ = mul i64 %101, 8
  %p_114 = add i64 %p_.moved.to., %p_
  %p_scevgep65 = getelementptr i8* %25, i64 %p_114
  %p_scevgep6263 = bitcast i8* %p_scevgep65 to double*
  store double 0.000000e+00, double* %p_scevgep6263
  %p_indvar.next58 = add i64 %101, 1
  %polly.indvar_next111 = add nsw i64 %polly.indvar110, 1
  %polly.adjust_ub112 = sub i64 %99, 1
  %polly.loop_cond113 = icmp sle i64 %polly.indvar110, %polly.adjust_ub112
  br i1 %polly.loop_cond113, label %polly.loop_header106, label %polly.loop_exit108

polly.cond118:                                    ; preds = %.preheader6
  %102 = srem i64 %18, 8
  %103 = icmp eq i64 %102, 0
  br i1 %103, label %polly.then123, label %polly.merge119

polly.then123:                                    ; preds = %polly.cond118
  br i1 true, label %polly.loop_header125, label %polly.merge119

polly.loop_header125:                             ; preds = %polly.then123, %polly.loop_header125
  %polly.indvar129 = phi i64 [ %polly.indvar_next130, %polly.loop_header125 ], [ 0, %polly.then123 ]
  %p_134 = add i64 %20, %polly.indvar129
  %p_scevgep76 = getelementptr [2000 x double]* %A, i64 0, i64 %p_134
  store double 0.000000e+00, double* %p_scevgep76
  %p_indvar.next74 = add i64 %polly.indvar129, 1
  %polly.indvar_next130 = add nsw i64 %polly.indvar129, 1
  %polly.adjust_ub131 = sub i64 %17, 1
  %polly.loop_cond132 = icmp sle i64 %polly.indvar129, %polly.adjust_ub131
  br i1 %polly.loop_cond132, label %polly.loop_header125, label %polly.merge119

polly.cond138:                                    ; preds = %.preheader7
  %104 = srem i64 %13, 8
  %105 = icmp eq i64 %104, 0
  %106 = icmp sge i64 %indvar69, 0
  %or.cond162 = and i1 %105, %106
  br i1 %or.cond162, label %polly.then143, label %.preheader6

polly.then143:                                    ; preds = %polly.cond138
  br i1 %106, label %polly.loop_header145, label %.preheader6

polly.loop_header145:                             ; preds = %polly.then143, %polly.loop_header145
  %polly.indvar149 = phi i64 [ %polly.indvar_next150, %polly.loop_header145 ], [ 0, %polly.then143 ]
  %p_scevgep72 = getelementptr [2000 x double]* %A, i64 %indvar69, i64 %polly.indvar149
  %p_154 = mul i64 %polly.indvar149, -1
  %p_155 = trunc i64 %p_154 to i32
  %p_156 = srem i32 %p_155, %n
  %p_157 = sitofp i32 %p_156 to double
  %p_158 = fdiv double %p_157, %0
  %p_159 = fadd double %p_158, 1.000000e+00
  store double %p_159, double* %p_scevgep72
  %p_indvar.next68 = add i64 %polly.indvar149, 1
  %polly.indvar_next150 = add nsw i64 %polly.indvar149, 1
  %polly.adjust_ub151 = sub i64 %indvar69, 1
  %polly.loop_cond152 = icmp sle i64 %polly.indvar149, %polly.adjust_ub151
  br i1 %polly.loop_cond152, label %polly.loop_header145, label %.preheader6
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_ludcmp(i32 %n, [2000 x double]* %A, double* %b, double* %x, double* %y) #0 {
.split:
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.preheader3.lr.ph, label %.preheader1

.preheader3.lr.ph:                                ; preds = %.split
  %1 = add i32 %n, -1
  %2 = zext i32 %n to i64
  %3 = zext i32 %1 to i64
  br label %.preheader3

.preheader3:                                      ; preds = %.preheader3.lr.ph, %polly.merge
  %4 = phi i64 [ 0, %.preheader3.lr.ph ], [ %indvar.next72, %polly.merge ]
  %5 = trunc i64 %4 to i32
  %6 = mul i64 %4, -1
  %7 = add i64 %3, %6
  %8 = trunc i64 %7 to i32
  %9 = zext i32 %8 to i64
  %10 = mul i64 %4, 16008
  %11 = mul i64 %4, 2001
  %12 = add i64 %9, 1
  %13 = icmp sgt i32 %5, 0
  %14 = icmp sge i64 %4, 1
  %or.cond = and i1 %13, %14
  br i1 %or.cond, label %polly.stmt.272, label %.preheader2

.preheader1:                                      ; preds = %polly.merge, %.split
  br i1 %0, label %.lr.ph21, label %.preheader

.lr.ph21:                                         ; preds = %.preheader1
  %15 = zext i32 %n to i64
  br label %22

.preheader2:                                      ; preds = %polly.stmt.272, %polly.loop_exit295, %.preheader3
  %16 = icmp slt i32 %5, %n
  br i1 %16, label %.lr.ph37, label %polly.merge

.lr.ph37:                                         ; preds = %.preheader2
  br i1 true, label %polly.cond100, label %polly.merge

polly.merge:                                      ; preds = %polly.then251, %polly.loop_header253, %polly.cond249, %polly.cond246, %.lr.ph37, %.preheader2
  %indvar.next72 = add i64 %4, 1
  %exitcond89 = icmp ne i64 %indvar.next72, %2
  br i1 %exitcond89, label %.preheader3, label %.preheader1

.preheader:                                       ; preds = %31, %.preheader1
  br i1 %0, label %.lr.ph11, label %._crit_edge12

.lr.ph11:                                         ; preds = %.preheader
  %17 = zext i32 %n to i64
  %18 = sext i32 %n to i64
  %19 = mul i64 %18, 2001
  %20 = add i64 %18, -1
  %21 = add i64 %19, -1
  br label %32

; <label>:22                                      ; preds = %.lr.ph21, %31
  %23 = phi i64 [ 0, %.lr.ph21 ], [ %indvar.next58, %31 ]
  %i.120 = trunc i64 %23 to i32
  %scevgep64 = getelementptr double* %b, i64 %23
  %scevgep65 = getelementptr double* %y, i64 %23
  %24 = load double* %scevgep64, align 8, !tbaa !6
  %25 = icmp sgt i32 %i.120, 0
  br i1 %25, label %.lr.ph16, label %31

.lr.ph16:                                         ; preds = %22
  br label %26

; <label>:26                                      ; preds = %.lr.ph16, %26
  %w.214.reg2mem.0 = phi double [ %24, %.lr.ph16 ], [ %30, %26 ]
  %indvar55 = phi i64 [ 0, %.lr.ph16 ], [ %indvar.next56, %26 ]
  %scevgep60 = getelementptr [2000 x double]* %A, i64 %23, i64 %indvar55
  %scevgep61 = getelementptr double* %y, i64 %indvar55
  %27 = load double* %scevgep60, align 8, !tbaa !6
  %28 = load double* %scevgep61, align 8, !tbaa !6
  %29 = fmul double %27, %28
  %30 = fsub double %w.214.reg2mem.0, %29
  %indvar.next56 = add i64 %indvar55, 1
  %exitcond59 = icmp ne i64 %indvar.next56, %23
  br i1 %exitcond59, label %26, label %._crit_edge17

._crit_edge17:                                    ; preds = %26
  br label %31

; <label>:31                                      ; preds = %._crit_edge17, %22
  %w.2.lcssa.reg2mem.0 = phi double [ %30, %._crit_edge17 ], [ %24, %22 ]
  store double %w.2.lcssa.reg2mem.0, double* %scevgep65, align 8, !tbaa !6
  %indvar.next58 = add i64 %23, 1
  %exitcond62 = icmp ne i64 %indvar.next58, %15
  br i1 %exitcond62, label %22, label %.preheader

; <label>:32                                      ; preds = %.lr.ph11, %53
  %indvar46 = phi i64 [ 0, %.lr.ph11 ], [ %indvar.next47, %53 ]
  %33 = mul i64 %indvar46, -1
  %34 = add i64 %18, %33
  %35 = mul i64 %indvar46, -2001
  %36 = add i64 %19, %35
  %37 = add i64 %indvar46, -1
  %38 = trunc i64 %37 to i32
  %39 = add i64 %20, %33
  %scevgep52 = getelementptr double* %y, i64 %39
  %40 = add i64 %21, %35
  %scevgep53 = getelementptr [2000 x double]* %A, i64 -1, i64 %40
  %scevgep54 = getelementptr double* %x, i64 %39
  %41 = add i64 %17, %33
  %i.2.in9 = trunc i64 %41 to i32
  %42 = zext i32 %38 to i64
  %43 = add i64 %42, 1
  %44 = load double* %scevgep52, align 8, !tbaa !6
  %45 = icmp slt i32 %i.2.in9, %n
  br i1 %45, label %.lr.ph, label %53

.lr.ph:                                           ; preds = %32
  br label %46

; <label>:46                                      ; preds = %.lr.ph, %46
  %w.36.reg2mem.0 = phi double [ %44, %.lr.ph ], [ %52, %46 ]
  %indvar = phi i64 [ 0, %.lr.ph ], [ %indvar.next, %46 ]
  %47 = add i64 %34, %indvar
  %scevgep48 = getelementptr double* %x, i64 %47
  %48 = add i64 %36, %indvar
  %scevgep = getelementptr [2000 x double]* %A, i64 -1, i64 %48
  %49 = load double* %scevgep, align 8, !tbaa !6
  %50 = load double* %scevgep48, align 8, !tbaa !6
  %51 = fmul double %49, %50
  %52 = fsub double %w.36.reg2mem.0, %51
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %43
  br i1 %exitcond, label %46, label %._crit_edge

._crit_edge:                                      ; preds = %46
  br label %53

; <label>:53                                      ; preds = %._crit_edge, %32
  %w.3.lcssa.reg2mem.0 = phi double [ %52, %._crit_edge ], [ %44, %32 ]
  %54 = load double* %scevgep53, align 8, !tbaa !6
  %55 = fdiv double %w.3.lcssa.reg2mem.0, %54
  store double %55, double* %scevgep54, align 8, !tbaa !6
  %indvar.next47 = add i64 %indvar46, 1
  %exitcond49 = icmp ne i64 %indvar.next47, %17
  br i1 %exitcond49, label %32, label %._crit_edge12

._crit_edge12:                                    ; preds = %53, %.preheader
  ret void

polly.cond100:                                    ; preds = %.lr.ph37
  %56 = srem i64 %10, 8
  %57 = icmp eq i64 %56, 0
  br i1 %57, label %polly.cond103, label %polly.cond122

polly.cond122:                                    ; preds = %polly.then105, %polly.loop_exit109, %polly.cond103, %polly.cond100
  %58 = add i64 %10, 7
  %59 = srem i64 %58, 8
  %60 = icmp sle i64 %59, 6
  br i1 %60, label %polly.cond125, label %polly.cond166

polly.cond166:                                    ; preds = %polly.then127, %polly.loop_exit147, %polly.cond125, %polly.cond122
  br i1 %57, label %polly.cond169, label %polly.cond196

polly.cond196:                                    ; preds = %polly.then171, %polly.loop_header173, %polly.cond169, %polly.cond166
  br i1 %60, label %polly.cond199, label %polly.cond220

polly.cond220:                                    ; preds = %polly.then201, %polly.loop_header203, %polly.cond199, %polly.cond196
  br i1 %57, label %polly.cond223, label %polly.cond246

polly.cond246:                                    ; preds = %polly.then225, %polly.loop_header227, %polly.cond223, %polly.cond220
  br i1 %60, label %polly.cond249, label %polly.merge

polly.cond103:                                    ; preds = %polly.cond100
  %61 = sext i32 %5 to i64
  %62 = icmp sge i64 %61, 1
  %63 = and i1 %62, %14
  br i1 %63, label %polly.then105, label %polly.cond122

polly.then105:                                    ; preds = %polly.cond103
  br i1 true, label %polly.loop_header, label %polly.cond122

polly.loop_header:                                ; preds = %polly.then105, %polly.loop_exit109
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit109 ], [ 0, %polly.then105 ]
  %p_ = add i64 %11, %polly.indvar
  %p_scevgep88 = getelementptr [2000 x double]* %A, i64 0, i64 %p_
  %_p_scalar_ = load double* %p_scevgep88
  %64 = add i64 %4, -1
  %polly.loop_guard110 = icmp sle i64 0, %64
  br i1 %polly.loop_guard110, label %polly.loop_header107, label %polly.loop_exit109

polly.loop_exit109:                               ; preds = %polly.loop_header107, %polly.loop_header
  %w.131.reg2mem.0 = phi double [ %p_119, %polly.loop_header107 ], [ %_p_scalar_, %polly.loop_header ]
  store double %w.131.reg2mem.0, double* %p_scevgep88
  %p_indvar.next84 = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %9, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond122

polly.loop_header107:                             ; preds = %polly.loop_header, %polly.loop_header107
  %w.131.reg2mem.1 = phi double [ %_p_scalar_, %polly.loop_header ], [ %p_119, %polly.loop_header107 ]
  %polly.indvar111 = phi i64 [ %polly.indvar_next112, %polly.loop_header107 ], [ 0, %polly.loop_header ]
  %p_.moved.to.95 = add i64 %4, %polly.indvar
  %p_scevgep85 = getelementptr [2000 x double]* %A, i64 %polly.indvar111, i64 %p_.moved.to.95
  %p_scevgep82 = getelementptr [2000 x double]* %A, i64 %4, i64 %polly.indvar111
  %_p_scalar_116 = load double* %p_scevgep82
  %_p_scalar_117 = load double* %p_scevgep85
  %p_118 = fmul double %_p_scalar_116, %_p_scalar_117
  %p_119 = fsub double %w.131.reg2mem.1, %p_118
  %p_indvar.next80 = add i64 %polly.indvar111, 1
  %polly.indvar_next112 = add nsw i64 %polly.indvar111, 1
  %polly.adjust_ub113 = sub i64 %64, 1
  %polly.loop_cond114 = icmp sle i64 %polly.indvar111, %polly.adjust_ub113
  br i1 %polly.loop_cond114, label %polly.loop_header107, label %polly.loop_exit109

polly.cond125:                                    ; preds = %polly.cond122
  %65 = sext i32 %5 to i64
  %66 = icmp sge i64 %65, 1
  %67 = and i1 %66, %14
  br i1 %67, label %polly.then127, label %polly.cond166

polly.then127:                                    ; preds = %polly.cond125
  br i1 true, label %polly.loop_header129, label %polly.cond166

polly.loop_header129:                             ; preds = %polly.then127, %polly.loop_exit147
  %polly.indvar133 = phi i64 [ %polly.indvar_next134, %polly.loop_exit147 ], [ 0, %polly.then127 ]
  %p_139 = add i64 %11, %polly.indvar133
  %p_scevgep88140 = getelementptr [2000 x double]* %A, i64 0, i64 %p_139
  %_p_scalar_141 = load double* %p_scevgep88140
  %68 = add i64 %4, -1
  %polly.loop_guard148 = icmp sle i64 0, %68
  br i1 %polly.loop_guard148, label %polly.loop_header145, label %polly.loop_exit147

polly.loop_exit147:                               ; preds = %polly.loop_header145, %polly.loop_header129
  %polly.indvar_next134 = add nsw i64 %polly.indvar133, 1
  %polly.adjust_ub135 = sub i64 %9, 1
  %polly.loop_cond136 = icmp sle i64 %polly.indvar133, %polly.adjust_ub135
  br i1 %polly.loop_cond136, label %polly.loop_header129, label %polly.cond166

polly.loop_header145:                             ; preds = %polly.loop_header129, %polly.loop_header145
  %w.131.reg2mem.3 = phi double [ %_p_scalar_141, %polly.loop_header129 ], [ %p_161, %polly.loop_header145 ]
  %polly.indvar149 = phi i64 [ %polly.indvar_next150, %polly.loop_header145 ], [ 0, %polly.loop_header129 ]
  %p_.moved.to.95154 = add i64 %4, %polly.indvar133
  %p_scevgep85156 = getelementptr [2000 x double]* %A, i64 %polly.indvar149, i64 %p_.moved.to.95154
  %p_scevgep82157 = getelementptr [2000 x double]* %A, i64 %4, i64 %polly.indvar149
  %_p_scalar_158 = load double* %p_scevgep82157
  %_p_scalar_159 = load double* %p_scevgep85156
  %p_160 = fmul double %_p_scalar_158, %_p_scalar_159
  %p_161 = fsub double %w.131.reg2mem.3, %p_160
  %p_indvar.next80162 = add i64 %polly.indvar149, 1
  %polly.indvar_next150 = add nsw i64 %polly.indvar149, 1
  %polly.adjust_ub151 = sub i64 %68, 1
  %polly.loop_cond152 = icmp sle i64 %polly.indvar149, %polly.adjust_ub151
  br i1 %polly.loop_cond152, label %polly.loop_header145, label %polly.loop_exit147

polly.cond169:                                    ; preds = %polly.cond166
  %69 = sext i32 %5 to i64
  %70 = icmp sge i64 %69, 1
  %71 = icmp sle i64 %4, 0
  %72 = and i1 %70, %71
  br i1 %72, label %polly.then171, label %polly.cond196

polly.then171:                                    ; preds = %polly.cond169
  br i1 true, label %polly.loop_header173, label %polly.cond196

polly.loop_header173:                             ; preds = %polly.then171, %polly.loop_header173
  %polly.indvar177 = phi i64 [ %polly.indvar_next178, %polly.loop_header173 ], [ 0, %polly.then171 ]
  %p_183 = add i64 %11, %polly.indvar177
  %p_scevgep88184 = getelementptr [2000 x double]* %A, i64 0, i64 %p_183
  %_p_scalar_185 = load double* %p_scevgep88184
  store double %_p_scalar_185, double* %p_scevgep88184
  %p_indvar.next84194 = add i64 %polly.indvar177, 1
  %polly.indvar_next178 = add nsw i64 %polly.indvar177, 1
  %polly.adjust_ub179 = sub i64 %9, 1
  %polly.loop_cond180 = icmp sle i64 %polly.indvar177, %polly.adjust_ub179
  br i1 %polly.loop_cond180, label %polly.loop_header173, label %polly.cond196

polly.cond199:                                    ; preds = %polly.cond196
  %73 = sext i32 %5 to i64
  %74 = icmp sge i64 %73, 1
  %75 = icmp sle i64 %4, 0
  %76 = and i1 %74, %75
  br i1 %76, label %polly.then201, label %polly.cond220

polly.then201:                                    ; preds = %polly.cond199
  br i1 true, label %polly.loop_header203, label %polly.cond220

polly.loop_header203:                             ; preds = %polly.then201, %polly.loop_header203
  %polly.indvar207 = phi i64 [ %polly.indvar_next208, %polly.loop_header203 ], [ 0, %polly.then201 ]
  %p_213 = add i64 %11, %polly.indvar207
  %p_scevgep88214 = getelementptr [2000 x double]* %A, i64 0, i64 %p_213
  %polly.indvar_next208 = add nsw i64 %polly.indvar207, 1
  %polly.adjust_ub209 = sub i64 %9, 1
  %polly.loop_cond210 = icmp sle i64 %polly.indvar207, %polly.adjust_ub209
  br i1 %polly.loop_cond210, label %polly.loop_header203, label %polly.cond220

polly.cond223:                                    ; preds = %polly.cond220
  %77 = sext i32 %5 to i64
  %78 = icmp sle i64 %77, 0
  br i1 %78, label %polly.then225, label %polly.cond246

polly.then225:                                    ; preds = %polly.cond223
  br i1 true, label %polly.loop_header227, label %polly.cond246

polly.loop_header227:                             ; preds = %polly.then225, %polly.loop_header227
  %polly.indvar231 = phi i64 [ %polly.indvar_next232, %polly.loop_header227 ], [ 0, %polly.then225 ]
  %p_237 = add i64 %11, %polly.indvar231
  %p_scevgep88238 = getelementptr [2000 x double]* %A, i64 0, i64 %p_237
  %_p_scalar_239 = load double* %p_scevgep88238
  store double %_p_scalar_239, double* %p_scevgep88238
  %p_indvar.next84244 = add i64 %polly.indvar231, 1
  %polly.indvar_next232 = add nsw i64 %polly.indvar231, 1
  %polly.adjust_ub233 = sub i64 %9, 1
  %polly.loop_cond234 = icmp sle i64 %polly.indvar231, %polly.adjust_ub233
  br i1 %polly.loop_cond234, label %polly.loop_header227, label %polly.cond246

polly.cond249:                                    ; preds = %polly.cond246
  %79 = sext i32 %5 to i64
  %80 = icmp sle i64 %79, 0
  br i1 %80, label %polly.then251, label %polly.merge

polly.then251:                                    ; preds = %polly.cond249
  br i1 true, label %polly.loop_header253, label %polly.merge

polly.loop_header253:                             ; preds = %polly.then251, %polly.loop_header253
  %polly.indvar257 = phi i64 [ %polly.indvar_next258, %polly.loop_header253 ], [ 0, %polly.then251 ]
  %p_263 = add i64 %11, %polly.indvar257
  %p_scevgep88264 = getelementptr [2000 x double]* %A, i64 0, i64 %p_263
  %polly.indvar_next258 = add nsw i64 %polly.indvar257, 1
  %polly.adjust_ub259 = sub i64 %9, 1
  %polly.loop_cond260 = icmp sle i64 %polly.indvar257, %polly.adjust_ub259
  br i1 %polly.loop_cond260, label %polly.loop_header253, label %polly.merge

polly.stmt.272:                                   ; preds = %.preheader3
  %p_scevgep77 = getelementptr [2000 x double]* %A, i64 %4, i64 0
  %_p_scalar_273 = load double* %p_scevgep77
  %p_scevgep78.moved.to. = getelementptr [2000 x double]* %A, i64 0, i64 0
  %_p_scalar_276 = load double* %p_scevgep78.moved.to.
  %p_277 = fdiv double %_p_scalar_273, %_p_scalar_276
  store double %p_277, double* %p_scevgep77
  %81 = add i64 %4, -1
  %polly.loop_guard282 = icmp sle i64 1, %81
  br i1 %polly.loop_guard282, label %polly.loop_header279, label %.preheader2

polly.loop_header279:                             ; preds = %polly.stmt.272, %polly.loop_exit295
  %polly.indvar283 = phi i64 [ %polly.indvar_next284, %polly.loop_exit295 ], [ 1, %polly.stmt.272 ]
  %p_scevgep77288 = getelementptr [2000 x double]* %A, i64 %4, i64 %polly.indvar283
  %p_j.028289 = trunc i64 %polly.indvar283 to i32
  %_p_scalar_290 = load double* %p_scevgep77288
  %82 = add i64 %polly.indvar283, -1
  %polly.loop_guard296 = icmp sle i64 0, %82
  br i1 %polly.loop_guard296, label %polly.loop_header293, label %polly.loop_exit295

polly.loop_exit295:                               ; preds = %polly.loop_header293, %polly.loop_header279
  %w.023.reg2mem.0 = phi double [ %p_305, %polly.loop_header293 ], [ %_p_scalar_290, %polly.loop_header279 ]
  %p_.moved.to.97308 = mul i64 %polly.indvar283, 2001
  %p_scevgep78.moved.to.309 = getelementptr [2000 x double]* %A, i64 0, i64 %p_.moved.to.97308
  %_p_scalar_312 = load double* %p_scevgep78.moved.to.309
  %p_313 = fdiv double %w.023.reg2mem.0, %_p_scalar_312
  store double %p_313, double* %p_scevgep77288
  %p_indvar.next69314 = add i64 %polly.indvar283, 1
  %polly.indvar_next284 = add nsw i64 %polly.indvar283, 1
  %polly.adjust_ub285 = sub i64 %81, 1
  %polly.loop_cond286 = icmp sle i64 %polly.indvar283, %polly.adjust_ub285
  br i1 %polly.loop_cond286, label %polly.loop_header279, label %.preheader2

polly.loop_header293:                             ; preds = %polly.loop_header279, %polly.loop_header293
  %w.023.reg2mem.1 = phi double [ %_p_scalar_290, %polly.loop_header279 ], [ %p_305, %polly.loop_header293 ]
  %polly.indvar297 = phi i64 [ %polly.indvar_next298, %polly.loop_header293 ], [ 0, %polly.loop_header279 ]
  %p_scevgep73 = getelementptr [2000 x double]* %A, i64 %4, i64 %polly.indvar297
  %p_scevgep74 = getelementptr [2000 x double]* %A, i64 %polly.indvar297, i64 %polly.indvar283
  %_p_scalar_302 = load double* %p_scevgep73
  %_p_scalar_303 = load double* %p_scevgep74
  %p_304 = fmul double %_p_scalar_302, %_p_scalar_303
  %p_305 = fsub double %w.023.reg2mem.1, %p_304
  %p_indvar.next67 = add i64 %polly.indvar297, 1
  %polly.indvar_next298 = add nsw i64 %polly.indvar297, 1
  %polly.adjust_ub299 = sub i64 %82, 1
  %polly.loop_cond300 = icmp sle i64 %polly.indvar297, %polly.adjust_ub299
  br i1 %polly.loop_cond300, label %polly.loop_header293, label %polly.loop_exit295
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, double* %x) #0 {
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
  %scevgep = getelementptr double* %x, i64 %indvar
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
