; ModuleID = './linear-algebra/solvers/lu/lu.c'
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
  tail call void @kernel_lu(i32 2000, [2000 x double]* %1)
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
define internal void @kernel_lu(i32 %n, [2000 x double]* %A) #0 {
.split:
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.preheader3.lr.ph, label %._crit_edge13

.preheader3.lr.ph:                                ; preds = %.split
  %1 = add i32 %n, -1
  %2 = zext i32 %n to i64
  %3 = zext i32 %1 to i64
  br label %.preheader3

.preheader3:                                      ; preds = %.preheader3.lr.ph, %polly.merge
  %4 = phi i64 [ 0, %.preheader3.lr.ph ], [ %indvar.next17, %polly.merge ]
  %5 = mul i64 %4, 16000
  %6 = trunc i64 %4 to i32
  %7 = mul i64 %4, -1
  %8 = add i64 %3, %7
  %9 = trunc i64 %8 to i32
  %10 = zext i32 %9 to i64
  %11 = mul i64 %4, 16008
  %12 = mul i64 %4, 2001
  %13 = icmp sgt i32 %6, 0
  br i1 %13, label %polly.cond60, label %.preheader2

.preheader2:                                      ; preds = %polly.stmt.66, %polly.loop_exit82, %polly.cond60, %.preheader3
  %14 = icmp slt i32 %6, %n
  br i1 %14, label %.preheader.lr.ph, label %polly.merge

.preheader.lr.ph:                                 ; preds = %.preheader2
  %15 = srem i64 %11, 8
  %16 = icmp eq i64 %15, 0
  br i1 %16, label %polly.cond42, label %polly.merge

polly.merge:                                      ; preds = %polly.then44, %polly.loop_exit48, %polly.cond42, %.preheader.lr.ph, %.preheader2
  %indvar.next17 = add i64 %4, 1
  %exitcond33 = icmp ne i64 %indvar.next17, %2
  br i1 %exitcond33, label %.preheader3, label %._crit_edge13

._crit_edge13:                                    ; preds = %polly.merge, %.split
  ret void

polly.cond42:                                     ; preds = %.preheader.lr.ph
  %17 = icmp sge i64 %4, 1
  %18 = sext i32 %6 to i64
  %19 = icmp sge i64 %18, 1
  %20 = and i1 %17, %19
  br i1 %20, label %polly.then44, label %polly.merge

polly.then44:                                     ; preds = %polly.cond42
  br i1 true, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then44, %polly.loop_exit48
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit48 ], [ 0, %polly.then44 ]
  %21 = add i64 %4, -1
  %polly.loop_guard49 = icmp sle i64 0, %21
  br i1 %polly.loop_guard49, label %polly.loop_header46, label %polly.loop_exit48

polly.loop_exit48:                                ; preds = %polly.loop_header46, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %10, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header46:                              ; preds = %polly.loop_header, %polly.loop_header46
  %polly.indvar50 = phi i64 [ %polly.indvar_next51, %polly.loop_header46 ], [ 0, %polly.loop_header ]
  %p_.moved.to. = add i64 %4, %polly.indvar
  %p_.moved.to.39 = add i64 %12, %polly.indvar
  %p_scevgep32.moved.to. = getelementptr [2000 x double]* %A, i64 0, i64 %p_.moved.to.39
  %p_scevgep29 = getelementptr [2000 x double]* %A, i64 %polly.indvar50, i64 %p_.moved.to.
  %p_scevgep26 = getelementptr [2000 x double]* %A, i64 %4, i64 %polly.indvar50
  %_p_scalar_ = load double* %p_scevgep26
  %_p_scalar_54 = load double* %p_scevgep29
  %p_ = fmul double %_p_scalar_, %_p_scalar_54
  %_p_scalar_55 = load double* %p_scevgep32.moved.to.
  %p_56 = fsub double %_p_scalar_55, %p_
  store double %p_56, double* %p_scevgep32.moved.to.
  %p_indvar.next24 = add i64 %polly.indvar50, 1
  %polly.indvar_next51 = add nsw i64 %polly.indvar50, 1
  %polly.adjust_ub52 = sub i64 %21, 1
  %polly.loop_cond53 = icmp sle i64 %polly.indvar50, %polly.adjust_ub52
  br i1 %polly.loop_cond53, label %polly.loop_header46, label %polly.loop_exit48

polly.cond60:                                     ; preds = %.preheader3
  %22 = srem i64 %5, 8
  %23 = icmp eq i64 %22, 0
  %24 = icmp sge i64 %4, 1
  %or.cond = and i1 %23, %24
  br i1 %or.cond, label %polly.stmt.66, label %.preheader2

polly.stmt.66:                                    ; preds = %polly.cond60
  %p_scevgep22.moved.to. = getelementptr [2000 x double]* %A, i64 0, i64 0
  %p_scevgep21.moved.to.41 = getelementptr [2000 x double]* %A, i64 %4, i64 0
  %_p_scalar_67 = load double* %p_scevgep22.moved.to.
  %_p_scalar_68 = load double* %p_scevgep21.moved.to.41
  %p_69 = fdiv double %_p_scalar_68, %_p_scalar_67
  store double %p_69, double* %p_scevgep21.moved.to.41
  %25 = add i64 %4, -1
  %polly.loop_guard74 = icmp sle i64 1, %25
  br i1 %polly.loop_guard74, label %polly.loop_header71, label %.preheader2

polly.loop_header71:                              ; preds = %polly.stmt.66, %polly.loop_exit82
  %polly.indvar75 = phi i64 [ %polly.indvar_next76, %polly.loop_exit82 ], [ 1, %polly.stmt.66 ]
  %26 = add i64 %polly.indvar75, -1
  %polly.loop_guard83 = icmp sle i64 0, %26
  br i1 %polly.loop_guard83, label %polly.loop_header80, label %polly.loop_exit82

polly.loop_exit82:                                ; preds = %polly.loop_header80, %polly.loop_header71
  %p_.moved.to.4095 = mul i64 %polly.indvar75, 2001
  %p_scevgep22.moved.to.96 = getelementptr [2000 x double]* %A, i64 0, i64 %p_.moved.to.4095
  %p_scevgep21.moved.to.4197 = getelementptr [2000 x double]* %A, i64 %4, i64 %polly.indvar75
  %_p_scalar_98 = load double* %p_scevgep22.moved.to.96
  %_p_scalar_99 = load double* %p_scevgep21.moved.to.4197
  %p_100 = fdiv double %_p_scalar_99, %_p_scalar_98
  store double %p_100, double* %p_scevgep21.moved.to.4197
  %p_indvar.next15101 = add i64 %polly.indvar75, 1
  %polly.indvar_next76 = add nsw i64 %polly.indvar75, 1
  %polly.adjust_ub77 = sub i64 %25, 1
  %polly.loop_cond78 = icmp sle i64 %polly.indvar75, %polly.adjust_ub77
  br i1 %polly.loop_cond78, label %polly.loop_header71, label %.preheader2

polly.loop_header80:                              ; preds = %polly.loop_header71, %polly.loop_header80
  %polly.indvar84 = phi i64 [ %polly.indvar_next85, %polly.loop_header80 ], [ 0, %polly.loop_header71 ]
  %p_scevgep21.moved.to. = getelementptr [2000 x double]* %A, i64 %4, i64 %polly.indvar75
  %p_scevgep = getelementptr [2000 x double]* %A, i64 %4, i64 %polly.indvar84
  %p_scevgep18 = getelementptr [2000 x double]* %A, i64 %polly.indvar84, i64 %polly.indvar75
  %_p_scalar_89 = load double* %p_scevgep
  %_p_scalar_90 = load double* %p_scevgep18
  %p_91 = fmul double %_p_scalar_89, %_p_scalar_90
  %_p_scalar_92 = load double* %p_scevgep21.moved.to.
  %p_93 = fsub double %_p_scalar_92, %p_91
  store double %p_93, double* %p_scevgep21.moved.to.
  %p_indvar.next = add i64 %polly.indvar84, 1
  %polly.indvar_next85 = add nsw i64 %polly.indvar84, 1
  %polly.adjust_ub86 = sub i64 %26, 1
  %polly.loop_cond87 = icmp sle i64 %polly.indvar84, %polly.adjust_ub86
  br i1 %polly.loop_cond87, label %polly.loop_header80, label %polly.loop_exit82
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
