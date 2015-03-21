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
  store double 1.500000e+00, double* %alpha, align 8, !tbaa !1
  store double 1.200000e+00, double* %beta, align 8, !tbaa !1
  %0 = icmp sgt i32 %ni, 0
  br i1 %0, label %.preheader6.lr.ph, label %polly.start146

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
  br i1 %9, label %polly.then199, label %polly.start146

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit67, %polly.merge100
  ret void

polly.then:                                       ; preds = %polly.merge100
  %10 = add i64 %68, -1
  %polly.loop_guard = icmp sle i64 0, %10
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit67
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit67 ], [ 0, %polly.then ]
  %11 = mul i64 -3, %68
  %12 = add i64 %11, %144
  %13 = add i64 %12, 5
  %14 = sub i64 %13, 32
  %15 = add i64 %14, 1
  %16 = icmp slt i64 %13, 0
  %17 = select i1 %16, i64 %15, i64 %13
  %18 = sdiv i64 %17, 32
  %19 = mul i64 -32, %18
  %20 = mul i64 -32, %68
  %21 = add i64 %19, %20
  %22 = mul i64 -32, %polly.indvar
  %23 = mul i64 -3, %polly.indvar
  %24 = add i64 %23, %144
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
  %polly.loop_guard68 = icmp sle i64 %35, %36
  br i1 %polly.loop_guard68, label %polly.loop_header65, label %polly.loop_exit67

polly.loop_exit67:                                ; preds = %polly.loop_exit76, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %10, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header65:                              ; preds = %polly.loop_header, %polly.loop_exit76
  %polly.indvar69 = phi i64 [ %polly.indvar_next70, %polly.loop_exit76 ], [ %35, %polly.loop_header ]
  %37 = mul i64 -1, %polly.indvar69
  %38 = mul i64 -1, %144
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
  %polly.loop_guard77 = icmp sle i64 %47, %57
  br i1 %polly.loop_guard77, label %polly.loop_header74, label %polly.loop_exit76

polly.loop_exit76:                                ; preds = %polly.loop_exit85, %polly.loop_header65
  %polly.indvar_next70 = add nsw i64 %polly.indvar69, 32
  %polly.adjust_ub71 = sub i64 %36, 32
  %polly.loop_cond72 = icmp sle i64 %polly.indvar69, %polly.adjust_ub71
  br i1 %polly.loop_cond72, label %polly.loop_header65, label %polly.loop_exit67

polly.loop_header74:                              ; preds = %polly.loop_header65, %polly.loop_exit85
  %polly.indvar78 = phi i64 [ %polly.indvar_next79, %polly.loop_exit85 ], [ %47, %polly.loop_header65 ]
  %58 = mul i64 -20, %polly.indvar78
  %59 = add i64 %58, %38
  %60 = add i64 %59, 1
  %61 = icmp sgt i64 %polly.indvar69, %60
  %62 = select i1 %61, i64 %polly.indvar69, i64 %60
  %63 = add i64 %polly.indvar69, 31
  %64 = icmp slt i64 %58, %63
  %65 = select i1 %64, i64 %58, i64 %63
  %polly.loop_guard86 = icmp sle i64 %62, %65
  br i1 %polly.loop_guard86, label %polly.loop_header83, label %polly.loop_exit85

polly.loop_exit85:                                ; preds = %polly.loop_header83, %polly.loop_header74
  %polly.indvar_next79 = add nsw i64 %polly.indvar78, 1
  %polly.adjust_ub80 = sub i64 %57, 1
  %polly.loop_cond81 = icmp sle i64 %polly.indvar78, %polly.adjust_ub80
  br i1 %polly.loop_cond81, label %polly.loop_header74, label %polly.loop_exit76

polly.loop_header83:                              ; preds = %polly.loop_header74, %polly.loop_header83
  %polly.indvar87 = phi i64 [ %polly.indvar_next88, %polly.loop_header83 ], [ %62, %polly.loop_header74 ]
  %66 = mul i64 -1, %polly.indvar87
  %67 = add i64 %58, %66
  %p_.moved.to.60 = mul i64 %polly.indvar78, 2
  %p_.moved.to.61 = sitofp i32 %nk to double
  %p_scevgep = getelementptr [1200 x double]* %D, i64 %polly.indvar78, i64 %67
  %p_ = mul i64 %polly.indvar78, %67
  %p_91 = add i64 %p_.moved.to.60, %p_
  %p_92 = trunc i64 %p_91 to i32
  %p_93 = srem i32 %p_92, %nk
  %p_94 = sitofp i32 %p_93 to double
  %p_95 = fdiv double %p_94, %p_.moved.to.61
  store double %p_95, double* %p_scevgep
  %p_indvar.next = add i64 %67, 1
  %polly.indvar_next88 = add nsw i64 %polly.indvar87, 1
  %polly.adjust_ub89 = sub i64 %65, 1
  %polly.loop_cond90 = icmp sle i64 %polly.indvar87, %polly.adjust_ub89
  br i1 %polly.loop_cond90, label %polly.loop_header83, label %polly.loop_exit85

polly.merge100:                                   ; preds = %polly.then101, %polly.loop_exit114, %polly.merge149
  %68 = zext i32 %ni to i64
  %69 = sext i32 %ni to i64
  %70 = icmp sge i64 %69, 1
  %71 = and i1 %70, %146
  %72 = icmp sge i64 %68, 1
  %73 = and i1 %71, %72
  %74 = and i1 %73, %149
  br i1 %74, label %polly.then, label %polly.merge

polly.then101:                                    ; preds = %polly.merge149
  %75 = add i64 %134, -1
  %polly.loop_guard106 = icmp sle i64 0, %75
  br i1 %polly.loop_guard106, label %polly.loop_header103, label %polly.merge100

polly.loop_header103:                             ; preds = %polly.then101, %polly.loop_exit114
  %polly.indvar107 = phi i64 [ %polly.indvar_next108, %polly.loop_exit114 ], [ 0, %polly.then101 ]
  %76 = mul i64 -3, %134
  %77 = add i64 %76, %144
  %78 = add i64 %77, 5
  %79 = sub i64 %78, 32
  %80 = add i64 %79, 1
  %81 = icmp slt i64 %78, 0
  %82 = select i1 %81, i64 %80, i64 %78
  %83 = sdiv i64 %82, 32
  %84 = mul i64 -32, %83
  %85 = mul i64 -32, %134
  %86 = add i64 %84, %85
  %87 = mul i64 -32, %polly.indvar107
  %88 = mul i64 -3, %polly.indvar107
  %89 = add i64 %88, %144
  %90 = add i64 %89, 5
  %91 = sub i64 %90, 32
  %92 = add i64 %91, 1
  %93 = icmp slt i64 %90, 0
  %94 = select i1 %93, i64 %92, i64 %90
  %95 = sdiv i64 %94, 32
  %96 = mul i64 -32, %95
  %97 = add i64 %87, %96
  %98 = add i64 %97, -640
  %99 = icmp sgt i64 %86, %98
  %100 = select i1 %99, i64 %86, i64 %98
  %101 = mul i64 -20, %polly.indvar107
  %polly.loop_guard115 = icmp sle i64 %100, %101
  br i1 %polly.loop_guard115, label %polly.loop_header112, label %polly.loop_exit114

polly.loop_exit114:                               ; preds = %polly.loop_exit123, %polly.loop_header103
  %polly.indvar_next108 = add nsw i64 %polly.indvar107, 32
  %polly.adjust_ub109 = sub i64 %75, 32
  %polly.loop_cond110 = icmp sle i64 %polly.indvar107, %polly.adjust_ub109
  br i1 %polly.loop_cond110, label %polly.loop_header103, label %polly.merge100

polly.loop_header112:                             ; preds = %polly.loop_header103, %polly.loop_exit123
  %polly.indvar116 = phi i64 [ %polly.indvar_next117, %polly.loop_exit123 ], [ %100, %polly.loop_header103 ]
  %102 = mul i64 -1, %polly.indvar116
  %103 = mul i64 -1, %144
  %104 = add i64 %102, %103
  %105 = add i64 %104, -30
  %106 = add i64 %105, 20
  %107 = sub i64 %106, 1
  %108 = icmp slt i64 %105, 0
  %109 = select i1 %108, i64 %105, i64 %107
  %110 = sdiv i64 %109, 20
  %111 = icmp sgt i64 %110, %polly.indvar107
  %112 = select i1 %111, i64 %110, i64 %polly.indvar107
  %113 = sub i64 %102, 20
  %114 = add i64 %113, 1
  %115 = icmp slt i64 %102, 0
  %116 = select i1 %115, i64 %114, i64 %102
  %117 = sdiv i64 %116, 20
  %118 = add i64 %polly.indvar107, 31
  %119 = icmp slt i64 %117, %118
  %120 = select i1 %119, i64 %117, i64 %118
  %121 = icmp slt i64 %120, %75
  %122 = select i1 %121, i64 %120, i64 %75
  %polly.loop_guard124 = icmp sle i64 %112, %122
  br i1 %polly.loop_guard124, label %polly.loop_header121, label %polly.loop_exit123

polly.loop_exit123:                               ; preds = %polly.loop_exit132, %polly.loop_header112
  %polly.indvar_next117 = add nsw i64 %polly.indvar116, 32
  %polly.adjust_ub118 = sub i64 %101, 32
  %polly.loop_cond119 = icmp sle i64 %polly.indvar116, %polly.adjust_ub118
  br i1 %polly.loop_cond119, label %polly.loop_header112, label %polly.loop_exit114

polly.loop_header121:                             ; preds = %polly.loop_header112, %polly.loop_exit132
  %polly.indvar125 = phi i64 [ %polly.indvar_next126, %polly.loop_exit132 ], [ %112, %polly.loop_header112 ]
  %123 = mul i64 -20, %polly.indvar125
  %124 = add i64 %123, %103
  %125 = add i64 %124, 1
  %126 = icmp sgt i64 %polly.indvar116, %125
  %127 = select i1 %126, i64 %polly.indvar116, i64 %125
  %128 = add i64 %polly.indvar116, 31
  %129 = icmp slt i64 %123, %128
  %130 = select i1 %129, i64 %123, i64 %128
  %polly.loop_guard133 = icmp sle i64 %127, %130
  br i1 %polly.loop_guard133, label %polly.loop_header130, label %polly.loop_exit132

polly.loop_exit132:                               ; preds = %polly.loop_header130, %polly.loop_header121
  %polly.indvar_next126 = add nsw i64 %polly.indvar125, 1
  %polly.adjust_ub127 = sub i64 %122, 1
  %polly.loop_cond128 = icmp sle i64 %polly.indvar125, %polly.adjust_ub127
  br i1 %polly.loop_cond128, label %polly.loop_header121, label %polly.loop_exit123

polly.loop_header130:                             ; preds = %polly.loop_header121, %polly.loop_header130
  %polly.indvar134 = phi i64 [ %polly.indvar_next135, %polly.loop_header130 ], [ %127, %polly.loop_header121 ]
  %131 = mul i64 -1, %polly.indvar134
  %132 = add i64 %123, %131
  %p_.moved.to. = mul i64 %polly.indvar125, 3
  %p_.moved.to.54 = sitofp i32 %nl to double
  %p_scevgep35 = getelementptr [1200 x double]* %C, i64 %polly.indvar125, i64 %132
  %p_139 = mul i64 %polly.indvar125, %132
  %p_140 = add i64 %p_.moved.to., %p_139
  %p_141 = trunc i64 %p_140 to i32
  %p_142 = srem i32 %p_141, %nl
  %p_143 = sitofp i32 %p_142 to double
  %p_144 = fdiv double %p_143, %p_.moved.to.54
  store double %p_144, double* %p_scevgep35
  %p_indvar.next31 = add i64 %132, 1
  %polly.indvar_next135 = add nsw i64 %polly.indvar134, 1
  %polly.adjust_ub136 = sub i64 %130, 1
  %polly.loop_cond137 = icmp sle i64 %polly.indvar134, %polly.adjust_ub136
  br i1 %polly.loop_cond137, label %polly.loop_header130, label %polly.loop_exit132

polly.start146:                                   ; preds = %polly.then199, %polly.loop_exit212, %.preheader6.lr.ph, %.split
  %133 = zext i32 %nk to i64
  %134 = zext i32 %nj to i64
  %135 = sext i32 %nj to i64
  %136 = icmp sge i64 %135, 1
  %137 = sext i32 %nk to i64
  %138 = icmp sge i64 %137, 1
  %139 = and i1 %136, %138
  %140 = icmp sge i64 %133, 1
  %141 = and i1 %139, %140
  %142 = icmp sge i64 %134, 1
  %143 = and i1 %141, %142
  br i1 %143, label %polly.then150, label %polly.merge149

polly.merge149:                                   ; preds = %polly.then150, %polly.loop_exit163, %polly.start146
  %144 = zext i32 %nl to i64
  %145 = sext i32 %nl to i64
  %146 = icmp sge i64 %145, 1
  %147 = and i1 %136, %146
  %148 = and i1 %147, %142
  %149 = icmp sge i64 %144, 1
  %150 = and i1 %148, %149
  br i1 %150, label %polly.then101, label %polly.merge100

polly.then150:                                    ; preds = %polly.start146
  %151 = add i64 %133, -1
  %polly.loop_guard155 = icmp sle i64 0, %151
  br i1 %polly.loop_guard155, label %polly.loop_header152, label %polly.merge149

polly.loop_header152:                             ; preds = %polly.then150, %polly.loop_exit163
  %polly.indvar156 = phi i64 [ %polly.indvar_next157, %polly.loop_exit163 ], [ 0, %polly.then150 ]
  %152 = mul i64 -3, %133
  %153 = add i64 %152, %134
  %154 = add i64 %153, 5
  %155 = sub i64 %154, 32
  %156 = add i64 %155, 1
  %157 = icmp slt i64 %154, 0
  %158 = select i1 %157, i64 %156, i64 %154
  %159 = sdiv i64 %158, 32
  %160 = mul i64 -32, %159
  %161 = mul i64 -32, %133
  %162 = add i64 %160, %161
  %163 = mul i64 -32, %polly.indvar156
  %164 = mul i64 -3, %polly.indvar156
  %165 = add i64 %164, %134
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
  %177 = mul i64 -20, %polly.indvar156
  %polly.loop_guard164 = icmp sle i64 %176, %177
  br i1 %polly.loop_guard164, label %polly.loop_header161, label %polly.loop_exit163

polly.loop_exit163:                               ; preds = %polly.loop_exit172, %polly.loop_header152
  %polly.indvar_next157 = add nsw i64 %polly.indvar156, 32
  %polly.adjust_ub158 = sub i64 %151, 32
  %polly.loop_cond159 = icmp sle i64 %polly.indvar156, %polly.adjust_ub158
  br i1 %polly.loop_cond159, label %polly.loop_header152, label %polly.merge149

polly.loop_header161:                             ; preds = %polly.loop_header152, %polly.loop_exit172
  %polly.indvar165 = phi i64 [ %polly.indvar_next166, %polly.loop_exit172 ], [ %176, %polly.loop_header152 ]
  %178 = mul i64 -1, %polly.indvar165
  %179 = mul i64 -1, %134
  %180 = add i64 %178, %179
  %181 = add i64 %180, -30
  %182 = add i64 %181, 20
  %183 = sub i64 %182, 1
  %184 = icmp slt i64 %181, 0
  %185 = select i1 %184, i64 %181, i64 %183
  %186 = sdiv i64 %185, 20
  %187 = icmp sgt i64 %186, %polly.indvar156
  %188 = select i1 %187, i64 %186, i64 %polly.indvar156
  %189 = sub i64 %178, 20
  %190 = add i64 %189, 1
  %191 = icmp slt i64 %178, 0
  %192 = select i1 %191, i64 %190, i64 %178
  %193 = sdiv i64 %192, 20
  %194 = add i64 %polly.indvar156, 31
  %195 = icmp slt i64 %193, %194
  %196 = select i1 %195, i64 %193, i64 %194
  %197 = icmp slt i64 %196, %151
  %198 = select i1 %197, i64 %196, i64 %151
  %polly.loop_guard173 = icmp sle i64 %188, %198
  br i1 %polly.loop_guard173, label %polly.loop_header170, label %polly.loop_exit172

polly.loop_exit172:                               ; preds = %polly.loop_exit181, %polly.loop_header161
  %polly.indvar_next166 = add nsw i64 %polly.indvar165, 32
  %polly.adjust_ub167 = sub i64 %177, 32
  %polly.loop_cond168 = icmp sle i64 %polly.indvar165, %polly.adjust_ub167
  br i1 %polly.loop_cond168, label %polly.loop_header161, label %polly.loop_exit163

polly.loop_header170:                             ; preds = %polly.loop_header161, %polly.loop_exit181
  %polly.indvar174 = phi i64 [ %polly.indvar_next175, %polly.loop_exit181 ], [ %188, %polly.loop_header161 ]
  %199 = mul i64 -20, %polly.indvar174
  %200 = add i64 %199, %179
  %201 = add i64 %200, 1
  %202 = icmp sgt i64 %polly.indvar165, %201
  %203 = select i1 %202, i64 %polly.indvar165, i64 %201
  %204 = add i64 %polly.indvar165, 31
  %205 = icmp slt i64 %199, %204
  %206 = select i1 %205, i64 %199, i64 %204
  %polly.loop_guard182 = icmp sle i64 %203, %206
  br i1 %polly.loop_guard182, label %polly.loop_header179, label %polly.loop_exit181

polly.loop_exit181:                               ; preds = %polly.loop_header179, %polly.loop_header170
  %polly.indvar_next175 = add nsw i64 %polly.indvar174, 1
  %polly.adjust_ub176 = sub i64 %198, 1
  %polly.loop_cond177 = icmp sle i64 %polly.indvar174, %polly.adjust_ub176
  br i1 %polly.loop_cond177, label %polly.loop_header170, label %polly.loop_exit172

polly.loop_header179:                             ; preds = %polly.loop_header170, %polly.loop_header179
  %polly.indvar183 = phi i64 [ %polly.indvar_next184, %polly.loop_header179 ], [ %203, %polly.loop_header170 ]
  %207 = mul i64 -1, %polly.indvar183
  %208 = add i64 %199, %207
  %p_.moved.to.57 = sitofp i32 %nj to double
  %p_scevgep43 = getelementptr [900 x double]* %B, i64 %polly.indvar174, i64 %208
  %p_188 = mul i64 %polly.indvar174, %208
  %p_189 = add i64 %polly.indvar174, %p_188
  %p_190 = trunc i64 %p_189 to i32
  %p_191 = srem i32 %p_190, %nj
  %p_192 = sitofp i32 %p_191 to double
  %p_193 = fdiv double %p_192, %p_.moved.to.57
  store double %p_193, double* %p_scevgep43
  %p_indvar.next39 = add i64 %208, 1
  %polly.indvar_next184 = add nsw i64 %polly.indvar183, 1
  %polly.adjust_ub185 = sub i64 %206, 1
  %polly.loop_cond186 = icmp sle i64 %polly.indvar183, %polly.adjust_ub185
  br i1 %polly.loop_cond186, label %polly.loop_header179, label %polly.loop_exit181

polly.then199:                                    ; preds = %.preheader6.lr.ph
  %209 = add i64 %3, -1
  %polly.loop_guard204 = icmp sle i64 0, %209
  br i1 %polly.loop_guard204, label %polly.loop_header201, label %polly.start146

polly.loop_header201:                             ; preds = %polly.then199, %polly.loop_exit212
  %polly.indvar205 = phi i64 [ %polly.indvar_next206, %polly.loop_exit212 ], [ 0, %polly.then199 ]
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
  %221 = mul i64 -32, %polly.indvar205
  %222 = mul i64 -3, %polly.indvar205
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
  %235 = mul i64 -20, %polly.indvar205
  %polly.loop_guard213 = icmp sle i64 %234, %235
  br i1 %polly.loop_guard213, label %polly.loop_header210, label %polly.loop_exit212

polly.loop_exit212:                               ; preds = %polly.loop_exit221, %polly.loop_header201
  %polly.indvar_next206 = add nsw i64 %polly.indvar205, 32
  %polly.adjust_ub207 = sub i64 %209, 32
  %polly.loop_cond208 = icmp sle i64 %polly.indvar205, %polly.adjust_ub207
  br i1 %polly.loop_cond208, label %polly.loop_header201, label %polly.start146

polly.loop_header210:                             ; preds = %polly.loop_header201, %polly.loop_exit221
  %polly.indvar214 = phi i64 [ %polly.indvar_next215, %polly.loop_exit221 ], [ %234, %polly.loop_header201 ]
  %236 = mul i64 -1, %polly.indvar214
  %237 = mul i64 -1, %1
  %238 = add i64 %236, %237
  %239 = add i64 %238, -30
  %240 = add i64 %239, 20
  %241 = sub i64 %240, 1
  %242 = icmp slt i64 %239, 0
  %243 = select i1 %242, i64 %239, i64 %241
  %244 = sdiv i64 %243, 20
  %245 = icmp sgt i64 %244, %polly.indvar205
  %246 = select i1 %245, i64 %244, i64 %polly.indvar205
  %247 = sub i64 %236, 20
  %248 = add i64 %247, 1
  %249 = icmp slt i64 %236, 0
  %250 = select i1 %249, i64 %248, i64 %236
  %251 = sdiv i64 %250, 20
  %252 = add i64 %polly.indvar205, 31
  %253 = icmp slt i64 %251, %252
  %254 = select i1 %253, i64 %251, i64 %252
  %255 = icmp slt i64 %254, %209
  %256 = select i1 %255, i64 %254, i64 %209
  %polly.loop_guard222 = icmp sle i64 %246, %256
  br i1 %polly.loop_guard222, label %polly.loop_header219, label %polly.loop_exit221

polly.loop_exit221:                               ; preds = %polly.loop_exit230, %polly.loop_header210
  %polly.indvar_next215 = add nsw i64 %polly.indvar214, 32
  %polly.adjust_ub216 = sub i64 %235, 32
  %polly.loop_cond217 = icmp sle i64 %polly.indvar214, %polly.adjust_ub216
  br i1 %polly.loop_cond217, label %polly.loop_header210, label %polly.loop_exit212

polly.loop_header219:                             ; preds = %polly.loop_header210, %polly.loop_exit230
  %polly.indvar223 = phi i64 [ %polly.indvar_next224, %polly.loop_exit230 ], [ %246, %polly.loop_header210 ]
  %257 = mul i64 -20, %polly.indvar223
  %258 = add i64 %257, %237
  %259 = add i64 %258, 1
  %260 = icmp sgt i64 %polly.indvar214, %259
  %261 = select i1 %260, i64 %polly.indvar214, i64 %259
  %262 = add i64 %polly.indvar214, 31
  %263 = icmp slt i64 %257, %262
  %264 = select i1 %263, i64 %257, i64 %262
  %polly.loop_guard231 = icmp sle i64 %261, %264
  br i1 %polly.loop_guard231, label %polly.loop_header228, label %polly.loop_exit230

polly.loop_exit230:                               ; preds = %polly.loop_header228, %polly.loop_header219
  %polly.indvar_next224 = add nsw i64 %polly.indvar223, 1
  %polly.adjust_ub225 = sub i64 %256, 1
  %polly.loop_cond226 = icmp sle i64 %polly.indvar223, %polly.adjust_ub225
  br i1 %polly.loop_cond226, label %polly.loop_header219, label %polly.loop_exit221

polly.loop_header228:                             ; preds = %polly.loop_header219, %polly.loop_header228
  %polly.indvar232 = phi i64 [ %polly.indvar_next233, %polly.loop_header228 ], [ %261, %polly.loop_header219 ]
  %265 = mul i64 -1, %polly.indvar232
  %266 = add i64 %257, %265
  %p_scevgep51 = getelementptr [1100 x double]* %A, i64 %polly.indvar223, i64 %266
  %p_237 = mul i64 %polly.indvar223, %266
  %p_238 = trunc i64 %p_237 to i32
  %p_239 = srem i32 %p_238, %ni
  %p_240 = sitofp i32 %p_239 to double
  %p_241 = fdiv double %p_240, %2
  store double %p_241, double* %p_scevgep51
  %p_indvar.next47 = add i64 %266, 1
  %polly.indvar_next233 = add nsw i64 %polly.indvar232, 1
  %polly.adjust_ub234 = sub i64 %264, 1
  %polly.loop_cond235 = icmp sle i64 %polly.indvar232, %polly.adjust_ub234
  br i1 %polly.loop_cond235, label %polly.loop_header228, label %polly.loop_exit230
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_2mm(i32 %ni, i32 %nj, i32 %nk, i32 %nl, double %alpha, double %beta, [900 x double]* %tmp, [1100 x double]* %A, [900 x double]* %B, [1200 x double]* %C, [1200 x double]* %D) #0 {
.split:
  %0 = icmp sgt i32 %ni, 0
  br i1 %0, label %.preheader2.lr.ph, label %.preheader1

.preheader2.lr.ph:                                ; preds = %.split
  %1 = zext i32 %nk to i64
  %2 = zext i32 %nj to i64
  %3 = zext i32 %ni to i64
  %4 = icmp sgt i32 %nj, 0
  %5 = icmp sgt i32 %nk, 0
  br label %.preheader2

.preheader2:                                      ; preds = %.preheader2.lr.ph, %._crit_edge15
  %indvar31 = phi i64 [ 0, %.preheader2.lr.ph ], [ %indvar.next32, %._crit_edge15 ]
  br i1 %4, label %.lr.ph14, label %._crit_edge15

.preheader1:                                      ; preds = %._crit_edge15, %.split
  br i1 %0, label %.preheader.lr.ph, label %._crit_edge8

.preheader.lr.ph:                                 ; preds = %.preheader1
  %6 = zext i32 %nj to i64
  %7 = zext i32 %nl to i64
  %8 = zext i32 %ni to i64
  %9 = icmp sgt i32 %nl, 0
  %10 = icmp sgt i32 %nj, 0
  br label %.preheader

.lr.ph14:                                         ; preds = %.preheader2, %._crit_edge12
  %indvar34 = phi i64 [ %indvar.next35, %._crit_edge12 ], [ 0, %.preheader2 ]
  %scevgep39 = getelementptr [900 x double]* %tmp, i64 %indvar31, i64 %indvar34
  store double 0.000000e+00, double* %scevgep39, align 8, !tbaa !1
  br i1 %5, label %.lr.ph11, label %._crit_edge12

.lr.ph11:                                         ; preds = %.lr.ph14, %.lr.ph11
  %indvar28 = phi i64 [ %indvar.next29, %.lr.ph11 ], [ 0, %.lr.ph14 ]
  %scevgep33 = getelementptr [1100 x double]* %A, i64 %indvar31, i64 %indvar28
  %scevgep36 = getelementptr [900 x double]* %B, i64 %indvar28, i64 %indvar34
  %11 = load double* %scevgep33, align 8, !tbaa !1
  %12 = fmul double %11, %alpha
  %13 = load double* %scevgep36, align 8, !tbaa !1
  %14 = fmul double %12, %13
  %15 = load double* %scevgep39, align 8, !tbaa !1
  %16 = fadd double %15, %14
  store double %16, double* %scevgep39, align 8, !tbaa !1
  %indvar.next29 = add i64 %indvar28, 1
  %exitcond30 = icmp ne i64 %indvar.next29, %1
  br i1 %exitcond30, label %.lr.ph11, label %._crit_edge12

._crit_edge12:                                    ; preds = %.lr.ph11, %.lr.ph14
  %indvar.next35 = add i64 %indvar34, 1
  %exitcond37 = icmp ne i64 %indvar.next35, %2
  br i1 %exitcond37, label %.lr.ph14, label %._crit_edge15

._crit_edge15:                                    ; preds = %._crit_edge12, %.preheader2
  %indvar.next32 = add i64 %indvar31, 1
  %exitcond40 = icmp ne i64 %indvar.next32, %3
  br i1 %exitcond40, label %.preheader2, label %.preheader1

.preheader:                                       ; preds = %.preheader.lr.ph, %._crit_edge6
  %indvar17 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next18, %._crit_edge6 ]
  br i1 %9, label %.lr.ph5, label %._crit_edge6

.lr.ph5:                                          ; preds = %.preheader, %._crit_edge
  %indvar19 = phi i64 [ %indvar.next20, %._crit_edge ], [ 0, %.preheader ]
  %scevgep24 = getelementptr [1200 x double]* %D, i64 %indvar17, i64 %indvar19
  %17 = load double* %scevgep24, align 8, !tbaa !1
  %18 = fmul double %17, %beta
  store double %18, double* %scevgep24, align 8, !tbaa !1
  br i1 %10, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %.lr.ph5, %.lr.ph
  %indvar = phi i64 [ %indvar.next, %.lr.ph ], [ 0, %.lr.ph5 ]
  %scevgep = getelementptr [900 x double]* %tmp, i64 %indvar17, i64 %indvar
  %scevgep21 = getelementptr [1200 x double]* %C, i64 %indvar, i64 %indvar19
  %19 = load double* %scevgep, align 8, !tbaa !1
  %20 = load double* %scevgep21, align 8, !tbaa !1
  %21 = fmul double %19, %20
  %22 = load double* %scevgep24, align 8, !tbaa !1
  %23 = fadd double %22, %21
  store double %23, double* %scevgep24, align 8, !tbaa !1
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %6
  br i1 %exitcond, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %.lr.ph5
  %indvar.next20 = add i64 %indvar19, 1
  %exitcond22 = icmp ne i64 %indvar.next20, %7
  br i1 %exitcond22, label %.lr.ph5, label %._crit_edge6

._crit_edge6:                                     ; preds = %._crit_edge, %.preheader
  %indvar.next18 = add i64 %indvar17, 1
  %exitcond25 = icmp ne i64 %indvar.next18, %8
  br i1 %exitcond25, label %.preheader, label %._crit_edge8

._crit_edge8:                                     ; preds = %._crit_edge6, %.preheader1
  ret void
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
