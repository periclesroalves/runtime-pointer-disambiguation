; ModuleID = './linear-algebra/kernels/2mm/2mm.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [2 x i8] c"D\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %alpha = alloca double, align 8
  %beta = alloca double, align 8
  %0 = tail call i8* @polybench_alloc_data(i64 720000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 880000, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 990000, i32 8) #3
  %3 = tail call i8* @polybench_alloc_data(i64 1080000, i32 8) #3
  %4 = tail call i8* @polybench_alloc_data(i64 960000, i32 8) #3
  %5 = bitcast i8* %1 to [1100 x double]*
  %6 = bitcast i8* %2 to [900 x double]*
  %7 = bitcast i8* %3 to [1200 x double]*
  %8 = bitcast i8* %4 to [1200 x double]*
  call void @init_array(i32 800, i32 900, i32 1100, i32 1200, double* %alpha, double* %beta, [1100 x double]* %5, [900 x double]* %6, [1200 x double]* %7, [1200 x double]* %8)
  call void (...)* @polybench_timer_start() #3
  %9 = load double* %alpha, align 8, !tbaa !1
  %10 = load double* %beta, align 8, !tbaa !1
  %11 = bitcast i8* %0 to [900 x double]*
  call void @kernel_2mm(i32 800, i32 900, i32 1100, i32 1200, double %9, double %10, [900 x double]* %11, [1100 x double]* %5, [900 x double]* %6, [1200 x double]* %7, [1200 x double]* %8)
  call void (...)* @polybench_timer_stop() #3
  call void (...)* @polybench_timer_print() #3
  %12 = icmp sgt i32 %argc, 42
  br i1 %12, label %13, label %17

; <label>:13                                      ; preds = %.split
  %14 = load i8** %argv, align 8, !tbaa !5
  %15 = load i8* %14, align 1, !tbaa !7
  %phitmp = icmp eq i8 %15, 0
  br i1 %phitmp, label %16, label %17

; <label>:16                                      ; preds = %13
  call void @print_array(i32 800, i32 1200, [1200 x double]* %8)
  br label %17

; <label>:17                                      ; preds = %13, %16, %.split
  call void @free(i8* %0) #3
  call void @free(i8* %1) #3
  call void @free(i8* %2) #3
  call void @free(i8* %3) #3
  call void @free(i8* %4) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %ni, i32 %nj, i32 %nk, i32 %nl, double* %alpha, double* %beta, [1100 x double]* %A, [900 x double]* %B, [1200 x double]* %C, [1200 x double]* %D) #0 {
.split:
  %alpha54 = bitcast double* %alpha to i8*
  %beta55 = bitcast double* %beta to i8*
  %A57 = bitcast [1100 x double]* %A to i8*
  %A56 = ptrtoint [1100 x double]* %A to i64
  %0 = icmp ult i8* %alpha54, %beta55
  %1 = icmp ult i8* %beta55, %alpha54
  %pair-no-alias = or i1 %0, %1
  %2 = zext i32 %ni to i64
  %3 = add i64 %2, -1
  %4 = mul i64 8800, %3
  %5 = add i64 %A56, %4
  %6 = zext i32 %nk to i64
  %7 = add i64 %6, -1
  %8 = mul i64 8, %7
  %9 = add i64 %5, %8
  %10 = inttoptr i64 %9 to i8*
  %11 = icmp ult i8* %alpha54, %A57
  %12 = icmp ult i8* %10, %alpha54
  %pair-no-alias58 = or i1 %11, %12
  %13 = and i1 %pair-no-alias, %pair-no-alias58
  %14 = icmp ult i8* %beta55, %A57
  %15 = icmp ult i8* %10, %beta55
  %pair-no-alias59 = or i1 %14, %15
  %16 = and i1 %13, %pair-no-alias59
  br i1 %16, label %polly.start222, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  store double 1.500000e+00, double* %alpha, align 8, !tbaa !1
  store double 1.200000e+00, double* %beta, align 8, !tbaa !1
  %17 = icmp sgt i32 %ni, 0
  br i1 %17, label %.preheader6.lr.ph.clone, label %polly.start173

.preheader6.lr.ph.clone:                          ; preds = %.split.split.clone
  %18 = sitofp i32 %ni to double
  %19 = sext i32 %nk to i64
  %20 = icmp sge i64 %19, 1
  %21 = icmp sge i64 %2, 1
  %22 = and i1 %20, %21
  %23 = icmp sge i64 %6, 1
  %24 = and i1 %22, %23
  br i1 %24, label %polly.then275, label %polly.start173

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit92, %polly.merge126
  ret void

polly.then:                                       ; preds = %polly.merge126
  %polly.loop_guard = icmp sle i64 0, %3
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit92
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit92 ], [ 0, %polly.then ]
  %25 = mul i64 -3, %2
  %26 = add i64 %25, %156
  %27 = add i64 %26, 5
  %28 = sub i64 %27, 32
  %29 = add i64 %28, 1
  %30 = icmp slt i64 %27, 0
  %31 = select i1 %30, i64 %29, i64 %27
  %32 = sdiv i64 %31, 32
  %33 = mul i64 -32, %32
  %34 = mul i64 -32, %2
  %35 = add i64 %33, %34
  %36 = mul i64 -32, %polly.indvar
  %37 = mul i64 -3, %polly.indvar
  %38 = add i64 %37, %156
  %39 = add i64 %38, 5
  %40 = sub i64 %39, 32
  %41 = add i64 %40, 1
  %42 = icmp slt i64 %39, 0
  %43 = select i1 %42, i64 %41, i64 %39
  %44 = sdiv i64 %43, 32
  %45 = mul i64 -32, %44
  %46 = add i64 %36, %45
  %47 = add i64 %46, -640
  %48 = icmp sgt i64 %35, %47
  %49 = select i1 %48, i64 %35, i64 %47
  %50 = mul i64 -20, %polly.indvar
  %polly.loop_guard93 = icmp sle i64 %49, %50
  br i1 %polly.loop_guard93, label %polly.loop_header90, label %polly.loop_exit92

polly.loop_exit92:                                ; preds = %polly.loop_exit101, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %3, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header90:                              ; preds = %polly.loop_header, %polly.loop_exit101
  %polly.indvar94 = phi i64 [ %polly.indvar_next95, %polly.loop_exit101 ], [ %49, %polly.loop_header ]
  %51 = mul i64 -1, %polly.indvar94
  %52 = mul i64 -1, %156
  %53 = add i64 %51, %52
  %54 = add i64 %53, -30
  %55 = add i64 %54, 20
  %56 = sub i64 %55, 1
  %57 = icmp slt i64 %54, 0
  %58 = select i1 %57, i64 %54, i64 %56
  %59 = sdiv i64 %58, 20
  %60 = icmp sgt i64 %59, %polly.indvar
  %61 = select i1 %60, i64 %59, i64 %polly.indvar
  %62 = sub i64 %51, 20
  %63 = add i64 %62, 1
  %64 = icmp slt i64 %51, 0
  %65 = select i1 %64, i64 %63, i64 %51
  %66 = sdiv i64 %65, 20
  %67 = add i64 %polly.indvar, 31
  %68 = icmp slt i64 %66, %67
  %69 = select i1 %68, i64 %66, i64 %67
  %70 = icmp slt i64 %69, %3
  %71 = select i1 %70, i64 %69, i64 %3
  %polly.loop_guard102 = icmp sle i64 %61, %71
  br i1 %polly.loop_guard102, label %polly.loop_header99, label %polly.loop_exit101

polly.loop_exit101:                               ; preds = %polly.loop_exit110, %polly.loop_header90
  %polly.indvar_next95 = add nsw i64 %polly.indvar94, 32
  %polly.adjust_ub96 = sub i64 %50, 32
  %polly.loop_cond97 = icmp sle i64 %polly.indvar94, %polly.adjust_ub96
  br i1 %polly.loop_cond97, label %polly.loop_header90, label %polly.loop_exit92

polly.loop_header99:                              ; preds = %polly.loop_header90, %polly.loop_exit110
  %polly.indvar103 = phi i64 [ %polly.indvar_next104, %polly.loop_exit110 ], [ %61, %polly.loop_header90 ]
  %72 = mul i64 -20, %polly.indvar103
  %73 = add i64 %72, %52
  %74 = add i64 %73, 1
  %75 = icmp sgt i64 %polly.indvar94, %74
  %76 = select i1 %75, i64 %polly.indvar94, i64 %74
  %77 = add i64 %polly.indvar94, 31
  %78 = icmp slt i64 %72, %77
  %79 = select i1 %78, i64 %72, i64 %77
  %polly.loop_guard111 = icmp sle i64 %76, %79
  br i1 %polly.loop_guard111, label %polly.loop_header108, label %polly.loop_exit110

polly.loop_exit110:                               ; preds = %polly.loop_header108, %polly.loop_header99
  %polly.indvar_next104 = add nsw i64 %polly.indvar103, 1
  %polly.adjust_ub105 = sub i64 %71, 1
  %polly.loop_cond106 = icmp sle i64 %polly.indvar103, %polly.adjust_ub105
  br i1 %polly.loop_cond106, label %polly.loop_header99, label %polly.loop_exit101

polly.loop_header108:                             ; preds = %polly.loop_header99, %polly.loop_header108
  %polly.indvar112 = phi i64 [ %polly.indvar_next113, %polly.loop_header108 ], [ %76, %polly.loop_header99 ]
  %80 = mul i64 -1, %polly.indvar112
  %81 = add i64 %72, %80
  %p_.moved.to.75 = mul i64 %polly.indvar103, 2
  %p_.moved.to.76 = sitofp i32 %nk to double
  %p_scevgep = getelementptr [1200 x double]* %D, i64 %polly.indvar103, i64 %81
  %p_ = mul i64 %polly.indvar103, %81
  %p_116 = add i64 %p_.moved.to.75, %p_
  %p_117 = trunc i64 %p_116 to i32
  %p_118 = srem i32 %p_117, %nk
  %p_119 = sitofp i32 %p_118 to double
  %p_120 = fdiv double %p_119, %p_.moved.to.76
  store double %p_120, double* %p_scevgep
  %p_indvar.next = add i64 %81, 1
  %polly.indvar_next113 = add nsw i64 %polly.indvar112, 1
  %polly.adjust_ub114 = sub i64 %79, 1
  %polly.loop_cond115 = icmp sle i64 %polly.indvar112, %polly.adjust_ub114
  br i1 %polly.loop_cond115, label %polly.loop_header108, label %polly.loop_exit110

polly.merge126:                                   ; preds = %polly.then127, %polly.loop_exit140, %polly.merge176
  %82 = sext i32 %ni to i64
  %83 = icmp sge i64 %82, 1
  %84 = and i1 %83, %158
  %85 = icmp sge i64 %2, 1
  %86 = and i1 %84, %85
  %87 = and i1 %86, %161
  br i1 %87, label %polly.then, label %polly.merge

polly.then127:                                    ; preds = %polly.merge176
  %88 = add i64 %146, -1
  %polly.loop_guard132 = icmp sle i64 0, %88
  br i1 %polly.loop_guard132, label %polly.loop_header129, label %polly.merge126

polly.loop_header129:                             ; preds = %polly.then127, %polly.loop_exit140
  %polly.indvar133 = phi i64 [ %polly.indvar_next134, %polly.loop_exit140 ], [ 0, %polly.then127 ]
  %89 = mul i64 -3, %146
  %90 = add i64 %89, %156
  %91 = add i64 %90, 5
  %92 = sub i64 %91, 32
  %93 = add i64 %92, 1
  %94 = icmp slt i64 %91, 0
  %95 = select i1 %94, i64 %93, i64 %91
  %96 = sdiv i64 %95, 32
  %97 = mul i64 -32, %96
  %98 = mul i64 -32, %146
  %99 = add i64 %97, %98
  %100 = mul i64 -32, %polly.indvar133
  %101 = mul i64 -3, %polly.indvar133
  %102 = add i64 %101, %156
  %103 = add i64 %102, 5
  %104 = sub i64 %103, 32
  %105 = add i64 %104, 1
  %106 = icmp slt i64 %103, 0
  %107 = select i1 %106, i64 %105, i64 %103
  %108 = sdiv i64 %107, 32
  %109 = mul i64 -32, %108
  %110 = add i64 %100, %109
  %111 = add i64 %110, -640
  %112 = icmp sgt i64 %99, %111
  %113 = select i1 %112, i64 %99, i64 %111
  %114 = mul i64 -20, %polly.indvar133
  %polly.loop_guard141 = icmp sle i64 %113, %114
  br i1 %polly.loop_guard141, label %polly.loop_header138, label %polly.loop_exit140

polly.loop_exit140:                               ; preds = %polly.loop_exit149, %polly.loop_header129
  %polly.indvar_next134 = add nsw i64 %polly.indvar133, 32
  %polly.adjust_ub135 = sub i64 %88, 32
  %polly.loop_cond136 = icmp sle i64 %polly.indvar133, %polly.adjust_ub135
  br i1 %polly.loop_cond136, label %polly.loop_header129, label %polly.merge126

polly.loop_header138:                             ; preds = %polly.loop_header129, %polly.loop_exit149
  %polly.indvar142 = phi i64 [ %polly.indvar_next143, %polly.loop_exit149 ], [ %113, %polly.loop_header129 ]
  %115 = mul i64 -1, %polly.indvar142
  %116 = mul i64 -1, %156
  %117 = add i64 %115, %116
  %118 = add i64 %117, -30
  %119 = add i64 %118, 20
  %120 = sub i64 %119, 1
  %121 = icmp slt i64 %118, 0
  %122 = select i1 %121, i64 %118, i64 %120
  %123 = sdiv i64 %122, 20
  %124 = icmp sgt i64 %123, %polly.indvar133
  %125 = select i1 %124, i64 %123, i64 %polly.indvar133
  %126 = sub i64 %115, 20
  %127 = add i64 %126, 1
  %128 = icmp slt i64 %115, 0
  %129 = select i1 %128, i64 %127, i64 %115
  %130 = sdiv i64 %129, 20
  %131 = add i64 %polly.indvar133, 31
  %132 = icmp slt i64 %130, %131
  %133 = select i1 %132, i64 %130, i64 %131
  %134 = icmp slt i64 %133, %88
  %135 = select i1 %134, i64 %133, i64 %88
  %polly.loop_guard150 = icmp sle i64 %125, %135
  br i1 %polly.loop_guard150, label %polly.loop_header147, label %polly.loop_exit149

polly.loop_exit149:                               ; preds = %polly.loop_exit158, %polly.loop_header138
  %polly.indvar_next143 = add nsw i64 %polly.indvar142, 32
  %polly.adjust_ub144 = sub i64 %114, 32
  %polly.loop_cond145 = icmp sle i64 %polly.indvar142, %polly.adjust_ub144
  br i1 %polly.loop_cond145, label %polly.loop_header138, label %polly.loop_exit140

polly.loop_header147:                             ; preds = %polly.loop_header138, %polly.loop_exit158
  %polly.indvar151 = phi i64 [ %polly.indvar_next152, %polly.loop_exit158 ], [ %125, %polly.loop_header138 ]
  %136 = mul i64 -20, %polly.indvar151
  %137 = add i64 %136, %116
  %138 = add i64 %137, 1
  %139 = icmp sgt i64 %polly.indvar142, %138
  %140 = select i1 %139, i64 %polly.indvar142, i64 %138
  %141 = add i64 %polly.indvar142, 31
  %142 = icmp slt i64 %136, %141
  %143 = select i1 %142, i64 %136, i64 %141
  %polly.loop_guard159 = icmp sle i64 %140, %143
  br i1 %polly.loop_guard159, label %polly.loop_header156, label %polly.loop_exit158

polly.loop_exit158:                               ; preds = %polly.loop_header156, %polly.loop_header147
  %polly.indvar_next152 = add nsw i64 %polly.indvar151, 1
  %polly.adjust_ub153 = sub i64 %135, 1
  %polly.loop_cond154 = icmp sle i64 %polly.indvar151, %polly.adjust_ub153
  br i1 %polly.loop_cond154, label %polly.loop_header147, label %polly.loop_exit149

polly.loop_header156:                             ; preds = %polly.loop_header147, %polly.loop_header156
  %polly.indvar160 = phi i64 [ %polly.indvar_next161, %polly.loop_header156 ], [ %140, %polly.loop_header147 ]
  %144 = mul i64 -1, %polly.indvar160
  %145 = add i64 %136, %144
  %p_.moved.to. = mul i64 %polly.indvar151, 3
  %p_.moved.to.60 = sitofp i32 %nl to double
  %p_scevgep35 = getelementptr [1200 x double]* %C, i64 %polly.indvar151, i64 %145
  %p_165 = mul i64 %polly.indvar151, %145
  %p_166 = add i64 %p_.moved.to., %p_165
  %p_167 = trunc i64 %p_166 to i32
  %p_168 = srem i32 %p_167, %nl
  %p_169 = sitofp i32 %p_168 to double
  %p_170 = fdiv double %p_169, %p_.moved.to.60
  store double %p_170, double* %p_scevgep35
  %p_indvar.next31 = add i64 %145, 1
  %polly.indvar_next161 = add nsw i64 %polly.indvar160, 1
  %polly.adjust_ub162 = sub i64 %143, 1
  %polly.loop_cond163 = icmp sle i64 %polly.indvar160, %polly.adjust_ub162
  br i1 %polly.loop_cond163, label %polly.loop_header156, label %polly.loop_exit158

polly.start173:                                   ; preds = %polly.then275, %polly.loop_exit288, %.preheader6.lr.ph.clone, %.split.split.clone, %polly.stmt..split.split
  %146 = zext i32 %nj to i64
  %147 = sext i32 %nj to i64
  %148 = icmp sge i64 %147, 1
  %149 = sext i32 %nk to i64
  %150 = icmp sge i64 %149, 1
  %151 = and i1 %148, %150
  %152 = icmp sge i64 %6, 1
  %153 = and i1 %151, %152
  %154 = icmp sge i64 %146, 1
  %155 = and i1 %153, %154
  br i1 %155, label %polly.then177, label %polly.merge176

polly.merge176:                                   ; preds = %polly.then177, %polly.loop_exit190, %polly.start173
  %156 = zext i32 %nl to i64
  %157 = sext i32 %nl to i64
  %158 = icmp sge i64 %157, 1
  %159 = and i1 %148, %158
  %160 = and i1 %159, %154
  %161 = icmp sge i64 %156, 1
  %162 = and i1 %160, %161
  br i1 %162, label %polly.then127, label %polly.merge126

polly.then177:                                    ; preds = %polly.start173
  %polly.loop_guard182 = icmp sle i64 0, %7
  br i1 %polly.loop_guard182, label %polly.loop_header179, label %polly.merge176

polly.loop_header179:                             ; preds = %polly.then177, %polly.loop_exit190
  %polly.indvar183 = phi i64 [ %polly.indvar_next184, %polly.loop_exit190 ], [ 0, %polly.then177 ]
  %163 = mul i64 -3, %6
  %164 = add i64 %163, %146
  %165 = add i64 %164, 5
  %166 = sub i64 %165, 32
  %167 = add i64 %166, 1
  %168 = icmp slt i64 %165, 0
  %169 = select i1 %168, i64 %167, i64 %165
  %170 = sdiv i64 %169, 32
  %171 = mul i64 -32, %170
  %172 = mul i64 -32, %6
  %173 = add i64 %171, %172
  %174 = mul i64 -32, %polly.indvar183
  %175 = mul i64 -3, %polly.indvar183
  %176 = add i64 %175, %146
  %177 = add i64 %176, 5
  %178 = sub i64 %177, 32
  %179 = add i64 %178, 1
  %180 = icmp slt i64 %177, 0
  %181 = select i1 %180, i64 %179, i64 %177
  %182 = sdiv i64 %181, 32
  %183 = mul i64 -32, %182
  %184 = add i64 %174, %183
  %185 = add i64 %184, -640
  %186 = icmp sgt i64 %173, %185
  %187 = select i1 %186, i64 %173, i64 %185
  %188 = mul i64 -20, %polly.indvar183
  %polly.loop_guard191 = icmp sle i64 %187, %188
  br i1 %polly.loop_guard191, label %polly.loop_header188, label %polly.loop_exit190

polly.loop_exit190:                               ; preds = %polly.loop_exit199, %polly.loop_header179
  %polly.indvar_next184 = add nsw i64 %polly.indvar183, 32
  %polly.adjust_ub185 = sub i64 %7, 32
  %polly.loop_cond186 = icmp sle i64 %polly.indvar183, %polly.adjust_ub185
  br i1 %polly.loop_cond186, label %polly.loop_header179, label %polly.merge176

polly.loop_header188:                             ; preds = %polly.loop_header179, %polly.loop_exit199
  %polly.indvar192 = phi i64 [ %polly.indvar_next193, %polly.loop_exit199 ], [ %187, %polly.loop_header179 ]
  %189 = mul i64 -1, %polly.indvar192
  %190 = mul i64 -1, %146
  %191 = add i64 %189, %190
  %192 = add i64 %191, -30
  %193 = add i64 %192, 20
  %194 = sub i64 %193, 1
  %195 = icmp slt i64 %192, 0
  %196 = select i1 %195, i64 %192, i64 %194
  %197 = sdiv i64 %196, 20
  %198 = icmp sgt i64 %197, %polly.indvar183
  %199 = select i1 %198, i64 %197, i64 %polly.indvar183
  %200 = sub i64 %189, 20
  %201 = add i64 %200, 1
  %202 = icmp slt i64 %189, 0
  %203 = select i1 %202, i64 %201, i64 %189
  %204 = sdiv i64 %203, 20
  %205 = add i64 %polly.indvar183, 31
  %206 = icmp slt i64 %204, %205
  %207 = select i1 %206, i64 %204, i64 %205
  %208 = icmp slt i64 %207, %7
  %209 = select i1 %208, i64 %207, i64 %7
  %polly.loop_guard200 = icmp sle i64 %199, %209
  br i1 %polly.loop_guard200, label %polly.loop_header197, label %polly.loop_exit199

polly.loop_exit199:                               ; preds = %polly.loop_exit208, %polly.loop_header188
  %polly.indvar_next193 = add nsw i64 %polly.indvar192, 32
  %polly.adjust_ub194 = sub i64 %188, 32
  %polly.loop_cond195 = icmp sle i64 %polly.indvar192, %polly.adjust_ub194
  br i1 %polly.loop_cond195, label %polly.loop_header188, label %polly.loop_exit190

polly.loop_header197:                             ; preds = %polly.loop_header188, %polly.loop_exit208
  %polly.indvar201 = phi i64 [ %polly.indvar_next202, %polly.loop_exit208 ], [ %199, %polly.loop_header188 ]
  %210 = mul i64 -20, %polly.indvar201
  %211 = add i64 %210, %190
  %212 = add i64 %211, 1
  %213 = icmp sgt i64 %polly.indvar192, %212
  %214 = select i1 %213, i64 %polly.indvar192, i64 %212
  %215 = add i64 %polly.indvar192, 31
  %216 = icmp slt i64 %210, %215
  %217 = select i1 %216, i64 %210, i64 %215
  %polly.loop_guard209 = icmp sle i64 %214, %217
  br i1 %polly.loop_guard209, label %polly.loop_header206, label %polly.loop_exit208

polly.loop_exit208:                               ; preds = %polly.loop_header206, %polly.loop_header197
  %polly.indvar_next202 = add nsw i64 %polly.indvar201, 1
  %polly.adjust_ub203 = sub i64 %209, 1
  %polly.loop_cond204 = icmp sle i64 %polly.indvar201, %polly.adjust_ub203
  br i1 %polly.loop_cond204, label %polly.loop_header197, label %polly.loop_exit199

polly.loop_header206:                             ; preds = %polly.loop_header197, %polly.loop_header206
  %polly.indvar210 = phi i64 [ %polly.indvar_next211, %polly.loop_header206 ], [ %214, %polly.loop_header197 ]
  %218 = mul i64 -1, %polly.indvar210
  %219 = add i64 %210, %218
  %p_.moved.to.68 = sitofp i32 %nj to double
  %p_scevgep43 = getelementptr [900 x double]* %B, i64 %polly.indvar201, i64 %219
  %p_215 = mul i64 %polly.indvar201, %219
  %p_216 = add i64 %polly.indvar201, %p_215
  %p_217 = trunc i64 %p_216 to i32
  %p_218 = srem i32 %p_217, %nj
  %p_219 = sitofp i32 %p_218 to double
  %p_220 = fdiv double %p_219, %p_.moved.to.68
  store double %p_220, double* %p_scevgep43
  %p_indvar.next39 = add i64 %219, 1
  %polly.indvar_next211 = add nsw i64 %polly.indvar210, 1
  %polly.adjust_ub212 = sub i64 %217, 1
  %polly.loop_cond213 = icmp sle i64 %polly.indvar210, %polly.adjust_ub212
  br i1 %polly.loop_cond213, label %polly.loop_header206, label %polly.loop_exit208

polly.start222:                                   ; preds = %.split
  %220 = sext i32 %ni to i64
  %221 = icmp sge i64 %220, 1
  %222 = sext i32 %nk to i64
  %223 = icmp sge i64 %222, 1
  %224 = and i1 %221, %223
  %225 = icmp sge i64 %2, 1
  %226 = and i1 %224, %225
  %227 = icmp sge i64 %6, 1
  %228 = and i1 %226, %227
  br i1 %228, label %polly.then226, label %polly.stmt..split.split

polly.stmt..split.split:                          ; preds = %polly.then226, %polly.loop_exit239, %polly.start222
  store double 1.500000e+00, double* %alpha
  store double 1.200000e+00, double* %beta
  br label %polly.start173

polly.then226:                                    ; preds = %polly.start222
  %polly.loop_guard231 = icmp sle i64 0, %3
  br i1 %polly.loop_guard231, label %polly.loop_header228, label %polly.stmt..split.split

polly.loop_header228:                             ; preds = %polly.then226, %polly.loop_exit239
  %polly.indvar232 = phi i64 [ %polly.indvar_next233, %polly.loop_exit239 ], [ 0, %polly.then226 ]
  %229 = mul i64 -3, %2
  %230 = add i64 %229, %6
  %231 = add i64 %230, 5
  %232 = sub i64 %231, 32
  %233 = add i64 %232, 1
  %234 = icmp slt i64 %231, 0
  %235 = select i1 %234, i64 %233, i64 %231
  %236 = sdiv i64 %235, 32
  %237 = mul i64 -32, %236
  %238 = mul i64 -32, %2
  %239 = add i64 %237, %238
  %240 = mul i64 -32, %polly.indvar232
  %241 = mul i64 -3, %polly.indvar232
  %242 = add i64 %241, %6
  %243 = add i64 %242, 5
  %244 = sub i64 %243, 32
  %245 = add i64 %244, 1
  %246 = icmp slt i64 %243, 0
  %247 = select i1 %246, i64 %245, i64 %243
  %248 = sdiv i64 %247, 32
  %249 = mul i64 -32, %248
  %250 = add i64 %240, %249
  %251 = add i64 %250, -640
  %252 = icmp sgt i64 %239, %251
  %253 = select i1 %252, i64 %239, i64 %251
  %254 = mul i64 -20, %polly.indvar232
  %polly.loop_guard240 = icmp sle i64 %253, %254
  br i1 %polly.loop_guard240, label %polly.loop_header237, label %polly.loop_exit239

polly.loop_exit239:                               ; preds = %polly.loop_exit248, %polly.loop_header228
  %polly.indvar_next233 = add nsw i64 %polly.indvar232, 32
  %polly.adjust_ub234 = sub i64 %3, 32
  %polly.loop_cond235 = icmp sle i64 %polly.indvar232, %polly.adjust_ub234
  br i1 %polly.loop_cond235, label %polly.loop_header228, label %polly.stmt..split.split

polly.loop_header237:                             ; preds = %polly.loop_header228, %polly.loop_exit248
  %polly.indvar241 = phi i64 [ %polly.indvar_next242, %polly.loop_exit248 ], [ %253, %polly.loop_header228 ]
  %255 = mul i64 -1, %polly.indvar241
  %256 = mul i64 -1, %6
  %257 = add i64 %255, %256
  %258 = add i64 %257, -30
  %259 = add i64 %258, 20
  %260 = sub i64 %259, 1
  %261 = icmp slt i64 %258, 0
  %262 = select i1 %261, i64 %258, i64 %260
  %263 = sdiv i64 %262, 20
  %264 = icmp sgt i64 %263, %polly.indvar232
  %265 = select i1 %264, i64 %263, i64 %polly.indvar232
  %266 = sub i64 %255, 20
  %267 = add i64 %266, 1
  %268 = icmp slt i64 %255, 0
  %269 = select i1 %268, i64 %267, i64 %255
  %270 = sdiv i64 %269, 20
  %271 = add i64 %polly.indvar232, 31
  %272 = icmp slt i64 %270, %271
  %273 = select i1 %272, i64 %270, i64 %271
  %274 = icmp slt i64 %273, %3
  %275 = select i1 %274, i64 %273, i64 %3
  %polly.loop_guard249 = icmp sle i64 %265, %275
  br i1 %polly.loop_guard249, label %polly.loop_header246, label %polly.loop_exit248

polly.loop_exit248:                               ; preds = %polly.loop_exit257, %polly.loop_header237
  %polly.indvar_next242 = add nsw i64 %polly.indvar241, 32
  %polly.adjust_ub243 = sub i64 %254, 32
  %polly.loop_cond244 = icmp sle i64 %polly.indvar241, %polly.adjust_ub243
  br i1 %polly.loop_cond244, label %polly.loop_header237, label %polly.loop_exit239

polly.loop_header246:                             ; preds = %polly.loop_header237, %polly.loop_exit257
  %polly.indvar250 = phi i64 [ %polly.indvar_next251, %polly.loop_exit257 ], [ %265, %polly.loop_header237 ]
  %276 = mul i64 -20, %polly.indvar250
  %277 = add i64 %276, %256
  %278 = add i64 %277, 1
  %279 = icmp sgt i64 %polly.indvar241, %278
  %280 = select i1 %279, i64 %polly.indvar241, i64 %278
  %281 = add i64 %polly.indvar241, 31
  %282 = icmp slt i64 %276, %281
  %283 = select i1 %282, i64 %276, i64 %281
  %polly.loop_guard258 = icmp sle i64 %280, %283
  br i1 %polly.loop_guard258, label %polly.loop_header255, label %polly.loop_exit257

polly.loop_exit257:                               ; preds = %polly.loop_header255, %polly.loop_header246
  %polly.indvar_next251 = add nsw i64 %polly.indvar250, 1
  %polly.adjust_ub252 = sub i64 %275, 1
  %polly.loop_cond253 = icmp sle i64 %polly.indvar250, %polly.adjust_ub252
  br i1 %polly.loop_cond253, label %polly.loop_header246, label %polly.loop_exit248

polly.loop_header255:                             ; preds = %polly.loop_header246, %polly.loop_header255
  %polly.indvar259 = phi i64 [ %polly.indvar_next260, %polly.loop_header255 ], [ %280, %polly.loop_header246 ]
  %284 = mul i64 -1, %polly.indvar259
  %285 = add i64 %276, %284
  %p_.moved.to.83 = sitofp i32 %ni to double
  %p_scevgep51 = getelementptr [1100 x double]* %A, i64 %polly.indvar250, i64 %285
  %p_264 = mul i64 %polly.indvar250, %285
  %p_265 = trunc i64 %p_264 to i32
  %p_266 = srem i32 %p_265, %ni
  %p_267 = sitofp i32 %p_266 to double
  %p_268 = fdiv double %p_267, %p_.moved.to.83
  store double %p_268, double* %p_scevgep51
  %p_indvar.next47 = add i64 %285, 1
  %polly.indvar_next260 = add nsw i64 %polly.indvar259, 1
  %polly.adjust_ub261 = sub i64 %283, 1
  %polly.loop_cond262 = icmp sle i64 %polly.indvar259, %polly.adjust_ub261
  br i1 %polly.loop_cond262, label %polly.loop_header255, label %polly.loop_exit257

polly.then275:                                    ; preds = %.preheader6.lr.ph.clone
  %polly.loop_guard280 = icmp sle i64 0, %3
  br i1 %polly.loop_guard280, label %polly.loop_header277, label %polly.start173

polly.loop_header277:                             ; preds = %polly.then275, %polly.loop_exit288
  %polly.indvar281 = phi i64 [ %polly.indvar_next282, %polly.loop_exit288 ], [ 0, %polly.then275 ]
  %286 = mul i64 -3, %2
  %287 = add i64 %286, %6
  %288 = add i64 %287, 5
  %289 = sub i64 %288, 32
  %290 = add i64 %289, 1
  %291 = icmp slt i64 %288, 0
  %292 = select i1 %291, i64 %290, i64 %288
  %293 = sdiv i64 %292, 32
  %294 = mul i64 -32, %293
  %295 = mul i64 -32, %2
  %296 = add i64 %294, %295
  %297 = mul i64 -32, %polly.indvar281
  %298 = mul i64 -3, %polly.indvar281
  %299 = add i64 %298, %6
  %300 = add i64 %299, 5
  %301 = sub i64 %300, 32
  %302 = add i64 %301, 1
  %303 = icmp slt i64 %300, 0
  %304 = select i1 %303, i64 %302, i64 %300
  %305 = sdiv i64 %304, 32
  %306 = mul i64 -32, %305
  %307 = add i64 %297, %306
  %308 = add i64 %307, -640
  %309 = icmp sgt i64 %296, %308
  %310 = select i1 %309, i64 %296, i64 %308
  %311 = mul i64 -20, %polly.indvar281
  %polly.loop_guard289 = icmp sle i64 %310, %311
  br i1 %polly.loop_guard289, label %polly.loop_header286, label %polly.loop_exit288

polly.loop_exit288:                               ; preds = %polly.loop_exit297, %polly.loop_header277
  %polly.indvar_next282 = add nsw i64 %polly.indvar281, 32
  %polly.adjust_ub283 = sub i64 %3, 32
  %polly.loop_cond284 = icmp sle i64 %polly.indvar281, %polly.adjust_ub283
  br i1 %polly.loop_cond284, label %polly.loop_header277, label %polly.start173

polly.loop_header286:                             ; preds = %polly.loop_header277, %polly.loop_exit297
  %polly.indvar290 = phi i64 [ %polly.indvar_next291, %polly.loop_exit297 ], [ %310, %polly.loop_header277 ]
  %312 = mul i64 -1, %polly.indvar290
  %313 = mul i64 -1, %6
  %314 = add i64 %312, %313
  %315 = add i64 %314, -30
  %316 = add i64 %315, 20
  %317 = sub i64 %316, 1
  %318 = icmp slt i64 %315, 0
  %319 = select i1 %318, i64 %315, i64 %317
  %320 = sdiv i64 %319, 20
  %321 = icmp sgt i64 %320, %polly.indvar281
  %322 = select i1 %321, i64 %320, i64 %polly.indvar281
  %323 = sub i64 %312, 20
  %324 = add i64 %323, 1
  %325 = icmp slt i64 %312, 0
  %326 = select i1 %325, i64 %324, i64 %312
  %327 = sdiv i64 %326, 20
  %328 = add i64 %polly.indvar281, 31
  %329 = icmp slt i64 %327, %328
  %330 = select i1 %329, i64 %327, i64 %328
  %331 = icmp slt i64 %330, %3
  %332 = select i1 %331, i64 %330, i64 %3
  %polly.loop_guard298 = icmp sle i64 %322, %332
  br i1 %polly.loop_guard298, label %polly.loop_header295, label %polly.loop_exit297

polly.loop_exit297:                               ; preds = %polly.loop_exit306, %polly.loop_header286
  %polly.indvar_next291 = add nsw i64 %polly.indvar290, 32
  %polly.adjust_ub292 = sub i64 %311, 32
  %polly.loop_cond293 = icmp sle i64 %polly.indvar290, %polly.adjust_ub292
  br i1 %polly.loop_cond293, label %polly.loop_header286, label %polly.loop_exit288

polly.loop_header295:                             ; preds = %polly.loop_header286, %polly.loop_exit306
  %polly.indvar299 = phi i64 [ %polly.indvar_next300, %polly.loop_exit306 ], [ %322, %polly.loop_header286 ]
  %333 = mul i64 -20, %polly.indvar299
  %334 = add i64 %333, %313
  %335 = add i64 %334, 1
  %336 = icmp sgt i64 %polly.indvar290, %335
  %337 = select i1 %336, i64 %polly.indvar290, i64 %335
  %338 = add i64 %polly.indvar290, 31
  %339 = icmp slt i64 %333, %338
  %340 = select i1 %339, i64 %333, i64 %338
  %polly.loop_guard307 = icmp sle i64 %337, %340
  br i1 %polly.loop_guard307, label %polly.loop_header304, label %polly.loop_exit306

polly.loop_exit306:                               ; preds = %polly.loop_header304, %polly.loop_header295
  %polly.indvar_next300 = add nsw i64 %polly.indvar299, 1
  %polly.adjust_ub301 = sub i64 %332, 1
  %polly.loop_cond302 = icmp sle i64 %polly.indvar299, %polly.adjust_ub301
  br i1 %polly.loop_cond302, label %polly.loop_header295, label %polly.loop_exit297

polly.loop_header304:                             ; preds = %polly.loop_header295, %polly.loop_header304
  %polly.indvar308 = phi i64 [ %polly.indvar_next309, %polly.loop_header304 ], [ %337, %polly.loop_header295 ]
  %341 = mul i64 -1, %polly.indvar308
  %342 = add i64 %333, %341
  %p_scevgep51.clone = getelementptr [1100 x double]* %A, i64 %polly.indvar299, i64 %342
  %p_313 = mul i64 %polly.indvar299, %342
  %p_314 = trunc i64 %p_313 to i32
  %p_315 = srem i32 %p_314, %ni
  %p_316 = sitofp i32 %p_315 to double
  %p_317 = fdiv double %p_316, %18
  store double %p_317, double* %p_scevgep51.clone
  %p_indvar.next47.clone = add i64 %342, 1
  %polly.indvar_next309 = add nsw i64 %polly.indvar308, 1
  %polly.adjust_ub310 = sub i64 %340, 1
  %polly.loop_cond311 = icmp sle i64 %polly.indvar308, %polly.adjust_ub310
  br i1 %polly.loop_cond311, label %polly.loop_header304, label %polly.loop_exit306
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_2mm(i32 %ni, i32 %nj, i32 %nk, i32 %nl, double %alpha, double %beta, [900 x double]* %tmp, [1100 x double]* %A, [900 x double]* %B, [1200 x double]* %C, [1200 x double]* %D) #0 {
.split:
  %tmp45 = bitcast [900 x double]* %tmp to i8*
  %C52 = bitcast [1200 x double]* %C to i8*
  %D55 = bitcast [1200 x double]* %D to i8*
  %D54 = ptrtoint [1200 x double]* %D to i64
  %C51 = ptrtoint [1200 x double]* %C to i64
  %tmp43 = ptrtoint [900 x double]* %tmp to i64
  %A46 = bitcast [1100 x double]* %A to i8*
  %B48 = bitcast [900 x double]* %B to i8*
  %B47 = ptrtoint [900 x double]* %B to i64
  %A44 = ptrtoint [1100 x double]* %A to i64
  %0 = zext i32 %ni to i64
  %1 = add i64 %0, -1
  %2 = mul i64 7200, %1
  %3 = add i64 %tmp43, %2
  %4 = zext i32 %nj to i64
  %5 = add i64 %4, -1
  %6 = mul i64 8, %5
  %7 = add i64 %3, %6
  %8 = inttoptr i64 %7 to i8*
  %9 = mul i64 8800, %1
  %10 = add i64 %A44, %9
  %11 = zext i32 %nk to i64
  %12 = add i64 %11, -1
  %13 = mul i64 8, %12
  %14 = add i64 %10, %13
  %15 = inttoptr i64 %14 to i8*
  %16 = icmp ult i8* %8, %A46
  %17 = icmp ult i8* %15, %tmp45
  %pair-no-alias = or i1 %16, %17
  %18 = add i64 %B47, %6
  %19 = mul i64 7200, %12
  %20 = add i64 %18, %19
  %21 = inttoptr i64 %20 to i8*
  %22 = icmp ult i8* %8, %B48
  %23 = icmp ult i8* %21, %tmp45
  %pair-no-alias49 = or i1 %22, %23
  %24 = and i1 %pair-no-alias, %pair-no-alias49
  %25 = icmp ult i8* %15, %B48
  %26 = icmp ult i8* %21, %A46
  %pair-no-alias50 = or i1 %25, %26
  %27 = and i1 %24, %pair-no-alias50
  br i1 %27, label %polly.start200, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  %28 = icmp sgt i32 %ni, 0
  br i1 %28, label %.preheader2.lr.ph.clone, label %.preheader1

.preheader2.lr.ph.clone:                          ; preds = %.split.split.clone
  %29 = icmp sgt i32 %nj, 0
  %30 = icmp sgt i32 %nk, 0
  br label %.preheader2.clone

.preheader2.clone:                                ; preds = %._crit_edge15.clone, %.preheader2.lr.ph.clone
  %indvar31.clone = phi i64 [ 0, %.preheader2.lr.ph.clone ], [ %indvar.next32.clone, %._crit_edge15.clone ]
  br i1 %29, label %.lr.ph14.clone, label %._crit_edge15.clone

.lr.ph14.clone:                                   ; preds = %.preheader2.clone, %._crit_edge12.clone
  %indvar34.clone = phi i64 [ %indvar.next35.clone, %._crit_edge12.clone ], [ 0, %.preheader2.clone ]
  %scevgep39.clone = getelementptr [900 x double]* %tmp, i64 %indvar31.clone, i64 %indvar34.clone
  store double 0.000000e+00, double* %scevgep39.clone, align 8, !tbaa !1
  br i1 %30, label %.lr.ph11.clone, label %._crit_edge12.clone

.lr.ph11.clone:                                   ; preds = %.lr.ph14.clone, %.lr.ph11.clone
  %indvar28.clone = phi i64 [ %indvar.next29.clone, %.lr.ph11.clone ], [ 0, %.lr.ph14.clone ]
  %scevgep33.clone = getelementptr [1100 x double]* %A, i64 %indvar31.clone, i64 %indvar28.clone
  %scevgep36.clone = getelementptr [900 x double]* %B, i64 %indvar28.clone, i64 %indvar34.clone
  %31 = load double* %scevgep33.clone, align 8, !tbaa !1
  %32 = fmul double %31, %alpha
  %33 = load double* %scevgep36.clone, align 8, !tbaa !1
  %34 = fmul double %32, %33
  %35 = load double* %scevgep39.clone, align 8, !tbaa !1
  %36 = fadd double %35, %34
  store double %36, double* %scevgep39.clone, align 8, !tbaa !1
  %indvar.next29.clone = add i64 %indvar28.clone, 1
  %exitcond30.clone = icmp ne i64 %indvar.next29.clone, %11
  br i1 %exitcond30.clone, label %.lr.ph11.clone, label %._crit_edge12.clone

._crit_edge12.clone:                              ; preds = %.lr.ph11.clone, %.lr.ph14.clone
  %indvar.next35.clone = add i64 %indvar34.clone, 1
  %exitcond37.clone = icmp ne i64 %indvar.next35.clone, %4
  br i1 %exitcond37.clone, label %.lr.ph14.clone, label %._crit_edge15.clone

._crit_edge15.clone:                              ; preds = %._crit_edge12.clone, %.preheader2.clone
  %indvar.next32.clone = add i64 %indvar31.clone, 1
  %exitcond40.clone = icmp ne i64 %indvar.next32.clone, %0
  br i1 %exitcond40.clone, label %.preheader2.clone, label %.preheader1

.preheader1:                                      ; preds = %polly.then305, %polly.loop_exit318, %polly.cond303, %polly.start200, %.split.split.clone, %._crit_edge15.clone
  %37 = zext i32 %nl to i64
  %38 = add i64 %37, -1
  %39 = mul i64 8, %38
  %40 = add i64 %C51, %39
  %41 = mul i64 9600, %5
  %42 = add i64 %40, %41
  %43 = inttoptr i64 %42 to i8*
  %44 = icmp ult i8* %8, %C52
  %45 = icmp ult i8* %43, %tmp45
  %pair-no-alias53 = or i1 %44, %45
  %46 = mul i64 9600, %1
  %47 = add i64 %D54, %46
  %48 = add i64 %47, %39
  %49 = inttoptr i64 %48 to i8*
  %50 = icmp ult i8* %8, %D55
  %51 = icmp ult i8* %49, %tmp45
  %pair-no-alias56 = or i1 %50, %51
  %52 = and i1 %pair-no-alias53, %pair-no-alias56
  %53 = icmp ult i8* %43, %D55
  %54 = icmp ult i8* %49, %C52
  %pair-no-alias57 = or i1 %53, %54
  %55 = and i1 %52, %pair-no-alias57
  br i1 %55, label %polly.start, label %.preheader1.split.clone

.preheader1.split.clone:                          ; preds = %.preheader1
  %56 = icmp sgt i32 %ni, 0
  br i1 %56, label %.preheader.lr.ph.clone, label %.region.clone

.preheader.lr.ph.clone:                           ; preds = %.preheader1.split.clone
  %57 = icmp sgt i32 %nl, 0
  %58 = icmp sgt i32 %nj, 0
  br label %.preheader.clone

.preheader.clone:                                 ; preds = %._crit_edge6.clone, %.preheader.lr.ph.clone
  %indvar17.clone = phi i64 [ 0, %.preheader.lr.ph.clone ], [ %indvar.next18.clone, %._crit_edge6.clone ]
  br i1 %57, label %.lr.ph5.clone, label %._crit_edge6.clone

.lr.ph5.clone:                                    ; preds = %.preheader.clone, %._crit_edge.clone
  %indvar19.clone = phi i64 [ %indvar.next20.clone, %._crit_edge.clone ], [ 0, %.preheader.clone ]
  %scevgep24.clone = getelementptr [1200 x double]* %D, i64 %indvar17.clone, i64 %indvar19.clone
  %59 = load double* %scevgep24.clone, align 8, !tbaa !1
  %60 = fmul double %59, %beta
  store double %60, double* %scevgep24.clone, align 8, !tbaa !1
  br i1 %58, label %.lr.ph.clone, label %._crit_edge.clone

.lr.ph.clone:                                     ; preds = %.lr.ph5.clone, %.lr.ph.clone
  %indvar.clone = phi i64 [ %indvar.next.clone, %.lr.ph.clone ], [ 0, %.lr.ph5.clone ]
  %scevgep.clone = getelementptr [900 x double]* %tmp, i64 %indvar17.clone, i64 %indvar.clone
  %scevgep21.clone = getelementptr [1200 x double]* %C, i64 %indvar.clone, i64 %indvar19.clone
  %61 = load double* %scevgep.clone, align 8, !tbaa !1
  %62 = load double* %scevgep21.clone, align 8, !tbaa !1
  %63 = fmul double %61, %62
  %64 = load double* %scevgep24.clone, align 8, !tbaa !1
  %65 = fadd double %64, %63
  store double %65, double* %scevgep24.clone, align 8, !tbaa !1
  %indvar.next.clone = add i64 %indvar.clone, 1
  %exitcond.clone = icmp ne i64 %indvar.next.clone, %4
  br i1 %exitcond.clone, label %.lr.ph.clone, label %._crit_edge.clone

._crit_edge.clone:                                ; preds = %.lr.ph.clone, %.lr.ph5.clone
  %indvar.next20.clone = add i64 %indvar19.clone, 1
  %exitcond22.clone = icmp ne i64 %indvar.next20.clone, %37
  br i1 %exitcond22.clone, label %.lr.ph5.clone, label %._crit_edge6.clone

._crit_edge6.clone:                               ; preds = %._crit_edge.clone, %.preheader.clone
  %indvar.next18.clone = add i64 %indvar17.clone, 1
  %exitcond25.clone = icmp ne i64 %indvar.next18.clone, %0
  br i1 %exitcond25.clone, label %.preheader.clone, label %.region.clone

.region.clone:                                    ; preds = %polly.then157, %polly.loop_exit170, %polly.cond155, %polly.start, %.preheader1.split.clone, %._crit_edge6.clone
  ret void

polly.start:                                      ; preds = %.preheader1
  %66 = sext i32 %ni to i64
  %67 = icmp sge i64 %66, 1
  %68 = sext i32 %nl to i64
  %69 = icmp sge i64 %68, 1
  %70 = and i1 %67, %69
  %71 = icmp sge i64 %0, 1
  %72 = and i1 %70, %71
  %73 = icmp sge i64 %37, 1
  %74 = and i1 %72, %73
  br i1 %74, label %polly.cond66, label %.region.clone

polly.cond66:                                     ; preds = %polly.start
  %75 = sext i32 %nj to i64
  %76 = icmp sge i64 %75, 1
  %77 = icmp sge i64 %4, 1
  %78 = and i1 %76, %77
  br i1 %78, label %polly.then68, label %polly.cond111

polly.cond111:                                    ; preds = %polly.then68, %polly.loop_exit72, %polly.cond66
  %79 = icmp sle i64 %75, 0
  %80 = and i1 %79, %77
  br i1 %80, label %polly.then113, label %polly.cond155

polly.cond155:                                    ; preds = %polly.then113, %polly.loop_exit126, %polly.cond111
  %81 = icmp sle i64 %4, 0
  br i1 %81, label %polly.then157, label %.region.clone

polly.then68:                                     ; preds = %polly.cond66
  %polly.loop_guard = icmp sle i64 0, %1
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond111

polly.loop_header:                                ; preds = %polly.then68, %polly.loop_exit72
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit72 ], [ 0, %polly.then68 ]
  %82 = mul i64 -3, %0
  %83 = add i64 %82, %37
  %84 = add i64 %83, 5
  %85 = sub i64 %84, 32
  %86 = add i64 %85, 1
  %87 = icmp slt i64 %84, 0
  %88 = select i1 %87, i64 %86, i64 %84
  %89 = sdiv i64 %88, 32
  %90 = mul i64 -32, %89
  %91 = mul i64 -32, %0
  %92 = add i64 %90, %91
  %93 = mul i64 -32, %polly.indvar
  %94 = mul i64 -3, %polly.indvar
  %95 = add i64 %94, %37
  %96 = add i64 %95, 5
  %97 = sub i64 %96, 32
  %98 = add i64 %97, 1
  %99 = icmp slt i64 %96, 0
  %100 = select i1 %99, i64 %98, i64 %96
  %101 = sdiv i64 %100, 32
  %102 = mul i64 -32, %101
  %103 = add i64 %93, %102
  %104 = add i64 %103, -640
  %105 = icmp sgt i64 %92, %104
  %106 = select i1 %105, i64 %92, i64 %104
  %107 = mul i64 -20, %polly.indvar
  %polly.loop_guard73 = icmp sle i64 %106, %107
  br i1 %polly.loop_guard73, label %polly.loop_header70, label %polly.loop_exit72

polly.loop_exit72:                                ; preds = %polly.loop_exit81, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %1, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond111

polly.loop_header70:                              ; preds = %polly.loop_header, %polly.loop_exit81
  %polly.indvar74 = phi i64 [ %polly.indvar_next75, %polly.loop_exit81 ], [ %106, %polly.loop_header ]
  %108 = mul i64 -1, %polly.indvar74
  %109 = mul i64 -1, %37
  %110 = add i64 %108, %109
  %111 = add i64 %110, -30
  %112 = add i64 %111, 20
  %113 = sub i64 %112, 1
  %114 = icmp slt i64 %111, 0
  %115 = select i1 %114, i64 %111, i64 %113
  %116 = sdiv i64 %115, 20
  %117 = icmp sgt i64 %116, %polly.indvar
  %118 = select i1 %117, i64 %116, i64 %polly.indvar
  %119 = sub i64 %108, 20
  %120 = add i64 %119, 1
  %121 = icmp slt i64 %108, 0
  %122 = select i1 %121, i64 %120, i64 %108
  %123 = sdiv i64 %122, 20
  %124 = add i64 %polly.indvar, 31
  %125 = icmp slt i64 %123, %124
  %126 = select i1 %125, i64 %123, i64 %124
  %127 = icmp slt i64 %126, %1
  %128 = select i1 %127, i64 %126, i64 %1
  %polly.loop_guard82 = icmp sle i64 %118, %128
  br i1 %polly.loop_guard82, label %polly.loop_header79, label %polly.loop_exit81

polly.loop_exit81:                                ; preds = %polly.loop_exit90, %polly.loop_header70
  %polly.indvar_next75 = add nsw i64 %polly.indvar74, 32
  %polly.adjust_ub76 = sub i64 %107, 32
  %polly.loop_cond77 = icmp sle i64 %polly.indvar74, %polly.adjust_ub76
  br i1 %polly.loop_cond77, label %polly.loop_header70, label %polly.loop_exit72

polly.loop_header79:                              ; preds = %polly.loop_header70, %polly.loop_exit90
  %polly.indvar83 = phi i64 [ %polly.indvar_next84, %polly.loop_exit90 ], [ %118, %polly.loop_header70 ]
  %129 = mul i64 -20, %polly.indvar83
  %130 = add i64 %129, %109
  %131 = add i64 %130, 1
  %132 = icmp sgt i64 %polly.indvar74, %131
  %133 = select i1 %132, i64 %polly.indvar74, i64 %131
  %134 = add i64 %polly.indvar74, 31
  %135 = icmp slt i64 %129, %134
  %136 = select i1 %135, i64 %129, i64 %134
  %polly.loop_guard91 = icmp sle i64 %133, %136
  br i1 %polly.loop_guard91, label %polly.loop_header88, label %polly.loop_exit90

polly.loop_exit90:                                ; preds = %polly.loop_exit99, %polly.loop_header79
  %polly.indvar_next84 = add nsw i64 %polly.indvar83, 1
  %polly.adjust_ub85 = sub i64 %128, 1
  %polly.loop_cond86 = icmp sle i64 %polly.indvar83, %polly.adjust_ub85
  br i1 %polly.loop_cond86, label %polly.loop_header79, label %polly.loop_exit81

polly.loop_header88:                              ; preds = %polly.loop_header79, %polly.loop_exit99
  %polly.indvar92 = phi i64 [ %polly.indvar_next93, %polly.loop_exit99 ], [ %133, %polly.loop_header79 ]
  %137 = mul i64 -1, %polly.indvar92
  %138 = add i64 %129, %137
  %p_scevgep24 = getelementptr [1200 x double]* %D, i64 %polly.indvar83, i64 %138
  %_p_scalar_ = load double* %p_scevgep24
  %p_ = fmul double %_p_scalar_, %beta
  store double %p_, double* %p_scevgep24
  %polly.loop_guard100 = icmp sle i64 0, %5
  br i1 %polly.loop_guard100, label %polly.loop_header97, label %polly.loop_exit99

polly.loop_exit99:                                ; preds = %polly.loop_header97, %polly.loop_header88
  %polly.indvar_next93 = add nsw i64 %polly.indvar92, 1
  %polly.adjust_ub94 = sub i64 %136, 1
  %polly.loop_cond95 = icmp sle i64 %polly.indvar92, %polly.adjust_ub94
  br i1 %polly.loop_cond95, label %polly.loop_header88, label %polly.loop_exit90

polly.loop_header97:                              ; preds = %polly.loop_header88, %polly.loop_header97
  %polly.indvar101 = phi i64 [ %polly.indvar_next102, %polly.loop_header97 ], [ 0, %polly.loop_header88 ]
  %p_scevgep = getelementptr [900 x double]* %tmp, i64 %polly.indvar83, i64 %polly.indvar101
  %p_scevgep21 = getelementptr [1200 x double]* %C, i64 %polly.indvar101, i64 %138
  %_p_scalar_106 = load double* %p_scevgep
  %_p_scalar_107 = load double* %p_scevgep21
  %p_108 = fmul double %_p_scalar_106, %_p_scalar_107
  %_p_scalar_109 = load double* %p_scevgep24
  %p_110 = fadd double %_p_scalar_109, %p_108
  store double %p_110, double* %p_scevgep24
  %p_indvar.next = add i64 %polly.indvar101, 1
  %polly.indvar_next102 = add nsw i64 %polly.indvar101, 1
  %polly.adjust_ub103 = sub i64 %5, 1
  %polly.loop_cond104 = icmp sle i64 %polly.indvar101, %polly.adjust_ub103
  br i1 %polly.loop_cond104, label %polly.loop_header97, label %polly.loop_exit99

polly.then113:                                    ; preds = %polly.cond111
  %polly.loop_guard118 = icmp sle i64 0, %1
  br i1 %polly.loop_guard118, label %polly.loop_header115, label %polly.cond155

polly.loop_header115:                             ; preds = %polly.then113, %polly.loop_exit126
  %polly.indvar119 = phi i64 [ %polly.indvar_next120, %polly.loop_exit126 ], [ 0, %polly.then113 ]
  %139 = mul i64 -3, %0
  %140 = add i64 %139, %37
  %141 = add i64 %140, 5
  %142 = sub i64 %141, 32
  %143 = add i64 %142, 1
  %144 = icmp slt i64 %141, 0
  %145 = select i1 %144, i64 %143, i64 %141
  %146 = sdiv i64 %145, 32
  %147 = mul i64 -32, %146
  %148 = mul i64 -32, %0
  %149 = add i64 %147, %148
  %150 = mul i64 -32, %polly.indvar119
  %151 = mul i64 -3, %polly.indvar119
  %152 = add i64 %151, %37
  %153 = add i64 %152, 5
  %154 = sub i64 %153, 32
  %155 = add i64 %154, 1
  %156 = icmp slt i64 %153, 0
  %157 = select i1 %156, i64 %155, i64 %153
  %158 = sdiv i64 %157, 32
  %159 = mul i64 -32, %158
  %160 = add i64 %150, %159
  %161 = add i64 %160, -640
  %162 = icmp sgt i64 %149, %161
  %163 = select i1 %162, i64 %149, i64 %161
  %164 = mul i64 -20, %polly.indvar119
  %polly.loop_guard127 = icmp sle i64 %163, %164
  br i1 %polly.loop_guard127, label %polly.loop_header124, label %polly.loop_exit126

polly.loop_exit126:                               ; preds = %polly.loop_exit135, %polly.loop_header115
  %polly.indvar_next120 = add nsw i64 %polly.indvar119, 32
  %polly.adjust_ub121 = sub i64 %1, 32
  %polly.loop_cond122 = icmp sle i64 %polly.indvar119, %polly.adjust_ub121
  br i1 %polly.loop_cond122, label %polly.loop_header115, label %polly.cond155

polly.loop_header124:                             ; preds = %polly.loop_header115, %polly.loop_exit135
  %polly.indvar128 = phi i64 [ %polly.indvar_next129, %polly.loop_exit135 ], [ %163, %polly.loop_header115 ]
  %165 = mul i64 -1, %polly.indvar128
  %166 = mul i64 -1, %37
  %167 = add i64 %165, %166
  %168 = add i64 %167, -30
  %169 = add i64 %168, 20
  %170 = sub i64 %169, 1
  %171 = icmp slt i64 %168, 0
  %172 = select i1 %171, i64 %168, i64 %170
  %173 = sdiv i64 %172, 20
  %174 = icmp sgt i64 %173, %polly.indvar119
  %175 = select i1 %174, i64 %173, i64 %polly.indvar119
  %176 = sub i64 %165, 20
  %177 = add i64 %176, 1
  %178 = icmp slt i64 %165, 0
  %179 = select i1 %178, i64 %177, i64 %165
  %180 = sdiv i64 %179, 20
  %181 = add i64 %polly.indvar119, 31
  %182 = icmp slt i64 %180, %181
  %183 = select i1 %182, i64 %180, i64 %181
  %184 = icmp slt i64 %183, %1
  %185 = select i1 %184, i64 %183, i64 %1
  %polly.loop_guard136 = icmp sle i64 %175, %185
  br i1 %polly.loop_guard136, label %polly.loop_header133, label %polly.loop_exit135

polly.loop_exit135:                               ; preds = %polly.loop_exit144, %polly.loop_header124
  %polly.indvar_next129 = add nsw i64 %polly.indvar128, 32
  %polly.adjust_ub130 = sub i64 %164, 32
  %polly.loop_cond131 = icmp sle i64 %polly.indvar128, %polly.adjust_ub130
  br i1 %polly.loop_cond131, label %polly.loop_header124, label %polly.loop_exit126

polly.loop_header133:                             ; preds = %polly.loop_header124, %polly.loop_exit144
  %polly.indvar137 = phi i64 [ %polly.indvar_next138, %polly.loop_exit144 ], [ %175, %polly.loop_header124 ]
  %186 = mul i64 -20, %polly.indvar137
  %187 = add i64 %186, %166
  %188 = add i64 %187, 1
  %189 = icmp sgt i64 %polly.indvar128, %188
  %190 = select i1 %189, i64 %polly.indvar128, i64 %188
  %191 = add i64 %polly.indvar128, 31
  %192 = icmp slt i64 %186, %191
  %193 = select i1 %192, i64 %186, i64 %191
  %polly.loop_guard145 = icmp sle i64 %190, %193
  br i1 %polly.loop_guard145, label %polly.loop_header142, label %polly.loop_exit144

polly.loop_exit144:                               ; preds = %polly.loop_header142, %polly.loop_header133
  %polly.indvar_next138 = add nsw i64 %polly.indvar137, 1
  %polly.adjust_ub139 = sub i64 %185, 1
  %polly.loop_cond140 = icmp sle i64 %polly.indvar137, %polly.adjust_ub139
  br i1 %polly.loop_cond140, label %polly.loop_header133, label %polly.loop_exit135

polly.loop_header142:                             ; preds = %polly.loop_header133, %polly.loop_header142
  %polly.indvar146 = phi i64 [ %polly.indvar_next147, %polly.loop_header142 ], [ %190, %polly.loop_header133 ]
  %194 = mul i64 -1, %polly.indvar146
  %195 = add i64 %186, %194
  %p_scevgep24152 = getelementptr [1200 x double]* %D, i64 %polly.indvar137, i64 %195
  %_p_scalar_153 = load double* %p_scevgep24152
  %p_154 = fmul double %_p_scalar_153, %beta
  store double %p_154, double* %p_scevgep24152
  %polly.indvar_next147 = add nsw i64 %polly.indvar146, 1
  %polly.adjust_ub148 = sub i64 %193, 1
  %polly.loop_cond149 = icmp sle i64 %polly.indvar146, %polly.adjust_ub148
  br i1 %polly.loop_cond149, label %polly.loop_header142, label %polly.loop_exit144

polly.then157:                                    ; preds = %polly.cond155
  %polly.loop_guard162 = icmp sle i64 0, %1
  br i1 %polly.loop_guard162, label %polly.loop_header159, label %.region.clone

polly.loop_header159:                             ; preds = %polly.then157, %polly.loop_exit170
  %polly.indvar163 = phi i64 [ %polly.indvar_next164, %polly.loop_exit170 ], [ 0, %polly.then157 ]
  %196 = mul i64 -3, %0
  %197 = add i64 %196, %37
  %198 = add i64 %197, 5
  %199 = sub i64 %198, 32
  %200 = add i64 %199, 1
  %201 = icmp slt i64 %198, 0
  %202 = select i1 %201, i64 %200, i64 %198
  %203 = sdiv i64 %202, 32
  %204 = mul i64 -32, %203
  %205 = mul i64 -32, %0
  %206 = add i64 %204, %205
  %207 = mul i64 -32, %polly.indvar163
  %208 = mul i64 -3, %polly.indvar163
  %209 = add i64 %208, %37
  %210 = add i64 %209, 5
  %211 = sub i64 %210, 32
  %212 = add i64 %211, 1
  %213 = icmp slt i64 %210, 0
  %214 = select i1 %213, i64 %212, i64 %210
  %215 = sdiv i64 %214, 32
  %216 = mul i64 -32, %215
  %217 = add i64 %207, %216
  %218 = add i64 %217, -640
  %219 = icmp sgt i64 %206, %218
  %220 = select i1 %219, i64 %206, i64 %218
  %221 = mul i64 -20, %polly.indvar163
  %polly.loop_guard171 = icmp sle i64 %220, %221
  br i1 %polly.loop_guard171, label %polly.loop_header168, label %polly.loop_exit170

polly.loop_exit170:                               ; preds = %polly.loop_exit179, %polly.loop_header159
  %polly.indvar_next164 = add nsw i64 %polly.indvar163, 32
  %polly.adjust_ub165 = sub i64 %1, 32
  %polly.loop_cond166 = icmp sle i64 %polly.indvar163, %polly.adjust_ub165
  br i1 %polly.loop_cond166, label %polly.loop_header159, label %.region.clone

polly.loop_header168:                             ; preds = %polly.loop_header159, %polly.loop_exit179
  %polly.indvar172 = phi i64 [ %polly.indvar_next173, %polly.loop_exit179 ], [ %220, %polly.loop_header159 ]
  %222 = mul i64 -1, %polly.indvar172
  %223 = mul i64 -1, %37
  %224 = add i64 %222, %223
  %225 = add i64 %224, -30
  %226 = add i64 %225, 20
  %227 = sub i64 %226, 1
  %228 = icmp slt i64 %225, 0
  %229 = select i1 %228, i64 %225, i64 %227
  %230 = sdiv i64 %229, 20
  %231 = icmp sgt i64 %230, %polly.indvar163
  %232 = select i1 %231, i64 %230, i64 %polly.indvar163
  %233 = sub i64 %222, 20
  %234 = add i64 %233, 1
  %235 = icmp slt i64 %222, 0
  %236 = select i1 %235, i64 %234, i64 %222
  %237 = sdiv i64 %236, 20
  %238 = add i64 %polly.indvar163, 31
  %239 = icmp slt i64 %237, %238
  %240 = select i1 %239, i64 %237, i64 %238
  %241 = icmp slt i64 %240, %1
  %242 = select i1 %241, i64 %240, i64 %1
  %polly.loop_guard180 = icmp sle i64 %232, %242
  br i1 %polly.loop_guard180, label %polly.loop_header177, label %polly.loop_exit179

polly.loop_exit179:                               ; preds = %polly.loop_exit188, %polly.loop_header168
  %polly.indvar_next173 = add nsw i64 %polly.indvar172, 32
  %polly.adjust_ub174 = sub i64 %221, 32
  %polly.loop_cond175 = icmp sle i64 %polly.indvar172, %polly.adjust_ub174
  br i1 %polly.loop_cond175, label %polly.loop_header168, label %polly.loop_exit170

polly.loop_header177:                             ; preds = %polly.loop_header168, %polly.loop_exit188
  %polly.indvar181 = phi i64 [ %polly.indvar_next182, %polly.loop_exit188 ], [ %232, %polly.loop_header168 ]
  %243 = mul i64 -20, %polly.indvar181
  %244 = add i64 %243, %223
  %245 = add i64 %244, 1
  %246 = icmp sgt i64 %polly.indvar172, %245
  %247 = select i1 %246, i64 %polly.indvar172, i64 %245
  %248 = add i64 %polly.indvar172, 31
  %249 = icmp slt i64 %243, %248
  %250 = select i1 %249, i64 %243, i64 %248
  %polly.loop_guard189 = icmp sle i64 %247, %250
  br i1 %polly.loop_guard189, label %polly.loop_header186, label %polly.loop_exit188

polly.loop_exit188:                               ; preds = %polly.loop_header186, %polly.loop_header177
  %polly.indvar_next182 = add nsw i64 %polly.indvar181, 1
  %polly.adjust_ub183 = sub i64 %242, 1
  %polly.loop_cond184 = icmp sle i64 %polly.indvar181, %polly.adjust_ub183
  br i1 %polly.loop_cond184, label %polly.loop_header177, label %polly.loop_exit179

polly.loop_header186:                             ; preds = %polly.loop_header177, %polly.loop_header186
  %polly.indvar190 = phi i64 [ %polly.indvar_next191, %polly.loop_header186 ], [ %247, %polly.loop_header177 ]
  %251 = mul i64 -1, %polly.indvar190
  %252 = add i64 %243, %251
  %p_scevgep24196 = getelementptr [1200 x double]* %D, i64 %polly.indvar181, i64 %252
  %_p_scalar_197 = load double* %p_scevgep24196
  %p_198 = fmul double %_p_scalar_197, %beta
  store double %p_198, double* %p_scevgep24196
  %polly.indvar_next191 = add nsw i64 %polly.indvar190, 1
  %polly.adjust_ub192 = sub i64 %250, 1
  %polly.loop_cond193 = icmp sle i64 %polly.indvar190, %polly.adjust_ub192
  br i1 %polly.loop_cond193, label %polly.loop_header186, label %polly.loop_exit188

polly.start200:                                   ; preds = %.split
  %253 = sext i32 %ni to i64
  %254 = icmp sge i64 %253, 1
  %255 = sext i32 %nj to i64
  %256 = icmp sge i64 %255, 1
  %257 = and i1 %254, %256
  %258 = icmp sge i64 %0, 1
  %259 = and i1 %257, %258
  %260 = icmp sge i64 %4, 1
  %261 = and i1 %259, %260
  br i1 %261, label %polly.cond205, label %.preheader1

polly.cond205:                                    ; preds = %polly.start200
  %262 = sext i32 %nk to i64
  %263 = icmp sge i64 %262, 1
  %264 = icmp sge i64 %11, 1
  %265 = and i1 %263, %264
  br i1 %265, label %polly.then207, label %polly.cond261

polly.cond261:                                    ; preds = %polly.then207, %polly.loop_exit220, %polly.cond205
  %266 = icmp sle i64 %262, 0
  %267 = and i1 %266, %264
  br i1 %267, label %polly.then263, label %polly.cond303

polly.cond303:                                    ; preds = %polly.then263, %polly.loop_exit276, %polly.cond261
  %268 = icmp sle i64 %11, 0
  br i1 %268, label %polly.then305, label %.preheader1

polly.then207:                                    ; preds = %polly.cond205
  %polly.loop_guard212 = icmp sle i64 0, %1
  br i1 %polly.loop_guard212, label %polly.loop_header209, label %polly.cond261

polly.loop_header209:                             ; preds = %polly.then207, %polly.loop_exit220
  %polly.indvar213 = phi i64 [ %polly.indvar_next214, %polly.loop_exit220 ], [ 0, %polly.then207 ]
  %269 = mul i64 -3, %0
  %270 = add i64 %269, %4
  %271 = add i64 %270, 5
  %272 = sub i64 %271, 32
  %273 = add i64 %272, 1
  %274 = icmp slt i64 %271, 0
  %275 = select i1 %274, i64 %273, i64 %271
  %276 = sdiv i64 %275, 32
  %277 = mul i64 -32, %276
  %278 = mul i64 -32, %0
  %279 = add i64 %277, %278
  %280 = mul i64 -32, %polly.indvar213
  %281 = mul i64 -3, %polly.indvar213
  %282 = add i64 %281, %4
  %283 = add i64 %282, 5
  %284 = sub i64 %283, 32
  %285 = add i64 %284, 1
  %286 = icmp slt i64 %283, 0
  %287 = select i1 %286, i64 %285, i64 %283
  %288 = sdiv i64 %287, 32
  %289 = mul i64 -32, %288
  %290 = add i64 %280, %289
  %291 = add i64 %290, -640
  %292 = icmp sgt i64 %279, %291
  %293 = select i1 %292, i64 %279, i64 %291
  %294 = mul i64 -20, %polly.indvar213
  %polly.loop_guard221 = icmp sle i64 %293, %294
  br i1 %polly.loop_guard221, label %polly.loop_header218, label %polly.loop_exit220

polly.loop_exit220:                               ; preds = %polly.loop_exit229, %polly.loop_header209
  %polly.indvar_next214 = add nsw i64 %polly.indvar213, 32
  %polly.adjust_ub215 = sub i64 %1, 32
  %polly.loop_cond216 = icmp sle i64 %polly.indvar213, %polly.adjust_ub215
  br i1 %polly.loop_cond216, label %polly.loop_header209, label %polly.cond261

polly.loop_header218:                             ; preds = %polly.loop_header209, %polly.loop_exit229
  %polly.indvar222 = phi i64 [ %polly.indvar_next223, %polly.loop_exit229 ], [ %293, %polly.loop_header209 ]
  %295 = mul i64 -1, %polly.indvar222
  %296 = mul i64 -1, %4
  %297 = add i64 %295, %296
  %298 = add i64 %297, -30
  %299 = add i64 %298, 20
  %300 = sub i64 %299, 1
  %301 = icmp slt i64 %298, 0
  %302 = select i1 %301, i64 %298, i64 %300
  %303 = sdiv i64 %302, 20
  %304 = icmp sgt i64 %303, %polly.indvar213
  %305 = select i1 %304, i64 %303, i64 %polly.indvar213
  %306 = sub i64 %295, 20
  %307 = add i64 %306, 1
  %308 = icmp slt i64 %295, 0
  %309 = select i1 %308, i64 %307, i64 %295
  %310 = sdiv i64 %309, 20
  %311 = add i64 %polly.indvar213, 31
  %312 = icmp slt i64 %310, %311
  %313 = select i1 %312, i64 %310, i64 %311
  %314 = icmp slt i64 %313, %1
  %315 = select i1 %314, i64 %313, i64 %1
  %polly.loop_guard230 = icmp sle i64 %305, %315
  br i1 %polly.loop_guard230, label %polly.loop_header227, label %polly.loop_exit229

polly.loop_exit229:                               ; preds = %polly.loop_exit238, %polly.loop_header218
  %polly.indvar_next223 = add nsw i64 %polly.indvar222, 32
  %polly.adjust_ub224 = sub i64 %294, 32
  %polly.loop_cond225 = icmp sle i64 %polly.indvar222, %polly.adjust_ub224
  br i1 %polly.loop_cond225, label %polly.loop_header218, label %polly.loop_exit220

polly.loop_header227:                             ; preds = %polly.loop_header218, %polly.loop_exit238
  %polly.indvar231 = phi i64 [ %polly.indvar_next232, %polly.loop_exit238 ], [ %305, %polly.loop_header218 ]
  %316 = mul i64 -20, %polly.indvar231
  %317 = add i64 %316, %296
  %318 = add i64 %317, 1
  %319 = icmp sgt i64 %polly.indvar222, %318
  %320 = select i1 %319, i64 %polly.indvar222, i64 %318
  %321 = add i64 %polly.indvar222, 31
  %322 = icmp slt i64 %316, %321
  %323 = select i1 %322, i64 %316, i64 %321
  %polly.loop_guard239 = icmp sle i64 %320, %323
  br i1 %polly.loop_guard239, label %polly.loop_header236, label %polly.loop_exit238

polly.loop_exit238:                               ; preds = %polly.loop_exit248, %polly.loop_header227
  %polly.indvar_next232 = add nsw i64 %polly.indvar231, 1
  %polly.adjust_ub233 = sub i64 %315, 1
  %polly.loop_cond234 = icmp sle i64 %polly.indvar231, %polly.adjust_ub233
  br i1 %polly.loop_cond234, label %polly.loop_header227, label %polly.loop_exit229

polly.loop_header236:                             ; preds = %polly.loop_header227, %polly.loop_exit248
  %polly.indvar240 = phi i64 [ %polly.indvar_next241, %polly.loop_exit248 ], [ %320, %polly.loop_header227 ]
  %324 = mul i64 -1, %polly.indvar240
  %325 = add i64 %316, %324
  %p_scevgep39 = getelementptr [900 x double]* %tmp, i64 %polly.indvar231, i64 %325
  store double 0.000000e+00, double* %p_scevgep39
  %polly.loop_guard249 = icmp sle i64 0, %12
  br i1 %polly.loop_guard249, label %polly.loop_header246, label %polly.loop_exit248

polly.loop_exit248:                               ; preds = %polly.loop_header246, %polly.loop_header236
  %polly.indvar_next241 = add nsw i64 %polly.indvar240, 1
  %polly.adjust_ub242 = sub i64 %323, 1
  %polly.loop_cond243 = icmp sle i64 %polly.indvar240, %polly.adjust_ub242
  br i1 %polly.loop_cond243, label %polly.loop_header236, label %polly.loop_exit238

polly.loop_header246:                             ; preds = %polly.loop_header236, %polly.loop_header246
  %polly.indvar250 = phi i64 [ %polly.indvar_next251, %polly.loop_header246 ], [ 0, %polly.loop_header236 ]
  %p_scevgep33 = getelementptr [1100 x double]* %A, i64 %polly.indvar231, i64 %polly.indvar250
  %p_scevgep36 = getelementptr [900 x double]* %B, i64 %polly.indvar250, i64 %325
  %_p_scalar_255 = load double* %p_scevgep33
  %p_256 = fmul double %_p_scalar_255, %alpha
  %_p_scalar_257 = load double* %p_scevgep36
  %p_258 = fmul double %p_256, %_p_scalar_257
  %_p_scalar_259 = load double* %p_scevgep39
  %p_260 = fadd double %_p_scalar_259, %p_258
  store double %p_260, double* %p_scevgep39
  %p_indvar.next29 = add i64 %polly.indvar250, 1
  %polly.indvar_next251 = add nsw i64 %polly.indvar250, 1
  %polly.adjust_ub252 = sub i64 %12, 1
  %polly.loop_cond253 = icmp sle i64 %polly.indvar250, %polly.adjust_ub252
  br i1 %polly.loop_cond253, label %polly.loop_header246, label %polly.loop_exit248

polly.then263:                                    ; preds = %polly.cond261
  %polly.loop_guard268 = icmp sle i64 0, %1
  br i1 %polly.loop_guard268, label %polly.loop_header265, label %polly.cond303

polly.loop_header265:                             ; preds = %polly.then263, %polly.loop_exit276
  %polly.indvar269 = phi i64 [ %polly.indvar_next270, %polly.loop_exit276 ], [ 0, %polly.then263 ]
  %326 = mul i64 -3, %0
  %327 = add i64 %326, %4
  %328 = add i64 %327, 5
  %329 = sub i64 %328, 32
  %330 = add i64 %329, 1
  %331 = icmp slt i64 %328, 0
  %332 = select i1 %331, i64 %330, i64 %328
  %333 = sdiv i64 %332, 32
  %334 = mul i64 -32, %333
  %335 = mul i64 -32, %0
  %336 = add i64 %334, %335
  %337 = mul i64 -32, %polly.indvar269
  %338 = mul i64 -3, %polly.indvar269
  %339 = add i64 %338, %4
  %340 = add i64 %339, 5
  %341 = sub i64 %340, 32
  %342 = add i64 %341, 1
  %343 = icmp slt i64 %340, 0
  %344 = select i1 %343, i64 %342, i64 %340
  %345 = sdiv i64 %344, 32
  %346 = mul i64 -32, %345
  %347 = add i64 %337, %346
  %348 = add i64 %347, -640
  %349 = icmp sgt i64 %336, %348
  %350 = select i1 %349, i64 %336, i64 %348
  %351 = mul i64 -20, %polly.indvar269
  %polly.loop_guard277 = icmp sle i64 %350, %351
  br i1 %polly.loop_guard277, label %polly.loop_header274, label %polly.loop_exit276

polly.loop_exit276:                               ; preds = %polly.loop_exit285, %polly.loop_header265
  %polly.indvar_next270 = add nsw i64 %polly.indvar269, 32
  %polly.adjust_ub271 = sub i64 %1, 32
  %polly.loop_cond272 = icmp sle i64 %polly.indvar269, %polly.adjust_ub271
  br i1 %polly.loop_cond272, label %polly.loop_header265, label %polly.cond303

polly.loop_header274:                             ; preds = %polly.loop_header265, %polly.loop_exit285
  %polly.indvar278 = phi i64 [ %polly.indvar_next279, %polly.loop_exit285 ], [ %350, %polly.loop_header265 ]
  %352 = mul i64 -1, %polly.indvar278
  %353 = mul i64 -1, %4
  %354 = add i64 %352, %353
  %355 = add i64 %354, -30
  %356 = add i64 %355, 20
  %357 = sub i64 %356, 1
  %358 = icmp slt i64 %355, 0
  %359 = select i1 %358, i64 %355, i64 %357
  %360 = sdiv i64 %359, 20
  %361 = icmp sgt i64 %360, %polly.indvar269
  %362 = select i1 %361, i64 %360, i64 %polly.indvar269
  %363 = sub i64 %352, 20
  %364 = add i64 %363, 1
  %365 = icmp slt i64 %352, 0
  %366 = select i1 %365, i64 %364, i64 %352
  %367 = sdiv i64 %366, 20
  %368 = add i64 %polly.indvar269, 31
  %369 = icmp slt i64 %367, %368
  %370 = select i1 %369, i64 %367, i64 %368
  %371 = icmp slt i64 %370, %1
  %372 = select i1 %371, i64 %370, i64 %1
  %polly.loop_guard286 = icmp sle i64 %362, %372
  br i1 %polly.loop_guard286, label %polly.loop_header283, label %polly.loop_exit285

polly.loop_exit285:                               ; preds = %polly.loop_exit294, %polly.loop_header274
  %polly.indvar_next279 = add nsw i64 %polly.indvar278, 32
  %polly.adjust_ub280 = sub i64 %351, 32
  %polly.loop_cond281 = icmp sle i64 %polly.indvar278, %polly.adjust_ub280
  br i1 %polly.loop_cond281, label %polly.loop_header274, label %polly.loop_exit276

polly.loop_header283:                             ; preds = %polly.loop_header274, %polly.loop_exit294
  %polly.indvar287 = phi i64 [ %polly.indvar_next288, %polly.loop_exit294 ], [ %362, %polly.loop_header274 ]
  %373 = mul i64 -20, %polly.indvar287
  %374 = add i64 %373, %353
  %375 = add i64 %374, 1
  %376 = icmp sgt i64 %polly.indvar278, %375
  %377 = select i1 %376, i64 %polly.indvar278, i64 %375
  %378 = add i64 %polly.indvar278, 31
  %379 = icmp slt i64 %373, %378
  %380 = select i1 %379, i64 %373, i64 %378
  %polly.loop_guard295 = icmp sle i64 %377, %380
  br i1 %polly.loop_guard295, label %polly.loop_header292, label %polly.loop_exit294

polly.loop_exit294:                               ; preds = %polly.loop_header292, %polly.loop_header283
  %polly.indvar_next288 = add nsw i64 %polly.indvar287, 1
  %polly.adjust_ub289 = sub i64 %372, 1
  %polly.loop_cond290 = icmp sle i64 %polly.indvar287, %polly.adjust_ub289
  br i1 %polly.loop_cond290, label %polly.loop_header283, label %polly.loop_exit285

polly.loop_header292:                             ; preds = %polly.loop_header283, %polly.loop_header292
  %polly.indvar296 = phi i64 [ %polly.indvar_next297, %polly.loop_header292 ], [ %377, %polly.loop_header283 ]
  %381 = mul i64 -1, %polly.indvar296
  %382 = add i64 %373, %381
  %p_scevgep39302 = getelementptr [900 x double]* %tmp, i64 %polly.indvar287, i64 %382
  store double 0.000000e+00, double* %p_scevgep39302
  %polly.indvar_next297 = add nsw i64 %polly.indvar296, 1
  %polly.adjust_ub298 = sub i64 %380, 1
  %polly.loop_cond299 = icmp sle i64 %polly.indvar296, %polly.adjust_ub298
  br i1 %polly.loop_cond299, label %polly.loop_header292, label %polly.loop_exit294

polly.then305:                                    ; preds = %polly.cond303
  %polly.loop_guard310 = icmp sle i64 0, %1
  br i1 %polly.loop_guard310, label %polly.loop_header307, label %.preheader1

polly.loop_header307:                             ; preds = %polly.then305, %polly.loop_exit318
  %polly.indvar311 = phi i64 [ %polly.indvar_next312, %polly.loop_exit318 ], [ 0, %polly.then305 ]
  %383 = mul i64 -3, %0
  %384 = add i64 %383, %4
  %385 = add i64 %384, 5
  %386 = sub i64 %385, 32
  %387 = add i64 %386, 1
  %388 = icmp slt i64 %385, 0
  %389 = select i1 %388, i64 %387, i64 %385
  %390 = sdiv i64 %389, 32
  %391 = mul i64 -32, %390
  %392 = mul i64 -32, %0
  %393 = add i64 %391, %392
  %394 = mul i64 -32, %polly.indvar311
  %395 = mul i64 -3, %polly.indvar311
  %396 = add i64 %395, %4
  %397 = add i64 %396, 5
  %398 = sub i64 %397, 32
  %399 = add i64 %398, 1
  %400 = icmp slt i64 %397, 0
  %401 = select i1 %400, i64 %399, i64 %397
  %402 = sdiv i64 %401, 32
  %403 = mul i64 -32, %402
  %404 = add i64 %394, %403
  %405 = add i64 %404, -640
  %406 = icmp sgt i64 %393, %405
  %407 = select i1 %406, i64 %393, i64 %405
  %408 = mul i64 -20, %polly.indvar311
  %polly.loop_guard319 = icmp sle i64 %407, %408
  br i1 %polly.loop_guard319, label %polly.loop_header316, label %polly.loop_exit318

polly.loop_exit318:                               ; preds = %polly.loop_exit327, %polly.loop_header307
  %polly.indvar_next312 = add nsw i64 %polly.indvar311, 32
  %polly.adjust_ub313 = sub i64 %1, 32
  %polly.loop_cond314 = icmp sle i64 %polly.indvar311, %polly.adjust_ub313
  br i1 %polly.loop_cond314, label %polly.loop_header307, label %.preheader1

polly.loop_header316:                             ; preds = %polly.loop_header307, %polly.loop_exit327
  %polly.indvar320 = phi i64 [ %polly.indvar_next321, %polly.loop_exit327 ], [ %407, %polly.loop_header307 ]
  %409 = mul i64 -1, %polly.indvar320
  %410 = mul i64 -1, %4
  %411 = add i64 %409, %410
  %412 = add i64 %411, -30
  %413 = add i64 %412, 20
  %414 = sub i64 %413, 1
  %415 = icmp slt i64 %412, 0
  %416 = select i1 %415, i64 %412, i64 %414
  %417 = sdiv i64 %416, 20
  %418 = icmp sgt i64 %417, %polly.indvar311
  %419 = select i1 %418, i64 %417, i64 %polly.indvar311
  %420 = sub i64 %409, 20
  %421 = add i64 %420, 1
  %422 = icmp slt i64 %409, 0
  %423 = select i1 %422, i64 %421, i64 %409
  %424 = sdiv i64 %423, 20
  %425 = add i64 %polly.indvar311, 31
  %426 = icmp slt i64 %424, %425
  %427 = select i1 %426, i64 %424, i64 %425
  %428 = icmp slt i64 %427, %1
  %429 = select i1 %428, i64 %427, i64 %1
  %polly.loop_guard328 = icmp sle i64 %419, %429
  br i1 %polly.loop_guard328, label %polly.loop_header325, label %polly.loop_exit327

polly.loop_exit327:                               ; preds = %polly.loop_exit336, %polly.loop_header316
  %polly.indvar_next321 = add nsw i64 %polly.indvar320, 32
  %polly.adjust_ub322 = sub i64 %408, 32
  %polly.loop_cond323 = icmp sle i64 %polly.indvar320, %polly.adjust_ub322
  br i1 %polly.loop_cond323, label %polly.loop_header316, label %polly.loop_exit318

polly.loop_header325:                             ; preds = %polly.loop_header316, %polly.loop_exit336
  %polly.indvar329 = phi i64 [ %polly.indvar_next330, %polly.loop_exit336 ], [ %419, %polly.loop_header316 ]
  %430 = mul i64 -20, %polly.indvar329
  %431 = add i64 %430, %410
  %432 = add i64 %431, 1
  %433 = icmp sgt i64 %polly.indvar320, %432
  %434 = select i1 %433, i64 %polly.indvar320, i64 %432
  %435 = add i64 %polly.indvar320, 31
  %436 = icmp slt i64 %430, %435
  %437 = select i1 %436, i64 %430, i64 %435
  %polly.loop_guard337 = icmp sle i64 %434, %437
  br i1 %polly.loop_guard337, label %polly.loop_header334, label %polly.loop_exit336

polly.loop_exit336:                               ; preds = %polly.loop_header334, %polly.loop_header325
  %polly.indvar_next330 = add nsw i64 %polly.indvar329, 1
  %polly.adjust_ub331 = sub i64 %429, 1
  %polly.loop_cond332 = icmp sle i64 %polly.indvar329, %polly.adjust_ub331
  br i1 %polly.loop_cond332, label %polly.loop_header325, label %polly.loop_exit327

polly.loop_header334:                             ; preds = %polly.loop_header325, %polly.loop_header334
  %polly.indvar338 = phi i64 [ %polly.indvar_next339, %polly.loop_header334 ], [ %434, %polly.loop_header325 ]
  %438 = mul i64 -1, %polly.indvar338
  %439 = add i64 %430, %438
  %p_scevgep39344 = getelementptr [900 x double]* %tmp, i64 %polly.indvar329, i64 %439
  store double 0.000000e+00, double* %p_scevgep39344
  %polly.indvar_next339 = add nsw i64 %polly.indvar338, 1
  %polly.adjust_ub340 = sub i64 %437, 1
  %polly.loop_cond341 = icmp sle i64 %polly.indvar338, %polly.adjust_ub340
  br i1 %polly.loop_cond341, label %polly.loop_header334, label %polly.loop_exit336
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %ni, i32 %nl, [1200 x double]* %D) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
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
  %scevgep = getelementptr [1200 x double]* %D, i64 %indvar4, i64 %indvar
  %13 = srem i32 %12, 20
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %15, label %17

; <label>:15                                      ; preds = %10
  %16 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %16) #4
  br label %17

; <label>:17                                      ; preds = %15, %10
  %18 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %19 = load double* %scevgep, align 8, !tbaa !1
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
  %23 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %24 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %25 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
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
!2 = metadata !{metadata !"double", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{metadata !6, metadata !6, i64 0}
!6 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!7 = metadata !{metadata !3, metadata !3, i64 0}
