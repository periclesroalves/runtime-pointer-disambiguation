; ModuleID = './linear-algebra/solvers/cholesky/cholesky.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %0 = tail call i8* @polybench_alloc_data(i64 4000000, i32 8) #3
  %1 = bitcast i8* %0 to [2000 x double]*
  tail call void @init_array(i32 2000, [2000 x double]* %1)
  tail call void (...)* @polybench_timer_start() #3
  tail call void @kernel_cholesky(i32 2000, [2000 x double]* %1)
  tail call void (...)* @polybench_timer_stop() #3
  tail call void (...)* @polybench_timer_print() #3
  %2 = icmp sgt i32 %argc, 42
  br i1 %2, label %3, label %7

; <label>:3                                       ; preds = %.split
  %4 = load i8** %argv, align 8, !tbaa !1
  %5 = load i8* %4, align 1, !tbaa !5
  %phitmp = icmp eq i8 %5, 0
  br i1 %phitmp, label %6, label %7

; <label>:6                                       ; preds = %3
  tail call void @print_array(i32 2000, [2000 x double]* %1)
  br label %7

; <label>:7                                       ; preds = %3, %6, %.split
  tail call void @free(i8* %0) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %n, [2000 x double]* noalias %A) #0 {
.split:
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.preheader7.lr.ph, label %._crit_edge28

.preheader7.lr.ph:                                ; preds = %.split
  %1 = add i32 %n, -2
  %2 = zext i32 %n to i64
  %3 = zext i32 %1 to i64
  %4 = sitofp i32 %n to double
  br label %.preheader7

.preheader7:                                      ; preds = %.preheader7.lr.ph, %polly.merge196
  %indvar65 = phi i64 [ 0, %.preheader7.lr.ph ], [ %13, %polly.merge196 ]
  %5 = mul i64 %indvar65, 16000
  %6 = mul i64 %indvar65, -1
  %7 = add i64 %3, %6
  %8 = trunc i64 %7 to i32
  %9 = zext i32 %8 to i64
  %10 = mul i64 %indvar65, 16008
  %i.027 = trunc i64 %indvar65 to i32
  %11 = mul i64 %indvar65, 2001
  %12 = add i64 %11, 1
  %13 = add i64 %indvar65, 1
  %j.123 = trunc i64 %13 to i32
  %scevgep76 = getelementptr [2000 x double]* %A, i64 0, i64 %11
  %14 = add i64 %9, 1
  %15 = icmp slt i32 %i.027, 0
  br i1 %15, label %.preheader6, label %polly.cond215

.preheader6:                                      ; preds = %polly.then220, %polly.loop_header222, %polly.cond215, %.preheader7
  %16 = icmp slt i32 %j.123, %n
  br i1 %16, label %polly.cond195, label %polly.merge196

polly.merge196:                                   ; preds = %polly.then200, %polly.loop_header202, %polly.cond195, %.preheader6
  store double 1.000000e+00, double* %scevgep76, align 8, !tbaa !6
  %exitcond73 = icmp ne i64 %13, %2
  br i1 %exitcond73, label %.preheader7, label %._crit_edge28

._crit_edge28:                                    ; preds = %polly.merge196, %.split
  %17 = tail call i8* @polybench_alloc_data(i64 4000000, i32 8) #3
  br i1 %0, label %.preheader5.lr.ph, label %polly.start

.preheader5.lr.ph:                                ; preds = %._crit_edge28
  %18 = zext i32 %n to i64
  %19 = sext i32 %n to i64
  %20 = icmp sge i64 %19, 1
  %21 = icmp sge i64 %18, 1
  %22 = and i1 %20, %21
  br i1 %22, label %polly.then152, label %polly.start

polly.start:                                      ; preds = %polly.then152, %polly.loop_exit165, %.preheader5.lr.ph, %._crit_edge28
  %23 = zext i32 %n to i64
  %24 = sext i32 %n to i64
  %25 = icmp sge i64 %24, 1
  %26 = icmp sge i64 %23, 1
  %27 = and i1 %25, %26
  br i1 %27, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.loop_exit, %polly.loop_exit119, %polly.start
  tail call void @free(i8* %17) #3
  ret void

polly.then:                                       ; preds = %polly.start
  %28 = add i64 %23, -1
  %polly.loop_guard = icmp sle i64 0, %28
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.loop_exit

polly.loop_exit:                                  ; preds = %polly.loop_exit87, %polly.then
  br i1 %polly.loop_guard, label %polly.loop_header108, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit87
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit87 ], [ 0, %polly.then ]
  br i1 %polly.loop_guard, label %polly.loop_header85, label %polly.loop_exit87

polly.loop_exit87:                                ; preds = %polly.loop_exit96, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %28, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.loop_exit

polly.loop_header85:                              ; preds = %polly.loop_header, %polly.loop_exit96
  %polly.indvar89 = phi i64 [ %polly.indvar_next90, %polly.loop_exit96 ], [ 0, %polly.loop_header ]
  %p_scevgep49.moved.to..lr.ph12 = getelementptr [2000 x double]* %A, i64 %polly.indvar89, i64 %polly.indvar
  %_p_scalar_ = load double* %p_scevgep49.moved.to..lr.ph12
  br i1 %polly.loop_guard, label %polly.loop_header94, label %polly.loop_exit96

polly.loop_exit96:                                ; preds = %polly.loop_header94, %polly.loop_header85
  %polly.indvar_next90 = add nsw i64 %polly.indvar89, 1
  %polly.adjust_ub91 = sub i64 %28, 1
  %polly.loop_cond92 = icmp sle i64 %polly.indvar89, %polly.adjust_ub91
  br i1 %polly.loop_cond92, label %polly.loop_header85, label %polly.loop_exit87

polly.loop_header94:                              ; preds = %polly.loop_header85, %polly.loop_header94
  %polly.indvar98 = phi i64 [ %polly.indvar_next99, %polly.loop_header94 ], [ 0, %polly.loop_header85 ]
  %p_.moved.to.77 = mul i64 %polly.indvar89, 16000
  %p_scevgep = getelementptr [2000 x double]* %A, i64 %polly.indvar98, i64 %polly.indvar
  %p_ = mul i64 %polly.indvar98, 8
  %p_102 = add i64 %p_.moved.to.77, %p_
  %p_scevgep47 = getelementptr i8* %17, i64 %p_102
  %p_scevgep4445 = bitcast i8* %p_scevgep47 to double*
  %_p_scalar_103 = load double* %p_scevgep
  %p_104 = fmul double %_p_scalar_, %_p_scalar_103
  %_p_scalar_105 = load double* %p_scevgep4445
  %p_106 = fadd double %_p_scalar_105, %p_104
  store double %p_106, double* %p_scevgep4445
  %p_indvar.next38 = add i64 %polly.indvar98, 1
  %polly.indvar_next99 = add nsw i64 %polly.indvar98, 1
  %polly.adjust_ub100 = sub i64 %28, 1
  %polly.loop_cond101 = icmp sle i64 %polly.indvar98, %polly.adjust_ub100
  br i1 %polly.loop_cond101, label %polly.loop_header94, label %polly.loop_exit96

polly.loop_header108:                             ; preds = %polly.loop_exit, %polly.loop_exit119
  %polly.indvar112 = phi i64 [ %polly.indvar_next113, %polly.loop_exit119 ], [ 0, %polly.loop_exit ]
  %29 = mul i64 -11, %23
  %30 = add i64 %29, 5
  %31 = sub i64 %30, 32
  %32 = add i64 %31, 1
  %33 = icmp slt i64 %30, 0
  %34 = select i1 %33, i64 %32, i64 %30
  %35 = sdiv i64 %34, 32
  %36 = mul i64 -32, %35
  %37 = mul i64 -32, %23
  %38 = add i64 %36, %37
  %39 = mul i64 -32, %polly.indvar112
  %40 = mul i64 -3, %polly.indvar112
  %41 = add i64 %40, %23
  %42 = add i64 %41, 5
  %43 = sub i64 %42, 32
  %44 = add i64 %43, 1
  %45 = icmp slt i64 %42, 0
  %46 = select i1 %45, i64 %44, i64 %42
  %47 = sdiv i64 %46, 32
  %48 = mul i64 -32, %47
  %49 = add i64 %39, %48
  %50 = add i64 %49, -640
  %51 = icmp sgt i64 %38, %50
  %52 = select i1 %51, i64 %38, i64 %50
  %53 = mul i64 -20, %polly.indvar112
  %polly.loop_guard120 = icmp sle i64 %52, %53
  br i1 %polly.loop_guard120, label %polly.loop_header117, label %polly.loop_exit119

polly.loop_exit119:                               ; preds = %polly.loop_exit128, %polly.loop_header108
  %polly.indvar_next113 = add nsw i64 %polly.indvar112, 32
  %polly.adjust_ub114 = sub i64 %28, 32
  %polly.loop_cond115 = icmp sle i64 %polly.indvar112, %polly.adjust_ub114
  br i1 %polly.loop_cond115, label %polly.loop_header108, label %polly.merge

polly.loop_header117:                             ; preds = %polly.loop_header108, %polly.loop_exit128
  %polly.indvar121 = phi i64 [ %polly.indvar_next122, %polly.loop_exit128 ], [ %52, %polly.loop_header108 ]
  %54 = mul i64 -1, %polly.indvar121
  %55 = mul i64 -1, %23
  %56 = add i64 %54, %55
  %57 = add i64 %56, -30
  %58 = add i64 %57, 20
  %59 = sub i64 %58, 1
  %60 = icmp slt i64 %57, 0
  %61 = select i1 %60, i64 %57, i64 %59
  %62 = sdiv i64 %61, 20
  %63 = icmp sgt i64 %62, %polly.indvar112
  %64 = select i1 %63, i64 %62, i64 %polly.indvar112
  %65 = sub i64 %54, 20
  %66 = add i64 %65, 1
  %67 = icmp slt i64 %54, 0
  %68 = select i1 %67, i64 %66, i64 %54
  %69 = sdiv i64 %68, 20
  %70 = add i64 %polly.indvar112, 31
  %71 = icmp slt i64 %69, %70
  %72 = select i1 %71, i64 %69, i64 %70
  %73 = icmp slt i64 %72, %28
  %74 = select i1 %73, i64 %72, i64 %28
  %polly.loop_guard129 = icmp sle i64 %64, %74
  br i1 %polly.loop_guard129, label %polly.loop_header126, label %polly.loop_exit128

polly.loop_exit128:                               ; preds = %polly.loop_exit137, %polly.loop_header117
  %polly.indvar_next122 = add nsw i64 %polly.indvar121, 32
  %polly.adjust_ub123 = sub i64 %53, 32
  %polly.loop_cond124 = icmp sle i64 %polly.indvar121, %polly.adjust_ub123
  br i1 %polly.loop_cond124, label %polly.loop_header117, label %polly.loop_exit119

polly.loop_header126:                             ; preds = %polly.loop_header117, %polly.loop_exit137
  %polly.indvar130 = phi i64 [ %polly.indvar_next131, %polly.loop_exit137 ], [ %64, %polly.loop_header117 ]
  %75 = mul i64 -20, %polly.indvar130
  %76 = add i64 %75, %55
  %77 = add i64 %76, 1
  %78 = icmp sgt i64 %polly.indvar121, %77
  %79 = select i1 %78, i64 %polly.indvar121, i64 %77
  %80 = add i64 %polly.indvar121, 31
  %81 = icmp slt i64 %75, %80
  %82 = select i1 %81, i64 %75, i64 %80
  %polly.loop_guard138 = icmp sle i64 %79, %82
  br i1 %polly.loop_guard138, label %polly.loop_header135, label %polly.loop_exit137

polly.loop_exit137:                               ; preds = %polly.loop_header135, %polly.loop_header126
  %polly.indvar_next131 = add nsw i64 %polly.indvar130, 1
  %polly.adjust_ub132 = sub i64 %74, 1
  %polly.loop_cond133 = icmp sle i64 %polly.indvar130, %polly.adjust_ub132
  br i1 %polly.loop_cond133, label %polly.loop_header126, label %polly.loop_exit128

polly.loop_header135:                             ; preds = %polly.loop_header126, %polly.loop_header135
  %polly.indvar139 = phi i64 [ %polly.indvar_next140, %polly.loop_header135 ], [ %79, %polly.loop_header126 ]
  %83 = mul i64 -1, %polly.indvar139
  %84 = add i64 %75, %83
  %p_.moved.to.81 = mul i64 %polly.indvar130, 16000
  %p_scevgep32 = getelementptr [2000 x double]* %A, i64 %polly.indvar130, i64 %84
  %p_144 = mul i64 %84, 8
  %p_145 = add i64 %p_.moved.to.81, %p_144
  %p_scevgep35 = getelementptr i8* %17, i64 %p_145
  %p_scevgep31 = bitcast i8* %p_scevgep35 to double*
  %_p_scalar_146 = load double* %p_scevgep31
  store double %_p_scalar_146, double* %p_scevgep32
  %p_indvar.next = add i64 %84, 1
  %polly.indvar_next140 = add nsw i64 %polly.indvar139, 1
  %polly.adjust_ub141 = sub i64 %82, 1
  %polly.loop_cond142 = icmp sle i64 %polly.indvar139, %polly.adjust_ub141
  br i1 %polly.loop_cond142, label %polly.loop_header135, label %polly.loop_exit137

polly.then152:                                    ; preds = %.preheader5.lr.ph
  %85 = add i64 %18, -1
  %polly.loop_guard157 = icmp sle i64 0, %85
  br i1 %polly.loop_guard157, label %polly.loop_header154, label %polly.start

polly.loop_header154:                             ; preds = %polly.then152, %polly.loop_exit165
  %polly.indvar158 = phi i64 [ %polly.indvar_next159, %polly.loop_exit165 ], [ 0, %polly.then152 ]
  %86 = mul i64 -11, %18
  %87 = add i64 %86, 5
  %88 = sub i64 %87, 32
  %89 = add i64 %88, 1
  %90 = icmp slt i64 %87, 0
  %91 = select i1 %90, i64 %89, i64 %87
  %92 = sdiv i64 %91, 32
  %93 = mul i64 -32, %92
  %94 = mul i64 -32, %18
  %95 = add i64 %93, %94
  %96 = mul i64 -32, %polly.indvar158
  %97 = mul i64 -3, %polly.indvar158
  %98 = add i64 %97, %18
  %99 = add i64 %98, 5
  %100 = sub i64 %99, 32
  %101 = add i64 %100, 1
  %102 = icmp slt i64 %99, 0
  %103 = select i1 %102, i64 %101, i64 %99
  %104 = sdiv i64 %103, 32
  %105 = mul i64 -32, %104
  %106 = add i64 %96, %105
  %107 = add i64 %106, -640
  %108 = icmp sgt i64 %95, %107
  %109 = select i1 %108, i64 %95, i64 %107
  %110 = mul i64 -20, %polly.indvar158
  %polly.loop_guard166 = icmp sle i64 %109, %110
  br i1 %polly.loop_guard166, label %polly.loop_header163, label %polly.loop_exit165

polly.loop_exit165:                               ; preds = %polly.loop_exit174, %polly.loop_header154
  %polly.indvar_next159 = add nsw i64 %polly.indvar158, 32
  %polly.adjust_ub160 = sub i64 %85, 32
  %polly.loop_cond161 = icmp sle i64 %polly.indvar158, %polly.adjust_ub160
  br i1 %polly.loop_cond161, label %polly.loop_header154, label %polly.start

polly.loop_header163:                             ; preds = %polly.loop_header154, %polly.loop_exit174
  %polly.indvar167 = phi i64 [ %polly.indvar_next168, %polly.loop_exit174 ], [ %109, %polly.loop_header154 ]
  %111 = mul i64 -1, %polly.indvar167
  %112 = mul i64 -1, %18
  %113 = add i64 %111, %112
  %114 = add i64 %113, -30
  %115 = add i64 %114, 20
  %116 = sub i64 %115, 1
  %117 = icmp slt i64 %114, 0
  %118 = select i1 %117, i64 %114, i64 %116
  %119 = sdiv i64 %118, 20
  %120 = icmp sgt i64 %119, %polly.indvar158
  %121 = select i1 %120, i64 %119, i64 %polly.indvar158
  %122 = sub i64 %111, 20
  %123 = add i64 %122, 1
  %124 = icmp slt i64 %111, 0
  %125 = select i1 %124, i64 %123, i64 %111
  %126 = sdiv i64 %125, 20
  %127 = add i64 %polly.indvar158, 31
  %128 = icmp slt i64 %126, %127
  %129 = select i1 %128, i64 %126, i64 %127
  %130 = icmp slt i64 %129, %85
  %131 = select i1 %130, i64 %129, i64 %85
  %polly.loop_guard175 = icmp sle i64 %121, %131
  br i1 %polly.loop_guard175, label %polly.loop_header172, label %polly.loop_exit174

polly.loop_exit174:                               ; preds = %polly.loop_exit183, %polly.loop_header163
  %polly.indvar_next168 = add nsw i64 %polly.indvar167, 32
  %polly.adjust_ub169 = sub i64 %110, 32
  %polly.loop_cond170 = icmp sle i64 %polly.indvar167, %polly.adjust_ub169
  br i1 %polly.loop_cond170, label %polly.loop_header163, label %polly.loop_exit165

polly.loop_header172:                             ; preds = %polly.loop_header163, %polly.loop_exit183
  %polly.indvar176 = phi i64 [ %polly.indvar_next177, %polly.loop_exit183 ], [ %121, %polly.loop_header163 ]
  %132 = mul i64 -20, %polly.indvar176
  %133 = add i64 %132, %112
  %134 = add i64 %133, 1
  %135 = icmp sgt i64 %polly.indvar167, %134
  %136 = select i1 %135, i64 %polly.indvar167, i64 %134
  %137 = add i64 %polly.indvar167, 31
  %138 = icmp slt i64 %132, %137
  %139 = select i1 %138, i64 %132, i64 %137
  %polly.loop_guard184 = icmp sle i64 %136, %139
  br i1 %polly.loop_guard184, label %polly.loop_header181, label %polly.loop_exit183

polly.loop_exit183:                               ; preds = %polly.loop_header181, %polly.loop_header172
  %polly.indvar_next177 = add nsw i64 %polly.indvar176, 1
  %polly.adjust_ub178 = sub i64 %131, 1
  %polly.loop_cond179 = icmp sle i64 %polly.indvar176, %polly.adjust_ub178
  br i1 %polly.loop_cond179, label %polly.loop_header172, label %polly.loop_exit174

polly.loop_header181:                             ; preds = %polly.loop_header172, %polly.loop_header181
  %polly.indvar185 = phi i64 [ %polly.indvar_next186, %polly.loop_header181 ], [ %136, %polly.loop_header172 ]
  %140 = mul i64 -1, %polly.indvar185
  %141 = add i64 %132, %140
  %p_.moved.to. = mul i64 %polly.indvar176, 16000
  %p_190 = mul i64 %141, 8
  %p_191 = add i64 %p_.moved.to., %p_190
  %p_scevgep61 = getelementptr i8* %17, i64 %p_191
  %p_scevgep5859 = bitcast i8* %p_scevgep61 to double*
  store double 0.000000e+00, double* %p_scevgep5859
  %p_indvar.next54 = add i64 %141, 1
  %polly.indvar_next186 = add nsw i64 %polly.indvar185, 1
  %polly.adjust_ub187 = sub i64 %139, 1
  %polly.loop_cond188 = icmp sle i64 %polly.indvar185, %polly.adjust_ub187
  br i1 %polly.loop_cond188, label %polly.loop_header181, label %polly.loop_exit183

polly.cond195:                                    ; preds = %.preheader6
  %142 = srem i64 %10, 8
  %143 = icmp eq i64 %142, 0
  br i1 %143, label %polly.then200, label %polly.merge196

polly.then200:                                    ; preds = %polly.cond195
  br i1 true, label %polly.loop_header202, label %polly.merge196

polly.loop_header202:                             ; preds = %polly.then200, %polly.loop_header202
  %polly.indvar206 = phi i64 [ %polly.indvar_next207, %polly.loop_header202 ], [ 0, %polly.then200 ]
  %p_211 = add i64 %12, %polly.indvar206
  %p_scevgep72 = getelementptr [2000 x double]* %A, i64 0, i64 %p_211
  store double 0.000000e+00, double* %p_scevgep72
  %p_indvar.next70 = add i64 %polly.indvar206, 1
  %polly.indvar_next207 = add nsw i64 %polly.indvar206, 1
  %polly.adjust_ub208 = sub i64 %9, 1
  %polly.loop_cond209 = icmp sle i64 %polly.indvar206, %polly.adjust_ub208
  br i1 %polly.loop_cond209, label %polly.loop_header202, label %polly.merge196

polly.cond215:                                    ; preds = %.preheader7
  %144 = srem i64 %5, 8
  %145 = icmp eq i64 %144, 0
  %146 = icmp sge i64 %indvar65, 0
  %or.cond239 = and i1 %145, %146
  br i1 %or.cond239, label %polly.then220, label %.preheader6

polly.then220:                                    ; preds = %polly.cond215
  br i1 %146, label %polly.loop_header222, label %.preheader6

polly.loop_header222:                             ; preds = %polly.then220, %polly.loop_header222
  %polly.indvar226 = phi i64 [ %polly.indvar_next227, %polly.loop_header222 ], [ 0, %polly.then220 ]
  %p_scevgep68 = getelementptr [2000 x double]* %A, i64 %indvar65, i64 %polly.indvar226
  %p_231 = mul i64 %polly.indvar226, -1
  %p_232 = trunc i64 %p_231 to i32
  %p_233 = srem i32 %p_232, %n
  %p_234 = sitofp i32 %p_233 to double
  %p_235 = fdiv double %p_234, %4
  %p_236 = fadd double %p_235, 1.000000e+00
  store double %p_236, double* %p_scevgep68
  %p_indvar.next64 = add i64 %polly.indvar226, 1
  %polly.indvar_next227 = add nsw i64 %polly.indvar226, 1
  %polly.adjust_ub228 = sub i64 %indvar65, 1
  %polly.loop_cond229 = icmp sle i64 %polly.indvar226, %polly.adjust_ub228
  br i1 %polly.loop_cond229, label %polly.loop_header222, label %.preheader6
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_cholesky(i32 %n, [2000 x double]* noalias %A) #0 {
.split:
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.preheader.lr.ph, label %._crit_edge10

.preheader.lr.ph:                                 ; preds = %.split
  %1 = zext i32 %n to i64
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %polly.merge
  %2 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next14, %polly.merge ]
  %3 = mul i64 %2, 16000
  %4 = mul i64 %2, 16008
  %i.09 = trunc i64 %2 to i32
  %5 = mul i64 %2, 2001
  %scevgep28 = getelementptr [2000 x double]* %A, i64 0, i64 %5
  %6 = icmp sgt i32 %i.09, 0
  br i1 %6, label %polly.cond39, label %polly.merge40

polly.merge40:                                    ; preds = %polly.stmt.45, %polly.loop_exit69, %polly.cond39, %.preheader
  %7 = load double* %scevgep28, align 8, !tbaa !6
  store double %7, double* %scevgep28, align 8, !tbaa !6
  br i1 %6, label %polly.cond, label %polly.merge

polly.merge:                                      ; preds = %polly.then32, %polly.loop_header, %polly.cond, %polly.merge40
  %8 = load double* %scevgep28, align 8, !tbaa !6
  %9 = tail call double @sqrt(double %8) #3
  store double %9, double* %scevgep28, align 8, !tbaa !6
  %indvar.next14 = add i64 %2, 1
  %exitcond24 = icmp ne i64 %indvar.next14, %1
  br i1 %exitcond24, label %.preheader, label %._crit_edge10

._crit_edge10:                                    ; preds = %polly.merge, %.split
  ret void

polly.cond:                                       ; preds = %polly.merge40
  %10 = srem i64 %4, 8
  %11 = icmp eq i64 %10, 0
  %12 = icmp sge i64 %2, 1
  %or.cond = and i1 %11, %12
  br i1 %or.cond, label %polly.then32, label %polly.merge

polly.then32:                                     ; preds = %polly.cond
  %13 = add i64 %2, -1
  %polly.loop_guard = icmp sle i64 0, %13
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then32, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then32 ]
  %p_scevgep23 = getelementptr [2000 x double]* %A, i64 %2, i64 %polly.indvar
  %_p_scalar_ = load double* %p_scevgep23
  %p_ = fmul double %_p_scalar_, %_p_scalar_
  %_p_scalar_34 = load double* %scevgep28
  %p_35 = fsub double %_p_scalar_34, %p_
  store double %p_35, double* %scevgep28
  %p_indvar.next21 = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %13, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.cond39:                                     ; preds = %.preheader
  %14 = srem i64 %3, 8
  %15 = icmp eq i64 %14, 0
  %16 = icmp sge i64 %2, 1
  %or.cond92 = and i1 %15, %16
  br i1 %or.cond92, label %polly.stmt.45, label %polly.merge40

polly.stmt.45:                                    ; preds = %polly.cond39
  %p_scevgep18 = getelementptr [2000 x double]* %A, i64 %2, i64 0
  %_p_scalar_46 = load double* %p_scevgep18
  store double %_p_scalar_46, double* %p_scevgep18
  %p_scevgep19.moved.to. = getelementptr [2000 x double]* %A, i64 0, i64 0
  %_p_scalar_49 = load double* %p_scevgep19.moved.to.
  %p_51 = fdiv double %_p_scalar_46, %_p_scalar_49
  store double %p_51, double* %p_scevgep18
  %17 = add i64 %2, -1
  %polly.loop_guard56 = icmp sle i64 1, %17
  br i1 %polly.loop_guard56, label %polly.loop_header53, label %polly.merge40

polly.loop_header53:                              ; preds = %polly.stmt.45, %polly.loop_exit69
  %polly.indvar57 = phi i64 [ %polly.indvar_next58, %polly.loop_exit69 ], [ 1, %polly.stmt.45 ]
  %p_scevgep1862 = getelementptr [2000 x double]* %A, i64 %2, i64 %polly.indvar57
  %p_j.0263 = trunc i64 %polly.indvar57 to i32
  %_p_scalar_64 = load double* %p_scevgep1862
  store double %_p_scalar_64, double* %p_scevgep1862
  %18 = add i64 %polly.indvar57, -1
  %polly.loop_guard70 = icmp sle i64 0, %18
  br i1 %polly.loop_guard70, label %polly.loop_header67, label %polly.loop_exit69

polly.loop_exit69:                                ; preds = %polly.loop_header67, %polly.loop_header53
  %p_.moved.to.82 = mul i64 %polly.indvar57, 2001
  %p_scevgep19.moved.to.83 = getelementptr [2000 x double]* %A, i64 0, i64 %p_.moved.to.82
  %_p_scalar_85 = load double* %p_scevgep19.moved.to.83
  %_p_scalar_86 = load double* %p_scevgep1862
  %p_87 = fdiv double %_p_scalar_86, %_p_scalar_85
  store double %p_87, double* %p_scevgep1862
  %p_indvar.next1288 = add i64 %polly.indvar57, 1
  %polly.indvar_next58 = add nsw i64 %polly.indvar57, 1
  %polly.adjust_ub59 = sub i64 %17, 1
  %polly.loop_cond60 = icmp sle i64 %polly.indvar57, %polly.adjust_ub59
  br i1 %polly.loop_cond60, label %polly.loop_header53, label %polly.merge40

polly.loop_header67:                              ; preds = %polly.loop_header53, %polly.loop_header67
  %polly.indvar71 = phi i64 [ %polly.indvar_next72, %polly.loop_header67 ], [ 0, %polly.loop_header53 ]
  %p_scevgep = getelementptr [2000 x double]* %A, i64 %2, i64 %polly.indvar71
  %p_scevgep15 = getelementptr [2000 x double]* %A, i64 %polly.indvar57, i64 %polly.indvar71
  %_p_scalar_76 = load double* %p_scevgep
  %_p_scalar_77 = load double* %p_scevgep15
  %p_78 = fmul double %_p_scalar_76, %_p_scalar_77
  %_p_scalar_79 = load double* %p_scevgep1862
  %p_80 = fsub double %_p_scalar_79, %p_78
  store double %p_80, double* %p_scevgep1862
  %p_indvar.next = add i64 %polly.indvar71, 1
  %polly.indvar_next72 = add nsw i64 %polly.indvar71, 1
  %polly.adjust_ub73 = sub i64 %18, 1
  %polly.loop_cond74 = icmp sle i64 %polly.indvar71, %polly.adjust_ub73
  br i1 %polly.loop_cond74, label %polly.loop_header67, label %polly.loop_exit69
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, [2000 x double]* noalias %A) #0 {
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
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %21
  %indvar4 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next5, %21 ]
  %i.02 = trunc i64 %indvar4 to i32
  %7 = mul i64 %6, %indvar4
  %8 = add i64 %indvar4, 1
  %9 = icmp slt i32 %i.02, 0
  br i1 %9, label %21, label %.lr.ph

.lr.ph:                                           ; preds = %.preheader
  br label %10

; <label>:10                                      ; preds = %17, %.lr.ph
  %indvar = phi i64 [ %indvar.next, %17 ], [ 0, %.lr.ph ]
  %11 = add i64 %7, %indvar
  %12 = trunc i64 %11 to i32
  %scevgep = getelementptr [2000 x double]* %A, i64 %indvar4, i64 %indvar
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
  %exitcond = icmp ne i64 %indvar.next, %8
  br i1 %exitcond, label %10, label %._crit_edge

._crit_edge:                                      ; preds = %17
  br label %21

; <label>:21                                      ; preds = %._crit_edge, %.preheader
  %indvar.next5 = add i64 %indvar4, 1
  %exitcond6 = icmp ne i64 %indvar.next5, %6
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
declare double @sqrt(double) #2

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
