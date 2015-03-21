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
define internal void @init_array(i32 %n, [1000 x double]* %u) #0 {
polly.split_new_and_old:
  %0 = zext i32 %n to i64
  %1 = sext i32 %n to i64
  %2 = icmp sge i64 %1, 1
  %3 = icmp sge i64 %0, 1
  %4 = and i1 %2, %3
  br i1 %4, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit22, %polly.split_new_and_old
  ret void

polly.then:                                       ; preds = %polly.split_new_and_old
  %5 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %5
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit22
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit22 ], [ 0, %polly.then ]
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
  %polly.loop_guard23 = icmp sle i64 %29, %30
  br i1 %polly.loop_guard23, label %polly.loop_header20, label %polly.loop_exit22

polly.loop_exit22:                                ; preds = %polly.loop_exit31, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %5, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header20:                              ; preds = %polly.loop_header, %polly.loop_exit31
  %polly.indvar24 = phi i64 [ %polly.indvar_next25, %polly.loop_exit31 ], [ %29, %polly.loop_header ]
  %31 = mul i64 -1, %polly.indvar24
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
  %polly.loop_guard32 = icmp sle i64 %41, %51
  br i1 %polly.loop_guard32, label %polly.loop_header29, label %polly.loop_exit31

polly.loop_exit31:                                ; preds = %polly.loop_exit40, %polly.loop_header20
  %polly.indvar_next25 = add nsw i64 %polly.indvar24, 32
  %polly.adjust_ub26 = sub i64 %30, 32
  %polly.loop_cond27 = icmp sle i64 %polly.indvar24, %polly.adjust_ub26
  br i1 %polly.loop_cond27, label %polly.loop_header20, label %polly.loop_exit22

polly.loop_header29:                              ; preds = %polly.loop_header20, %polly.loop_exit40
  %polly.indvar33 = phi i64 [ %polly.indvar_next34, %polly.loop_exit40 ], [ %41, %polly.loop_header20 ]
  %52 = mul i64 -20, %polly.indvar33
  %53 = add i64 %52, %32
  %54 = add i64 %53, 1
  %55 = icmp sgt i64 %polly.indvar24, %54
  %56 = select i1 %55, i64 %polly.indvar24, i64 %54
  %57 = add i64 %polly.indvar24, 31
  %58 = icmp slt i64 %52, %57
  %59 = select i1 %58, i64 %52, i64 %57
  %polly.loop_guard41 = icmp sle i64 %56, %59
  br i1 %polly.loop_guard41, label %polly.loop_header38, label %polly.loop_exit40

polly.loop_exit40:                                ; preds = %polly.loop_header38, %polly.loop_header29
  %polly.indvar_next34 = add nsw i64 %polly.indvar33, 1
  %polly.adjust_ub35 = sub i64 %51, 1
  %polly.loop_cond36 = icmp sle i64 %polly.indvar33, %polly.adjust_ub35
  br i1 %polly.loop_cond36, label %polly.loop_header29, label %polly.loop_exit31

polly.loop_header38:                              ; preds = %polly.loop_header29, %polly.loop_header38
  %polly.indvar42 = phi i64 [ %polly.indvar_next43, %polly.loop_header38 ], [ %56, %polly.loop_header29 ]
  %60 = mul i64 -1, %polly.indvar42
  %61 = add i64 %52, %60
  %p_.moved.to.8 = add i64 %0, %polly.indvar33
  %p_.moved.to.9 = sitofp i32 %n to double
  %p_scevgep = getelementptr [1000 x double]* %u, i64 %polly.indvar33, i64 %61
  %p_ = mul i64 %61, -1
  %p_46 = add i64 %p_.moved.to.8, %p_
  %p_47 = trunc i64 %p_46 to i32
  %p_48 = sitofp i32 %p_47 to double
  %p_49 = fdiv double %p_48, %p_.moved.to.9
  store double %p_49, double* %p_scevgep
  %p_indvar.next = add i64 %61, 1
  %polly.indvar_next43 = add nsw i64 %polly.indvar42, 1
  %polly.adjust_ub44 = sub i64 %59, 1
  %polly.loop_cond45 = icmp sle i64 %polly.indvar42, %polly.adjust_ub44
  br i1 %polly.loop_cond45, label %polly.loop_header38, label %polly.loop_exit40
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_adi(i32 %tsteps, i32 %n, [1000 x double]* %u, [1000 x double]* %v, [1000 x double]* %p, [1000 x double]* %q) #0 {
.split:
  %scevgep91 = getelementptr [1000 x double]* %u, i64 1, i64 0
  %0 = add i32 %n, -1
  %1 = sext i32 %0 to i64
  %scevgep92 = getelementptr [1000 x double]* %u, i64 1, i64 %1
  %2 = icmp ult double* %scevgep92, %scevgep91
  %umin = select i1 %2, double* %scevgep92, double* %scevgep91
  %scevgep93 = getelementptr double* %scevgep91, i64 %1
  %3 = icmp ult double* %scevgep93, %umin
  %umin94 = select i1 %3, double* %scevgep93, double* %umin
  %4 = icmp ult double* %scevgep91, %umin94
  %umin95 = select i1 %4, double* %scevgep91, double* %umin94
  %scevgep96 = getelementptr [1000 x double]* %u, i64 1, i64 1
  %5 = icmp ult double* %scevgep96, %umin95
  %umin97 = select i1 %5, double* %scevgep96, double* %umin95
  %scevgep98 = getelementptr [1000 x double]* %u, i64 1, i64 2
  %6 = icmp ult double* %scevgep98, %umin97
  %umin99 = select i1 %6, double* %scevgep98, double* %umin97
  %7 = add i32 %n, -2
  %8 = sext i32 %7 to i64
  %scevgep100 = getelementptr [1000 x double]* %u, i64 1, i64 %8
  %9 = icmp ult double* %scevgep100, %umin99
  %umin101 = select i1 %9, double* %scevgep100, double* %umin99
  %umin101145 = bitcast double* %umin101 to i8*
  %scevgep102103 = ptrtoint double* %scevgep91 to i64
  %10 = add i32 %n, -3
  %11 = zext i32 %10 to i64
  %12 = mul i64 8000, %11
  %13 = add i64 %scevgep102103, %12
  %scevgep104105 = ptrtoint double* %scevgep92 to i64
  %14 = add i64 %scevgep104105, %12
  %15 = icmp ugt i64 %14, %13
  %umax = select i1 %15, i64 %14, i64 %13
  %16 = mul i32 -1, %10
  %17 = add i32 %0, %16
  %18 = sext i32 %17 to i64
  %19 = mul i64 8, %18
  %20 = add i64 %13, %19
  %21 = icmp ugt i64 %20, %umax
  %umax106 = select i1 %21, i64 %20, i64 %umax
  %22 = mul i64 8, %11
  %23 = add i64 %scevgep102103, %22
  %24 = add i64 %23, %12
  %25 = icmp ugt i64 %24, %umax106
  %umax107 = select i1 %25, i64 %24, i64 %umax106
  %scevgep108109 = ptrtoint double* %scevgep96 to i64
  %26 = add i64 %scevgep108109, %22
  %27 = add i64 %26, %12
  %28 = icmp ugt i64 %27, %umax107
  %umax110 = select i1 %28, i64 %27, i64 %umax107
  %scevgep111112 = ptrtoint double* %scevgep98 to i64
  %29 = add i64 %scevgep111112, %22
  %30 = add i64 %29, %12
  %31 = icmp ugt i64 %30, %umax110
  %umax113 = select i1 %31, i64 %30, i64 %umax110
  %scevgep114115 = ptrtoint double* %scevgep100 to i64
  %32 = add i64 %scevgep114115, %12
  %33 = zext i32 %7 to i64
  %34 = add i64 %33, -1
  %35 = mul i64 -8, %34
  %36 = add i64 %32, %35
  %37 = icmp ugt i64 %36, %umax113
  %umax116 = select i1 %37, i64 %36, i64 %umax113
  %umax116146 = inttoptr i64 %umax116 to i8*
  %scevgep117 = getelementptr [1000 x double]* %v, i64 0, i64 1
  %38 = mul i64 1000, %1
  %scevgep118 = getelementptr double* %scevgep117, i64 %38
  %scevgep119 = getelementptr [1000 x double]* %v, i64 %8, i64 1
  %39 = icmp ult double* %scevgep119, %scevgep118
  %umin120 = select i1 %39, double* %scevgep119, double* %scevgep118
  %40 = icmp ult double* %scevgep117, %umin120
  %umin121 = select i1 %40, double* %scevgep117, double* %umin120
  %scevgep122 = getelementptr [1000 x double]* %v, i64 1, i64 1
  %41 = icmp ult double* %scevgep122, %umin121
  %umin123 = select i1 %41, double* %scevgep122, double* %umin121
  %scevgep124 = getelementptr [1000 x double]* %v, i64 2, i64 1
  %42 = icmp ult double* %scevgep124, %umin123
  %umin125 = select i1 %42, double* %scevgep124, double* %umin123
  %43 = icmp ult double* %scevgep117, %umin125
  %umin126 = select i1 %43, double* %scevgep117, double* %umin125
  %scevgep127 = getelementptr [1000 x double]* %v, i64 %1, i64 1
  %44 = icmp ult double* %scevgep127, %umin126
  %umin128 = select i1 %44, double* %scevgep127, double* %umin126
  %umin128147 = bitcast double* %umin128 to i8*
  %45 = mul i64 8000, %18
  %scevgep129130 = ptrtoint double* %scevgep117 to i64
  %46 = add i64 %scevgep129130, %22
  %47 = add i64 %46, %45
  %scevgep131132 = ptrtoint double* %scevgep119 to i64
  %48 = add i64 %scevgep131132, %22
  %49 = mul i64 -8000, %34
  %50 = add i64 %48, %49
  %51 = icmp ugt i64 %50, %47
  %umax133 = select i1 %51, i64 %50, i64 %47
  %52 = add i64 %scevgep129130, %12
  %53 = add i64 %52, %22
  %54 = icmp ugt i64 %53, %umax133
  %umax134 = select i1 %54, i64 %53, i64 %umax133
  %scevgep135136 = ptrtoint double* %scevgep122 to i64
  %55 = add i64 %scevgep135136, %12
  %56 = add i64 %55, %22
  %57 = icmp ugt i64 %56, %umax134
  %umax137 = select i1 %57, i64 %56, i64 %umax134
  %scevgep138139 = ptrtoint double* %scevgep124 to i64
  %58 = add i64 %scevgep138139, %12
  %59 = add i64 %58, %22
  %60 = icmp ugt i64 %59, %umax137
  %umax140 = select i1 %60, i64 %59, i64 %umax137
  %61 = icmp ugt i64 %46, %umax140
  %umax141 = select i1 %61, i64 %46, i64 %umax140
  %scevgep142143 = ptrtoint double* %scevgep127 to i64
  %62 = add i64 %scevgep142143, %22
  %63 = icmp ugt i64 %62, %umax141
  %umax144 = select i1 %63, i64 %62, i64 %umax141
  %umax144148 = inttoptr i64 %umax144 to i8*
  %64 = icmp ult i8* %umax116146, %umin128147
  %65 = icmp ult i8* %umax144148, %umin101145
  %pair-no-alias = or i1 %64, %65
  %scevgep149 = getelementptr [1000 x double]* %p, i64 1, i64 %8
  %scevgep150 = getelementptr [1000 x double]* %p, i64 1, i64 0
  %66 = icmp ult double* %scevgep150, %scevgep149
  %umin151 = select i1 %66, double* %scevgep150, double* %scevgep149
  %scevgep153 = getelementptr [1000 x double]* %p, i64 1, i64 1
  %67 = icmp ult double* %scevgep153, %umin151
  %umin154 = select i1 %67, double* %scevgep153, double* %umin151
  %68 = icmp ult double* %scevgep149, %umin154
  %umin155 = select i1 %68, double* %scevgep149, double* %umin154
  %69 = icmp ult double* %scevgep150, %umin155
  %umin156 = select i1 %69, double* %scevgep150, double* %umin155
  %70 = icmp ult double* %scevgep153, %umin156
  %umin158 = select i1 %70, double* %scevgep153, double* %umin156
  %umin158172 = bitcast double* %umin158 to i8*
  %scevgep159160 = ptrtoint double* %scevgep149 to i64
  %71 = add i64 %scevgep159160, %12
  %72 = add i64 %71, %35
  %scevgep161162 = ptrtoint double* %scevgep150 to i64
  %73 = add i64 %scevgep161162, %12
  %74 = icmp ugt i64 %73, %72
  %umax163 = select i1 %74, i64 %73, i64 %72
  %75 = add i64 %73, %22
  %76 = icmp ugt i64 %75, %umax163
  %umax164 = select i1 %76, i64 %75, i64 %umax163
  %scevgep165166 = ptrtoint double* %scevgep153 to i64
  %77 = add i64 %scevgep165166, %12
  %78 = add i64 %77, %22
  %79 = icmp ugt i64 %78, %umax164
  %umax167 = select i1 %79, i64 %78, i64 %umax164
  %80 = icmp ugt i64 %72, %umax167
  %umax168 = select i1 %80, i64 %72, i64 %umax167
  %81 = icmp ugt i64 %73, %umax168
  %umax169 = select i1 %81, i64 %73, i64 %umax168
  %82 = icmp ugt i64 %75, %umax169
  %umax170 = select i1 %82, i64 %75, i64 %umax169
  %83 = icmp ugt i64 %78, %umax170
  %umax171 = select i1 %83, i64 %78, i64 %umax170
  %umax171173 = inttoptr i64 %umax171 to i8*
  %84 = icmp ult i8* %umax116146, %umin158172
  %85 = icmp ult i8* %umax171173, %umin101145
  %pair-no-alias174 = or i1 %84, %85
  %86 = and i1 %pair-no-alias, %pair-no-alias174
  %scevgep175 = getelementptr [1000 x double]* %q, i64 1, i64 %8
  %scevgep176 = getelementptr [1000 x double]* %q, i64 1, i64 0
  %87 = icmp ult double* %scevgep176, %scevgep175
  %umin177 = select i1 %87, double* %scevgep176, double* %scevgep175
  %scevgep179 = getelementptr [1000 x double]* %q, i64 1, i64 1
  %88 = icmp ult double* %scevgep179, %umin177
  %umin180 = select i1 %88, double* %scevgep179, double* %umin177
  %89 = icmp ult double* %scevgep176, %umin180
  %umin181 = select i1 %89, double* %scevgep176, double* %umin180
  %90 = icmp ult double* %scevgep179, %umin181
  %umin183 = select i1 %90, double* %scevgep179, double* %umin181
  %91 = icmp ult double* %scevgep175, %umin183
  %umin184 = select i1 %91, double* %scevgep175, double* %umin183
  %umin184198 = bitcast double* %umin184 to i8*
  %scevgep185186 = ptrtoint double* %scevgep175 to i64
  %92 = add i64 %scevgep185186, %12
  %93 = add i64 %92, %35
  %scevgep187188 = ptrtoint double* %scevgep176 to i64
  %94 = add i64 %scevgep187188, %12
  %95 = icmp ugt i64 %94, %93
  %umax189 = select i1 %95, i64 %94, i64 %93
  %96 = add i64 %94, %22
  %97 = icmp ugt i64 %96, %umax189
  %umax190 = select i1 %97, i64 %96, i64 %umax189
  %scevgep191192 = ptrtoint double* %scevgep179 to i64
  %98 = add i64 %scevgep191192, %12
  %99 = add i64 %98, %22
  %100 = icmp ugt i64 %99, %umax190
  %umax193 = select i1 %100, i64 %99, i64 %umax190
  %101 = icmp ugt i64 %94, %umax193
  %umax194 = select i1 %101, i64 %94, i64 %umax193
  %102 = icmp ugt i64 %96, %umax194
  %umax195 = select i1 %102, i64 %96, i64 %umax194
  %103 = icmp ugt i64 %99, %umax195
  %umax196 = select i1 %103, i64 %99, i64 %umax195
  %104 = icmp ugt i64 %93, %umax196
  %umax197 = select i1 %104, i64 %93, i64 %umax196
  %umax197199 = inttoptr i64 %umax197 to i8*
  %105 = icmp ult i8* %umax116146, %umin184198
  %106 = icmp ult i8* %umax197199, %umin101145
  %pair-no-alias200 = or i1 %105, %106
  %107 = and i1 %86, %pair-no-alias200
  %108 = icmp ult i8* %umax144148, %umin158172
  %109 = icmp ult i8* %umax171173, %umin128147
  %pair-no-alias201 = or i1 %108, %109
  %110 = and i1 %107, %pair-no-alias201
  %111 = icmp ult i8* %umax144148, %umin184198
  %112 = icmp ult i8* %umax197199, %umin128147
  %pair-no-alias202 = or i1 %111, %112
  %113 = and i1 %110, %pair-no-alias202
  %114 = icmp ult i8* %umax171173, %umin184198
  %115 = icmp ult i8* %umax197199, %umin158172
  %pair-no-alias203 = or i1 %114, %115
  %116 = and i1 %113, %pair-no-alias203
  br i1 %116, label %polly.start, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  %117 = sitofp i32 %n to double
  %118 = fdiv double 1.000000e+00, %117
  %119 = sitofp i32 %tsteps to double
  %120 = fdiv double 1.000000e+00, %119
  %121 = fmul double %120, 2.000000e+00
  %122 = fmul double %118, %118
  %123 = fdiv double %121, %122
  %124 = fdiv double %120, %122
  %125 = fmul double %123, -5.000000e-01
  %126 = fadd double %123, 1.000000e+00
  %127 = fmul double %124, -5.000000e-01
  %128 = fadd double %124, 1.000000e+00
  %129 = icmp slt i32 %tsteps, 1
  br i1 %129, label %.region.clone, label %.preheader1.lr.ph.clone

.preheader1.lr.ph.clone:                          ; preds = %.split.split.clone
  %130 = add i64 %11, 1
  %131 = zext i32 %0 to i64
  %132 = add nsw i32 %n, -1
  %133 = icmp sgt i32 %132, 1
  %134 = add nsw i32 %n, -2
  %135 = icmp sgt i32 %134, 0
  %136 = fsub double -0.000000e+00, %127
  %137 = fmul double %125, 2.000000e+00
  %138 = fadd double %137, 1.000000e+00
  %139 = fsub double -0.000000e+00, %125
  %140 = fmul double %127, 2.000000e+00
  %141 = fadd double %140, 1.000000e+00
  br label %.preheader1.clone

.preheader1.clone:                                ; preds = %._crit_edge21.clone, %.preheader1.lr.ph.clone
  %indvar88.clone = phi i32 [ %indvar.next89.clone, %._crit_edge21.clone ], [ 0, %.preheader1.lr.ph.clone ]
  br i1 %133, label %.lr.ph9.clone, label %.preheader.clone

.lr.ph9.clone:                                    ; preds = %.preheader1.clone, %._crit_edge6.clone
  %indvar24.clone = phi i64 [ %142, %._crit_edge6.clone ], [ 0, %.preheader1.clone ]
  %142 = add i64 %indvar24.clone, 1
  %143 = add i64 %indvar24.clone, 2
  %scevgep49.clone = getelementptr [1000 x double]* %v, i64 0, i64 %142
  %scevgep51.clone = getelementptr [1000 x double]* %p, i64 %142, i64 0
  %scevgep52.clone = getelementptr [1000 x double]* %q, i64 %142, i64 0
  %scevgep53.clone = getelementptr [1000 x double]* %v, i64 %1, i64 %142
  store double 1.000000e+00, double* %scevgep49.clone, align 8, !tbaa !6
  store double 0.000000e+00, double* %scevgep51.clone, align 8, !tbaa !6
  %144 = load double* %scevgep49.clone, align 8, !tbaa !6
  store double %144, double* %scevgep52.clone, align 8, !tbaa !6
  br i1 %133, label %.lr.ph.clone, label %._crit_edge.clone

.lr.ph.clone:                                     ; preds = %.lr.ph9.clone, %.lr.ph.clone
  %indvar.clone = phi i64 [ %145, %.lr.ph.clone ], [ 0, %.lr.ph9.clone ]
  %145 = add i64 %indvar.clone, 1
  %scevgep28.clone = getelementptr [1000 x double]* %u, i64 %145, i64 %143
  %scevgep26.clone = getelementptr [1000 x double]* %u, i64 %145, i64 %indvar24.clone
  %scevgep31.clone = getelementptr [1000 x double]* %q, i64 %142, i64 %indvar.clone
  %scevgep30.clone = getelementptr [1000 x double]* %p, i64 %142, i64 %indvar.clone
  %scevgep29.clone = getelementptr [1000 x double]* %q, i64 %142, i64 %145
  %scevgep27.clone = getelementptr [1000 x double]* %u, i64 %145, i64 %142
  %scevgep.clone = getelementptr [1000 x double]* %p, i64 %142, i64 %145
  %146 = load double* %scevgep30.clone, align 8, !tbaa !6
  %147 = fmul double %125, %146
  %148 = fadd double %126, %147
  %149 = fdiv double %139, %148
  store double %149, double* %scevgep.clone, align 8, !tbaa !6
  %150 = load double* %scevgep26.clone, align 8, !tbaa !6
  %151 = fmul double %127, %150
  %152 = load double* %scevgep27.clone, align 8, !tbaa !6
  %153 = fmul double %141, %152
  %154 = fsub double %153, %151
  %155 = load double* %scevgep28.clone, align 8, !tbaa !6
  %156 = fmul double %127, %155
  %157 = fsub double %154, %156
  %158 = load double* %scevgep31.clone, align 8, !tbaa !6
  %159 = fmul double %125, %158
  %160 = fsub double %157, %159
  %161 = load double* %scevgep30.clone, align 8, !tbaa !6
  %162 = fmul double %125, %161
  %163 = fadd double %126, %162
  %164 = fdiv double %160, %163
  store double %164, double* %scevgep29.clone, align 8, !tbaa !6
  %exitcond.clone = icmp ne i64 %145, %130
  br i1 %exitcond.clone, label %.lr.ph.clone, label %._crit_edge.clone

._crit_edge.clone:                                ; preds = %.lr.ph.clone, %.lr.ph9.clone
  store double 1.000000e+00, double* %scevgep53.clone, align 8, !tbaa !6
  br i1 %135, label %.lr.ph5.clone, label %._crit_edge6.clone

.lr.ph5.clone:                                    ; preds = %._crit_edge.clone, %.lr.ph5.clone
  %indvar32.clone = phi i64 [ %indvar.next33.clone, %.lr.ph5.clone ], [ 0, %._crit_edge.clone ]
  %165 = mul i64 %indvar32.clone, -1
  %166 = add i64 %8, %165
  %scevgep37.clone = getelementptr [1000 x double]* %v, i64 %166, i64 %142
  %scevgep36.clone = getelementptr [1000 x double]* %q, i64 %142, i64 %166
  %scevgep35.clone = getelementptr [1000 x double]* %p, i64 %142, i64 %166
  %167 = add i64 %131, %165
  %168 = trunc i64 %167 to i32
  %169 = sext i32 %168 to i64
  %170 = mul i64 %169, 1000
  %scevgep50.clone = getelementptr double* %scevgep49.clone, i64 %170
  %171 = load double* %scevgep35.clone, align 8, !tbaa !6
  %172 = load double* %scevgep50.clone, align 8, !tbaa !6
  %173 = fmul double %171, %172
  %174 = load double* %scevgep36.clone, align 8, !tbaa !6
  %175 = fadd double %173, %174
  store double %175, double* %scevgep37.clone, align 8, !tbaa !6
  %indvar.next33.clone = add i64 %indvar32.clone, 1
  %exitcond34.clone = icmp ne i64 %indvar.next33.clone, %33
  br i1 %exitcond34.clone, label %.lr.ph5.clone, label %._crit_edge6.clone

._crit_edge6.clone:                               ; preds = %.lr.ph5.clone, %._crit_edge.clone
  %exitcond38.clone = icmp ne i64 %142, %130
  br i1 %exitcond38.clone, label %.lr.ph9.clone, label %.preheader.clone

.preheader.clone:                                 ; preds = %._crit_edge6.clone, %.preheader1.clone
  br i1 %133, label %.lr.ph20.clone, label %._crit_edge21.clone

.lr.ph20.clone:                                   ; preds = %.preheader.clone, %._crit_edge17.clone
  %indvar57.clone = phi i64 [ %176, %._crit_edge17.clone ], [ 0, %.preheader.clone ]
  %176 = add i64 %indvar57.clone, 1
  %177 = add i64 %indvar57.clone, 2
  %scevgep83.clone = getelementptr [1000 x double]* %u, i64 %176, i64 0
  %scevgep85.clone = getelementptr [1000 x double]* %p, i64 %176, i64 0
  %scevgep86.clone = getelementptr [1000 x double]* %q, i64 %176, i64 0
  %scevgep87.clone = getelementptr [1000 x double]* %u, i64 %176, i64 %1
  store double 1.000000e+00, double* %scevgep83.clone, align 8, !tbaa !6
  store double 0.000000e+00, double* %scevgep85.clone, align 8, !tbaa !6
  %178 = load double* %scevgep83.clone, align 8, !tbaa !6
  store double %178, double* %scevgep86.clone, align 8, !tbaa !6
  br i1 %133, label %.lr.ph12.clone, label %._crit_edge13.clone

.lr.ph12.clone:                                   ; preds = %.lr.ph20.clone, %.lr.ph12.clone
  %indvar54.clone = phi i64 [ %179, %.lr.ph12.clone ], [ 0, %.lr.ph20.clone ]
  %179 = add i64 %indvar54.clone, 1
  %scevgep62.clone = getelementptr [1000 x double]* %v, i64 %177, i64 %179
  %scevgep60.clone = getelementptr [1000 x double]* %v, i64 %indvar57.clone, i64 %179
  %scevgep65.clone = getelementptr [1000 x double]* %q, i64 %176, i64 %indvar54.clone
  %scevgep64.clone = getelementptr [1000 x double]* %p, i64 %176, i64 %indvar54.clone
  %scevgep63.clone = getelementptr [1000 x double]* %q, i64 %176, i64 %179
  %scevgep61.clone = getelementptr [1000 x double]* %v, i64 %176, i64 %179
  %scevgep59.clone = getelementptr [1000 x double]* %p, i64 %176, i64 %179
  %180 = load double* %scevgep64.clone, align 8, !tbaa !6
  %181 = fmul double %127, %180
  %182 = fadd double %128, %181
  %183 = fdiv double %136, %182
  store double %183, double* %scevgep59.clone, align 8, !tbaa !6
  %184 = load double* %scevgep60.clone, align 8, !tbaa !6
  %185 = fmul double %125, %184
  %186 = load double* %scevgep61.clone, align 8, !tbaa !6
  %187 = fmul double %138, %186
  %188 = fsub double %187, %185
  %189 = load double* %scevgep62.clone, align 8, !tbaa !6
  %190 = fmul double %125, %189
  %191 = fsub double %188, %190
  %192 = load double* %scevgep65.clone, align 8, !tbaa !6
  %193 = fmul double %127, %192
  %194 = fsub double %191, %193
  %195 = load double* %scevgep64.clone, align 8, !tbaa !6
  %196 = fmul double %127, %195
  %197 = fadd double %128, %196
  %198 = fdiv double %194, %197
  store double %198, double* %scevgep63.clone, align 8, !tbaa !6
  %exitcond56.clone = icmp ne i64 %179, %130
  br i1 %exitcond56.clone, label %.lr.ph12.clone, label %._crit_edge13.clone

._crit_edge13.clone:                              ; preds = %.lr.ph12.clone, %.lr.ph20.clone
  store double 1.000000e+00, double* %scevgep87.clone, align 8, !tbaa !6
  br i1 %135, label %.lr.ph16.clone, label %._crit_edge17.clone

.lr.ph16.clone:                                   ; preds = %._crit_edge13.clone, %.lr.ph16.clone
  %indvar66.clone = phi i64 [ %indvar.next67.clone, %.lr.ph16.clone ], [ 0, %._crit_edge13.clone ]
  %199 = mul i64 %indvar66.clone, -1
  %200 = add i64 %8, %199
  %scevgep71.clone = getelementptr [1000 x double]* %u, i64 %176, i64 %200
  %scevgep70.clone = getelementptr [1000 x double]* %q, i64 %176, i64 %200
  %scevgep69.clone = getelementptr [1000 x double]* %p, i64 %176, i64 %200
  %201 = add i64 %131, %199
  %202 = trunc i64 %201 to i32
  %203 = sext i32 %202 to i64
  %scevgep84.clone = getelementptr double* %scevgep83.clone, i64 %203
  %204 = load double* %scevgep69.clone, align 8, !tbaa !6
  %205 = load double* %scevgep84.clone, align 8, !tbaa !6
  %206 = fmul double %204, %205
  %207 = load double* %scevgep70.clone, align 8, !tbaa !6
  %208 = fadd double %206, %207
  store double %208, double* %scevgep71.clone, align 8, !tbaa !6
  %indvar.next67.clone = add i64 %indvar66.clone, 1
  %exitcond68.clone = icmp ne i64 %indvar.next67.clone, %33
  br i1 %exitcond68.clone, label %.lr.ph16.clone, label %._crit_edge17.clone

._crit_edge17.clone:                              ; preds = %.lr.ph16.clone, %._crit_edge13.clone
  %exitcond72.clone = icmp ne i64 %176, %130
  br i1 %exitcond72.clone, label %.lr.ph20.clone, label %._crit_edge21.clone

._crit_edge21.clone:                              ; preds = %._crit_edge17.clone, %.preheader.clone
  %indvar.next89.clone = add i32 %indvar88.clone, 1
  %exitcond90.clone = icmp ne i32 %indvar.next89.clone, %tsteps
  br i1 %exitcond90.clone, label %.preheader1.clone, label %.region.clone

.region.clone:                                    ; preds = %polly.then412, %polly.loop_exit510, %polly.cond410, %polly.start, %._crit_edge21.clone, %.split.split.clone
  ret void

polly.start:                                      ; preds = %.split
  %209 = sext i32 %n to i64
  %210 = icmp sge i64 %209, 3
  %211 = sext i32 %tsteps to i64
  %212 = icmp sge i64 %211, 1
  %213 = and i1 %210, %212
  br i1 %213, label %polly.cond283, label %.region.clone

polly.cond283:                                    ; preds = %polly.start
  %214 = icmp sge i64 %33, 1
  br i1 %214, label %polly.then285, label %polly.cond410

polly.cond410:                                    ; preds = %polly.then285, %polly.loop_exit350, %polly.cond283
  %215 = icmp sle i64 %33, 0
  br i1 %215, label %polly.then412, label %.region.clone

polly.then285:                                    ; preds = %polly.cond283
  %216 = add i64 %211, -1
  %polly.loop_guard = icmp sle i64 0, %216
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond410

polly.loop_header:                                ; preds = %polly.then285, %polly.loop_exit350
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit350 ], [ 0, %polly.then285 ]
  br i1 true, label %polly.loop_header287, label %polly.loop_exit289

polly.loop_exit289:                               ; preds = %polly.loop_exit329, %polly.loop_header
  br i1 true, label %polly.loop_header348, label %polly.loop_exit350

polly.loop_exit350:                               ; preds = %polly.loop_exit393, %polly.loop_exit289
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %216, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond410

polly.loop_header287:                             ; preds = %polly.loop_header, %polly.loop_exit329
  %polly.indvar291 = phi i64 [ %polly.indvar_next292, %polly.loop_exit329 ], [ 0, %polly.loop_header ]
  %p_.moved.to. = add nsw i32 %n, -1
  %p_ = add i64 %polly.indvar291, 1
  %p_scevgep49 = getelementptr [1000 x double]* %v, i64 0, i64 %p_
  %p_scevgep51 = getelementptr [1000 x double]* %p, i64 %p_, i64 0
  %p_scevgep52 = getelementptr [1000 x double]* %q, i64 %p_, i64 0
  store double 1.000000e+00, double* %p_scevgep49
  store double 0.000000e+00, double* %p_scevgep51
  %_p_scalar_ = load double* %p_scevgep49
  store double %_p_scalar_, double* %p_scevgep52
  br i1 true, label %polly.loop_header296, label %polly.loop_exit298

polly.loop_exit298:                               ; preds = %polly.loop_header296, %polly.loop_header287
  %p_scevgep53.moved.to. = getelementptr [1000 x double]* %v, i64 %1, i64 %p_
  %p_.moved.to.231 = add nsw i32 %n, -2
  store double 1.000000e+00, double* %p_scevgep53.moved.to.
  %polly.loop_guard330 = icmp sle i64 0, %34
  br i1 %polly.loop_guard330, label %polly.loop_header327, label %polly.loop_exit329

polly.loop_exit329:                               ; preds = %polly.loop_header327, %polly.loop_exit298
  %polly.indvar_next292 = add nsw i64 %polly.indvar291, 1
  %polly.adjust_ub293 = sub i64 %11, 1
  %polly.loop_cond294 = icmp sle i64 %polly.indvar291, %polly.adjust_ub293
  br i1 %polly.loop_cond294, label %polly.loop_header287, label %polly.loop_exit289

polly.loop_header296:                             ; preds = %polly.loop_header287, %polly.loop_header296
  %polly.indvar300 = phi i64 [ %polly.indvar_next301, %polly.loop_header296 ], [ 0, %polly.loop_header287 ]
  %p_.moved.to.207 = sitofp i32 %tsteps to double
  %p_.moved.to.208 = fdiv double 1.000000e+00, %p_.moved.to.207
  %p_.moved.to.209 = fmul double %p_.moved.to.208, 2.000000e+00
  %p_.moved.to.210 = sitofp i32 %n to double
  %p_.moved.to.211 = fdiv double 1.000000e+00, %p_.moved.to.210
  %p_.moved.to.212 = fmul double %p_.moved.to.211, %p_.moved.to.211
  %p_.moved.to.213 = fdiv double %p_.moved.to.209, %p_.moved.to.212
  %p_.moved.to.214 = fmul double %p_.moved.to.213, -5.000000e-01
  %p_.moved.to.215 = fsub double -0.000000e+00, %p_.moved.to.214
  %p_.moved.to.216 = fadd double %p_.moved.to.213, 1.000000e+00
  %p_.moved.to.217 = add i64 %polly.indvar291, 2
  %p_.moved.to.221 = fdiv double %p_.moved.to.208, %p_.moved.to.212
  %p_.moved.to.222 = fmul double %p_.moved.to.221, -5.000000e-01
  %p_.moved.to.223 = fmul double %p_.moved.to.222, 2.000000e+00
  %p_.moved.to.224 = fadd double %p_.moved.to.223, 1.000000e+00
  %p_.moved.to.227 = add i64 %11, 1
  %p_305 = add i64 %polly.indvar300, 1
  %p_scevgep28 = getelementptr [1000 x double]* %u, i64 %p_305, i64 %p_.moved.to.217
  %p_scevgep26 = getelementptr [1000 x double]* %u, i64 %p_305, i64 %polly.indvar291
  %p_scevgep31 = getelementptr [1000 x double]* %q, i64 %p_, i64 %polly.indvar300
  %p_scevgep30 = getelementptr [1000 x double]* %p, i64 %p_, i64 %polly.indvar300
  %p_scevgep29 = getelementptr [1000 x double]* %q, i64 %p_, i64 %p_305
  %p_scevgep27 = getelementptr [1000 x double]* %u, i64 %p_305, i64 %p_
  %p_scevgep = getelementptr [1000 x double]* %p, i64 %p_, i64 %p_305
  %_p_scalar_306 = load double* %p_scevgep30
  %p_307 = fmul double %p_.moved.to.214, %_p_scalar_306
  %p_308 = fadd double %p_.moved.to.216, %p_307
  %p_309 = fdiv double %p_.moved.to.215, %p_308
  store double %p_309, double* %p_scevgep
  %_p_scalar_310 = load double* %p_scevgep26
  %p_311 = fmul double %p_.moved.to.222, %_p_scalar_310
  %_p_scalar_312 = load double* %p_scevgep27
  %p_313 = fmul double %p_.moved.to.224, %_p_scalar_312
  %p_314 = fsub double %p_313, %p_311
  %_p_scalar_315 = load double* %p_scevgep28
  %p_316 = fmul double %p_.moved.to.222, %_p_scalar_315
  %p_317 = fsub double %p_314, %p_316
  %_p_scalar_318 = load double* %p_scevgep31
  %p_319 = fmul double %p_.moved.to.214, %_p_scalar_318
  %p_320 = fsub double %p_317, %p_319
  %_p_scalar_321 = load double* %p_scevgep30
  %p_322 = fmul double %p_.moved.to.214, %_p_scalar_321
  %p_323 = fadd double %p_.moved.to.216, %p_322
  %p_324 = fdiv double %p_320, %p_323
  store double %p_324, double* %p_scevgep29
  %polly.indvar_next301 = add nsw i64 %polly.indvar300, 1
  %polly.adjust_ub302 = sub i64 %11, 1
  %polly.loop_cond303 = icmp sle i64 %polly.indvar300, %polly.adjust_ub302
  br i1 %polly.loop_cond303, label %polly.loop_header296, label %polly.loop_exit298

polly.loop_header327:                             ; preds = %polly.loop_exit298, %polly.loop_header327
  %polly.indvar331 = phi i64 [ %polly.indvar_next332, %polly.loop_header327 ], [ 0, %polly.loop_exit298 ]
  %p_.moved.to.237 = zext i32 %0 to i64
  %p_336 = mul i64 %polly.indvar331, -1
  %p_337 = add i64 %8, %p_336
  %p_scevgep37 = getelementptr [1000 x double]* %v, i64 %p_337, i64 %p_
  %p_scevgep36 = getelementptr [1000 x double]* %q, i64 %p_, i64 %p_337
  %p_scevgep35 = getelementptr [1000 x double]* %p, i64 %p_, i64 %p_337
  %p_338 = add i64 %p_.moved.to.237, %p_336
  %p_339 = trunc i64 %p_338 to i32
  %p_340 = sext i32 %p_339 to i64
  %p_341 = mul i64 %p_340, 1000
  %p_scevgep50 = getelementptr double* %p_scevgep49, i64 %p_341
  %_p_scalar_342 = load double* %p_scevgep35
  %_p_scalar_343 = load double* %p_scevgep50
  %p_344 = fmul double %_p_scalar_342, %_p_scalar_343
  %_p_scalar_345 = load double* %p_scevgep36
  %p_346 = fadd double %p_344, %_p_scalar_345
  store double %p_346, double* %p_scevgep37
  %p_indvar.next33 = add i64 %polly.indvar331, 1
  %polly.indvar_next332 = add nsw i64 %polly.indvar331, 1
  %polly.adjust_ub333 = sub i64 %34, 1
  %polly.loop_cond334 = icmp sle i64 %polly.indvar331, %polly.adjust_ub333
  br i1 %polly.loop_cond334, label %polly.loop_header327, label %polly.loop_exit329

polly.loop_header348:                             ; preds = %polly.loop_exit289, %polly.loop_exit393
  %polly.indvar352 = phi i64 [ %polly.indvar_next353, %polly.loop_exit393 ], [ 0, %polly.loop_exit289 ]
  %p_.moved.to.244 = add nsw i32 %n, -1
  %p_357 = add i64 %polly.indvar352, 1
  %p_scevgep83 = getelementptr [1000 x double]* %u, i64 %p_357, i64 0
  %p_scevgep85 = getelementptr [1000 x double]* %p, i64 %p_357, i64 0
  %p_scevgep86 = getelementptr [1000 x double]* %q, i64 %p_357, i64 0
  store double 1.000000e+00, double* %p_scevgep83
  store double 0.000000e+00, double* %p_scevgep85
  %_p_scalar_358 = load double* %p_scevgep83
  store double %_p_scalar_358, double* %p_scevgep86
  br i1 true, label %polly.loop_header360, label %polly.loop_exit362

polly.loop_exit362:                               ; preds = %polly.loop_header360, %polly.loop_header348
  %p_scevgep87.moved.to. = getelementptr [1000 x double]* %u, i64 %p_357, i64 %1
  %p_.moved.to.271 = add nsw i32 %n, -2
  store double 1.000000e+00, double* %p_scevgep87.moved.to.
  %polly.loop_guard394 = icmp sle i64 0, %34
  br i1 %polly.loop_guard394, label %polly.loop_header391, label %polly.loop_exit393

polly.loop_exit393:                               ; preds = %polly.loop_header391, %polly.loop_exit362
  %polly.indvar_next353 = add nsw i64 %polly.indvar352, 1
  %polly.adjust_ub354 = sub i64 %11, 1
  %polly.loop_cond355 = icmp sle i64 %polly.indvar352, %polly.adjust_ub354
  br i1 %polly.loop_cond355, label %polly.loop_header348, label %polly.loop_exit350

polly.loop_header360:                             ; preds = %polly.loop_header348, %polly.loop_header360
  %polly.indvar364 = phi i64 [ %polly.indvar_next365, %polly.loop_header360 ], [ 0, %polly.loop_header348 ]
  %p_.moved.to.247 = sitofp i32 %tsteps to double
  %p_.moved.to.248 = fdiv double 1.000000e+00, %p_.moved.to.247
  %p_.moved.to.249 = sitofp i32 %n to double
  %p_.moved.to.250 = fdiv double 1.000000e+00, %p_.moved.to.249
  %p_.moved.to.251 = fmul double %p_.moved.to.250, %p_.moved.to.250
  %p_.moved.to.252 = fdiv double %p_.moved.to.248, %p_.moved.to.251
  %p_.moved.to.253 = fmul double %p_.moved.to.252, -5.000000e-01
  %p_.moved.to.254 = fsub double -0.000000e+00, %p_.moved.to.253
  %p_.moved.to.255 = fadd double %p_.moved.to.252, 1.000000e+00
  %p_.moved.to.256 = add i64 %polly.indvar352, 2
  %p_.moved.to.257 = fmul double %p_.moved.to.248, 2.000000e+00
  %p_.moved.to.261 = fdiv double %p_.moved.to.257, %p_.moved.to.251
  %p_.moved.to.262 = fmul double %p_.moved.to.261, -5.000000e-01
  %p_.moved.to.263 = fmul double %p_.moved.to.262, 2.000000e+00
  %p_.moved.to.264 = fadd double %p_.moved.to.263, 1.000000e+00
  %p_.moved.to.267 = add i64 %11, 1
  %p_369 = add i64 %polly.indvar364, 1
  %p_scevgep62 = getelementptr [1000 x double]* %v, i64 %p_.moved.to.256, i64 %p_369
  %p_scevgep60 = getelementptr [1000 x double]* %v, i64 %polly.indvar352, i64 %p_369
  %p_scevgep65 = getelementptr [1000 x double]* %q, i64 %p_357, i64 %polly.indvar364
  %p_scevgep64 = getelementptr [1000 x double]* %p, i64 %p_357, i64 %polly.indvar364
  %p_scevgep63 = getelementptr [1000 x double]* %q, i64 %p_357, i64 %p_369
  %p_scevgep61 = getelementptr [1000 x double]* %v, i64 %p_357, i64 %p_369
  %p_scevgep59 = getelementptr [1000 x double]* %p, i64 %p_357, i64 %p_369
  %_p_scalar_370 = load double* %p_scevgep64
  %p_371 = fmul double %p_.moved.to.253, %_p_scalar_370
  %p_372 = fadd double %p_.moved.to.255, %p_371
  %p_373 = fdiv double %p_.moved.to.254, %p_372
  store double %p_373, double* %p_scevgep59
  %_p_scalar_374 = load double* %p_scevgep60
  %p_375 = fmul double %p_.moved.to.262, %_p_scalar_374
  %_p_scalar_376 = load double* %p_scevgep61
  %p_377 = fmul double %p_.moved.to.264, %_p_scalar_376
  %p_378 = fsub double %p_377, %p_375
  %_p_scalar_379 = load double* %p_scevgep62
  %p_380 = fmul double %p_.moved.to.262, %_p_scalar_379
  %p_381 = fsub double %p_378, %p_380
  %_p_scalar_382 = load double* %p_scevgep65
  %p_383 = fmul double %p_.moved.to.253, %_p_scalar_382
  %p_384 = fsub double %p_381, %p_383
  %_p_scalar_385 = load double* %p_scevgep64
  %p_386 = fmul double %p_.moved.to.253, %_p_scalar_385
  %p_387 = fadd double %p_.moved.to.255, %p_386
  %p_388 = fdiv double %p_384, %p_387
  store double %p_388, double* %p_scevgep63
  %polly.indvar_next365 = add nsw i64 %polly.indvar364, 1
  %polly.adjust_ub366 = sub i64 %11, 1
  %polly.loop_cond367 = icmp sle i64 %polly.indvar364, %polly.adjust_ub366
  br i1 %polly.loop_cond367, label %polly.loop_header360, label %polly.loop_exit362

polly.loop_header391:                             ; preds = %polly.loop_exit362, %polly.loop_header391
  %polly.indvar395 = phi i64 [ %polly.indvar_next396, %polly.loop_header391 ], [ 0, %polly.loop_exit362 ]
  %p_.moved.to.277 = zext i32 %0 to i64
  %p_400 = mul i64 %polly.indvar395, -1
  %p_401 = add i64 %8, %p_400
  %p_scevgep71 = getelementptr [1000 x double]* %u, i64 %p_357, i64 %p_401
  %p_scevgep70 = getelementptr [1000 x double]* %q, i64 %p_357, i64 %p_401
  %p_scevgep69 = getelementptr [1000 x double]* %p, i64 %p_357, i64 %p_401
  %p_402 = add i64 %p_.moved.to.277, %p_400
  %p_403 = trunc i64 %p_402 to i32
  %p_404 = sext i32 %p_403 to i64
  %p_scevgep84 = getelementptr double* %p_scevgep83, i64 %p_404
  %_p_scalar_405 = load double* %p_scevgep69
  %_p_scalar_406 = load double* %p_scevgep84
  %p_407 = fmul double %_p_scalar_405, %_p_scalar_406
  %_p_scalar_408 = load double* %p_scevgep70
  %p_409 = fadd double %p_407, %_p_scalar_408
  store double %p_409, double* %p_scevgep71
  %p_indvar.next67 = add i64 %polly.indvar395, 1
  %polly.indvar_next396 = add nsw i64 %polly.indvar395, 1
  %polly.adjust_ub397 = sub i64 %34, 1
  %polly.loop_cond398 = icmp sle i64 %polly.indvar395, %polly.adjust_ub397
  br i1 %polly.loop_cond398, label %polly.loop_header391, label %polly.loop_exit393

polly.then412:                                    ; preds = %polly.cond410
  %217 = add i64 %211, -1
  %polly.loop_guard417 = icmp sle i64 0, %217
  br i1 %polly.loop_guard417, label %polly.loop_header414, label %.region.clone

polly.loop_header414:                             ; preds = %polly.then412, %polly.loop_exit510
  %polly.indvar418 = phi i64 [ %polly.indvar_next419, %polly.loop_exit510 ], [ 0, %polly.then412 ]
  br i1 true, label %polly.loop_header423, label %polly.loop_exit425

polly.loop_exit425:                               ; preds = %polly.loop_exit442, %polly.loop_header414
  br i1 true, label %polly.loop_header508, label %polly.loop_exit510

polly.loop_exit510:                               ; preds = %polly.loop_exit527, %polly.loop_exit425
  %polly.indvar_next419 = add nsw i64 %polly.indvar418, 1
  %polly.adjust_ub420 = sub i64 %217, 1
  %polly.loop_cond421 = icmp sle i64 %polly.indvar418, %polly.adjust_ub420
  br i1 %polly.loop_cond421, label %polly.loop_header414, label %.region.clone

polly.loop_header423:                             ; preds = %polly.loop_header414, %polly.loop_exit442
  %polly.indvar427 = phi i64 [ %polly.indvar_next428, %polly.loop_exit442 ], [ 0, %polly.loop_header414 ]
  %p_.moved.to.432 = add nsw i32 %n, -1
  %p_434 = add i64 %polly.indvar427, 1
  %p_scevgep49435 = getelementptr [1000 x double]* %v, i64 0, i64 %p_434
  %p_scevgep51436 = getelementptr [1000 x double]* %p, i64 %p_434, i64 0
  %p_scevgep52437 = getelementptr [1000 x double]* %q, i64 %p_434, i64 0
  store double 1.000000e+00, double* %p_scevgep49435
  store double 0.000000e+00, double* %p_scevgep51436
  %_p_scalar_438 = load double* %p_scevgep49435
  store double %_p_scalar_438, double* %p_scevgep52437
  br i1 true, label %polly.loop_header440, label %polly.loop_exit442

polly.loop_exit442:                               ; preds = %polly.loop_header440, %polly.loop_header423
  %p_scevgep53.moved.to.504 = getelementptr [1000 x double]* %v, i64 %1, i64 %p_434
  %p_.moved.to.231505 = add nsw i32 %n, -2
  store double 1.000000e+00, double* %p_scevgep53.moved.to.504
  %polly.indvar_next428 = add nsw i64 %polly.indvar427, 1
  %polly.adjust_ub429 = sub i64 %11, 1
  %polly.loop_cond430 = icmp sle i64 %polly.indvar427, %polly.adjust_ub429
  br i1 %polly.loop_cond430, label %polly.loop_header423, label %polly.loop_exit425

polly.loop_header440:                             ; preds = %polly.loop_header423, %polly.loop_header440
  %polly.indvar444 = phi i64 [ %polly.indvar_next445, %polly.loop_header440 ], [ 0, %polly.loop_header423 ]
  %p_.moved.to.207450 = sitofp i32 %tsteps to double
  %p_.moved.to.208451 = fdiv double 1.000000e+00, %p_.moved.to.207450
  %p_.moved.to.209452 = fmul double %p_.moved.to.208451, 2.000000e+00
  %p_.moved.to.210453 = sitofp i32 %n to double
  %p_.moved.to.211454 = fdiv double 1.000000e+00, %p_.moved.to.210453
  %p_.moved.to.212455 = fmul double %p_.moved.to.211454, %p_.moved.to.211454
  %p_.moved.to.213456 = fdiv double %p_.moved.to.209452, %p_.moved.to.212455
  %p_.moved.to.214457 = fmul double %p_.moved.to.213456, -5.000000e-01
  %p_.moved.to.215458 = fsub double -0.000000e+00, %p_.moved.to.214457
  %p_.moved.to.216459 = fadd double %p_.moved.to.213456, 1.000000e+00
  %p_.moved.to.217460 = add i64 %polly.indvar427, 2
  %p_.moved.to.221464 = fdiv double %p_.moved.to.208451, %p_.moved.to.212455
  %p_.moved.to.222465 = fmul double %p_.moved.to.221464, -5.000000e-01
  %p_.moved.to.223466 = fmul double %p_.moved.to.222465, 2.000000e+00
  %p_.moved.to.224467 = fadd double %p_.moved.to.223466, 1.000000e+00
  %p_.moved.to.227470 = add i64 %11, 1
  %p_471 = add i64 %polly.indvar444, 1
  %p_scevgep28472 = getelementptr [1000 x double]* %u, i64 %p_471, i64 %p_.moved.to.217460
  %p_scevgep26473 = getelementptr [1000 x double]* %u, i64 %p_471, i64 %polly.indvar427
  %p_scevgep31474 = getelementptr [1000 x double]* %q, i64 %p_434, i64 %polly.indvar444
  %p_scevgep30475 = getelementptr [1000 x double]* %p, i64 %p_434, i64 %polly.indvar444
  %p_scevgep29476 = getelementptr [1000 x double]* %q, i64 %p_434, i64 %p_471
  %p_scevgep27477 = getelementptr [1000 x double]* %u, i64 %p_471, i64 %p_434
  %p_scevgep478 = getelementptr [1000 x double]* %p, i64 %p_434, i64 %p_471
  %_p_scalar_479 = load double* %p_scevgep30475
  %p_480 = fmul double %p_.moved.to.214457, %_p_scalar_479
  %p_481 = fadd double %p_.moved.to.216459, %p_480
  %p_482 = fdiv double %p_.moved.to.215458, %p_481
  store double %p_482, double* %p_scevgep478
  %_p_scalar_483 = load double* %p_scevgep26473
  %p_484 = fmul double %p_.moved.to.222465, %_p_scalar_483
  %_p_scalar_485 = load double* %p_scevgep27477
  %p_486 = fmul double %p_.moved.to.224467, %_p_scalar_485
  %p_487 = fsub double %p_486, %p_484
  %_p_scalar_488 = load double* %p_scevgep28472
  %p_489 = fmul double %p_.moved.to.222465, %_p_scalar_488
  %p_490 = fsub double %p_487, %p_489
  %_p_scalar_491 = load double* %p_scevgep31474
  %p_492 = fmul double %p_.moved.to.214457, %_p_scalar_491
  %p_493 = fsub double %p_490, %p_492
  %_p_scalar_494 = load double* %p_scevgep30475
  %p_495 = fmul double %p_.moved.to.214457, %_p_scalar_494
  %p_496 = fadd double %p_.moved.to.216459, %p_495
  %p_497 = fdiv double %p_493, %p_496
  store double %p_497, double* %p_scevgep29476
  %polly.indvar_next445 = add nsw i64 %polly.indvar444, 1
  %polly.adjust_ub446 = sub i64 %11, 1
  %polly.loop_cond447 = icmp sle i64 %polly.indvar444, %polly.adjust_ub446
  br i1 %polly.loop_cond447, label %polly.loop_header440, label %polly.loop_exit442

polly.loop_header508:                             ; preds = %polly.loop_exit425, %polly.loop_exit527
  %polly.indvar512 = phi i64 [ %polly.indvar_next513, %polly.loop_exit527 ], [ 0, %polly.loop_exit425 ]
  %p_.moved.to.244517 = add nsw i32 %n, -1
  %p_519 = add i64 %polly.indvar512, 1
  %p_scevgep83520 = getelementptr [1000 x double]* %u, i64 %p_519, i64 0
  %p_scevgep85521 = getelementptr [1000 x double]* %p, i64 %p_519, i64 0
  %p_scevgep86522 = getelementptr [1000 x double]* %q, i64 %p_519, i64 0
  store double 1.000000e+00, double* %p_scevgep83520
  store double 0.000000e+00, double* %p_scevgep85521
  %_p_scalar_523 = load double* %p_scevgep83520
  store double %_p_scalar_523, double* %p_scevgep86522
  br i1 true, label %polly.loop_header525, label %polly.loop_exit527

polly.loop_exit527:                               ; preds = %polly.loop_header525, %polly.loop_header508
  %p_scevgep87.moved.to.589 = getelementptr [1000 x double]* %u, i64 %p_519, i64 %1
  %p_.moved.to.271590 = add nsw i32 %n, -2
  store double 1.000000e+00, double* %p_scevgep87.moved.to.589
  %polly.indvar_next513 = add nsw i64 %polly.indvar512, 1
  %polly.adjust_ub514 = sub i64 %11, 1
  %polly.loop_cond515 = icmp sle i64 %polly.indvar512, %polly.adjust_ub514
  br i1 %polly.loop_cond515, label %polly.loop_header508, label %polly.loop_exit510

polly.loop_header525:                             ; preds = %polly.loop_header508, %polly.loop_header525
  %polly.indvar529 = phi i64 [ %polly.indvar_next530, %polly.loop_header525 ], [ 0, %polly.loop_header508 ]
  %p_.moved.to.247535 = sitofp i32 %tsteps to double
  %p_.moved.to.248536 = fdiv double 1.000000e+00, %p_.moved.to.247535
  %p_.moved.to.249537 = sitofp i32 %n to double
  %p_.moved.to.250538 = fdiv double 1.000000e+00, %p_.moved.to.249537
  %p_.moved.to.251539 = fmul double %p_.moved.to.250538, %p_.moved.to.250538
  %p_.moved.to.252540 = fdiv double %p_.moved.to.248536, %p_.moved.to.251539
  %p_.moved.to.253541 = fmul double %p_.moved.to.252540, -5.000000e-01
  %p_.moved.to.254542 = fsub double -0.000000e+00, %p_.moved.to.253541
  %p_.moved.to.255543 = fadd double %p_.moved.to.252540, 1.000000e+00
  %p_.moved.to.256544 = add i64 %polly.indvar512, 2
  %p_.moved.to.257545 = fmul double %p_.moved.to.248536, 2.000000e+00
  %p_.moved.to.261549 = fdiv double %p_.moved.to.257545, %p_.moved.to.251539
  %p_.moved.to.262550 = fmul double %p_.moved.to.261549, -5.000000e-01
  %p_.moved.to.263551 = fmul double %p_.moved.to.262550, 2.000000e+00
  %p_.moved.to.264552 = fadd double %p_.moved.to.263551, 1.000000e+00
  %p_.moved.to.267555 = add i64 %11, 1
  %p_556 = add i64 %polly.indvar529, 1
  %p_scevgep62557 = getelementptr [1000 x double]* %v, i64 %p_.moved.to.256544, i64 %p_556
  %p_scevgep60558 = getelementptr [1000 x double]* %v, i64 %polly.indvar512, i64 %p_556
  %p_scevgep65559 = getelementptr [1000 x double]* %q, i64 %p_519, i64 %polly.indvar529
  %p_scevgep64560 = getelementptr [1000 x double]* %p, i64 %p_519, i64 %polly.indvar529
  %p_scevgep63561 = getelementptr [1000 x double]* %q, i64 %p_519, i64 %p_556
  %p_scevgep61562 = getelementptr [1000 x double]* %v, i64 %p_519, i64 %p_556
  %p_scevgep59563 = getelementptr [1000 x double]* %p, i64 %p_519, i64 %p_556
  %_p_scalar_564 = load double* %p_scevgep64560
  %p_565 = fmul double %p_.moved.to.253541, %_p_scalar_564
  %p_566 = fadd double %p_.moved.to.255543, %p_565
  %p_567 = fdiv double %p_.moved.to.254542, %p_566
  store double %p_567, double* %p_scevgep59563
  %_p_scalar_568 = load double* %p_scevgep60558
  %p_569 = fmul double %p_.moved.to.262550, %_p_scalar_568
  %_p_scalar_570 = load double* %p_scevgep61562
  %p_571 = fmul double %p_.moved.to.264552, %_p_scalar_570
  %p_572 = fsub double %p_571, %p_569
  %_p_scalar_573 = load double* %p_scevgep62557
  %p_574 = fmul double %p_.moved.to.262550, %_p_scalar_573
  %p_575 = fsub double %p_572, %p_574
  %_p_scalar_576 = load double* %p_scevgep65559
  %p_577 = fmul double %p_.moved.to.253541, %_p_scalar_576
  %p_578 = fsub double %p_575, %p_577
  %_p_scalar_579 = load double* %p_scevgep64560
  %p_580 = fmul double %p_.moved.to.253541, %_p_scalar_579
  %p_581 = fadd double %p_.moved.to.255543, %p_580
  %p_582 = fdiv double %p_578, %p_581
  store double %p_582, double* %p_scevgep63561
  %polly.indvar_next530 = add nsw i64 %polly.indvar529, 1
  %polly.adjust_ub531 = sub i64 %11, 1
  %polly.loop_cond532 = icmp sle i64 %polly.indvar529, %polly.adjust_ub531
  br i1 %polly.loop_cond532, label %polly.loop_header525, label %polly.loop_exit527
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, [1000 x double]* %u) #0 {
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
