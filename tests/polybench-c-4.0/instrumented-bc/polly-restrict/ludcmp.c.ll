; ModuleID = './linear-algebra/solvers/ludcmp/ludcmp.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %0 = tail call i8* @polybench_alloc_data(i64 4000000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %3 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %4 = bitcast i8* %0 to [2000 x double]*
  %5 = bitcast i8* %1 to double*
  %6 = bitcast i8* %2 to double*
  %7 = bitcast i8* %3 to double*
  tail call void @init_array(i32 2000, [2000 x double]* %4, double* %5, double* %6, double* %7)
  tail call void (...)* @polybench_timer_start() #3
  tail call void @kernel_ludcmp(i32 2000, [2000 x double]* %4, double* %5, double* %6, double* %7)
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
  tail call void @print_array(i32 2000, double* %6)
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
define internal void @init_array(i32 %n, [2000 x double]* noalias %A, double* noalias %b, double* noalias %x, double* noalias %y) #0 {
polly.split_new_and_old249:
  %0 = zext i32 %n to i64
  %1 = sext i32 %n to i64
  %2 = icmp sge i64 %1, 1
  %3 = icmp sge i64 %0, 1
  %4 = and i1 %2, %3
  br i1 %4, label %polly.then254, label %polly.merge253

.preheader7.lr.ph:                                ; preds = %polly.merge253
  %5 = add i32 %n, -2
  %6 = zext i32 %5 to i64
  %7 = sitofp i32 %n to double
  br label %.preheader7

.preheader7:                                      ; preds = %.preheader7.lr.ph, %polly.merge208
  %indvar69 = phi i64 [ 0, %.preheader7.lr.ph ], [ %16, %polly.merge208 ]
  %8 = mul i64 %indvar69, 16000
  %9 = mul i64 %indvar69, -1
  %10 = add i64 %6, %9
  %11 = trunc i64 %10 to i32
  %12 = zext i32 %11 to i64
  %13 = mul i64 %indvar69, 16008
  %i.128 = trunc i64 %indvar69 to i32
  %14 = mul i64 %indvar69, 2001
  %15 = add i64 %14, 1
  %16 = add i64 %indvar69, 1
  %j.124 = trunc i64 %16 to i32
  %scevgep80 = getelementptr [2000 x double]* %A, i64 0, i64 %14
  %17 = add i64 %12, 1
  %18 = icmp slt i32 %i.128, 0
  br i1 %18, label %.preheader6, label %polly.cond227

.preheader6:                                      ; preds = %polly.then232, %polly.loop_header234, %polly.cond227, %.preheader7
  %19 = icmp slt i32 %j.124, %n
  br i1 %19, label %polly.cond207, label %polly.merge208

polly.merge208:                                   ; preds = %polly.then212, %polly.loop_header214, %polly.cond207, %.preheader6
  store double 1.000000e+00, double* %scevgep80, align 8, !tbaa !6
  %exitcond77 = icmp ne i64 %16, %0
  br i1 %exitcond77, label %.preheader7, label %._crit_edge29

._crit_edge29:                                    ; preds = %polly.merge208, %polly.merge253
  %20 = tail call i8* @polybench_alloc_data(i64 4000000, i32 8) #3
  br i1 %140, label %.preheader5.lr.ph, label %polly.start

.preheader5.lr.ph:                                ; preds = %._crit_edge29
  br i1 %4, label %polly.then164, label %polly.start

polly.start:                                      ; preds = %polly.then164, %polly.loop_exit177, %.preheader5.lr.ph, %._crit_edge29
  br i1 %4, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.loop_exit, %polly.loop_exit131, %polly.start
  tail call void @free(i8* %20) #3
  ret void

polly.then:                                       ; preds = %polly.start
  %21 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %21
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.loop_exit

polly.loop_exit:                                  ; preds = %polly.loop_exit99, %polly.then
  br i1 %polly.loop_guard, label %polly.loop_header120, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit99
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit99 ], [ 0, %polly.then ]
  br i1 %polly.loop_guard, label %polly.loop_header97, label %polly.loop_exit99

polly.loop_exit99:                                ; preds = %polly.loop_exit108, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %21, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.loop_exit

polly.loop_header97:                              ; preds = %polly.loop_header, %polly.loop_exit108
  %polly.indvar101 = phi i64 [ %polly.indvar_next102, %polly.loop_exit108 ], [ 0, %polly.loop_header ]
  %p_scevgep53.moved.to..lr.ph13 = getelementptr [2000 x double]* %A, i64 %polly.indvar101, i64 %polly.indvar
  %_p_scalar_ = load double* %p_scevgep53.moved.to..lr.ph13
  br i1 %polly.loop_guard, label %polly.loop_header106, label %polly.loop_exit108

polly.loop_exit108:                               ; preds = %polly.loop_header106, %polly.loop_header97
  %polly.indvar_next102 = add nsw i64 %polly.indvar101, 1
  %polly.adjust_ub103 = sub i64 %21, 1
  %polly.loop_cond104 = icmp sle i64 %polly.indvar101, %polly.adjust_ub103
  br i1 %polly.loop_cond104, label %polly.loop_header97, label %polly.loop_exit99

polly.loop_header106:                             ; preds = %polly.loop_header97, %polly.loop_header106
  %polly.indvar110 = phi i64 [ %polly.indvar_next111, %polly.loop_header106 ], [ 0, %polly.loop_header97 ]
  %p_.moved.to.88 = mul i64 %polly.indvar101, 16000
  %p_scevgep = getelementptr [2000 x double]* %A, i64 %polly.indvar110, i64 %polly.indvar
  %p_ = mul i64 %polly.indvar110, 8
  %p_114 = add i64 %p_.moved.to.88, %p_
  %p_scevgep51 = getelementptr i8* %20, i64 %p_114
  %p_scevgep4849 = bitcast i8* %p_scevgep51 to double*
  %_p_scalar_115 = load double* %p_scevgep
  %p_116 = fmul double %_p_scalar_, %_p_scalar_115
  %_p_scalar_117 = load double* %p_scevgep4849
  %p_118 = fadd double %_p_scalar_117, %p_116
  store double %p_118, double* %p_scevgep4849
  %p_indvar.next42 = add i64 %polly.indvar110, 1
  %polly.indvar_next111 = add nsw i64 %polly.indvar110, 1
  %polly.adjust_ub112 = sub i64 %21, 1
  %polly.loop_cond113 = icmp sle i64 %polly.indvar110, %polly.adjust_ub112
  br i1 %polly.loop_cond113, label %polly.loop_header106, label %polly.loop_exit108

polly.loop_header120:                             ; preds = %polly.loop_exit, %polly.loop_exit131
  %polly.indvar124 = phi i64 [ %polly.indvar_next125, %polly.loop_exit131 ], [ 0, %polly.loop_exit ]
  %22 = mul i64 -11, %0
  %23 = add i64 %22, 5
  %24 = sub i64 %23, 32
  %25 = add i64 %24, 1
  %26 = icmp slt i64 %23, 0
  %27 = select i1 %26, i64 %25, i64 %23
  %28 = sdiv i64 %27, 32
  %29 = mul i64 -32, %28
  %30 = mul i64 -32, %0
  %31 = add i64 %29, %30
  %32 = mul i64 -32, %polly.indvar124
  %33 = mul i64 -3, %polly.indvar124
  %34 = add i64 %33, %0
  %35 = add i64 %34, 5
  %36 = sub i64 %35, 32
  %37 = add i64 %36, 1
  %38 = icmp slt i64 %35, 0
  %39 = select i1 %38, i64 %37, i64 %35
  %40 = sdiv i64 %39, 32
  %41 = mul i64 -32, %40
  %42 = add i64 %32, %41
  %43 = add i64 %42, -640
  %44 = icmp sgt i64 %31, %43
  %45 = select i1 %44, i64 %31, i64 %43
  %46 = mul i64 -20, %polly.indvar124
  %polly.loop_guard132 = icmp sle i64 %45, %46
  br i1 %polly.loop_guard132, label %polly.loop_header129, label %polly.loop_exit131

polly.loop_exit131:                               ; preds = %polly.loop_exit140, %polly.loop_header120
  %polly.indvar_next125 = add nsw i64 %polly.indvar124, 32
  %polly.adjust_ub126 = sub i64 %21, 32
  %polly.loop_cond127 = icmp sle i64 %polly.indvar124, %polly.adjust_ub126
  br i1 %polly.loop_cond127, label %polly.loop_header120, label %polly.merge

polly.loop_header129:                             ; preds = %polly.loop_header120, %polly.loop_exit140
  %polly.indvar133 = phi i64 [ %polly.indvar_next134, %polly.loop_exit140 ], [ %45, %polly.loop_header120 ]
  %47 = mul i64 -1, %polly.indvar133
  %48 = mul i64 -1, %0
  %49 = add i64 %47, %48
  %50 = add i64 %49, -30
  %51 = add i64 %50, 20
  %52 = sub i64 %51, 1
  %53 = icmp slt i64 %50, 0
  %54 = select i1 %53, i64 %50, i64 %52
  %55 = sdiv i64 %54, 20
  %56 = icmp sgt i64 %55, %polly.indvar124
  %57 = select i1 %56, i64 %55, i64 %polly.indvar124
  %58 = sub i64 %47, 20
  %59 = add i64 %58, 1
  %60 = icmp slt i64 %47, 0
  %61 = select i1 %60, i64 %59, i64 %47
  %62 = sdiv i64 %61, 20
  %63 = add i64 %polly.indvar124, 31
  %64 = icmp slt i64 %62, %63
  %65 = select i1 %64, i64 %62, i64 %63
  %66 = icmp slt i64 %65, %21
  %67 = select i1 %66, i64 %65, i64 %21
  %polly.loop_guard141 = icmp sle i64 %57, %67
  br i1 %polly.loop_guard141, label %polly.loop_header138, label %polly.loop_exit140

polly.loop_exit140:                               ; preds = %polly.loop_exit149, %polly.loop_header129
  %polly.indvar_next134 = add nsw i64 %polly.indvar133, 32
  %polly.adjust_ub135 = sub i64 %46, 32
  %polly.loop_cond136 = icmp sle i64 %polly.indvar133, %polly.adjust_ub135
  br i1 %polly.loop_cond136, label %polly.loop_header129, label %polly.loop_exit131

polly.loop_header138:                             ; preds = %polly.loop_header129, %polly.loop_exit149
  %polly.indvar142 = phi i64 [ %polly.indvar_next143, %polly.loop_exit149 ], [ %57, %polly.loop_header129 ]
  %68 = mul i64 -20, %polly.indvar142
  %69 = add i64 %68, %48
  %70 = add i64 %69, 1
  %71 = icmp sgt i64 %polly.indvar133, %70
  %72 = select i1 %71, i64 %polly.indvar133, i64 %70
  %73 = add i64 %polly.indvar133, 31
  %74 = icmp slt i64 %68, %73
  %75 = select i1 %74, i64 %68, i64 %73
  %polly.loop_guard150 = icmp sle i64 %72, %75
  br i1 %polly.loop_guard150, label %polly.loop_header147, label %polly.loop_exit149

polly.loop_exit149:                               ; preds = %polly.loop_header147, %polly.loop_header138
  %polly.indvar_next143 = add nsw i64 %polly.indvar142, 1
  %polly.adjust_ub144 = sub i64 %67, 1
  %polly.loop_cond145 = icmp sle i64 %polly.indvar142, %polly.adjust_ub144
  br i1 %polly.loop_cond145, label %polly.loop_header138, label %polly.loop_exit140

polly.loop_header147:                             ; preds = %polly.loop_header138, %polly.loop_header147
  %polly.indvar151 = phi i64 [ %polly.indvar_next152, %polly.loop_header147 ], [ %72, %polly.loop_header138 ]
  %76 = mul i64 -1, %polly.indvar151
  %77 = add i64 %68, %76
  %p_.moved.to.92 = mul i64 %polly.indvar142, 16000
  %p_scevgep36 = getelementptr [2000 x double]* %A, i64 %polly.indvar142, i64 %77
  %p_156 = mul i64 %77, 8
  %p_157 = add i64 %p_.moved.to.92, %p_156
  %p_scevgep39 = getelementptr i8* %20, i64 %p_157
  %p_scevgep35 = bitcast i8* %p_scevgep39 to double*
  %_p_scalar_158 = load double* %p_scevgep35
  store double %_p_scalar_158, double* %p_scevgep36
  %p_indvar.next = add i64 %77, 1
  %polly.indvar_next152 = add nsw i64 %polly.indvar151, 1
  %polly.adjust_ub153 = sub i64 %75, 1
  %polly.loop_cond154 = icmp sle i64 %polly.indvar151, %polly.adjust_ub153
  br i1 %polly.loop_cond154, label %polly.loop_header147, label %polly.loop_exit149

polly.then164:                                    ; preds = %.preheader5.lr.ph
  %78 = add i64 %0, -1
  %polly.loop_guard169 = icmp sle i64 0, %78
  br i1 %polly.loop_guard169, label %polly.loop_header166, label %polly.start

polly.loop_header166:                             ; preds = %polly.then164, %polly.loop_exit177
  %polly.indvar170 = phi i64 [ %polly.indvar_next171, %polly.loop_exit177 ], [ 0, %polly.then164 ]
  %79 = mul i64 -11, %0
  %80 = add i64 %79, 5
  %81 = sub i64 %80, 32
  %82 = add i64 %81, 1
  %83 = icmp slt i64 %80, 0
  %84 = select i1 %83, i64 %82, i64 %80
  %85 = sdiv i64 %84, 32
  %86 = mul i64 -32, %85
  %87 = mul i64 -32, %0
  %88 = add i64 %86, %87
  %89 = mul i64 -32, %polly.indvar170
  %90 = mul i64 -3, %polly.indvar170
  %91 = add i64 %90, %0
  %92 = add i64 %91, 5
  %93 = sub i64 %92, 32
  %94 = add i64 %93, 1
  %95 = icmp slt i64 %92, 0
  %96 = select i1 %95, i64 %94, i64 %92
  %97 = sdiv i64 %96, 32
  %98 = mul i64 -32, %97
  %99 = add i64 %89, %98
  %100 = add i64 %99, -640
  %101 = icmp sgt i64 %88, %100
  %102 = select i1 %101, i64 %88, i64 %100
  %103 = mul i64 -20, %polly.indvar170
  %polly.loop_guard178 = icmp sle i64 %102, %103
  br i1 %polly.loop_guard178, label %polly.loop_header175, label %polly.loop_exit177

polly.loop_exit177:                               ; preds = %polly.loop_exit186, %polly.loop_header166
  %polly.indvar_next171 = add nsw i64 %polly.indvar170, 32
  %polly.adjust_ub172 = sub i64 %78, 32
  %polly.loop_cond173 = icmp sle i64 %polly.indvar170, %polly.adjust_ub172
  br i1 %polly.loop_cond173, label %polly.loop_header166, label %polly.start

polly.loop_header175:                             ; preds = %polly.loop_header166, %polly.loop_exit186
  %polly.indvar179 = phi i64 [ %polly.indvar_next180, %polly.loop_exit186 ], [ %102, %polly.loop_header166 ]
  %104 = mul i64 -1, %polly.indvar179
  %105 = mul i64 -1, %0
  %106 = add i64 %104, %105
  %107 = add i64 %106, -30
  %108 = add i64 %107, 20
  %109 = sub i64 %108, 1
  %110 = icmp slt i64 %107, 0
  %111 = select i1 %110, i64 %107, i64 %109
  %112 = sdiv i64 %111, 20
  %113 = icmp sgt i64 %112, %polly.indvar170
  %114 = select i1 %113, i64 %112, i64 %polly.indvar170
  %115 = sub i64 %104, 20
  %116 = add i64 %115, 1
  %117 = icmp slt i64 %104, 0
  %118 = select i1 %117, i64 %116, i64 %104
  %119 = sdiv i64 %118, 20
  %120 = add i64 %polly.indvar170, 31
  %121 = icmp slt i64 %119, %120
  %122 = select i1 %121, i64 %119, i64 %120
  %123 = icmp slt i64 %122, %78
  %124 = select i1 %123, i64 %122, i64 %78
  %polly.loop_guard187 = icmp sle i64 %114, %124
  br i1 %polly.loop_guard187, label %polly.loop_header184, label %polly.loop_exit186

polly.loop_exit186:                               ; preds = %polly.loop_exit195, %polly.loop_header175
  %polly.indvar_next180 = add nsw i64 %polly.indvar179, 32
  %polly.adjust_ub181 = sub i64 %103, 32
  %polly.loop_cond182 = icmp sle i64 %polly.indvar179, %polly.adjust_ub181
  br i1 %polly.loop_cond182, label %polly.loop_header175, label %polly.loop_exit177

polly.loop_header184:                             ; preds = %polly.loop_header175, %polly.loop_exit195
  %polly.indvar188 = phi i64 [ %polly.indvar_next189, %polly.loop_exit195 ], [ %114, %polly.loop_header175 ]
  %125 = mul i64 -20, %polly.indvar188
  %126 = add i64 %125, %105
  %127 = add i64 %126, 1
  %128 = icmp sgt i64 %polly.indvar179, %127
  %129 = select i1 %128, i64 %polly.indvar179, i64 %127
  %130 = add i64 %polly.indvar179, 31
  %131 = icmp slt i64 %125, %130
  %132 = select i1 %131, i64 %125, i64 %130
  %polly.loop_guard196 = icmp sle i64 %129, %132
  br i1 %polly.loop_guard196, label %polly.loop_header193, label %polly.loop_exit195

polly.loop_exit195:                               ; preds = %polly.loop_header193, %polly.loop_header184
  %polly.indvar_next189 = add nsw i64 %polly.indvar188, 1
  %polly.adjust_ub190 = sub i64 %124, 1
  %polly.loop_cond191 = icmp sle i64 %polly.indvar188, %polly.adjust_ub190
  br i1 %polly.loop_cond191, label %polly.loop_header184, label %polly.loop_exit186

polly.loop_header193:                             ; preds = %polly.loop_header184, %polly.loop_header193
  %polly.indvar197 = phi i64 [ %polly.indvar_next198, %polly.loop_header193 ], [ %129, %polly.loop_header184 ]
  %133 = mul i64 -1, %polly.indvar197
  %134 = add i64 %125, %133
  %p_.moved.to.95 = mul i64 %polly.indvar188, 16000
  %p_202 = mul i64 %134, 8
  %p_203 = add i64 %p_.moved.to.95, %p_202
  %p_scevgep65 = getelementptr i8* %20, i64 %p_203
  %p_scevgep6263 = bitcast i8* %p_scevgep65 to double*
  store double 0.000000e+00, double* %p_scevgep6263
  %p_indvar.next58 = add i64 %134, 1
  %polly.indvar_next198 = add nsw i64 %polly.indvar197, 1
  %polly.adjust_ub199 = sub i64 %132, 1
  %polly.loop_cond200 = icmp sle i64 %polly.indvar197, %polly.adjust_ub199
  br i1 %polly.loop_cond200, label %polly.loop_header193, label %polly.loop_exit195

polly.cond207:                                    ; preds = %.preheader6
  %135 = srem i64 %13, 8
  %136 = icmp eq i64 %135, 0
  br i1 %136, label %polly.then212, label %polly.merge208

polly.then212:                                    ; preds = %polly.cond207
  br i1 true, label %polly.loop_header214, label %polly.merge208

polly.loop_header214:                             ; preds = %polly.then212, %polly.loop_header214
  %polly.indvar218 = phi i64 [ %polly.indvar_next219, %polly.loop_header214 ], [ 0, %polly.then212 ]
  %p_223 = add i64 %15, %polly.indvar218
  %p_scevgep76 = getelementptr [2000 x double]* %A, i64 0, i64 %p_223
  store double 0.000000e+00, double* %p_scevgep76
  %p_indvar.next74 = add i64 %polly.indvar218, 1
  %polly.indvar_next219 = add nsw i64 %polly.indvar218, 1
  %polly.adjust_ub220 = sub i64 %12, 1
  %polly.loop_cond221 = icmp sle i64 %polly.indvar218, %polly.adjust_ub220
  br i1 %polly.loop_cond221, label %polly.loop_header214, label %polly.merge208

polly.cond227:                                    ; preds = %.preheader7
  %137 = srem i64 %8, 8
  %138 = icmp eq i64 %137, 0
  %139 = icmp sge i64 %indvar69, 0
  %or.cond273 = and i1 %138, %139
  br i1 %or.cond273, label %polly.then232, label %.preheader6

polly.then232:                                    ; preds = %polly.cond227
  br i1 %139, label %polly.loop_header234, label %.preheader6

polly.loop_header234:                             ; preds = %polly.then232, %polly.loop_header234
  %polly.indvar238 = phi i64 [ %polly.indvar_next239, %polly.loop_header234 ], [ 0, %polly.then232 ]
  %p_scevgep72 = getelementptr [2000 x double]* %A, i64 %indvar69, i64 %polly.indvar238
  %p_243 = mul i64 %polly.indvar238, -1
  %p_244 = trunc i64 %p_243 to i32
  %p_245 = srem i32 %p_244, %n
  %p_246 = sitofp i32 %p_245 to double
  %p_247 = fdiv double %p_246, %7
  %p_248 = fadd double %p_247, 1.000000e+00
  store double %p_248, double* %p_scevgep72
  %p_indvar.next68 = add i64 %polly.indvar238, 1
  %polly.indvar_next239 = add nsw i64 %polly.indvar238, 1
  %polly.adjust_ub240 = sub i64 %indvar69, 1
  %polly.loop_cond241 = icmp sle i64 %polly.indvar238, %polly.adjust_ub240
  br i1 %polly.loop_cond241, label %polly.loop_header234, label %.preheader6

polly.merge253:                                   ; preds = %polly.then254, %polly.loop_header256, %polly.split_new_and_old249
  %140 = icmp sgt i32 %n, 0
  br i1 %140, label %.preheader7.lr.ph, label %._crit_edge29

polly.then254:                                    ; preds = %polly.split_new_and_old249
  %141 = add i64 %0, -1
  %polly.loop_guard259 = icmp sle i64 0, %141
  br i1 %polly.loop_guard259, label %polly.loop_header256, label %polly.merge253

polly.loop_header256:                             ; preds = %polly.then254, %polly.loop_header256
  %polly.indvar260 = phi i64 [ %polly.indvar_next261, %polly.loop_header256 ], [ 0, %polly.then254 ]
  %p_.moved.to. = sitofp i32 %n to double
  %p_scevgep84 = getelementptr double* %x, i64 %polly.indvar260
  %p_scevgep85 = getelementptr double* %y, i64 %polly.indvar260
  %p_265 = add i64 %polly.indvar260, 1
  %p_266 = trunc i64 %p_265 to i32
  %p_scevgep86 = getelementptr double* %b, i64 %polly.indvar260
  store double 0.000000e+00, double* %p_scevgep84
  store double 0.000000e+00, double* %p_scevgep85
  %p_267 = sitofp i32 %p_266 to double
  %p_268 = fdiv double %p_267, %p_.moved.to.
  %p_269 = fmul double %p_268, 5.000000e-01
  %p_270 = fadd double %p_269, 4.000000e+00
  store double %p_270, double* %p_scevgep86
  %polly.indvar_next261 = add nsw i64 %polly.indvar260, 1
  %polly.adjust_ub262 = sub i64 %141, 1
  %polly.loop_cond263 = icmp sle i64 %polly.indvar260, %polly.adjust_ub262
  br i1 %polly.loop_cond263, label %polly.loop_header256, label %polly.merge253
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_ludcmp(i32 %n, [2000 x double]* noalias %A, double* noalias %b, double* noalias %x, double* noalias %y) #0 {
.split:
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.preheader3.lr.ph, label %polly.start109

.preheader3.lr.ph:                                ; preds = %.split
  %1 = add i32 %n, -1
  %2 = zext i32 %n to i64
  %3 = zext i32 %1 to i64
  br label %.preheader3

.preheader3:                                      ; preds = %.preheader3.lr.ph, %polly.merge157
  %4 = phi i64 [ 0, %.preheader3.lr.ph ], [ %indvar.next72, %polly.merge157 ]
  %5 = trunc i64 %4 to i32
  %6 = mul i64 %4, -1
  %7 = add i64 %3, %6
  %8 = trunc i64 %7 to i32
  %9 = zext i32 %8 to i64
  %10 = mul i64 %4, 16008
  %11 = mul i64 %4, 2001
  %12 = add i64 %9, 1
  %13 = icmp sgt i32 %5, 0
  %14 = icmp sge i64 %4, 1
  %or.cond = and i1 %13, %14
  br i1 %or.cond, label %polly.stmt.343, label %.preheader2

.preheader2:                                      ; preds = %polly.stmt.343, %polly.loop_exit366, %.preheader3
  %15 = icmp slt i32 %5, %n
  br i1 %15, label %.lr.ph37, label %polly.merge157

.lr.ph37:                                         ; preds = %.preheader2
  br i1 true, label %polly.cond159, label %polly.merge157

polly.merge157:                                   ; preds = %polly.then322, %polly.loop_header324, %polly.cond320, %polly.cond317, %.lr.ph37, %.preheader2
  %indvar.next72 = add i64 %4, 1
  %exitcond89 = icmp ne i64 %indvar.next72, %2
  br i1 %exitcond89, label %.preheader3, label %polly.start109

.lr.ph11:                                         ; preds = %polly.merge112
  %16 = mul i64 %37, 2001
  %17 = add i64 %37, -1
  %18 = add i64 %16, -1
  br label %19

; <label>:19                                      ; preds = %.lr.ph11, %33
  %indvar46 = phi i64 [ 0, %.lr.ph11 ], [ %indvar.next47, %33 ]
  %20 = add i64 %indvar46, -1
  %21 = trunc i64 %20 to i32
  %22 = zext i32 %21 to i64
  %23 = mul i64 %indvar46, -1
  %24 = add i64 %37, %23
  %25 = mul i64 %indvar46, -2001
  %26 = add i64 %16, %25
  %27 = add i64 %17, %23
  %scevgep52 = getelementptr double* %y, i64 %27
  %28 = add i64 %18, %25
  %scevgep53 = getelementptr [2000 x double]* %A, i64 -1, i64 %28
  %scevgep54 = getelementptr double* %x, i64 %27
  %29 = add i64 %36, %23
  %i.2.in9 = trunc i64 %29 to i32
  %30 = add i64 %22, 1
  %31 = load double* %scevgep52, align 8, !tbaa !6
  %32 = icmp slt i32 %i.2.in9, %n
  br i1 %32, label %.lr.ph, label %33

.lr.ph:                                           ; preds = %19
  br i1 true, label %polly.then, label %polly.stmt.._crit_edge

; <label>:33                                      ; preds = %polly.stmt.._crit_edge, %19
  %w.3.lcssa.reg2mem.0 = phi double [ %w.36.reg2mem.0, %polly.stmt.._crit_edge ], [ %31, %19 ]
  %34 = load double* %scevgep53, align 8, !tbaa !6
  %35 = fdiv double %w.3.lcssa.reg2mem.0, %34
  store double %35, double* %scevgep54, align 8, !tbaa !6
  %indvar.next47 = add i64 %indvar46, 1
  %exitcond49 = icmp ne i64 %indvar.next47, %36
  br i1 %exitcond49, label %19, label %._crit_edge12

._crit_edge12:                                    ; preds = %33, %polly.merge112
  ret void

polly.stmt.._crit_edge:                           ; preds = %polly.then, %polly.loop_header, %.lr.ph
  %w.36.reg2mem.0 = phi double [ %p_106, %polly.loop_header ], [ %31, %polly.then ], [ %31, %.lr.ph ]
  br label %33

polly.then:                                       ; preds = %.lr.ph
  br i1 true, label %polly.loop_header, label %polly.stmt.._crit_edge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %w.36.reg2mem.1 = phi double [ %31, %polly.then ], [ %p_106, %polly.loop_header ]
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_ = add i64 %24, %polly.indvar
  %p_scevgep48 = getelementptr double* %x, i64 %p_
  %p_103 = add i64 %26, %polly.indvar
  %p_scevgep = getelementptr [2000 x double]* %A, i64 -1, i64 %p_103
  %_p_scalar_ = load double* %p_scevgep
  %_p_scalar_104 = load double* %p_scevgep48
  %p_105 = fmul double %_p_scalar_, %_p_scalar_104
  %p_106 = fsub double %w.36.reg2mem.1, %p_105
  %p_indvar.next = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %22, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.stmt.._crit_edge

polly.start109:                                   ; preds = %polly.merge157, %.split
  %36 = zext i32 %n to i64
  %37 = sext i32 %n to i64
  %38 = icmp sge i64 %37, 1
  %39 = icmp sge i64 %36, 1
  %40 = and i1 %38, %39
  br i1 %40, label %polly.stmt.114, label %polly.merge112

polly.merge112:                                   ; preds = %polly.stmt.114, %polly.loop_exit135, %polly.start109
  br i1 %0, label %.lr.ph11, label %._crit_edge12

polly.stmt.114:                                   ; preds = %polly.start109
  %_p_scalar_115 = load double* %b
  store double %_p_scalar_115, double* %y
  %41 = add i64 %36, -1
  %polly.loop_guard122 = icmp sle i64 1, %41
  br i1 %polly.loop_guard122, label %polly.loop_header119, label %polly.merge112

polly.loop_header119:                             ; preds = %polly.stmt.114, %polly.loop_exit135
  %polly.indvar123 = phi i64 [ %polly.indvar_next124, %polly.loop_exit135 ], [ 1, %polly.stmt.114 ]
  %p_i.120128 = trunc i64 %polly.indvar123 to i32
  %p_scevgep64129 = getelementptr double* %b, i64 %polly.indvar123
  %_p_scalar_130 = load double* %p_scevgep64129
  %42 = add i64 %polly.indvar123, -1
  %polly.loop_guard136 = icmp sle i64 0, %42
  br i1 %polly.loop_guard136, label %polly.loop_header133, label %polly.loop_exit135

polly.loop_exit135:                               ; preds = %polly.loop_header133, %polly.loop_header119
  %w.214.reg2mem.0 = phi double [ %p_145, %polly.loop_header133 ], [ %_p_scalar_130, %polly.loop_header119 ]
  %p_scevgep65.moved.to.148 = getelementptr double* %y, i64 %polly.indvar123
  store double %w.214.reg2mem.0, double* %p_scevgep65.moved.to.148
  %p_indvar.next58151 = add i64 %polly.indvar123, 1
  %polly.indvar_next124 = add nsw i64 %polly.indvar123, 1
  %polly.adjust_ub125 = sub i64 %41, 1
  %polly.loop_cond126 = icmp sle i64 %polly.indvar123, %polly.adjust_ub125
  br i1 %polly.loop_cond126, label %polly.loop_header119, label %polly.merge112

polly.loop_header133:                             ; preds = %polly.loop_header119, %polly.loop_header133
  %w.214.reg2mem.1 = phi double [ %_p_scalar_130, %polly.loop_header119 ], [ %p_145, %polly.loop_header133 ]
  %polly.indvar137 = phi i64 [ %polly.indvar_next138, %polly.loop_header133 ], [ 0, %polly.loop_header119 ]
  %p_scevgep60 = getelementptr [2000 x double]* %A, i64 %polly.indvar123, i64 %polly.indvar137
  %p_scevgep61 = getelementptr double* %y, i64 %polly.indvar137
  %_p_scalar_142 = load double* %p_scevgep60
  %_p_scalar_143 = load double* %p_scevgep61
  %p_144 = fmul double %_p_scalar_142, %_p_scalar_143
  %p_145 = fsub double %w.214.reg2mem.1, %p_144
  %p_indvar.next56 = add i64 %polly.indvar137, 1
  %polly.indvar_next138 = add nsw i64 %polly.indvar137, 1
  %polly.adjust_ub139 = sub i64 %42, 1
  %polly.loop_cond140 = icmp sle i64 %polly.indvar137, %polly.adjust_ub139
  br i1 %polly.loop_cond140, label %polly.loop_header133, label %polly.loop_exit135

polly.cond159:                                    ; preds = %.lr.ph37
  %43 = srem i64 %10, 8
  %44 = icmp eq i64 %43, 0
  br i1 %44, label %polly.cond162, label %polly.cond193

polly.cond193:                                    ; preds = %polly.then164, %polly.loop_exit180, %polly.cond162, %polly.cond159
  %45 = add i64 %10, 7
  %46 = srem i64 %45, 8
  %47 = icmp sle i64 %46, 6
  br i1 %47, label %polly.cond196, label %polly.cond237

polly.cond237:                                    ; preds = %polly.then198, %polly.loop_exit218, %polly.cond196, %polly.cond193
  br i1 %44, label %polly.cond240, label %polly.cond267

polly.cond267:                                    ; preds = %polly.then242, %polly.loop_header244, %polly.cond240, %polly.cond237
  br i1 %47, label %polly.cond270, label %polly.cond291

polly.cond291:                                    ; preds = %polly.then272, %polly.loop_header274, %polly.cond270, %polly.cond267
  br i1 %44, label %polly.cond294, label %polly.cond317

polly.cond317:                                    ; preds = %polly.then296, %polly.loop_header298, %polly.cond294, %polly.cond291
  br i1 %47, label %polly.cond320, label %polly.merge157

polly.cond162:                                    ; preds = %polly.cond159
  %48 = sext i32 %5 to i64
  %49 = icmp sge i64 %48, 1
  %50 = and i1 %49, %14
  br i1 %50, label %polly.then164, label %polly.cond193

polly.then164:                                    ; preds = %polly.cond162
  br i1 true, label %polly.loop_header166, label %polly.cond193

polly.loop_header166:                             ; preds = %polly.then164, %polly.loop_exit180
  %polly.indvar170 = phi i64 [ %polly.indvar_next171, %polly.loop_exit180 ], [ 0, %polly.then164 ]
  %p_175 = add i64 %11, %polly.indvar170
  %p_scevgep88 = getelementptr [2000 x double]* %A, i64 0, i64 %p_175
  %_p_scalar_176 = load double* %p_scevgep88
  %51 = add i64 %4, -1
  %polly.loop_guard181 = icmp sle i64 0, %51
  br i1 %polly.loop_guard181, label %polly.loop_header178, label %polly.loop_exit180

polly.loop_exit180:                               ; preds = %polly.loop_header178, %polly.loop_header166
  %w.131.reg2mem.0 = phi double [ %p_190, %polly.loop_header178 ], [ %_p_scalar_176, %polly.loop_header166 ]
  store double %w.131.reg2mem.0, double* %p_scevgep88
  %p_indvar.next84 = add i64 %polly.indvar170, 1
  %polly.indvar_next171 = add nsw i64 %polly.indvar170, 1
  %polly.adjust_ub172 = sub i64 %9, 1
  %polly.loop_cond173 = icmp sle i64 %polly.indvar170, %polly.adjust_ub172
  br i1 %polly.loop_cond173, label %polly.loop_header166, label %polly.cond193

polly.loop_header178:                             ; preds = %polly.loop_header166, %polly.loop_header178
  %w.131.reg2mem.1 = phi double [ %_p_scalar_176, %polly.loop_header166 ], [ %p_190, %polly.loop_header178 ]
  %polly.indvar182 = phi i64 [ %polly.indvar_next183, %polly.loop_header178 ], [ 0, %polly.loop_header166 ]
  %p_.moved.to.96 = add i64 %4, %polly.indvar170
  %p_scevgep85 = getelementptr [2000 x double]* %A, i64 %polly.indvar182, i64 %p_.moved.to.96
  %p_scevgep82 = getelementptr [2000 x double]* %A, i64 %4, i64 %polly.indvar182
  %_p_scalar_187 = load double* %p_scevgep82
  %_p_scalar_188 = load double* %p_scevgep85
  %p_189 = fmul double %_p_scalar_187, %_p_scalar_188
  %p_190 = fsub double %w.131.reg2mem.1, %p_189
  %p_indvar.next80 = add i64 %polly.indvar182, 1
  %polly.indvar_next183 = add nsw i64 %polly.indvar182, 1
  %polly.adjust_ub184 = sub i64 %51, 1
  %polly.loop_cond185 = icmp sle i64 %polly.indvar182, %polly.adjust_ub184
  br i1 %polly.loop_cond185, label %polly.loop_header178, label %polly.loop_exit180

polly.cond196:                                    ; preds = %polly.cond193
  %52 = sext i32 %5 to i64
  %53 = icmp sge i64 %52, 1
  %54 = and i1 %53, %14
  br i1 %54, label %polly.then198, label %polly.cond237

polly.then198:                                    ; preds = %polly.cond196
  br i1 true, label %polly.loop_header200, label %polly.cond237

polly.loop_header200:                             ; preds = %polly.then198, %polly.loop_exit218
  %polly.indvar204 = phi i64 [ %polly.indvar_next205, %polly.loop_exit218 ], [ 0, %polly.then198 ]
  %p_210 = add i64 %11, %polly.indvar204
  %p_scevgep88211 = getelementptr [2000 x double]* %A, i64 0, i64 %p_210
  %_p_scalar_212 = load double* %p_scevgep88211
  %55 = add i64 %4, -1
  %polly.loop_guard219 = icmp sle i64 0, %55
  br i1 %polly.loop_guard219, label %polly.loop_header216, label %polly.loop_exit218

polly.loop_exit218:                               ; preds = %polly.loop_header216, %polly.loop_header200
  %polly.indvar_next205 = add nsw i64 %polly.indvar204, 1
  %polly.adjust_ub206 = sub i64 %9, 1
  %polly.loop_cond207 = icmp sle i64 %polly.indvar204, %polly.adjust_ub206
  br i1 %polly.loop_cond207, label %polly.loop_header200, label %polly.cond237

polly.loop_header216:                             ; preds = %polly.loop_header200, %polly.loop_header216
  %w.131.reg2mem.3 = phi double [ %_p_scalar_212, %polly.loop_header200 ], [ %p_232, %polly.loop_header216 ]
  %polly.indvar220 = phi i64 [ %polly.indvar_next221, %polly.loop_header216 ], [ 0, %polly.loop_header200 ]
  %p_.moved.to.96225 = add i64 %4, %polly.indvar204
  %p_scevgep85227 = getelementptr [2000 x double]* %A, i64 %polly.indvar220, i64 %p_.moved.to.96225
  %p_scevgep82228 = getelementptr [2000 x double]* %A, i64 %4, i64 %polly.indvar220
  %_p_scalar_229 = load double* %p_scevgep82228
  %_p_scalar_230 = load double* %p_scevgep85227
  %p_231 = fmul double %_p_scalar_229, %_p_scalar_230
  %p_232 = fsub double %w.131.reg2mem.3, %p_231
  %p_indvar.next80233 = add i64 %polly.indvar220, 1
  %polly.indvar_next221 = add nsw i64 %polly.indvar220, 1
  %polly.adjust_ub222 = sub i64 %55, 1
  %polly.loop_cond223 = icmp sle i64 %polly.indvar220, %polly.adjust_ub222
  br i1 %polly.loop_cond223, label %polly.loop_header216, label %polly.loop_exit218

polly.cond240:                                    ; preds = %polly.cond237
  %56 = sext i32 %5 to i64
  %57 = icmp sge i64 %56, 1
  %58 = icmp sle i64 %4, 0
  %59 = and i1 %57, %58
  br i1 %59, label %polly.then242, label %polly.cond267

polly.then242:                                    ; preds = %polly.cond240
  br i1 true, label %polly.loop_header244, label %polly.cond267

polly.loop_header244:                             ; preds = %polly.then242, %polly.loop_header244
  %polly.indvar248 = phi i64 [ %polly.indvar_next249, %polly.loop_header244 ], [ 0, %polly.then242 ]
  %p_254 = add i64 %11, %polly.indvar248
  %p_scevgep88255 = getelementptr [2000 x double]* %A, i64 0, i64 %p_254
  %_p_scalar_256 = load double* %p_scevgep88255
  store double %_p_scalar_256, double* %p_scevgep88255
  %p_indvar.next84265 = add i64 %polly.indvar248, 1
  %polly.indvar_next249 = add nsw i64 %polly.indvar248, 1
  %polly.adjust_ub250 = sub i64 %9, 1
  %polly.loop_cond251 = icmp sle i64 %polly.indvar248, %polly.adjust_ub250
  br i1 %polly.loop_cond251, label %polly.loop_header244, label %polly.cond267

polly.cond270:                                    ; preds = %polly.cond267
  %60 = sext i32 %5 to i64
  %61 = icmp sge i64 %60, 1
  %62 = icmp sle i64 %4, 0
  %63 = and i1 %61, %62
  br i1 %63, label %polly.then272, label %polly.cond291

polly.then272:                                    ; preds = %polly.cond270
  br i1 true, label %polly.loop_header274, label %polly.cond291

polly.loop_header274:                             ; preds = %polly.then272, %polly.loop_header274
  %polly.indvar278 = phi i64 [ %polly.indvar_next279, %polly.loop_header274 ], [ 0, %polly.then272 ]
  %p_284 = add i64 %11, %polly.indvar278
  %p_scevgep88285 = getelementptr [2000 x double]* %A, i64 0, i64 %p_284
  %polly.indvar_next279 = add nsw i64 %polly.indvar278, 1
  %polly.adjust_ub280 = sub i64 %9, 1
  %polly.loop_cond281 = icmp sle i64 %polly.indvar278, %polly.adjust_ub280
  br i1 %polly.loop_cond281, label %polly.loop_header274, label %polly.cond291

polly.cond294:                                    ; preds = %polly.cond291
  %64 = sext i32 %5 to i64
  %65 = icmp sle i64 %64, 0
  br i1 %65, label %polly.then296, label %polly.cond317

polly.then296:                                    ; preds = %polly.cond294
  br i1 true, label %polly.loop_header298, label %polly.cond317

polly.loop_header298:                             ; preds = %polly.then296, %polly.loop_header298
  %polly.indvar302 = phi i64 [ %polly.indvar_next303, %polly.loop_header298 ], [ 0, %polly.then296 ]
  %p_308 = add i64 %11, %polly.indvar302
  %p_scevgep88309 = getelementptr [2000 x double]* %A, i64 0, i64 %p_308
  %_p_scalar_310 = load double* %p_scevgep88309
  store double %_p_scalar_310, double* %p_scevgep88309
  %p_indvar.next84315 = add i64 %polly.indvar302, 1
  %polly.indvar_next303 = add nsw i64 %polly.indvar302, 1
  %polly.adjust_ub304 = sub i64 %9, 1
  %polly.loop_cond305 = icmp sle i64 %polly.indvar302, %polly.adjust_ub304
  br i1 %polly.loop_cond305, label %polly.loop_header298, label %polly.cond317

polly.cond320:                                    ; preds = %polly.cond317
  %66 = sext i32 %5 to i64
  %67 = icmp sle i64 %66, 0
  br i1 %67, label %polly.then322, label %polly.merge157

polly.then322:                                    ; preds = %polly.cond320
  br i1 true, label %polly.loop_header324, label %polly.merge157

polly.loop_header324:                             ; preds = %polly.then322, %polly.loop_header324
  %polly.indvar328 = phi i64 [ %polly.indvar_next329, %polly.loop_header324 ], [ 0, %polly.then322 ]
  %p_334 = add i64 %11, %polly.indvar328
  %p_scevgep88335 = getelementptr [2000 x double]* %A, i64 0, i64 %p_334
  %polly.indvar_next329 = add nsw i64 %polly.indvar328, 1
  %polly.adjust_ub330 = sub i64 %9, 1
  %polly.loop_cond331 = icmp sle i64 %polly.indvar328, %polly.adjust_ub330
  br i1 %polly.loop_cond331, label %polly.loop_header324, label %polly.merge157

polly.stmt.343:                                   ; preds = %.preheader3
  %p_scevgep77 = getelementptr [2000 x double]* %A, i64 %4, i64 0
  %_p_scalar_344 = load double* %p_scevgep77
  %p_scevgep78.moved.to. = getelementptr [2000 x double]* %A, i64 0, i64 0
  %_p_scalar_347 = load double* %p_scevgep78.moved.to.
  %p_348 = fdiv double %_p_scalar_344, %_p_scalar_347
  store double %p_348, double* %p_scevgep77
  %68 = add i64 %4, -1
  %polly.loop_guard353 = icmp sle i64 1, %68
  br i1 %polly.loop_guard353, label %polly.loop_header350, label %.preheader2

polly.loop_header350:                             ; preds = %polly.stmt.343, %polly.loop_exit366
  %polly.indvar354 = phi i64 [ %polly.indvar_next355, %polly.loop_exit366 ], [ 1, %polly.stmt.343 ]
  %p_scevgep77359 = getelementptr [2000 x double]* %A, i64 %4, i64 %polly.indvar354
  %p_j.028360 = trunc i64 %polly.indvar354 to i32
  %_p_scalar_361 = load double* %p_scevgep77359
  %69 = add i64 %polly.indvar354, -1
  %polly.loop_guard367 = icmp sle i64 0, %69
  br i1 %polly.loop_guard367, label %polly.loop_header364, label %polly.loop_exit366

polly.loop_exit366:                               ; preds = %polly.loop_header364, %polly.loop_header350
  %w.023.reg2mem.0 = phi double [ %p_376, %polly.loop_header364 ], [ %_p_scalar_361, %polly.loop_header350 ]
  %p_.moved.to.379 = mul i64 %polly.indvar354, 2001
  %p_scevgep78.moved.to.380 = getelementptr [2000 x double]* %A, i64 0, i64 %p_.moved.to.379
  %_p_scalar_383 = load double* %p_scevgep78.moved.to.380
  %p_384 = fdiv double %w.023.reg2mem.0, %_p_scalar_383
  store double %p_384, double* %p_scevgep77359
  %p_indvar.next69385 = add i64 %polly.indvar354, 1
  %polly.indvar_next355 = add nsw i64 %polly.indvar354, 1
  %polly.adjust_ub356 = sub i64 %68, 1
  %polly.loop_cond357 = icmp sle i64 %polly.indvar354, %polly.adjust_ub356
  br i1 %polly.loop_cond357, label %polly.loop_header350, label %.preheader2

polly.loop_header364:                             ; preds = %polly.loop_header350, %polly.loop_header364
  %w.023.reg2mem.1 = phi double [ %_p_scalar_361, %polly.loop_header350 ], [ %p_376, %polly.loop_header364 ]
  %polly.indvar368 = phi i64 [ %polly.indvar_next369, %polly.loop_header364 ], [ 0, %polly.loop_header350 ]
  %p_scevgep73 = getelementptr [2000 x double]* %A, i64 %4, i64 %polly.indvar368
  %p_scevgep74 = getelementptr [2000 x double]* %A, i64 %polly.indvar368, i64 %polly.indvar354
  %_p_scalar_373 = load double* %p_scevgep73
  %_p_scalar_374 = load double* %p_scevgep74
  %p_375 = fmul double %_p_scalar_373, %_p_scalar_374
  %p_376 = fsub double %w.023.reg2mem.1, %p_375
  %p_indvar.next67 = add i64 %polly.indvar368, 1
  %polly.indvar_next369 = add nsw i64 %polly.indvar368, 1
  %polly.adjust_ub370 = sub i64 %69, 1
  %polly.loop_cond371 = icmp sle i64 %polly.indvar368, %polly.adjust_ub370
  br i1 %polly.loop_cond371, label %polly.loop_header364, label %polly.loop_exit366
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, double* noalias %x) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %n, 0
  br i1 %5, label %.lr.ph, label %16

.lr.ph:                                           ; preds = %.split
  %6 = zext i32 %n to i64
  br label %7

; <label>:7                                       ; preds = %.lr.ph, %12
  %indvar = phi i64 [ 0, %.lr.ph ], [ %indvar.next, %12 ]
  %i.01 = trunc i64 %indvar to i32
  %scevgep = getelementptr double* %x, i64 %indvar
  %8 = srem i32 %i.01, 20
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %10, label %12

; <label>:10                                      ; preds = %7
  %11 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %11) #4
  br label %12

; <label>:12                                      ; preds = %10, %7
  %13 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %14 = load double* %scevgep, align 8, !tbaa !6
  %15 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %13, i8* getelementptr inbounds ([8 x i8]* @.str5, i64 0, i64 0), double %14) #5
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %6
  br i1 %exitcond, label %7, label %._crit_edge

._crit_edge:                                      ; preds = %12
  br label %16

; <label>:16                                      ; preds = %._crit_edge, %.split
  %17 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %18 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %17, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %19 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %20 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str7, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %19) #4
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
