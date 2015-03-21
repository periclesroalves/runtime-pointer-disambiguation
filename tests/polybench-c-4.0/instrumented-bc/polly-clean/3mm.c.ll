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
define internal void @init_array(i32 %ni, i32 %nj, i32 %nk, i32 %nl, i32 %nm, [1000 x double]* %A, [900 x double]* %B, [1200 x double]* %C, [1100 x double]* %D) #0 {
polly.split_new_and_old201:
  %0 = zext i32 %ni to i64
  %1 = zext i32 %nk to i64
  %2 = sext i32 %ni to i64
  %3 = icmp sge i64 %2, 1
  %4 = sext i32 %nk to i64
  %5 = icmp sge i64 %4, 1
  %6 = and i1 %3, %5
  %7 = icmp sge i64 %0, 1
  %8 = and i1 %6, %7
  %9 = icmp sge i64 %1, 1
  %10 = and i1 %8, %9
  br i1 %10, label %polly.then206, label %polly.merge205

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit74, %polly.merge107
  ret void

polly.then:                                       ; preds = %polly.merge107
  %11 = add i64 %134, -1
  %polly.loop_guard = icmp sle i64 0, %11
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit74
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit74 ], [ 0, %polly.then ]
  %12 = mul i64 -3, %134
  %13 = add i64 %12, %69
  %14 = add i64 %13, 5
  %15 = sub i64 %14, 32
  %16 = add i64 %15, 1
  %17 = icmp slt i64 %14, 0
  %18 = select i1 %17, i64 %16, i64 %14
  %19 = sdiv i64 %18, 32
  %20 = mul i64 -32, %19
  %21 = mul i64 -32, %134
  %22 = add i64 %20, %21
  %23 = mul i64 -32, %polly.indvar
  %24 = mul i64 -3, %polly.indvar
  %25 = add i64 %24, %69
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
  %polly.loop_guard75 = icmp sle i64 %36, %37
  br i1 %polly.loop_guard75, label %polly.loop_header72, label %polly.loop_exit74

polly.loop_exit74:                                ; preds = %polly.loop_exit83, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %11, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header72:                              ; preds = %polly.loop_header, %polly.loop_exit83
  %polly.indvar76 = phi i64 [ %polly.indvar_next77, %polly.loop_exit83 ], [ %36, %polly.loop_header ]
  %38 = mul i64 -1, %polly.indvar76
  %39 = mul i64 -1, %69
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
  %polly.loop_guard84 = icmp sle i64 %48, %58
  br i1 %polly.loop_guard84, label %polly.loop_header81, label %polly.loop_exit83

polly.loop_exit83:                                ; preds = %polly.loop_exit92, %polly.loop_header72
  %polly.indvar_next77 = add nsw i64 %polly.indvar76, 32
  %polly.adjust_ub78 = sub i64 %37, 32
  %polly.loop_cond79 = icmp sle i64 %polly.indvar76, %polly.adjust_ub78
  br i1 %polly.loop_cond79, label %polly.loop_header72, label %polly.loop_exit74

polly.loop_header81:                              ; preds = %polly.loop_header72, %polly.loop_exit92
  %polly.indvar85 = phi i64 [ %polly.indvar_next86, %polly.loop_exit92 ], [ %48, %polly.loop_header72 ]
  %59 = mul i64 -20, %polly.indvar85
  %60 = add i64 %59, %39
  %61 = add i64 %60, 1
  %62 = icmp sgt i64 %polly.indvar76, %61
  %63 = select i1 %62, i64 %polly.indvar76, i64 %61
  %64 = add i64 %polly.indvar76, 31
  %65 = icmp slt i64 %59, %64
  %66 = select i1 %65, i64 %59, i64 %64
  %polly.loop_guard93 = icmp sle i64 %63, %66
  br i1 %polly.loop_guard93, label %polly.loop_header90, label %polly.loop_exit92

polly.loop_exit92:                                ; preds = %polly.loop_header90, %polly.loop_header81
  %polly.indvar_next86 = add nsw i64 %polly.indvar85, 1
  %polly.adjust_ub87 = sub i64 %58, 1
  %polly.loop_cond88 = icmp sle i64 %polly.indvar85, %polly.adjust_ub87
  br i1 %polly.loop_cond88, label %polly.loop_header81, label %polly.loop_exit83

polly.loop_header90:                              ; preds = %polly.loop_header81, %polly.loop_header90
  %polly.indvar94 = phi i64 [ %polly.indvar_next95, %polly.loop_header90 ], [ %63, %polly.loop_header81 ]
  %67 = mul i64 -1, %polly.indvar94
  %68 = add i64 %59, %67
  %p_.moved.to. = mul i64 %polly.indvar85, 2
  %p_.moved.to.54 = mul nsw i32 %nk, 5
  %p_.moved.to.55 = sitofp i32 %p_.moved.to.54 to double
  %p_scevgep = getelementptr [1100 x double]* %D, i64 %polly.indvar85, i64 %68
  %p_ = mul i64 %polly.indvar85, %68
  %p_98 = add i64 %p_.moved.to., %p_
  %p_99 = trunc i64 %p_98 to i32
  %p_100 = srem i32 %p_99, %nk
  %p_101 = sitofp i32 %p_100 to double
  %p_102 = fdiv double %p_101, %p_.moved.to.55
  store double %p_102, double* %p_scevgep
  %p_indvar.next = add i64 %68, 1
  %polly.indvar_next95 = add nsw i64 %polly.indvar94, 1
  %polly.adjust_ub96 = sub i64 %66, 1
  %polly.loop_cond97 = icmp sle i64 %polly.indvar94, %polly.adjust_ub96
  br i1 %polly.loop_cond97, label %polly.loop_header90, label %polly.loop_exit92

polly.merge107:                                   ; preds = %polly.then108, %polly.loop_exit121, %polly.merge156
  %69 = zext i32 %nl to i64
  %70 = sext i32 %nl to i64
  %71 = icmp sge i64 %70, 1
  %72 = and i1 %71, %136
  %73 = and i1 %72, %139
  %74 = icmp sge i64 %69, 1
  %75 = and i1 %73, %74
  br i1 %75, label %polly.then, label %polly.merge

polly.then108:                                    ; preds = %polly.merge156
  %76 = add i64 %199, -1
  %polly.loop_guard113 = icmp sle i64 0, %76
  br i1 %polly.loop_guard113, label %polly.loop_header110, label %polly.merge107

polly.loop_header110:                             ; preds = %polly.then108, %polly.loop_exit121
  %polly.indvar114 = phi i64 [ %polly.indvar_next115, %polly.loop_exit121 ], [ 0, %polly.then108 ]
  %77 = mul i64 -3, %199
  %78 = add i64 %77, %134
  %79 = add i64 %78, 5
  %80 = sub i64 %79, 32
  %81 = add i64 %80, 1
  %82 = icmp slt i64 %79, 0
  %83 = select i1 %82, i64 %81, i64 %79
  %84 = sdiv i64 %83, 32
  %85 = mul i64 -32, %84
  %86 = mul i64 -32, %199
  %87 = add i64 %85, %86
  %88 = mul i64 -32, %polly.indvar114
  %89 = mul i64 -3, %polly.indvar114
  %90 = add i64 %89, %134
  %91 = add i64 %90, 5
  %92 = sub i64 %91, 32
  %93 = add i64 %92, 1
  %94 = icmp slt i64 %91, 0
  %95 = select i1 %94, i64 %93, i64 %91
  %96 = sdiv i64 %95, 32
  %97 = mul i64 -32, %96
  %98 = add i64 %88, %97
  %99 = add i64 %98, -640
  %100 = icmp sgt i64 %87, %99
  %101 = select i1 %100, i64 %87, i64 %99
  %102 = mul i64 -20, %polly.indvar114
  %polly.loop_guard122 = icmp sle i64 %101, %102
  br i1 %polly.loop_guard122, label %polly.loop_header119, label %polly.loop_exit121

polly.loop_exit121:                               ; preds = %polly.loop_exit130, %polly.loop_header110
  %polly.indvar_next115 = add nsw i64 %polly.indvar114, 32
  %polly.adjust_ub116 = sub i64 %76, 32
  %polly.loop_cond117 = icmp sle i64 %polly.indvar114, %polly.adjust_ub116
  br i1 %polly.loop_cond117, label %polly.loop_header110, label %polly.merge107

polly.loop_header119:                             ; preds = %polly.loop_header110, %polly.loop_exit130
  %polly.indvar123 = phi i64 [ %polly.indvar_next124, %polly.loop_exit130 ], [ %101, %polly.loop_header110 ]
  %103 = mul i64 -1, %polly.indvar123
  %104 = mul i64 -1, %134
  %105 = add i64 %103, %104
  %106 = add i64 %105, -30
  %107 = add i64 %106, 20
  %108 = sub i64 %107, 1
  %109 = icmp slt i64 %106, 0
  %110 = select i1 %109, i64 %106, i64 %108
  %111 = sdiv i64 %110, 20
  %112 = icmp sgt i64 %111, %polly.indvar114
  %113 = select i1 %112, i64 %111, i64 %polly.indvar114
  %114 = sub i64 %103, 20
  %115 = add i64 %114, 1
  %116 = icmp slt i64 %103, 0
  %117 = select i1 %116, i64 %115, i64 %103
  %118 = sdiv i64 %117, 20
  %119 = add i64 %polly.indvar114, 31
  %120 = icmp slt i64 %118, %119
  %121 = select i1 %120, i64 %118, i64 %119
  %122 = icmp slt i64 %121, %76
  %123 = select i1 %122, i64 %121, i64 %76
  %polly.loop_guard131 = icmp sle i64 %113, %123
  br i1 %polly.loop_guard131, label %polly.loop_header128, label %polly.loop_exit130

polly.loop_exit130:                               ; preds = %polly.loop_exit139, %polly.loop_header119
  %polly.indvar_next124 = add nsw i64 %polly.indvar123, 32
  %polly.adjust_ub125 = sub i64 %102, 32
  %polly.loop_cond126 = icmp sle i64 %polly.indvar123, %polly.adjust_ub125
  br i1 %polly.loop_cond126, label %polly.loop_header119, label %polly.loop_exit121

polly.loop_header128:                             ; preds = %polly.loop_header119, %polly.loop_exit139
  %polly.indvar132 = phi i64 [ %polly.indvar_next133, %polly.loop_exit139 ], [ %113, %polly.loop_header119 ]
  %124 = mul i64 -20, %polly.indvar132
  %125 = add i64 %124, %104
  %126 = add i64 %125, 1
  %127 = icmp sgt i64 %polly.indvar123, %126
  %128 = select i1 %127, i64 %polly.indvar123, i64 %126
  %129 = add i64 %polly.indvar123, 31
  %130 = icmp slt i64 %124, %129
  %131 = select i1 %130, i64 %124, i64 %129
  %polly.loop_guard140 = icmp sle i64 %128, %131
  br i1 %polly.loop_guard140, label %polly.loop_header137, label %polly.loop_exit139

polly.loop_exit139:                               ; preds = %polly.loop_header137, %polly.loop_header128
  %polly.indvar_next133 = add nsw i64 %polly.indvar132, 1
  %polly.adjust_ub134 = sub i64 %123, 1
  %polly.loop_cond135 = icmp sle i64 %polly.indvar132, %polly.adjust_ub134
  br i1 %polly.loop_cond135, label %polly.loop_header128, label %polly.loop_exit130

polly.loop_header137:                             ; preds = %polly.loop_header128, %polly.loop_header137
  %polly.indvar141 = phi i64 [ %polly.indvar_next142, %polly.loop_header137 ], [ %128, %polly.loop_header128 ]
  %132 = mul i64 -1, %polly.indvar141
  %133 = add i64 %124, %132
  %p_.moved.to.62 = mul i64 %polly.indvar132, 3
  %p_.moved.to.63 = mul nsw i32 %nl, 5
  %p_.moved.to.64 = sitofp i32 %p_.moved.to.63 to double
  %p_scevgep35 = getelementptr [1200 x double]* %C, i64 %polly.indvar132, i64 %133
  %p_146 = mul i64 %polly.indvar132, %133
  %p_147 = add i64 %p_.moved.to.62, %p_146
  %p_148 = trunc i64 %p_147 to i32
  %p_149 = srem i32 %p_148, %nl
  %p_150 = sitofp i32 %p_149 to double
  %p_151 = fdiv double %p_150, %p_.moved.to.64
  store double %p_151, double* %p_scevgep35
  %p_indvar.next31 = add i64 %133, 1
  %polly.indvar_next142 = add nsw i64 %polly.indvar141, 1
  %polly.adjust_ub143 = sub i64 %131, 1
  %polly.loop_cond144 = icmp sle i64 %polly.indvar141, %polly.adjust_ub143
  br i1 %polly.loop_cond144, label %polly.loop_header137, label %polly.loop_exit139

polly.merge156:                                   ; preds = %polly.then157, %polly.loop_exit170, %polly.merge205
  %134 = zext i32 %nm to i64
  %135 = sext i32 %nm to i64
  %136 = icmp sge i64 %135, 1
  %137 = and i1 %201, %136
  %138 = and i1 %137, %204
  %139 = icmp sge i64 %134, 1
  %140 = and i1 %138, %139
  br i1 %140, label %polly.then108, label %polly.merge107

polly.then157:                                    ; preds = %polly.merge205
  %141 = add i64 %1, -1
  %polly.loop_guard162 = icmp sle i64 0, %141
  br i1 %polly.loop_guard162, label %polly.loop_header159, label %polly.merge156

polly.loop_header159:                             ; preds = %polly.then157, %polly.loop_exit170
  %polly.indvar163 = phi i64 [ %polly.indvar_next164, %polly.loop_exit170 ], [ 0, %polly.then157 ]
  %142 = mul i64 -3, %1
  %143 = add i64 %142, %199
  %144 = add i64 %143, 5
  %145 = sub i64 %144, 32
  %146 = add i64 %145, 1
  %147 = icmp slt i64 %144, 0
  %148 = select i1 %147, i64 %146, i64 %144
  %149 = sdiv i64 %148, 32
  %150 = mul i64 -32, %149
  %151 = mul i64 -32, %1
  %152 = add i64 %150, %151
  %153 = mul i64 -32, %polly.indvar163
  %154 = mul i64 -3, %polly.indvar163
  %155 = add i64 %154, %199
  %156 = add i64 %155, 5
  %157 = sub i64 %156, 32
  %158 = add i64 %157, 1
  %159 = icmp slt i64 %156, 0
  %160 = select i1 %159, i64 %158, i64 %156
  %161 = sdiv i64 %160, 32
  %162 = mul i64 -32, %161
  %163 = add i64 %153, %162
  %164 = add i64 %163, -640
  %165 = icmp sgt i64 %152, %164
  %166 = select i1 %165, i64 %152, i64 %164
  %167 = mul i64 -20, %polly.indvar163
  %polly.loop_guard171 = icmp sle i64 %166, %167
  br i1 %polly.loop_guard171, label %polly.loop_header168, label %polly.loop_exit170

polly.loop_exit170:                               ; preds = %polly.loop_exit179, %polly.loop_header159
  %polly.indvar_next164 = add nsw i64 %polly.indvar163, 32
  %polly.adjust_ub165 = sub i64 %141, 32
  %polly.loop_cond166 = icmp sle i64 %polly.indvar163, %polly.adjust_ub165
  br i1 %polly.loop_cond166, label %polly.loop_header159, label %polly.merge156

polly.loop_header168:                             ; preds = %polly.loop_header159, %polly.loop_exit179
  %polly.indvar172 = phi i64 [ %polly.indvar_next173, %polly.loop_exit179 ], [ %166, %polly.loop_header159 ]
  %168 = mul i64 -1, %polly.indvar172
  %169 = mul i64 -1, %199
  %170 = add i64 %168, %169
  %171 = add i64 %170, -30
  %172 = add i64 %171, 20
  %173 = sub i64 %172, 1
  %174 = icmp slt i64 %171, 0
  %175 = select i1 %174, i64 %171, i64 %173
  %176 = sdiv i64 %175, 20
  %177 = icmp sgt i64 %176, %polly.indvar163
  %178 = select i1 %177, i64 %176, i64 %polly.indvar163
  %179 = sub i64 %168, 20
  %180 = add i64 %179, 1
  %181 = icmp slt i64 %168, 0
  %182 = select i1 %181, i64 %180, i64 %168
  %183 = sdiv i64 %182, 20
  %184 = add i64 %polly.indvar163, 31
  %185 = icmp slt i64 %183, %184
  %186 = select i1 %185, i64 %183, i64 %184
  %187 = icmp slt i64 %186, %141
  %188 = select i1 %187, i64 %186, i64 %141
  %polly.loop_guard180 = icmp sle i64 %178, %188
  br i1 %polly.loop_guard180, label %polly.loop_header177, label %polly.loop_exit179

polly.loop_exit179:                               ; preds = %polly.loop_exit188, %polly.loop_header168
  %polly.indvar_next173 = add nsw i64 %polly.indvar172, 32
  %polly.adjust_ub174 = sub i64 %167, 32
  %polly.loop_cond175 = icmp sle i64 %polly.indvar172, %polly.adjust_ub174
  br i1 %polly.loop_cond175, label %polly.loop_header168, label %polly.loop_exit170

polly.loop_header177:                             ; preds = %polly.loop_header168, %polly.loop_exit188
  %polly.indvar181 = phi i64 [ %polly.indvar_next182, %polly.loop_exit188 ], [ %178, %polly.loop_header168 ]
  %189 = mul i64 -20, %polly.indvar181
  %190 = add i64 %189, %169
  %191 = add i64 %190, 1
  %192 = icmp sgt i64 %polly.indvar172, %191
  %193 = select i1 %192, i64 %polly.indvar172, i64 %191
  %194 = add i64 %polly.indvar172, 31
  %195 = icmp slt i64 %189, %194
  %196 = select i1 %195, i64 %189, i64 %194
  %polly.loop_guard189 = icmp sle i64 %193, %196
  br i1 %polly.loop_guard189, label %polly.loop_header186, label %polly.loop_exit188

polly.loop_exit188:                               ; preds = %polly.loop_header186, %polly.loop_header177
  %polly.indvar_next182 = add nsw i64 %polly.indvar181, 1
  %polly.adjust_ub183 = sub i64 %188, 1
  %polly.loop_cond184 = icmp sle i64 %polly.indvar181, %polly.adjust_ub183
  br i1 %polly.loop_cond184, label %polly.loop_header177, label %polly.loop_exit179

polly.loop_header186:                             ; preds = %polly.loop_header177, %polly.loop_header186
  %polly.indvar190 = phi i64 [ %polly.indvar_next191, %polly.loop_header186 ], [ %193, %polly.loop_header177 ]
  %197 = mul i64 -1, %polly.indvar190
  %198 = add i64 %189, %197
  %p_.moved.to.58 = mul nsw i32 %nj, 5
  %p_.moved.to.59 = sitofp i32 %p_.moved.to.58 to double
  %p_scevgep43 = getelementptr [900 x double]* %B, i64 %polly.indvar181, i64 %198
  %p_195 = mul i64 %polly.indvar181, %198
  %p_196 = add i64 %polly.indvar181, %p_195
  %p_197 = trunc i64 %p_196 to i32
  %p_198 = srem i32 %p_197, %nj
  %p_199 = sitofp i32 %p_198 to double
  %p_200 = fdiv double %p_199, %p_.moved.to.59
  store double %p_200, double* %p_scevgep43
  %p_indvar.next39 = add i64 %198, 1
  %polly.indvar_next191 = add nsw i64 %polly.indvar190, 1
  %polly.adjust_ub192 = sub i64 %196, 1
  %polly.loop_cond193 = icmp sle i64 %polly.indvar190, %polly.adjust_ub192
  br i1 %polly.loop_cond193, label %polly.loop_header186, label %polly.loop_exit188

polly.merge205:                                   ; preds = %polly.then206, %polly.loop_exit219, %polly.split_new_and_old201
  %199 = zext i32 %nj to i64
  %200 = sext i32 %nj to i64
  %201 = icmp sge i64 %200, 1
  %202 = and i1 %201, %5
  %203 = and i1 %202, %9
  %204 = icmp sge i64 %199, 1
  %205 = and i1 %203, %204
  br i1 %205, label %polly.then157, label %polly.merge156

polly.then206:                                    ; preds = %polly.split_new_and_old201
  %206 = add i64 %0, -1
  %polly.loop_guard211 = icmp sle i64 0, %206
  br i1 %polly.loop_guard211, label %polly.loop_header208, label %polly.merge205

polly.loop_header208:                             ; preds = %polly.then206, %polly.loop_exit219
  %polly.indvar212 = phi i64 [ %polly.indvar_next213, %polly.loop_exit219 ], [ 0, %polly.then206 ]
  %207 = mul i64 -3, %0
  %208 = add i64 %207, %1
  %209 = add i64 %208, 5
  %210 = sub i64 %209, 32
  %211 = add i64 %210, 1
  %212 = icmp slt i64 %209, 0
  %213 = select i1 %212, i64 %211, i64 %209
  %214 = sdiv i64 %213, 32
  %215 = mul i64 -32, %214
  %216 = mul i64 -32, %0
  %217 = add i64 %215, %216
  %218 = mul i64 -32, %polly.indvar212
  %219 = mul i64 -3, %polly.indvar212
  %220 = add i64 %219, %1
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
  %232 = mul i64 -20, %polly.indvar212
  %polly.loop_guard220 = icmp sle i64 %231, %232
  br i1 %polly.loop_guard220, label %polly.loop_header217, label %polly.loop_exit219

polly.loop_exit219:                               ; preds = %polly.loop_exit228, %polly.loop_header208
  %polly.indvar_next213 = add nsw i64 %polly.indvar212, 32
  %polly.adjust_ub214 = sub i64 %206, 32
  %polly.loop_cond215 = icmp sle i64 %polly.indvar212, %polly.adjust_ub214
  br i1 %polly.loop_cond215, label %polly.loop_header208, label %polly.merge205

polly.loop_header217:                             ; preds = %polly.loop_header208, %polly.loop_exit228
  %polly.indvar221 = phi i64 [ %polly.indvar_next222, %polly.loop_exit228 ], [ %231, %polly.loop_header208 ]
  %233 = mul i64 -1, %polly.indvar221
  %234 = mul i64 -1, %1
  %235 = add i64 %233, %234
  %236 = add i64 %235, -30
  %237 = add i64 %236, 20
  %238 = sub i64 %237, 1
  %239 = icmp slt i64 %236, 0
  %240 = select i1 %239, i64 %236, i64 %238
  %241 = sdiv i64 %240, 20
  %242 = icmp sgt i64 %241, %polly.indvar212
  %243 = select i1 %242, i64 %241, i64 %polly.indvar212
  %244 = sub i64 %233, 20
  %245 = add i64 %244, 1
  %246 = icmp slt i64 %233, 0
  %247 = select i1 %246, i64 %245, i64 %233
  %248 = sdiv i64 %247, 20
  %249 = add i64 %polly.indvar212, 31
  %250 = icmp slt i64 %248, %249
  %251 = select i1 %250, i64 %248, i64 %249
  %252 = icmp slt i64 %251, %206
  %253 = select i1 %252, i64 %251, i64 %206
  %polly.loop_guard229 = icmp sle i64 %243, %253
  br i1 %polly.loop_guard229, label %polly.loop_header226, label %polly.loop_exit228

polly.loop_exit228:                               ; preds = %polly.loop_exit237, %polly.loop_header217
  %polly.indvar_next222 = add nsw i64 %polly.indvar221, 32
  %polly.adjust_ub223 = sub i64 %232, 32
  %polly.loop_cond224 = icmp sle i64 %polly.indvar221, %polly.adjust_ub223
  br i1 %polly.loop_cond224, label %polly.loop_header217, label %polly.loop_exit219

polly.loop_header226:                             ; preds = %polly.loop_header217, %polly.loop_exit237
  %polly.indvar230 = phi i64 [ %polly.indvar_next231, %polly.loop_exit237 ], [ %243, %polly.loop_header217 ]
  %254 = mul i64 -20, %polly.indvar230
  %255 = add i64 %254, %234
  %256 = add i64 %255, 1
  %257 = icmp sgt i64 %polly.indvar221, %256
  %258 = select i1 %257, i64 %polly.indvar221, i64 %256
  %259 = add i64 %polly.indvar221, 31
  %260 = icmp slt i64 %254, %259
  %261 = select i1 %260, i64 %254, i64 %259
  %polly.loop_guard238 = icmp sle i64 %258, %261
  br i1 %polly.loop_guard238, label %polly.loop_header235, label %polly.loop_exit237

polly.loop_exit237:                               ; preds = %polly.loop_header235, %polly.loop_header226
  %polly.indvar_next231 = add nsw i64 %polly.indvar230, 1
  %polly.adjust_ub232 = sub i64 %253, 1
  %polly.loop_cond233 = icmp sle i64 %polly.indvar230, %polly.adjust_ub232
  br i1 %polly.loop_cond233, label %polly.loop_header226, label %polly.loop_exit228

polly.loop_header235:                             ; preds = %polly.loop_header226, %polly.loop_header235
  %polly.indvar239 = phi i64 [ %polly.indvar_next240, %polly.loop_header235 ], [ %258, %polly.loop_header226 ]
  %262 = mul i64 -1, %polly.indvar239
  %263 = add i64 %254, %262
  %p_.moved.to.67 = mul nsw i32 %ni, 5
  %p_.moved.to.68 = sitofp i32 %p_.moved.to.67 to double
  %p_scevgep51 = getelementptr [1000 x double]* %A, i64 %polly.indvar230, i64 %263
  %p_244 = mul i64 %polly.indvar230, %263
  %p_245 = trunc i64 %p_244 to i32
  %p_246 = srem i32 %p_245, %ni
  %p_247 = sitofp i32 %p_246 to double
  %p_248 = fdiv double %p_247, %p_.moved.to.68
  store double %p_248, double* %p_scevgep51
  %p_indvar.next47 = add i64 %263, 1
  %polly.indvar_next240 = add nsw i64 %polly.indvar239, 1
  %polly.adjust_ub241 = sub i64 %261, 1
  %polly.loop_cond242 = icmp sle i64 %polly.indvar239, %polly.adjust_ub241
  br i1 %polly.loop_cond242, label %polly.loop_header235, label %polly.loop_exit237
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_3mm(i32 %ni, i32 %nj, i32 %nk, i32 %nl, i32 %nm, [900 x double]* %E, [1000 x double]* %A, [900 x double]* %B, [1100 x double]* %F, [1200 x double]* %C, [1100 x double]* %D, [1100 x double]* %G) #0 {
.split:
  %0 = icmp sgt i32 %ni, 0
  br i1 %0, label %.preheader4.lr.ph, label %.preheader3

.preheader4.lr.ph:                                ; preds = %.split
  %1 = zext i32 %nk to i64
  %2 = zext i32 %nj to i64
  %3 = zext i32 %ni to i64
  %4 = icmp sgt i32 %nj, 0
  %5 = icmp sgt i32 %nk, 0
  br label %.preheader4

.preheader4:                                      ; preds = %.preheader4.lr.ph, %._crit_edge25
  %indvar56 = phi i64 [ 0, %.preheader4.lr.ph ], [ %indvar.next57, %._crit_edge25 ]
  br i1 %4, label %.lr.ph24, label %._crit_edge25

.preheader3:                                      ; preds = %._crit_edge25, %.split
  %6 = icmp sgt i32 %nj, 0
  br i1 %6, label %.preheader2.lr.ph, label %.preheader1

.preheader2.lr.ph:                                ; preds = %.preheader3
  %7 = zext i32 %nm to i64
  %8 = zext i32 %nl to i64
  %9 = zext i32 %nj to i64
  %10 = icmp sgt i32 %nl, 0
  %11 = icmp sgt i32 %nm, 0
  br label %.preheader2

.lr.ph24:                                         ; preds = %.preheader4, %._crit_edge22
  %indvar59 = phi i64 [ %indvar.next60, %._crit_edge22 ], [ 0, %.preheader4 ]
  %scevgep64 = getelementptr [900 x double]* %E, i64 %indvar56, i64 %indvar59
  store double 0.000000e+00, double* %scevgep64, align 8, !tbaa !6
  br i1 %5, label %.lr.ph21, label %._crit_edge22

.lr.ph21:                                         ; preds = %.lr.ph24, %.lr.ph21
  %indvar53 = phi i64 [ %indvar.next54, %.lr.ph21 ], [ 0, %.lr.ph24 ]
  %scevgep58 = getelementptr [1000 x double]* %A, i64 %indvar56, i64 %indvar53
  %scevgep61 = getelementptr [900 x double]* %B, i64 %indvar53, i64 %indvar59
  %12 = load double* %scevgep58, align 8, !tbaa !6
  %13 = load double* %scevgep61, align 8, !tbaa !6
  %14 = fmul double %12, %13
  %15 = load double* %scevgep64, align 8, !tbaa !6
  %16 = fadd double %15, %14
  store double %16, double* %scevgep64, align 8, !tbaa !6
  %indvar.next54 = add i64 %indvar53, 1
  %exitcond55 = icmp ne i64 %indvar.next54, %1
  br i1 %exitcond55, label %.lr.ph21, label %._crit_edge22

._crit_edge22:                                    ; preds = %.lr.ph21, %.lr.ph24
  %indvar.next60 = add i64 %indvar59, 1
  %exitcond62 = icmp ne i64 %indvar.next60, %2
  br i1 %exitcond62, label %.lr.ph24, label %._crit_edge25

._crit_edge25:                                    ; preds = %._crit_edge22, %.preheader4
  %indvar.next57 = add i64 %indvar56, 1
  %exitcond65 = icmp ne i64 %indvar.next57, %3
  br i1 %exitcond65, label %.preheader4, label %.preheader3

.preheader2:                                      ; preds = %.preheader2.lr.ph, %._crit_edge17
  %indvar41 = phi i64 [ 0, %.preheader2.lr.ph ], [ %indvar.next42, %._crit_edge17 ]
  br i1 %10, label %.lr.ph16, label %._crit_edge17

.preheader1:                                      ; preds = %._crit_edge17, %.preheader3
  br i1 %0, label %.preheader.lr.ph, label %._crit_edge10

.preheader.lr.ph:                                 ; preds = %.preheader1
  %17 = zext i32 %nj to i64
  %18 = zext i32 %nl to i64
  %19 = zext i32 %ni to i64
  %20 = icmp sgt i32 %nl, 0
  br label %.preheader

.lr.ph16:                                         ; preds = %.preheader2, %._crit_edge14
  %indvar44 = phi i64 [ %indvar.next45, %._crit_edge14 ], [ 0, %.preheader2 ]
  %scevgep49 = getelementptr [1100 x double]* %F, i64 %indvar41, i64 %indvar44
  store double 0.000000e+00, double* %scevgep49, align 8, !tbaa !6
  br i1 %11, label %.lr.ph13, label %._crit_edge14

.lr.ph13:                                         ; preds = %.lr.ph16, %.lr.ph13
  %indvar38 = phi i64 [ %indvar.next39, %.lr.ph13 ], [ 0, %.lr.ph16 ]
  %scevgep43 = getelementptr [1200 x double]* %C, i64 %indvar41, i64 %indvar38
  %scevgep46 = getelementptr [1100 x double]* %D, i64 %indvar38, i64 %indvar44
  %21 = load double* %scevgep43, align 8, !tbaa !6
  %22 = load double* %scevgep46, align 8, !tbaa !6
  %23 = fmul double %21, %22
  %24 = load double* %scevgep49, align 8, !tbaa !6
  %25 = fadd double %24, %23
  store double %25, double* %scevgep49, align 8, !tbaa !6
  %indvar.next39 = add i64 %indvar38, 1
  %exitcond40 = icmp ne i64 %indvar.next39, %7
  br i1 %exitcond40, label %.lr.ph13, label %._crit_edge14

._crit_edge14:                                    ; preds = %.lr.ph13, %.lr.ph16
  %indvar.next45 = add i64 %indvar44, 1
  %exitcond47 = icmp ne i64 %indvar.next45, %8
  br i1 %exitcond47, label %.lr.ph16, label %._crit_edge17

._crit_edge17:                                    ; preds = %._crit_edge14, %.preheader2
  %indvar.next42 = add i64 %indvar41, 1
  %exitcond50 = icmp ne i64 %indvar.next42, %9
  br i1 %exitcond50, label %.preheader2, label %.preheader1

.preheader:                                       ; preds = %.preheader.lr.ph, %._crit_edge8
  %indvar27 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next28, %._crit_edge8 ]
  br i1 %20, label %.lr.ph7, label %._crit_edge8

.lr.ph7:                                          ; preds = %.preheader, %._crit_edge
  %indvar29 = phi i64 [ %indvar.next30, %._crit_edge ], [ 0, %.preheader ]
  %scevgep34 = getelementptr [1100 x double]* %G, i64 %indvar27, i64 %indvar29
  store double 0.000000e+00, double* %scevgep34, align 8, !tbaa !6
  br i1 %6, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %.lr.ph7, %.lr.ph
  %indvar = phi i64 [ %indvar.next, %.lr.ph ], [ 0, %.lr.ph7 ]
  %scevgep = getelementptr [900 x double]* %E, i64 %indvar27, i64 %indvar
  %scevgep31 = getelementptr [1100 x double]* %F, i64 %indvar, i64 %indvar29
  %26 = load double* %scevgep, align 8, !tbaa !6
  %27 = load double* %scevgep31, align 8, !tbaa !6
  %28 = fmul double %26, %27
  %29 = load double* %scevgep34, align 8, !tbaa !6
  %30 = fadd double %29, %28
  store double %30, double* %scevgep34, align 8, !tbaa !6
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %17
  br i1 %exitcond, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %.lr.ph7
  %indvar.next30 = add i64 %indvar29, 1
  %exitcond32 = icmp ne i64 %indvar.next30, %18
  br i1 %exitcond32, label %.lr.ph7, label %._crit_edge8

._crit_edge8:                                     ; preds = %._crit_edge, %.preheader
  %indvar.next28 = add i64 %indvar27, 1
  %exitcond35 = icmp ne i64 %indvar.next28, %19
  br i1 %exitcond35, label %.preheader, label %._crit_edge10

._crit_edge10:                                    ; preds = %._crit_edge8, %.preheader1
  ret void
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %ni, i32 %nl, [1100 x double]* %G) #0 {
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
