; ModuleID = './linear-algebra/blas/syrk/syrk.c'
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
  %2 = bitcast i8* %0 to [1200 x double]*
  %3 = bitcast i8* %1 to [1000 x double]*
  call void @init_array(i32 1200, i32 1000, double* %alpha, double* %beta, [1200 x double]* %2, [1000 x double]* %3)
  call void (...)* @polybench_timer_start() #3
  %4 = load double* %alpha, align 8, !tbaa !1
  %5 = load double* %beta, align 8, !tbaa !1
  call void @kernel_syrk(i32 1200, i32 1000, double %4, double %5, [1200 x double]* %2, [1000 x double]* %3)
  call void (...)* @polybench_timer_stop() #3
  call void (...)* @polybench_timer_print() #3
  %6 = icmp sgt i32 %argc, 42
  br i1 %6, label %7, label %11

; <label>:7                                       ; preds = %.split
  %8 = load i8** %argv, align 8, !tbaa !5
  %9 = load i8* %8, align 1, !tbaa !7
  %phitmp = icmp eq i8 %9, 0
  br i1 %phitmp, label %10, label %11

; <label>:10                                      ; preds = %7
  call void @print_array(i32 1200, [1200 x double]* %2)
  br label %11

; <label>:11                                      ; preds = %7, %10, %.split
  call void @free(i8* %0) #3
  call void @free(i8* %1) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %n, i32 %m, double* %alpha, double* %beta, [1200 x double]* %C, [1000 x double]* %A) #0 {
.split:
  %alpha24 = bitcast double* %alpha to i8*
  %beta25 = bitcast double* %beta to i8*
  %A27 = bitcast [1000 x double]* %A to i8*
  %A26 = ptrtoint [1000 x double]* %A to i64
  %0 = icmp ult i8* %alpha24, %beta25
  %1 = icmp ult i8* %beta25, %alpha24
  %pair-no-alias = or i1 %0, %1
  %2 = zext i32 %n to i64
  %3 = add i64 %2, -1
  %4 = mul i64 8000, %3
  %5 = add i64 %A26, %4
  %6 = zext i32 %m to i64
  %7 = add i64 %6, -1
  %8 = mul i64 8, %7
  %9 = add i64 %5, %8
  %10 = inttoptr i64 %9 to i8*
  %11 = icmp ult i8* %alpha24, %A27
  %12 = icmp ult i8* %10, %alpha24
  %pair-no-alias28 = or i1 %11, %12
  %13 = and i1 %pair-no-alias, %pair-no-alias28
  %14 = icmp ult i8* %beta25, %A27
  %15 = icmp ult i8* %10, %beta25
  %pair-no-alias29 = or i1 %14, %15
  %16 = and i1 %13, %pair-no-alias29
  br i1 %16, label %polly.start73, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  store double 1.500000e+00, double* %alpha, align 8, !tbaa !1
  store double 1.200000e+00, double* %beta, align 8, !tbaa !1
  %17 = icmp sgt i32 %n, 0
  br i1 %17, label %.preheader2.lr.ph.clone, label %polly.start

.preheader2.lr.ph.clone:                          ; preds = %.split.split.clone
  %18 = sitofp i32 %n to double
  %19 = sext i32 %m to i64
  %20 = icmp sge i64 %19, 1
  %21 = icmp sge i64 %2, 1
  %22 = and i1 %20, %21
  %23 = icmp sge i64 %6, 1
  %24 = and i1 %22, %23
  br i1 %24, label %polly.then126, label %polly.start

polly.start:                                      ; preds = %polly.then126, %polly.loop_exit139, %.preheader2.lr.ph.clone, %polly.then78, %polly.loop_exit91, %polly.start73, %.split.split.clone
  %25 = sext i32 %n to i64
  %26 = icmp sge i64 %25, 1
  %27 = icmp sge i64 %2, 1
  %28 = and i1 %26, %27
  br i1 %28, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.then, %polly.loop_exit44, %polly.start
  ret void

polly.then:                                       ; preds = %polly.start
  %polly.loop_guard = icmp sle i64 0, %3
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit44
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit44 ], [ 0, %polly.then ]
  %29 = mul i64 -11, %2
  %30 = add i64 %29, 5
  %31 = sub i64 %30, 32
  %32 = add i64 %31, 1
  %33 = icmp slt i64 %30, 0
  %34 = select i1 %33, i64 %32, i64 %30
  %35 = sdiv i64 %34, 32
  %36 = mul i64 -32, %35
  %37 = mul i64 -32, %2
  %38 = add i64 %36, %37
  %39 = mul i64 -32, %polly.indvar
  %40 = mul i64 -3, %polly.indvar
  %41 = add i64 %40, %2
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
  %53 = mul i64 -20, %polly.indvar
  %polly.loop_guard45 = icmp sle i64 %52, %53
  br i1 %polly.loop_guard45, label %polly.loop_header42, label %polly.loop_exit44

polly.loop_exit44:                                ; preds = %polly.loop_exit53, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %3, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge

polly.loop_header42:                              ; preds = %polly.loop_header, %polly.loop_exit53
  %polly.indvar46 = phi i64 [ %polly.indvar_next47, %polly.loop_exit53 ], [ %52, %polly.loop_header ]
  %54 = mul i64 -1, %polly.indvar46
  %55 = mul i64 -1, %2
  %56 = add i64 %54, %55
  %57 = add i64 %56, -30
  %58 = add i64 %57, 20
  %59 = sub i64 %58, 1
  %60 = icmp slt i64 %57, 0
  %61 = select i1 %60, i64 %57, i64 %59
  %62 = sdiv i64 %61, 20
  %63 = icmp sgt i64 %62, %polly.indvar
  %64 = select i1 %63, i64 %62, i64 %polly.indvar
  %65 = sub i64 %54, 20
  %66 = add i64 %65, 1
  %67 = icmp slt i64 %54, 0
  %68 = select i1 %67, i64 %66, i64 %54
  %69 = sdiv i64 %68, 20
  %70 = add i64 %polly.indvar, 31
  %71 = icmp slt i64 %69, %70
  %72 = select i1 %71, i64 %69, i64 %70
  %73 = icmp slt i64 %72, %3
  %74 = select i1 %73, i64 %72, i64 %3
  %polly.loop_guard54 = icmp sle i64 %64, %74
  br i1 %polly.loop_guard54, label %polly.loop_header51, label %polly.loop_exit53

polly.loop_exit53:                                ; preds = %polly.loop_exit62, %polly.loop_header42
  %polly.indvar_next47 = add nsw i64 %polly.indvar46, 32
  %polly.adjust_ub48 = sub i64 %53, 32
  %polly.loop_cond49 = icmp sle i64 %polly.indvar46, %polly.adjust_ub48
  br i1 %polly.loop_cond49, label %polly.loop_header42, label %polly.loop_exit44

polly.loop_header51:                              ; preds = %polly.loop_header42, %polly.loop_exit62
  %polly.indvar55 = phi i64 [ %polly.indvar_next56, %polly.loop_exit62 ], [ %64, %polly.loop_header42 ]
  %75 = mul i64 -20, %polly.indvar55
  %76 = add i64 %75, %55
  %77 = add i64 %76, 1
  %78 = icmp sgt i64 %polly.indvar46, %77
  %79 = select i1 %78, i64 %polly.indvar46, i64 %77
  %80 = add i64 %polly.indvar46, 31
  %81 = icmp slt i64 %75, %80
  %82 = select i1 %81, i64 %75, i64 %80
  %polly.loop_guard63 = icmp sle i64 %79, %82
  br i1 %polly.loop_guard63, label %polly.loop_header60, label %polly.loop_exit62

polly.loop_exit62:                                ; preds = %polly.loop_header60, %polly.loop_header51
  %polly.indvar_next56 = add nsw i64 %polly.indvar55, 1
  %polly.adjust_ub57 = sub i64 %74, 1
  %polly.loop_cond58 = icmp sle i64 %polly.indvar55, %polly.adjust_ub57
  br i1 %polly.loop_cond58, label %polly.loop_header51, label %polly.loop_exit53

polly.loop_header60:                              ; preds = %polly.loop_header51, %polly.loop_header60
  %polly.indvar64 = phi i64 [ %polly.indvar_next65, %polly.loop_header60 ], [ %79, %polly.loop_header51 ]
  %83 = mul i64 -1, %polly.indvar64
  %84 = add i64 %75, %83
  %p_.moved.to. = sitofp i32 %m to double
  %p_scevgep = getelementptr [1200 x double]* %C, i64 %polly.indvar55, i64 %84
  %p_ = mul i64 %polly.indvar55, %84
  %p_68 = trunc i64 %p_ to i32
  %p_69 = srem i32 %p_68, %m
  %p_70 = sitofp i32 %p_69 to double
  %p_71 = fdiv double %p_70, %p_.moved.to.
  store double %p_71, double* %p_scevgep
  %p_indvar.next = add i64 %84, 1
  %polly.indvar_next65 = add nsw i64 %polly.indvar64, 1
  %polly.adjust_ub66 = sub i64 %82, 1
  %polly.loop_cond67 = icmp sle i64 %polly.indvar64, %polly.adjust_ub66
  br i1 %polly.loop_cond67, label %polly.loop_header60, label %polly.loop_exit62

polly.start73:                                    ; preds = %.split
  store double 1.500000e+00, double* %alpha
  store double 1.200000e+00, double* %beta
  %85 = sext i32 %m to i64
  %86 = icmp sge i64 %85, 1
  %87 = sext i32 %n to i64
  %88 = icmp sge i64 %87, 1
  %89 = and i1 %86, %88
  %90 = icmp sge i64 %2, 1
  %91 = and i1 %89, %90
  %92 = icmp sge i64 %6, 1
  %93 = and i1 %91, %92
  br i1 %93, label %polly.then78, label %polly.start

polly.then78:                                     ; preds = %polly.start73
  %polly.loop_guard83 = icmp sle i64 0, %3
  br i1 %polly.loop_guard83, label %polly.loop_header80, label %polly.start

polly.loop_header80:                              ; preds = %polly.then78, %polly.loop_exit91
  %polly.indvar84 = phi i64 [ %polly.indvar_next85, %polly.loop_exit91 ], [ 0, %polly.then78 ]
  %94 = mul i64 -3, %2
  %95 = add i64 %94, %6
  %96 = add i64 %95, 5
  %97 = sub i64 %96, 32
  %98 = add i64 %97, 1
  %99 = icmp slt i64 %96, 0
  %100 = select i1 %99, i64 %98, i64 %96
  %101 = sdiv i64 %100, 32
  %102 = mul i64 -32, %101
  %103 = mul i64 -32, %2
  %104 = add i64 %102, %103
  %105 = mul i64 -32, %polly.indvar84
  %106 = mul i64 -3, %polly.indvar84
  %107 = add i64 %106, %6
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
  %119 = mul i64 -20, %polly.indvar84
  %polly.loop_guard92 = icmp sle i64 %118, %119
  br i1 %polly.loop_guard92, label %polly.loop_header89, label %polly.loop_exit91

polly.loop_exit91:                                ; preds = %polly.loop_exit100, %polly.loop_header80
  %polly.indvar_next85 = add nsw i64 %polly.indvar84, 32
  %polly.adjust_ub86 = sub i64 %3, 32
  %polly.loop_cond87 = icmp sle i64 %polly.indvar84, %polly.adjust_ub86
  br i1 %polly.loop_cond87, label %polly.loop_header80, label %polly.start

polly.loop_header89:                              ; preds = %polly.loop_header80, %polly.loop_exit100
  %polly.indvar93 = phi i64 [ %polly.indvar_next94, %polly.loop_exit100 ], [ %118, %polly.loop_header80 ]
  %120 = mul i64 -1, %polly.indvar93
  %121 = mul i64 -1, %6
  %122 = add i64 %120, %121
  %123 = add i64 %122, -30
  %124 = add i64 %123, 20
  %125 = sub i64 %124, 1
  %126 = icmp slt i64 %123, 0
  %127 = select i1 %126, i64 %123, i64 %125
  %128 = sdiv i64 %127, 20
  %129 = icmp sgt i64 %128, %polly.indvar84
  %130 = select i1 %129, i64 %128, i64 %polly.indvar84
  %131 = sub i64 %120, 20
  %132 = add i64 %131, 1
  %133 = icmp slt i64 %120, 0
  %134 = select i1 %133, i64 %132, i64 %120
  %135 = sdiv i64 %134, 20
  %136 = add i64 %polly.indvar84, 31
  %137 = icmp slt i64 %135, %136
  %138 = select i1 %137, i64 %135, i64 %136
  %139 = icmp slt i64 %138, %3
  %140 = select i1 %139, i64 %138, i64 %3
  %polly.loop_guard101 = icmp sle i64 %130, %140
  br i1 %polly.loop_guard101, label %polly.loop_header98, label %polly.loop_exit100

polly.loop_exit100:                               ; preds = %polly.loop_exit109, %polly.loop_header89
  %polly.indvar_next94 = add nsw i64 %polly.indvar93, 32
  %polly.adjust_ub95 = sub i64 %119, 32
  %polly.loop_cond96 = icmp sle i64 %polly.indvar93, %polly.adjust_ub95
  br i1 %polly.loop_cond96, label %polly.loop_header89, label %polly.loop_exit91

polly.loop_header98:                              ; preds = %polly.loop_header89, %polly.loop_exit109
  %polly.indvar102 = phi i64 [ %polly.indvar_next103, %polly.loop_exit109 ], [ %130, %polly.loop_header89 ]
  %141 = mul i64 -20, %polly.indvar102
  %142 = add i64 %141, %121
  %143 = add i64 %142, 1
  %144 = icmp sgt i64 %polly.indvar93, %143
  %145 = select i1 %144, i64 %polly.indvar93, i64 %143
  %146 = add i64 %polly.indvar93, 31
  %147 = icmp slt i64 %141, %146
  %148 = select i1 %147, i64 %141, i64 %146
  %polly.loop_guard110 = icmp sle i64 %145, %148
  br i1 %polly.loop_guard110, label %polly.loop_header107, label %polly.loop_exit109

polly.loop_exit109:                               ; preds = %polly.loop_header107, %polly.loop_header98
  %polly.indvar_next103 = add nsw i64 %polly.indvar102, 1
  %polly.adjust_ub104 = sub i64 %140, 1
  %polly.loop_cond105 = icmp sle i64 %polly.indvar102, %polly.adjust_ub104
  br i1 %polly.loop_cond105, label %polly.loop_header98, label %polly.loop_exit100

polly.loop_header107:                             ; preds = %polly.loop_header98, %polly.loop_header107
  %polly.indvar111 = phi i64 [ %polly.indvar_next112, %polly.loop_header107 ], [ %145, %polly.loop_header98 ]
  %149 = mul i64 -1, %polly.indvar111
  %150 = add i64 %141, %149
  %p_.moved.to.35 = sitofp i32 %n to double
  %p_scevgep21 = getelementptr [1000 x double]* %A, i64 %polly.indvar102, i64 %150
  %p_116 = mul i64 %polly.indvar102, %150
  %p_117 = trunc i64 %p_116 to i32
  %p_118 = srem i32 %p_117, %n
  %p_119 = sitofp i32 %p_118 to double
  %p_120 = fdiv double %p_119, %p_.moved.to.35
  store double %p_120, double* %p_scevgep21
  %p_indvar.next17 = add i64 %150, 1
  %polly.indvar_next112 = add nsw i64 %polly.indvar111, 1
  %polly.adjust_ub113 = sub i64 %148, 1
  %polly.loop_cond114 = icmp sle i64 %polly.indvar111, %polly.adjust_ub113
  br i1 %polly.loop_cond114, label %polly.loop_header107, label %polly.loop_exit109

polly.then126:                                    ; preds = %.preheader2.lr.ph.clone
  %polly.loop_guard131 = icmp sle i64 0, %3
  br i1 %polly.loop_guard131, label %polly.loop_header128, label %polly.start

polly.loop_header128:                             ; preds = %polly.then126, %polly.loop_exit139
  %polly.indvar132 = phi i64 [ %polly.indvar_next133, %polly.loop_exit139 ], [ 0, %polly.then126 ]
  %151 = mul i64 -3, %2
  %152 = add i64 %151, %6
  %153 = add i64 %152, 5
  %154 = sub i64 %153, 32
  %155 = add i64 %154, 1
  %156 = icmp slt i64 %153, 0
  %157 = select i1 %156, i64 %155, i64 %153
  %158 = sdiv i64 %157, 32
  %159 = mul i64 -32, %158
  %160 = mul i64 -32, %2
  %161 = add i64 %159, %160
  %162 = mul i64 -32, %polly.indvar132
  %163 = mul i64 -3, %polly.indvar132
  %164 = add i64 %163, %6
  %165 = add i64 %164, 5
  %166 = sub i64 %165, 32
  %167 = add i64 %166, 1
  %168 = icmp slt i64 %165, 0
  %169 = select i1 %168, i64 %167, i64 %165
  %170 = sdiv i64 %169, 32
  %171 = mul i64 -32, %170
  %172 = add i64 %162, %171
  %173 = add i64 %172, -640
  %174 = icmp sgt i64 %161, %173
  %175 = select i1 %174, i64 %161, i64 %173
  %176 = mul i64 -20, %polly.indvar132
  %polly.loop_guard140 = icmp sle i64 %175, %176
  br i1 %polly.loop_guard140, label %polly.loop_header137, label %polly.loop_exit139

polly.loop_exit139:                               ; preds = %polly.loop_exit148, %polly.loop_header128
  %polly.indvar_next133 = add nsw i64 %polly.indvar132, 32
  %polly.adjust_ub134 = sub i64 %3, 32
  %polly.loop_cond135 = icmp sle i64 %polly.indvar132, %polly.adjust_ub134
  br i1 %polly.loop_cond135, label %polly.loop_header128, label %polly.start

polly.loop_header137:                             ; preds = %polly.loop_header128, %polly.loop_exit148
  %polly.indvar141 = phi i64 [ %polly.indvar_next142, %polly.loop_exit148 ], [ %175, %polly.loop_header128 ]
  %177 = mul i64 -1, %polly.indvar141
  %178 = mul i64 -1, %6
  %179 = add i64 %177, %178
  %180 = add i64 %179, -30
  %181 = add i64 %180, 20
  %182 = sub i64 %181, 1
  %183 = icmp slt i64 %180, 0
  %184 = select i1 %183, i64 %180, i64 %182
  %185 = sdiv i64 %184, 20
  %186 = icmp sgt i64 %185, %polly.indvar132
  %187 = select i1 %186, i64 %185, i64 %polly.indvar132
  %188 = sub i64 %177, 20
  %189 = add i64 %188, 1
  %190 = icmp slt i64 %177, 0
  %191 = select i1 %190, i64 %189, i64 %177
  %192 = sdiv i64 %191, 20
  %193 = add i64 %polly.indvar132, 31
  %194 = icmp slt i64 %192, %193
  %195 = select i1 %194, i64 %192, i64 %193
  %196 = icmp slt i64 %195, %3
  %197 = select i1 %196, i64 %195, i64 %3
  %polly.loop_guard149 = icmp sle i64 %187, %197
  br i1 %polly.loop_guard149, label %polly.loop_header146, label %polly.loop_exit148

polly.loop_exit148:                               ; preds = %polly.loop_exit157, %polly.loop_header137
  %polly.indvar_next142 = add nsw i64 %polly.indvar141, 32
  %polly.adjust_ub143 = sub i64 %176, 32
  %polly.loop_cond144 = icmp sle i64 %polly.indvar141, %polly.adjust_ub143
  br i1 %polly.loop_cond144, label %polly.loop_header137, label %polly.loop_exit139

polly.loop_header146:                             ; preds = %polly.loop_header137, %polly.loop_exit157
  %polly.indvar150 = phi i64 [ %polly.indvar_next151, %polly.loop_exit157 ], [ %187, %polly.loop_header137 ]
  %198 = mul i64 -20, %polly.indvar150
  %199 = add i64 %198, %178
  %200 = add i64 %199, 1
  %201 = icmp sgt i64 %polly.indvar141, %200
  %202 = select i1 %201, i64 %polly.indvar141, i64 %200
  %203 = add i64 %polly.indvar141, 31
  %204 = icmp slt i64 %198, %203
  %205 = select i1 %204, i64 %198, i64 %203
  %polly.loop_guard158 = icmp sle i64 %202, %205
  br i1 %polly.loop_guard158, label %polly.loop_header155, label %polly.loop_exit157

polly.loop_exit157:                               ; preds = %polly.loop_header155, %polly.loop_header146
  %polly.indvar_next151 = add nsw i64 %polly.indvar150, 1
  %polly.adjust_ub152 = sub i64 %197, 1
  %polly.loop_cond153 = icmp sle i64 %polly.indvar150, %polly.adjust_ub152
  br i1 %polly.loop_cond153, label %polly.loop_header146, label %polly.loop_exit148

polly.loop_header155:                             ; preds = %polly.loop_header146, %polly.loop_header155
  %polly.indvar159 = phi i64 [ %polly.indvar_next160, %polly.loop_header155 ], [ %202, %polly.loop_header146 ]
  %206 = mul i64 -1, %polly.indvar159
  %207 = add i64 %198, %206
  %p_scevgep21.clone = getelementptr [1000 x double]* %A, i64 %polly.indvar150, i64 %207
  %p_164 = mul i64 %polly.indvar150, %207
  %p_165 = trunc i64 %p_164 to i32
  %p_166 = srem i32 %p_165, %n
  %p_167 = sitofp i32 %p_166 to double
  %p_168 = fdiv double %p_167, %18
  store double %p_168, double* %p_scevgep21.clone
  %p_indvar.next17.clone = add i64 %207, 1
  %polly.indvar_next160 = add nsw i64 %polly.indvar159, 1
  %polly.adjust_ub161 = sub i64 %205, 1
  %polly.loop_cond162 = icmp sle i64 %polly.indvar159, %polly.adjust_ub161
  br i1 %polly.loop_cond162, label %polly.loop_header155, label %polly.loop_exit157
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_syrk(i32 %n, i32 %m, double %alpha, double %beta, [1200 x double]* %C, [1000 x double]* %A) #0 {
.split:
  %A29 = ptrtoint [1000 x double]* %A to i64
  %C27 = ptrtoint [1200 x double]* %C to i64
  %umin31 = bitcast [1200 x double]* %C to i8*
  %0 = zext i32 %n to i64
  %1 = add i64 %0, -1
  %2 = mul i64 9600, %1
  %3 = add i64 %C27, %2
  %4 = mul i64 8, %1
  %5 = add i64 %3, %4
  %umax32 = inttoptr i64 %5 to i8*
  %umin2833 = bitcast [1000 x double]* %A to i8*
  %6 = mul i64 8000, %1
  %7 = add i64 %A29, %6
  %8 = zext i32 %m to i64
  %9 = add i64 %8, -1
  %10 = mul i64 8, %9
  %11 = add i64 %7, %10
  %12 = add i64 %A29, %10
  %13 = add i64 %12, %6
  %14 = icmp ugt i64 %13, %11
  %umax30 = select i1 %14, i64 %13, i64 %11
  %umax3034 = inttoptr i64 %umax30 to i8*
  %15 = icmp ult i8* %umax32, %umin2833
  %16 = icmp ult i8* %umax3034, %umin31
  %pair-no-alias = or i1 %15, %16
  br i1 %pair-no-alias, label %polly.start, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  %17 = icmp sgt i32 %n, 0
  br i1 %17, label %.preheader2.lr.ph.clone, label %.region.clone

.preheader2.lr.ph.clone:                          ; preds = %.split.split.clone
  %18 = icmp sgt i32 %m, 0
  br label %.preheader2.clone

.preheader2.clone:                                ; preds = %._crit_edge7.clone, %.preheader2.lr.ph.clone
  %indvar11.clone = phi i64 [ 0, %.preheader2.lr.ph.clone ], [ %20, %._crit_edge7.clone ]
  %19 = mul i64 %indvar11.clone, 9600
  %i.08.clone = trunc i64 %indvar11.clone to i32
  %20 = add i64 %indvar11.clone, 1
  %21 = icmp slt i32 %i.08.clone, 0
  br i1 %21, label %.preheader1.clone, label %polly.cond179

.preheader1.clone:                                ; preds = %polly.then184, %polly.loop_header186, %polly.cond179, %.preheader2.clone
  br i1 %18, label %.preheader.lr.ph.clone, label %._crit_edge7.clone

.preheader.lr.ph.clone:                           ; preds = %.preheader1.clone
  br label %.preheader.clone

.preheader.clone:                                 ; preds = %._crit_edge.clone, %.preheader.lr.ph.clone
  %indvar16.clone = phi i64 [ 0, %.preheader.lr.ph.clone ], [ %indvar.next17.clone, %._crit_edge.clone ]
  %scevgep22.clone = getelementptr [1000 x double]* %A, i64 %indvar11.clone, i64 %indvar16.clone
  br i1 %21, label %._crit_edge.clone, label %.lr.ph5.clone

._crit_edge.clone:                                ; preds = %.lr.ph5.clone, %.preheader.clone
  %indvar.next17.clone = add i64 %indvar16.clone, 1
  %exitcond20.clone = icmp ne i64 %indvar.next17.clone, %8
  br i1 %exitcond20.clone, label %.preheader.clone, label %._crit_edge7.clone

._crit_edge7.clone:                               ; preds = %._crit_edge.clone, %.preheader1.clone
  %exitcond23.clone = icmp ne i64 %20, %0
  br i1 %exitcond23.clone, label %.preheader2.clone, label %.region.clone

.lr.ph5.clone:                                    ; preds = %.preheader.clone, %.lr.ph5.clone
  %indvar13.clone = phi i64 [ %indvar.next14.clone, %.lr.ph5.clone ], [ 0, %.preheader.clone ]
  %scevgep19.clone = getelementptr [1200 x double]* %C, i64 %indvar11.clone, i64 %indvar13.clone
  %scevgep18.clone = getelementptr [1000 x double]* %A, i64 %indvar13.clone, i64 %indvar16.clone
  %22 = load double* %scevgep22.clone, align 8, !tbaa !1
  %23 = fmul double %22, %alpha
  %24 = load double* %scevgep18.clone, align 8, !tbaa !1
  %25 = fmul double %23, %24
  %26 = load double* %scevgep19.clone, align 8, !tbaa !1
  %27 = fadd double %26, %25
  store double %27, double* %scevgep19.clone, align 8, !tbaa !1
  %indvar.next14.clone = add i64 %indvar13.clone, 1
  %exitcond15.clone = icmp ne i64 %indvar.next14.clone, %20
  br i1 %exitcond15.clone, label %.lr.ph5.clone, label %._crit_edge.clone

.region.clone:                                    ; preds = %polly.then132, %polly.loop_exit145, %polly.cond130, %polly.start, %.split.split.clone, %._crit_edge7.clone
  ret void

polly.start:                                      ; preds = %.split
  %28 = sext i32 %n to i64
  %29 = icmp sge i64 %28, 1
  %30 = icmp sge i64 %0, 1
  %31 = and i1 %29, %30
  br i1 %31, label %polly.cond38, label %.region.clone

polly.cond38:                                     ; preds = %polly.start
  %32 = sext i32 %m to i64
  %33 = icmp sge i64 %32, 1
  %34 = icmp sge i64 %8, 1
  %35 = and i1 %33, %34
  br i1 %35, label %polly.then40, label %polly.cond84

polly.cond84:                                     ; preds = %polly.then40, %polly.loop_exit44, %polly.cond38
  %36 = icmp sle i64 %32, 0
  %37 = and i1 %36, %34
  br i1 %37, label %polly.then86, label %polly.cond130

polly.cond130:                                    ; preds = %polly.then86, %polly.loop_exit99, %polly.cond84
  %38 = icmp sle i64 %8, 0
  br i1 %38, label %polly.then132, label %.region.clone

polly.then40:                                     ; preds = %polly.cond38
  %polly.loop_guard = icmp sle i64 0, %1
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond84

polly.loop_header:                                ; preds = %polly.then40, %polly.loop_exit44
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit44 ], [ 0, %polly.then40 ]
  %39 = mul i64 -11, %0
  %40 = add i64 %39, 5
  %41 = sub i64 %40, 32
  %42 = add i64 %41, 1
  %43 = icmp slt i64 %40, 0
  %44 = select i1 %43, i64 %42, i64 %40
  %45 = sdiv i64 %44, 32
  %46 = mul i64 -32, %45
  %47 = mul i64 -32, %0
  %48 = add i64 %46, %47
  %49 = mul i64 -32, %polly.indvar
  %50 = mul i64 11, %polly.indvar
  %51 = add i64 %50, -1
  %52 = sub i64 %51, 32
  %53 = add i64 %52, 1
  %54 = icmp slt i64 %51, 0
  %55 = select i1 %54, i64 %53, i64 %51
  %56 = sdiv i64 %55, 32
  %57 = mul i64 32, %56
  %58 = add i64 %49, %57
  %59 = add i64 %58, -640
  %60 = icmp sgt i64 %48, %59
  %61 = select i1 %60, i64 %48, i64 %59
  %62 = mul i64 -20, %polly.indvar
  %polly.loop_guard45 = icmp sle i64 %61, %62
  br i1 %polly.loop_guard45, label %polly.loop_header42, label %polly.loop_exit44

polly.loop_exit44:                                ; preds = %polly.loop_exit53, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %1, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond84

polly.loop_header42:                              ; preds = %polly.loop_header, %polly.loop_exit53
  %polly.indvar46 = phi i64 [ %polly.indvar_next47, %polly.loop_exit53 ], [ %61, %polly.loop_header ]
  %63 = mul i64 -1, %polly.indvar46
  %64 = add i64 %63, -31
  %65 = add i64 %64, 21
  %66 = sub i64 %65, 1
  %67 = icmp slt i64 %64, 0
  %68 = select i1 %67, i64 %64, i64 %66
  %69 = sdiv i64 %68, 21
  %70 = icmp sgt i64 %69, %polly.indvar
  %71 = select i1 %70, i64 %69, i64 %polly.indvar
  %72 = sub i64 %63, 20
  %73 = add i64 %72, 1
  %74 = icmp slt i64 %63, 0
  %75 = select i1 %74, i64 %73, i64 %63
  %76 = sdiv i64 %75, 20
  %77 = add i64 %polly.indvar, 31
  %78 = icmp slt i64 %76, %77
  %79 = select i1 %78, i64 %76, i64 %77
  %80 = icmp slt i64 %79, %1
  %81 = select i1 %80, i64 %79, i64 %1
  %polly.loop_guard54 = icmp sle i64 %71, %81
  br i1 %polly.loop_guard54, label %polly.loop_header51, label %polly.loop_exit53

polly.loop_exit53:                                ; preds = %polly.loop_exit62, %polly.loop_header42
  %polly.indvar_next47 = add nsw i64 %polly.indvar46, 32
  %polly.adjust_ub48 = sub i64 %62, 32
  %polly.loop_cond49 = icmp sle i64 %polly.indvar46, %polly.adjust_ub48
  br i1 %polly.loop_cond49, label %polly.loop_header42, label %polly.loop_exit44

polly.loop_header51:                              ; preds = %polly.loop_header42, %polly.loop_exit62
  %polly.indvar55 = phi i64 [ %polly.indvar_next56, %polly.loop_exit62 ], [ %71, %polly.loop_header42 ]
  %82 = mul i64 -21, %polly.indvar55
  %83 = icmp sgt i64 %polly.indvar46, %82
  %84 = select i1 %83, i64 %polly.indvar46, i64 %82
  %85 = mul i64 -20, %polly.indvar55
  %86 = add i64 %polly.indvar46, 31
  %87 = icmp slt i64 %85, %86
  %88 = select i1 %87, i64 %85, i64 %86
  %polly.loop_guard63 = icmp sle i64 %84, %88
  br i1 %polly.loop_guard63, label %polly.loop_header60, label %polly.loop_exit62

polly.loop_exit62:                                ; preds = %polly.loop_exit71, %polly.loop_header51
  %polly.indvar_next56 = add nsw i64 %polly.indvar55, 1
  %polly.adjust_ub57 = sub i64 %81, 1
  %polly.loop_cond58 = icmp sle i64 %polly.indvar55, %polly.adjust_ub57
  br i1 %polly.loop_cond58, label %polly.loop_header51, label %polly.loop_exit53

polly.loop_header60:                              ; preds = %polly.loop_header51, %polly.loop_exit71
  %polly.indvar64 = phi i64 [ %polly.indvar_next65, %polly.loop_exit71 ], [ %84, %polly.loop_header51 ]
  %89 = mul i64 -1, %polly.indvar64
  %90 = add i64 %85, %89
  %p_.moved.to.37 = add i64 %polly.indvar55, 1
  %p_scevgep = getelementptr [1200 x double]* %C, i64 %polly.indvar55, i64 %90
  %_p_scalar_ = load double* %p_scevgep
  %p_ = fmul double %_p_scalar_, %beta
  store double %p_, double* %p_scevgep
  %p_indvar.next = add i64 %90, 1
  %polly.loop_guard72 = icmp sle i64 0, %9
  br i1 %polly.loop_guard72, label %polly.loop_header69, label %polly.loop_exit71

polly.loop_exit71:                                ; preds = %polly.loop_header69, %polly.loop_header60
  %polly.indvar_next65 = add nsw i64 %polly.indvar64, 1
  %polly.adjust_ub66 = sub i64 %88, 1
  %polly.loop_cond67 = icmp sle i64 %polly.indvar64, %polly.adjust_ub66
  br i1 %polly.loop_cond67, label %polly.loop_header60, label %polly.loop_exit62

polly.loop_header69:                              ; preds = %polly.loop_header60, %polly.loop_header69
  %polly.indvar73 = phi i64 [ %polly.indvar_next74, %polly.loop_header69 ], [ 0, %polly.loop_header60 ]
  %p_scevgep22.moved.to. = getelementptr [1000 x double]* %A, i64 %polly.indvar55, i64 %polly.indvar73
  %p_scevgep18 = getelementptr [1000 x double]* %A, i64 %90, i64 %polly.indvar73
  %_p_scalar_78 = load double* %p_scevgep22.moved.to.
  %p_79 = fmul double %_p_scalar_78, %alpha
  %_p_scalar_80 = load double* %p_scevgep18
  %p_81 = fmul double %p_79, %_p_scalar_80
  %_p_scalar_82 = load double* %p_scevgep
  %p_83 = fadd double %_p_scalar_82, %p_81
  store double %p_83, double* %p_scevgep
  %polly.indvar_next74 = add nsw i64 %polly.indvar73, 1
  %polly.adjust_ub75 = sub i64 %9, 1
  %polly.loop_cond76 = icmp sle i64 %polly.indvar73, %polly.adjust_ub75
  br i1 %polly.loop_cond76, label %polly.loop_header69, label %polly.loop_exit71

polly.then86:                                     ; preds = %polly.cond84
  %polly.loop_guard91 = icmp sle i64 0, %1
  br i1 %polly.loop_guard91, label %polly.loop_header88, label %polly.cond130

polly.loop_header88:                              ; preds = %polly.then86, %polly.loop_exit99
  %polly.indvar92 = phi i64 [ %polly.indvar_next93, %polly.loop_exit99 ], [ 0, %polly.then86 ]
  %91 = mul i64 -11, %0
  %92 = add i64 %91, 5
  %93 = sub i64 %92, 32
  %94 = add i64 %93, 1
  %95 = icmp slt i64 %92, 0
  %96 = select i1 %95, i64 %94, i64 %92
  %97 = sdiv i64 %96, 32
  %98 = mul i64 -32, %97
  %99 = mul i64 -32, %0
  %100 = add i64 %98, %99
  %101 = mul i64 -32, %polly.indvar92
  %102 = mul i64 11, %polly.indvar92
  %103 = add i64 %102, -1
  %104 = sub i64 %103, 32
  %105 = add i64 %104, 1
  %106 = icmp slt i64 %103, 0
  %107 = select i1 %106, i64 %105, i64 %103
  %108 = sdiv i64 %107, 32
  %109 = mul i64 32, %108
  %110 = add i64 %101, %109
  %111 = add i64 %110, -640
  %112 = icmp sgt i64 %100, %111
  %113 = select i1 %112, i64 %100, i64 %111
  %114 = mul i64 -20, %polly.indvar92
  %polly.loop_guard100 = icmp sle i64 %113, %114
  br i1 %polly.loop_guard100, label %polly.loop_header97, label %polly.loop_exit99

polly.loop_exit99:                                ; preds = %polly.loop_exit108, %polly.loop_header88
  %polly.indvar_next93 = add nsw i64 %polly.indvar92, 32
  %polly.adjust_ub94 = sub i64 %1, 32
  %polly.loop_cond95 = icmp sle i64 %polly.indvar92, %polly.adjust_ub94
  br i1 %polly.loop_cond95, label %polly.loop_header88, label %polly.cond130

polly.loop_header97:                              ; preds = %polly.loop_header88, %polly.loop_exit108
  %polly.indvar101 = phi i64 [ %polly.indvar_next102, %polly.loop_exit108 ], [ %113, %polly.loop_header88 ]
  %115 = mul i64 -1, %polly.indvar101
  %116 = add i64 %115, -31
  %117 = add i64 %116, 21
  %118 = sub i64 %117, 1
  %119 = icmp slt i64 %116, 0
  %120 = select i1 %119, i64 %116, i64 %118
  %121 = sdiv i64 %120, 21
  %122 = icmp sgt i64 %121, %polly.indvar92
  %123 = select i1 %122, i64 %121, i64 %polly.indvar92
  %124 = sub i64 %115, 20
  %125 = add i64 %124, 1
  %126 = icmp slt i64 %115, 0
  %127 = select i1 %126, i64 %125, i64 %115
  %128 = sdiv i64 %127, 20
  %129 = add i64 %polly.indvar92, 31
  %130 = icmp slt i64 %128, %129
  %131 = select i1 %130, i64 %128, i64 %129
  %132 = icmp slt i64 %131, %1
  %133 = select i1 %132, i64 %131, i64 %1
  %polly.loop_guard109 = icmp sle i64 %123, %133
  br i1 %polly.loop_guard109, label %polly.loop_header106, label %polly.loop_exit108

polly.loop_exit108:                               ; preds = %polly.loop_exit117, %polly.loop_header97
  %polly.indvar_next102 = add nsw i64 %polly.indvar101, 32
  %polly.adjust_ub103 = sub i64 %114, 32
  %polly.loop_cond104 = icmp sle i64 %polly.indvar101, %polly.adjust_ub103
  br i1 %polly.loop_cond104, label %polly.loop_header97, label %polly.loop_exit99

polly.loop_header106:                             ; preds = %polly.loop_header97, %polly.loop_exit117
  %polly.indvar110 = phi i64 [ %polly.indvar_next111, %polly.loop_exit117 ], [ %123, %polly.loop_header97 ]
  %134 = mul i64 -21, %polly.indvar110
  %135 = icmp sgt i64 %polly.indvar101, %134
  %136 = select i1 %135, i64 %polly.indvar101, i64 %134
  %137 = mul i64 -20, %polly.indvar110
  %138 = add i64 %polly.indvar101, 31
  %139 = icmp slt i64 %137, %138
  %140 = select i1 %139, i64 %137, i64 %138
  %polly.loop_guard118 = icmp sle i64 %136, %140
  br i1 %polly.loop_guard118, label %polly.loop_header115, label %polly.loop_exit117

polly.loop_exit117:                               ; preds = %polly.loop_header115, %polly.loop_header106
  %polly.indvar_next111 = add nsw i64 %polly.indvar110, 1
  %polly.adjust_ub112 = sub i64 %133, 1
  %polly.loop_cond113 = icmp sle i64 %polly.indvar110, %polly.adjust_ub112
  br i1 %polly.loop_cond113, label %polly.loop_header106, label %polly.loop_exit108

polly.loop_header115:                             ; preds = %polly.loop_header106, %polly.loop_header115
  %polly.indvar119 = phi i64 [ %polly.indvar_next120, %polly.loop_header115 ], [ %136, %polly.loop_header106 ]
  %141 = mul i64 -1, %polly.indvar119
  %142 = add i64 %137, %141
  %p_.moved.to.37124 = add i64 %polly.indvar110, 1
  %p_scevgep125 = getelementptr [1200 x double]* %C, i64 %polly.indvar110, i64 %142
  %_p_scalar_126 = load double* %p_scevgep125
  %p_127 = fmul double %_p_scalar_126, %beta
  store double %p_127, double* %p_scevgep125
  %p_indvar.next128 = add i64 %142, 1
  %polly.indvar_next120 = add nsw i64 %polly.indvar119, 1
  %polly.adjust_ub121 = sub i64 %140, 1
  %polly.loop_cond122 = icmp sle i64 %polly.indvar119, %polly.adjust_ub121
  br i1 %polly.loop_cond122, label %polly.loop_header115, label %polly.loop_exit117

polly.then132:                                    ; preds = %polly.cond130
  %polly.loop_guard137 = icmp sle i64 0, %1
  br i1 %polly.loop_guard137, label %polly.loop_header134, label %.region.clone

polly.loop_header134:                             ; preds = %polly.then132, %polly.loop_exit145
  %polly.indvar138 = phi i64 [ %polly.indvar_next139, %polly.loop_exit145 ], [ 0, %polly.then132 ]
  %143 = mul i64 -11, %0
  %144 = add i64 %143, 5
  %145 = sub i64 %144, 32
  %146 = add i64 %145, 1
  %147 = icmp slt i64 %144, 0
  %148 = select i1 %147, i64 %146, i64 %144
  %149 = sdiv i64 %148, 32
  %150 = mul i64 -32, %149
  %151 = mul i64 -32, %0
  %152 = add i64 %150, %151
  %153 = mul i64 -32, %polly.indvar138
  %154 = mul i64 11, %polly.indvar138
  %155 = add i64 %154, -1
  %156 = sub i64 %155, 32
  %157 = add i64 %156, 1
  %158 = icmp slt i64 %155, 0
  %159 = select i1 %158, i64 %157, i64 %155
  %160 = sdiv i64 %159, 32
  %161 = mul i64 32, %160
  %162 = add i64 %153, %161
  %163 = add i64 %162, -640
  %164 = icmp sgt i64 %152, %163
  %165 = select i1 %164, i64 %152, i64 %163
  %166 = mul i64 -20, %polly.indvar138
  %polly.loop_guard146 = icmp sle i64 %165, %166
  br i1 %polly.loop_guard146, label %polly.loop_header143, label %polly.loop_exit145

polly.loop_exit145:                               ; preds = %polly.loop_exit154, %polly.loop_header134
  %polly.indvar_next139 = add nsw i64 %polly.indvar138, 32
  %polly.adjust_ub140 = sub i64 %1, 32
  %polly.loop_cond141 = icmp sle i64 %polly.indvar138, %polly.adjust_ub140
  br i1 %polly.loop_cond141, label %polly.loop_header134, label %.region.clone

polly.loop_header143:                             ; preds = %polly.loop_header134, %polly.loop_exit154
  %polly.indvar147 = phi i64 [ %polly.indvar_next148, %polly.loop_exit154 ], [ %165, %polly.loop_header134 ]
  %167 = mul i64 -1, %polly.indvar147
  %168 = add i64 %167, -31
  %169 = add i64 %168, 21
  %170 = sub i64 %169, 1
  %171 = icmp slt i64 %168, 0
  %172 = select i1 %171, i64 %168, i64 %170
  %173 = sdiv i64 %172, 21
  %174 = icmp sgt i64 %173, %polly.indvar138
  %175 = select i1 %174, i64 %173, i64 %polly.indvar138
  %176 = sub i64 %167, 20
  %177 = add i64 %176, 1
  %178 = icmp slt i64 %167, 0
  %179 = select i1 %178, i64 %177, i64 %167
  %180 = sdiv i64 %179, 20
  %181 = add i64 %polly.indvar138, 31
  %182 = icmp slt i64 %180, %181
  %183 = select i1 %182, i64 %180, i64 %181
  %184 = icmp slt i64 %183, %1
  %185 = select i1 %184, i64 %183, i64 %1
  %polly.loop_guard155 = icmp sle i64 %175, %185
  br i1 %polly.loop_guard155, label %polly.loop_header152, label %polly.loop_exit154

polly.loop_exit154:                               ; preds = %polly.loop_exit163, %polly.loop_header143
  %polly.indvar_next148 = add nsw i64 %polly.indvar147, 32
  %polly.adjust_ub149 = sub i64 %166, 32
  %polly.loop_cond150 = icmp sle i64 %polly.indvar147, %polly.adjust_ub149
  br i1 %polly.loop_cond150, label %polly.loop_header143, label %polly.loop_exit145

polly.loop_header152:                             ; preds = %polly.loop_header143, %polly.loop_exit163
  %polly.indvar156 = phi i64 [ %polly.indvar_next157, %polly.loop_exit163 ], [ %175, %polly.loop_header143 ]
  %186 = mul i64 -21, %polly.indvar156
  %187 = icmp sgt i64 %polly.indvar147, %186
  %188 = select i1 %187, i64 %polly.indvar147, i64 %186
  %189 = mul i64 -20, %polly.indvar156
  %190 = add i64 %polly.indvar147, 31
  %191 = icmp slt i64 %189, %190
  %192 = select i1 %191, i64 %189, i64 %190
  %polly.loop_guard164 = icmp sle i64 %188, %192
  br i1 %polly.loop_guard164, label %polly.loop_header161, label %polly.loop_exit163

polly.loop_exit163:                               ; preds = %polly.loop_header161, %polly.loop_header152
  %polly.indvar_next157 = add nsw i64 %polly.indvar156, 1
  %polly.adjust_ub158 = sub i64 %185, 1
  %polly.loop_cond159 = icmp sle i64 %polly.indvar156, %polly.adjust_ub158
  br i1 %polly.loop_cond159, label %polly.loop_header152, label %polly.loop_exit154

polly.loop_header161:                             ; preds = %polly.loop_header152, %polly.loop_header161
  %polly.indvar165 = phi i64 [ %polly.indvar_next166, %polly.loop_header161 ], [ %188, %polly.loop_header152 ]
  %193 = mul i64 -1, %polly.indvar165
  %194 = add i64 %189, %193
  %p_.moved.to.37170 = add i64 %polly.indvar156, 1
  %p_scevgep171 = getelementptr [1200 x double]* %C, i64 %polly.indvar156, i64 %194
  %_p_scalar_172 = load double* %p_scevgep171
  %p_173 = fmul double %_p_scalar_172, %beta
  store double %p_173, double* %p_scevgep171
  %p_indvar.next174 = add i64 %194, 1
  %polly.indvar_next166 = add nsw i64 %polly.indvar165, 1
  %polly.adjust_ub167 = sub i64 %192, 1
  %polly.loop_cond168 = icmp sle i64 %polly.indvar165, %polly.adjust_ub167
  br i1 %polly.loop_cond168, label %polly.loop_header161, label %polly.loop_exit163

polly.cond179:                                    ; preds = %.preheader2.clone
  %195 = srem i64 %19, 8
  %196 = icmp eq i64 %195, 0
  %197 = icmp sge i64 %indvar11.clone, 0
  %or.cond = and i1 %196, %197
  br i1 %or.cond, label %polly.then184, label %.preheader1.clone

polly.then184:                                    ; preds = %polly.cond179
  br i1 %197, label %polly.loop_header186, label %.preheader1.clone

polly.loop_header186:                             ; preds = %polly.then184, %polly.loop_header186
  %polly.indvar190 = phi i64 [ %polly.indvar_next191, %polly.loop_header186 ], [ 0, %polly.then184 ]
  %p_scevgep.clone = getelementptr [1200 x double]* %C, i64 %indvar11.clone, i64 %polly.indvar190
  %_p_scalar_195 = load double* %p_scevgep.clone
  %p_196 = fmul double %_p_scalar_195, %beta
  store double %p_196, double* %p_scevgep.clone
  %p_indvar.next.clone = add i64 %polly.indvar190, 1
  %polly.indvar_next191 = add nsw i64 %polly.indvar190, 1
  %polly.adjust_ub192 = sub i64 %indvar11.clone, 1
  %polly.loop_cond193 = icmp sle i64 %polly.indvar190, %polly.adjust_ub192
  br i1 %polly.loop_cond193, label %polly.loop_header186, label %.preheader1.clone
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
