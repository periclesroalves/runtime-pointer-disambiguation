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
define internal void @init_array(i32 %m, i32 %n, [1200 x double]* %A, [1200 x double]* %R, [1200 x double]* %Q) #0 {
.split:
  %A27 = bitcast [1200 x double]* %A to i8*
  %Q28 = bitcast [1200 x double]* %Q to i8*
  %Q26 = ptrtoint [1200 x double]* %Q to i64
  %A25 = ptrtoint [1200 x double]* %A to i64
  %0 = zext i32 %m to i64
  %1 = add i64 %0, -1
  %2 = mul i64 9600, %1
  %3 = add i64 %A25, %2
  %4 = zext i32 %n to i64
  %5 = add i64 %4, -1
  %6 = mul i64 8, %5
  %7 = add i64 %3, %6
  %8 = inttoptr i64 %7 to i8*
  %9 = add i64 %Q26, %2
  %10 = add i64 %9, %6
  %11 = inttoptr i64 %10 to i8*
  %12 = icmp ult i8* %8, %Q28
  %13 = icmp ult i8* %11, %A27
  %pair-no-alias = or i1 %12, %13
  br i1 %pair-no-alias, label %polly.start66, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  %14 = icmp sgt i32 %m, 0
  br i1 %14, label %.preheader2.lr.ph.clone, label %polly.start

.preheader2.lr.ph.clone:                          ; preds = %.split.split.clone
  %15 = icmp sgt i32 %n, 0
  %16 = sitofp i32 %m to double
  br label %.preheader2.clone

.preheader2.clone:                                ; preds = %._crit_edge8.clone, %.preheader2.lr.ph.clone
  %17 = phi i64 [ 0, %.preheader2.lr.ph.clone ], [ %indvar.next19.clone, %._crit_edge8.clone ]
  br i1 %15, label %.lr.ph7.clone, label %._crit_edge8.clone

.lr.ph7.clone:                                    ; preds = %.preheader2.clone, %.lr.ph7.clone
  %indvar15.clone = phi i64 [ %indvar.next16.clone, %.lr.ph7.clone ], [ 0, %.preheader2.clone ]
  %scevgep21.clone = getelementptr [1200 x double]* %Q, i64 %17, i64 %indvar15.clone
  %scevgep20.clone = getelementptr [1200 x double]* %A, i64 %17, i64 %indvar15.clone
  %18 = mul i64 %17, %indvar15.clone
  %19 = trunc i64 %18 to i32
  %20 = srem i32 %19, %m
  %21 = sitofp i32 %20 to double
  %22 = fdiv double %21, %16
  %23 = fmul double %22, 1.000000e+02
  %24 = fadd double %23, 1.000000e+01
  store double %24, double* %scevgep20.clone, align 8, !tbaa !6
  store double 0.000000e+00, double* %scevgep21.clone, align 8, !tbaa !6
  %indvar.next16.clone = add i64 %indvar15.clone, 1
  %exitcond17.clone = icmp ne i64 %indvar.next16.clone, %4
  br i1 %exitcond17.clone, label %.lr.ph7.clone, label %._crit_edge8.clone

._crit_edge8.clone:                               ; preds = %.lr.ph7.clone, %.preheader2.clone
  %indvar.next19.clone = add i64 %17, 1
  %exitcond22.clone = icmp ne i64 %indvar.next19.clone, %0
  br i1 %exitcond22.clone, label %.preheader2.clone, label %polly.start

polly.start:                                      ; preds = %polly.then70, %polly.loop_exit83, %polly.start66, %.split.split.clone, %._crit_edge8.clone
  %25 = sext i32 %n to i64
  %26 = icmp sge i64 %25, 1
  %27 = icmp sge i64 %4, 1
  %28 = and i1 %26, %27
  br i1 %28, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit41, %polly.start
  ret void

polly.then:                                       ; preds = %polly.start
  %polly.loop_guard = icmp sle i64 0, %5
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit41
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit41 ], [ 0, %polly.then ]
  %29 = mul i64 -11, %4
  %30 = add i64 %29, 5
  %31 = sub i64 %30, 32
  %32 = add i64 %31, 1
  %33 = icmp slt i64 %30, 0
  %34 = select i1 %33, i64 %32, i64 %30
  %35 = sdiv i64 %34, 32
  %36 = mul i64 -32, %35
  %37 = mul i64 -32, %4
  %38 = add i64 %36, %37
  %39 = mul i64 -32, %polly.indvar
  %40 = mul i64 -3, %polly.indvar
  %41 = add i64 %40, %4
  %42 = add i64 %41, 5
  %43 = sub i64 %42, 32
  %44 = add i64 %43, 1
  %45 = icmp slt i64 %42, 0
  %46 = select i1 %45, i64 %44, i64 %42
  %47 = sdiv i64 %46, 32
  %48 = mul i64 -32, %47
  %49 = add i64 %39, %48
  %50 = add i64 %49, -640
  %51 = icmp sgt i64 %38, %50
  %52 = select i1 %51, i64 %38, i64 %50
  %53 = mul i64 -20, %polly.indvar
  %polly.loop_guard42 = icmp sle i64 %52, %53
  br i1 %polly.loop_guard42, label %polly.loop_header39, label %polly.loop_exit41

polly.loop_exit41:                                ; preds = %polly.loop_exit50, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %5, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header39:                              ; preds = %polly.loop_header, %polly.loop_exit50
  %polly.indvar43 = phi i64 [ %polly.indvar_next44, %polly.loop_exit50 ], [ %52, %polly.loop_header ]
  %54 = mul i64 -1, %polly.indvar43
  %55 = mul i64 -1, %4
  %56 = add i64 %54, %55
  %57 = add i64 %56, -30
  %58 = add i64 %57, 20
  %59 = sub i64 %58, 1
  %60 = icmp slt i64 %57, 0
  %61 = select i1 %60, i64 %57, i64 %59
  %62 = sdiv i64 %61, 20
  %63 = icmp sgt i64 %62, %polly.indvar
  %64 = select i1 %63, i64 %62, i64 %polly.indvar
  %65 = sub i64 %54, 20
  %66 = add i64 %65, 1
  %67 = icmp slt i64 %54, 0
  %68 = select i1 %67, i64 %66, i64 %54
  %69 = sdiv i64 %68, 20
  %70 = add i64 %polly.indvar, 31
  %71 = icmp slt i64 %69, %70
  %72 = select i1 %71, i64 %69, i64 %70
  %73 = icmp slt i64 %72, %5
  %74 = select i1 %73, i64 %72, i64 %5
  %polly.loop_guard51 = icmp sle i64 %64, %74
  br i1 %polly.loop_guard51, label %polly.loop_header48, label %polly.loop_exit50

polly.loop_exit50:                                ; preds = %polly.loop_exit59, %polly.loop_header39
  %polly.indvar_next44 = add nsw i64 %polly.indvar43, 32
  %polly.adjust_ub45 = sub i64 %53, 32
  %polly.loop_cond46 = icmp sle i64 %polly.indvar43, %polly.adjust_ub45
  br i1 %polly.loop_cond46, label %polly.loop_header39, label %polly.loop_exit41

polly.loop_header48:                              ; preds = %polly.loop_header39, %polly.loop_exit59
  %polly.indvar52 = phi i64 [ %polly.indvar_next53, %polly.loop_exit59 ], [ %64, %polly.loop_header39 ]
  %75 = mul i64 -20, %polly.indvar52
  %76 = add i64 %75, %55
  %77 = add i64 %76, 1
  %78 = icmp sgt i64 %polly.indvar43, %77
  %79 = select i1 %78, i64 %polly.indvar43, i64 %77
  %80 = add i64 %polly.indvar43, 31
  %81 = icmp slt i64 %75, %80
  %82 = select i1 %81, i64 %75, i64 %80
  %polly.loop_guard60 = icmp sle i64 %79, %82
  br i1 %polly.loop_guard60, label %polly.loop_header57, label %polly.loop_exit59

polly.loop_exit59:                                ; preds = %polly.loop_header57, %polly.loop_header48
  %polly.indvar_next53 = add nsw i64 %polly.indvar52, 1
  %polly.adjust_ub54 = sub i64 %74, 1
  %polly.loop_cond55 = icmp sle i64 %polly.indvar52, %polly.adjust_ub54
  br i1 %polly.loop_cond55, label %polly.loop_header48, label %polly.loop_exit50

polly.loop_header57:                              ; preds = %polly.loop_header48, %polly.loop_header57
  %polly.indvar61 = phi i64 [ %polly.indvar_next62, %polly.loop_header57 ], [ %79, %polly.loop_header48 ]
  %83 = mul i64 -1, %polly.indvar61
  %84 = add i64 %75, %83
  %p_scevgep = getelementptr [1200 x double]* %R, i64 %polly.indvar52, i64 %84
  store double 0.000000e+00, double* %p_scevgep
  %p_indvar.next = add i64 %84, 1
  %polly.indvar_next62 = add nsw i64 %polly.indvar61, 1
  %polly.adjust_ub63 = sub i64 %82, 1
  %polly.loop_cond64 = icmp sle i64 %polly.indvar61, %polly.adjust_ub63
  br i1 %polly.loop_cond64, label %polly.loop_header57, label %polly.loop_exit59

polly.start66:                                    ; preds = %.split
  %85 = sext i32 %m to i64
  %86 = icmp sge i64 %85, 1
  %87 = sext i32 %n to i64
  %88 = icmp sge i64 %87, 1
  %89 = and i1 %86, %88
  %90 = icmp sge i64 %0, 1
  %91 = and i1 %89, %90
  %92 = icmp sge i64 %4, 1
  %93 = and i1 %91, %92
  br i1 %93, label %polly.then70, label %polly.start

polly.then70:                                     ; preds = %polly.start66
  %polly.loop_guard75 = icmp sle i64 0, %1
  br i1 %polly.loop_guard75, label %polly.loop_header72, label %polly.start

polly.loop_header72:                              ; preds = %polly.then70, %polly.loop_exit83
  %polly.indvar76 = phi i64 [ %polly.indvar_next77, %polly.loop_exit83 ], [ 0, %polly.then70 ]
  %94 = mul i64 -3, %0
  %95 = add i64 %94, %4
  %96 = add i64 %95, 5
  %97 = sub i64 %96, 32
  %98 = add i64 %97, 1
  %99 = icmp slt i64 %96, 0
  %100 = select i1 %99, i64 %98, i64 %96
  %101 = sdiv i64 %100, 32
  %102 = mul i64 -32, %101
  %103 = mul i64 -32, %0
  %104 = add i64 %102, %103
  %105 = mul i64 -32, %polly.indvar76
  %106 = mul i64 -3, %polly.indvar76
  %107 = add i64 %106, %4
  %108 = add i64 %107, 5
  %109 = sub i64 %108, 32
  %110 = add i64 %109, 1
  %111 = icmp slt i64 %108, 0
  %112 = select i1 %111, i64 %110, i64 %108
  %113 = sdiv i64 %112, 32
  %114 = mul i64 -32, %113
  %115 = add i64 %105, %114
  %116 = add i64 %115, -640
  %117 = icmp sgt i64 %104, %116
  %118 = select i1 %117, i64 %104, i64 %116
  %119 = mul i64 -20, %polly.indvar76
  %polly.loop_guard84 = icmp sle i64 %118, %119
  br i1 %polly.loop_guard84, label %polly.loop_header81, label %polly.loop_exit83

polly.loop_exit83:                                ; preds = %polly.loop_exit92, %polly.loop_header72
  %polly.indvar_next77 = add nsw i64 %polly.indvar76, 32
  %polly.adjust_ub78 = sub i64 %1, 32
  %polly.loop_cond79 = icmp sle i64 %polly.indvar76, %polly.adjust_ub78
  br i1 %polly.loop_cond79, label %polly.loop_header72, label %polly.start

polly.loop_header81:                              ; preds = %polly.loop_header72, %polly.loop_exit92
  %polly.indvar85 = phi i64 [ %polly.indvar_next86, %polly.loop_exit92 ], [ %118, %polly.loop_header72 ]
  %120 = mul i64 -1, %polly.indvar85
  %121 = mul i64 -1, %4
  %122 = add i64 %120, %121
  %123 = add i64 %122, -30
  %124 = add i64 %123, 20
  %125 = sub i64 %124, 1
  %126 = icmp slt i64 %123, 0
  %127 = select i1 %126, i64 %123, i64 %125
  %128 = sdiv i64 %127, 20
  %129 = icmp sgt i64 %128, %polly.indvar76
  %130 = select i1 %129, i64 %128, i64 %polly.indvar76
  %131 = sub i64 %120, 20
  %132 = add i64 %131, 1
  %133 = icmp slt i64 %120, 0
  %134 = select i1 %133, i64 %132, i64 %120
  %135 = sdiv i64 %134, 20
  %136 = add i64 %polly.indvar76, 31
  %137 = icmp slt i64 %135, %136
  %138 = select i1 %137, i64 %135, i64 %136
  %139 = icmp slt i64 %138, %1
  %140 = select i1 %139, i64 %138, i64 %1
  %polly.loop_guard93 = icmp sle i64 %130, %140
  br i1 %polly.loop_guard93, label %polly.loop_header90, label %polly.loop_exit92

polly.loop_exit92:                                ; preds = %polly.loop_exit101, %polly.loop_header81
  %polly.indvar_next86 = add nsw i64 %polly.indvar85, 32
  %polly.adjust_ub87 = sub i64 %119, 32
  %polly.loop_cond88 = icmp sle i64 %polly.indvar85, %polly.adjust_ub87
  br i1 %polly.loop_cond88, label %polly.loop_header81, label %polly.loop_exit83

polly.loop_header90:                              ; preds = %polly.loop_header81, %polly.loop_exit101
  %polly.indvar94 = phi i64 [ %polly.indvar_next95, %polly.loop_exit101 ], [ %130, %polly.loop_header81 ]
  %141 = mul i64 -20, %polly.indvar94
  %142 = add i64 %141, %121
  %143 = add i64 %142, 1
  %144 = icmp sgt i64 %polly.indvar85, %143
  %145 = select i1 %144, i64 %polly.indvar85, i64 %143
  %146 = add i64 %polly.indvar85, 31
  %147 = icmp slt i64 %141, %146
  %148 = select i1 %147, i64 %141, i64 %146
  %polly.loop_guard102 = icmp sle i64 %145, %148
  br i1 %polly.loop_guard102, label %polly.loop_header99, label %polly.loop_exit101

polly.loop_exit101:                               ; preds = %polly.loop_header99, %polly.loop_header90
  %polly.indvar_next95 = add nsw i64 %polly.indvar94, 1
  %polly.adjust_ub96 = sub i64 %140, 1
  %polly.loop_cond97 = icmp sle i64 %polly.indvar94, %polly.adjust_ub96
  br i1 %polly.loop_cond97, label %polly.loop_header90, label %polly.loop_exit92

polly.loop_header99:                              ; preds = %polly.loop_header90, %polly.loop_header99
  %polly.indvar103 = phi i64 [ %polly.indvar_next104, %polly.loop_header99 ], [ %145, %polly.loop_header90 ]
  %149 = mul i64 -1, %polly.indvar103
  %150 = add i64 %141, %149
  %p_.moved.to.32 = sitofp i32 %m to double
  %p_scevgep21 = getelementptr [1200 x double]* %Q, i64 %polly.indvar94, i64 %150
  %p_scevgep20 = getelementptr [1200 x double]* %A, i64 %polly.indvar94, i64 %150
  %p_ = mul i64 %polly.indvar94, %150
  %p_108 = trunc i64 %p_ to i32
  %p_109 = srem i32 %p_108, %m
  %p_110 = sitofp i32 %p_109 to double
  %p_111 = fdiv double %p_110, %p_.moved.to.32
  %p_112 = fmul double %p_111, 1.000000e+02
  %p_113 = fadd double %p_112, 1.000000e+01
  store double %p_113, double* %p_scevgep20
  store double 0.000000e+00, double* %p_scevgep21
  %p_indvar.next16 = add i64 %150, 1
  %polly.indvar_next104 = add nsw i64 %polly.indvar103, 1
  %polly.adjust_ub105 = sub i64 %148, 1
  %polly.loop_cond106 = icmp sle i64 %polly.indvar103, %polly.adjust_ub105
  br i1 %polly.loop_cond106, label %polly.loop_header99, label %polly.loop_exit101
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_gramschmidt(i32 %m, i32 %n, [1200 x double]* %A, [1200 x double]* %R, [1200 x double]* %Q) #0 {
.split:
  %A54 = bitcast [1200 x double]* %A to i8*
  %R55 = bitcast [1200 x double]* %R to i8*
  %Q56 = ptrtoint [1200 x double]* %Q to i64
  %Q57 = bitcast [1200 x double]* %Q to i8*
  %R53 = ptrtoint [1200 x double]* %R to i64
  %A52 = ptrtoint [1200 x double]* %A to i64
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.preheader2.lr.ph, label %._crit_edge18

.preheader2.lr.ph:                                ; preds = %.split
  %1 = zext i32 %m to i64
  %2 = add i32 %n, -2
  %3 = zext i32 %n to i64
  %4 = zext i32 %2 to i64
  %5 = icmp sgt i32 %m, 0
  %scevgep61 = getelementptr [1200 x double]* %A, i64 0, i64 1
  %scevgep6263 = ptrtoint double* %scevgep61 to i64
  %6 = add i32 %n, -1
  %7 = mul i32 -1, %6
  %8 = add i32 %2, %7
  %scevgep64 = getelementptr [1200 x double]* %R, i64 0, i64 1
  %scevgep6469 = bitcast double* %scevgep64 to i8*
  %scevgep6566 = ptrtoint double* %scevgep64 to i64
  br label %.preheader2

.preheader2:                                      ; preds = %.preheader2.lr.ph, %.region60.clone
  %nrm.04.reg2mem.0 = phi double [ undef, %.preheader2.lr.ph ], [ %nrm.04.reg2mem.2, %.region60.clone ]
  %indvar19 = phi i64 [ 0, %.preheader2.lr.ph ], [ %p_195, %.region60.clone ]
  %9 = mul i64 %indvar19, 8
  %p_193 = mul i64 %indvar19, 1201
  %p_194 = add i64 %p_193, 1
  %p_195 = add i64 %indvar19, 1
  %p_j.013 = trunc i64 %p_195 to i32
  %p_196 = mul i64 %indvar19, -1
  %p_197 = add i64 %4, %p_196
  %p_198 = trunc i64 %p_197 to i32
  %p_scevgep51 = getelementptr [1200 x double]* %R, i64 0, i64 %p_193
  %p_199 = zext i32 %p_198 to i64
  %p_200 = add i64 %p_199, 1
  %10 = sext i32 %m to i64
  %11 = icmp sge i64 %10, 1
  br i1 %11, label %polly.stmt..lr.ph, label %polly.cond204

.lr.ph7.split:                                    ; preds = %polly.merge222
  %12 = add i64 %3, -1
  %13 = mul i64 8, %12
  %14 = add i64 %A52, %13
  %15 = add i64 %1, -1
  %16 = mul i64 9600, %15
  %17 = add i64 %14, %16
  %18 = inttoptr i64 %17 to i8*
  %19 = mul i64 9608, %12
  %20 = add i64 %R53, %19
  %21 = inttoptr i64 %20 to i8*
  %22 = icmp ult i8* %18, %R55
  %23 = icmp ult i8* %21, %A54
  %pair-no-alias = or i1 %22, %23
  %24 = add i64 %Q56, %13
  %25 = add i64 %24, %16
  %26 = inttoptr i64 %25 to i8*
  %27 = icmp ult i8* %18, %Q57
  %28 = icmp ult i8* %26, %A54
  %pair-no-alias58 = or i1 %27, %28
  %29 = and i1 %pair-no-alias, %pair-no-alias58
  %30 = icmp ult i8* %21, %Q57
  %31 = icmp ult i8* %26, %R55
  %pair-no-alias59 = or i1 %30, %31
  %32 = and i1 %29, %pair-no-alias59
  br i1 %32, label %polly.cond136, label %69

.preheader1:                                      ; preds = %polly.then141, %polly.loop_header143, %polly.cond136, %69, %polly.merge222
  %umin67 = bitcast double* %scevgep61 to i8*
  %33 = add i64 %3, -1
  %34 = mul i64 8, %33
  %35 = add i64 %scevgep6263, %34
  %36 = zext i32 %8 to i64
  %37 = mul i64 8, %36
  %38 = add i64 %35, %37
  %39 = add i64 %1, -1
  %40 = mul i64 9600, %39
  %41 = add i64 %38, %40
  %umax68 = inttoptr i64 %41 to i8*
  %42 = mul i64 9608, %33
  %43 = add i64 %scevgep6566, %42
  %44 = add i64 %43, %37
  %45 = inttoptr i64 %44 to i8*
  %46 = icmp ult i8* %umax68, %scevgep6469
  %47 = icmp ult i8* %45, %umin67
  %pair-no-alias70 = or i1 %46, %47
  %48 = add i64 %Q56, %34
  %49 = add i64 %48, %40
  %umax7274 = inttoptr i64 %49 to i8*
  %50 = icmp ult i8* %umax68, %Q57
  %51 = icmp ult i8* %umax7274, %umin67
  %pair-no-alias75 = or i1 %50, %51
  %52 = and i1 %pair-no-alias70, %pair-no-alias75
  %53 = icmp ult i8* %45, %Q57
  %54 = icmp ult i8* %umax7274, %scevgep6469
  %pair-no-alias76 = or i1 %53, %54
  %55 = and i1 %52, %pair-no-alias76
  br i1 %55, label %polly.cond, label %.preheader1.split.clone

.preheader1.split.clone:                          ; preds = %.preheader1
  %56 = icmp slt i32 %p_j.013, %n
  br i1 %56, label %.lr.ph15.clone, label %.region60.clone

.lr.ph15.clone:                                   ; preds = %.preheader1.split.clone, %.loopexit.clone
  %indvar30.clone = phi i64 [ %indvar.next31.clone, %.loopexit.clone ], [ 0, %.preheader1.split.clone ]
  %57 = add i64 %p_194, %indvar30.clone
  %scevgep41.clone = getelementptr [1200 x double]* %R, i64 0, i64 %57
  %58 = add i64 %p_195, %indvar30.clone
  store double 0.000000e+00, double* %scevgep41.clone, align 8, !tbaa !6
  br i1 %5, label %.lr.ph10.clone, label %.preheader.clone

.lr.ph10.clone:                                   ; preds = %.lr.ph15.clone, %.lr.ph10.clone
  %indvar26.clone = phi i64 [ %indvar.next27.clone, %.lr.ph10.clone ], [ 0, %.lr.ph15.clone ]
  %scevgep32.clone = getelementptr [1200 x double]* %A, i64 %indvar26.clone, i64 %58
  %scevgep29.clone = getelementptr [1200 x double]* %Q, i64 %indvar26.clone, i64 %indvar19
  %59 = load double* %scevgep29.clone, align 8, !tbaa !6
  %60 = load double* %scevgep32.clone, align 8, !tbaa !6
  %61 = fmul double %59, %60
  %62 = load double* %scevgep41.clone, align 8, !tbaa !6
  %63 = fadd double %62, %61
  store double %63, double* %scevgep41.clone, align 8, !tbaa !6
  %indvar.next27.clone = add i64 %indvar26.clone, 1
  %exitcond28.clone = icmp ne i64 %indvar.next27.clone, %1
  br i1 %exitcond28.clone, label %.lr.ph10.clone, label %.preheader.clone

.preheader.clone:                                 ; preds = %.lr.ph10.clone, %.lr.ph15.clone
  br i1 %5, label %.lr.ph12.clone, label %.loopexit.clone

.lr.ph12.clone:                                   ; preds = %.preheader.clone, %.lr.ph12.clone
  %indvar33.clone = phi i64 [ %indvar.next34.clone, %.lr.ph12.clone ], [ 0, %.preheader.clone ]
  %scevgep36.clone = getelementptr [1200 x double]* %A, i64 %indvar33.clone, i64 %58
  %scevgep37.clone = getelementptr [1200 x double]* %Q, i64 %indvar33.clone, i64 %indvar19
  %64 = load double* %scevgep36.clone, align 8, !tbaa !6
  %65 = load double* %scevgep37.clone, align 8, !tbaa !6
  %66 = load double* %scevgep41.clone, align 8, !tbaa !6
  %67 = fmul double %65, %66
  %68 = fsub double %64, %67
  store double %68, double* %scevgep36.clone, align 8, !tbaa !6
  %indvar.next34.clone = add i64 %indvar33.clone, 1
  %exitcond35.clone = icmp ne i64 %indvar.next34.clone, %1
  br i1 %exitcond35.clone, label %.lr.ph12.clone, label %.loopexit.clone

.loopexit.clone:                                  ; preds = %.lr.ph12.clone, %.preheader.clone
  %indvar.next31.clone = add i64 %indvar30.clone, 1
  %exitcond38.clone = icmp ne i64 %indvar.next31.clone, %p_200
  br i1 %exitcond38.clone, label %.lr.ph15.clone, label %.region60.clone

; <label>:69                                      ; preds = %.lr.ph7.split, %69
  %indvar21.clone = phi i64 [ 0, %.lr.ph7.split ], [ %indvar.next22.clone, %69 ]
  %scevgep25.clone = getelementptr [1200 x double]* %Q, i64 %indvar21.clone, i64 %indvar19
  %scevgep24.clone = getelementptr [1200 x double]* %A, i64 %indvar21.clone, i64 %indvar19
  %70 = load double* %scevgep24.clone, align 8, !tbaa !6
  %71 = load double* %p_scevgep51, align 8, !tbaa !6
  %72 = fdiv double %70, %71
  store double %72, double* %scevgep25.clone, align 8, !tbaa !6
  %indvar.next22.clone = add i64 %indvar21.clone, 1
  %exitcond23.clone = icmp ne i64 %indvar.next22.clone, %1
  br i1 %exitcond23.clone, label %69, label %.preheader1

.region60.clone:                                  ; preds = %polly.then94, %polly.loop_exit121, %polly.cond92, %polly.cond, %.preheader1.split.clone, %.loopexit.clone
  %exitcond42 = icmp ne i64 %p_195, %3
  br i1 %exitcond42, label %.preheader2, label %._crit_edge18

._crit_edge18:                                    ; preds = %.region60.clone, %.split
  ret void

polly.cond:                                       ; preds = %.preheader1
  %73 = icmp sge i64 %p_200, 1
  %74 = sext i32 %p_j.013 to i64
  %75 = sext i32 %n to i64
  %76 = add i64 %75, -1
  %77 = icmp sle i64 %74, %76
  %78 = and i1 %73, %77
  br i1 %78, label %polly.then, label %.region60.clone

polly.then:                                       ; preds = %polly.cond
  br i1 true, label %polly.loop_header, label %polly.cond92

polly.cond92:                                     ; preds = %polly.then, %polly.loop_header
  br i1 %82, label %polly.then94, label %.region60.clone

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_ = add i64 %p_194, %polly.indvar
  %p_scevgep41 = getelementptr [1200 x double]* %R, i64 0, i64 %p_
  store double 0.000000e+00, double* %p_scevgep41
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %p_199, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond92

polly.then94:                                     ; preds = %polly.cond92
  br i1 true, label %polly.loop_header96, label %.region60.clone

polly.loop_header96:                              ; preds = %polly.then94, %polly.loop_exit121
  %polly.indvar100 = phi i64 [ %polly.indvar_next101, %polly.loop_exit121 ], [ 0, %polly.then94 ]
  %polly.loop_guard108 = icmp sle i64 0, %39
  br i1 %polly.loop_guard108, label %polly.loop_header105, label %polly.loop_exit107

polly.loop_exit107:                               ; preds = %polly.loop_header105, %polly.loop_header96
  br i1 %polly.loop_guard108, label %polly.loop_header119, label %polly.loop_exit121

polly.loop_exit121:                               ; preds = %polly.loop_header119, %polly.loop_exit107
  %polly.indvar_next101 = add nsw i64 %polly.indvar100, 1
  %polly.adjust_ub102 = sub i64 %p_199, 1
  %polly.loop_cond103 = icmp sle i64 %polly.indvar100, %polly.adjust_ub102
  br i1 %polly.loop_cond103, label %polly.loop_header96, label %.region60.clone

polly.loop_header105:                             ; preds = %polly.loop_header96, %polly.loop_header105
  %polly.indvar109 = phi i64 [ %polly.indvar_next110, %polly.loop_header105 ], [ 0, %polly.loop_header96 ]
  %p_.moved.to.77 = add i64 %p_195, %polly.indvar100
  %p_.moved.to.78 = add i64 %p_194, %polly.indvar100
  %p_scevgep41.moved.to. = getelementptr [1200 x double]* %R, i64 0, i64 %p_.moved.to.78
  %p_scevgep32 = getelementptr [1200 x double]* %A, i64 %polly.indvar109, i64 %p_.moved.to.77
  %p_scevgep29 = getelementptr [1200 x double]* %Q, i64 %polly.indvar109, i64 %indvar19
  %_p_scalar_ = load double* %p_scevgep29
  %_p_scalar_114 = load double* %p_scevgep32
  %p_115 = fmul double %_p_scalar_, %_p_scalar_114
  %_p_scalar_116 = load double* %p_scevgep41.moved.to.
  %p_117 = fadd double %_p_scalar_116, %p_115
  store double %p_117, double* %p_scevgep41.moved.to.
  %p_indvar.next27 = add i64 %polly.indvar109, 1
  %polly.indvar_next110 = add nsw i64 %polly.indvar109, 1
  %polly.adjust_ub111 = sub i64 %39, 1
  %polly.loop_cond112 = icmp sle i64 %polly.indvar109, %polly.adjust_ub111
  br i1 %polly.loop_cond112, label %polly.loop_header105, label %polly.loop_exit107

polly.loop_header119:                             ; preds = %polly.loop_exit107, %polly.loop_header119
  %polly.indvar123 = phi i64 [ %polly.indvar_next124, %polly.loop_header119 ], [ 0, %polly.loop_exit107 ]
  %p_.moved.to.79 = add i64 %p_195, %polly.indvar100
  %p_.moved.to.80 = add i64 %p_194, %polly.indvar100
  %p_scevgep41.moved.to.81 = getelementptr [1200 x double]* %R, i64 0, i64 %p_.moved.to.80
  %p_scevgep36 = getelementptr [1200 x double]* %A, i64 %polly.indvar123, i64 %p_.moved.to.79
  %p_scevgep37 = getelementptr [1200 x double]* %Q, i64 %polly.indvar123, i64 %indvar19
  %_p_scalar_128 = load double* %p_scevgep36
  %_p_scalar_129 = load double* %p_scevgep37
  %_p_scalar_130 = load double* %p_scevgep41.moved.to.81
  %p_131 = fmul double %_p_scalar_129, %_p_scalar_130
  %p_132 = fsub double %_p_scalar_128, %p_131
  store double %p_132, double* %p_scevgep36
  %p_indvar.next34 = add i64 %polly.indvar123, 1
  %polly.indvar_next124 = add nsw i64 %polly.indvar123, 1
  %polly.adjust_ub125 = sub i64 %39, 1
  %polly.loop_cond126 = icmp sle i64 %polly.indvar123, %polly.adjust_ub125
  br i1 %polly.loop_cond126, label %polly.loop_header119, label %polly.loop_exit121

polly.cond136:                                    ; preds = %.lr.ph7.split
  %79 = srem i64 %9, 8
  %80 = icmp eq i64 %79, 0
  %or.cond = and i1 %80, %81
  br i1 %or.cond, label %polly.then141, label %.preheader1

polly.then141:                                    ; preds = %polly.cond136
  %polly.loop_guard146 = icmp sle i64 0, %15
  br i1 %polly.loop_guard146, label %polly.loop_header143, label %.preheader1

polly.loop_header143:                             ; preds = %polly.then141, %polly.loop_header143
  %polly.indvar147 = phi i64 [ %polly.indvar_next148, %polly.loop_header143 ], [ 0, %polly.then141 ]
  %p_scevgep25 = getelementptr [1200 x double]* %Q, i64 %polly.indvar147, i64 %indvar19
  %p_scevgep24 = getelementptr [1200 x double]* %A, i64 %polly.indvar147, i64 %indvar19
  %_p_scalar_152 = load double* %p_scevgep24
  %_p_scalar_153 = load double* %p_scevgep51
  %p_154 = fdiv double %_p_scalar_152, %_p_scalar_153
  store double %p_154, double* %p_scevgep25
  %p_indvar.next22 = add i64 %polly.indvar147, 1
  %polly.indvar_next148 = add nsw i64 %polly.indvar147, 1
  %polly.adjust_ub149 = sub i64 %15, 1
  %polly.loop_cond150 = icmp sle i64 %polly.indvar147, %polly.adjust_ub149
  br i1 %polly.loop_cond150, label %polly.loop_header143, label %.preheader1

polly.cond204:                                    ; preds = %.preheader2, %polly.stmt..lr.ph
  %nrm.04.reg2mem.1 = phi double [ 0.000000e+00, %polly.stmt..lr.ph ], [ %nrm.04.reg2mem.0, %.preheader2 ]
  %81 = icmp sge i64 %1, 1
  %82 = and i1 %11, %81
  br i1 %82, label %polly.then206, label %polly.cond221

polly.cond221:                                    ; preds = %polly.then206, %polly.loop_header208, %polly.cond204
  %nrm.04.reg2mem.2 = phi double [ %p_220, %polly.loop_header208 ], [ %nrm.04.reg2mem.1, %polly.then206 ], [ %nrm.04.reg2mem.1, %polly.cond204 ]
  br i1 %11, label %polly.stmt.._crit_edge, label %polly.merge222

polly.merge222:                                   ; preds = %polly.stmt.._crit_edge, %polly.cond221
  %nrm.0.lcssa.reg2mem.0 = phi double [ %nrm.04.reg2mem.2, %polly.stmt.._crit_edge ], [ 0.000000e+00, %polly.cond221 ]
  %83 = tail call double @sqrt(double %nrm.0.lcssa.reg2mem.0) #3
  store double %83, double* %p_scevgep51, align 8, !tbaa !6
  br i1 %5, label %.lr.ph7.split, label %.preheader1

polly.stmt..lr.ph:                                ; preds = %.preheader2
  br label %polly.cond204

polly.then206:                                    ; preds = %polly.cond204
  %84 = add i64 %1, -1
  %polly.loop_guard211 = icmp sle i64 0, %84
  br i1 %polly.loop_guard211, label %polly.loop_header208, label %polly.cond221

polly.loop_header208:                             ; preds = %polly.then206, %polly.loop_header208
  %nrm.04.reg2mem.3 = phi double [ %nrm.04.reg2mem.1, %polly.then206 ], [ %p_220, %polly.loop_header208 ]
  %polly.indvar212 = phi i64 [ %polly.indvar_next213, %polly.loop_header208 ], [ 0, %polly.then206 ]
  %p_scevgep = getelementptr [1200 x double]* %A, i64 %polly.indvar212, i64 %indvar19
  %_p_scalar_217 = load double* %p_scevgep
  %p_219 = fmul double %_p_scalar_217, %_p_scalar_217
  %p_220 = fadd double %nrm.04.reg2mem.3, %p_219
  %p_indvar.next = add i64 %polly.indvar212, 1
  %polly.indvar_next213 = add nsw i64 %polly.indvar212, 1
  %polly.adjust_ub214 = sub i64 %84, 1
  %polly.loop_cond215 = icmp sle i64 %polly.indvar212, %polly.adjust_ub214
  br i1 %polly.loop_cond215, label %polly.loop_header208, label %polly.cond221

polly.stmt.._crit_edge:                           ; preds = %polly.cond221
  br label %polly.merge222
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %m, i32 %n, [1200 x double]* %A, [1200 x double]* %R, [1200 x double]* %Q) #0 {
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

declare i8* @gcg_getBasePtr(i8* nocapture readonly)

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
