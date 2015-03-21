; ModuleID = './linear-algebra/solvers/gramschmidt/gramschmidt.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [2 x i8] c"R\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [2 x i8] c"Q\00", align 1
@.str8 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %0 = tail call i8* @polybench_alloc_data(i64 1200000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 1440000, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 1200000, i32 8) #3
  %3 = bitcast i8* %0 to [1200 x double]*
  %4 = bitcast i8* %1 to [1200 x double]*
  %5 = bitcast i8* %2 to [1200 x double]*
  tail call void @init_array(i32 1000, i32 1200, [1200 x double]* %3, [1200 x double]* %4, [1200 x double]* %5)
  tail call void (...)* @polybench_timer_start() #3
  tail call void @kernel_gramschmidt(i32 1000, i32 1200, [1200 x double]* %3, [1200 x double]* %4, [1200 x double]* %5)
  tail call void (...)* @polybench_timer_stop() #3
  tail call void (...)* @polybench_timer_print() #3
  %6 = icmp sgt i32 %argc, 42
  br i1 %6, label %7, label %11

; <label>:7                                       ; preds = %.split
  %8 = load i8** %argv, align 8, !tbaa !1
  %9 = load i8* %8, align 1, !tbaa !5
  %phitmp = icmp eq i8 %9, 0
  br i1 %phitmp, label %10, label %11

; <label>:10                                      ; preds = %7
  tail call void @print_array(i32 1000, i32 1200, [1200 x double]* %3, [1200 x double]* %4, [1200 x double]* %5)
  br label %11

; <label>:11                                      ; preds = %7, %10, %.split
  tail call void @free(i8* %0) #3
  tail call void @free(i8* %1) #3
  tail call void @free(i8* %2) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %m, i32 %n, [1200 x double]* noalias %A, [1200 x double]* noalias %R, [1200 x double]* noalias %Q) #0 {
polly.split_new_and_old:
  %0 = zext i32 %m to i64
  %1 = zext i32 %n to i64
  %2 = sext i32 %n to i64
  %3 = icmp sge i64 %2, 1
  %4 = icmp sge i64 %1, 1
  %5 = and i1 %3, %4
  br i1 %5, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.then58, %polly.loop_exit71, %polly.cond56, %polly.split_new_and_old
  ret void

polly.then:                                       ; preds = %polly.split_new_and_old
  %6 = add i64 %1, -1
  %polly.loop_guard = icmp sle i64 0, %6
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond56

polly.cond56:                                     ; preds = %polly.then, %polly.loop_exit32
  %7 = sext i32 %m to i64
  %8 = icmp sge i64 %7, 1
  %9 = icmp sge i64 %0, 1
  %10 = and i1 %8, %9
  br i1 %10, label %polly.then58, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit32
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit32 ], [ 0, %polly.then ]
  %11 = mul i64 -11, %1
  %12 = add i64 %11, 5
  %13 = sub i64 %12, 32
  %14 = add i64 %13, 1
  %15 = icmp slt i64 %12, 0
  %16 = select i1 %15, i64 %14, i64 %12
  %17 = sdiv i64 %16, 32
  %18 = mul i64 -32, %17
  %19 = mul i64 -32, %1
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
  %polly.loop_guard33 = icmp sle i64 %34, %35
  br i1 %polly.loop_guard33, label %polly.loop_header30, label %polly.loop_exit32

polly.loop_exit32:                                ; preds = %polly.loop_exit41, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %6, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond56

polly.loop_header30:                              ; preds = %polly.loop_header, %polly.loop_exit41
  %polly.indvar34 = phi i64 [ %polly.indvar_next35, %polly.loop_exit41 ], [ %34, %polly.loop_header ]
  %36 = mul i64 -1, %polly.indvar34
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
  %55 = icmp slt i64 %54, %6
  %56 = select i1 %55, i64 %54, i64 %6
  %polly.loop_guard42 = icmp sle i64 %46, %56
  br i1 %polly.loop_guard42, label %polly.loop_header39, label %polly.loop_exit41

polly.loop_exit41:                                ; preds = %polly.loop_exit50, %polly.loop_header30
  %polly.indvar_next35 = add nsw i64 %polly.indvar34, 32
  %polly.adjust_ub36 = sub i64 %35, 32
  %polly.loop_cond37 = icmp sle i64 %polly.indvar34, %polly.adjust_ub36
  br i1 %polly.loop_cond37, label %polly.loop_header30, label %polly.loop_exit32

polly.loop_header39:                              ; preds = %polly.loop_header30, %polly.loop_exit50
  %polly.indvar43 = phi i64 [ %polly.indvar_next44, %polly.loop_exit50 ], [ %46, %polly.loop_header30 ]
  %57 = mul i64 -20, %polly.indvar43
  %58 = add i64 %57, %37
  %59 = add i64 %58, 1
  %60 = icmp sgt i64 %polly.indvar34, %59
  %61 = select i1 %60, i64 %polly.indvar34, i64 %59
  %62 = add i64 %polly.indvar34, 31
  %63 = icmp slt i64 %57, %62
  %64 = select i1 %63, i64 %57, i64 %62
  %polly.loop_guard51 = icmp sle i64 %61, %64
  br i1 %polly.loop_guard51, label %polly.loop_header48, label %polly.loop_exit50

polly.loop_exit50:                                ; preds = %polly.loop_header48, %polly.loop_header39
  %polly.indvar_next44 = add nsw i64 %polly.indvar43, 1
  %polly.adjust_ub45 = sub i64 %56, 1
  %polly.loop_cond46 = icmp sle i64 %polly.indvar43, %polly.adjust_ub45
  br i1 %polly.loop_cond46, label %polly.loop_header39, label %polly.loop_exit41

polly.loop_header48:                              ; preds = %polly.loop_header39, %polly.loop_header48
  %polly.indvar52 = phi i64 [ %polly.indvar_next53, %polly.loop_header48 ], [ %61, %polly.loop_header39 ]
  %65 = mul i64 -1, %polly.indvar52
  %66 = add i64 %57, %65
  %p_scevgep = getelementptr [1200 x double]* %R, i64 %polly.indvar43, i64 %66
  store double 0.000000e+00, double* %p_scevgep
  %p_indvar.next = add i64 %66, 1
  %polly.indvar_next53 = add nsw i64 %polly.indvar52, 1
  %polly.adjust_ub54 = sub i64 %64, 1
  %polly.loop_cond55 = icmp sle i64 %polly.indvar52, %polly.adjust_ub54
  br i1 %polly.loop_cond55, label %polly.loop_header48, label %polly.loop_exit50

polly.then58:                                     ; preds = %polly.cond56
  %67 = add i64 %0, -1
  %polly.loop_guard63 = icmp sle i64 0, %67
  br i1 %polly.loop_guard63, label %polly.loop_header60, label %polly.merge

polly.loop_header60:                              ; preds = %polly.then58, %polly.loop_exit71
  %polly.indvar64 = phi i64 [ %polly.indvar_next65, %polly.loop_exit71 ], [ 0, %polly.then58 ]
  %68 = mul i64 -3, %0
  %69 = add i64 %68, %1
  %70 = add i64 %69, 5
  %71 = sub i64 %70, 32
  %72 = add i64 %71, 1
  %73 = icmp slt i64 %70, 0
  %74 = select i1 %73, i64 %72, i64 %70
  %75 = sdiv i64 %74, 32
  %76 = mul i64 -32, %75
  %77 = mul i64 -32, %0
  %78 = add i64 %76, %77
  %79 = mul i64 -32, %polly.indvar64
  %80 = mul i64 -3, %polly.indvar64
  %81 = add i64 %80, %1
  %82 = add i64 %81, 5
  %83 = sub i64 %82, 32
  %84 = add i64 %83, 1
  %85 = icmp slt i64 %82, 0
  %86 = select i1 %85, i64 %84, i64 %82
  %87 = sdiv i64 %86, 32
  %88 = mul i64 -32, %87
  %89 = add i64 %79, %88
  %90 = add i64 %89, -640
  %91 = icmp sgt i64 %78, %90
  %92 = select i1 %91, i64 %78, i64 %90
  %93 = mul i64 -20, %polly.indvar64
  %polly.loop_guard72 = icmp sle i64 %92, %93
  br i1 %polly.loop_guard72, label %polly.loop_header69, label %polly.loop_exit71

polly.loop_exit71:                                ; preds = %polly.loop_exit80, %polly.loop_header60
  %polly.indvar_next65 = add nsw i64 %polly.indvar64, 32
  %polly.adjust_ub66 = sub i64 %67, 32
  %polly.loop_cond67 = icmp sle i64 %polly.indvar64, %polly.adjust_ub66
  br i1 %polly.loop_cond67, label %polly.loop_header60, label %polly.merge

polly.loop_header69:                              ; preds = %polly.loop_header60, %polly.loop_exit80
  %polly.indvar73 = phi i64 [ %polly.indvar_next74, %polly.loop_exit80 ], [ %92, %polly.loop_header60 ]
  %94 = mul i64 -1, %polly.indvar73
  %95 = mul i64 -1, %1
  %96 = add i64 %94, %95
  %97 = add i64 %96, -30
  %98 = add i64 %97, 20
  %99 = sub i64 %98, 1
  %100 = icmp slt i64 %97, 0
  %101 = select i1 %100, i64 %97, i64 %99
  %102 = sdiv i64 %101, 20
  %103 = icmp sgt i64 %102, %polly.indvar64
  %104 = select i1 %103, i64 %102, i64 %polly.indvar64
  %105 = sub i64 %94, 20
  %106 = add i64 %105, 1
  %107 = icmp slt i64 %94, 0
  %108 = select i1 %107, i64 %106, i64 %94
  %109 = sdiv i64 %108, 20
  %110 = add i64 %polly.indvar64, 31
  %111 = icmp slt i64 %109, %110
  %112 = select i1 %111, i64 %109, i64 %110
  %113 = icmp slt i64 %112, %67
  %114 = select i1 %113, i64 %112, i64 %67
  %polly.loop_guard81 = icmp sle i64 %104, %114
  br i1 %polly.loop_guard81, label %polly.loop_header78, label %polly.loop_exit80

polly.loop_exit80:                                ; preds = %polly.loop_exit89, %polly.loop_header69
  %polly.indvar_next74 = add nsw i64 %polly.indvar73, 32
  %polly.adjust_ub75 = sub i64 %93, 32
  %polly.loop_cond76 = icmp sle i64 %polly.indvar73, %polly.adjust_ub75
  br i1 %polly.loop_cond76, label %polly.loop_header69, label %polly.loop_exit71

polly.loop_header78:                              ; preds = %polly.loop_header69, %polly.loop_exit89
  %polly.indvar82 = phi i64 [ %polly.indvar_next83, %polly.loop_exit89 ], [ %104, %polly.loop_header69 ]
  %115 = mul i64 -20, %polly.indvar82
  %116 = add i64 %115, %95
  %117 = add i64 %116, 1
  %118 = icmp sgt i64 %polly.indvar73, %117
  %119 = select i1 %118, i64 %polly.indvar73, i64 %117
  %120 = add i64 %polly.indvar73, 31
  %121 = icmp slt i64 %115, %120
  %122 = select i1 %121, i64 %115, i64 %120
  %polly.loop_guard90 = icmp sle i64 %119, %122
  br i1 %polly.loop_guard90, label %polly.loop_header87, label %polly.loop_exit89

polly.loop_exit89:                                ; preds = %polly.loop_header87, %polly.loop_header78
  %polly.indvar_next83 = add nsw i64 %polly.indvar82, 1
  %polly.adjust_ub84 = sub i64 %114, 1
  %polly.loop_cond85 = icmp sle i64 %polly.indvar82, %polly.adjust_ub84
  br i1 %polly.loop_cond85, label %polly.loop_header78, label %polly.loop_exit80

polly.loop_header87:                              ; preds = %polly.loop_header78, %polly.loop_header87
  %polly.indvar91 = phi i64 [ %polly.indvar_next92, %polly.loop_header87 ], [ %119, %polly.loop_header78 ]
  %123 = mul i64 -1, %polly.indvar91
  %124 = add i64 %115, %123
  %p_.moved.to. = sitofp i32 %m to double
  %p_scevgep21 = getelementptr [1200 x double]* %Q, i64 %polly.indvar82, i64 %124
  %p_scevgep20 = getelementptr [1200 x double]* %A, i64 %polly.indvar82, i64 %124
  %p_ = mul i64 %polly.indvar82, %124
  %p_96 = trunc i64 %p_ to i32
  %p_97 = srem i32 %p_96, %m
  %p_98 = sitofp i32 %p_97 to double
  %p_99 = fdiv double %p_98, %p_.moved.to.
  %p_100 = fmul double %p_99, 1.000000e+02
  %p_101 = fadd double %p_100, 1.000000e+01
  store double %p_101, double* %p_scevgep20
  store double 0.000000e+00, double* %p_scevgep21
  %p_indvar.next16 = add i64 %124, 1
  %polly.indvar_next92 = add nsw i64 %polly.indvar91, 1
  %polly.adjust_ub93 = sub i64 %122, 1
  %polly.loop_cond94 = icmp sle i64 %polly.indvar91, %polly.adjust_ub93
  br i1 %polly.loop_cond94, label %polly.loop_header87, label %polly.loop_exit89
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_gramschmidt(i32 %m, i32 %n, [1200 x double]* noalias %A, [1200 x double]* noalias %R, [1200 x double]* noalias %Q) #0 {
.split:
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.preheader2.lr.ph, label %._crit_edge18

.preheader2.lr.ph:                                ; preds = %.split
  %1 = zext i32 %m to i64
  %2 = add i32 %n, -2
  %3 = zext i32 %n to i64
  %4 = zext i32 %2 to i64
  %5 = icmp sgt i32 %m, 0
  br label %.preheader2

.preheader2:                                      ; preds = %.preheader2.lr.ph, %polly.merge
  %indvar19 = phi i64 [ 0, %.preheader2.lr.ph ], [ %14, %polly.merge ]
  %6 = mul i64 %indvar19, 8
  %7 = mul i64 %indvar19, -1
  %8 = add i64 %4, %7
  %9 = trunc i64 %8 to i32
  %10 = zext i32 %9 to i64
  %11 = mul i64 %indvar19, 9608
  %12 = mul i64 %indvar19, 1201
  %13 = add i64 %12, 1
  %14 = add i64 %indvar19, 1
  %j.013 = trunc i64 %14 to i32
  %scevgep52 = getelementptr [1200 x double]* %R, i64 0, i64 %12
  br i1 %5, label %.lr.ph, label %16

.lr.ph:                                           ; preds = %.preheader2
  %15 = icmp sge i64 %1, 1
  br i1 %15, label %polly.then346, label %polly.stmt.._crit_edge

; <label>:16                                      ; preds = %polly.stmt.._crit_edge, %.preheader2
  %nrm.0.lcssa.reg2mem.0 = phi double [ %nrm.04.reg2mem.0, %polly.stmt.._crit_edge ], [ 0.000000e+00, %.preheader2 ]
  %17 = tail call double @sqrt(double %nrm.0.lcssa.reg2mem.0) #3
  store double %17, double* %scevgep52, align 8, !tbaa !6
  br i1 %5, label %.lr.ph7, label %.preheader1

.lr.ph7:                                          ; preds = %16
  %18 = srem i64 %6, 8
  %19 = icmp eq i64 %18, 0
  %20 = icmp sge i64 %1, 1
  %or.cond376 = and i1 %19, %20
  br i1 %or.cond376, label %polly.then328, label %.preheader1

.preheader1:                                      ; preds = %polly.then328, %polly.loop_header330, %.lr.ph7, %16
  %21 = icmp slt i32 %j.013, %n
  br i1 %21, label %polly.cond55, label %polly.merge

polly.merge:                                      ; preds = %polly.then302, %polly.loop_header304, %polly.cond297, %polly.cond58, %.preheader1
  %exitcond43 = icmp ne i64 %14, %3
  br i1 %exitcond43, label %.preheader2, label %._crit_edge18

._crit_edge18:                                    ; preds = %polly.merge, %.split
  ret void

polly.cond55:                                     ; preds = %.preheader1
  %22 = srem i64 %11, 8
  %23 = icmp eq i64 %22, 0
  br i1 %23, label %polly.then57, label %polly.cond58

polly.cond58:                                     ; preds = %polly.then57, %polly.loop_header, %polly.cond55
  %24 = sext i32 %m to i64
  %25 = icmp sge i64 %24, 1
  br i1 %25, label %polly.cond61, label %polly.merge

polly.then57:                                     ; preds = %polly.cond55
  br i1 true, label %polly.loop_header, label %polly.cond58

polly.loop_header:                                ; preds = %polly.then57, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then57 ]
  %p_ = add i64 %13, %polly.indvar
  %p_scevgep42 = getelementptr [1200 x double]* %R, i64 0, i64 %p_
  store double 0.000000e+00, double* %p_scevgep42
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %10, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond58

polly.cond61:                                     ; preds = %polly.cond58
  %26 = srem i64 %6, 8
  %27 = icmp eq i64 %26, 0
  br i1 %27, label %polly.cond64, label %polly.cond108

polly.cond108:                                    ; preds = %polly.then69, %polly.loop_exit97, %polly.cond64, %polly.cond61
  br i1 %23, label %polly.cond111, label %polly.cond158

polly.cond158:                                    ; preds = %polly.then116, %polly.loop_exit133, %polly.cond111, %polly.cond108
  br i1 %27, label %polly.cond161, label %polly.cond224

polly.cond224:                                    ; preds = %polly.then166, %polly.loop_exit207, %polly.cond161, %polly.cond158
  %28 = add i64 %6, 7
  %29 = srem i64 %28, 8
  %30 = icmp sle i64 %29, 6
  br i1 %30, label %polly.cond227, label %polly.cond270

polly.cond270:                                    ; preds = %polly.then232, %polly.loop_exit249, %polly.cond227, %polly.cond224
  %31 = icmp sle i64 %1, 0
  %or.cond372 = and i1 %23, %31
  br i1 %or.cond372, label %polly.then275, label %polly.cond297

polly.cond297:                                    ; preds = %polly.then275, %polly.loop_header277, %polly.cond270
  %32 = add i64 %11, 7
  %33 = srem i64 %32, 8
  %34 = icmp sle i64 %33, 6
  %or.cond374 = and i1 %34, %31
  br i1 %or.cond374, label %polly.then302, label %polly.merge

polly.cond64:                                     ; preds = %polly.cond61
  %35 = icmp sge i64 %1, 1
  %or.cond364 = and i1 %23, %35
  br i1 %or.cond364, label %polly.then69, label %polly.cond108

polly.then69:                                     ; preds = %polly.cond64
  br i1 true, label %polly.loop_header71, label %polly.cond108

polly.loop_header71:                              ; preds = %polly.then69, %polly.loop_exit97
  %polly.indvar75 = phi i64 [ %polly.indvar_next76, %polly.loop_exit97 ], [ 0, %polly.then69 ]
  %p_.moved.to..lr.ph10 = add i64 %13, %polly.indvar75
  %p_scevgep42.moved.to..lr.ph10 = getelementptr [1200 x double]* %R, i64 0, i64 %p_.moved.to..lr.ph10
  %.promoted_p_scalar_ = load double* %p_scevgep42.moved.to..lr.ph10
  %36 = add i64 %1, -1
  %polly.loop_guard83 = icmp sle i64 0, %36
  br i1 %polly.loop_guard83, label %polly.loop_header80, label %polly.loop_exit82

polly.loop_exit82:                                ; preds = %polly.loop_header80, %polly.loop_header71
  %.reg2mem.0 = phi double [ %p_91, %polly.loop_header80 ], [ %.promoted_p_scalar_, %polly.loop_header71 ]
  store double %.reg2mem.0, double* %p_scevgep42.moved.to..lr.ph10
  br i1 %polly.loop_guard83, label %polly.loop_header95, label %polly.loop_exit97

polly.loop_exit97:                                ; preds = %polly.loop_header95, %polly.loop_exit82
  %polly.indvar_next76 = add nsw i64 %polly.indvar75, 1
  %polly.adjust_ub77 = sub i64 %10, 1
  %polly.loop_cond78 = icmp sle i64 %polly.indvar75, %polly.adjust_ub77
  br i1 %polly.loop_cond78, label %polly.loop_header71, label %polly.cond108

polly.loop_header80:                              ; preds = %polly.loop_header71, %polly.loop_header80
  %.reg2mem.1 = phi double [ %.promoted_p_scalar_, %polly.loop_header71 ], [ %p_91, %polly.loop_header80 ]
  %polly.indvar84 = phi i64 [ %polly.indvar_next85, %polly.loop_header80 ], [ 0, %polly.loop_header71 ]
  %p_.moved.to.53 = add i64 %14, %polly.indvar75
  %p_scevgep32 = getelementptr [1200 x double]* %A, i64 %polly.indvar84, i64 %p_.moved.to.53
  %p_scevgep29 = getelementptr [1200 x double]* %Q, i64 %polly.indvar84, i64 %indvar19
  %_p_scalar_ = load double* %p_scevgep29
  %_p_scalar_89 = load double* %p_scevgep32
  %p_90 = fmul double %_p_scalar_, %_p_scalar_89
  %p_91 = fadd double %.reg2mem.1, %p_90
  %p_indvar.next27 = add i64 %polly.indvar84, 1
  %polly.indvar_next85 = add nsw i64 %polly.indvar84, 1
  %polly.adjust_ub86 = sub i64 %36, 1
  %polly.loop_cond87 = icmp sle i64 %polly.indvar84, %polly.adjust_ub86
  br i1 %polly.loop_cond87, label %polly.loop_header80, label %polly.loop_exit82

polly.loop_header95:                              ; preds = %polly.loop_exit82, %polly.loop_header95
  %polly.indvar99 = phi i64 [ %polly.indvar_next100, %polly.loop_header95 ], [ 0, %polly.loop_exit82 ]
  %p_.moved.to.54 = add i64 %14, %polly.indvar75
  %p_scevgep37 = getelementptr [1200 x double]* %A, i64 %polly.indvar99, i64 %p_.moved.to.54
  %p_scevgep38 = getelementptr [1200 x double]* %Q, i64 %polly.indvar99, i64 %indvar19
  %_p_scalar_104 = load double* %p_scevgep37
  %_p_scalar_105 = load double* %p_scevgep38
  %p_106 = fmul double %_p_scalar_105, %.reg2mem.0
  %p_107 = fsub double %_p_scalar_104, %p_106
  store double %p_107, double* %p_scevgep37
  %p_indvar.next35 = add i64 %polly.indvar99, 1
  %polly.indvar_next100 = add nsw i64 %polly.indvar99, 1
  %polly.adjust_ub101 = sub i64 %36, 1
  %polly.loop_cond102 = icmp sle i64 %polly.indvar99, %polly.adjust_ub101
  br i1 %polly.loop_cond102, label %polly.loop_header95, label %polly.loop_exit97

polly.cond111:                                    ; preds = %polly.cond108
  %37 = add i64 %6, 7
  %38 = srem i64 %37, 8
  %39 = icmp sle i64 %38, 6
  %40 = icmp sge i64 %1, 1
  %or.cond366 = and i1 %39, %40
  br i1 %or.cond366, label %polly.then116, label %polly.cond158

polly.then116:                                    ; preds = %polly.cond111
  br i1 true, label %polly.loop_header118, label %polly.cond158

polly.loop_header118:                             ; preds = %polly.then116, %polly.loop_exit133
  %polly.indvar122 = phi i64 [ %polly.indvar_next123, %polly.loop_exit133 ], [ 0, %polly.then116 ]
  %p_.moved.to..lr.ph10127 = add i64 %13, %polly.indvar122
  %p_scevgep42.moved.to..lr.ph10128 = getelementptr [1200 x double]* %R, i64 0, i64 %p_.moved.to..lr.ph10127
  %.promoted_p_scalar_129 = load double* %p_scevgep42.moved.to..lr.ph10128
  %41 = add i64 %1, -1
  %polly.loop_guard134 = icmp sle i64 0, %41
  br i1 %polly.loop_guard134, label %polly.loop_header131, label %polly.loop_exit133

polly.loop_exit133:                               ; preds = %polly.loop_header131, %polly.loop_header118
  %.reg2mem.2 = phi double [ %p_147, %polly.loop_header131 ], [ %.promoted_p_scalar_129, %polly.loop_header118 ]
  store double %.reg2mem.2, double* %p_scevgep42.moved.to..lr.ph10128
  %polly.indvar_next123 = add nsw i64 %polly.indvar122, 1
  %polly.adjust_ub124 = sub i64 %10, 1
  %polly.loop_cond125 = icmp sle i64 %polly.indvar122, %polly.adjust_ub124
  br i1 %polly.loop_cond125, label %polly.loop_header118, label %polly.cond158

polly.loop_header131:                             ; preds = %polly.loop_header118, %polly.loop_header131
  %.reg2mem.3 = phi double [ %.promoted_p_scalar_129, %polly.loop_header118 ], [ %p_147, %polly.loop_header131 ]
  %polly.indvar135 = phi i64 [ %polly.indvar_next136, %polly.loop_header131 ], [ 0, %polly.loop_header118 ]
  %p_.moved.to.53140 = add i64 %14, %polly.indvar122
  %p_scevgep32142 = getelementptr [1200 x double]* %A, i64 %polly.indvar135, i64 %p_.moved.to.53140
  %p_scevgep29143 = getelementptr [1200 x double]* %Q, i64 %polly.indvar135, i64 %indvar19
  %_p_scalar_144 = load double* %p_scevgep29143
  %_p_scalar_145 = load double* %p_scevgep32142
  %p_146 = fmul double %_p_scalar_144, %_p_scalar_145
  %p_147 = fadd double %.reg2mem.3, %p_146
  %p_indvar.next27148 = add i64 %polly.indvar135, 1
  %polly.indvar_next136 = add nsw i64 %polly.indvar135, 1
  %polly.adjust_ub137 = sub i64 %41, 1
  %polly.loop_cond138 = icmp sle i64 %polly.indvar135, %polly.adjust_ub137
  br i1 %polly.loop_cond138, label %polly.loop_header131, label %polly.loop_exit133

polly.cond161:                                    ; preds = %polly.cond158
  %42 = add i64 %11, 7
  %43 = srem i64 %42, 8
  %44 = icmp sle i64 %43, 6
  %45 = icmp sge i64 %1, 1
  %or.cond368 = and i1 %44, %45
  br i1 %or.cond368, label %polly.then166, label %polly.cond224

polly.then166:                                    ; preds = %polly.cond161
  br i1 true, label %polly.loop_header168, label %polly.cond224

polly.loop_header168:                             ; preds = %polly.then166, %polly.loop_exit207
  %polly.indvar172 = phi i64 [ %polly.indvar_next173, %polly.loop_exit207 ], [ 0, %polly.then166 ]
  %p_.moved.to..lr.ph10177 = add i64 %13, %polly.indvar172
  %p_scevgep42.moved.to..lr.ph10178 = getelementptr [1200 x double]* %R, i64 0, i64 %p_.moved.to..lr.ph10177
  %.promoted_p_scalar_179 = load double* %p_scevgep42.moved.to..lr.ph10178
  %46 = add i64 %1, -1
  %polly.loop_guard184 = icmp sle i64 0, %46
  br i1 %polly.loop_guard184, label %polly.loop_header181, label %polly.loop_exit183

polly.loop_exit183:                               ; preds = %polly.loop_header181, %polly.loop_header168
  %_p_scalar_203 = load double* %p_scevgep42.moved.to..lr.ph10178
  br i1 %polly.loop_guard184, label %polly.loop_header205, label %polly.loop_exit207

polly.loop_exit207:                               ; preds = %polly.loop_header205, %polly.loop_exit183
  %polly.indvar_next173 = add nsw i64 %polly.indvar172, 1
  %polly.adjust_ub174 = sub i64 %10, 1
  %polly.loop_cond175 = icmp sle i64 %polly.indvar172, %polly.adjust_ub174
  br i1 %polly.loop_cond175, label %polly.loop_header168, label %polly.cond224

polly.loop_header181:                             ; preds = %polly.loop_header168, %polly.loop_header181
  %.reg2mem.4 = phi double [ %.promoted_p_scalar_179, %polly.loop_header168 ], [ %p_197, %polly.loop_header181 ]
  %polly.indvar185 = phi i64 [ %polly.indvar_next186, %polly.loop_header181 ], [ 0, %polly.loop_header168 ]
  %p_.moved.to.53190 = add i64 %14, %polly.indvar172
  %p_scevgep32192 = getelementptr [1200 x double]* %A, i64 %polly.indvar185, i64 %p_.moved.to.53190
  %p_scevgep29193 = getelementptr [1200 x double]* %Q, i64 %polly.indvar185, i64 %indvar19
  %_p_scalar_194 = load double* %p_scevgep29193
  %_p_scalar_195 = load double* %p_scevgep32192
  %p_196 = fmul double %_p_scalar_194, %_p_scalar_195
  %p_197 = fadd double %.reg2mem.4, %p_196
  %p_indvar.next27198 = add i64 %polly.indvar185, 1
  %polly.indvar_next186 = add nsw i64 %polly.indvar185, 1
  %polly.adjust_ub187 = sub i64 %46, 1
  %polly.loop_cond188 = icmp sle i64 %polly.indvar185, %polly.adjust_ub187
  br i1 %polly.loop_cond188, label %polly.loop_header181, label %polly.loop_exit183

polly.loop_header205:                             ; preds = %polly.loop_exit183, %polly.loop_header205
  %polly.indvar209 = phi i64 [ %polly.indvar_next210, %polly.loop_header205 ], [ 0, %polly.loop_exit183 ]
  %p_.moved.to.54214 = add i64 %14, %polly.indvar172
  %p_scevgep37215 = getelementptr [1200 x double]* %A, i64 %polly.indvar209, i64 %p_.moved.to.54214
  %p_scevgep38216 = getelementptr [1200 x double]* %Q, i64 %polly.indvar209, i64 %indvar19
  %_p_scalar_217 = load double* %p_scevgep37215
  %_p_scalar_218 = load double* %p_scevgep38216
  %p_220 = fmul double %_p_scalar_218, %_p_scalar_203
  %p_221 = fsub double %_p_scalar_217, %p_220
  store double %p_221, double* %p_scevgep37215
  %p_indvar.next35222 = add i64 %polly.indvar209, 1
  %polly.indvar_next210 = add nsw i64 %polly.indvar209, 1
  %polly.adjust_ub211 = sub i64 %46, 1
  %polly.loop_cond212 = icmp sle i64 %polly.indvar209, %polly.adjust_ub211
  br i1 %polly.loop_cond212, label %polly.loop_header205, label %polly.loop_exit207

polly.cond227:                                    ; preds = %polly.cond224
  %47 = add i64 %11, 7
  %48 = srem i64 %47, 8
  %49 = icmp sle i64 %48, 6
  %50 = icmp sge i64 %1, 1
  %or.cond370 = and i1 %49, %50
  br i1 %or.cond370, label %polly.then232, label %polly.cond270

polly.then232:                                    ; preds = %polly.cond227
  br i1 true, label %polly.loop_header234, label %polly.cond270

polly.loop_header234:                             ; preds = %polly.then232, %polly.loop_exit249
  %polly.indvar238 = phi i64 [ %polly.indvar_next239, %polly.loop_exit249 ], [ 0, %polly.then232 ]
  %p_.moved.to..lr.ph10243 = add i64 %13, %polly.indvar238
  %p_scevgep42.moved.to..lr.ph10244 = getelementptr [1200 x double]* %R, i64 0, i64 %p_.moved.to..lr.ph10243
  %.promoted_p_scalar_245 = load double* %p_scevgep42.moved.to..lr.ph10244
  %51 = add i64 %1, -1
  %polly.loop_guard250 = icmp sle i64 0, %51
  br i1 %polly.loop_guard250, label %polly.loop_header247, label %polly.loop_exit249

polly.loop_exit249:                               ; preds = %polly.loop_header247, %polly.loop_header234
  %polly.indvar_next239 = add nsw i64 %polly.indvar238, 1
  %polly.adjust_ub240 = sub i64 %10, 1
  %polly.loop_cond241 = icmp sle i64 %polly.indvar238, %polly.adjust_ub240
  br i1 %polly.loop_cond241, label %polly.loop_header234, label %polly.cond270

polly.loop_header247:                             ; preds = %polly.loop_header234, %polly.loop_header247
  %.reg2mem.5 = phi double [ %.promoted_p_scalar_245, %polly.loop_header234 ], [ %p_263, %polly.loop_header247 ]
  %polly.indvar251 = phi i64 [ %polly.indvar_next252, %polly.loop_header247 ], [ 0, %polly.loop_header234 ]
  %p_.moved.to.53256 = add i64 %14, %polly.indvar238
  %p_scevgep32258 = getelementptr [1200 x double]* %A, i64 %polly.indvar251, i64 %p_.moved.to.53256
  %p_scevgep29259 = getelementptr [1200 x double]* %Q, i64 %polly.indvar251, i64 %indvar19
  %_p_scalar_260 = load double* %p_scevgep29259
  %_p_scalar_261 = load double* %p_scevgep32258
  %p_262 = fmul double %_p_scalar_260, %_p_scalar_261
  %p_263 = fadd double %.reg2mem.5, %p_262
  %p_indvar.next27264 = add i64 %polly.indvar251, 1
  %polly.indvar_next252 = add nsw i64 %polly.indvar251, 1
  %polly.adjust_ub253 = sub i64 %51, 1
  %polly.loop_cond254 = icmp sle i64 %polly.indvar251, %polly.adjust_ub253
  br i1 %polly.loop_cond254, label %polly.loop_header247, label %polly.loop_exit249

polly.then275:                                    ; preds = %polly.cond270
  br i1 true, label %polly.loop_header277, label %polly.cond297

polly.loop_header277:                             ; preds = %polly.then275, %polly.loop_header277
  %polly.indvar281 = phi i64 [ %polly.indvar_next282, %polly.loop_header277 ], [ 0, %polly.then275 ]
  %p_.moved.to..lr.ph10286 = add i64 %13, %polly.indvar281
  %p_scevgep42.moved.to..lr.ph10287 = getelementptr [1200 x double]* %R, i64 0, i64 %p_.moved.to..lr.ph10286
  %.promoted_p_scalar_288 = load double* %p_scevgep42.moved.to..lr.ph10287
  store double %.promoted_p_scalar_288, double* %p_scevgep42.moved.to..lr.ph10287
  %polly.indvar_next282 = add nsw i64 %polly.indvar281, 1
  %polly.adjust_ub283 = sub i64 %10, 1
  %polly.loop_cond284 = icmp sle i64 %polly.indvar281, %polly.adjust_ub283
  br i1 %polly.loop_cond284, label %polly.loop_header277, label %polly.cond297

polly.then302:                                    ; preds = %polly.cond297
  br i1 true, label %polly.loop_header304, label %polly.merge

polly.loop_header304:                             ; preds = %polly.then302, %polly.loop_header304
  %polly.indvar308 = phi i64 [ %polly.indvar_next309, %polly.loop_header304 ], [ 0, %polly.then302 ]
  %p_.moved.to..lr.ph10313 = add i64 %13, %polly.indvar308
  %p_scevgep42.moved.to..lr.ph10314 = getelementptr [1200 x double]* %R, i64 0, i64 %p_.moved.to..lr.ph10313
  %polly.indvar_next309 = add nsw i64 %polly.indvar308, 1
  %polly.adjust_ub310 = sub i64 %10, 1
  %polly.loop_cond311 = icmp sle i64 %polly.indvar308, %polly.adjust_ub310
  br i1 %polly.loop_cond311, label %polly.loop_header304, label %polly.merge

polly.then328:                                    ; preds = %.lr.ph7
  %52 = add i64 %1, -1
  %polly.loop_guard333 = icmp sle i64 0, %52
  br i1 %polly.loop_guard333, label %polly.loop_header330, label %.preheader1

polly.loop_header330:                             ; preds = %polly.then328, %polly.loop_header330
  %polly.indvar334 = phi i64 [ %polly.indvar_next335, %polly.loop_header330 ], [ 0, %polly.then328 ]
  %p_scevgep25 = getelementptr [1200 x double]* %Q, i64 %polly.indvar334, i64 %indvar19
  %p_scevgep24 = getelementptr [1200 x double]* %A, i64 %polly.indvar334, i64 %indvar19
  %_p_scalar_339 = load double* %p_scevgep24
  %p_340 = fdiv double %_p_scalar_339, %17
  store double %p_340, double* %p_scevgep25
  %p_indvar.next22 = add i64 %polly.indvar334, 1
  %polly.indvar_next335 = add nsw i64 %polly.indvar334, 1
  %polly.adjust_ub336 = sub i64 %52, 1
  %polly.loop_cond337 = icmp sle i64 %polly.indvar334, %polly.adjust_ub336
  br i1 %polly.loop_cond337, label %polly.loop_header330, label %.preheader1

polly.stmt.._crit_edge:                           ; preds = %polly.then346, %polly.loop_header348, %.lr.ph
  %nrm.04.reg2mem.0 = phi double [ %p_360, %polly.loop_header348 ], [ 0.000000e+00, %polly.then346 ], [ 0.000000e+00, %.lr.ph ]
  br label %16

polly.then346:                                    ; preds = %.lr.ph
  %53 = add i64 %1, -1
  %polly.loop_guard351 = icmp sle i64 0, %53
  br i1 %polly.loop_guard351, label %polly.loop_header348, label %polly.stmt.._crit_edge

polly.loop_header348:                             ; preds = %polly.then346, %polly.loop_header348
  %nrm.04.reg2mem.1 = phi double [ 0.000000e+00, %polly.then346 ], [ %p_360, %polly.loop_header348 ]
  %polly.indvar352 = phi i64 [ %polly.indvar_next353, %polly.loop_header348 ], [ 0, %polly.then346 ]
  %p_scevgep = getelementptr [1200 x double]* %A, i64 %polly.indvar352, i64 %indvar19
  %_p_scalar_357 = load double* %p_scevgep
  %p_359 = fmul double %_p_scalar_357, %_p_scalar_357
  %p_360 = fadd double %nrm.04.reg2mem.1, %p_359
  %p_indvar.next = add i64 %polly.indvar352, 1
  %polly.indvar_next353 = add nsw i64 %polly.indvar352, 1
  %polly.adjust_ub354 = sub i64 %53, 1
  %polly.loop_cond355 = icmp sle i64 %polly.indvar352, %polly.adjust_ub354
  br i1 %polly.loop_cond355, label %polly.loop_header348, label %polly.stmt.._crit_edge
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %m, i32 %n, [1200 x double]* noalias %A, [1200 x double]* noalias %R, [1200 x double]* noalias %Q) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %n, 0
  br i1 %5, label %.preheader4.lr.ph, label %22

.preheader4.lr.ph:                                ; preds = %.split
  %6 = zext i32 %n to i64
  %7 = zext i32 %n to i64
  %8 = icmp sgt i32 %n, 0
  br label %.preheader4

.preheader4:                                      ; preds = %.preheader4.lr.ph, %21
  %indvar20 = phi i64 [ 0, %.preheader4.lr.ph ], [ %indvar.next21, %21 ]
  %9 = mul i64 %7, %indvar20
  br i1 %8, label %.lr.ph9, label %21

.lr.ph9:                                          ; preds = %.preheader4
  br label %10

; <label>:10                                      ; preds = %.lr.ph9, %17
  %indvar17 = phi i64 [ 0, %.lr.ph9 ], [ %indvar.next18, %17 ]
  %11 = add i64 %9, %indvar17
  %12 = trunc i64 %11 to i32
  %scevgep22 = getelementptr [1200 x double]* %R, i64 %indvar20, i64 %indvar17
  %13 = srem i32 %12, 20
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %15, label %17

; <label>:15                                      ; preds = %10
  %16 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %fputc3 = tail call i32 @fputc(i32 10, %struct._IO_FILE* %16) #4
  br label %17

; <label>:17                                      ; preds = %15, %10
  %18 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %19 = load double* %scevgep22, align 8, !tbaa !6
  %20 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %18, i8* getelementptr inbounds ([8 x i8]* @.str5, i64 0, i64 0), double %19) #5
  %indvar.next18 = add i64 %indvar17, 1
  %exitcond19 = icmp ne i64 %indvar.next18, %6
  br i1 %exitcond19, label %10, label %._crit_edge10

._crit_edge10:                                    ; preds = %17
  br label %21

; <label>:21                                      ; preds = %._crit_edge10, %.preheader4
  %indvar.next21 = add i64 %indvar20, 1
  %exitcond23 = icmp ne i64 %indvar.next21, %7
  br i1 %exitcond23, label %.preheader4, label %._crit_edge12

._crit_edge12:                                    ; preds = %21
  br label %22

; <label>:22                                      ; preds = %._crit_edge12, %.split
  %23 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %24 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %25 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %26 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %25, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str7, i64 0, i64 0)) #5
  %27 = icmp sgt i32 %m, 0
  br i1 %27, label %.preheader.lr.ph, label %45

.preheader.lr.ph:                                 ; preds = %22
  %28 = zext i32 %n to i64
  %29 = zext i32 %m to i64
  %30 = zext i32 %n to i64
  %31 = icmp sgt i32 %n, 0
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %44
  %indvar13 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next14, %44 ]
  %32 = mul i64 %30, %indvar13
  br i1 %31, label %.lr.ph, label %44

.lr.ph:                                           ; preds = %.preheader
  br label %33

; <label>:33                                      ; preds = %.lr.ph, %40
  %indvar = phi i64 [ 0, %.lr.ph ], [ %indvar.next, %40 ]
  %34 = add i64 %32, %indvar
  %35 = trunc i64 %34 to i32
  %scevgep = getelementptr [1200 x double]* %Q, i64 %indvar13, i64 %indvar
  %36 = srem i32 %35, 20
  %37 = icmp eq i32 %36, 0
  br i1 %37, label %38, label %40

; <label>:38                                      ; preds = %33
  %39 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %39) #4
  br label %40

; <label>:40                                      ; preds = %38, %33
  %41 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %42 = load double* %scevgep, align 8, !tbaa !6
  %43 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %41, i8* getelementptr inbounds ([8 x i8]* @.str5, i64 0, i64 0), double %42) #5
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %28
  br i1 %exitcond, label %33, label %._crit_edge

._crit_edge:                                      ; preds = %40
  br label %44

; <label>:44                                      ; preds = %._crit_edge, %.preheader
  %indvar.next14 = add i64 %indvar13, 1
  %exitcond15 = icmp ne i64 %indvar.next14, %29
  br i1 %exitcond15, label %.preheader, label %._crit_edge7

._crit_edge7:                                     ; preds = %44
  br label %45

; <label>:45                                      ; preds = %._crit_edge7, %22
  %46 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %47 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %46, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str7, i64 0, i64 0)) #5
  %48 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %49 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str8, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %48) #4
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
