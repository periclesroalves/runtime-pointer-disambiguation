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
  %alpha39 = bitcast double* %alpha to i8*
  %beta40 = bitcast double* %beta to i8*
  %C42 = bitcast [1100 x double]* %C to i8*
  %C41 = ptrtoint [1100 x double]* %C to i64
  %0 = icmp ult i8* %alpha39, %beta40
  %1 = icmp ult i8* %beta40, %alpha39
  %pair-no-alias = or i1 %0, %1
  %2 = zext i32 %ni to i64
  %3 = add i64 %2, -1
  %4 = mul i64 8800, %3
  %5 = add i64 %C41, %4
  %6 = zext i32 %nj to i64
  %7 = add i64 %6, -1
  %8 = mul i64 8, %7
  %9 = add i64 %5, %8
  %10 = inttoptr i64 %9 to i8*
  %11 = icmp ult i8* %alpha39, %C42
  %12 = icmp ult i8* %10, %alpha39
  %pair-no-alias43 = or i1 %11, %12
  %13 = and i1 %pair-no-alias, %pair-no-alias43
  %14 = icmp ult i8* %beta40, %C42
  %15 = icmp ult i8* %10, %beta40
  %pair-no-alias44 = or i1 %14, %15
  %16 = and i1 %13, %pair-no-alias44
  br i1 %16, label %polly.start148, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  store double 1.500000e+00, double* %alpha, align 8, !tbaa !1
  store double 1.200000e+00, double* %beta, align 8, !tbaa !1
  %17 = icmp sgt i32 %ni, 0
  br i1 %17, label %.preheader4.lr.ph.clone, label %polly.start99

.preheader4.lr.ph.clone:                          ; preds = %.split.split.clone
  %18 = sitofp i32 %ni to double
  %19 = sext i32 %nj to i64
  %20 = icmp sge i64 %19, 1
  %21 = icmp sge i64 %2, 1
  %22 = and i1 %20, %21
  %23 = icmp sge i64 %6, 1
  %24 = and i1 %22, %23
  br i1 %24, label %polly.then201, label %polly.start99

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit68, %polly.merge102
  ret void

polly.then:                                       ; preds = %polly.merge102
  %25 = add i64 %83, -1
  %polly.loop_guard = icmp sle i64 0, %25
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit68
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit68 ], [ 0, %polly.then ]
  %26 = mul i64 -3, %83
  %27 = add i64 %26, %6
  %28 = add i64 %27, 5
  %29 = sub i64 %28, 32
  %30 = add i64 %29, 1
  %31 = icmp slt i64 %28, 0
  %32 = select i1 %31, i64 %30, i64 %28
  %33 = sdiv i64 %32, 32
  %34 = mul i64 -32, %33
  %35 = mul i64 -32, %83
  %36 = add i64 %34, %35
  %37 = mul i64 -32, %polly.indvar
  %38 = mul i64 -3, %polly.indvar
  %39 = add i64 %38, %6
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
  %polly.loop_guard69 = icmp sle i64 %50, %51
  br i1 %polly.loop_guard69, label %polly.loop_header66, label %polly.loop_exit68

polly.loop_exit68:                                ; preds = %polly.loop_exit77, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %25, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header66:                              ; preds = %polly.loop_header, %polly.loop_exit77
  %polly.indvar70 = phi i64 [ %polly.indvar_next71, %polly.loop_exit77 ], [ %50, %polly.loop_header ]
  %52 = mul i64 -1, %polly.indvar70
  %53 = mul i64 -1, %6
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
  %polly.loop_guard78 = icmp sle i64 %62, %72
  br i1 %polly.loop_guard78, label %polly.loop_header75, label %polly.loop_exit77

polly.loop_exit77:                                ; preds = %polly.loop_exit86, %polly.loop_header66
  %polly.indvar_next71 = add nsw i64 %polly.indvar70, 32
  %polly.adjust_ub72 = sub i64 %51, 32
  %polly.loop_cond73 = icmp sle i64 %polly.indvar70, %polly.adjust_ub72
  br i1 %polly.loop_cond73, label %polly.loop_header66, label %polly.loop_exit68

polly.loop_header75:                              ; preds = %polly.loop_header66, %polly.loop_exit86
  %polly.indvar79 = phi i64 [ %polly.indvar_next80, %polly.loop_exit86 ], [ %62, %polly.loop_header66 ]
  %73 = mul i64 -20, %polly.indvar79
  %74 = add i64 %73, %53
  %75 = add i64 %74, 1
  %76 = icmp sgt i64 %polly.indvar70, %75
  %77 = select i1 %76, i64 %polly.indvar70, i64 %75
  %78 = add i64 %polly.indvar70, 31
  %79 = icmp slt i64 %73, %78
  %80 = select i1 %79, i64 %73, i64 %78
  %polly.loop_guard87 = icmp sle i64 %77, %80
  br i1 %polly.loop_guard87, label %polly.loop_header84, label %polly.loop_exit86

polly.loop_exit86:                                ; preds = %polly.loop_header84, %polly.loop_header75
  %polly.indvar_next80 = add nsw i64 %polly.indvar79, 1
  %polly.adjust_ub81 = sub i64 %72, 1
  %polly.loop_cond82 = icmp sle i64 %polly.indvar79, %polly.adjust_ub81
  br i1 %polly.loop_cond82, label %polly.loop_header75, label %polly.loop_exit77

polly.loop_header84:                              ; preds = %polly.loop_header75, %polly.loop_header84
  %polly.indvar88 = phi i64 [ %polly.indvar_next89, %polly.loop_header84 ], [ %77, %polly.loop_header75 ]
  %81 = mul i64 -1, %polly.indvar88
  %82 = add i64 %73, %81
  %p_.moved.to. = mul i64 %polly.indvar79, 2
  %p_.moved.to.45 = sitofp i32 %nj to double
  %p_scevgep = getelementptr [1100 x double]* %B, i64 %polly.indvar79, i64 %82
  %p_ = mul i64 %polly.indvar79, %82
  %p_92 = add i64 %p_.moved.to., %p_
  %p_93 = trunc i64 %p_92 to i32
  %p_94 = srem i32 %p_93, %nj
  %p_95 = sitofp i32 %p_94 to double
  %p_96 = fdiv double %p_95, %p_.moved.to.45
  store double %p_96, double* %p_scevgep
  %p_indvar.next = add i64 %82, 1
  %polly.indvar_next89 = add nsw i64 %polly.indvar88, 1
  %polly.adjust_ub90 = sub i64 %80, 1
  %polly.loop_cond91 = icmp sle i64 %polly.indvar88, %polly.adjust_ub90
  br i1 %polly.loop_cond91, label %polly.loop_header84, label %polly.loop_exit86

polly.start99:                                    ; preds = %polly.then201, %polly.loop_exit214, %.preheader4.lr.ph.clone, %polly.then153, %polly.loop_exit166, %polly.start148, %.split.split.clone
  %83 = zext i32 %nk to i64
  %84 = sext i32 %ni to i64
  %85 = icmp sge i64 %84, 1
  %86 = sext i32 %nk to i64
  %87 = icmp sge i64 %86, 1
  %88 = and i1 %85, %87
  %89 = icmp sge i64 %2, 1
  %90 = and i1 %88, %89
  %91 = icmp sge i64 %83, 1
  %92 = and i1 %90, %91
  br i1 %92, label %polly.then103, label %polly.merge102

polly.merge102:                                   ; preds = %polly.then103, %polly.loop_exit116, %polly.start99
  %93 = sext i32 %nj to i64
  %94 = icmp sge i64 %93, 1
  %95 = and i1 %94, %87
  %96 = and i1 %95, %91
  %97 = icmp sge i64 %6, 1
  %98 = and i1 %96, %97
  br i1 %98, label %polly.then, label %polly.merge

polly.then103:                                    ; preds = %polly.start99
  %polly.loop_guard108 = icmp sle i64 0, %3
  br i1 %polly.loop_guard108, label %polly.loop_header105, label %polly.merge102

polly.loop_header105:                             ; preds = %polly.then103, %polly.loop_exit116
  %polly.indvar109 = phi i64 [ %polly.indvar_next110, %polly.loop_exit116 ], [ 0, %polly.then103 ]
  %99 = mul i64 -3, %2
  %100 = add i64 %99, %83
  %101 = add i64 %100, 5
  %102 = sub i64 %101, 32
  %103 = add i64 %102, 1
  %104 = icmp slt i64 %101, 0
  %105 = select i1 %104, i64 %103, i64 %101
  %106 = sdiv i64 %105, 32
  %107 = mul i64 -32, %106
  %108 = mul i64 -32, %2
  %109 = add i64 %107, %108
  %110 = mul i64 -32, %polly.indvar109
  %111 = mul i64 -3, %polly.indvar109
  %112 = add i64 %111, %83
  %113 = add i64 %112, 5
  %114 = sub i64 %113, 32
  %115 = add i64 %114, 1
  %116 = icmp slt i64 %113, 0
  %117 = select i1 %116, i64 %115, i64 %113
  %118 = sdiv i64 %117, 32
  %119 = mul i64 -32, %118
  %120 = add i64 %110, %119
  %121 = add i64 %120, -640
  %122 = icmp sgt i64 %109, %121
  %123 = select i1 %122, i64 %109, i64 %121
  %124 = mul i64 -20, %polly.indvar109
  %polly.loop_guard117 = icmp sle i64 %123, %124
  br i1 %polly.loop_guard117, label %polly.loop_header114, label %polly.loop_exit116

polly.loop_exit116:                               ; preds = %polly.loop_exit125, %polly.loop_header105
  %polly.indvar_next110 = add nsw i64 %polly.indvar109, 32
  %polly.adjust_ub111 = sub i64 %3, 32
  %polly.loop_cond112 = icmp sle i64 %polly.indvar109, %polly.adjust_ub111
  br i1 %polly.loop_cond112, label %polly.loop_header105, label %polly.merge102

polly.loop_header114:                             ; preds = %polly.loop_header105, %polly.loop_exit125
  %polly.indvar118 = phi i64 [ %polly.indvar_next119, %polly.loop_exit125 ], [ %123, %polly.loop_header105 ]
  %125 = mul i64 -1, %polly.indvar118
  %126 = mul i64 -1, %83
  %127 = add i64 %125, %126
  %128 = add i64 %127, -30
  %129 = add i64 %128, 20
  %130 = sub i64 %129, 1
  %131 = icmp slt i64 %128, 0
  %132 = select i1 %131, i64 %128, i64 %130
  %133 = sdiv i64 %132, 20
  %134 = icmp sgt i64 %133, %polly.indvar109
  %135 = select i1 %134, i64 %133, i64 %polly.indvar109
  %136 = sub i64 %125, 20
  %137 = add i64 %136, 1
  %138 = icmp slt i64 %125, 0
  %139 = select i1 %138, i64 %137, i64 %125
  %140 = sdiv i64 %139, 20
  %141 = add i64 %polly.indvar109, 31
  %142 = icmp slt i64 %140, %141
  %143 = select i1 %142, i64 %140, i64 %141
  %144 = icmp slt i64 %143, %3
  %145 = select i1 %144, i64 %143, i64 %3
  %polly.loop_guard126 = icmp sle i64 %135, %145
  br i1 %polly.loop_guard126, label %polly.loop_header123, label %polly.loop_exit125

polly.loop_exit125:                               ; preds = %polly.loop_exit134, %polly.loop_header114
  %polly.indvar_next119 = add nsw i64 %polly.indvar118, 32
  %polly.adjust_ub120 = sub i64 %124, 32
  %polly.loop_cond121 = icmp sle i64 %polly.indvar118, %polly.adjust_ub120
  br i1 %polly.loop_cond121, label %polly.loop_header114, label %polly.loop_exit116

polly.loop_header123:                             ; preds = %polly.loop_header114, %polly.loop_exit134
  %polly.indvar127 = phi i64 [ %polly.indvar_next128, %polly.loop_exit134 ], [ %135, %polly.loop_header114 ]
  %146 = mul i64 -20, %polly.indvar127
  %147 = add i64 %146, %126
  %148 = add i64 %147, 1
  %149 = icmp sgt i64 %polly.indvar118, %148
  %150 = select i1 %149, i64 %polly.indvar118, i64 %148
  %151 = add i64 %polly.indvar118, 31
  %152 = icmp slt i64 %146, %151
  %153 = select i1 %152, i64 %146, i64 %151
  %polly.loop_guard135 = icmp sle i64 %150, %153
  br i1 %polly.loop_guard135, label %polly.loop_header132, label %polly.loop_exit134

polly.loop_exit134:                               ; preds = %polly.loop_header132, %polly.loop_header123
  %polly.indvar_next128 = add nsw i64 %polly.indvar127, 1
  %polly.adjust_ub129 = sub i64 %145, 1
  %polly.loop_cond130 = icmp sle i64 %polly.indvar127, %polly.adjust_ub129
  br i1 %polly.loop_cond130, label %polly.loop_header123, label %polly.loop_exit125

polly.loop_header132:                             ; preds = %polly.loop_header123, %polly.loop_header132
  %polly.indvar136 = phi i64 [ %polly.indvar_next137, %polly.loop_header132 ], [ %150, %polly.loop_header123 ]
  %154 = mul i64 -1, %polly.indvar136
  %155 = add i64 %146, %154
  %p_.moved.to.52 = sitofp i32 %nk to double
  %p_scevgep28 = getelementptr [1200 x double]* %A, i64 %polly.indvar127, i64 %155
  %p_141 = mul i64 %polly.indvar127, %155
  %p_142 = add i64 %polly.indvar127, %p_141
  %p_143 = trunc i64 %p_142 to i32
  %p_144 = srem i32 %p_143, %nk
  %p_145 = sitofp i32 %p_144 to double
  %p_146 = fdiv double %p_145, %p_.moved.to.52
  store double %p_146, double* %p_scevgep28
  %p_indvar.next24 = add i64 %155, 1
  %polly.indvar_next137 = add nsw i64 %polly.indvar136, 1
  %polly.adjust_ub138 = sub i64 %153, 1
  %polly.loop_cond139 = icmp sle i64 %polly.indvar136, %polly.adjust_ub138
  br i1 %polly.loop_cond139, label %polly.loop_header132, label %polly.loop_exit134

polly.start148:                                   ; preds = %.split
  store double 1.500000e+00, double* %alpha
  store double 1.200000e+00, double* %beta
  %156 = sext i32 %ni to i64
  %157 = icmp sge i64 %156, 1
  %158 = sext i32 %nj to i64
  %159 = icmp sge i64 %158, 1
  %160 = and i1 %157, %159
  %161 = icmp sge i64 %2, 1
  %162 = and i1 %160, %161
  %163 = icmp sge i64 %6, 1
  %164 = and i1 %162, %163
  br i1 %164, label %polly.then153, label %polly.start99

polly.then153:                                    ; preds = %polly.start148
  %polly.loop_guard158 = icmp sle i64 0, %3
  br i1 %polly.loop_guard158, label %polly.loop_header155, label %polly.start99

polly.loop_header155:                             ; preds = %polly.then153, %polly.loop_exit166
  %polly.indvar159 = phi i64 [ %polly.indvar_next160, %polly.loop_exit166 ], [ 0, %polly.then153 ]
  %165 = mul i64 -3, %2
  %166 = add i64 %165, %6
  %167 = add i64 %166, 5
  %168 = sub i64 %167, 32
  %169 = add i64 %168, 1
  %170 = icmp slt i64 %167, 0
  %171 = select i1 %170, i64 %169, i64 %167
  %172 = sdiv i64 %171, 32
  %173 = mul i64 -32, %172
  %174 = mul i64 -32, %2
  %175 = add i64 %173, %174
  %176 = mul i64 -32, %polly.indvar159
  %177 = mul i64 -3, %polly.indvar159
  %178 = add i64 %177, %6
  %179 = add i64 %178, 5
  %180 = sub i64 %179, 32
  %181 = add i64 %180, 1
  %182 = icmp slt i64 %179, 0
  %183 = select i1 %182, i64 %181, i64 %179
  %184 = sdiv i64 %183, 32
  %185 = mul i64 -32, %184
  %186 = add i64 %176, %185
  %187 = add i64 %186, -640
  %188 = icmp sgt i64 %175, %187
  %189 = select i1 %188, i64 %175, i64 %187
  %190 = mul i64 -20, %polly.indvar159
  %polly.loop_guard167 = icmp sle i64 %189, %190
  br i1 %polly.loop_guard167, label %polly.loop_header164, label %polly.loop_exit166

polly.loop_exit166:                               ; preds = %polly.loop_exit175, %polly.loop_header155
  %polly.indvar_next160 = add nsw i64 %polly.indvar159, 32
  %polly.adjust_ub161 = sub i64 %3, 32
  %polly.loop_cond162 = icmp sle i64 %polly.indvar159, %polly.adjust_ub161
  br i1 %polly.loop_cond162, label %polly.loop_header155, label %polly.start99

polly.loop_header164:                             ; preds = %polly.loop_header155, %polly.loop_exit175
  %polly.indvar168 = phi i64 [ %polly.indvar_next169, %polly.loop_exit175 ], [ %189, %polly.loop_header155 ]
  %191 = mul i64 -1, %polly.indvar168
  %192 = mul i64 -1, %6
  %193 = add i64 %191, %192
  %194 = add i64 %193, -30
  %195 = add i64 %194, 20
  %196 = sub i64 %195, 1
  %197 = icmp slt i64 %194, 0
  %198 = select i1 %197, i64 %194, i64 %196
  %199 = sdiv i64 %198, 20
  %200 = icmp sgt i64 %199, %polly.indvar159
  %201 = select i1 %200, i64 %199, i64 %polly.indvar159
  %202 = sub i64 %191, 20
  %203 = add i64 %202, 1
  %204 = icmp slt i64 %191, 0
  %205 = select i1 %204, i64 %203, i64 %191
  %206 = sdiv i64 %205, 20
  %207 = add i64 %polly.indvar159, 31
  %208 = icmp slt i64 %206, %207
  %209 = select i1 %208, i64 %206, i64 %207
  %210 = icmp slt i64 %209, %3
  %211 = select i1 %210, i64 %209, i64 %3
  %polly.loop_guard176 = icmp sle i64 %201, %211
  br i1 %polly.loop_guard176, label %polly.loop_header173, label %polly.loop_exit175

polly.loop_exit175:                               ; preds = %polly.loop_exit184, %polly.loop_header164
  %polly.indvar_next169 = add nsw i64 %polly.indvar168, 32
  %polly.adjust_ub170 = sub i64 %190, 32
  %polly.loop_cond171 = icmp sle i64 %polly.indvar168, %polly.adjust_ub170
  br i1 %polly.loop_cond171, label %polly.loop_header164, label %polly.loop_exit166

polly.loop_header173:                             ; preds = %polly.loop_header164, %polly.loop_exit184
  %polly.indvar177 = phi i64 [ %polly.indvar_next178, %polly.loop_exit184 ], [ %201, %polly.loop_header164 ]
  %212 = mul i64 -20, %polly.indvar177
  %213 = add i64 %212, %192
  %214 = add i64 %213, 1
  %215 = icmp sgt i64 %polly.indvar168, %214
  %216 = select i1 %215, i64 %polly.indvar168, i64 %214
  %217 = add i64 %polly.indvar168, 31
  %218 = icmp slt i64 %212, %217
  %219 = select i1 %218, i64 %212, i64 %217
  %polly.loop_guard185 = icmp sle i64 %216, %219
  br i1 %polly.loop_guard185, label %polly.loop_header182, label %polly.loop_exit184

polly.loop_exit184:                               ; preds = %polly.loop_header182, %polly.loop_header173
  %polly.indvar_next178 = add nsw i64 %polly.indvar177, 1
  %polly.adjust_ub179 = sub i64 %211, 1
  %polly.loop_cond180 = icmp sle i64 %polly.indvar177, %polly.adjust_ub179
  br i1 %polly.loop_cond180, label %polly.loop_header173, label %polly.loop_exit175

polly.loop_header182:                             ; preds = %polly.loop_header173, %polly.loop_header182
  %polly.indvar186 = phi i64 [ %polly.indvar_next187, %polly.loop_header182 ], [ %216, %polly.loop_header173 ]
  %220 = mul i64 -1, %polly.indvar186
  %221 = add i64 %212, %220
  %p_.moved.to.59 = sitofp i32 %ni to double
  %p_scevgep36 = getelementptr [1100 x double]* %C, i64 %polly.indvar177, i64 %221
  %p_191 = mul i64 %polly.indvar177, %221
  %p_192 = trunc i64 %p_191 to i32
  %p_193 = srem i32 %p_192, %ni
  %p_194 = sitofp i32 %p_193 to double
  %p_195 = fdiv double %p_194, %p_.moved.to.59
  store double %p_195, double* %p_scevgep36
  %p_indvar.next32 = add i64 %221, 1
  %polly.indvar_next187 = add nsw i64 %polly.indvar186, 1
  %polly.adjust_ub188 = sub i64 %219, 1
  %polly.loop_cond189 = icmp sle i64 %polly.indvar186, %polly.adjust_ub188
  br i1 %polly.loop_cond189, label %polly.loop_header182, label %polly.loop_exit184

polly.then201:                                    ; preds = %.preheader4.lr.ph.clone
  %polly.loop_guard206 = icmp sle i64 0, %3
  br i1 %polly.loop_guard206, label %polly.loop_header203, label %polly.start99

polly.loop_header203:                             ; preds = %polly.then201, %polly.loop_exit214
  %polly.indvar207 = phi i64 [ %polly.indvar_next208, %polly.loop_exit214 ], [ 0, %polly.then201 ]
  %222 = mul i64 -3, %2
  %223 = add i64 %222, %6
  %224 = add i64 %223, 5
  %225 = sub i64 %224, 32
  %226 = add i64 %225, 1
  %227 = icmp slt i64 %224, 0
  %228 = select i1 %227, i64 %226, i64 %224
  %229 = sdiv i64 %228, 32
  %230 = mul i64 -32, %229
  %231 = mul i64 -32, %2
  %232 = add i64 %230, %231
  %233 = mul i64 -32, %polly.indvar207
  %234 = mul i64 -3, %polly.indvar207
  %235 = add i64 %234, %6
  %236 = add i64 %235, 5
  %237 = sub i64 %236, 32
  %238 = add i64 %237, 1
  %239 = icmp slt i64 %236, 0
  %240 = select i1 %239, i64 %238, i64 %236
  %241 = sdiv i64 %240, 32
  %242 = mul i64 -32, %241
  %243 = add i64 %233, %242
  %244 = add i64 %243, -640
  %245 = icmp sgt i64 %232, %244
  %246 = select i1 %245, i64 %232, i64 %244
  %247 = mul i64 -20, %polly.indvar207
  %polly.loop_guard215 = icmp sle i64 %246, %247
  br i1 %polly.loop_guard215, label %polly.loop_header212, label %polly.loop_exit214

polly.loop_exit214:                               ; preds = %polly.loop_exit223, %polly.loop_header203
  %polly.indvar_next208 = add nsw i64 %polly.indvar207, 32
  %polly.adjust_ub209 = sub i64 %3, 32
  %polly.loop_cond210 = icmp sle i64 %polly.indvar207, %polly.adjust_ub209
  br i1 %polly.loop_cond210, label %polly.loop_header203, label %polly.start99

polly.loop_header212:                             ; preds = %polly.loop_header203, %polly.loop_exit223
  %polly.indvar216 = phi i64 [ %polly.indvar_next217, %polly.loop_exit223 ], [ %246, %polly.loop_header203 ]
  %248 = mul i64 -1, %polly.indvar216
  %249 = mul i64 -1, %6
  %250 = add i64 %248, %249
  %251 = add i64 %250, -30
  %252 = add i64 %251, 20
  %253 = sub i64 %252, 1
  %254 = icmp slt i64 %251, 0
  %255 = select i1 %254, i64 %251, i64 %253
  %256 = sdiv i64 %255, 20
  %257 = icmp sgt i64 %256, %polly.indvar207
  %258 = select i1 %257, i64 %256, i64 %polly.indvar207
  %259 = sub i64 %248, 20
  %260 = add i64 %259, 1
  %261 = icmp slt i64 %248, 0
  %262 = select i1 %261, i64 %260, i64 %248
  %263 = sdiv i64 %262, 20
  %264 = add i64 %polly.indvar207, 31
  %265 = icmp slt i64 %263, %264
  %266 = select i1 %265, i64 %263, i64 %264
  %267 = icmp slt i64 %266, %3
  %268 = select i1 %267, i64 %266, i64 %3
  %polly.loop_guard224 = icmp sle i64 %258, %268
  br i1 %polly.loop_guard224, label %polly.loop_header221, label %polly.loop_exit223

polly.loop_exit223:                               ; preds = %polly.loop_exit232, %polly.loop_header212
  %polly.indvar_next217 = add nsw i64 %polly.indvar216, 32
  %polly.adjust_ub218 = sub i64 %247, 32
  %polly.loop_cond219 = icmp sle i64 %polly.indvar216, %polly.adjust_ub218
  br i1 %polly.loop_cond219, label %polly.loop_header212, label %polly.loop_exit214

polly.loop_header221:                             ; preds = %polly.loop_header212, %polly.loop_exit232
  %polly.indvar225 = phi i64 [ %polly.indvar_next226, %polly.loop_exit232 ], [ %258, %polly.loop_header212 ]
  %269 = mul i64 -20, %polly.indvar225
  %270 = add i64 %269, %249
  %271 = add i64 %270, 1
  %272 = icmp sgt i64 %polly.indvar216, %271
  %273 = select i1 %272, i64 %polly.indvar216, i64 %271
  %274 = add i64 %polly.indvar216, 31
  %275 = icmp slt i64 %269, %274
  %276 = select i1 %275, i64 %269, i64 %274
  %polly.loop_guard233 = icmp sle i64 %273, %276
  br i1 %polly.loop_guard233, label %polly.loop_header230, label %polly.loop_exit232

polly.loop_exit232:                               ; preds = %polly.loop_header230, %polly.loop_header221
  %polly.indvar_next226 = add nsw i64 %polly.indvar225, 1
  %polly.adjust_ub227 = sub i64 %268, 1
  %polly.loop_cond228 = icmp sle i64 %polly.indvar225, %polly.adjust_ub227
  br i1 %polly.loop_cond228, label %polly.loop_header221, label %polly.loop_exit223

polly.loop_header230:                             ; preds = %polly.loop_header221, %polly.loop_header230
  %polly.indvar234 = phi i64 [ %polly.indvar_next235, %polly.loop_header230 ], [ %273, %polly.loop_header221 ]
  %277 = mul i64 -1, %polly.indvar234
  %278 = add i64 %269, %277
  %p_scevgep36.clone = getelementptr [1100 x double]* %C, i64 %polly.indvar225, i64 %278
  %p_239 = mul i64 %polly.indvar225, %278
  %p_240 = trunc i64 %p_239 to i32
  %p_241 = srem i32 %p_240, %ni
  %p_242 = sitofp i32 %p_241 to double
  %p_243 = fdiv double %p_242, %18
  store double %p_243, double* %p_scevgep36.clone
  %p_indvar.next32.clone = add i64 %278, 1
  %polly.indvar_next235 = add nsw i64 %polly.indvar234, 1
  %polly.adjust_ub236 = sub i64 %276, 1
  %polly.loop_cond237 = icmp sle i64 %polly.indvar234, %polly.adjust_ub236
  br i1 %polly.loop_cond237, label %polly.loop_header230, label %polly.loop_exit232
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_gemm(i32 %ni, i32 %nj, i32 %nk, double %alpha, double %beta, [1100 x double]* %C, [1200 x double]* %A, [1100 x double]* %B) #0 {
.split:
  %A30 = bitcast [1200 x double]* %A to i8*
  %B32 = bitcast [1100 x double]* %B to i8*
  %B31 = ptrtoint [1100 x double]* %B to i64
  %A27 = ptrtoint [1200 x double]* %A to i64
  %C26 = ptrtoint [1100 x double]* %C to i64
  %umin28 = bitcast [1100 x double]* %C to i8*
  %0 = zext i32 %ni to i64
  %1 = add i64 %0, -1
  %2 = mul i64 8800, %1
  %3 = add i64 %C26, %2
  %4 = zext i32 %nj to i64
  %5 = add i64 %4, -1
  %6 = mul i64 8, %5
  %7 = add i64 %3, %6
  %umax29 = inttoptr i64 %7 to i8*
  %8 = mul i64 9600, %1
  %9 = add i64 %A27, %8
  %10 = zext i32 %nk to i64
  %11 = add i64 %10, -1
  %12 = mul i64 8, %11
  %13 = add i64 %9, %12
  %14 = inttoptr i64 %13 to i8*
  %15 = icmp ult i8* %umax29, %A30
  %16 = icmp ult i8* %14, %umin28
  %pair-no-alias = or i1 %15, %16
  %17 = mul i64 8800, %11
  %18 = add i64 %B31, %17
  %19 = add i64 %18, %6
  %20 = inttoptr i64 %19 to i8*
  %21 = icmp ult i8* %umax29, %B32
  %22 = icmp ult i8* %20, %umin28
  %pair-no-alias33 = or i1 %21, %22
  %23 = and i1 %pair-no-alias, %pair-no-alias33
  %24 = icmp ult i8* %14, %B32
  %25 = icmp ult i8* %20, %A30
  %pair-no-alias34 = or i1 %24, %25
  %26 = and i1 %23, %pair-no-alias34
  br i1 %26, label %polly.start, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  %27 = icmp sgt i32 %ni, 0
  br i1 %27, label %.preheader2.lr.ph.clone, label %.region.clone

.preheader2.lr.ph.clone:                          ; preds = %.split.split.clone
  %28 = icmp sgt i32 %nj, 0
  %29 = icmp sgt i32 %nk, 0
  br label %.preheader2.clone

.preheader2.clone:                                ; preds = %._crit_edge7.clone, %.preheader2.lr.ph.clone
  %indvar10.clone = phi i64 [ 0, %.preheader2.lr.ph.clone ], [ %indvar.next11.clone, %._crit_edge7.clone ]
  %30 = mul i64 %indvar10.clone, 8800
  br i1 %28, label %polly.cond179, label %.preheader1.clone

.preheader1.clone:                                ; preds = %polly.then184, %polly.loop_header186, %polly.cond179, %.preheader2.clone
  br i1 %29, label %.preheader.clone, label %._crit_edge7.clone

.preheader.clone:                                 ; preds = %.preheader1.clone, %._crit_edge.clone
  %indvar15.clone = phi i64 [ %indvar.next16.clone, %._crit_edge.clone ], [ 0, %.preheader1.clone ]
  %scevgep21.clone = getelementptr [1200 x double]* %A, i64 %indvar10.clone, i64 %indvar15.clone
  br i1 %28, label %.lr.ph5.clone, label %._crit_edge.clone

.lr.ph5.clone:                                    ; preds = %.preheader.clone, %.lr.ph5.clone
  %indvar12.clone = phi i64 [ %indvar.next13.clone, %.lr.ph5.clone ], [ 0, %.preheader.clone ]
  %scevgep18.clone = getelementptr [1100 x double]* %C, i64 %indvar10.clone, i64 %indvar12.clone
  %scevgep17.clone = getelementptr [1100 x double]* %B, i64 %indvar15.clone, i64 %indvar12.clone
  %31 = load double* %scevgep21.clone, align 8, !tbaa !1
  %32 = fmul double %31, %alpha
  %33 = load double* %scevgep17.clone, align 8, !tbaa !1
  %34 = fmul double %32, %33
  %35 = load double* %scevgep18.clone, align 8, !tbaa !1
  %36 = fadd double %35, %34
  store double %36, double* %scevgep18.clone, align 8, !tbaa !1
  %indvar.next13.clone = add i64 %indvar12.clone, 1
  %exitcond14.clone = icmp ne i64 %indvar.next13.clone, %4
  br i1 %exitcond14.clone, label %.lr.ph5.clone, label %._crit_edge.clone

._crit_edge.clone:                                ; preds = %.lr.ph5.clone, %.preheader.clone
  %indvar.next16.clone = add i64 %indvar15.clone, 1
  %exitcond19.clone = icmp ne i64 %indvar.next16.clone, %10
  br i1 %exitcond19.clone, label %.preheader.clone, label %._crit_edge7.clone

._crit_edge7.clone:                               ; preds = %._crit_edge.clone, %.preheader1.clone
  %indvar.next11.clone = add i64 %indvar10.clone, 1
  %exitcond22.clone = icmp ne i64 %indvar.next11.clone, %0
  br i1 %exitcond22.clone, label %.preheader2.clone, label %.region.clone

.region.clone:                                    ; preds = %polly.then132, %polly.loop_exit145, %polly.cond130, %polly.start, %.split.split.clone, %._crit_edge7.clone
  ret void

polly.start:                                      ; preds = %.split
  %37 = sext i32 %ni to i64
  %38 = icmp sge i64 %37, 1
  %39 = sext i32 %nj to i64
  %40 = icmp sge i64 %39, 1
  %41 = and i1 %38, %40
  %42 = icmp sge i64 %0, 1
  %43 = and i1 %41, %42
  %44 = icmp sge i64 %4, 1
  %45 = and i1 %43, %44
  br i1 %45, label %polly.cond38, label %.region.clone

polly.cond38:                                     ; preds = %polly.start
  %46 = sext i32 %nk to i64
  %47 = icmp sge i64 %46, 1
  %48 = icmp sge i64 %10, 1
  %49 = and i1 %47, %48
  br i1 %49, label %polly.then40, label %polly.cond84

polly.cond84:                                     ; preds = %polly.then40, %polly.loop_exit44, %polly.cond38
  %50 = icmp sle i64 %46, 0
  %51 = and i1 %50, %48
  br i1 %51, label %polly.then86, label %polly.cond130

polly.cond130:                                    ; preds = %polly.then86, %polly.loop_exit99, %polly.cond84
  %52 = icmp sle i64 %10, 0
  br i1 %52, label %polly.then132, label %.region.clone

polly.then40:                                     ; preds = %polly.cond38
  %polly.loop_guard = icmp sle i64 0, %1
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond84

polly.loop_header:                                ; preds = %polly.then40, %polly.loop_exit44
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit44 ], [ 0, %polly.then40 ]
  %53 = mul i64 -3, %0
  %54 = add i64 %53, %4
  %55 = add i64 %54, 5
  %56 = sub i64 %55, 32
  %57 = add i64 %56, 1
  %58 = icmp slt i64 %55, 0
  %59 = select i1 %58, i64 %57, i64 %55
  %60 = sdiv i64 %59, 32
  %61 = mul i64 -32, %60
  %62 = mul i64 -32, %0
  %63 = add i64 %61, %62
  %64 = mul i64 -32, %polly.indvar
  %65 = mul i64 -3, %polly.indvar
  %66 = add i64 %65, %4
  %67 = add i64 %66, 5
  %68 = sub i64 %67, 32
  %69 = add i64 %68, 1
  %70 = icmp slt i64 %67, 0
  %71 = select i1 %70, i64 %69, i64 %67
  %72 = sdiv i64 %71, 32
  %73 = mul i64 -32, %72
  %74 = add i64 %64, %73
  %75 = add i64 %74, -640
  %76 = icmp sgt i64 %63, %75
  %77 = select i1 %76, i64 %63, i64 %75
  %78 = mul i64 -20, %polly.indvar
  %polly.loop_guard45 = icmp sle i64 %77, %78
  br i1 %polly.loop_guard45, label %polly.loop_header42, label %polly.loop_exit44

polly.loop_exit44:                                ; preds = %polly.loop_exit53, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %1, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond84

polly.loop_header42:                              ; preds = %polly.loop_header, %polly.loop_exit53
  %polly.indvar46 = phi i64 [ %polly.indvar_next47, %polly.loop_exit53 ], [ %77, %polly.loop_header ]
  %79 = mul i64 -1, %polly.indvar46
  %80 = mul i64 -1, %4
  %81 = add i64 %79, %80
  %82 = add i64 %81, -30
  %83 = add i64 %82, 20
  %84 = sub i64 %83, 1
  %85 = icmp slt i64 %82, 0
  %86 = select i1 %85, i64 %82, i64 %84
  %87 = sdiv i64 %86, 20
  %88 = icmp sgt i64 %87, %polly.indvar
  %89 = select i1 %88, i64 %87, i64 %polly.indvar
  %90 = sub i64 %79, 20
  %91 = add i64 %90, 1
  %92 = icmp slt i64 %79, 0
  %93 = select i1 %92, i64 %91, i64 %79
  %94 = sdiv i64 %93, 20
  %95 = add i64 %polly.indvar, 31
  %96 = icmp slt i64 %94, %95
  %97 = select i1 %96, i64 %94, i64 %95
  %98 = icmp slt i64 %97, %1
  %99 = select i1 %98, i64 %97, i64 %1
  %polly.loop_guard54 = icmp sle i64 %89, %99
  br i1 %polly.loop_guard54, label %polly.loop_header51, label %polly.loop_exit53

polly.loop_exit53:                                ; preds = %polly.loop_exit62, %polly.loop_header42
  %polly.indvar_next47 = add nsw i64 %polly.indvar46, 32
  %polly.adjust_ub48 = sub i64 %78, 32
  %polly.loop_cond49 = icmp sle i64 %polly.indvar46, %polly.adjust_ub48
  br i1 %polly.loop_cond49, label %polly.loop_header42, label %polly.loop_exit44

polly.loop_header51:                              ; preds = %polly.loop_header42, %polly.loop_exit62
  %polly.indvar55 = phi i64 [ %polly.indvar_next56, %polly.loop_exit62 ], [ %89, %polly.loop_header42 ]
  %100 = mul i64 -20, %polly.indvar55
  %101 = add i64 %100, %80
  %102 = add i64 %101, 1
  %103 = icmp sgt i64 %polly.indvar46, %102
  %104 = select i1 %103, i64 %polly.indvar46, i64 %102
  %105 = add i64 %polly.indvar46, 31
  %106 = icmp slt i64 %100, %105
  %107 = select i1 %106, i64 %100, i64 %105
  %polly.loop_guard63 = icmp sle i64 %104, %107
  br i1 %polly.loop_guard63, label %polly.loop_header60, label %polly.loop_exit62

polly.loop_exit62:                                ; preds = %polly.loop_exit71, %polly.loop_header51
  %polly.indvar_next56 = add nsw i64 %polly.indvar55, 1
  %polly.adjust_ub57 = sub i64 %99, 1
  %polly.loop_cond58 = icmp sle i64 %polly.indvar55, %polly.adjust_ub57
  br i1 %polly.loop_cond58, label %polly.loop_header51, label %polly.loop_exit53

polly.loop_header60:                              ; preds = %polly.loop_header51, %polly.loop_exit71
  %polly.indvar64 = phi i64 [ %polly.indvar_next65, %polly.loop_exit71 ], [ %104, %polly.loop_header51 ]
  %108 = mul i64 -1, %polly.indvar64
  %109 = add i64 %100, %108
  %p_scevgep = getelementptr [1100 x double]* %C, i64 %polly.indvar55, i64 %109
  %_p_scalar_ = load double* %p_scevgep
  %p_ = fmul double %_p_scalar_, %beta
  store double %p_, double* %p_scevgep
  %p_indvar.next = add i64 %109, 1
  %polly.loop_guard72 = icmp sle i64 0, %11
  br i1 %polly.loop_guard72, label %polly.loop_header69, label %polly.loop_exit71

polly.loop_exit71:                                ; preds = %polly.loop_header69, %polly.loop_header60
  %polly.indvar_next65 = add nsw i64 %polly.indvar64, 1
  %polly.adjust_ub66 = sub i64 %107, 1
  %polly.loop_cond67 = icmp sle i64 %polly.indvar64, %polly.adjust_ub66
  br i1 %polly.loop_cond67, label %polly.loop_header60, label %polly.loop_exit62

polly.loop_header69:                              ; preds = %polly.loop_header60, %polly.loop_header69
  %polly.indvar73 = phi i64 [ %polly.indvar_next74, %polly.loop_header69 ], [ 0, %polly.loop_header60 ]
  %p_scevgep21.moved.to. = getelementptr [1200 x double]* %A, i64 %polly.indvar55, i64 %polly.indvar73
  %p_scevgep17 = getelementptr [1100 x double]* %B, i64 %polly.indvar73, i64 %109
  %_p_scalar_78 = load double* %p_scevgep21.moved.to.
  %p_79 = fmul double %_p_scalar_78, %alpha
  %_p_scalar_80 = load double* %p_scevgep17
  %p_81 = fmul double %p_79, %_p_scalar_80
  %_p_scalar_82 = load double* %p_scevgep
  %p_83 = fadd double %_p_scalar_82, %p_81
  store double %p_83, double* %p_scevgep
  %polly.indvar_next74 = add nsw i64 %polly.indvar73, 1
  %polly.adjust_ub75 = sub i64 %11, 1
  %polly.loop_cond76 = icmp sle i64 %polly.indvar73, %polly.adjust_ub75
  br i1 %polly.loop_cond76, label %polly.loop_header69, label %polly.loop_exit71

polly.then86:                                     ; preds = %polly.cond84
  %polly.loop_guard91 = icmp sle i64 0, %1
  br i1 %polly.loop_guard91, label %polly.loop_header88, label %polly.cond130

polly.loop_header88:                              ; preds = %polly.then86, %polly.loop_exit99
  %polly.indvar92 = phi i64 [ %polly.indvar_next93, %polly.loop_exit99 ], [ 0, %polly.then86 ]
  %110 = mul i64 -3, %0
  %111 = add i64 %110, %4
  %112 = add i64 %111, 5
  %113 = sub i64 %112, 32
  %114 = add i64 %113, 1
  %115 = icmp slt i64 %112, 0
  %116 = select i1 %115, i64 %114, i64 %112
  %117 = sdiv i64 %116, 32
  %118 = mul i64 -32, %117
  %119 = mul i64 -32, %0
  %120 = add i64 %118, %119
  %121 = mul i64 -32, %polly.indvar92
  %122 = mul i64 -3, %polly.indvar92
  %123 = add i64 %122, %4
  %124 = add i64 %123, 5
  %125 = sub i64 %124, 32
  %126 = add i64 %125, 1
  %127 = icmp slt i64 %124, 0
  %128 = select i1 %127, i64 %126, i64 %124
  %129 = sdiv i64 %128, 32
  %130 = mul i64 -32, %129
  %131 = add i64 %121, %130
  %132 = add i64 %131, -640
  %133 = icmp sgt i64 %120, %132
  %134 = select i1 %133, i64 %120, i64 %132
  %135 = mul i64 -20, %polly.indvar92
  %polly.loop_guard100 = icmp sle i64 %134, %135
  br i1 %polly.loop_guard100, label %polly.loop_header97, label %polly.loop_exit99

polly.loop_exit99:                                ; preds = %polly.loop_exit108, %polly.loop_header88
  %polly.indvar_next93 = add nsw i64 %polly.indvar92, 32
  %polly.adjust_ub94 = sub i64 %1, 32
  %polly.loop_cond95 = icmp sle i64 %polly.indvar92, %polly.adjust_ub94
  br i1 %polly.loop_cond95, label %polly.loop_header88, label %polly.cond130

polly.loop_header97:                              ; preds = %polly.loop_header88, %polly.loop_exit108
  %polly.indvar101 = phi i64 [ %polly.indvar_next102, %polly.loop_exit108 ], [ %134, %polly.loop_header88 ]
  %136 = mul i64 -1, %polly.indvar101
  %137 = mul i64 -1, %4
  %138 = add i64 %136, %137
  %139 = add i64 %138, -30
  %140 = add i64 %139, 20
  %141 = sub i64 %140, 1
  %142 = icmp slt i64 %139, 0
  %143 = select i1 %142, i64 %139, i64 %141
  %144 = sdiv i64 %143, 20
  %145 = icmp sgt i64 %144, %polly.indvar92
  %146 = select i1 %145, i64 %144, i64 %polly.indvar92
  %147 = sub i64 %136, 20
  %148 = add i64 %147, 1
  %149 = icmp slt i64 %136, 0
  %150 = select i1 %149, i64 %148, i64 %136
  %151 = sdiv i64 %150, 20
  %152 = add i64 %polly.indvar92, 31
  %153 = icmp slt i64 %151, %152
  %154 = select i1 %153, i64 %151, i64 %152
  %155 = icmp slt i64 %154, %1
  %156 = select i1 %155, i64 %154, i64 %1
  %polly.loop_guard109 = icmp sle i64 %146, %156
  br i1 %polly.loop_guard109, label %polly.loop_header106, label %polly.loop_exit108

polly.loop_exit108:                               ; preds = %polly.loop_exit117, %polly.loop_header97
  %polly.indvar_next102 = add nsw i64 %polly.indvar101, 32
  %polly.adjust_ub103 = sub i64 %135, 32
  %polly.loop_cond104 = icmp sle i64 %polly.indvar101, %polly.adjust_ub103
  br i1 %polly.loop_cond104, label %polly.loop_header97, label %polly.loop_exit99

polly.loop_header106:                             ; preds = %polly.loop_header97, %polly.loop_exit117
  %polly.indvar110 = phi i64 [ %polly.indvar_next111, %polly.loop_exit117 ], [ %146, %polly.loop_header97 ]
  %157 = mul i64 -20, %polly.indvar110
  %158 = add i64 %157, %137
  %159 = add i64 %158, 1
  %160 = icmp sgt i64 %polly.indvar101, %159
  %161 = select i1 %160, i64 %polly.indvar101, i64 %159
  %162 = add i64 %polly.indvar101, 31
  %163 = icmp slt i64 %157, %162
  %164 = select i1 %163, i64 %157, i64 %162
  %polly.loop_guard118 = icmp sle i64 %161, %164
  br i1 %polly.loop_guard118, label %polly.loop_header115, label %polly.loop_exit117

polly.loop_exit117:                               ; preds = %polly.loop_header115, %polly.loop_header106
  %polly.indvar_next111 = add nsw i64 %polly.indvar110, 1
  %polly.adjust_ub112 = sub i64 %156, 1
  %polly.loop_cond113 = icmp sle i64 %polly.indvar110, %polly.adjust_ub112
  br i1 %polly.loop_cond113, label %polly.loop_header106, label %polly.loop_exit108

polly.loop_header115:                             ; preds = %polly.loop_header106, %polly.loop_header115
  %polly.indvar119 = phi i64 [ %polly.indvar_next120, %polly.loop_header115 ], [ %161, %polly.loop_header106 ]
  %165 = mul i64 -1, %polly.indvar119
  %166 = add i64 %157, %165
  %p_scevgep125 = getelementptr [1100 x double]* %C, i64 %polly.indvar110, i64 %166
  %_p_scalar_126 = load double* %p_scevgep125
  %p_127 = fmul double %_p_scalar_126, %beta
  store double %p_127, double* %p_scevgep125
  %p_indvar.next128 = add i64 %166, 1
  %polly.indvar_next120 = add nsw i64 %polly.indvar119, 1
  %polly.adjust_ub121 = sub i64 %164, 1
  %polly.loop_cond122 = icmp sle i64 %polly.indvar119, %polly.adjust_ub121
  br i1 %polly.loop_cond122, label %polly.loop_header115, label %polly.loop_exit117

polly.then132:                                    ; preds = %polly.cond130
  %polly.loop_guard137 = icmp sle i64 0, %1
  br i1 %polly.loop_guard137, label %polly.loop_header134, label %.region.clone

polly.loop_header134:                             ; preds = %polly.then132, %polly.loop_exit145
  %polly.indvar138 = phi i64 [ %polly.indvar_next139, %polly.loop_exit145 ], [ 0, %polly.then132 ]
  %167 = mul i64 -3, %0
  %168 = add i64 %167, %4
  %169 = add i64 %168, 5
  %170 = sub i64 %169, 32
  %171 = add i64 %170, 1
  %172 = icmp slt i64 %169, 0
  %173 = select i1 %172, i64 %171, i64 %169
  %174 = sdiv i64 %173, 32
  %175 = mul i64 -32, %174
  %176 = mul i64 -32, %0
  %177 = add i64 %175, %176
  %178 = mul i64 -32, %polly.indvar138
  %179 = mul i64 -3, %polly.indvar138
  %180 = add i64 %179, %4
  %181 = add i64 %180, 5
  %182 = sub i64 %181, 32
  %183 = add i64 %182, 1
  %184 = icmp slt i64 %181, 0
  %185 = select i1 %184, i64 %183, i64 %181
  %186 = sdiv i64 %185, 32
  %187 = mul i64 -32, %186
  %188 = add i64 %178, %187
  %189 = add i64 %188, -640
  %190 = icmp sgt i64 %177, %189
  %191 = select i1 %190, i64 %177, i64 %189
  %192 = mul i64 -20, %polly.indvar138
  %polly.loop_guard146 = icmp sle i64 %191, %192
  br i1 %polly.loop_guard146, label %polly.loop_header143, label %polly.loop_exit145

polly.loop_exit145:                               ; preds = %polly.loop_exit154, %polly.loop_header134
  %polly.indvar_next139 = add nsw i64 %polly.indvar138, 32
  %polly.adjust_ub140 = sub i64 %1, 32
  %polly.loop_cond141 = icmp sle i64 %polly.indvar138, %polly.adjust_ub140
  br i1 %polly.loop_cond141, label %polly.loop_header134, label %.region.clone

polly.loop_header143:                             ; preds = %polly.loop_header134, %polly.loop_exit154
  %polly.indvar147 = phi i64 [ %polly.indvar_next148, %polly.loop_exit154 ], [ %191, %polly.loop_header134 ]
  %193 = mul i64 -1, %polly.indvar147
  %194 = mul i64 -1, %4
  %195 = add i64 %193, %194
  %196 = add i64 %195, -30
  %197 = add i64 %196, 20
  %198 = sub i64 %197, 1
  %199 = icmp slt i64 %196, 0
  %200 = select i1 %199, i64 %196, i64 %198
  %201 = sdiv i64 %200, 20
  %202 = icmp sgt i64 %201, %polly.indvar138
  %203 = select i1 %202, i64 %201, i64 %polly.indvar138
  %204 = sub i64 %193, 20
  %205 = add i64 %204, 1
  %206 = icmp slt i64 %193, 0
  %207 = select i1 %206, i64 %205, i64 %193
  %208 = sdiv i64 %207, 20
  %209 = add i64 %polly.indvar138, 31
  %210 = icmp slt i64 %208, %209
  %211 = select i1 %210, i64 %208, i64 %209
  %212 = icmp slt i64 %211, %1
  %213 = select i1 %212, i64 %211, i64 %1
  %polly.loop_guard155 = icmp sle i64 %203, %213
  br i1 %polly.loop_guard155, label %polly.loop_header152, label %polly.loop_exit154

polly.loop_exit154:                               ; preds = %polly.loop_exit163, %polly.loop_header143
  %polly.indvar_next148 = add nsw i64 %polly.indvar147, 32
  %polly.adjust_ub149 = sub i64 %192, 32
  %polly.loop_cond150 = icmp sle i64 %polly.indvar147, %polly.adjust_ub149
  br i1 %polly.loop_cond150, label %polly.loop_header143, label %polly.loop_exit145

polly.loop_header152:                             ; preds = %polly.loop_header143, %polly.loop_exit163
  %polly.indvar156 = phi i64 [ %polly.indvar_next157, %polly.loop_exit163 ], [ %203, %polly.loop_header143 ]
  %214 = mul i64 -20, %polly.indvar156
  %215 = add i64 %214, %194
  %216 = add i64 %215, 1
  %217 = icmp sgt i64 %polly.indvar147, %216
  %218 = select i1 %217, i64 %polly.indvar147, i64 %216
  %219 = add i64 %polly.indvar147, 31
  %220 = icmp slt i64 %214, %219
  %221 = select i1 %220, i64 %214, i64 %219
  %polly.loop_guard164 = icmp sle i64 %218, %221
  br i1 %polly.loop_guard164, label %polly.loop_header161, label %polly.loop_exit163

polly.loop_exit163:                               ; preds = %polly.loop_header161, %polly.loop_header152
  %polly.indvar_next157 = add nsw i64 %polly.indvar156, 1
  %polly.adjust_ub158 = sub i64 %213, 1
  %polly.loop_cond159 = icmp sle i64 %polly.indvar156, %polly.adjust_ub158
  br i1 %polly.loop_cond159, label %polly.loop_header152, label %polly.loop_exit154

polly.loop_header161:                             ; preds = %polly.loop_header152, %polly.loop_header161
  %polly.indvar165 = phi i64 [ %polly.indvar_next166, %polly.loop_header161 ], [ %218, %polly.loop_header152 ]
  %222 = mul i64 -1, %polly.indvar165
  %223 = add i64 %214, %222
  %p_scevgep171 = getelementptr [1100 x double]* %C, i64 %polly.indvar156, i64 %223
  %_p_scalar_172 = load double* %p_scevgep171
  %p_173 = fmul double %_p_scalar_172, %beta
  store double %p_173, double* %p_scevgep171
  %p_indvar.next174 = add i64 %223, 1
  %polly.indvar_next166 = add nsw i64 %polly.indvar165, 1
  %polly.adjust_ub167 = sub i64 %221, 1
  %polly.loop_cond168 = icmp sle i64 %polly.indvar165, %polly.adjust_ub167
  br i1 %polly.loop_cond168, label %polly.loop_header161, label %polly.loop_exit163

polly.cond179:                                    ; preds = %.preheader2.clone
  %224 = srem i64 %30, 8
  %225 = icmp eq i64 %224, 0
  %226 = icmp sge i64 %4, 1
  %or.cond = and i1 %225, %226
  br i1 %or.cond, label %polly.then184, label %.preheader1.clone

polly.then184:                                    ; preds = %polly.cond179
  %polly.loop_guard189 = icmp sle i64 0, %5
  br i1 %polly.loop_guard189, label %polly.loop_header186, label %.preheader1.clone

polly.loop_header186:                             ; preds = %polly.then184, %polly.loop_header186
  %polly.indvar190 = phi i64 [ %polly.indvar_next191, %polly.loop_header186 ], [ 0, %polly.then184 ]
  %p_scevgep.clone = getelementptr [1100 x double]* %C, i64 %indvar10.clone, i64 %polly.indvar190
  %_p_scalar_195 = load double* %p_scevgep.clone
  %p_196 = fmul double %_p_scalar_195, %beta
  store double %p_196, double* %p_scevgep.clone
  %p_indvar.next.clone = add i64 %polly.indvar190, 1
  %polly.indvar_next191 = add nsw i64 %polly.indvar190, 1
  %polly.adjust_ub192 = sub i64 %5, 1
  %polly.loop_cond193 = icmp sle i64 %polly.indvar190, %polly.adjust_ub192
  br i1 %polly.loop_cond193, label %polly.loop_header186, label %.preheader1.clone
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
