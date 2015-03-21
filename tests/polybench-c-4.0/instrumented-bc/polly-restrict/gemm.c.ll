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
define internal void @init_array(i32 %ni, i32 %nj, i32 %nk, double* %alpha, double* %beta, [1100 x double]* noalias %C, [1200 x double]* noalias %A, [1100 x double]* noalias %B) #0 {
.split:
  store double 1.500000e+00, double* %alpha, align 8, !tbaa !1
  store double 1.200000e+00, double* %beta, align 8, !tbaa !1
  %0 = icmp sgt i32 %ni, 0
  br i1 %0, label %.preheader4.lr.ph, label %polly.start

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
  br i1 %9, label %polly.then131, label %polly.start

polly.start:                                      ; preds = %polly.then131, %polly.loop_exit144, %.preheader4.lr.ph, %.split
  %10 = zext i32 %ni to i64
  %11 = zext i32 %nk to i64
  %12 = zext i32 %nj to i64
  %13 = sext i32 %nk to i64
  %14 = icmp sge i64 %13, 1
  %15 = icmp sge i64 %11, 1
  %16 = and i1 %14, %15
  br i1 %16, label %polly.cond45, label %polly.merge

polly.merge:                                      ; preds = %polly.then82, %polly.loop_exit95, %polly.cond80, %polly.start
  ret void

polly.cond45:                                     ; preds = %polly.start
  %17 = sext i32 %nj to i64
  %18 = icmp sge i64 %17, 1
  %19 = icmp sge i64 %12, 1
  %20 = and i1 %18, %19
  br i1 %20, label %polly.then47, label %polly.cond80

polly.cond80:                                     ; preds = %polly.then47, %polly.loop_exit51, %polly.cond45
  %21 = sext i32 %ni to i64
  %22 = icmp sge i64 %21, 1
  %23 = icmp sge i64 %10, 1
  %24 = and i1 %22, %23
  br i1 %24, label %polly.then82, label %polly.merge

polly.then47:                                     ; preds = %polly.cond45
  %25 = add i64 %11, -1
  %polly.loop_guard = icmp sle i64 0, %25
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond80

polly.loop_header:                                ; preds = %polly.then47, %polly.loop_exit51
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit51 ], [ 0, %polly.then47 ]
  %26 = mul i64 -3, %11
  %27 = add i64 %26, %12
  %28 = add i64 %27, 5
  %29 = sub i64 %28, 32
  %30 = add i64 %29, 1
  %31 = icmp slt i64 %28, 0
  %32 = select i1 %31, i64 %30, i64 %28
  %33 = sdiv i64 %32, 32
  %34 = mul i64 -32, %33
  %35 = mul i64 -32, %11
  %36 = add i64 %34, %35
  %37 = mul i64 -32, %polly.indvar
  %38 = mul i64 -3, %polly.indvar
  %39 = add i64 %38, %12
  %40 = add i64 %39, 5
  %41 = sub i64 %40, 32
  %42 = add i64 %41, 1
  %43 = icmp slt i64 %40, 0
  %44 = select i1 %43, i64 %42, i64 %40
  %45 = sdiv i64 %44, 32
  %46 = mul i64 -32, %45
  %47 = add i64 %37, %46
  %48 = add i64 %47, -640
  %49 = icmp sgt i64 %36, %48
  %50 = select i1 %49, i64 %36, i64 %48
  %51 = mul i64 -20, %polly.indvar
  %polly.loop_guard52 = icmp sle i64 %50, %51
  br i1 %polly.loop_guard52, label %polly.loop_header49, label %polly.loop_exit51

polly.loop_exit51:                                ; preds = %polly.loop_exit60, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %25, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond80

polly.loop_header49:                              ; preds = %polly.loop_header, %polly.loop_exit60
  %polly.indvar53 = phi i64 [ %polly.indvar_next54, %polly.loop_exit60 ], [ %50, %polly.loop_header ]
  %52 = mul i64 -1, %polly.indvar53
  %53 = mul i64 -1, %12
  %54 = add i64 %52, %53
  %55 = add i64 %54, -30
  %56 = add i64 %55, 20
  %57 = sub i64 %56, 1
  %58 = icmp slt i64 %55, 0
  %59 = select i1 %58, i64 %55, i64 %57
  %60 = sdiv i64 %59, 20
  %61 = icmp sgt i64 %60, %polly.indvar
  %62 = select i1 %61, i64 %60, i64 %polly.indvar
  %63 = sub i64 %52, 20
  %64 = add i64 %63, 1
  %65 = icmp slt i64 %52, 0
  %66 = select i1 %65, i64 %64, i64 %52
  %67 = sdiv i64 %66, 20
  %68 = add i64 %polly.indvar, 31
  %69 = icmp slt i64 %67, %68
  %70 = select i1 %69, i64 %67, i64 %68
  %71 = icmp slt i64 %70, %25
  %72 = select i1 %71, i64 %70, i64 %25
  %polly.loop_guard61 = icmp sle i64 %62, %72
  br i1 %polly.loop_guard61, label %polly.loop_header58, label %polly.loop_exit60

polly.loop_exit60:                                ; preds = %polly.loop_exit69, %polly.loop_header49
  %polly.indvar_next54 = add nsw i64 %polly.indvar53, 32
  %polly.adjust_ub55 = sub i64 %51, 32
  %polly.loop_cond56 = icmp sle i64 %polly.indvar53, %polly.adjust_ub55
  br i1 %polly.loop_cond56, label %polly.loop_header49, label %polly.loop_exit51

polly.loop_header58:                              ; preds = %polly.loop_header49, %polly.loop_exit69
  %polly.indvar62 = phi i64 [ %polly.indvar_next63, %polly.loop_exit69 ], [ %62, %polly.loop_header49 ]
  %73 = mul i64 -20, %polly.indvar62
  %74 = add i64 %73, %53
  %75 = add i64 %74, 1
  %76 = icmp sgt i64 %polly.indvar53, %75
  %77 = select i1 %76, i64 %polly.indvar53, i64 %75
  %78 = add i64 %polly.indvar53, 31
  %79 = icmp slt i64 %73, %78
  %80 = select i1 %79, i64 %73, i64 %78
  %polly.loop_guard70 = icmp sle i64 %77, %80
  br i1 %polly.loop_guard70, label %polly.loop_header67, label %polly.loop_exit69

polly.loop_exit69:                                ; preds = %polly.loop_header67, %polly.loop_header58
  %polly.indvar_next63 = add nsw i64 %polly.indvar62, 1
  %polly.adjust_ub64 = sub i64 %72, 1
  %polly.loop_cond65 = icmp sle i64 %polly.indvar62, %polly.adjust_ub64
  br i1 %polly.loop_cond65, label %polly.loop_header58, label %polly.loop_exit60

polly.loop_header67:                              ; preds = %polly.loop_header58, %polly.loop_header67
  %polly.indvar71 = phi i64 [ %polly.indvar_next72, %polly.loop_header67 ], [ %77, %polly.loop_header58 ]
  %81 = mul i64 -1, %polly.indvar71
  %82 = add i64 %73, %81
  %p_.moved.to.41 = mul i64 %polly.indvar62, 2
  %p_.moved.to.42 = sitofp i32 %nj to double
  %p_scevgep = getelementptr [1100 x double]* %B, i64 %polly.indvar62, i64 %82
  %p_ = mul i64 %polly.indvar62, %82
  %p_75 = add i64 %p_.moved.to.41, %p_
  %p_76 = trunc i64 %p_75 to i32
  %p_77 = srem i32 %p_76, %nj
  %p_78 = sitofp i32 %p_77 to double
  %p_79 = fdiv double %p_78, %p_.moved.to.42
  store double %p_79, double* %p_scevgep
  %p_indvar.next = add i64 %82, 1
  %polly.indvar_next72 = add nsw i64 %polly.indvar71, 1
  %polly.adjust_ub73 = sub i64 %80, 1
  %polly.loop_cond74 = icmp sle i64 %polly.indvar71, %polly.adjust_ub73
  br i1 %polly.loop_cond74, label %polly.loop_header67, label %polly.loop_exit69

polly.then82:                                     ; preds = %polly.cond80
  %83 = add i64 %10, -1
  %polly.loop_guard87 = icmp sle i64 0, %83
  br i1 %polly.loop_guard87, label %polly.loop_header84, label %polly.merge

polly.loop_header84:                              ; preds = %polly.then82, %polly.loop_exit95
  %polly.indvar88 = phi i64 [ %polly.indvar_next89, %polly.loop_exit95 ], [ 0, %polly.then82 ]
  %84 = mul i64 -3, %10
  %85 = add i64 %84, %11
  %86 = add i64 %85, 5
  %87 = sub i64 %86, 32
  %88 = add i64 %87, 1
  %89 = icmp slt i64 %86, 0
  %90 = select i1 %89, i64 %88, i64 %86
  %91 = sdiv i64 %90, 32
  %92 = mul i64 -32, %91
  %93 = mul i64 -32, %10
  %94 = add i64 %92, %93
  %95 = mul i64 -32, %polly.indvar88
  %96 = mul i64 -3, %polly.indvar88
  %97 = add i64 %96, %11
  %98 = add i64 %97, 5
  %99 = sub i64 %98, 32
  %100 = add i64 %99, 1
  %101 = icmp slt i64 %98, 0
  %102 = select i1 %101, i64 %100, i64 %98
  %103 = sdiv i64 %102, 32
  %104 = mul i64 -32, %103
  %105 = add i64 %95, %104
  %106 = add i64 %105, -640
  %107 = icmp sgt i64 %94, %106
  %108 = select i1 %107, i64 %94, i64 %106
  %109 = mul i64 -20, %polly.indvar88
  %polly.loop_guard96 = icmp sle i64 %108, %109
  br i1 %polly.loop_guard96, label %polly.loop_header93, label %polly.loop_exit95

polly.loop_exit95:                                ; preds = %polly.loop_exit104, %polly.loop_header84
  %polly.indvar_next89 = add nsw i64 %polly.indvar88, 32
  %polly.adjust_ub90 = sub i64 %83, 32
  %polly.loop_cond91 = icmp sle i64 %polly.indvar88, %polly.adjust_ub90
  br i1 %polly.loop_cond91, label %polly.loop_header84, label %polly.merge

polly.loop_header93:                              ; preds = %polly.loop_header84, %polly.loop_exit104
  %polly.indvar97 = phi i64 [ %polly.indvar_next98, %polly.loop_exit104 ], [ %108, %polly.loop_header84 ]
  %110 = mul i64 -1, %polly.indvar97
  %111 = mul i64 -1, %11
  %112 = add i64 %110, %111
  %113 = add i64 %112, -30
  %114 = add i64 %113, 20
  %115 = sub i64 %114, 1
  %116 = icmp slt i64 %113, 0
  %117 = select i1 %116, i64 %113, i64 %115
  %118 = sdiv i64 %117, 20
  %119 = icmp sgt i64 %118, %polly.indvar88
  %120 = select i1 %119, i64 %118, i64 %polly.indvar88
  %121 = sub i64 %110, 20
  %122 = add i64 %121, 1
  %123 = icmp slt i64 %110, 0
  %124 = select i1 %123, i64 %122, i64 %110
  %125 = sdiv i64 %124, 20
  %126 = add i64 %polly.indvar88, 31
  %127 = icmp slt i64 %125, %126
  %128 = select i1 %127, i64 %125, i64 %126
  %129 = icmp slt i64 %128, %83
  %130 = select i1 %129, i64 %128, i64 %83
  %polly.loop_guard105 = icmp sle i64 %120, %130
  br i1 %polly.loop_guard105, label %polly.loop_header102, label %polly.loop_exit104

polly.loop_exit104:                               ; preds = %polly.loop_exit113, %polly.loop_header93
  %polly.indvar_next98 = add nsw i64 %polly.indvar97, 32
  %polly.adjust_ub99 = sub i64 %109, 32
  %polly.loop_cond100 = icmp sle i64 %polly.indvar97, %polly.adjust_ub99
  br i1 %polly.loop_cond100, label %polly.loop_header93, label %polly.loop_exit95

polly.loop_header102:                             ; preds = %polly.loop_header93, %polly.loop_exit113
  %polly.indvar106 = phi i64 [ %polly.indvar_next107, %polly.loop_exit113 ], [ %120, %polly.loop_header93 ]
  %131 = mul i64 -20, %polly.indvar106
  %132 = add i64 %131, %111
  %133 = add i64 %132, 1
  %134 = icmp sgt i64 %polly.indvar97, %133
  %135 = select i1 %134, i64 %polly.indvar97, i64 %133
  %136 = add i64 %polly.indvar97, 31
  %137 = icmp slt i64 %131, %136
  %138 = select i1 %137, i64 %131, i64 %136
  %polly.loop_guard114 = icmp sle i64 %135, %138
  br i1 %polly.loop_guard114, label %polly.loop_header111, label %polly.loop_exit113

polly.loop_exit113:                               ; preds = %polly.loop_header111, %polly.loop_header102
  %polly.indvar_next107 = add nsw i64 %polly.indvar106, 1
  %polly.adjust_ub108 = sub i64 %130, 1
  %polly.loop_cond109 = icmp sle i64 %polly.indvar106, %polly.adjust_ub108
  br i1 %polly.loop_cond109, label %polly.loop_header102, label %polly.loop_exit104

polly.loop_header111:                             ; preds = %polly.loop_header102, %polly.loop_header111
  %polly.indvar115 = phi i64 [ %polly.indvar_next116, %polly.loop_header111 ], [ %135, %polly.loop_header102 ]
  %139 = mul i64 -1, %polly.indvar115
  %140 = add i64 %131, %139
  %p_.moved.to. = sitofp i32 %nk to double
  %p_scevgep28 = getelementptr [1200 x double]* %A, i64 %polly.indvar106, i64 %140
  %p_120 = mul i64 %polly.indvar106, %140
  %p_121 = add i64 %polly.indvar106, %p_120
  %p_122 = trunc i64 %p_121 to i32
  %p_123 = srem i32 %p_122, %nk
  %p_124 = sitofp i32 %p_123 to double
  %p_125 = fdiv double %p_124, %p_.moved.to.
  store double %p_125, double* %p_scevgep28
  %p_indvar.next24 = add i64 %140, 1
  %polly.indvar_next116 = add nsw i64 %polly.indvar115, 1
  %polly.adjust_ub117 = sub i64 %138, 1
  %polly.loop_cond118 = icmp sle i64 %polly.indvar115, %polly.adjust_ub117
  br i1 %polly.loop_cond118, label %polly.loop_header111, label %polly.loop_exit113

polly.then131:                                    ; preds = %.preheader4.lr.ph
  %141 = add i64 %3, -1
  %polly.loop_guard136 = icmp sle i64 0, %141
  br i1 %polly.loop_guard136, label %polly.loop_header133, label %polly.start

polly.loop_header133:                             ; preds = %polly.then131, %polly.loop_exit144
  %polly.indvar137 = phi i64 [ %polly.indvar_next138, %polly.loop_exit144 ], [ 0, %polly.then131 ]
  %142 = mul i64 -3, %3
  %143 = add i64 %142, %1
  %144 = add i64 %143, 5
  %145 = sub i64 %144, 32
  %146 = add i64 %145, 1
  %147 = icmp slt i64 %144, 0
  %148 = select i1 %147, i64 %146, i64 %144
  %149 = sdiv i64 %148, 32
  %150 = mul i64 -32, %149
  %151 = mul i64 -32, %3
  %152 = add i64 %150, %151
  %153 = mul i64 -32, %polly.indvar137
  %154 = mul i64 -3, %polly.indvar137
  %155 = add i64 %154, %1
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
  %167 = mul i64 -20, %polly.indvar137
  %polly.loop_guard145 = icmp sle i64 %166, %167
  br i1 %polly.loop_guard145, label %polly.loop_header142, label %polly.loop_exit144

polly.loop_exit144:                               ; preds = %polly.loop_exit153, %polly.loop_header133
  %polly.indvar_next138 = add nsw i64 %polly.indvar137, 32
  %polly.adjust_ub139 = sub i64 %141, 32
  %polly.loop_cond140 = icmp sle i64 %polly.indvar137, %polly.adjust_ub139
  br i1 %polly.loop_cond140, label %polly.loop_header133, label %polly.start

polly.loop_header142:                             ; preds = %polly.loop_header133, %polly.loop_exit153
  %polly.indvar146 = phi i64 [ %polly.indvar_next147, %polly.loop_exit153 ], [ %166, %polly.loop_header133 ]
  %168 = mul i64 -1, %polly.indvar146
  %169 = mul i64 -1, %1
  %170 = add i64 %168, %169
  %171 = add i64 %170, -30
  %172 = add i64 %171, 20
  %173 = sub i64 %172, 1
  %174 = icmp slt i64 %171, 0
  %175 = select i1 %174, i64 %171, i64 %173
  %176 = sdiv i64 %175, 20
  %177 = icmp sgt i64 %176, %polly.indvar137
  %178 = select i1 %177, i64 %176, i64 %polly.indvar137
  %179 = sub i64 %168, 20
  %180 = add i64 %179, 1
  %181 = icmp slt i64 %168, 0
  %182 = select i1 %181, i64 %180, i64 %168
  %183 = sdiv i64 %182, 20
  %184 = add i64 %polly.indvar137, 31
  %185 = icmp slt i64 %183, %184
  %186 = select i1 %185, i64 %183, i64 %184
  %187 = icmp slt i64 %186, %141
  %188 = select i1 %187, i64 %186, i64 %141
  %polly.loop_guard154 = icmp sle i64 %178, %188
  br i1 %polly.loop_guard154, label %polly.loop_header151, label %polly.loop_exit153

polly.loop_exit153:                               ; preds = %polly.loop_exit162, %polly.loop_header142
  %polly.indvar_next147 = add nsw i64 %polly.indvar146, 32
  %polly.adjust_ub148 = sub i64 %167, 32
  %polly.loop_cond149 = icmp sle i64 %polly.indvar146, %polly.adjust_ub148
  br i1 %polly.loop_cond149, label %polly.loop_header142, label %polly.loop_exit144

polly.loop_header151:                             ; preds = %polly.loop_header142, %polly.loop_exit162
  %polly.indvar155 = phi i64 [ %polly.indvar_next156, %polly.loop_exit162 ], [ %178, %polly.loop_header142 ]
  %189 = mul i64 -20, %polly.indvar155
  %190 = add i64 %189, %169
  %191 = add i64 %190, 1
  %192 = icmp sgt i64 %polly.indvar146, %191
  %193 = select i1 %192, i64 %polly.indvar146, i64 %191
  %194 = add i64 %polly.indvar146, 31
  %195 = icmp slt i64 %189, %194
  %196 = select i1 %195, i64 %189, i64 %194
  %polly.loop_guard163 = icmp sle i64 %193, %196
  br i1 %polly.loop_guard163, label %polly.loop_header160, label %polly.loop_exit162

polly.loop_exit162:                               ; preds = %polly.loop_header160, %polly.loop_header151
  %polly.indvar_next156 = add nsw i64 %polly.indvar155, 1
  %polly.adjust_ub157 = sub i64 %188, 1
  %polly.loop_cond158 = icmp sle i64 %polly.indvar155, %polly.adjust_ub157
  br i1 %polly.loop_cond158, label %polly.loop_header151, label %polly.loop_exit153

polly.loop_header160:                             ; preds = %polly.loop_header151, %polly.loop_header160
  %polly.indvar164 = phi i64 [ %polly.indvar_next165, %polly.loop_header160 ], [ %193, %polly.loop_header151 ]
  %197 = mul i64 -1, %polly.indvar164
  %198 = add i64 %189, %197
  %p_scevgep36 = getelementptr [1100 x double]* %C, i64 %polly.indvar155, i64 %198
  %p_169 = mul i64 %polly.indvar155, %198
  %p_170 = trunc i64 %p_169 to i32
  %p_171 = srem i32 %p_170, %ni
  %p_172 = sitofp i32 %p_171 to double
  %p_173 = fdiv double %p_172, %2
  store double %p_173, double* %p_scevgep36
  %p_indvar.next32 = add i64 %198, 1
  %polly.indvar_next165 = add nsw i64 %polly.indvar164, 1
  %polly.adjust_ub166 = sub i64 %196, 1
  %polly.loop_cond167 = icmp sle i64 %polly.indvar164, %polly.adjust_ub166
  br i1 %polly.loop_cond167, label %polly.loop_header160, label %polly.loop_exit162
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_gemm(i32 %ni, i32 %nj, i32 %nk, double %alpha, double %beta, [1100 x double]* noalias %C, [1200 x double]* noalias %A, [1100 x double]* noalias %B) #0 {
polly.split_new_and_old:
  %0 = zext i32 %ni to i64
  %1 = zext i32 %nj to i64
  %2 = zext i32 %nk to i64
  %3 = sext i32 %ni to i64
  %4 = icmp sge i64 %3, 1
  %5 = sext i32 %nj to i64
  %6 = icmp sge i64 %5, 1
  %7 = and i1 %4, %6
  %8 = icmp sge i64 %0, 1
  %9 = and i1 %7, %8
  br i1 %9, label %polly.cond30, label %polly.merge

polly.merge:                                      ; preds = %polly.then124, %polly.loop_exit137, %polly.cond122, %polly.split_new_and_old
  ret void

polly.cond30:                                     ; preds = %polly.split_new_and_old
  %10 = sext i32 %nk to i64
  %11 = icmp sge i64 %10, 1
  %12 = icmp sge i64 %1, 1
  %13 = and i1 %11, %12
  %14 = icmp sge i64 %2, 1
  %15 = and i1 %13, %14
  br i1 %15, label %polly.then32, label %polly.cond66

polly.cond66:                                     ; preds = %polly.then32, %polly.loop_exit45, %polly.cond30
  %16 = icmp sle i64 %10, 0
  %17 = and i1 %16, %12
  %18 = and i1 %17, %14
  br i1 %18, label %polly.then68, label %polly.cond94

polly.cond94:                                     ; preds = %polly.then68, %polly.loop_exit81, %polly.cond66
  %19 = icmp sle i64 %2, 0
  %20 = and i1 %12, %19
  br i1 %20, label %polly.then96, label %polly.cond122

polly.cond122:                                    ; preds = %polly.then96, %polly.loop_exit109, %polly.cond94
  %21 = icmp sle i64 %1, 0
  %22 = and i1 %11, %21
  %23 = and i1 %22, %14
  br i1 %23, label %polly.then124, label %polly.merge

polly.then32:                                     ; preds = %polly.cond30
  %24 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %24
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond66

polly.loop_header:                                ; preds = %polly.then32, %polly.loop_exit45
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit45 ], [ 0, %polly.then32 ]
  %25 = add i64 %1, -1
  %polly.loop_guard37 = icmp sle i64 0, %25
  br i1 %polly.loop_guard37, label %polly.loop_header34, label %polly.loop_exit36

polly.loop_exit36:                                ; preds = %polly.loop_header34, %polly.loop_header
  %26 = add i64 %2, -1
  %polly.loop_guard46 = icmp sle i64 0, %26
  br i1 %polly.loop_guard46, label %polly.loop_header43, label %polly.loop_exit45

polly.loop_exit45:                                ; preds = %polly.loop_exit55, %polly.loop_exit36
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %24, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond66

polly.loop_header34:                              ; preds = %polly.loop_header, %polly.loop_header34
  %polly.indvar38 = phi i64 [ %polly.indvar_next39, %polly.loop_header34 ], [ 0, %polly.loop_header ]
  %p_scevgep = getelementptr [1100 x double]* %C, i64 %polly.indvar, i64 %polly.indvar38
  %_p_scalar_ = load double* %p_scevgep
  %p_ = fmul double %_p_scalar_, %beta
  store double %p_, double* %p_scevgep
  %p_indvar.next = add i64 %polly.indvar38, 1
  %polly.indvar_next39 = add nsw i64 %polly.indvar38, 1
  %polly.adjust_ub40 = sub i64 %25, 1
  %polly.loop_cond41 = icmp sle i64 %polly.indvar38, %polly.adjust_ub40
  br i1 %polly.loop_cond41, label %polly.loop_header34, label %polly.loop_exit36

polly.loop_header43:                              ; preds = %polly.loop_exit36, %polly.loop_exit55
  %polly.indvar47 = phi i64 [ %polly.indvar_next48, %polly.loop_exit55 ], [ 0, %polly.loop_exit36 ]
  %p_scevgep21.moved.to..lr.ph5 = getelementptr [1200 x double]* %A, i64 %polly.indvar, i64 %polly.indvar47
  %_p_scalar_51 = load double* %p_scevgep21.moved.to..lr.ph5
  br i1 %polly.loop_guard37, label %polly.loop_header53, label %polly.loop_exit55

polly.loop_exit55:                                ; preds = %polly.loop_header53, %polly.loop_header43
  %polly.indvar_next48 = add nsw i64 %polly.indvar47, 1
  %polly.adjust_ub49 = sub i64 %26, 1
  %polly.loop_cond50 = icmp sle i64 %polly.indvar47, %polly.adjust_ub49
  br i1 %polly.loop_cond50, label %polly.loop_header43, label %polly.loop_exit45

polly.loop_header53:                              ; preds = %polly.loop_header43, %polly.loop_header53
  %polly.indvar57 = phi i64 [ %polly.indvar_next58, %polly.loop_header53 ], [ 0, %polly.loop_header43 ]
  %p_.moved.to.26 = fmul double %_p_scalar_51, %alpha
  %p_scevgep18 = getelementptr [1100 x double]* %C, i64 %polly.indvar, i64 %polly.indvar57
  %p_scevgep17 = getelementptr [1100 x double]* %B, i64 %polly.indvar47, i64 %polly.indvar57
  %_p_scalar_62 = load double* %p_scevgep17
  %p_63 = fmul double %p_.moved.to.26, %_p_scalar_62
  %_p_scalar_64 = load double* %p_scevgep18
  %p_65 = fadd double %_p_scalar_64, %p_63
  store double %p_65, double* %p_scevgep18
  %p_indvar.next13 = add i64 %polly.indvar57, 1
  %polly.indvar_next58 = add nsw i64 %polly.indvar57, 1
  %polly.adjust_ub59 = sub i64 %25, 1
  %polly.loop_cond60 = icmp sle i64 %polly.indvar57, %polly.adjust_ub59
  br i1 %polly.loop_cond60, label %polly.loop_header53, label %polly.loop_exit55

polly.then68:                                     ; preds = %polly.cond66
  %27 = add i64 %0, -1
  %polly.loop_guard73 = icmp sle i64 0, %27
  br i1 %polly.loop_guard73, label %polly.loop_header70, label %polly.cond94

polly.loop_header70:                              ; preds = %polly.then68, %polly.loop_exit81
  %polly.indvar74 = phi i64 [ %polly.indvar_next75, %polly.loop_exit81 ], [ 0, %polly.then68 ]
  %28 = add i64 %1, -1
  %polly.loop_guard82 = icmp sle i64 0, %28
  br i1 %polly.loop_guard82, label %polly.loop_header79, label %polly.loop_exit81

polly.loop_exit81:                                ; preds = %polly.loop_header79, %polly.loop_header70
  %polly.indvar_next75 = add nsw i64 %polly.indvar74, 1
  %polly.adjust_ub76 = sub i64 %27, 1
  %polly.loop_cond77 = icmp sle i64 %polly.indvar74, %polly.adjust_ub76
  br i1 %polly.loop_cond77, label %polly.loop_header70, label %polly.cond94

polly.loop_header79:                              ; preds = %polly.loop_header70, %polly.loop_header79
  %polly.indvar83 = phi i64 [ %polly.indvar_next84, %polly.loop_header79 ], [ 0, %polly.loop_header70 ]
  %p_scevgep89 = getelementptr [1100 x double]* %C, i64 %polly.indvar74, i64 %polly.indvar83
  %_p_scalar_90 = load double* %p_scevgep89
  %p_91 = fmul double %_p_scalar_90, %beta
  store double %p_91, double* %p_scevgep89
  %p_indvar.next92 = add i64 %polly.indvar83, 1
  %polly.indvar_next84 = add nsw i64 %polly.indvar83, 1
  %polly.adjust_ub85 = sub i64 %28, 1
  %polly.loop_cond86 = icmp sle i64 %polly.indvar83, %polly.adjust_ub85
  br i1 %polly.loop_cond86, label %polly.loop_header79, label %polly.loop_exit81

polly.then96:                                     ; preds = %polly.cond94
  %29 = add i64 %0, -1
  %polly.loop_guard101 = icmp sle i64 0, %29
  br i1 %polly.loop_guard101, label %polly.loop_header98, label %polly.cond122

polly.loop_header98:                              ; preds = %polly.then96, %polly.loop_exit109
  %polly.indvar102 = phi i64 [ %polly.indvar_next103, %polly.loop_exit109 ], [ 0, %polly.then96 ]
  %30 = add i64 %1, -1
  %polly.loop_guard110 = icmp sle i64 0, %30
  br i1 %polly.loop_guard110, label %polly.loop_header107, label %polly.loop_exit109

polly.loop_exit109:                               ; preds = %polly.loop_header107, %polly.loop_header98
  %polly.indvar_next103 = add nsw i64 %polly.indvar102, 1
  %polly.adjust_ub104 = sub i64 %29, 1
  %polly.loop_cond105 = icmp sle i64 %polly.indvar102, %polly.adjust_ub104
  br i1 %polly.loop_cond105, label %polly.loop_header98, label %polly.cond122

polly.loop_header107:                             ; preds = %polly.loop_header98, %polly.loop_header107
  %polly.indvar111 = phi i64 [ %polly.indvar_next112, %polly.loop_header107 ], [ 0, %polly.loop_header98 ]
  %p_scevgep117 = getelementptr [1100 x double]* %C, i64 %polly.indvar102, i64 %polly.indvar111
  %_p_scalar_118 = load double* %p_scevgep117
  %p_119 = fmul double %_p_scalar_118, %beta
  store double %p_119, double* %p_scevgep117
  %p_indvar.next120 = add i64 %polly.indvar111, 1
  %polly.indvar_next112 = add nsw i64 %polly.indvar111, 1
  %polly.adjust_ub113 = sub i64 %30, 1
  %polly.loop_cond114 = icmp sle i64 %polly.indvar111, %polly.adjust_ub113
  br i1 %polly.loop_cond114, label %polly.loop_header107, label %polly.loop_exit109

polly.then124:                                    ; preds = %polly.cond122
  %31 = add i64 %0, -1
  %polly.loop_guard129 = icmp sle i64 0, %31
  br i1 %polly.loop_guard129, label %polly.loop_header126, label %polly.merge

polly.loop_header126:                             ; preds = %polly.then124, %polly.loop_exit137
  %polly.indvar130 = phi i64 [ %polly.indvar_next131, %polly.loop_exit137 ], [ 0, %polly.then124 ]
  %32 = add i64 %2, -1
  %polly.loop_guard138 = icmp sle i64 0, %32
  br i1 %polly.loop_guard138, label %polly.loop_header135, label %polly.loop_exit137

polly.loop_exit137:                               ; preds = %polly.loop_header135, %polly.loop_header126
  %polly.indvar_next131 = add nsw i64 %polly.indvar130, 1
  %polly.adjust_ub132 = sub i64 %31, 1
  %polly.loop_cond133 = icmp sle i64 %polly.indvar130, %polly.adjust_ub132
  br i1 %polly.loop_cond133, label %polly.loop_header126, label %polly.merge

polly.loop_header135:                             ; preds = %polly.loop_header126, %polly.loop_header135
  %polly.indvar139 = phi i64 [ %polly.indvar_next140, %polly.loop_header135 ], [ 0, %polly.loop_header126 ]
  %p_scevgep21.moved.to..lr.ph5144 = getelementptr [1200 x double]* %A, i64 %polly.indvar130, i64 %polly.indvar139
  %polly.indvar_next140 = add nsw i64 %polly.indvar139, 1
  %polly.adjust_ub141 = sub i64 %32, 1
  %polly.loop_cond142 = icmp sle i64 %polly.indvar139, %polly.adjust_ub141
  br i1 %polly.loop_cond142, label %polly.loop_header135, label %polly.loop_exit137
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %ni, i32 %nj, [1100 x double]* noalias %C) #0 {
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
