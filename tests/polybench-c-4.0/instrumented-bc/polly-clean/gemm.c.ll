; ModuleID = './linear-algebra/blas/gemm/gemm.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [2 x i8] c"C\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %alpha = alloca double, align 8
  %beta = alloca double, align 8
  %0 = tail call i8* @polybench_alloc_data(i64 1100000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 1200000, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 1320000, i32 8) #3
  %3 = bitcast i8* %0 to [1100 x double]*
  %4 = bitcast i8* %1 to [1200 x double]*
  %5 = bitcast i8* %2 to [1100 x double]*
  call void @init_array(i32 1000, i32 1100, i32 1200, double* %alpha, double* %beta, [1100 x double]* %3, [1200 x double]* %4, [1100 x double]* %5)
  call void (...)* @polybench_timer_start() #3
  %6 = load double* %alpha, align 8, !tbaa !1
  %7 = load double* %beta, align 8, !tbaa !1
  call void @kernel_gemm(i32 1000, i32 1100, i32 1200, double %6, double %7, [1100 x double]* %3, [1200 x double]* %4, [1100 x double]* %5)
  call void (...)* @polybench_timer_stop() #3
  call void (...)* @polybench_timer_print() #3
  %8 = icmp sgt i32 %argc, 42
  br i1 %8, label %9, label %13

; <label>:9                                       ; preds = %.split
  %10 = load i8** %argv, align 8, !tbaa !5
  %11 = load i8* %10, align 1, !tbaa !7
  %phitmp = icmp eq i8 %11, 0
  br i1 %phitmp, label %12, label %13

; <label>:12                                      ; preds = %9
  call void @print_array(i32 1000, i32 1100, [1100 x double]* %3)
  br label %13

; <label>:13                                      ; preds = %9, %12, %.split
  call void @free(i8* %0) #3
  call void @free(i8* %1) #3
  call void @free(i8* %2) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %ni, i32 %nj, i32 %nk, double* %alpha, double* %beta, [1100 x double]* %C, [1200 x double]* %A, [1100 x double]* %B) #0 {
.split:
  store double 1.500000e+00, double* %alpha, align 8, !tbaa !1
  store double 1.200000e+00, double* %beta, align 8, !tbaa !1
  %0 = icmp sgt i32 %ni, 0
  br i1 %0, label %.preheader4.lr.ph, label %polly.start78

.preheader4.lr.ph:                                ; preds = %.split
  %1 = zext i32 %nj to i64
  %2 = sitofp i32 %ni to double
  %3 = zext i32 %ni to i64
  %4 = sext i32 %nj to i64
  %5 = icmp sge i64 %4, 1
  %6 = icmp sge i64 %3, 1
  %7 = and i1 %5, %6
  %8 = icmp sge i64 %1, 1
  %9 = and i1 %7, %8
  br i1 %9, label %polly.then131, label %polly.start78

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit48, %polly.merge81
  ret void

polly.then:                                       ; preds = %polly.merge81
  %10 = add i64 %69, -1
  %polly.loop_guard = icmp sle i64 0, %10
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit48
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit48 ], [ 0, %polly.then ]
  %11 = mul i64 -3, %69
  %12 = add i64 %11, %79
  %13 = add i64 %12, 5
  %14 = sub i64 %13, 32
  %15 = add i64 %14, 1
  %16 = icmp slt i64 %13, 0
  %17 = select i1 %16, i64 %15, i64 %13
  %18 = sdiv i64 %17, 32
  %19 = mul i64 -32, %18
  %20 = mul i64 -32, %69
  %21 = add i64 %19, %20
  %22 = mul i64 -32, %polly.indvar
  %23 = mul i64 -3, %polly.indvar
  %24 = add i64 %23, %79
  %25 = add i64 %24, 5
  %26 = sub i64 %25, 32
  %27 = add i64 %26, 1
  %28 = icmp slt i64 %25, 0
  %29 = select i1 %28, i64 %27, i64 %25
  %30 = sdiv i64 %29, 32
  %31 = mul i64 -32, %30
  %32 = add i64 %22, %31
  %33 = add i64 %32, -640
  %34 = icmp sgt i64 %21, %33
  %35 = select i1 %34, i64 %21, i64 %33
  %36 = mul i64 -20, %polly.indvar
  %polly.loop_guard49 = icmp sle i64 %35, %36
  br i1 %polly.loop_guard49, label %polly.loop_header46, label %polly.loop_exit48

polly.loop_exit48:                                ; preds = %polly.loop_exit57, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %10, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header46:                              ; preds = %polly.loop_header, %polly.loop_exit57
  %polly.indvar50 = phi i64 [ %polly.indvar_next51, %polly.loop_exit57 ], [ %35, %polly.loop_header ]
  %37 = mul i64 -1, %polly.indvar50
  %38 = mul i64 -1, %79
  %39 = add i64 %37, %38
  %40 = add i64 %39, -30
  %41 = add i64 %40, 20
  %42 = sub i64 %41, 1
  %43 = icmp slt i64 %40, 0
  %44 = select i1 %43, i64 %40, i64 %42
  %45 = sdiv i64 %44, 20
  %46 = icmp sgt i64 %45, %polly.indvar
  %47 = select i1 %46, i64 %45, i64 %polly.indvar
  %48 = sub i64 %37, 20
  %49 = add i64 %48, 1
  %50 = icmp slt i64 %37, 0
  %51 = select i1 %50, i64 %49, i64 %37
  %52 = sdiv i64 %51, 20
  %53 = add i64 %polly.indvar, 31
  %54 = icmp slt i64 %52, %53
  %55 = select i1 %54, i64 %52, i64 %53
  %56 = icmp slt i64 %55, %10
  %57 = select i1 %56, i64 %55, i64 %10
  %polly.loop_guard58 = icmp sle i64 %47, %57
  br i1 %polly.loop_guard58, label %polly.loop_header55, label %polly.loop_exit57

polly.loop_exit57:                                ; preds = %polly.loop_exit66, %polly.loop_header46
  %polly.indvar_next51 = add nsw i64 %polly.indvar50, 32
  %polly.adjust_ub52 = sub i64 %36, 32
  %polly.loop_cond53 = icmp sle i64 %polly.indvar50, %polly.adjust_ub52
  br i1 %polly.loop_cond53, label %polly.loop_header46, label %polly.loop_exit48

polly.loop_header55:                              ; preds = %polly.loop_header46, %polly.loop_exit66
  %polly.indvar59 = phi i64 [ %polly.indvar_next60, %polly.loop_exit66 ], [ %47, %polly.loop_header46 ]
  %58 = mul i64 -20, %polly.indvar59
  %59 = add i64 %58, %38
  %60 = add i64 %59, 1
  %61 = icmp sgt i64 %polly.indvar50, %60
  %62 = select i1 %61, i64 %polly.indvar50, i64 %60
  %63 = add i64 %polly.indvar50, 31
  %64 = icmp slt i64 %58, %63
  %65 = select i1 %64, i64 %58, i64 %63
  %polly.loop_guard67 = icmp sle i64 %62, %65
  br i1 %polly.loop_guard67, label %polly.loop_header64, label %polly.loop_exit66

polly.loop_exit66:                                ; preds = %polly.loop_header64, %polly.loop_header55
  %polly.indvar_next60 = add nsw i64 %polly.indvar59, 1
  %polly.adjust_ub61 = sub i64 %57, 1
  %polly.loop_cond62 = icmp sle i64 %polly.indvar59, %polly.adjust_ub61
  br i1 %polly.loop_cond62, label %polly.loop_header55, label %polly.loop_exit57

polly.loop_header64:                              ; preds = %polly.loop_header55, %polly.loop_header64
  %polly.indvar68 = phi i64 [ %polly.indvar_next69, %polly.loop_header64 ], [ %62, %polly.loop_header55 ]
  %66 = mul i64 -1, %polly.indvar68
  %67 = add i64 %58, %66
  %p_.moved.to. = mul i64 %polly.indvar59, 2
  %p_.moved.to.39 = sitofp i32 %nj to double
  %p_scevgep = getelementptr [1100 x double]* %B, i64 %polly.indvar59, i64 %67
  %p_ = mul i64 %polly.indvar59, %67
  %p_72 = add i64 %p_.moved.to., %p_
  %p_73 = trunc i64 %p_72 to i32
  %p_74 = srem i32 %p_73, %nj
  %p_75 = sitofp i32 %p_74 to double
  %p_76 = fdiv double %p_75, %p_.moved.to.39
  store double %p_76, double* %p_scevgep
  %p_indvar.next = add i64 %67, 1
  %polly.indvar_next69 = add nsw i64 %polly.indvar68, 1
  %polly.adjust_ub70 = sub i64 %65, 1
  %polly.loop_cond71 = icmp sle i64 %polly.indvar68, %polly.adjust_ub70
  br i1 %polly.loop_cond71, label %polly.loop_header64, label %polly.loop_exit66

polly.start78:                                    ; preds = %polly.then131, %polly.loop_exit144, %.preheader4.lr.ph, %.split
  %68 = zext i32 %ni to i64
  %69 = zext i32 %nk to i64
  %70 = sext i32 %ni to i64
  %71 = icmp sge i64 %70, 1
  %72 = sext i32 %nk to i64
  %73 = icmp sge i64 %72, 1
  %74 = and i1 %71, %73
  %75 = icmp sge i64 %68, 1
  %76 = and i1 %74, %75
  %77 = icmp sge i64 %69, 1
  %78 = and i1 %76, %77
  br i1 %78, label %polly.then82, label %polly.merge81

polly.merge81:                                    ; preds = %polly.then82, %polly.loop_exit95, %polly.start78
  %79 = zext i32 %nj to i64
  %80 = sext i32 %nj to i64
  %81 = icmp sge i64 %80, 1
  %82 = and i1 %81, %73
  %83 = and i1 %82, %77
  %84 = icmp sge i64 %79, 1
  %85 = and i1 %83, %84
  br i1 %85, label %polly.then, label %polly.merge

polly.then82:                                     ; preds = %polly.start78
  %86 = add i64 %68, -1
  %polly.loop_guard87 = icmp sle i64 0, %86
  br i1 %polly.loop_guard87, label %polly.loop_header84, label %polly.merge81

polly.loop_header84:                              ; preds = %polly.then82, %polly.loop_exit95
  %polly.indvar88 = phi i64 [ %polly.indvar_next89, %polly.loop_exit95 ], [ 0, %polly.then82 ]
  %87 = mul i64 -3, %68
  %88 = add i64 %87, %69
  %89 = add i64 %88, 5
  %90 = sub i64 %89, 32
  %91 = add i64 %90, 1
  %92 = icmp slt i64 %89, 0
  %93 = select i1 %92, i64 %91, i64 %89
  %94 = sdiv i64 %93, 32
  %95 = mul i64 -32, %94
  %96 = mul i64 -32, %68
  %97 = add i64 %95, %96
  %98 = mul i64 -32, %polly.indvar88
  %99 = mul i64 -3, %polly.indvar88
  %100 = add i64 %99, %69
  %101 = add i64 %100, 5
  %102 = sub i64 %101, 32
  %103 = add i64 %102, 1
  %104 = icmp slt i64 %101, 0
  %105 = select i1 %104, i64 %103, i64 %101
  %106 = sdiv i64 %105, 32
  %107 = mul i64 -32, %106
  %108 = add i64 %98, %107
  %109 = add i64 %108, -640
  %110 = icmp sgt i64 %97, %109
  %111 = select i1 %110, i64 %97, i64 %109
  %112 = mul i64 -20, %polly.indvar88
  %polly.loop_guard96 = icmp sle i64 %111, %112
  br i1 %polly.loop_guard96, label %polly.loop_header93, label %polly.loop_exit95

polly.loop_exit95:                                ; preds = %polly.loop_exit104, %polly.loop_header84
  %polly.indvar_next89 = add nsw i64 %polly.indvar88, 32
  %polly.adjust_ub90 = sub i64 %86, 32
  %polly.loop_cond91 = icmp sle i64 %polly.indvar88, %polly.adjust_ub90
  br i1 %polly.loop_cond91, label %polly.loop_header84, label %polly.merge81

polly.loop_header93:                              ; preds = %polly.loop_header84, %polly.loop_exit104
  %polly.indvar97 = phi i64 [ %polly.indvar_next98, %polly.loop_exit104 ], [ %111, %polly.loop_header84 ]
  %113 = mul i64 -1, %polly.indvar97
  %114 = mul i64 -1, %69
  %115 = add i64 %113, %114
  %116 = add i64 %115, -30
  %117 = add i64 %116, 20
  %118 = sub i64 %117, 1
  %119 = icmp slt i64 %116, 0
  %120 = select i1 %119, i64 %116, i64 %118
  %121 = sdiv i64 %120, 20
  %122 = icmp sgt i64 %121, %polly.indvar88
  %123 = select i1 %122, i64 %121, i64 %polly.indvar88
  %124 = sub i64 %113, 20
  %125 = add i64 %124, 1
  %126 = icmp slt i64 %113, 0
  %127 = select i1 %126, i64 %125, i64 %113
  %128 = sdiv i64 %127, 20
  %129 = add i64 %polly.indvar88, 31
  %130 = icmp slt i64 %128, %129
  %131 = select i1 %130, i64 %128, i64 %129
  %132 = icmp slt i64 %131, %86
  %133 = select i1 %132, i64 %131, i64 %86
  %polly.loop_guard105 = icmp sle i64 %123, %133
  br i1 %polly.loop_guard105, label %polly.loop_header102, label %polly.loop_exit104

polly.loop_exit104:                               ; preds = %polly.loop_exit113, %polly.loop_header93
  %polly.indvar_next98 = add nsw i64 %polly.indvar97, 32
  %polly.adjust_ub99 = sub i64 %112, 32
  %polly.loop_cond100 = icmp sle i64 %polly.indvar97, %polly.adjust_ub99
  br i1 %polly.loop_cond100, label %polly.loop_header93, label %polly.loop_exit95

polly.loop_header102:                             ; preds = %polly.loop_header93, %polly.loop_exit113
  %polly.indvar106 = phi i64 [ %polly.indvar_next107, %polly.loop_exit113 ], [ %123, %polly.loop_header93 ]
  %134 = mul i64 -20, %polly.indvar106
  %135 = add i64 %134, %114
  %136 = add i64 %135, 1
  %137 = icmp sgt i64 %polly.indvar97, %136
  %138 = select i1 %137, i64 %polly.indvar97, i64 %136
  %139 = add i64 %polly.indvar97, 31
  %140 = icmp slt i64 %134, %139
  %141 = select i1 %140, i64 %134, i64 %139
  %polly.loop_guard114 = icmp sle i64 %138, %141
  br i1 %polly.loop_guard114, label %polly.loop_header111, label %polly.loop_exit113

polly.loop_exit113:                               ; preds = %polly.loop_header111, %polly.loop_header102
  %polly.indvar_next107 = add nsw i64 %polly.indvar106, 1
  %polly.adjust_ub108 = sub i64 %133, 1
  %polly.loop_cond109 = icmp sle i64 %polly.indvar106, %polly.adjust_ub108
  br i1 %polly.loop_cond109, label %polly.loop_header102, label %polly.loop_exit104

polly.loop_header111:                             ; preds = %polly.loop_header102, %polly.loop_header111
  %polly.indvar115 = phi i64 [ %polly.indvar_next116, %polly.loop_header111 ], [ %138, %polly.loop_header102 ]
  %142 = mul i64 -1, %polly.indvar115
  %143 = add i64 %134, %142
  %p_.moved.to.42 = sitofp i32 %nk to double
  %p_scevgep28 = getelementptr [1200 x double]* %A, i64 %polly.indvar106, i64 %143
  %p_120 = mul i64 %polly.indvar106, %143
  %p_121 = add i64 %polly.indvar106, %p_120
  %p_122 = trunc i64 %p_121 to i32
  %p_123 = srem i32 %p_122, %nk
  %p_124 = sitofp i32 %p_123 to double
  %p_125 = fdiv double %p_124, %p_.moved.to.42
  store double %p_125, double* %p_scevgep28
  %p_indvar.next24 = add i64 %143, 1
  %polly.indvar_next116 = add nsw i64 %polly.indvar115, 1
  %polly.adjust_ub117 = sub i64 %141, 1
  %polly.loop_cond118 = icmp sle i64 %polly.indvar115, %polly.adjust_ub117
  br i1 %polly.loop_cond118, label %polly.loop_header111, label %polly.loop_exit113

polly.then131:                                    ; preds = %.preheader4.lr.ph
  %144 = add i64 %3, -1
  %polly.loop_guard136 = icmp sle i64 0, %144
  br i1 %polly.loop_guard136, label %polly.loop_header133, label %polly.start78

polly.loop_header133:                             ; preds = %polly.then131, %polly.loop_exit144
  %polly.indvar137 = phi i64 [ %polly.indvar_next138, %polly.loop_exit144 ], [ 0, %polly.then131 ]
  %145 = mul i64 -3, %3
  %146 = add i64 %145, %1
  %147 = add i64 %146, 5
  %148 = sub i64 %147, 32
  %149 = add i64 %148, 1
  %150 = icmp slt i64 %147, 0
  %151 = select i1 %150, i64 %149, i64 %147
  %152 = sdiv i64 %151, 32
  %153 = mul i64 -32, %152
  %154 = mul i64 -32, %3
  %155 = add i64 %153, %154
  %156 = mul i64 -32, %polly.indvar137
  %157 = mul i64 -3, %polly.indvar137
  %158 = add i64 %157, %1
  %159 = add i64 %158, 5
  %160 = sub i64 %159, 32
  %161 = add i64 %160, 1
  %162 = icmp slt i64 %159, 0
  %163 = select i1 %162, i64 %161, i64 %159
  %164 = sdiv i64 %163, 32
  %165 = mul i64 -32, %164
  %166 = add i64 %156, %165
  %167 = add i64 %166, -640
  %168 = icmp sgt i64 %155, %167
  %169 = select i1 %168, i64 %155, i64 %167
  %170 = mul i64 -20, %polly.indvar137
  %polly.loop_guard145 = icmp sle i64 %169, %170
  br i1 %polly.loop_guard145, label %polly.loop_header142, label %polly.loop_exit144

polly.loop_exit144:                               ; preds = %polly.loop_exit153, %polly.loop_header133
  %polly.indvar_next138 = add nsw i64 %polly.indvar137, 32
  %polly.adjust_ub139 = sub i64 %144, 32
  %polly.loop_cond140 = icmp sle i64 %polly.indvar137, %polly.adjust_ub139
  br i1 %polly.loop_cond140, label %polly.loop_header133, label %polly.start78

polly.loop_header142:                             ; preds = %polly.loop_header133, %polly.loop_exit153
  %polly.indvar146 = phi i64 [ %polly.indvar_next147, %polly.loop_exit153 ], [ %169, %polly.loop_header133 ]
  %171 = mul i64 -1, %polly.indvar146
  %172 = mul i64 -1, %1
  %173 = add i64 %171, %172
  %174 = add i64 %173, -30
  %175 = add i64 %174, 20
  %176 = sub i64 %175, 1
  %177 = icmp slt i64 %174, 0
  %178 = select i1 %177, i64 %174, i64 %176
  %179 = sdiv i64 %178, 20
  %180 = icmp sgt i64 %179, %polly.indvar137
  %181 = select i1 %180, i64 %179, i64 %polly.indvar137
  %182 = sub i64 %171, 20
  %183 = add i64 %182, 1
  %184 = icmp slt i64 %171, 0
  %185 = select i1 %184, i64 %183, i64 %171
  %186 = sdiv i64 %185, 20
  %187 = add i64 %polly.indvar137, 31
  %188 = icmp slt i64 %186, %187
  %189 = select i1 %188, i64 %186, i64 %187
  %190 = icmp slt i64 %189, %144
  %191 = select i1 %190, i64 %189, i64 %144
  %polly.loop_guard154 = icmp sle i64 %181, %191
  br i1 %polly.loop_guard154, label %polly.loop_header151, label %polly.loop_exit153

polly.loop_exit153:                               ; preds = %polly.loop_exit162, %polly.loop_header142
  %polly.indvar_next147 = add nsw i64 %polly.indvar146, 32
  %polly.adjust_ub148 = sub i64 %170, 32
  %polly.loop_cond149 = icmp sle i64 %polly.indvar146, %polly.adjust_ub148
  br i1 %polly.loop_cond149, label %polly.loop_header142, label %polly.loop_exit144

polly.loop_header151:                             ; preds = %polly.loop_header142, %polly.loop_exit162
  %polly.indvar155 = phi i64 [ %polly.indvar_next156, %polly.loop_exit162 ], [ %181, %polly.loop_header142 ]
  %192 = mul i64 -20, %polly.indvar155
  %193 = add i64 %192, %172
  %194 = add i64 %193, 1
  %195 = icmp sgt i64 %polly.indvar146, %194
  %196 = select i1 %195, i64 %polly.indvar146, i64 %194
  %197 = add i64 %polly.indvar146, 31
  %198 = icmp slt i64 %192, %197
  %199 = select i1 %198, i64 %192, i64 %197
  %polly.loop_guard163 = icmp sle i64 %196, %199
  br i1 %polly.loop_guard163, label %polly.loop_header160, label %polly.loop_exit162

polly.loop_exit162:                               ; preds = %polly.loop_header160, %polly.loop_header151
  %polly.indvar_next156 = add nsw i64 %polly.indvar155, 1
  %polly.adjust_ub157 = sub i64 %191, 1
  %polly.loop_cond158 = icmp sle i64 %polly.indvar155, %polly.adjust_ub157
  br i1 %polly.loop_cond158, label %polly.loop_header151, label %polly.loop_exit153

polly.loop_header160:                             ; preds = %polly.loop_header151, %polly.loop_header160
  %polly.indvar164 = phi i64 [ %polly.indvar_next165, %polly.loop_header160 ], [ %196, %polly.loop_header151 ]
  %200 = mul i64 -1, %polly.indvar164
  %201 = add i64 %192, %200
  %p_scevgep36 = getelementptr [1100 x double]* %C, i64 %polly.indvar155, i64 %201
  %p_169 = mul i64 %polly.indvar155, %201
  %p_170 = trunc i64 %p_169 to i32
  %p_171 = srem i32 %p_170, %ni
  %p_172 = sitofp i32 %p_171 to double
  %p_173 = fdiv double %p_172, %2
  store double %p_173, double* %p_scevgep36
  %p_indvar.next32 = add i64 %201, 1
  %polly.indvar_next165 = add nsw i64 %polly.indvar164, 1
  %polly.adjust_ub166 = sub i64 %199, 1
  %polly.loop_cond167 = icmp sle i64 %polly.indvar164, %polly.adjust_ub166
  br i1 %polly.loop_cond167, label %polly.loop_header160, label %polly.loop_exit162
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_gemm(i32 %ni, i32 %nj, i32 %nk, double %alpha, double %beta, [1100 x double]* %C, [1200 x double]* %A, [1100 x double]* %B) #0 {
.split:
  %0 = icmp sgt i32 %ni, 0
  br i1 %0, label %.preheader2.lr.ph, label %._crit_edge9

.preheader2.lr.ph:                                ; preds = %.split
  %1 = zext i32 %nj to i64
  %2 = zext i32 %nk to i64
  %3 = zext i32 %ni to i64
  %4 = icmp sgt i32 %nj, 0
  %5 = icmp sgt i32 %nk, 0
  br label %.preheader2

.preheader2:                                      ; preds = %.preheader2.lr.ph, %._crit_edge7
  %indvar10 = phi i64 [ 0, %.preheader2.lr.ph ], [ %indvar.next11, %._crit_edge7 ]
  %6 = mul i64 %indvar10, 8800
  br i1 %4, label %polly.cond, label %.preheader1

.preheader1:                                      ; preds = %polly.then28, %polly.loop_header, %polly.cond, %.preheader2
  br i1 %5, label %.preheader, label %._crit_edge7

.preheader:                                       ; preds = %.preheader1, %._crit_edge
  %indvar15 = phi i64 [ %indvar.next16, %._crit_edge ], [ 0, %.preheader1 ]
  %scevgep21 = getelementptr [1200 x double]* %A, i64 %indvar10, i64 %indvar15
  br i1 %4, label %.lr.ph5, label %._crit_edge

.lr.ph5:                                          ; preds = %.preheader, %.lr.ph5
  %indvar12 = phi i64 [ %indvar.next13, %.lr.ph5 ], [ 0, %.preheader ]
  %scevgep18 = getelementptr [1100 x double]* %C, i64 %indvar10, i64 %indvar12
  %scevgep17 = getelementptr [1100 x double]* %B, i64 %indvar15, i64 %indvar12
  %7 = load double* %scevgep21, align 8, !tbaa !1
  %8 = fmul double %7, %alpha
  %9 = load double* %scevgep17, align 8, !tbaa !1
  %10 = fmul double %8, %9
  %11 = load double* %scevgep18, align 8, !tbaa !1
  %12 = fadd double %11, %10
  store double %12, double* %scevgep18, align 8, !tbaa !1
  %indvar.next13 = add i64 %indvar12, 1
  %exitcond14 = icmp ne i64 %indvar.next13, %1
  br i1 %exitcond14, label %.lr.ph5, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph5, %.preheader
  %indvar.next16 = add i64 %indvar15, 1
  %exitcond19 = icmp ne i64 %indvar.next16, %2
  br i1 %exitcond19, label %.preheader, label %._crit_edge7

._crit_edge7:                                     ; preds = %._crit_edge, %.preheader1
  %indvar.next11 = add i64 %indvar10, 1
  %exitcond22 = icmp ne i64 %indvar.next11, %3
  br i1 %exitcond22, label %.preheader2, label %._crit_edge9

._crit_edge9:                                     ; preds = %._crit_edge7, %.split
  ret void

polly.cond:                                       ; preds = %.preheader2
  %13 = srem i64 %6, 8
  %14 = icmp eq i64 %13, 0
  %15 = icmp sge i64 %1, 1
  %or.cond = and i1 %14, %15
  br i1 %or.cond, label %polly.then28, label %.preheader1

polly.then28:                                     ; preds = %polly.cond
  %16 = add i64 %1, -1
  %polly.loop_guard = icmp sle i64 0, %16
  br i1 %polly.loop_guard, label %polly.loop_header, label %.preheader1

polly.loop_header:                                ; preds = %polly.then28, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then28 ]
  %p_scevgep = getelementptr [1100 x double]* %C, i64 %indvar10, i64 %polly.indvar
  %_p_scalar_ = load double* %p_scevgep
  %p_ = fmul double %_p_scalar_, %beta
  store double %p_, double* %p_scevgep
  %p_indvar.next = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %16, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %.preheader1
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %ni, i32 %nj, [1100 x double]* %C) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %ni, 0
  br i1 %5, label %.preheader.lr.ph, label %22

.preheader.lr.ph:                                 ; preds = %.split
  %6 = zext i32 %nj to i64
  %7 = zext i32 %ni to i64
  %8 = icmp sgt i32 %nj, 0
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
  %scevgep = getelementptr [1100 x double]* %C, i64 %indvar4, i64 %indvar
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
