; ModuleID = './linear-algebra/blas/syr2k/syr2k.c'
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
  %0 = tail call i8* @polybench_alloc_data(i64 1440000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 1200000, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 1200000, i32 8) #3
  %3 = bitcast i8* %0 to [1200 x double]*
  %4 = bitcast i8* %1 to [1000 x double]*
  %5 = bitcast i8* %2 to [1000 x double]*
  call void @init_array(i32 1200, i32 1000, double* %alpha, double* %beta, [1200 x double]* %3, [1000 x double]* %4, [1000 x double]* %5)
  call void (...)* @polybench_timer_start() #3
  %6 = load double* %alpha, align 8, !tbaa !1
  %7 = load double* %beta, align 8, !tbaa !1
  call void @kernel_syr2k(i32 1200, i32 1000, double %6, double %7, [1200 x double]* %3, [1000 x double]* %4, [1000 x double]* %5)
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
  call void @print_array(i32 1200, [1200 x double]* %3)
  br label %13

; <label>:13                                      ; preds = %9, %12, %.split
  call void @free(i8* %0) #3
  call void @free(i8* %1) #3
  call void @free(i8* %2) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %n, i32 %m, double* %alpha, double* %beta, [1200 x double]* %C, [1000 x double]* %A, [1000 x double]* %B) #0 {
.split:
  %alpha26 = bitcast double* %alpha to i8*
  %beta27 = bitcast double* %beta to i8*
  %A29 = bitcast [1000 x double]* %A to i8*
  %B32 = bitcast [1000 x double]* %B to i8*
  %B31 = ptrtoint [1000 x double]* %B to i64
  %A28 = ptrtoint [1000 x double]* %A to i64
  %0 = icmp ult i8* %alpha26, %beta27
  %1 = icmp ult i8* %beta27, %alpha26
  %pair-no-alias = or i1 %0, %1
  %2 = zext i32 %n to i64
  %3 = add i64 %2, -1
  %4 = mul i64 8000, %3
  %5 = add i64 %A28, %4
  %6 = zext i32 %m to i64
  %7 = add i64 %6, -1
  %8 = mul i64 8, %7
  %9 = add i64 %5, %8
  %10 = inttoptr i64 %9 to i8*
  %11 = icmp ult i8* %alpha26, %A29
  %12 = icmp ult i8* %10, %alpha26
  %pair-no-alias30 = or i1 %11, %12
  %13 = and i1 %pair-no-alias, %pair-no-alias30
  %14 = add i64 %B31, %4
  %15 = add i64 %14, %8
  %16 = inttoptr i64 %15 to i8*
  %17 = icmp ult i8* %alpha26, %B32
  %18 = icmp ult i8* %16, %alpha26
  %pair-no-alias33 = or i1 %17, %18
  %19 = and i1 %13, %pair-no-alias33
  %20 = icmp ult i8* %beta27, %A29
  %21 = icmp ult i8* %10, %beta27
  %pair-no-alias34 = or i1 %20, %21
  %22 = and i1 %19, %pair-no-alias34
  %23 = icmp ult i8* %beta27, %B32
  %24 = icmp ult i8* %16, %beta27
  %pair-no-alias35 = or i1 %23, %24
  %25 = and i1 %22, %pair-no-alias35
  %26 = icmp ult i8* %10, %B32
  %27 = icmp ult i8* %16, %A29
  %pair-no-alias36 = or i1 %26, %27
  %28 = and i1 %25, %pair-no-alias36
  br i1 %28, label %polly.start81, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  store double 1.500000e+00, double* %alpha, align 8, !tbaa !1
  store double 1.200000e+00, double* %beta, align 8, !tbaa !1
  %29 = icmp sgt i32 %n, 0
  br i1 %29, label %.preheader2.lr.ph.clone, label %polly.start

.preheader2.lr.ph.clone:                          ; preds = %.split.split.clone
  %30 = icmp sgt i32 %m, 0
  %31 = sitofp i32 %n to double
  %32 = sitofp i32 %m to double
  br label %.preheader2.clone

.preheader2.clone:                                ; preds = %._crit_edge9.clone, %.preheader2.lr.ph.clone
  %33 = phi i64 [ 0, %.preheader2.lr.ph.clone ], [ %indvar.next20.clone, %._crit_edge9.clone ]
  br i1 %30, label %.lr.ph8.clone, label %._crit_edge9.clone

.lr.ph8.clone:                                    ; preds = %.preheader2.clone, %.lr.ph8.clone
  %indvar16.clone = phi i64 [ %indvar.next17.clone, %.lr.ph8.clone ], [ 0, %.preheader2.clone ]
  %scevgep22.clone = getelementptr [1000 x double]* %B, i64 %33, i64 %indvar16.clone
  %scevgep21.clone = getelementptr [1000 x double]* %A, i64 %33, i64 %indvar16.clone
  %34 = mul i64 %33, %indvar16.clone
  %35 = trunc i64 %34 to i32
  %36 = srem i32 %35, %n
  %37 = sitofp i32 %36 to double
  %38 = fdiv double %37, %31
  store double %38, double* %scevgep21.clone, align 8, !tbaa !1
  %39 = srem i32 %35, %m
  %40 = sitofp i32 %39 to double
  %41 = fdiv double %40, %32
  store double %41, double* %scevgep22.clone, align 8, !tbaa !1
  %indvar.next17.clone = add i64 %indvar16.clone, 1
  %exitcond18.clone = icmp ne i64 %indvar.next17.clone, %6
  br i1 %exitcond18.clone, label %.lr.ph8.clone, label %._crit_edge9.clone

._crit_edge9.clone:                               ; preds = %.lr.ph8.clone, %.preheader2.clone
  %indvar.next20.clone = add i64 %33, 1
  %exitcond23.clone = icmp ne i64 %indvar.next20.clone, %2
  br i1 %exitcond23.clone, label %.preheader2.clone, label %polly.start

polly.start:                                      ; preds = %polly.then86, %polly.loop_exit99, %polly.start81, %.split.split.clone, %._crit_edge9.clone
  %42 = sext i32 %n to i64
  %43 = icmp sge i64 %42, 1
  %44 = icmp sge i64 %2, 1
  %45 = and i1 %43, %44
  br i1 %45, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit52, %polly.start
  ret void

polly.then:                                       ; preds = %polly.start
  %polly.loop_guard = icmp sle i64 0, %3
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit52
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit52 ], [ 0, %polly.then ]
  %46 = mul i64 -11, %2
  %47 = add i64 %46, 5
  %48 = sub i64 %47, 32
  %49 = add i64 %48, 1
  %50 = icmp slt i64 %47, 0
  %51 = select i1 %50, i64 %49, i64 %47
  %52 = sdiv i64 %51, 32
  %53 = mul i64 -32, %52
  %54 = mul i64 -32, %2
  %55 = add i64 %53, %54
  %56 = mul i64 -32, %polly.indvar
  %57 = mul i64 -3, %polly.indvar
  %58 = add i64 %57, %2
  %59 = add i64 %58, 5
  %60 = sub i64 %59, 32
  %61 = add i64 %60, 1
  %62 = icmp slt i64 %59, 0
  %63 = select i1 %62, i64 %61, i64 %59
  %64 = sdiv i64 %63, 32
  %65 = mul i64 -32, %64
  %66 = add i64 %56, %65
  %67 = add i64 %66, -640
  %68 = icmp sgt i64 %55, %67
  %69 = select i1 %68, i64 %55, i64 %67
  %70 = mul i64 -20, %polly.indvar
  %polly.loop_guard53 = icmp sle i64 %69, %70
  br i1 %polly.loop_guard53, label %polly.loop_header50, label %polly.loop_exit52

polly.loop_exit52:                                ; preds = %polly.loop_exit61, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %3, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header50:                              ; preds = %polly.loop_header, %polly.loop_exit61
  %polly.indvar54 = phi i64 [ %polly.indvar_next55, %polly.loop_exit61 ], [ %69, %polly.loop_header ]
  %71 = mul i64 -1, %polly.indvar54
  %72 = mul i64 -1, %2
  %73 = add i64 %71, %72
  %74 = add i64 %73, -30
  %75 = add i64 %74, 20
  %76 = sub i64 %75, 1
  %77 = icmp slt i64 %74, 0
  %78 = select i1 %77, i64 %74, i64 %76
  %79 = sdiv i64 %78, 20
  %80 = icmp sgt i64 %79, %polly.indvar
  %81 = select i1 %80, i64 %79, i64 %polly.indvar
  %82 = sub i64 %71, 20
  %83 = add i64 %82, 1
  %84 = icmp slt i64 %71, 0
  %85 = select i1 %84, i64 %83, i64 %71
  %86 = sdiv i64 %85, 20
  %87 = add i64 %polly.indvar, 31
  %88 = icmp slt i64 %86, %87
  %89 = select i1 %88, i64 %86, i64 %87
  %90 = icmp slt i64 %89, %3
  %91 = select i1 %90, i64 %89, i64 %3
  %polly.loop_guard62 = icmp sle i64 %81, %91
  br i1 %polly.loop_guard62, label %polly.loop_header59, label %polly.loop_exit61

polly.loop_exit61:                                ; preds = %polly.loop_exit70, %polly.loop_header50
  %polly.indvar_next55 = add nsw i64 %polly.indvar54, 32
  %polly.adjust_ub56 = sub i64 %70, 32
  %polly.loop_cond57 = icmp sle i64 %polly.indvar54, %polly.adjust_ub56
  br i1 %polly.loop_cond57, label %polly.loop_header50, label %polly.loop_exit52

polly.loop_header59:                              ; preds = %polly.loop_header50, %polly.loop_exit70
  %polly.indvar63 = phi i64 [ %polly.indvar_next64, %polly.loop_exit70 ], [ %81, %polly.loop_header50 ]
  %92 = mul i64 -20, %polly.indvar63
  %93 = add i64 %92, %72
  %94 = add i64 %93, 1
  %95 = icmp sgt i64 %polly.indvar54, %94
  %96 = select i1 %95, i64 %polly.indvar54, i64 %94
  %97 = add i64 %polly.indvar54, 31
  %98 = icmp slt i64 %92, %97
  %99 = select i1 %98, i64 %92, i64 %97
  %polly.loop_guard71 = icmp sle i64 %96, %99
  br i1 %polly.loop_guard71, label %polly.loop_header68, label %polly.loop_exit70

polly.loop_exit70:                                ; preds = %polly.loop_header68, %polly.loop_header59
  %polly.indvar_next64 = add nsw i64 %polly.indvar63, 1
  %polly.adjust_ub65 = sub i64 %91, 1
  %polly.loop_cond66 = icmp sle i64 %polly.indvar63, %polly.adjust_ub65
  br i1 %polly.loop_cond66, label %polly.loop_header59, label %polly.loop_exit61

polly.loop_header68:                              ; preds = %polly.loop_header59, %polly.loop_header68
  %polly.indvar72 = phi i64 [ %polly.indvar_next73, %polly.loop_header68 ], [ %96, %polly.loop_header59 ]
  %100 = mul i64 -1, %polly.indvar72
  %101 = add i64 %92, %100
  %p_.moved.to. = sitofp i32 %m to double
  %p_scevgep = getelementptr [1200 x double]* %C, i64 %polly.indvar63, i64 %101
  %p_ = mul i64 %polly.indvar63, %101
  %p_76 = trunc i64 %p_ to i32
  %p_77 = srem i32 %p_76, %n
  %p_78 = sitofp i32 %p_77 to double
  %p_79 = fdiv double %p_78, %p_.moved.to.
  store double %p_79, double* %p_scevgep
  %p_indvar.next = add i64 %101, 1
  %polly.indvar_next73 = add nsw i64 %polly.indvar72, 1
  %polly.adjust_ub74 = sub i64 %99, 1
  %polly.loop_cond75 = icmp sle i64 %polly.indvar72, %polly.adjust_ub74
  br i1 %polly.loop_cond75, label %polly.loop_header68, label %polly.loop_exit70

polly.start81:                                    ; preds = %.split
  store double 1.500000e+00, double* %alpha
  store double 1.200000e+00, double* %beta
  %102 = sext i32 %m to i64
  %103 = icmp sge i64 %102, 1
  %104 = sext i32 %n to i64
  %105 = icmp sge i64 %104, 1
  %106 = and i1 %103, %105
  %107 = icmp sge i64 %2, 1
  %108 = and i1 %106, %107
  %109 = icmp sge i64 %6, 1
  %110 = and i1 %108, %109
  br i1 %110, label %polly.then86, label %polly.start

polly.then86:                                     ; preds = %polly.start81
  %polly.loop_guard91 = icmp sle i64 0, %3
  br i1 %polly.loop_guard91, label %polly.loop_header88, label %polly.start

polly.loop_header88:                              ; preds = %polly.then86, %polly.loop_exit99
  %polly.indvar92 = phi i64 [ %polly.indvar_next93, %polly.loop_exit99 ], [ 0, %polly.then86 ]
  %111 = mul i64 -3, %2
  %112 = add i64 %111, %6
  %113 = add i64 %112, 5
  %114 = sub i64 %113, 32
  %115 = add i64 %114, 1
  %116 = icmp slt i64 %113, 0
  %117 = select i1 %116, i64 %115, i64 %113
  %118 = sdiv i64 %117, 32
  %119 = mul i64 -32, %118
  %120 = mul i64 -32, %2
  %121 = add i64 %119, %120
  %122 = mul i64 -32, %polly.indvar92
  %123 = mul i64 -3, %polly.indvar92
  %124 = add i64 %123, %6
  %125 = add i64 %124, 5
  %126 = sub i64 %125, 32
  %127 = add i64 %126, 1
  %128 = icmp slt i64 %125, 0
  %129 = select i1 %128, i64 %127, i64 %125
  %130 = sdiv i64 %129, 32
  %131 = mul i64 -32, %130
  %132 = add i64 %122, %131
  %133 = add i64 %132, -640
  %134 = icmp sgt i64 %121, %133
  %135 = select i1 %134, i64 %121, i64 %133
  %136 = mul i64 -20, %polly.indvar92
  %polly.loop_guard100 = icmp sle i64 %135, %136
  br i1 %polly.loop_guard100, label %polly.loop_header97, label %polly.loop_exit99

polly.loop_exit99:                                ; preds = %polly.loop_exit108, %polly.loop_header88
  %polly.indvar_next93 = add nsw i64 %polly.indvar92, 32
  %polly.adjust_ub94 = sub i64 %3, 32
  %polly.loop_cond95 = icmp sle i64 %polly.indvar92, %polly.adjust_ub94
  br i1 %polly.loop_cond95, label %polly.loop_header88, label %polly.start

polly.loop_header97:                              ; preds = %polly.loop_header88, %polly.loop_exit108
  %polly.indvar101 = phi i64 [ %polly.indvar_next102, %polly.loop_exit108 ], [ %135, %polly.loop_header88 ]
  %137 = mul i64 -1, %polly.indvar101
  %138 = mul i64 -1, %6
  %139 = add i64 %137, %138
  %140 = add i64 %139, -30
  %141 = add i64 %140, 20
  %142 = sub i64 %141, 1
  %143 = icmp slt i64 %140, 0
  %144 = select i1 %143, i64 %140, i64 %142
  %145 = sdiv i64 %144, 20
  %146 = icmp sgt i64 %145, %polly.indvar92
  %147 = select i1 %146, i64 %145, i64 %polly.indvar92
  %148 = sub i64 %137, 20
  %149 = add i64 %148, 1
  %150 = icmp slt i64 %137, 0
  %151 = select i1 %150, i64 %149, i64 %137
  %152 = sdiv i64 %151, 20
  %153 = add i64 %polly.indvar92, 31
  %154 = icmp slt i64 %152, %153
  %155 = select i1 %154, i64 %152, i64 %153
  %156 = icmp slt i64 %155, %3
  %157 = select i1 %156, i64 %155, i64 %3
  %polly.loop_guard109 = icmp sle i64 %147, %157
  br i1 %polly.loop_guard109, label %polly.loop_header106, label %polly.loop_exit108

polly.loop_exit108:                               ; preds = %polly.loop_exit117, %polly.loop_header97
  %polly.indvar_next102 = add nsw i64 %polly.indvar101, 32
  %polly.adjust_ub103 = sub i64 %136, 32
  %polly.loop_cond104 = icmp sle i64 %polly.indvar101, %polly.adjust_ub103
  br i1 %polly.loop_cond104, label %polly.loop_header97, label %polly.loop_exit99

polly.loop_header106:                             ; preds = %polly.loop_header97, %polly.loop_exit117
  %polly.indvar110 = phi i64 [ %polly.indvar_next111, %polly.loop_exit117 ], [ %147, %polly.loop_header97 ]
  %158 = mul i64 -20, %polly.indvar110
  %159 = add i64 %158, %138
  %160 = add i64 %159, 1
  %161 = icmp sgt i64 %polly.indvar101, %160
  %162 = select i1 %161, i64 %polly.indvar101, i64 %160
  %163 = add i64 %polly.indvar101, 31
  %164 = icmp slt i64 %158, %163
  %165 = select i1 %164, i64 %158, i64 %163
  %polly.loop_guard118 = icmp sle i64 %162, %165
  br i1 %polly.loop_guard118, label %polly.loop_header115, label %polly.loop_exit117

polly.loop_exit117:                               ; preds = %polly.loop_header115, %polly.loop_header106
  %polly.indvar_next111 = add nsw i64 %polly.indvar110, 1
  %polly.adjust_ub112 = sub i64 %157, 1
  %polly.loop_cond113 = icmp sle i64 %polly.indvar110, %polly.adjust_ub112
  br i1 %polly.loop_cond113, label %polly.loop_header106, label %polly.loop_exit108

polly.loop_header115:                             ; preds = %polly.loop_header106, %polly.loop_header115
  %polly.indvar119 = phi i64 [ %polly.indvar_next120, %polly.loop_header115 ], [ %162, %polly.loop_header106 ]
  %166 = mul i64 -1, %polly.indvar119
  %167 = add i64 %158, %166
  %p_.moved.to.42 = sitofp i32 %n to double
  %p_.moved.to.43 = sitofp i32 %m to double
  %p_scevgep22 = getelementptr [1000 x double]* %B, i64 %polly.indvar110, i64 %167
  %p_scevgep21 = getelementptr [1000 x double]* %A, i64 %polly.indvar110, i64 %167
  %p_124 = mul i64 %polly.indvar110, %167
  %p_125 = trunc i64 %p_124 to i32
  %p_126 = srem i32 %p_125, %n
  %p_127 = sitofp i32 %p_126 to double
  %p_128 = fdiv double %p_127, %p_.moved.to.42
  store double %p_128, double* %p_scevgep21
  %p_129 = srem i32 %p_125, %m
  %p_130 = sitofp i32 %p_129 to double
  %p_131 = fdiv double %p_130, %p_.moved.to.43
  store double %p_131, double* %p_scevgep22
  %p_indvar.next17 = add i64 %167, 1
  %polly.indvar_next120 = add nsw i64 %polly.indvar119, 1
  %polly.adjust_ub121 = sub i64 %165, 1
  %polly.loop_cond122 = icmp sle i64 %polly.indvar119, %polly.adjust_ub121
  br i1 %polly.loop_cond122, label %polly.loop_header115, label %polly.loop_exit117
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_syr2k(i32 %n, i32 %m, double %alpha, double %beta, [1200 x double]* %C, [1000 x double]* %A, [1000 x double]* %B) #0 {
polly.split_new_and_old101:
  %C38 = bitcast [1200 x double]* %C to i8*
  %B42 = ptrtoint [1000 x double]* %B to i64
  %A37 = ptrtoint [1000 x double]* %A to i64
  %C36 = ptrtoint [1200 x double]* %C to i64
  %0 = zext i32 %n to i64
  %1 = sext i32 %n to i64
  %2 = icmp sge i64 %1, 1
  %3 = icmp sge i64 %0, 1
  %4 = and i1 %2, %3
  br i1 %4, label %polly.then106, label %polly.merge105

.preheader2.split.clone:                          ; preds = %polly.merge105
  %5 = icmp sgt i32 %n, 0
  br i1 %5, label %.preheader1.lr.ph.clone, label %.region.clone

.preheader1.lr.ph.clone:                          ; preds = %.preheader2.split.clone
  %6 = icmp sgt i32 %m, 0
  br label %.preheader1.clone

.preheader1.clone:                                ; preds = %._crit_edge6.clone, %.preheader1.lr.ph.clone
  %indvar16.clone = phi i64 [ 0, %.preheader1.lr.ph.clone ], [ %indvar.next17.clone, %._crit_edge6.clone ]
  br i1 %6, label %.preheader.clone, label %._crit_edge6.clone

.preheader.clone:                                 ; preds = %.preheader1.clone, %._crit_edge.clone
  %indvar13.clone = phi i64 [ %indvar.next14.clone, %._crit_edge.clone ], [ 0, %.preheader1.clone ]
  %scevgep23.clone = getelementptr [1000 x double]* %A, i64 %indvar16.clone, i64 %indvar13.clone
  %scevgep22.clone = getelementptr [1000 x double]* %B, i64 %indvar16.clone, i64 %indvar13.clone
  br i1 %5, label %.lr.ph.clone, label %._crit_edge.clone

.lr.ph.clone:                                     ; preds = %.preheader.clone, %.lr.ph.clone
  %indvar.clone = phi i64 [ %indvar.next.clone, %.lr.ph.clone ], [ 0, %.preheader.clone ]
  %scevgep18.clone = getelementptr [1200 x double]* %C, i64 %indvar16.clone, i64 %indvar.clone
  %scevgep15.clone = getelementptr [1000 x double]* %B, i64 %indvar.clone, i64 %indvar13.clone
  %scevgep.clone = getelementptr [1000 x double]* %A, i64 %indvar.clone, i64 %indvar13.clone
  %7 = load double* %scevgep.clone, align 8, !tbaa !1
  %8 = fmul double %7, %alpha
  %9 = load double* %scevgep22.clone, align 8, !tbaa !1
  %10 = fmul double %8, %9
  %11 = load double* %scevgep15.clone, align 8, !tbaa !1
  %12 = fmul double %11, %alpha
  %13 = load double* %scevgep23.clone, align 8, !tbaa !1
  %14 = fmul double %12, %13
  %15 = fadd double %10, %14
  %16 = load double* %scevgep18.clone, align 8, !tbaa !1
  %17 = fadd double %16, %15
  store double %17, double* %scevgep18.clone, align 8, !tbaa !1
  %indvar.next.clone = add i64 %indvar.clone, 1
  %exitcond.clone = icmp ne i64 %indvar.next.clone, %0
  br i1 %exitcond.clone, label %.lr.ph.clone, label %._crit_edge.clone

._crit_edge.clone:                                ; preds = %.lr.ph.clone, %.preheader.clone
  %indvar.next14.clone = add i64 %indvar13.clone, 1
  %exitcond19.clone = icmp ne i64 %indvar.next14.clone, %86
  br i1 %exitcond19.clone, label %.preheader.clone, label %._crit_edge6.clone

._crit_edge6.clone:                               ; preds = %._crit_edge.clone, %.preheader1.clone
  %indvar.next17.clone = add i64 %indvar16.clone, 1
  %exitcond24.clone = icmp ne i64 %indvar.next17.clone, %0
  br i1 %exitcond24.clone, label %.preheader1.clone, label %.region.clone

.region.clone:                                    ; preds = %polly.then, %polly.loop_exit58, %polly.start, %.preheader2.split.clone, %._crit_edge6.clone
  ret void

polly.start:                                      ; preds = %polly.merge105
  %18 = sext i32 %m to i64
  %19 = icmp sge i64 %18, 1
  %20 = and i1 %19, %2
  %21 = and i1 %20, %3
  %22 = icmp sge i64 %86, 1
  %23 = and i1 %21, %22
  br i1 %23, label %polly.then, label %.region.clone

polly.then:                                       ; preds = %polly.start
  %polly.loop_guard = icmp sle i64 0, %80
  br i1 %polly.loop_guard, label %polly.loop_header, label %.region.clone

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit58
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit58 ], [ 0, %polly.then ]
  %24 = mul i64 -11, %0
  %25 = add i64 %24, 5
  %26 = sub i64 %25, 32
  %27 = add i64 %26, 1
  %28 = icmp slt i64 %25, 0
  %29 = select i1 %28, i64 %27, i64 %25
  %30 = sdiv i64 %29, 32
  %31 = mul i64 -32, %30
  %32 = mul i64 -32, %0
  %33 = add i64 %31, %32
  %34 = mul i64 -32, %polly.indvar
  %35 = mul i64 -3, %polly.indvar
  %36 = add i64 %35, %0
  %37 = add i64 %36, 5
  %38 = sub i64 %37, 32
  %39 = add i64 %38, 1
  %40 = icmp slt i64 %37, 0
  %41 = select i1 %40, i64 %39, i64 %37
  %42 = sdiv i64 %41, 32
  %43 = mul i64 -32, %42
  %44 = add i64 %34, %43
  %45 = add i64 %44, -640
  %46 = icmp sgt i64 %33, %45
  %47 = select i1 %46, i64 %33, i64 %45
  %48 = mul i64 -20, %polly.indvar
  %polly.loop_guard59 = icmp sle i64 %47, %48
  br i1 %polly.loop_guard59, label %polly.loop_header56, label %polly.loop_exit58

polly.loop_exit58:                                ; preds = %polly.loop_exit67, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %80, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %.region.clone

polly.loop_header56:                              ; preds = %polly.loop_header, %polly.loop_exit67
  %polly.indvar60 = phi i64 [ %polly.indvar_next61, %polly.loop_exit67 ], [ %47, %polly.loop_header ]
  %49 = mul i64 -1, %polly.indvar60
  %50 = mul i64 -1, %0
  %51 = add i64 %49, %50
  %52 = add i64 %51, -30
  %53 = add i64 %52, 20
  %54 = sub i64 %53, 1
  %55 = icmp slt i64 %52, 0
  %56 = select i1 %55, i64 %52, i64 %54
  %57 = sdiv i64 %56, 20
  %58 = icmp sgt i64 %57, %polly.indvar
  %59 = select i1 %58, i64 %57, i64 %polly.indvar
  %60 = sub i64 %49, 20
  %61 = add i64 %60, 1
  %62 = icmp slt i64 %49, 0
  %63 = select i1 %62, i64 %61, i64 %49
  %64 = sdiv i64 %63, 20
  %65 = add i64 %polly.indvar, 31
  %66 = icmp slt i64 %64, %65
  %67 = select i1 %66, i64 %64, i64 %65
  %68 = icmp slt i64 %67, %80
  %69 = select i1 %68, i64 %67, i64 %80
  %polly.loop_guard68 = icmp sle i64 %59, %69
  br i1 %polly.loop_guard68, label %polly.loop_header65, label %polly.loop_exit67

polly.loop_exit67:                                ; preds = %polly.loop_exit76, %polly.loop_header56
  %polly.indvar_next61 = add nsw i64 %polly.indvar60, 32
  %polly.adjust_ub62 = sub i64 %48, 32
  %polly.loop_cond63 = icmp sle i64 %polly.indvar60, %polly.adjust_ub62
  br i1 %polly.loop_cond63, label %polly.loop_header56, label %polly.loop_exit58

polly.loop_header65:                              ; preds = %polly.loop_header56, %polly.loop_exit76
  %polly.indvar69 = phi i64 [ %polly.indvar_next70, %polly.loop_exit76 ], [ %59, %polly.loop_header56 ]
  %70 = mul i64 -20, %polly.indvar69
  %71 = add i64 %70, %50
  %72 = add i64 %71, 1
  %73 = icmp sgt i64 %polly.indvar60, %72
  %74 = select i1 %73, i64 %polly.indvar60, i64 %72
  %75 = add i64 %polly.indvar60, 31
  %76 = icmp slt i64 %70, %75
  %77 = select i1 %76, i64 %70, i64 %75
  %polly.loop_guard77 = icmp sle i64 %74, %77
  br i1 %polly.loop_guard77, label %polly.loop_header74, label %polly.loop_exit76

polly.loop_exit76:                                ; preds = %polly.loop_exit85, %polly.loop_header65
  %polly.indvar_next70 = add nsw i64 %polly.indvar69, 1
  %polly.adjust_ub71 = sub i64 %69, 1
  %polly.loop_cond72 = icmp sle i64 %polly.indvar69, %polly.adjust_ub71
  br i1 %polly.loop_cond72, label %polly.loop_header65, label %polly.loop_exit67

polly.loop_header74:                              ; preds = %polly.loop_header65, %polly.loop_exit85
  %polly.indvar78 = phi i64 [ %polly.indvar_next79, %polly.loop_exit85 ], [ %74, %polly.loop_header65 ]
  %polly.loop_guard86 = icmp sle i64 0, %87
  br i1 %polly.loop_guard86, label %polly.loop_header83, label %polly.loop_exit85

polly.loop_exit85:                                ; preds = %polly.loop_header83, %polly.loop_header74
  %polly.indvar_next79 = add nsw i64 %polly.indvar78, 1
  %polly.adjust_ub80 = sub i64 %77, 1
  %polly.loop_cond81 = icmp sle i64 %polly.indvar78, %polly.adjust_ub80
  br i1 %polly.loop_cond81, label %polly.loop_header74, label %polly.loop_exit76

polly.loop_header83:                              ; preds = %polly.loop_header74, %polly.loop_header83
  %polly.indvar87 = phi i64 [ %polly.indvar_next88, %polly.loop_header83 ], [ 0, %polly.loop_header74 ]
  %78 = mul i64 -1, %polly.indvar78
  %79 = add i64 %70, %78
  %p_scevgep22.moved.to. = getelementptr [1000 x double]* %B, i64 %polly.indvar69, i64 %polly.indvar87
  %p_scevgep23.moved.to. = getelementptr [1000 x double]* %A, i64 %polly.indvar69, i64 %polly.indvar87
  %p_scevgep18 = getelementptr [1200 x double]* %C, i64 %polly.indvar69, i64 %79
  %p_scevgep15 = getelementptr [1000 x double]* %B, i64 %79, i64 %polly.indvar87
  %p_scevgep = getelementptr [1000 x double]* %A, i64 %79, i64 %polly.indvar87
  %_p_scalar_ = load double* %p_scevgep
  %p_ = fmul double %_p_scalar_, %alpha
  %_p_scalar_91 = load double* %p_scevgep22.moved.to.
  %p_92 = fmul double %p_, %_p_scalar_91
  %_p_scalar_93 = load double* %p_scevgep15
  %p_94 = fmul double %_p_scalar_93, %alpha
  %_p_scalar_95 = load double* %p_scevgep23.moved.to.
  %p_96 = fmul double %p_94, %_p_scalar_95
  %p_97 = fadd double %p_92, %p_96
  %_p_scalar_98 = load double* %p_scevgep18
  %p_99 = fadd double %_p_scalar_98, %p_97
  store double %p_99, double* %p_scevgep18
  %p_indvar.next = add i64 %79, 1
  %polly.indvar_next88 = add nsw i64 %polly.indvar87, 1
  %polly.adjust_ub89 = sub i64 %87, 1
  %polly.loop_cond90 = icmp sle i64 %polly.indvar87, %polly.adjust_ub89
  br i1 %polly.loop_cond90, label %polly.loop_header83, label %polly.loop_exit85

polly.merge105:                                   ; preds = %polly.then106, %polly.loop_exit119, %polly.split_new_and_old101
  %80 = add i64 %0, -1
  %81 = mul i64 9600, %80
  %82 = add i64 %C36, %81
  %83 = mul i64 8, %80
  %84 = add i64 %82, %83
  %85 = inttoptr i64 %84 to i8*
  %umin39 = bitcast [1000 x double]* %A to i8*
  %86 = zext i32 %m to i64
  %87 = add i64 %86, -1
  %88 = mul i64 8, %87
  %89 = add i64 %A37, %88
  %90 = mul i64 8000, %80
  %91 = add i64 %89, %90
  %92 = add i64 %A37, %90
  %93 = add i64 %92, %88
  %94 = icmp ugt i64 %93, %91
  %umax = select i1 %94, i64 %93, i64 %91
  %umax40 = inttoptr i64 %umax to i8*
  %95 = icmp ult i8* %85, %umin39
  %96 = icmp ult i8* %umax40, %C38
  %pair-no-alias = or i1 %95, %96
  %umin4144 = bitcast [1000 x double]* %B to i8*
  %97 = add i64 %B42, %90
  %98 = add i64 %97, %88
  %99 = add i64 %B42, %88
  %100 = add i64 %99, %90
  %101 = icmp ugt i64 %100, %98
  %umax43 = select i1 %101, i64 %100, i64 %98
  %umax4345 = inttoptr i64 %umax43 to i8*
  %102 = icmp ult i8* %85, %umin4144
  %103 = icmp ult i8* %umax4345, %C38
  %pair-no-alias46 = or i1 %102, %103
  %104 = and i1 %pair-no-alias, %pair-no-alias46
  %105 = icmp ult i8* %umax40, %umin4144
  %106 = icmp ult i8* %umax4345, %umin39
  %pair-no-alias47 = or i1 %105, %106
  %107 = and i1 %104, %pair-no-alias47
  br i1 %107, label %polly.start, label %.preheader2.split.clone

polly.then106:                                    ; preds = %polly.split_new_and_old101
  %108 = add i64 %0, -1
  %polly.loop_guard111 = icmp sle i64 0, %108
  br i1 %polly.loop_guard111, label %polly.loop_header108, label %polly.merge105

polly.loop_header108:                             ; preds = %polly.then106, %polly.loop_exit119
  %polly.indvar112 = phi i64 [ %polly.indvar_next113, %polly.loop_exit119 ], [ 0, %polly.then106 ]
  %109 = mul i64 -11, %0
  %110 = add i64 %109, 5
  %111 = sub i64 %110, 32
  %112 = add i64 %111, 1
  %113 = icmp slt i64 %110, 0
  %114 = select i1 %113, i64 %112, i64 %110
  %115 = sdiv i64 %114, 32
  %116 = mul i64 -32, %115
  %117 = mul i64 -32, %0
  %118 = add i64 %116, %117
  %119 = mul i64 -32, %polly.indvar112
  %120 = mul i64 -3, %polly.indvar112
  %121 = add i64 %120, %0
  %122 = add i64 %121, 5
  %123 = sub i64 %122, 32
  %124 = add i64 %123, 1
  %125 = icmp slt i64 %122, 0
  %126 = select i1 %125, i64 %124, i64 %122
  %127 = sdiv i64 %126, 32
  %128 = mul i64 -32, %127
  %129 = add i64 %119, %128
  %130 = add i64 %129, -640
  %131 = icmp sgt i64 %118, %130
  %132 = select i1 %131, i64 %118, i64 %130
  %133 = mul i64 -20, %polly.indvar112
  %polly.loop_guard120 = icmp sle i64 %132, %133
  br i1 %polly.loop_guard120, label %polly.loop_header117, label %polly.loop_exit119

polly.loop_exit119:                               ; preds = %polly.loop_exit128, %polly.loop_header108
  %polly.indvar_next113 = add nsw i64 %polly.indvar112, 32
  %polly.adjust_ub114 = sub i64 %108, 32
  %polly.loop_cond115 = icmp sle i64 %polly.indvar112, %polly.adjust_ub114
  br i1 %polly.loop_cond115, label %polly.loop_header108, label %polly.merge105

polly.loop_header117:                             ; preds = %polly.loop_header108, %polly.loop_exit128
  %polly.indvar121 = phi i64 [ %polly.indvar_next122, %polly.loop_exit128 ], [ %132, %polly.loop_header108 ]
  %134 = mul i64 -1, %polly.indvar121
  %135 = mul i64 -1, %0
  %136 = add i64 %134, %135
  %137 = add i64 %136, -30
  %138 = add i64 %137, 20
  %139 = sub i64 %138, 1
  %140 = icmp slt i64 %137, 0
  %141 = select i1 %140, i64 %137, i64 %139
  %142 = sdiv i64 %141, 20
  %143 = icmp sgt i64 %142, %polly.indvar112
  %144 = select i1 %143, i64 %142, i64 %polly.indvar112
  %145 = sub i64 %134, 20
  %146 = add i64 %145, 1
  %147 = icmp slt i64 %134, 0
  %148 = select i1 %147, i64 %146, i64 %134
  %149 = sdiv i64 %148, 20
  %150 = add i64 %polly.indvar112, 31
  %151 = icmp slt i64 %149, %150
  %152 = select i1 %151, i64 %149, i64 %150
  %153 = icmp slt i64 %152, %108
  %154 = select i1 %153, i64 %152, i64 %108
  %polly.loop_guard129 = icmp sle i64 %144, %154
  br i1 %polly.loop_guard129, label %polly.loop_header126, label %polly.loop_exit128

polly.loop_exit128:                               ; preds = %polly.loop_exit137, %polly.loop_header117
  %polly.indvar_next122 = add nsw i64 %polly.indvar121, 32
  %polly.adjust_ub123 = sub i64 %133, 32
  %polly.loop_cond124 = icmp sle i64 %polly.indvar121, %polly.adjust_ub123
  br i1 %polly.loop_cond124, label %polly.loop_header117, label %polly.loop_exit119

polly.loop_header126:                             ; preds = %polly.loop_header117, %polly.loop_exit137
  %polly.indvar130 = phi i64 [ %polly.indvar_next131, %polly.loop_exit137 ], [ %144, %polly.loop_header117 ]
  %155 = mul i64 -20, %polly.indvar130
  %156 = add i64 %155, %135
  %157 = add i64 %156, 1
  %158 = icmp sgt i64 %polly.indvar121, %157
  %159 = select i1 %158, i64 %polly.indvar121, i64 %157
  %160 = add i64 %polly.indvar121, 31
  %161 = icmp slt i64 %155, %160
  %162 = select i1 %161, i64 %155, i64 %160
  %polly.loop_guard138 = icmp sle i64 %159, %162
  br i1 %polly.loop_guard138, label %polly.loop_header135, label %polly.loop_exit137

polly.loop_exit137:                               ; preds = %polly.loop_header135, %polly.loop_header126
  %polly.indvar_next131 = add nsw i64 %polly.indvar130, 1
  %polly.adjust_ub132 = sub i64 %154, 1
  %polly.loop_cond133 = icmp sle i64 %polly.indvar130, %polly.adjust_ub132
  br i1 %polly.loop_cond133, label %polly.loop_header126, label %polly.loop_exit128

polly.loop_header135:                             ; preds = %polly.loop_header126, %polly.loop_header135
  %polly.indvar139 = phi i64 [ %polly.indvar_next140, %polly.loop_header135 ], [ %159, %polly.loop_header126 ]
  %163 = mul i64 -1, %polly.indvar139
  %164 = add i64 %155, %163
  %p_scevgep33 = getelementptr [1200 x double]* %C, i64 %polly.indvar130, i64 %164
  %_p_scalar_144 = load double* %p_scevgep33
  %p_145 = fmul double %_p_scalar_144, %beta
  store double %p_145, double* %p_scevgep33
  %p_indvar.next29 = add i64 %164, 1
  %polly.indvar_next140 = add nsw i64 %polly.indvar139, 1
  %polly.adjust_ub141 = sub i64 %162, 1
  %polly.loop_cond142 = icmp sle i64 %polly.indvar139, %polly.adjust_ub141
  br i1 %polly.loop_cond142, label %polly.loop_header135, label %polly.loop_exit137
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, [1200 x double]* %C) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %n, 0
  br i1 %5, label %.preheader.lr.ph, label %22

.preheader.lr.ph:                                 ; preds = %.split
  %6 = zext i32 %n to i64
  %7 = zext i32 %n to i64
  %8 = icmp sgt i32 %n, 0
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
  %scevgep = getelementptr [1200 x double]* %C, i64 %indvar4, i64 %indvar
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
