; ModuleID = './linear-algebra/kernels/3mm/3mm.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [2 x i8] c"G\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %0 = tail call i8* @polybench_alloc_data(i64 720000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 800000, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 900000, i32 8) #3
  %3 = tail call i8* @polybench_alloc_data(i64 990000, i32 8) #3
  %4 = tail call i8* @polybench_alloc_data(i64 1080000, i32 8) #3
  %5 = tail call i8* @polybench_alloc_data(i64 1320000, i32 8) #3
  %6 = tail call i8* @polybench_alloc_data(i64 880000, i32 8) #3
  %7 = bitcast i8* %1 to [1000 x double]*
  %8 = bitcast i8* %2 to [900 x double]*
  %9 = bitcast i8* %4 to [1200 x double]*
  %10 = bitcast i8* %5 to [1100 x double]*
  tail call void @init_array(i32 800, i32 900, i32 1000, i32 1100, i32 1200, [1000 x double]* %7, [900 x double]* %8, [1200 x double]* %9, [1100 x double]* %10)
  tail call void (...)* @polybench_timer_start() #3
  %11 = bitcast i8* %0 to [900 x double]*
  %12 = bitcast i8* %3 to [1100 x double]*
  %13 = bitcast i8* %6 to [1100 x double]*
  tail call void @kernel_3mm(i32 800, i32 900, i32 1000, i32 1100, i32 1200, [900 x double]* %11, [1000 x double]* %7, [900 x double]* %8, [1100 x double]* %12, [1200 x double]* %9, [1100 x double]* %10, [1100 x double]* %13)
  tail call void (...)* @polybench_timer_stop() #3
  tail call void (...)* @polybench_timer_print() #3
  %14 = icmp sgt i32 %argc, 42
  br i1 %14, label %15, label %19

; <label>:15                                      ; preds = %.split
  %16 = load i8** %argv, align 8, !tbaa !1
  %17 = load i8* %16, align 1, !tbaa !5
  %phitmp = icmp eq i8 %17, 0
  br i1 %phitmp, label %18, label %19

; <label>:18                                      ; preds = %15
  tail call void @print_array(i32 800, i32 1100, [1100 x double]* %13)
  br label %19

; <label>:19                                      ; preds = %15, %18, %.split
  tail call void @free(i8* %0) #3
  tail call void @free(i8* %1) #3
  tail call void @free(i8* %2) #3
  tail call void @free(i8* %3) #3
  tail call void @free(i8* %4) #3
  tail call void @free(i8* %5) #3
  tail call void @free(i8* %6) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %ni, i32 %nj, i32 %nk, i32 %nl, i32 %nm, [1000 x double]* noalias %A, [900 x double]* noalias %B, [1200 x double]* noalias %C, [1100 x double]* noalias %D) #0 {
polly.split_new_and_old:
  %0 = zext i32 %ni to i64
  %1 = zext i32 %nk to i64
  %2 = zext i32 %nj to i64
  %3 = zext i32 %nm to i64
  %4 = zext i32 %nl to i64
  %5 = sext i32 %nj to i64
  %6 = icmp sge i64 %5, 1
  %7 = sext i32 %nk to i64
  %8 = icmp sge i64 %7, 1
  %9 = and i1 %6, %8
  %10 = icmp sge i64 %1, 1
  %11 = and i1 %9, %10
  %12 = icmp sge i64 %2, 1
  %13 = and i1 %11, %12
  br i1 %13, label %polly.then, label %polly.cond103

polly.cond103:                                    ; preds = %polly.then, %polly.loop_exit74, %polly.split_new_and_old
  %14 = sext i32 %ni to i64
  %15 = icmp sge i64 %14, 1
  %16 = and i1 %15, %8
  %17 = icmp sge i64 %0, 1
  %18 = and i1 %16, %17
  %19 = and i1 %18, %10
  br i1 %19, label %polly.then105, label %polly.cond148

polly.cond148:                                    ; preds = %polly.then105, %polly.loop_exit118, %polly.cond103
  %20 = sext i32 %nm to i64
  %21 = icmp sge i64 %20, 1
  %22 = and i1 %6, %21
  %23 = and i1 %22, %12
  %24 = icmp sge i64 %3, 1
  %25 = and i1 %23, %24
  br i1 %25, label %polly.then150, label %polly.cond194

polly.cond194:                                    ; preds = %polly.then150, %polly.loop_exit163, %polly.cond148
  %26 = sext i32 %nl to i64
  %27 = icmp sge i64 %26, 1
  %28 = and i1 %27, %21
  %29 = and i1 %28, %24
  %30 = icmp sge i64 %4, 1
  %31 = and i1 %29, %30
  br i1 %31, label %polly.then196, label %polly.merge195

polly.merge195:                                   ; preds = %polly.then196, %polly.loop_exit209, %polly.cond194
  ret void

polly.then:                                       ; preds = %polly.split_new_and_old
  %32 = add i64 %1, -1
  %polly.loop_guard = icmp sle i64 0, %32
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond103

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit74
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit74 ], [ 0, %polly.then ]
  %33 = mul i64 -3, %1
  %34 = add i64 %33, %2
  %35 = add i64 %34, 5
  %36 = sub i64 %35, 32
  %37 = add i64 %36, 1
  %38 = icmp slt i64 %35, 0
  %39 = select i1 %38, i64 %37, i64 %35
  %40 = sdiv i64 %39, 32
  %41 = mul i64 -32, %40
  %42 = mul i64 -32, %1
  %43 = add i64 %41, %42
  %44 = mul i64 -32, %polly.indvar
  %45 = mul i64 -3, %polly.indvar
  %46 = add i64 %45, %2
  %47 = add i64 %46, 5
  %48 = sub i64 %47, 32
  %49 = add i64 %48, 1
  %50 = icmp slt i64 %47, 0
  %51 = select i1 %50, i64 %49, i64 %47
  %52 = sdiv i64 %51, 32
  %53 = mul i64 -32, %52
  %54 = add i64 %44, %53
  %55 = add i64 %54, -640
  %56 = icmp sgt i64 %43, %55
  %57 = select i1 %56, i64 %43, i64 %55
  %58 = mul i64 -20, %polly.indvar
  %polly.loop_guard75 = icmp sle i64 %57, %58
  br i1 %polly.loop_guard75, label %polly.loop_header72, label %polly.loop_exit74

polly.loop_exit74:                                ; preds = %polly.loop_exit83, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %32, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond103

polly.loop_header72:                              ; preds = %polly.loop_header, %polly.loop_exit83
  %polly.indvar76 = phi i64 [ %polly.indvar_next77, %polly.loop_exit83 ], [ %57, %polly.loop_header ]
  %59 = mul i64 -1, %polly.indvar76
  %60 = mul i64 -1, %2
  %61 = add i64 %59, %60
  %62 = add i64 %61, -30
  %63 = add i64 %62, 20
  %64 = sub i64 %63, 1
  %65 = icmp slt i64 %62, 0
  %66 = select i1 %65, i64 %62, i64 %64
  %67 = sdiv i64 %66, 20
  %68 = icmp sgt i64 %67, %polly.indvar
  %69 = select i1 %68, i64 %67, i64 %polly.indvar
  %70 = sub i64 %59, 20
  %71 = add i64 %70, 1
  %72 = icmp slt i64 %59, 0
  %73 = select i1 %72, i64 %71, i64 %59
  %74 = sdiv i64 %73, 20
  %75 = add i64 %polly.indvar, 31
  %76 = icmp slt i64 %74, %75
  %77 = select i1 %76, i64 %74, i64 %75
  %78 = icmp slt i64 %77, %32
  %79 = select i1 %78, i64 %77, i64 %32
  %polly.loop_guard84 = icmp sle i64 %69, %79
  br i1 %polly.loop_guard84, label %polly.loop_header81, label %polly.loop_exit83

polly.loop_exit83:                                ; preds = %polly.loop_exit92, %polly.loop_header72
  %polly.indvar_next77 = add nsw i64 %polly.indvar76, 32
  %polly.adjust_ub78 = sub i64 %58, 32
  %polly.loop_cond79 = icmp sle i64 %polly.indvar76, %polly.adjust_ub78
  br i1 %polly.loop_cond79, label %polly.loop_header72, label %polly.loop_exit74

polly.loop_header81:                              ; preds = %polly.loop_header72, %polly.loop_exit92
  %polly.indvar85 = phi i64 [ %polly.indvar_next86, %polly.loop_exit92 ], [ %69, %polly.loop_header72 ]
  %80 = mul i64 -20, %polly.indvar85
  %81 = add i64 %80, %60
  %82 = add i64 %81, 1
  %83 = icmp sgt i64 %polly.indvar76, %82
  %84 = select i1 %83, i64 %polly.indvar76, i64 %82
  %85 = add i64 %polly.indvar76, 31
  %86 = icmp slt i64 %80, %85
  %87 = select i1 %86, i64 %80, i64 %85
  %polly.loop_guard93 = icmp sle i64 %84, %87
  br i1 %polly.loop_guard93, label %polly.loop_header90, label %polly.loop_exit92

polly.loop_exit92:                                ; preds = %polly.loop_header90, %polly.loop_header81
  %polly.indvar_next86 = add nsw i64 %polly.indvar85, 1
  %polly.adjust_ub87 = sub i64 %79, 1
  %polly.loop_cond88 = icmp sle i64 %polly.indvar85, %polly.adjust_ub87
  br i1 %polly.loop_cond88, label %polly.loop_header81, label %polly.loop_exit83

polly.loop_header90:                              ; preds = %polly.loop_header81, %polly.loop_header90
  %polly.indvar94 = phi i64 [ %polly.indvar_next95, %polly.loop_header90 ], [ %84, %polly.loop_header81 ]
  %88 = mul i64 -1, %polly.indvar94
  %89 = add i64 %80, %88
  %p_.moved.to.57 = mul nsw i32 %nj, 5
  %p_.moved.to.58 = sitofp i32 %p_.moved.to.57 to double
  %p_scevgep43 = getelementptr [900 x double]* %B, i64 %polly.indvar85, i64 %89
  %p_ = mul i64 %polly.indvar85, %89
  %p_98 = add i64 %polly.indvar85, %p_
  %p_99 = trunc i64 %p_98 to i32
  %p_100 = srem i32 %p_99, %nj
  %p_101 = sitofp i32 %p_100 to double
  %p_102 = fdiv double %p_101, %p_.moved.to.58
  store double %p_102, double* %p_scevgep43
  %p_indvar.next39 = add i64 %89, 1
  %polly.indvar_next95 = add nsw i64 %polly.indvar94, 1
  %polly.adjust_ub96 = sub i64 %87, 1
  %polly.loop_cond97 = icmp sle i64 %polly.indvar94, %polly.adjust_ub96
  br i1 %polly.loop_cond97, label %polly.loop_header90, label %polly.loop_exit92

polly.then105:                                    ; preds = %polly.cond103
  %90 = add i64 %0, -1
  %polly.loop_guard110 = icmp sle i64 0, %90
  br i1 %polly.loop_guard110, label %polly.loop_header107, label %polly.cond148

polly.loop_header107:                             ; preds = %polly.then105, %polly.loop_exit118
  %polly.indvar111 = phi i64 [ %polly.indvar_next112, %polly.loop_exit118 ], [ 0, %polly.then105 ]
  %91 = mul i64 -3, %0
  %92 = add i64 %91, %1
  %93 = add i64 %92, 5
  %94 = sub i64 %93, 32
  %95 = add i64 %94, 1
  %96 = icmp slt i64 %93, 0
  %97 = select i1 %96, i64 %95, i64 %93
  %98 = sdiv i64 %97, 32
  %99 = mul i64 -32, %98
  %100 = mul i64 -32, %0
  %101 = add i64 %99, %100
  %102 = mul i64 -32, %polly.indvar111
  %103 = mul i64 -3, %polly.indvar111
  %104 = add i64 %103, %1
  %105 = add i64 %104, 5
  %106 = sub i64 %105, 32
  %107 = add i64 %106, 1
  %108 = icmp slt i64 %105, 0
  %109 = select i1 %108, i64 %107, i64 %105
  %110 = sdiv i64 %109, 32
  %111 = mul i64 -32, %110
  %112 = add i64 %102, %111
  %113 = add i64 %112, -640
  %114 = icmp sgt i64 %101, %113
  %115 = select i1 %114, i64 %101, i64 %113
  %116 = mul i64 -20, %polly.indvar111
  %polly.loop_guard119 = icmp sle i64 %115, %116
  br i1 %polly.loop_guard119, label %polly.loop_header116, label %polly.loop_exit118

polly.loop_exit118:                               ; preds = %polly.loop_exit127, %polly.loop_header107
  %polly.indvar_next112 = add nsw i64 %polly.indvar111, 32
  %polly.adjust_ub113 = sub i64 %90, 32
  %polly.loop_cond114 = icmp sle i64 %polly.indvar111, %polly.adjust_ub113
  br i1 %polly.loop_cond114, label %polly.loop_header107, label %polly.cond148

polly.loop_header116:                             ; preds = %polly.loop_header107, %polly.loop_exit127
  %polly.indvar120 = phi i64 [ %polly.indvar_next121, %polly.loop_exit127 ], [ %115, %polly.loop_header107 ]
  %117 = mul i64 -1, %polly.indvar120
  %118 = mul i64 -1, %1
  %119 = add i64 %117, %118
  %120 = add i64 %119, -30
  %121 = add i64 %120, 20
  %122 = sub i64 %121, 1
  %123 = icmp slt i64 %120, 0
  %124 = select i1 %123, i64 %120, i64 %122
  %125 = sdiv i64 %124, 20
  %126 = icmp sgt i64 %125, %polly.indvar111
  %127 = select i1 %126, i64 %125, i64 %polly.indvar111
  %128 = sub i64 %117, 20
  %129 = add i64 %128, 1
  %130 = icmp slt i64 %117, 0
  %131 = select i1 %130, i64 %129, i64 %117
  %132 = sdiv i64 %131, 20
  %133 = add i64 %polly.indvar111, 31
  %134 = icmp slt i64 %132, %133
  %135 = select i1 %134, i64 %132, i64 %133
  %136 = icmp slt i64 %135, %90
  %137 = select i1 %136, i64 %135, i64 %90
  %polly.loop_guard128 = icmp sle i64 %127, %137
  br i1 %polly.loop_guard128, label %polly.loop_header125, label %polly.loop_exit127

polly.loop_exit127:                               ; preds = %polly.loop_exit136, %polly.loop_header116
  %polly.indvar_next121 = add nsw i64 %polly.indvar120, 32
  %polly.adjust_ub122 = sub i64 %116, 32
  %polly.loop_cond123 = icmp sle i64 %polly.indvar120, %polly.adjust_ub122
  br i1 %polly.loop_cond123, label %polly.loop_header116, label %polly.loop_exit118

polly.loop_header125:                             ; preds = %polly.loop_header116, %polly.loop_exit136
  %polly.indvar129 = phi i64 [ %polly.indvar_next130, %polly.loop_exit136 ], [ %127, %polly.loop_header116 ]
  %138 = mul i64 -20, %polly.indvar129
  %139 = add i64 %138, %118
  %140 = add i64 %139, 1
  %141 = icmp sgt i64 %polly.indvar120, %140
  %142 = select i1 %141, i64 %polly.indvar120, i64 %140
  %143 = add i64 %polly.indvar120, 31
  %144 = icmp slt i64 %138, %143
  %145 = select i1 %144, i64 %138, i64 %143
  %polly.loop_guard137 = icmp sle i64 %142, %145
  br i1 %polly.loop_guard137, label %polly.loop_header134, label %polly.loop_exit136

polly.loop_exit136:                               ; preds = %polly.loop_header134, %polly.loop_header125
  %polly.indvar_next130 = add nsw i64 %polly.indvar129, 1
  %polly.adjust_ub131 = sub i64 %137, 1
  %polly.loop_cond132 = icmp sle i64 %polly.indvar129, %polly.adjust_ub131
  br i1 %polly.loop_cond132, label %polly.loop_header125, label %polly.loop_exit127

polly.loop_header134:                             ; preds = %polly.loop_header125, %polly.loop_header134
  %polly.indvar138 = phi i64 [ %polly.indvar_next139, %polly.loop_header134 ], [ %142, %polly.loop_header125 ]
  %146 = mul i64 -1, %polly.indvar138
  %147 = add i64 %138, %146
  %p_.moved.to. = mul nsw i32 %ni, 5
  %p_.moved.to.54 = sitofp i32 %p_.moved.to. to double
  %p_scevgep51 = getelementptr [1000 x double]* %A, i64 %polly.indvar129, i64 %147
  %p_143 = mul i64 %polly.indvar129, %147
  %p_144 = trunc i64 %p_143 to i32
  %p_145 = srem i32 %p_144, %ni
  %p_146 = sitofp i32 %p_145 to double
  %p_147 = fdiv double %p_146, %p_.moved.to.54
  store double %p_147, double* %p_scevgep51
  %p_indvar.next47 = add i64 %147, 1
  %polly.indvar_next139 = add nsw i64 %polly.indvar138, 1
  %polly.adjust_ub140 = sub i64 %145, 1
  %polly.loop_cond141 = icmp sle i64 %polly.indvar138, %polly.adjust_ub140
  br i1 %polly.loop_cond141, label %polly.loop_header134, label %polly.loop_exit136

polly.then150:                                    ; preds = %polly.cond148
  %148 = add i64 %2, -1
  %polly.loop_guard155 = icmp sle i64 0, %148
  br i1 %polly.loop_guard155, label %polly.loop_header152, label %polly.cond194

polly.loop_header152:                             ; preds = %polly.then150, %polly.loop_exit163
  %polly.indvar156 = phi i64 [ %polly.indvar_next157, %polly.loop_exit163 ], [ 0, %polly.then150 ]
  %149 = mul i64 -3, %2
  %150 = add i64 %149, %3
  %151 = add i64 %150, 5
  %152 = sub i64 %151, 32
  %153 = add i64 %152, 1
  %154 = icmp slt i64 %151, 0
  %155 = select i1 %154, i64 %153, i64 %151
  %156 = sdiv i64 %155, 32
  %157 = mul i64 -32, %156
  %158 = mul i64 -32, %2
  %159 = add i64 %157, %158
  %160 = mul i64 -32, %polly.indvar156
  %161 = mul i64 -3, %polly.indvar156
  %162 = add i64 %161, %3
  %163 = add i64 %162, 5
  %164 = sub i64 %163, 32
  %165 = add i64 %164, 1
  %166 = icmp slt i64 %163, 0
  %167 = select i1 %166, i64 %165, i64 %163
  %168 = sdiv i64 %167, 32
  %169 = mul i64 -32, %168
  %170 = add i64 %160, %169
  %171 = add i64 %170, -640
  %172 = icmp sgt i64 %159, %171
  %173 = select i1 %172, i64 %159, i64 %171
  %174 = mul i64 -20, %polly.indvar156
  %polly.loop_guard164 = icmp sle i64 %173, %174
  br i1 %polly.loop_guard164, label %polly.loop_header161, label %polly.loop_exit163

polly.loop_exit163:                               ; preds = %polly.loop_exit172, %polly.loop_header152
  %polly.indvar_next157 = add nsw i64 %polly.indvar156, 32
  %polly.adjust_ub158 = sub i64 %148, 32
  %polly.loop_cond159 = icmp sle i64 %polly.indvar156, %polly.adjust_ub158
  br i1 %polly.loop_cond159, label %polly.loop_header152, label %polly.cond194

polly.loop_header161:                             ; preds = %polly.loop_header152, %polly.loop_exit172
  %polly.indvar165 = phi i64 [ %polly.indvar_next166, %polly.loop_exit172 ], [ %173, %polly.loop_header152 ]
  %175 = mul i64 -1, %polly.indvar165
  %176 = mul i64 -1, %3
  %177 = add i64 %175, %176
  %178 = add i64 %177, -30
  %179 = add i64 %178, 20
  %180 = sub i64 %179, 1
  %181 = icmp slt i64 %178, 0
  %182 = select i1 %181, i64 %178, i64 %180
  %183 = sdiv i64 %182, 20
  %184 = icmp sgt i64 %183, %polly.indvar156
  %185 = select i1 %184, i64 %183, i64 %polly.indvar156
  %186 = sub i64 %175, 20
  %187 = add i64 %186, 1
  %188 = icmp slt i64 %175, 0
  %189 = select i1 %188, i64 %187, i64 %175
  %190 = sdiv i64 %189, 20
  %191 = add i64 %polly.indvar156, 31
  %192 = icmp slt i64 %190, %191
  %193 = select i1 %192, i64 %190, i64 %191
  %194 = icmp slt i64 %193, %148
  %195 = select i1 %194, i64 %193, i64 %148
  %polly.loop_guard173 = icmp sle i64 %185, %195
  br i1 %polly.loop_guard173, label %polly.loop_header170, label %polly.loop_exit172

polly.loop_exit172:                               ; preds = %polly.loop_exit181, %polly.loop_header161
  %polly.indvar_next166 = add nsw i64 %polly.indvar165, 32
  %polly.adjust_ub167 = sub i64 %174, 32
  %polly.loop_cond168 = icmp sle i64 %polly.indvar165, %polly.adjust_ub167
  br i1 %polly.loop_cond168, label %polly.loop_header161, label %polly.loop_exit163

polly.loop_header170:                             ; preds = %polly.loop_header161, %polly.loop_exit181
  %polly.indvar174 = phi i64 [ %polly.indvar_next175, %polly.loop_exit181 ], [ %185, %polly.loop_header161 ]
  %196 = mul i64 -20, %polly.indvar174
  %197 = add i64 %196, %176
  %198 = add i64 %197, 1
  %199 = icmp sgt i64 %polly.indvar165, %198
  %200 = select i1 %199, i64 %polly.indvar165, i64 %198
  %201 = add i64 %polly.indvar165, 31
  %202 = icmp slt i64 %196, %201
  %203 = select i1 %202, i64 %196, i64 %201
  %polly.loop_guard182 = icmp sle i64 %200, %203
  br i1 %polly.loop_guard182, label %polly.loop_header179, label %polly.loop_exit181

polly.loop_exit181:                               ; preds = %polly.loop_header179, %polly.loop_header170
  %polly.indvar_next175 = add nsw i64 %polly.indvar174, 1
  %polly.adjust_ub176 = sub i64 %195, 1
  %polly.loop_cond177 = icmp sle i64 %polly.indvar174, %polly.adjust_ub176
  br i1 %polly.loop_cond177, label %polly.loop_header170, label %polly.loop_exit172

polly.loop_header179:                             ; preds = %polly.loop_header170, %polly.loop_header179
  %polly.indvar183 = phi i64 [ %polly.indvar_next184, %polly.loop_header179 ], [ %200, %polly.loop_header170 ]
  %204 = mul i64 -1, %polly.indvar183
  %205 = add i64 %196, %204
  %p_.moved.to.61 = mul i64 %polly.indvar174, 3
  %p_.moved.to.62 = mul nsw i32 %nl, 5
  %p_.moved.to.63 = sitofp i32 %p_.moved.to.62 to double
  %p_scevgep35 = getelementptr [1200 x double]* %C, i64 %polly.indvar174, i64 %205
  %p_188 = mul i64 %polly.indvar174, %205
  %p_189 = add i64 %p_.moved.to.61, %p_188
  %p_190 = trunc i64 %p_189 to i32
  %p_191 = srem i32 %p_190, %nl
  %p_192 = sitofp i32 %p_191 to double
  %p_193 = fdiv double %p_192, %p_.moved.to.63
  store double %p_193, double* %p_scevgep35
  %p_indvar.next31 = add i64 %205, 1
  %polly.indvar_next184 = add nsw i64 %polly.indvar183, 1
  %polly.adjust_ub185 = sub i64 %203, 1
  %polly.loop_cond186 = icmp sle i64 %polly.indvar183, %polly.adjust_ub185
  br i1 %polly.loop_cond186, label %polly.loop_header179, label %polly.loop_exit181

polly.then196:                                    ; preds = %polly.cond194
  %206 = add i64 %3, -1
  %polly.loop_guard201 = icmp sle i64 0, %206
  br i1 %polly.loop_guard201, label %polly.loop_header198, label %polly.merge195

polly.loop_header198:                             ; preds = %polly.then196, %polly.loop_exit209
  %polly.indvar202 = phi i64 [ %polly.indvar_next203, %polly.loop_exit209 ], [ 0, %polly.then196 ]
  %207 = mul i64 -3, %3
  %208 = add i64 %207, %4
  %209 = add i64 %208, 5
  %210 = sub i64 %209, 32
  %211 = add i64 %210, 1
  %212 = icmp slt i64 %209, 0
  %213 = select i1 %212, i64 %211, i64 %209
  %214 = sdiv i64 %213, 32
  %215 = mul i64 -32, %214
  %216 = mul i64 -32, %3
  %217 = add i64 %215, %216
  %218 = mul i64 -32, %polly.indvar202
  %219 = mul i64 -3, %polly.indvar202
  %220 = add i64 %219, %4
  %221 = add i64 %220, 5
  %222 = sub i64 %221, 32
  %223 = add i64 %222, 1
  %224 = icmp slt i64 %221, 0
  %225 = select i1 %224, i64 %223, i64 %221
  %226 = sdiv i64 %225, 32
  %227 = mul i64 -32, %226
  %228 = add i64 %218, %227
  %229 = add i64 %228, -640
  %230 = icmp sgt i64 %217, %229
  %231 = select i1 %230, i64 %217, i64 %229
  %232 = mul i64 -20, %polly.indvar202
  %polly.loop_guard210 = icmp sle i64 %231, %232
  br i1 %polly.loop_guard210, label %polly.loop_header207, label %polly.loop_exit209

polly.loop_exit209:                               ; preds = %polly.loop_exit218, %polly.loop_header198
  %polly.indvar_next203 = add nsw i64 %polly.indvar202, 32
  %polly.adjust_ub204 = sub i64 %206, 32
  %polly.loop_cond205 = icmp sle i64 %polly.indvar202, %polly.adjust_ub204
  br i1 %polly.loop_cond205, label %polly.loop_header198, label %polly.merge195

polly.loop_header207:                             ; preds = %polly.loop_header198, %polly.loop_exit218
  %polly.indvar211 = phi i64 [ %polly.indvar_next212, %polly.loop_exit218 ], [ %231, %polly.loop_header198 ]
  %233 = mul i64 -1, %polly.indvar211
  %234 = mul i64 -1, %4
  %235 = add i64 %233, %234
  %236 = add i64 %235, -30
  %237 = add i64 %236, 20
  %238 = sub i64 %237, 1
  %239 = icmp slt i64 %236, 0
  %240 = select i1 %239, i64 %236, i64 %238
  %241 = sdiv i64 %240, 20
  %242 = icmp sgt i64 %241, %polly.indvar202
  %243 = select i1 %242, i64 %241, i64 %polly.indvar202
  %244 = sub i64 %233, 20
  %245 = add i64 %244, 1
  %246 = icmp slt i64 %233, 0
  %247 = select i1 %246, i64 %245, i64 %233
  %248 = sdiv i64 %247, 20
  %249 = add i64 %polly.indvar202, 31
  %250 = icmp slt i64 %248, %249
  %251 = select i1 %250, i64 %248, i64 %249
  %252 = icmp slt i64 %251, %206
  %253 = select i1 %252, i64 %251, i64 %206
  %polly.loop_guard219 = icmp sle i64 %243, %253
  br i1 %polly.loop_guard219, label %polly.loop_header216, label %polly.loop_exit218

polly.loop_exit218:                               ; preds = %polly.loop_exit227, %polly.loop_header207
  %polly.indvar_next212 = add nsw i64 %polly.indvar211, 32
  %polly.adjust_ub213 = sub i64 %232, 32
  %polly.loop_cond214 = icmp sle i64 %polly.indvar211, %polly.adjust_ub213
  br i1 %polly.loop_cond214, label %polly.loop_header207, label %polly.loop_exit209

polly.loop_header216:                             ; preds = %polly.loop_header207, %polly.loop_exit227
  %polly.indvar220 = phi i64 [ %polly.indvar_next221, %polly.loop_exit227 ], [ %243, %polly.loop_header207 ]
  %254 = mul i64 -20, %polly.indvar220
  %255 = add i64 %254, %234
  %256 = add i64 %255, 1
  %257 = icmp sgt i64 %polly.indvar211, %256
  %258 = select i1 %257, i64 %polly.indvar211, i64 %256
  %259 = add i64 %polly.indvar211, 31
  %260 = icmp slt i64 %254, %259
  %261 = select i1 %260, i64 %254, i64 %259
  %polly.loop_guard228 = icmp sle i64 %258, %261
  br i1 %polly.loop_guard228, label %polly.loop_header225, label %polly.loop_exit227

polly.loop_exit227:                               ; preds = %polly.loop_header225, %polly.loop_header216
  %polly.indvar_next221 = add nsw i64 %polly.indvar220, 1
  %polly.adjust_ub222 = sub i64 %253, 1
  %polly.loop_cond223 = icmp sle i64 %polly.indvar220, %polly.adjust_ub222
  br i1 %polly.loop_cond223, label %polly.loop_header216, label %polly.loop_exit218

polly.loop_header225:                             ; preds = %polly.loop_header216, %polly.loop_header225
  %polly.indvar229 = phi i64 [ %polly.indvar_next230, %polly.loop_header225 ], [ %258, %polly.loop_header216 ]
  %262 = mul i64 -1, %polly.indvar229
  %263 = add i64 %254, %262
  %p_.moved.to.66 = mul i64 %polly.indvar220, 2
  %p_.moved.to.67 = mul nsw i32 %nk, 5
  %p_.moved.to.68 = sitofp i32 %p_.moved.to.67 to double
  %p_scevgep = getelementptr [1100 x double]* %D, i64 %polly.indvar220, i64 %263
  %p_234 = mul i64 %polly.indvar220, %263
  %p_235 = add i64 %p_.moved.to.66, %p_234
  %p_236 = trunc i64 %p_235 to i32
  %p_237 = srem i32 %p_236, %nk
  %p_238 = sitofp i32 %p_237 to double
  %p_239 = fdiv double %p_238, %p_.moved.to.68
  store double %p_239, double* %p_scevgep
  %p_indvar.next = add i64 %263, 1
  %polly.indvar_next230 = add nsw i64 %polly.indvar229, 1
  %polly.adjust_ub231 = sub i64 %261, 1
  %polly.loop_cond232 = icmp sle i64 %polly.indvar229, %polly.adjust_ub231
  br i1 %polly.loop_cond232, label %polly.loop_header225, label %polly.loop_exit227
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_3mm(i32 %ni, i32 %nj, i32 %nk, i32 %nl, i32 %nm, [900 x double]* noalias %E, [1000 x double]* noalias %A, [900 x double]* noalias %B, [1100 x double]* noalias %F, [1200 x double]* noalias %C, [1100 x double]* noalias %D, [1100 x double]* noalias %G) #0 {
polly.split_new_and_old:
  %0 = zext i32 %ni to i64
  %1 = zext i32 %nj to i64
  %2 = zext i32 %nk to i64
  %3 = zext i32 %nl to i64
  %4 = zext i32 %nm to i64
  %5 = sext i32 %ni to i64
  %6 = icmp sge i64 %5, 1
  %7 = sext i32 %nj to i64
  %8 = icmp sge i64 %7, 1
  %9 = and i1 %6, %8
  %10 = icmp sge i64 %0, 1
  %11 = and i1 %9, %10
  %12 = icmp sge i64 %1, 1
  %13 = and i1 %11, %12
  br i1 %13, label %polly.cond87, label %polly.cond166

polly.cond166:                                    ; preds = %polly.then144, %polly.loop_exit157, %polly.cond142, %polly.split_new_and_old
  %14 = sext i32 %nl to i64
  %15 = icmp sge i64 %14, 1
  %16 = and i1 %8, %15
  %17 = and i1 %16, %12
  %18 = icmp sge i64 %3, 1
  %19 = and i1 %17, %18
  br i1 %19, label %polly.cond169, label %polly.cond260

polly.cond260:                                    ; preds = %polly.then238, %polly.loop_exit251, %polly.cond236, %polly.cond166
  %20 = and i1 %6, %15
  %21 = and i1 %20, %10
  %22 = and i1 %21, %18
  br i1 %22, label %polly.cond263, label %polly.merge261

polly.merge261:                                   ; preds = %polly.then332, %polly.loop_exit345, %polly.cond330, %polly.cond260
  ret void

polly.cond87:                                     ; preds = %polly.split_new_and_old
  %23 = sext i32 %nk to i64
  %24 = icmp sge i64 %23, 1
  %25 = icmp sge i64 %2, 1
  %26 = and i1 %24, %25
  br i1 %26, label %polly.then89, label %polly.cond112

polly.cond112:                                    ; preds = %polly.then89, %polly.loop_exit93, %polly.cond87
  %27 = icmp sle i64 %2, 0
  %28 = and i1 %24, %27
  br i1 %28, label %polly.then114, label %polly.cond142

polly.cond142:                                    ; preds = %polly.then114, %polly.loop_exit127, %polly.cond112
  %29 = icmp sle i64 %23, 0
  br i1 %29, label %polly.then144, label %polly.cond166

polly.then89:                                     ; preds = %polly.cond87
  %30 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %30
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond112

polly.loop_header:                                ; preds = %polly.then89, %polly.loop_exit93
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit93 ], [ 0, %polly.then89 ]
  %31 = add i64 %1, -1
  %polly.loop_guard94 = icmp sle i64 0, %31
  br i1 %polly.loop_guard94, label %polly.loop_header91, label %polly.loop_exit93

polly.loop_exit93:                                ; preds = %polly.loop_exit102, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %30, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond112

polly.loop_header91:                              ; preds = %polly.loop_header, %polly.loop_exit102
  %polly.indvar95 = phi i64 [ %polly.indvar_next96, %polly.loop_exit102 ], [ 0, %polly.loop_header ]
  %p_scevgep68 = getelementptr [900 x double]* %E, i64 %polly.indvar, i64 %polly.indvar95
  store double 0.000000e+00, double* %p_scevgep68
  %32 = add i64 %2, -1
  %polly.loop_guard103 = icmp sle i64 0, %32
  br i1 %polly.loop_guard103, label %polly.loop_header100, label %polly.loop_exit102

polly.loop_exit102:                               ; preds = %polly.loop_header100, %polly.loop_header91
  %.reg2mem74.0 = phi double [ %p_110, %polly.loop_header100 ], [ 0.000000e+00, %polly.loop_header91 ]
  store double %.reg2mem74.0, double* %p_scevgep68
  %polly.indvar_next96 = add nsw i64 %polly.indvar95, 1
  %polly.adjust_ub97 = sub i64 %31, 1
  %polly.loop_cond98 = icmp sle i64 %polly.indvar95, %polly.adjust_ub97
  br i1 %polly.loop_cond98, label %polly.loop_header91, label %polly.loop_exit93

polly.loop_header100:                             ; preds = %polly.loop_header91, %polly.loop_header100
  %.reg2mem74.1 = phi double [ 0.000000e+00, %polly.loop_header91 ], [ %p_110, %polly.loop_header100 ]
  %polly.indvar104 = phi i64 [ %polly.indvar_next105, %polly.loop_header100 ], [ 0, %polly.loop_header91 ]
  %p_scevgep60 = getelementptr [1000 x double]* %A, i64 %polly.indvar, i64 %polly.indvar104
  %p_scevgep63 = getelementptr [900 x double]* %B, i64 %polly.indvar104, i64 %polly.indvar95
  %_p_scalar_ = load double* %p_scevgep60
  %_p_scalar_109 = load double* %p_scevgep63
  %p_ = fmul double %_p_scalar_, %_p_scalar_109
  %p_110 = fadd double %.reg2mem74.1, %p_
  %p_indvar.next56 = add i64 %polly.indvar104, 1
  %polly.indvar_next105 = add nsw i64 %polly.indvar104, 1
  %polly.adjust_ub106 = sub i64 %32, 1
  %polly.loop_cond107 = icmp sle i64 %polly.indvar104, %polly.adjust_ub106
  br i1 %polly.loop_cond107, label %polly.loop_header100, label %polly.loop_exit102

polly.then114:                                    ; preds = %polly.cond112
  %33 = add i64 %0, -1
  %polly.loop_guard119 = icmp sle i64 0, %33
  br i1 %polly.loop_guard119, label %polly.loop_header116, label %polly.cond142

polly.loop_header116:                             ; preds = %polly.then114, %polly.loop_exit127
  %polly.indvar120 = phi i64 [ %polly.indvar_next121, %polly.loop_exit127 ], [ 0, %polly.then114 ]
  %34 = add i64 %1, -1
  %polly.loop_guard128 = icmp sle i64 0, %34
  br i1 %polly.loop_guard128, label %polly.loop_header125, label %polly.loop_exit127

polly.loop_exit127:                               ; preds = %polly.loop_header125, %polly.loop_header116
  %polly.indvar_next121 = add nsw i64 %polly.indvar120, 1
  %polly.adjust_ub122 = sub i64 %33, 1
  %polly.loop_cond123 = icmp sle i64 %polly.indvar120, %polly.adjust_ub122
  br i1 %polly.loop_cond123, label %polly.loop_header116, label %polly.cond142

polly.loop_header125:                             ; preds = %polly.loop_header116, %polly.loop_header125
  %polly.indvar129 = phi i64 [ %polly.indvar_next130, %polly.loop_header125 ], [ 0, %polly.loop_header116 ]
  %p_scevgep68135 = getelementptr [900 x double]* %E, i64 %polly.indvar120, i64 %polly.indvar129
  store double 0.000000e+00, double* %p_scevgep68135
  %polly.indvar_next130 = add nsw i64 %polly.indvar129, 1
  %polly.adjust_ub131 = sub i64 %34, 1
  %polly.loop_cond132 = icmp sle i64 %polly.indvar129, %polly.adjust_ub131
  br i1 %polly.loop_cond132, label %polly.loop_header125, label %polly.loop_exit127

polly.then144:                                    ; preds = %polly.cond142
  %35 = add i64 %0, -1
  %polly.loop_guard149 = icmp sle i64 0, %35
  br i1 %polly.loop_guard149, label %polly.loop_header146, label %polly.cond166

polly.loop_header146:                             ; preds = %polly.then144, %polly.loop_exit157
  %polly.indvar150 = phi i64 [ %polly.indvar_next151, %polly.loop_exit157 ], [ 0, %polly.then144 ]
  %36 = add i64 %1, -1
  %polly.loop_guard158 = icmp sle i64 0, %36
  br i1 %polly.loop_guard158, label %polly.loop_header155, label %polly.loop_exit157

polly.loop_exit157:                               ; preds = %polly.loop_header155, %polly.loop_header146
  %polly.indvar_next151 = add nsw i64 %polly.indvar150, 1
  %polly.adjust_ub152 = sub i64 %35, 1
  %polly.loop_cond153 = icmp sle i64 %polly.indvar150, %polly.adjust_ub152
  br i1 %polly.loop_cond153, label %polly.loop_header146, label %polly.cond166

polly.loop_header155:                             ; preds = %polly.loop_header146, %polly.loop_header155
  %polly.indvar159 = phi i64 [ %polly.indvar_next160, %polly.loop_header155 ], [ 0, %polly.loop_header146 ]
  %p_scevgep68165 = getelementptr [900 x double]* %E, i64 %polly.indvar150, i64 %polly.indvar159
  store double 0.000000e+00, double* %p_scevgep68165
  %polly.indvar_next160 = add nsw i64 %polly.indvar159, 1
  %polly.adjust_ub161 = sub i64 %36, 1
  %polly.loop_cond162 = icmp sle i64 %polly.indvar159, %polly.adjust_ub161
  br i1 %polly.loop_cond162, label %polly.loop_header155, label %polly.loop_exit157

polly.cond169:                                    ; preds = %polly.cond166
  %37 = sext i32 %nm to i64
  %38 = icmp sge i64 %37, 1
  %39 = icmp sge i64 %4, 1
  %40 = and i1 %38, %39
  br i1 %40, label %polly.then171, label %polly.cond206

polly.cond206:                                    ; preds = %polly.then171, %polly.loop_exit184, %polly.cond169
  %41 = icmp sle i64 %4, 0
  %42 = and i1 %38, %41
  br i1 %42, label %polly.then208, label %polly.cond236

polly.cond236:                                    ; preds = %polly.then208, %polly.loop_exit221, %polly.cond206
  %43 = icmp sle i64 %37, 0
  br i1 %43, label %polly.then238, label %polly.cond260

polly.then171:                                    ; preds = %polly.cond169
  %44 = add i64 %1, -1
  %polly.loop_guard176 = icmp sle i64 0, %44
  br i1 %polly.loop_guard176, label %polly.loop_header173, label %polly.cond206

polly.loop_header173:                             ; preds = %polly.then171, %polly.loop_exit184
  %polly.indvar177 = phi i64 [ %polly.indvar_next178, %polly.loop_exit184 ], [ 0, %polly.then171 ]
  %45 = add i64 %3, -1
  %polly.loop_guard185 = icmp sle i64 0, %45
  br i1 %polly.loop_guard185, label %polly.loop_header182, label %polly.loop_exit184

polly.loop_exit184:                               ; preds = %polly.loop_exit194, %polly.loop_header173
  %polly.indvar_next178 = add nsw i64 %polly.indvar177, 1
  %polly.adjust_ub179 = sub i64 %44, 1
  %polly.loop_cond180 = icmp sle i64 %polly.indvar177, %polly.adjust_ub179
  br i1 %polly.loop_cond180, label %polly.loop_header173, label %polly.cond206

polly.loop_header182:                             ; preds = %polly.loop_header173, %polly.loop_exit194
  %polly.indvar186 = phi i64 [ %polly.indvar_next187, %polly.loop_exit194 ], [ 0, %polly.loop_header173 ]
  %p_scevgep51 = getelementptr [1100 x double]* %F, i64 %polly.indvar177, i64 %polly.indvar186
  store double 0.000000e+00, double* %p_scevgep51
  %46 = add i64 %4, -1
  %polly.loop_guard195 = icmp sle i64 0, %46
  br i1 %polly.loop_guard195, label %polly.loop_header192, label %polly.loop_exit194

polly.loop_exit194:                               ; preds = %polly.loop_header192, %polly.loop_header182
  %.reg2mem72.0 = phi double [ %p_204, %polly.loop_header192 ], [ 0.000000e+00, %polly.loop_header182 ]
  store double %.reg2mem72.0, double* %p_scevgep51
  %polly.indvar_next187 = add nsw i64 %polly.indvar186, 1
  %polly.adjust_ub188 = sub i64 %45, 1
  %polly.loop_cond189 = icmp sle i64 %polly.indvar186, %polly.adjust_ub188
  br i1 %polly.loop_cond189, label %polly.loop_header182, label %polly.loop_exit184

polly.loop_header192:                             ; preds = %polly.loop_header182, %polly.loop_header192
  %.reg2mem72.1 = phi double [ 0.000000e+00, %polly.loop_header182 ], [ %p_204, %polly.loop_header192 ]
  %polly.indvar196 = phi i64 [ %polly.indvar_next197, %polly.loop_header192 ], [ 0, %polly.loop_header182 ]
  %p_scevgep43 = getelementptr [1200 x double]* %C, i64 %polly.indvar177, i64 %polly.indvar196
  %p_scevgep46 = getelementptr [1100 x double]* %D, i64 %polly.indvar196, i64 %polly.indvar186
  %_p_scalar_201 = load double* %p_scevgep43
  %_p_scalar_202 = load double* %p_scevgep46
  %p_203 = fmul double %_p_scalar_201, %_p_scalar_202
  %p_204 = fadd double %.reg2mem72.1, %p_203
  %p_indvar.next39 = add i64 %polly.indvar196, 1
  %polly.indvar_next197 = add nsw i64 %polly.indvar196, 1
  %polly.adjust_ub198 = sub i64 %46, 1
  %polly.loop_cond199 = icmp sle i64 %polly.indvar196, %polly.adjust_ub198
  br i1 %polly.loop_cond199, label %polly.loop_header192, label %polly.loop_exit194

polly.then208:                                    ; preds = %polly.cond206
  %47 = add i64 %1, -1
  %polly.loop_guard213 = icmp sle i64 0, %47
  br i1 %polly.loop_guard213, label %polly.loop_header210, label %polly.cond236

polly.loop_header210:                             ; preds = %polly.then208, %polly.loop_exit221
  %polly.indvar214 = phi i64 [ %polly.indvar_next215, %polly.loop_exit221 ], [ 0, %polly.then208 ]
  %48 = add i64 %3, -1
  %polly.loop_guard222 = icmp sle i64 0, %48
  br i1 %polly.loop_guard222, label %polly.loop_header219, label %polly.loop_exit221

polly.loop_exit221:                               ; preds = %polly.loop_header219, %polly.loop_header210
  %polly.indvar_next215 = add nsw i64 %polly.indvar214, 1
  %polly.adjust_ub216 = sub i64 %47, 1
  %polly.loop_cond217 = icmp sle i64 %polly.indvar214, %polly.adjust_ub216
  br i1 %polly.loop_cond217, label %polly.loop_header210, label %polly.cond236

polly.loop_header219:                             ; preds = %polly.loop_header210, %polly.loop_header219
  %polly.indvar223 = phi i64 [ %polly.indvar_next224, %polly.loop_header219 ], [ 0, %polly.loop_header210 ]
  %p_scevgep51229 = getelementptr [1100 x double]* %F, i64 %polly.indvar214, i64 %polly.indvar223
  store double 0.000000e+00, double* %p_scevgep51229
  %polly.indvar_next224 = add nsw i64 %polly.indvar223, 1
  %polly.adjust_ub225 = sub i64 %48, 1
  %polly.loop_cond226 = icmp sle i64 %polly.indvar223, %polly.adjust_ub225
  br i1 %polly.loop_cond226, label %polly.loop_header219, label %polly.loop_exit221

polly.then238:                                    ; preds = %polly.cond236
  %49 = add i64 %1, -1
  %polly.loop_guard243 = icmp sle i64 0, %49
  br i1 %polly.loop_guard243, label %polly.loop_header240, label %polly.cond260

polly.loop_header240:                             ; preds = %polly.then238, %polly.loop_exit251
  %polly.indvar244 = phi i64 [ %polly.indvar_next245, %polly.loop_exit251 ], [ 0, %polly.then238 ]
  %50 = add i64 %3, -1
  %polly.loop_guard252 = icmp sle i64 0, %50
  br i1 %polly.loop_guard252, label %polly.loop_header249, label %polly.loop_exit251

polly.loop_exit251:                               ; preds = %polly.loop_header249, %polly.loop_header240
  %polly.indvar_next245 = add nsw i64 %polly.indvar244, 1
  %polly.adjust_ub246 = sub i64 %49, 1
  %polly.loop_cond247 = icmp sle i64 %polly.indvar244, %polly.adjust_ub246
  br i1 %polly.loop_cond247, label %polly.loop_header240, label %polly.cond260

polly.loop_header249:                             ; preds = %polly.loop_header240, %polly.loop_header249
  %polly.indvar253 = phi i64 [ %polly.indvar_next254, %polly.loop_header249 ], [ 0, %polly.loop_header240 ]
  %p_scevgep51259 = getelementptr [1100 x double]* %F, i64 %polly.indvar244, i64 %polly.indvar253
  store double 0.000000e+00, double* %p_scevgep51259
  %polly.indvar_next254 = add nsw i64 %polly.indvar253, 1
  %polly.adjust_ub255 = sub i64 %50, 1
  %polly.loop_cond256 = icmp sle i64 %polly.indvar253, %polly.adjust_ub255
  br i1 %polly.loop_cond256, label %polly.loop_header249, label %polly.loop_exit251

polly.cond263:                                    ; preds = %polly.cond260
  %51 = and i1 %8, %12
  br i1 %51, label %polly.then265, label %polly.cond300

polly.cond300:                                    ; preds = %polly.then265, %polly.loop_exit278, %polly.cond263
  %52 = icmp sle i64 %1, 0
  %53 = and i1 %8, %52
  br i1 %53, label %polly.then302, label %polly.cond330

polly.cond330:                                    ; preds = %polly.then302, %polly.loop_exit315, %polly.cond300
  %54 = icmp sle i64 %7, 0
  br i1 %54, label %polly.then332, label %polly.merge261

polly.then265:                                    ; preds = %polly.cond263
  %55 = add i64 %0, -1
  %polly.loop_guard270 = icmp sle i64 0, %55
  br i1 %polly.loop_guard270, label %polly.loop_header267, label %polly.cond300

polly.loop_header267:                             ; preds = %polly.then265, %polly.loop_exit278
  %polly.indvar271 = phi i64 [ %polly.indvar_next272, %polly.loop_exit278 ], [ 0, %polly.then265 ]
  %56 = add i64 %3, -1
  %polly.loop_guard279 = icmp sle i64 0, %56
  br i1 %polly.loop_guard279, label %polly.loop_header276, label %polly.loop_exit278

polly.loop_exit278:                               ; preds = %polly.loop_exit288, %polly.loop_header267
  %polly.indvar_next272 = add nsw i64 %polly.indvar271, 1
  %polly.adjust_ub273 = sub i64 %55, 1
  %polly.loop_cond274 = icmp sle i64 %polly.indvar271, %polly.adjust_ub273
  br i1 %polly.loop_cond274, label %polly.loop_header267, label %polly.cond300

polly.loop_header276:                             ; preds = %polly.loop_header267, %polly.loop_exit288
  %polly.indvar280 = phi i64 [ %polly.indvar_next281, %polly.loop_exit288 ], [ 0, %polly.loop_header267 ]
  %p_scevgep34 = getelementptr [1100 x double]* %G, i64 %polly.indvar271, i64 %polly.indvar280
  store double 0.000000e+00, double* %p_scevgep34
  %57 = add i64 %1, -1
  %polly.loop_guard289 = icmp sle i64 0, %57
  br i1 %polly.loop_guard289, label %polly.loop_header286, label %polly.loop_exit288

polly.loop_exit288:                               ; preds = %polly.loop_header286, %polly.loop_header276
  %.reg2mem.0 = phi double [ %p_298, %polly.loop_header286 ], [ 0.000000e+00, %polly.loop_header276 ]
  store double %.reg2mem.0, double* %p_scevgep34
  %polly.indvar_next281 = add nsw i64 %polly.indvar280, 1
  %polly.adjust_ub282 = sub i64 %56, 1
  %polly.loop_cond283 = icmp sle i64 %polly.indvar280, %polly.adjust_ub282
  br i1 %polly.loop_cond283, label %polly.loop_header276, label %polly.loop_exit278

polly.loop_header286:                             ; preds = %polly.loop_header276, %polly.loop_header286
  %.reg2mem.1 = phi double [ 0.000000e+00, %polly.loop_header276 ], [ %p_298, %polly.loop_header286 ]
  %polly.indvar290 = phi i64 [ %polly.indvar_next291, %polly.loop_header286 ], [ 0, %polly.loop_header276 ]
  %p_scevgep = getelementptr [900 x double]* %E, i64 %polly.indvar271, i64 %polly.indvar290
  %p_scevgep31 = getelementptr [1100 x double]* %F, i64 %polly.indvar290, i64 %polly.indvar280
  %_p_scalar_295 = load double* %p_scevgep
  %_p_scalar_296 = load double* %p_scevgep31
  %p_297 = fmul double %_p_scalar_295, %_p_scalar_296
  %p_298 = fadd double %.reg2mem.1, %p_297
  %p_indvar.next = add i64 %polly.indvar290, 1
  %polly.indvar_next291 = add nsw i64 %polly.indvar290, 1
  %polly.adjust_ub292 = sub i64 %57, 1
  %polly.loop_cond293 = icmp sle i64 %polly.indvar290, %polly.adjust_ub292
  br i1 %polly.loop_cond293, label %polly.loop_header286, label %polly.loop_exit288

polly.then302:                                    ; preds = %polly.cond300
  %58 = add i64 %0, -1
  %polly.loop_guard307 = icmp sle i64 0, %58
  br i1 %polly.loop_guard307, label %polly.loop_header304, label %polly.cond330

polly.loop_header304:                             ; preds = %polly.then302, %polly.loop_exit315
  %polly.indvar308 = phi i64 [ %polly.indvar_next309, %polly.loop_exit315 ], [ 0, %polly.then302 ]
  %59 = add i64 %3, -1
  %polly.loop_guard316 = icmp sle i64 0, %59
  br i1 %polly.loop_guard316, label %polly.loop_header313, label %polly.loop_exit315

polly.loop_exit315:                               ; preds = %polly.loop_header313, %polly.loop_header304
  %polly.indvar_next309 = add nsw i64 %polly.indvar308, 1
  %polly.adjust_ub310 = sub i64 %58, 1
  %polly.loop_cond311 = icmp sle i64 %polly.indvar308, %polly.adjust_ub310
  br i1 %polly.loop_cond311, label %polly.loop_header304, label %polly.cond330

polly.loop_header313:                             ; preds = %polly.loop_header304, %polly.loop_header313
  %polly.indvar317 = phi i64 [ %polly.indvar_next318, %polly.loop_header313 ], [ 0, %polly.loop_header304 ]
  %p_scevgep34323 = getelementptr [1100 x double]* %G, i64 %polly.indvar308, i64 %polly.indvar317
  store double 0.000000e+00, double* %p_scevgep34323
  %polly.indvar_next318 = add nsw i64 %polly.indvar317, 1
  %polly.adjust_ub319 = sub i64 %59, 1
  %polly.loop_cond320 = icmp sle i64 %polly.indvar317, %polly.adjust_ub319
  br i1 %polly.loop_cond320, label %polly.loop_header313, label %polly.loop_exit315

polly.then332:                                    ; preds = %polly.cond330
  %60 = add i64 %0, -1
  %polly.loop_guard337 = icmp sle i64 0, %60
  br i1 %polly.loop_guard337, label %polly.loop_header334, label %polly.merge261

polly.loop_header334:                             ; preds = %polly.then332, %polly.loop_exit345
  %polly.indvar338 = phi i64 [ %polly.indvar_next339, %polly.loop_exit345 ], [ 0, %polly.then332 ]
  %61 = add i64 %3, -1
  %polly.loop_guard346 = icmp sle i64 0, %61
  br i1 %polly.loop_guard346, label %polly.loop_header343, label %polly.loop_exit345

polly.loop_exit345:                               ; preds = %polly.loop_header343, %polly.loop_header334
  %polly.indvar_next339 = add nsw i64 %polly.indvar338, 1
  %polly.adjust_ub340 = sub i64 %60, 1
  %polly.loop_cond341 = icmp sle i64 %polly.indvar338, %polly.adjust_ub340
  br i1 %polly.loop_cond341, label %polly.loop_header334, label %polly.merge261

polly.loop_header343:                             ; preds = %polly.loop_header334, %polly.loop_header343
  %polly.indvar347 = phi i64 [ %polly.indvar_next348, %polly.loop_header343 ], [ 0, %polly.loop_header334 ]
  %p_scevgep34353 = getelementptr [1100 x double]* %G, i64 %polly.indvar338, i64 %polly.indvar347
  store double 0.000000e+00, double* %p_scevgep34353
  %polly.indvar_next348 = add nsw i64 %polly.indvar347, 1
  %polly.adjust_ub349 = sub i64 %61, 1
  %polly.loop_cond350 = icmp sle i64 %polly.indvar347, %polly.adjust_ub349
  br i1 %polly.loop_cond350, label %polly.loop_header343, label %polly.loop_exit345
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %ni, i32 %nl, [1100 x double]* noalias %G) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %ni, 0
  br i1 %5, label %.preheader.lr.ph, label %22

.preheader.lr.ph:                                 ; preds = %.split
  %6 = zext i32 %nl to i64
  %7 = zext i32 %ni to i64
  %8 = icmp sgt i32 %nl, 0
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
  %scevgep = getelementptr [1100 x double]* %G, i64 %indvar4, i64 %indvar
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
