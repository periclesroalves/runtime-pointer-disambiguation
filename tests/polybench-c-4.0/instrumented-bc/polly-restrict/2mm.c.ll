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
define internal void @init_array(i32 %ni, i32 %nj, i32 %nk, i32 %nl, double* %alpha, double* %beta, [1100 x double]* noalias %A, [900 x double]* noalias %B, [1200 x double]* noalias %C, [1200 x double]* noalias %D) #0 {
.split:
  store double 1.500000e+00, double* %alpha, align 8, !tbaa !1
  store double 1.200000e+00, double* %beta, align 8, !tbaa !1
  %0 = icmp sgt i32 %ni, 0
  br i1 %0, label %.preheader6.lr.ph, label %polly.start

.preheader6.lr.ph:                                ; preds = %.split
  %1 = zext i32 %nk to i64
  %2 = sitofp i32 %ni to double
  %3 = zext i32 %ni to i64
  %4 = sext i32 %nk to i64
  %5 = icmp sge i64 %4, 1
  %6 = icmp sge i64 %3, 1
  %7 = and i1 %5, %6
  %8 = icmp sge i64 %1, 1
  %9 = and i1 %7, %8
  br i1 %9, label %polly.then193, label %polly.start

polly.start:                                      ; preds = %polly.then193, %polly.loop_exit206, %.preheader6.lr.ph, %.split
  %10 = zext i32 %nk to i64
  %11 = zext i32 %nj to i64
  %12 = zext i32 %nl to i64
  %13 = zext i32 %ni to i64
  %14 = sext i32 %ni to i64
  %15 = icmp sge i64 %14, 1
  %16 = sext i32 %nl to i64
  %17 = icmp sge i64 %16, 1
  %18 = and i1 %15, %17
  %19 = icmp sge i64 %12, 1
  %20 = and i1 %18, %19
  %21 = icmp sge i64 %13, 1
  %22 = and i1 %20, %21
  br i1 %22, label %polly.then, label %polly.cond96

polly.cond96:                                     ; preds = %polly.then, %polly.loop_exit67, %polly.start
  %23 = sext i32 %nj to i64
  %24 = icmp sge i64 %23, 1
  %25 = sext i32 %nk to i64
  %26 = icmp sge i64 %25, 1
  %27 = and i1 %24, %26
  %28 = icmp sge i64 %10, 1
  %29 = and i1 %27, %28
  %30 = icmp sge i64 %11, 1
  %31 = and i1 %29, %30
  br i1 %31, label %polly.then98, label %polly.cond142

polly.cond142:                                    ; preds = %polly.then98, %polly.loop_exit111, %polly.cond96
  %32 = and i1 %24, %17
  %33 = and i1 %32, %30
  %34 = and i1 %33, %19
  br i1 %34, label %polly.then144, label %polly.merge143

polly.merge143:                                   ; preds = %polly.then144, %polly.loop_exit157, %polly.cond142
  ret void

polly.then:                                       ; preds = %polly.start
  %35 = add i64 %13, -1
  %polly.loop_guard = icmp sle i64 0, %35
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond96

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit67
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit67 ], [ 0, %polly.then ]
  %36 = mul i64 -3, %13
  %37 = add i64 %12, %36
  %38 = add i64 %37, 5
  %39 = sub i64 %38, 32
  %40 = add i64 %39, 1
  %41 = icmp slt i64 %38, 0
  %42 = select i1 %41, i64 %40, i64 %38
  %43 = sdiv i64 %42, 32
  %44 = mul i64 -32, %43
  %45 = mul i64 -32, %13
  %46 = add i64 %44, %45
  %47 = mul i64 -32, %polly.indvar
  %48 = mul i64 -3, %polly.indvar
  %49 = add i64 %48, %12
  %50 = add i64 %49, 5
  %51 = sub i64 %50, 32
  %52 = add i64 %51, 1
  %53 = icmp slt i64 %50, 0
  %54 = select i1 %53, i64 %52, i64 %50
  %55 = sdiv i64 %54, 32
  %56 = mul i64 -32, %55
  %57 = add i64 %47, %56
  %58 = add i64 %57, -640
  %59 = icmp sgt i64 %46, %58
  %60 = select i1 %59, i64 %46, i64 %58
  %61 = mul i64 -20, %polly.indvar
  %polly.loop_guard68 = icmp sle i64 %60, %61
  br i1 %polly.loop_guard68, label %polly.loop_header65, label %polly.loop_exit67

polly.loop_exit67:                                ; preds = %polly.loop_exit76, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %35, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond96

polly.loop_header65:                              ; preds = %polly.loop_header, %polly.loop_exit76
  %polly.indvar69 = phi i64 [ %polly.indvar_next70, %polly.loop_exit76 ], [ %60, %polly.loop_header ]
  %62 = mul i64 -1, %polly.indvar69
  %63 = mul i64 -1, %12
  %64 = add i64 %62, %63
  %65 = add i64 %64, -30
  %66 = add i64 %65, 20
  %67 = sub i64 %66, 1
  %68 = icmp slt i64 %65, 0
  %69 = select i1 %68, i64 %65, i64 %67
  %70 = sdiv i64 %69, 20
  %71 = icmp sgt i64 %70, %polly.indvar
  %72 = select i1 %71, i64 %70, i64 %polly.indvar
  %73 = sub i64 %62, 20
  %74 = add i64 %73, 1
  %75 = icmp slt i64 %62, 0
  %76 = select i1 %75, i64 %74, i64 %62
  %77 = sdiv i64 %76, 20
  %78 = add i64 %polly.indvar, 31
  %79 = icmp slt i64 %77, %78
  %80 = select i1 %79, i64 %77, i64 %78
  %81 = icmp slt i64 %80, %35
  %82 = select i1 %81, i64 %80, i64 %35
  %polly.loop_guard77 = icmp sle i64 %72, %82
  br i1 %polly.loop_guard77, label %polly.loop_header74, label %polly.loop_exit76

polly.loop_exit76:                                ; preds = %polly.loop_exit85, %polly.loop_header65
  %polly.indvar_next70 = add nsw i64 %polly.indvar69, 32
  %polly.adjust_ub71 = sub i64 %61, 32
  %polly.loop_cond72 = icmp sle i64 %polly.indvar69, %polly.adjust_ub71
  br i1 %polly.loop_cond72, label %polly.loop_header65, label %polly.loop_exit67

polly.loop_header74:                              ; preds = %polly.loop_header65, %polly.loop_exit85
  %polly.indvar78 = phi i64 [ %polly.indvar_next79, %polly.loop_exit85 ], [ %72, %polly.loop_header65 ]
  %83 = mul i64 -20, %polly.indvar78
  %84 = add i64 %83, %63
  %85 = add i64 %84, 1
  %86 = icmp sgt i64 %polly.indvar69, %85
  %87 = select i1 %86, i64 %polly.indvar69, i64 %85
  %88 = add i64 %polly.indvar69, 31
  %89 = icmp slt i64 %83, %88
  %90 = select i1 %89, i64 %83, i64 %88
  %polly.loop_guard86 = icmp sle i64 %87, %90
  br i1 %polly.loop_guard86, label %polly.loop_header83, label %polly.loop_exit85

polly.loop_exit85:                                ; preds = %polly.loop_header83, %polly.loop_header74
  %polly.indvar_next79 = add nsw i64 %polly.indvar78, 1
  %polly.adjust_ub80 = sub i64 %82, 1
  %polly.loop_cond81 = icmp sle i64 %polly.indvar78, %polly.adjust_ub80
  br i1 %polly.loop_cond81, label %polly.loop_header74, label %polly.loop_exit76

polly.loop_header83:                              ; preds = %polly.loop_header74, %polly.loop_header83
  %polly.indvar87 = phi i64 [ %polly.indvar_next88, %polly.loop_header83 ], [ %87, %polly.loop_header74 ]
  %91 = mul i64 -1, %polly.indvar87
  %92 = add i64 %83, %91
  %p_.moved.to.60 = mul i64 %polly.indvar78, 2
  %p_.moved.to.61 = sitofp i32 %nk to double
  %p_scevgep = getelementptr [1200 x double]* %D, i64 %polly.indvar78, i64 %92
  %p_ = mul i64 %polly.indvar78, %92
  %p_91 = add i64 %p_.moved.to.60, %p_
  %p_92 = trunc i64 %p_91 to i32
  %p_93 = srem i32 %p_92, %nk
  %p_94 = sitofp i32 %p_93 to double
  %p_95 = fdiv double %p_94, %p_.moved.to.61
  store double %p_95, double* %p_scevgep
  %p_indvar.next = add i64 %92, 1
  %polly.indvar_next88 = add nsw i64 %polly.indvar87, 1
  %polly.adjust_ub89 = sub i64 %90, 1
  %polly.loop_cond90 = icmp sle i64 %polly.indvar87, %polly.adjust_ub89
  br i1 %polly.loop_cond90, label %polly.loop_header83, label %polly.loop_exit85

polly.then98:                                     ; preds = %polly.cond96
  %93 = add i64 %10, -1
  %polly.loop_guard103 = icmp sle i64 0, %93
  br i1 %polly.loop_guard103, label %polly.loop_header100, label %polly.cond142

polly.loop_header100:                             ; preds = %polly.then98, %polly.loop_exit111
  %polly.indvar104 = phi i64 [ %polly.indvar_next105, %polly.loop_exit111 ], [ 0, %polly.then98 ]
  %94 = mul i64 -3, %10
  %95 = add i64 %94, %11
  %96 = add i64 %95, 5
  %97 = sub i64 %96, 32
  %98 = add i64 %97, 1
  %99 = icmp slt i64 %96, 0
  %100 = select i1 %99, i64 %98, i64 %96
  %101 = sdiv i64 %100, 32
  %102 = mul i64 -32, %101
  %103 = mul i64 -32, %10
  %104 = add i64 %102, %103
  %105 = mul i64 -32, %polly.indvar104
  %106 = mul i64 -3, %polly.indvar104
  %107 = add i64 %106, %11
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
  %119 = mul i64 -20, %polly.indvar104
  %polly.loop_guard112 = icmp sle i64 %118, %119
  br i1 %polly.loop_guard112, label %polly.loop_header109, label %polly.loop_exit111

polly.loop_exit111:                               ; preds = %polly.loop_exit120, %polly.loop_header100
  %polly.indvar_next105 = add nsw i64 %polly.indvar104, 32
  %polly.adjust_ub106 = sub i64 %93, 32
  %polly.loop_cond107 = icmp sle i64 %polly.indvar104, %polly.adjust_ub106
  br i1 %polly.loop_cond107, label %polly.loop_header100, label %polly.cond142

polly.loop_header109:                             ; preds = %polly.loop_header100, %polly.loop_exit120
  %polly.indvar113 = phi i64 [ %polly.indvar_next114, %polly.loop_exit120 ], [ %118, %polly.loop_header100 ]
  %120 = mul i64 -1, %polly.indvar113
  %121 = mul i64 -1, %11
  %122 = add i64 %120, %121
  %123 = add i64 %122, -30
  %124 = add i64 %123, 20
  %125 = sub i64 %124, 1
  %126 = icmp slt i64 %123, 0
  %127 = select i1 %126, i64 %123, i64 %125
  %128 = sdiv i64 %127, 20
  %129 = icmp sgt i64 %128, %polly.indvar104
  %130 = select i1 %129, i64 %128, i64 %polly.indvar104
  %131 = sub i64 %120, 20
  %132 = add i64 %131, 1
  %133 = icmp slt i64 %120, 0
  %134 = select i1 %133, i64 %132, i64 %120
  %135 = sdiv i64 %134, 20
  %136 = add i64 %polly.indvar104, 31
  %137 = icmp slt i64 %135, %136
  %138 = select i1 %137, i64 %135, i64 %136
  %139 = icmp slt i64 %138, %93
  %140 = select i1 %139, i64 %138, i64 %93
  %polly.loop_guard121 = icmp sle i64 %130, %140
  br i1 %polly.loop_guard121, label %polly.loop_header118, label %polly.loop_exit120

polly.loop_exit120:                               ; preds = %polly.loop_exit129, %polly.loop_header109
  %polly.indvar_next114 = add nsw i64 %polly.indvar113, 32
  %polly.adjust_ub115 = sub i64 %119, 32
  %polly.loop_cond116 = icmp sle i64 %polly.indvar113, %polly.adjust_ub115
  br i1 %polly.loop_cond116, label %polly.loop_header109, label %polly.loop_exit111

polly.loop_header118:                             ; preds = %polly.loop_header109, %polly.loop_exit129
  %polly.indvar122 = phi i64 [ %polly.indvar_next123, %polly.loop_exit129 ], [ %130, %polly.loop_header109 ]
  %141 = mul i64 -20, %polly.indvar122
  %142 = add i64 %141, %121
  %143 = add i64 %142, 1
  %144 = icmp sgt i64 %polly.indvar113, %143
  %145 = select i1 %144, i64 %polly.indvar113, i64 %143
  %146 = add i64 %polly.indvar113, 31
  %147 = icmp slt i64 %141, %146
  %148 = select i1 %147, i64 %141, i64 %146
  %polly.loop_guard130 = icmp sle i64 %145, %148
  br i1 %polly.loop_guard130, label %polly.loop_header127, label %polly.loop_exit129

polly.loop_exit129:                               ; preds = %polly.loop_header127, %polly.loop_header118
  %polly.indvar_next123 = add nsw i64 %polly.indvar122, 1
  %polly.adjust_ub124 = sub i64 %140, 1
  %polly.loop_cond125 = icmp sle i64 %polly.indvar122, %polly.adjust_ub124
  br i1 %polly.loop_cond125, label %polly.loop_header118, label %polly.loop_exit120

polly.loop_header127:                             ; preds = %polly.loop_header118, %polly.loop_header127
  %polly.indvar131 = phi i64 [ %polly.indvar_next132, %polly.loop_header127 ], [ %145, %polly.loop_header118 ]
  %149 = mul i64 -1, %polly.indvar131
  %150 = add i64 %141, %149
  %p_.moved.to. = sitofp i32 %nj to double
  %p_scevgep43 = getelementptr [900 x double]* %B, i64 %polly.indvar122, i64 %150
  %p_136 = mul i64 %polly.indvar122, %150
  %p_137 = add i64 %polly.indvar122, %p_136
  %p_138 = trunc i64 %p_137 to i32
  %p_139 = srem i32 %p_138, %nj
  %p_140 = sitofp i32 %p_139 to double
  %p_141 = fdiv double %p_140, %p_.moved.to.
  store double %p_141, double* %p_scevgep43
  %p_indvar.next39 = add i64 %150, 1
  %polly.indvar_next132 = add nsw i64 %polly.indvar131, 1
  %polly.adjust_ub133 = sub i64 %148, 1
  %polly.loop_cond134 = icmp sle i64 %polly.indvar131, %polly.adjust_ub133
  br i1 %polly.loop_cond134, label %polly.loop_header127, label %polly.loop_exit129

polly.then144:                                    ; preds = %polly.cond142
  %151 = add i64 %11, -1
  %polly.loop_guard149 = icmp sle i64 0, %151
  br i1 %polly.loop_guard149, label %polly.loop_header146, label %polly.merge143

polly.loop_header146:                             ; preds = %polly.then144, %polly.loop_exit157
  %polly.indvar150 = phi i64 [ %polly.indvar_next151, %polly.loop_exit157 ], [ 0, %polly.then144 ]
  %152 = mul i64 -3, %11
  %153 = add i64 %152, %12
  %154 = add i64 %153, 5
  %155 = sub i64 %154, 32
  %156 = add i64 %155, 1
  %157 = icmp slt i64 %154, 0
  %158 = select i1 %157, i64 %156, i64 %154
  %159 = sdiv i64 %158, 32
  %160 = mul i64 -32, %159
  %161 = mul i64 -32, %11
  %162 = add i64 %160, %161
  %163 = mul i64 -32, %polly.indvar150
  %164 = mul i64 -3, %polly.indvar150
  %165 = add i64 %164, %12
  %166 = add i64 %165, 5
  %167 = sub i64 %166, 32
  %168 = add i64 %167, 1
  %169 = icmp slt i64 %166, 0
  %170 = select i1 %169, i64 %168, i64 %166
  %171 = sdiv i64 %170, 32
  %172 = mul i64 -32, %171
  %173 = add i64 %163, %172
  %174 = add i64 %173, -640
  %175 = icmp sgt i64 %162, %174
  %176 = select i1 %175, i64 %162, i64 %174
  %177 = mul i64 -20, %polly.indvar150
  %polly.loop_guard158 = icmp sle i64 %176, %177
  br i1 %polly.loop_guard158, label %polly.loop_header155, label %polly.loop_exit157

polly.loop_exit157:                               ; preds = %polly.loop_exit166, %polly.loop_header146
  %polly.indvar_next151 = add nsw i64 %polly.indvar150, 32
  %polly.adjust_ub152 = sub i64 %151, 32
  %polly.loop_cond153 = icmp sle i64 %polly.indvar150, %polly.adjust_ub152
  br i1 %polly.loop_cond153, label %polly.loop_header146, label %polly.merge143

polly.loop_header155:                             ; preds = %polly.loop_header146, %polly.loop_exit166
  %polly.indvar159 = phi i64 [ %polly.indvar_next160, %polly.loop_exit166 ], [ %176, %polly.loop_header146 ]
  %178 = mul i64 -1, %polly.indvar159
  %179 = mul i64 -1, %12
  %180 = add i64 %178, %179
  %181 = add i64 %180, -30
  %182 = add i64 %181, 20
  %183 = sub i64 %182, 1
  %184 = icmp slt i64 %181, 0
  %185 = select i1 %184, i64 %181, i64 %183
  %186 = sdiv i64 %185, 20
  %187 = icmp sgt i64 %186, %polly.indvar150
  %188 = select i1 %187, i64 %186, i64 %polly.indvar150
  %189 = sub i64 %178, 20
  %190 = add i64 %189, 1
  %191 = icmp slt i64 %178, 0
  %192 = select i1 %191, i64 %190, i64 %178
  %193 = sdiv i64 %192, 20
  %194 = add i64 %polly.indvar150, 31
  %195 = icmp slt i64 %193, %194
  %196 = select i1 %195, i64 %193, i64 %194
  %197 = icmp slt i64 %196, %151
  %198 = select i1 %197, i64 %196, i64 %151
  %polly.loop_guard167 = icmp sle i64 %188, %198
  br i1 %polly.loop_guard167, label %polly.loop_header164, label %polly.loop_exit166

polly.loop_exit166:                               ; preds = %polly.loop_exit175, %polly.loop_header155
  %polly.indvar_next160 = add nsw i64 %polly.indvar159, 32
  %polly.adjust_ub161 = sub i64 %177, 32
  %polly.loop_cond162 = icmp sle i64 %polly.indvar159, %polly.adjust_ub161
  br i1 %polly.loop_cond162, label %polly.loop_header155, label %polly.loop_exit157

polly.loop_header164:                             ; preds = %polly.loop_header155, %polly.loop_exit175
  %polly.indvar168 = phi i64 [ %polly.indvar_next169, %polly.loop_exit175 ], [ %188, %polly.loop_header155 ]
  %199 = mul i64 -20, %polly.indvar168
  %200 = add i64 %199, %179
  %201 = add i64 %200, 1
  %202 = icmp sgt i64 %polly.indvar159, %201
  %203 = select i1 %202, i64 %polly.indvar159, i64 %201
  %204 = add i64 %polly.indvar159, 31
  %205 = icmp slt i64 %199, %204
  %206 = select i1 %205, i64 %199, i64 %204
  %polly.loop_guard176 = icmp sle i64 %203, %206
  br i1 %polly.loop_guard176, label %polly.loop_header173, label %polly.loop_exit175

polly.loop_exit175:                               ; preds = %polly.loop_header173, %polly.loop_header164
  %polly.indvar_next169 = add nsw i64 %polly.indvar168, 1
  %polly.adjust_ub170 = sub i64 %198, 1
  %polly.loop_cond171 = icmp sle i64 %polly.indvar168, %polly.adjust_ub170
  br i1 %polly.loop_cond171, label %polly.loop_header164, label %polly.loop_exit166

polly.loop_header173:                             ; preds = %polly.loop_header164, %polly.loop_header173
  %polly.indvar177 = phi i64 [ %polly.indvar_next178, %polly.loop_header173 ], [ %203, %polly.loop_header164 ]
  %207 = mul i64 -1, %polly.indvar177
  %208 = add i64 %199, %207
  %p_.moved.to.56 = mul i64 %polly.indvar168, 3
  %p_.moved.to.57 = sitofp i32 %nl to double
  %p_scevgep35 = getelementptr [1200 x double]* %C, i64 %polly.indvar168, i64 %208
  %p_182 = mul i64 %polly.indvar168, %208
  %p_183 = add i64 %p_.moved.to.56, %p_182
  %p_184 = trunc i64 %p_183 to i32
  %p_185 = srem i32 %p_184, %nl
  %p_186 = sitofp i32 %p_185 to double
  %p_187 = fdiv double %p_186, %p_.moved.to.57
  store double %p_187, double* %p_scevgep35
  %p_indvar.next31 = add i64 %208, 1
  %polly.indvar_next178 = add nsw i64 %polly.indvar177, 1
  %polly.adjust_ub179 = sub i64 %206, 1
  %polly.loop_cond180 = icmp sle i64 %polly.indvar177, %polly.adjust_ub179
  br i1 %polly.loop_cond180, label %polly.loop_header173, label %polly.loop_exit175

polly.then193:                                    ; preds = %.preheader6.lr.ph
  %209 = add i64 %3, -1
  %polly.loop_guard198 = icmp sle i64 0, %209
  br i1 %polly.loop_guard198, label %polly.loop_header195, label %polly.start

polly.loop_header195:                             ; preds = %polly.then193, %polly.loop_exit206
  %polly.indvar199 = phi i64 [ %polly.indvar_next200, %polly.loop_exit206 ], [ 0, %polly.then193 ]
  %210 = mul i64 -3, %3
  %211 = add i64 %210, %1
  %212 = add i64 %211, 5
  %213 = sub i64 %212, 32
  %214 = add i64 %213, 1
  %215 = icmp slt i64 %212, 0
  %216 = select i1 %215, i64 %214, i64 %212
  %217 = sdiv i64 %216, 32
  %218 = mul i64 -32, %217
  %219 = mul i64 -32, %3
  %220 = add i64 %218, %219
  %221 = mul i64 -32, %polly.indvar199
  %222 = mul i64 -3, %polly.indvar199
  %223 = add i64 %222, %1
  %224 = add i64 %223, 5
  %225 = sub i64 %224, 32
  %226 = add i64 %225, 1
  %227 = icmp slt i64 %224, 0
  %228 = select i1 %227, i64 %226, i64 %224
  %229 = sdiv i64 %228, 32
  %230 = mul i64 -32, %229
  %231 = add i64 %221, %230
  %232 = add i64 %231, -640
  %233 = icmp sgt i64 %220, %232
  %234 = select i1 %233, i64 %220, i64 %232
  %235 = mul i64 -20, %polly.indvar199
  %polly.loop_guard207 = icmp sle i64 %234, %235
  br i1 %polly.loop_guard207, label %polly.loop_header204, label %polly.loop_exit206

polly.loop_exit206:                               ; preds = %polly.loop_exit215, %polly.loop_header195
  %polly.indvar_next200 = add nsw i64 %polly.indvar199, 32
  %polly.adjust_ub201 = sub i64 %209, 32
  %polly.loop_cond202 = icmp sle i64 %polly.indvar199, %polly.adjust_ub201
  br i1 %polly.loop_cond202, label %polly.loop_header195, label %polly.start

polly.loop_header204:                             ; preds = %polly.loop_header195, %polly.loop_exit215
  %polly.indvar208 = phi i64 [ %polly.indvar_next209, %polly.loop_exit215 ], [ %234, %polly.loop_header195 ]
  %236 = mul i64 -1, %polly.indvar208
  %237 = mul i64 -1, %1
  %238 = add i64 %236, %237
  %239 = add i64 %238, -30
  %240 = add i64 %239, 20
  %241 = sub i64 %240, 1
  %242 = icmp slt i64 %239, 0
  %243 = select i1 %242, i64 %239, i64 %241
  %244 = sdiv i64 %243, 20
  %245 = icmp sgt i64 %244, %polly.indvar199
  %246 = select i1 %245, i64 %244, i64 %polly.indvar199
  %247 = sub i64 %236, 20
  %248 = add i64 %247, 1
  %249 = icmp slt i64 %236, 0
  %250 = select i1 %249, i64 %248, i64 %236
  %251 = sdiv i64 %250, 20
  %252 = add i64 %polly.indvar199, 31
  %253 = icmp slt i64 %251, %252
  %254 = select i1 %253, i64 %251, i64 %252
  %255 = icmp slt i64 %254, %209
  %256 = select i1 %255, i64 %254, i64 %209
  %polly.loop_guard216 = icmp sle i64 %246, %256
  br i1 %polly.loop_guard216, label %polly.loop_header213, label %polly.loop_exit215

polly.loop_exit215:                               ; preds = %polly.loop_exit224, %polly.loop_header204
  %polly.indvar_next209 = add nsw i64 %polly.indvar208, 32
  %polly.adjust_ub210 = sub i64 %235, 32
  %polly.loop_cond211 = icmp sle i64 %polly.indvar208, %polly.adjust_ub210
  br i1 %polly.loop_cond211, label %polly.loop_header204, label %polly.loop_exit206

polly.loop_header213:                             ; preds = %polly.loop_header204, %polly.loop_exit224
  %polly.indvar217 = phi i64 [ %polly.indvar_next218, %polly.loop_exit224 ], [ %246, %polly.loop_header204 ]
  %257 = mul i64 -20, %polly.indvar217
  %258 = add i64 %257, %237
  %259 = add i64 %258, 1
  %260 = icmp sgt i64 %polly.indvar208, %259
  %261 = select i1 %260, i64 %polly.indvar208, i64 %259
  %262 = add i64 %polly.indvar208, 31
  %263 = icmp slt i64 %257, %262
  %264 = select i1 %263, i64 %257, i64 %262
  %polly.loop_guard225 = icmp sle i64 %261, %264
  br i1 %polly.loop_guard225, label %polly.loop_header222, label %polly.loop_exit224

polly.loop_exit224:                               ; preds = %polly.loop_header222, %polly.loop_header213
  %polly.indvar_next218 = add nsw i64 %polly.indvar217, 1
  %polly.adjust_ub219 = sub i64 %256, 1
  %polly.loop_cond220 = icmp sle i64 %polly.indvar217, %polly.adjust_ub219
  br i1 %polly.loop_cond220, label %polly.loop_header213, label %polly.loop_exit215

polly.loop_header222:                             ; preds = %polly.loop_header213, %polly.loop_header222
  %polly.indvar226 = phi i64 [ %polly.indvar_next227, %polly.loop_header222 ], [ %261, %polly.loop_header213 ]
  %265 = mul i64 -1, %polly.indvar226
  %266 = add i64 %257, %265
  %p_scevgep51 = getelementptr [1100 x double]* %A, i64 %polly.indvar217, i64 %266
  %p_231 = mul i64 %polly.indvar217, %266
  %p_232 = trunc i64 %p_231 to i32
  %p_233 = srem i32 %p_232, %ni
  %p_234 = sitofp i32 %p_233 to double
  %p_235 = fdiv double %p_234, %2
  store double %p_235, double* %p_scevgep51
  %p_indvar.next47 = add i64 %266, 1
  %polly.indvar_next227 = add nsw i64 %polly.indvar226, 1
  %polly.adjust_ub228 = sub i64 %264, 1
  %polly.loop_cond229 = icmp sle i64 %polly.indvar226, %polly.adjust_ub228
  br i1 %polly.loop_cond229, label %polly.loop_header222, label %polly.loop_exit224
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_2mm(i32 %ni, i32 %nj, i32 %nk, i32 %nl, double %alpha, double %beta, [900 x double]* noalias %tmp, [1100 x double]* noalias %A, [900 x double]* noalias %B, [1200 x double]* noalias %C, [1200 x double]* noalias %D) #0 {
polly.split_new_and_old:
  %0 = zext i32 %ni to i64
  %1 = zext i32 %nj to i64
  %2 = zext i32 %nk to i64
  %3 = zext i32 %nl to i64
  %4 = sext i32 %ni to i64
  %5 = icmp sge i64 %4, 1
  %6 = icmp sge i64 %0, 1
  %7 = and i1 %5, %6
  br i1 %7, label %polly.cond54, label %polly.merge

polly.merge:                                      ; preds = %polly.then249, %polly.loop_exit262, %polly.cond247, %polly.cond155, %polly.split_new_and_old
  ret void

polly.cond54:                                     ; preds = %polly.split_new_and_old
  %8 = sext i32 %nj to i64
  %9 = icmp sge i64 %8, 1
  %10 = icmp sge i64 %1, 1
  %11 = and i1 %9, %10
  br i1 %11, label %polly.cond57, label %polly.cond155

polly.cond155:                                    ; preds = %polly.then133, %polly.loop_exit146, %polly.cond131, %polly.cond54
  %12 = sext i32 %nl to i64
  %13 = icmp sge i64 %12, 1
  %14 = icmp sge i64 %3, 1
  %15 = and i1 %13, %14
  br i1 %15, label %polly.cond158, label %polly.merge

polly.cond57:                                     ; preds = %polly.cond54
  %16 = sext i32 %nk to i64
  %17 = icmp sge i64 %16, 1
  %18 = icmp sge i64 %2, 1
  %19 = and i1 %17, %18
  br i1 %19, label %polly.then59, label %polly.cond92

polly.cond92:                                     ; preds = %polly.then59, %polly.loop_exit72, %polly.cond57
  %20 = icmp sle i64 %2, 0
  %21 = and i1 %17, %20
  br i1 %21, label %polly.then94, label %polly.cond131

polly.cond131:                                    ; preds = %polly.then94, %polly.loop_exit119, %polly.cond92
  %22 = icmp sle i64 %16, 0
  br i1 %22, label %polly.then133, label %polly.cond155

polly.then59:                                     ; preds = %polly.cond57
  %23 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %23
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond92

polly.loop_header:                                ; preds = %polly.then59, %polly.loop_exit72
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit72 ], [ 0, %polly.then59 ]
  %24 = add i64 %1, -1
  %polly.loop_guard64 = icmp sle i64 0, %24
  br i1 %polly.loop_guard64, label %polly.loop_header61, label %polly.loop_exit63

polly.loop_exit63:                                ; preds = %polly.loop_header61, %polly.loop_header
  br i1 %polly.loop_guard64, label %polly.loop_header70, label %polly.loop_exit72

polly.loop_exit72:                                ; preds = %polly.loop_exit81, %polly.loop_exit63
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %23, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond92

polly.loop_header61:                              ; preds = %polly.loop_header, %polly.loop_header61
  %polly.indvar65 = phi i64 [ %polly.indvar_next66, %polly.loop_header61 ], [ 0, %polly.loop_header ]
  %p_scevgep41 = getelementptr [900 x double]* %tmp, i64 %polly.indvar, i64 %polly.indvar65
  store double 0.000000e+00, double* %p_scevgep41
  %polly.indvar_next66 = add nsw i64 %polly.indvar65, 1
  %polly.adjust_ub67 = sub i64 %24, 1
  %polly.loop_cond68 = icmp sle i64 %polly.indvar65, %polly.adjust_ub67
  br i1 %polly.loop_cond68, label %polly.loop_header61, label %polly.loop_exit63

polly.loop_header70:                              ; preds = %polly.loop_exit63, %polly.loop_exit81
  %polly.indvar74 = phi i64 [ %polly.indvar_next75, %polly.loop_exit81 ], [ 0, %polly.loop_exit63 ]
  %p_scevgep41.moved.to..lr.ph11 = getelementptr [900 x double]* %tmp, i64 %polly.indvar, i64 %polly.indvar74
  %.promoted37_p_scalar_ = load double* %p_scevgep41.moved.to..lr.ph11
  %25 = add i64 %2, -1
  %polly.loop_guard82 = icmp sle i64 0, %25
  br i1 %polly.loop_guard82, label %polly.loop_header79, label %polly.loop_exit81

polly.loop_exit81:                                ; preds = %polly.loop_header79, %polly.loop_header70
  %.reg2mem45.0 = phi double [ %p_90, %polly.loop_header79 ], [ %.promoted37_p_scalar_, %polly.loop_header70 ]
  store double %.reg2mem45.0, double* %p_scevgep41.moved.to..lr.ph11
  %polly.indvar_next75 = add nsw i64 %polly.indvar74, 1
  %polly.adjust_ub76 = sub i64 %24, 1
  %polly.loop_cond77 = icmp sle i64 %polly.indvar74, %polly.adjust_ub76
  br i1 %polly.loop_cond77, label %polly.loop_header70, label %polly.loop_exit72

polly.loop_header79:                              ; preds = %polly.loop_header70, %polly.loop_header79
  %.reg2mem45.1 = phi double [ %.promoted37_p_scalar_, %polly.loop_header70 ], [ %p_90, %polly.loop_header79 ]
  %polly.indvar83 = phi i64 [ %polly.indvar_next84, %polly.loop_header79 ], [ 0, %polly.loop_header70 ]
  %p_scevgep33 = getelementptr [1100 x double]* %A, i64 %polly.indvar, i64 %polly.indvar83
  %p_scevgep36 = getelementptr [900 x double]* %B, i64 %polly.indvar83, i64 %polly.indvar74
  %_p_scalar_ = load double* %p_scevgep33
  %p_ = fmul double %_p_scalar_, %alpha
  %_p_scalar_88 = load double* %p_scevgep36
  %p_89 = fmul double %p_, %_p_scalar_88
  %p_90 = fadd double %.reg2mem45.1, %p_89
  %p_indvar.next29 = add i64 %polly.indvar83, 1
  %polly.indvar_next84 = add nsw i64 %polly.indvar83, 1
  %polly.adjust_ub85 = sub i64 %25, 1
  %polly.loop_cond86 = icmp sle i64 %polly.indvar83, %polly.adjust_ub85
  br i1 %polly.loop_cond86, label %polly.loop_header79, label %polly.loop_exit81

polly.then94:                                     ; preds = %polly.cond92
  %26 = add i64 %0, -1
  %polly.loop_guard99 = icmp sle i64 0, %26
  br i1 %polly.loop_guard99, label %polly.loop_header96, label %polly.cond131

polly.loop_header96:                              ; preds = %polly.then94, %polly.loop_exit119
  %polly.indvar100 = phi i64 [ %polly.indvar_next101, %polly.loop_exit119 ], [ 0, %polly.then94 ]
  %27 = add i64 %1, -1
  %polly.loop_guard108 = icmp sle i64 0, %27
  br i1 %polly.loop_guard108, label %polly.loop_header105, label %polly.loop_exit107

polly.loop_exit107:                               ; preds = %polly.loop_header105, %polly.loop_header96
  br i1 %polly.loop_guard108, label %polly.loop_header117, label %polly.loop_exit119

polly.loop_exit119:                               ; preds = %polly.loop_header117, %polly.loop_exit107
  %polly.indvar_next101 = add nsw i64 %polly.indvar100, 1
  %polly.adjust_ub102 = sub i64 %26, 1
  %polly.loop_cond103 = icmp sle i64 %polly.indvar100, %polly.adjust_ub102
  br i1 %polly.loop_cond103, label %polly.loop_header96, label %polly.cond131

polly.loop_header105:                             ; preds = %polly.loop_header96, %polly.loop_header105
  %polly.indvar109 = phi i64 [ %polly.indvar_next110, %polly.loop_header105 ], [ 0, %polly.loop_header96 ]
  %p_scevgep41115 = getelementptr [900 x double]* %tmp, i64 %polly.indvar100, i64 %polly.indvar109
  store double 0.000000e+00, double* %p_scevgep41115
  %polly.indvar_next110 = add nsw i64 %polly.indvar109, 1
  %polly.adjust_ub111 = sub i64 %27, 1
  %polly.loop_cond112 = icmp sle i64 %polly.indvar109, %polly.adjust_ub111
  br i1 %polly.loop_cond112, label %polly.loop_header105, label %polly.loop_exit107

polly.loop_header117:                             ; preds = %polly.loop_exit107, %polly.loop_header117
  %polly.indvar121 = phi i64 [ %polly.indvar_next122, %polly.loop_header117 ], [ 0, %polly.loop_exit107 ]
  %p_scevgep41.moved.to..lr.ph11126 = getelementptr [900 x double]* %tmp, i64 %polly.indvar100, i64 %polly.indvar121
  %.promoted37_p_scalar_127 = load double* %p_scevgep41.moved.to..lr.ph11126
  store double %.promoted37_p_scalar_127, double* %p_scevgep41.moved.to..lr.ph11126
  %polly.indvar_next122 = add nsw i64 %polly.indvar121, 1
  %polly.adjust_ub123 = sub i64 %27, 1
  %polly.loop_cond124 = icmp sle i64 %polly.indvar121, %polly.adjust_ub123
  br i1 %polly.loop_cond124, label %polly.loop_header117, label %polly.loop_exit119

polly.then133:                                    ; preds = %polly.cond131
  %28 = add i64 %0, -1
  %polly.loop_guard138 = icmp sle i64 0, %28
  br i1 %polly.loop_guard138, label %polly.loop_header135, label %polly.cond155

polly.loop_header135:                             ; preds = %polly.then133, %polly.loop_exit146
  %polly.indvar139 = phi i64 [ %polly.indvar_next140, %polly.loop_exit146 ], [ 0, %polly.then133 ]
  %29 = add i64 %1, -1
  %polly.loop_guard147 = icmp sle i64 0, %29
  br i1 %polly.loop_guard147, label %polly.loop_header144, label %polly.loop_exit146

polly.loop_exit146:                               ; preds = %polly.loop_header144, %polly.loop_header135
  %polly.indvar_next140 = add nsw i64 %polly.indvar139, 1
  %polly.adjust_ub141 = sub i64 %28, 1
  %polly.loop_cond142 = icmp sle i64 %polly.indvar139, %polly.adjust_ub141
  br i1 %polly.loop_cond142, label %polly.loop_header135, label %polly.cond155

polly.loop_header144:                             ; preds = %polly.loop_header135, %polly.loop_header144
  %polly.indvar148 = phi i64 [ %polly.indvar_next149, %polly.loop_header144 ], [ 0, %polly.loop_header135 ]
  %p_scevgep41154 = getelementptr [900 x double]* %tmp, i64 %polly.indvar139, i64 %polly.indvar148
  store double 0.000000e+00, double* %p_scevgep41154
  %polly.indvar_next149 = add nsw i64 %polly.indvar148, 1
  %polly.adjust_ub150 = sub i64 %29, 1
  %polly.loop_cond151 = icmp sle i64 %polly.indvar148, %polly.adjust_ub150
  br i1 %polly.loop_cond151, label %polly.loop_header144, label %polly.loop_exit146

polly.cond158:                                    ; preds = %polly.cond155
  br i1 %11, label %polly.then160, label %polly.cond206

polly.cond206:                                    ; preds = %polly.then160, %polly.loop_exit185, %polly.cond158
  %30 = icmp sle i64 %1, 0
  %31 = and i1 %9, %30
  br i1 %31, label %polly.then208, label %polly.cond247

polly.cond247:                                    ; preds = %polly.then208, %polly.loop_exit235, %polly.cond206
  %32 = icmp sle i64 %8, 0
  br i1 %32, label %polly.then249, label %polly.merge

polly.then160:                                    ; preds = %polly.cond158
  %33 = add i64 %0, -1
  %polly.loop_guard165 = icmp sle i64 0, %33
  br i1 %polly.loop_guard165, label %polly.loop_header162, label %polly.cond206

polly.loop_header162:                             ; preds = %polly.then160, %polly.loop_exit185
  %polly.indvar166 = phi i64 [ %polly.indvar_next167, %polly.loop_exit185 ], [ 0, %polly.then160 ]
  %34 = add i64 %3, -1
  %polly.loop_guard174 = icmp sle i64 0, %34
  br i1 %polly.loop_guard174, label %polly.loop_header171, label %polly.loop_exit173

polly.loop_exit173:                               ; preds = %polly.loop_header171, %polly.loop_header162
  br i1 %polly.loop_guard174, label %polly.loop_header183, label %polly.loop_exit185

polly.loop_exit185:                               ; preds = %polly.loop_exit194, %polly.loop_exit173
  %polly.indvar_next167 = add nsw i64 %polly.indvar166, 1
  %polly.adjust_ub168 = sub i64 %33, 1
  %polly.loop_cond169 = icmp sle i64 %polly.indvar166, %polly.adjust_ub168
  br i1 %polly.loop_cond169, label %polly.loop_header162, label %polly.cond206

polly.loop_header171:                             ; preds = %polly.loop_header162, %polly.loop_header171
  %polly.indvar175 = phi i64 [ %polly.indvar_next176, %polly.loop_header171 ], [ 0, %polly.loop_header162 ]
  %p_scevgep24 = getelementptr [1200 x double]* %D, i64 %polly.indvar166, i64 %polly.indvar175
  %_p_scalar_180 = load double* %p_scevgep24
  %p_181 = fmul double %_p_scalar_180, %beta
  store double %p_181, double* %p_scevgep24
  %polly.indvar_next176 = add nsw i64 %polly.indvar175, 1
  %polly.adjust_ub177 = sub i64 %34, 1
  %polly.loop_cond178 = icmp sle i64 %polly.indvar175, %polly.adjust_ub177
  br i1 %polly.loop_cond178, label %polly.loop_header171, label %polly.loop_exit173

polly.loop_header183:                             ; preds = %polly.loop_exit173, %polly.loop_exit194
  %polly.indvar187 = phi i64 [ %polly.indvar_next188, %polly.loop_exit194 ], [ 0, %polly.loop_exit173 ]
  %p_scevgep24.moved.to..lr.ph = getelementptr [1200 x double]* %D, i64 %polly.indvar166, i64 %polly.indvar187
  %.promoted_p_scalar_ = load double* %p_scevgep24.moved.to..lr.ph
  %35 = add i64 %1, -1
  %polly.loop_guard195 = icmp sle i64 0, %35
  br i1 %polly.loop_guard195, label %polly.loop_header192, label %polly.loop_exit194

polly.loop_exit194:                               ; preds = %polly.loop_header192, %polly.loop_header183
  %.reg2mem.0 = phi double [ %p_204, %polly.loop_header192 ], [ %.promoted_p_scalar_, %polly.loop_header183 ]
  store double %.reg2mem.0, double* %p_scevgep24.moved.to..lr.ph
  %polly.indvar_next188 = add nsw i64 %polly.indvar187, 1
  %polly.adjust_ub189 = sub i64 %34, 1
  %polly.loop_cond190 = icmp sle i64 %polly.indvar187, %polly.adjust_ub189
  br i1 %polly.loop_cond190, label %polly.loop_header183, label %polly.loop_exit185

polly.loop_header192:                             ; preds = %polly.loop_header183, %polly.loop_header192
  %.reg2mem.1 = phi double [ %.promoted_p_scalar_, %polly.loop_header183 ], [ %p_204, %polly.loop_header192 ]
  %polly.indvar196 = phi i64 [ %polly.indvar_next197, %polly.loop_header192 ], [ 0, %polly.loop_header183 ]
  %p_scevgep = getelementptr [900 x double]* %tmp, i64 %polly.indvar166, i64 %polly.indvar196
  %p_scevgep21 = getelementptr [1200 x double]* %C, i64 %polly.indvar196, i64 %polly.indvar187
  %_p_scalar_201 = load double* %p_scevgep
  %_p_scalar_202 = load double* %p_scevgep21
  %p_203 = fmul double %_p_scalar_201, %_p_scalar_202
  %p_204 = fadd double %.reg2mem.1, %p_203
  %p_indvar.next = add i64 %polly.indvar196, 1
  %polly.indvar_next197 = add nsw i64 %polly.indvar196, 1
  %polly.adjust_ub198 = sub i64 %35, 1
  %polly.loop_cond199 = icmp sle i64 %polly.indvar196, %polly.adjust_ub198
  br i1 %polly.loop_cond199, label %polly.loop_header192, label %polly.loop_exit194

polly.then208:                                    ; preds = %polly.cond206
  %36 = add i64 %0, -1
  %polly.loop_guard213 = icmp sle i64 0, %36
  br i1 %polly.loop_guard213, label %polly.loop_header210, label %polly.cond247

polly.loop_header210:                             ; preds = %polly.then208, %polly.loop_exit235
  %polly.indvar214 = phi i64 [ %polly.indvar_next215, %polly.loop_exit235 ], [ 0, %polly.then208 ]
  %37 = add i64 %3, -1
  %polly.loop_guard222 = icmp sle i64 0, %37
  br i1 %polly.loop_guard222, label %polly.loop_header219, label %polly.loop_exit221

polly.loop_exit221:                               ; preds = %polly.loop_header219, %polly.loop_header210
  br i1 %polly.loop_guard222, label %polly.loop_header233, label %polly.loop_exit235

polly.loop_exit235:                               ; preds = %polly.loop_header233, %polly.loop_exit221
  %polly.indvar_next215 = add nsw i64 %polly.indvar214, 1
  %polly.adjust_ub216 = sub i64 %36, 1
  %polly.loop_cond217 = icmp sle i64 %polly.indvar214, %polly.adjust_ub216
  br i1 %polly.loop_cond217, label %polly.loop_header210, label %polly.cond247

polly.loop_header219:                             ; preds = %polly.loop_header210, %polly.loop_header219
  %polly.indvar223 = phi i64 [ %polly.indvar_next224, %polly.loop_header219 ], [ 0, %polly.loop_header210 ]
  %p_scevgep24229 = getelementptr [1200 x double]* %D, i64 %polly.indvar214, i64 %polly.indvar223
  %_p_scalar_230 = load double* %p_scevgep24229
  %p_231 = fmul double %_p_scalar_230, %beta
  store double %p_231, double* %p_scevgep24229
  %polly.indvar_next224 = add nsw i64 %polly.indvar223, 1
  %polly.adjust_ub225 = sub i64 %37, 1
  %polly.loop_cond226 = icmp sle i64 %polly.indvar223, %polly.adjust_ub225
  br i1 %polly.loop_cond226, label %polly.loop_header219, label %polly.loop_exit221

polly.loop_header233:                             ; preds = %polly.loop_exit221, %polly.loop_header233
  %polly.indvar237 = phi i64 [ %polly.indvar_next238, %polly.loop_header233 ], [ 0, %polly.loop_exit221 ]
  %p_scevgep24.moved.to..lr.ph242 = getelementptr [1200 x double]* %D, i64 %polly.indvar214, i64 %polly.indvar237
  %.promoted_p_scalar_243 = load double* %p_scevgep24.moved.to..lr.ph242
  store double %.promoted_p_scalar_243, double* %p_scevgep24.moved.to..lr.ph242
  %polly.indvar_next238 = add nsw i64 %polly.indvar237, 1
  %polly.adjust_ub239 = sub i64 %37, 1
  %polly.loop_cond240 = icmp sle i64 %polly.indvar237, %polly.adjust_ub239
  br i1 %polly.loop_cond240, label %polly.loop_header233, label %polly.loop_exit235

polly.then249:                                    ; preds = %polly.cond247
  %38 = add i64 %0, -1
  %polly.loop_guard254 = icmp sle i64 0, %38
  br i1 %polly.loop_guard254, label %polly.loop_header251, label %polly.merge

polly.loop_header251:                             ; preds = %polly.then249, %polly.loop_exit262
  %polly.indvar255 = phi i64 [ %polly.indvar_next256, %polly.loop_exit262 ], [ 0, %polly.then249 ]
  %39 = add i64 %3, -1
  %polly.loop_guard263 = icmp sle i64 0, %39
  br i1 %polly.loop_guard263, label %polly.loop_header260, label %polly.loop_exit262

polly.loop_exit262:                               ; preds = %polly.loop_header260, %polly.loop_header251
  %polly.indvar_next256 = add nsw i64 %polly.indvar255, 1
  %polly.adjust_ub257 = sub i64 %38, 1
  %polly.loop_cond258 = icmp sle i64 %polly.indvar255, %polly.adjust_ub257
  br i1 %polly.loop_cond258, label %polly.loop_header251, label %polly.merge

polly.loop_header260:                             ; preds = %polly.loop_header251, %polly.loop_header260
  %polly.indvar264 = phi i64 [ %polly.indvar_next265, %polly.loop_header260 ], [ 0, %polly.loop_header251 ]
  %p_scevgep24270 = getelementptr [1200 x double]* %D, i64 %polly.indvar255, i64 %polly.indvar264
  %_p_scalar_271 = load double* %p_scevgep24270
  %p_272 = fmul double %_p_scalar_271, %beta
  store double %p_272, double* %p_scevgep24270
  %polly.indvar_next265 = add nsw i64 %polly.indvar264, 1
  %polly.adjust_ub266 = sub i64 %39, 1
  %polly.loop_cond267 = icmp sle i64 %polly.indvar264, %polly.adjust_ub266
  br i1 %polly.loop_cond267, label %polly.loop_header260, label %polly.loop_exit262
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %ni, i32 %nl, [1200 x double]* noalias %D) #0 {
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
