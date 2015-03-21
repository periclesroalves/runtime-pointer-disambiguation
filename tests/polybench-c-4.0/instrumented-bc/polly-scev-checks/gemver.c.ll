; ModuleID = './linear-algebra/blas/gemver/gemver.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [2 x i8] c"w\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %alpha = alloca double, align 8
  %beta = alloca double, align 8
  %0 = tail call i8* @polybench_alloc_data(i64 4000000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %2 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %3 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %4 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %5 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %6 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %7 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %8 = tail call i8* @polybench_alloc_data(i64 2000, i32 8) #3
  %9 = bitcast i8* %0 to [2000 x double]*
  %10 = bitcast i8* %1 to double*
  %11 = bitcast i8* %2 to double*
  %12 = bitcast i8* %3 to double*
  %13 = bitcast i8* %4 to double*
  %14 = bitcast i8* %5 to double*
  %15 = bitcast i8* %6 to double*
  %16 = bitcast i8* %7 to double*
  %17 = bitcast i8* %8 to double*
  call void @init_array(i32 2000, double* %alpha, double* %beta, [2000 x double]* %9, double* %10, double* %11, double* %12, double* %13, double* %14, double* %15, double* %16, double* %17)
  call void (...)* @polybench_timer_start() #3
  %18 = load double* %alpha, align 8, !tbaa !1
  %19 = load double* %beta, align 8, !tbaa !1
  call void @kernel_gemver(i32 2000, double %18, double %19, [2000 x double]* %9, double* %10, double* %11, double* %12, double* %13, double* %14, double* %15, double* %16, double* %17)
  call void (...)* @polybench_timer_stop() #3
  call void (...)* @polybench_timer_print() #3
  %20 = icmp sgt i32 %argc, 42
  br i1 %20, label %21, label %25

; <label>:21                                      ; preds = %.split
  %22 = load i8** %argv, align 8, !tbaa !5
  %23 = load i8* %22, align 1, !tbaa !7
  %phitmp = icmp eq i8 %23, 0
  br i1 %phitmp, label %24, label %25

; <label>:24                                      ; preds = %21
  call void @print_array(i32 2000, double* %14)
  br label %25

; <label>:25                                      ; preds = %21, %24, %.split
  call void @free(i8* %0) #3
  call void @free(i8* %1) #3
  call void @free(i8* %2) #3
  call void @free(i8* %3) #3
  call void @free(i8* %4) #3
  call void @free(i8* %5) #3
  call void @free(i8* %6) #3
  call void @free(i8* %7) #3
  call void @free(i8* %8) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %n, double* %alpha, double* %beta, [2000 x double]* %A, double* %u1, double* %v1, double* %u2, double* %v2, double* %w, double* %x, double* %y, double* %z) #0 {
.split:
  %alpha19 = bitcast double* %alpha to i8*
  %beta20 = bitcast double* %beta to i8*
  %A22 = bitcast [2000 x double]* %A to i8*
  %u125 = bitcast double* %u1 to i8*
  %v128 = bitcast double* %v1 to i8*
  %u231 = bitcast double* %u2 to i8*
  %v234 = bitcast double* %v2 to i8*
  %w37 = bitcast double* %w to i8*
  %x40 = bitcast double* %x to i8*
  %y43 = bitcast double* %y to i8*
  %z46 = bitcast double* %z to i8*
  %z45 = ptrtoint double* %z to i64
  %y42 = ptrtoint double* %y to i64
  %x39 = ptrtoint double* %x to i64
  %w36 = ptrtoint double* %w to i64
  %v233 = ptrtoint double* %v2 to i64
  %u230 = ptrtoint double* %u2 to i64
  %v127 = ptrtoint double* %v1 to i64
  %u124 = ptrtoint double* %u1 to i64
  %A21 = ptrtoint [2000 x double]* %A to i64
  %0 = icmp ult i8* %alpha19, %beta20
  %1 = icmp ult i8* %beta20, %alpha19
  %pair-no-alias = or i1 %0, %1
  %2 = zext i32 %n to i64
  %3 = add i64 %2, -1
  %4 = mul i64 16000, %3
  %5 = add i64 %A21, %4
  %6 = mul i64 8, %3
  %7 = add i64 %5, %6
  %8 = inttoptr i64 %7 to i8*
  %9 = icmp ult i8* %alpha19, %A22
  %10 = icmp ult i8* %8, %alpha19
  %pair-no-alias23 = or i1 %9, %10
  %11 = and i1 %pair-no-alias, %pair-no-alias23
  %12 = add i64 %u124, %6
  %13 = inttoptr i64 %12 to i8*
  %14 = icmp ult i8* %alpha19, %u125
  %15 = icmp ult i8* %13, %alpha19
  %pair-no-alias26 = or i1 %14, %15
  %16 = and i1 %11, %pair-no-alias26
  %17 = add i64 %v127, %6
  %18 = inttoptr i64 %17 to i8*
  %19 = icmp ult i8* %alpha19, %v128
  %20 = icmp ult i8* %18, %alpha19
  %pair-no-alias29 = or i1 %19, %20
  %21 = and i1 %16, %pair-no-alias29
  %22 = add i64 %u230, %6
  %23 = inttoptr i64 %22 to i8*
  %24 = icmp ult i8* %alpha19, %u231
  %25 = icmp ult i8* %23, %alpha19
  %pair-no-alias32 = or i1 %24, %25
  %26 = and i1 %21, %pair-no-alias32
  %27 = add i64 %v233, %6
  %28 = inttoptr i64 %27 to i8*
  %29 = icmp ult i8* %alpha19, %v234
  %30 = icmp ult i8* %28, %alpha19
  %pair-no-alias35 = or i1 %29, %30
  %31 = and i1 %26, %pair-no-alias35
  %32 = add i64 %w36, %6
  %33 = inttoptr i64 %32 to i8*
  %34 = icmp ult i8* %alpha19, %w37
  %35 = icmp ult i8* %33, %alpha19
  %pair-no-alias38 = or i1 %34, %35
  %36 = and i1 %31, %pair-no-alias38
  %37 = add i64 %x39, %6
  %38 = inttoptr i64 %37 to i8*
  %39 = icmp ult i8* %alpha19, %x40
  %40 = icmp ult i8* %38, %alpha19
  %pair-no-alias41 = or i1 %39, %40
  %41 = and i1 %36, %pair-no-alias41
  %42 = add i64 %y42, %6
  %43 = inttoptr i64 %42 to i8*
  %44 = icmp ult i8* %alpha19, %y43
  %45 = icmp ult i8* %43, %alpha19
  %pair-no-alias44 = or i1 %44, %45
  %46 = and i1 %41, %pair-no-alias44
  %47 = add i64 %z45, %6
  %48 = inttoptr i64 %47 to i8*
  %49 = icmp ult i8* %alpha19, %z46
  %50 = icmp ult i8* %48, %alpha19
  %pair-no-alias47 = or i1 %49, %50
  %51 = and i1 %46, %pair-no-alias47
  %52 = icmp ult i8* %beta20, %A22
  %53 = icmp ult i8* %8, %beta20
  %pair-no-alias48 = or i1 %52, %53
  %54 = and i1 %51, %pair-no-alias48
  %55 = icmp ult i8* %beta20, %u125
  %56 = icmp ult i8* %13, %beta20
  %pair-no-alias49 = or i1 %55, %56
  %57 = and i1 %54, %pair-no-alias49
  %58 = icmp ult i8* %beta20, %v128
  %59 = icmp ult i8* %18, %beta20
  %pair-no-alias50 = or i1 %58, %59
  %60 = and i1 %57, %pair-no-alias50
  %61 = icmp ult i8* %beta20, %u231
  %62 = icmp ult i8* %23, %beta20
  %pair-no-alias51 = or i1 %61, %62
  %63 = and i1 %60, %pair-no-alias51
  %64 = icmp ult i8* %beta20, %v234
  %65 = icmp ult i8* %28, %beta20
  %pair-no-alias52 = or i1 %64, %65
  %66 = and i1 %63, %pair-no-alias52
  %67 = icmp ult i8* %beta20, %w37
  %68 = icmp ult i8* %33, %beta20
  %pair-no-alias53 = or i1 %67, %68
  %69 = and i1 %66, %pair-no-alias53
  %70 = icmp ult i8* %beta20, %x40
  %71 = icmp ult i8* %38, %beta20
  %pair-no-alias54 = or i1 %70, %71
  %72 = and i1 %69, %pair-no-alias54
  %73 = icmp ult i8* %beta20, %y43
  %74 = icmp ult i8* %43, %beta20
  %pair-no-alias55 = or i1 %73, %74
  %75 = and i1 %72, %pair-no-alias55
  %76 = icmp ult i8* %beta20, %z46
  %77 = icmp ult i8* %48, %beta20
  %pair-no-alias56 = or i1 %76, %77
  %78 = and i1 %75, %pair-no-alias56
  %79 = icmp ult i8* %8, %u125
  %80 = icmp ult i8* %13, %A22
  %pair-no-alias57 = or i1 %79, %80
  %81 = and i1 %78, %pair-no-alias57
  %82 = icmp ult i8* %8, %v128
  %83 = icmp ult i8* %18, %A22
  %pair-no-alias58 = or i1 %82, %83
  %84 = and i1 %81, %pair-no-alias58
  %85 = icmp ult i8* %8, %u231
  %86 = icmp ult i8* %23, %A22
  %pair-no-alias59 = or i1 %85, %86
  %87 = and i1 %84, %pair-no-alias59
  %88 = icmp ult i8* %8, %v234
  %89 = icmp ult i8* %28, %A22
  %pair-no-alias60 = or i1 %88, %89
  %90 = and i1 %87, %pair-no-alias60
  %91 = icmp ult i8* %8, %w37
  %92 = icmp ult i8* %33, %A22
  %pair-no-alias61 = or i1 %91, %92
  %93 = and i1 %90, %pair-no-alias61
  %94 = icmp ult i8* %8, %x40
  %95 = icmp ult i8* %38, %A22
  %pair-no-alias62 = or i1 %94, %95
  %96 = and i1 %93, %pair-no-alias62
  %97 = icmp ult i8* %8, %y43
  %98 = icmp ult i8* %43, %A22
  %pair-no-alias63 = or i1 %97, %98
  %99 = and i1 %96, %pair-no-alias63
  %100 = icmp ult i8* %8, %z46
  %101 = icmp ult i8* %48, %A22
  %pair-no-alias64 = or i1 %100, %101
  %102 = and i1 %99, %pair-no-alias64
  %103 = icmp ult i8* %13, %v128
  %104 = icmp ult i8* %18, %u125
  %pair-no-alias65 = or i1 %103, %104
  %105 = and i1 %102, %pair-no-alias65
  %106 = icmp ult i8* %13, %u231
  %107 = icmp ult i8* %23, %u125
  %pair-no-alias66 = or i1 %106, %107
  %108 = and i1 %105, %pair-no-alias66
  %109 = icmp ult i8* %13, %v234
  %110 = icmp ult i8* %28, %u125
  %pair-no-alias67 = or i1 %109, %110
  %111 = and i1 %108, %pair-no-alias67
  %112 = icmp ult i8* %13, %w37
  %113 = icmp ult i8* %33, %u125
  %pair-no-alias68 = or i1 %112, %113
  %114 = and i1 %111, %pair-no-alias68
  %115 = icmp ult i8* %13, %x40
  %116 = icmp ult i8* %38, %u125
  %pair-no-alias69 = or i1 %115, %116
  %117 = and i1 %114, %pair-no-alias69
  %118 = icmp ult i8* %13, %y43
  %119 = icmp ult i8* %43, %u125
  %pair-no-alias70 = or i1 %118, %119
  %120 = and i1 %117, %pair-no-alias70
  %121 = icmp ult i8* %13, %z46
  %122 = icmp ult i8* %48, %u125
  %pair-no-alias71 = or i1 %121, %122
  %123 = and i1 %120, %pair-no-alias71
  %124 = icmp ult i8* %18, %u231
  %125 = icmp ult i8* %23, %v128
  %pair-no-alias72 = or i1 %124, %125
  %126 = and i1 %123, %pair-no-alias72
  %127 = icmp ult i8* %18, %v234
  %128 = icmp ult i8* %28, %v128
  %pair-no-alias73 = or i1 %127, %128
  %129 = and i1 %126, %pair-no-alias73
  %130 = icmp ult i8* %18, %w37
  %131 = icmp ult i8* %33, %v128
  %pair-no-alias74 = or i1 %130, %131
  %132 = and i1 %129, %pair-no-alias74
  %133 = icmp ult i8* %18, %x40
  %134 = icmp ult i8* %38, %v128
  %pair-no-alias75 = or i1 %133, %134
  %135 = and i1 %132, %pair-no-alias75
  %136 = icmp ult i8* %18, %y43
  %137 = icmp ult i8* %43, %v128
  %pair-no-alias76 = or i1 %136, %137
  %138 = and i1 %135, %pair-no-alias76
  %139 = icmp ult i8* %18, %z46
  %140 = icmp ult i8* %48, %v128
  %pair-no-alias77 = or i1 %139, %140
  %141 = and i1 %138, %pair-no-alias77
  %142 = icmp ult i8* %23, %v234
  %143 = icmp ult i8* %28, %u231
  %pair-no-alias78 = or i1 %142, %143
  %144 = and i1 %141, %pair-no-alias78
  %145 = icmp ult i8* %23, %w37
  %146 = icmp ult i8* %33, %u231
  %pair-no-alias79 = or i1 %145, %146
  %147 = and i1 %144, %pair-no-alias79
  %148 = icmp ult i8* %23, %x40
  %149 = icmp ult i8* %38, %u231
  %pair-no-alias80 = or i1 %148, %149
  %150 = and i1 %147, %pair-no-alias80
  %151 = icmp ult i8* %23, %y43
  %152 = icmp ult i8* %43, %u231
  %pair-no-alias81 = or i1 %151, %152
  %153 = and i1 %150, %pair-no-alias81
  %154 = icmp ult i8* %23, %z46
  %155 = icmp ult i8* %48, %u231
  %pair-no-alias82 = or i1 %154, %155
  %156 = and i1 %153, %pair-no-alias82
  %157 = icmp ult i8* %28, %w37
  %158 = icmp ult i8* %33, %v234
  %pair-no-alias83 = or i1 %157, %158
  %159 = and i1 %156, %pair-no-alias83
  %160 = icmp ult i8* %28, %x40
  %161 = icmp ult i8* %38, %v234
  %pair-no-alias84 = or i1 %160, %161
  %162 = and i1 %159, %pair-no-alias84
  %163 = icmp ult i8* %28, %y43
  %164 = icmp ult i8* %43, %v234
  %pair-no-alias85 = or i1 %163, %164
  %165 = and i1 %162, %pair-no-alias85
  %166 = icmp ult i8* %28, %z46
  %167 = icmp ult i8* %48, %v234
  %pair-no-alias86 = or i1 %166, %167
  %168 = and i1 %165, %pair-no-alias86
  %169 = icmp ult i8* %33, %x40
  %170 = icmp ult i8* %38, %w37
  %pair-no-alias87 = or i1 %169, %170
  %171 = and i1 %168, %pair-no-alias87
  %172 = icmp ult i8* %33, %y43
  %173 = icmp ult i8* %43, %w37
  %pair-no-alias88 = or i1 %172, %173
  %174 = and i1 %171, %pair-no-alias88
  %175 = icmp ult i8* %33, %z46
  %176 = icmp ult i8* %48, %w37
  %pair-no-alias89 = or i1 %175, %176
  %177 = and i1 %174, %pair-no-alias89
  %178 = icmp ult i8* %38, %y43
  %179 = icmp ult i8* %43, %x40
  %pair-no-alias90 = or i1 %178, %179
  %180 = and i1 %177, %pair-no-alias90
  %181 = icmp ult i8* %38, %z46
  %182 = icmp ult i8* %48, %x40
  %pair-no-alias91 = or i1 %181, %182
  %183 = and i1 %180, %pair-no-alias91
  %184 = icmp ult i8* %43, %z46
  %185 = icmp ult i8* %48, %y43
  %pair-no-alias92 = or i1 %184, %185
  %186 = and i1 %183, %pair-no-alias92
  br i1 %186, label %polly.start, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  store double 1.500000e+00, double* %alpha, align 8, !tbaa !1
  store double 1.200000e+00, double* %beta, align 8, !tbaa !1
  %187 = sitofp i32 %n to double
  %188 = icmp sgt i32 %n, 0
  br i1 %188, label %.lr.ph5.clone, label %.region.clone

.lr.ph5.clone:                                    ; preds = %.split.split.clone
  br label %189

; <label>:189                                     ; preds = %polly.merge164, %.lr.ph5.clone
  %190 = phi i64 [ 0, %.lr.ph5.clone ], [ %192, %polly.merge164 ]
  %191 = mul i64 %190, 16000
  %i.02.clone = trunc i64 %190 to i32
  %192 = add i64 %190, 1
  %193 = trunc i64 %192 to i32
  %scevgep11.clone = getelementptr double* %u1, i64 %190
  %scevgep12.clone = getelementptr double* %u2, i64 %190
  %scevgep13.clone = getelementptr double* %v1, i64 %190
  %scevgep14.clone = getelementptr double* %v2, i64 %190
  %scevgep15.clone = getelementptr double* %y, i64 %190
  %scevgep16.clone = getelementptr double* %z, i64 %190
  %scevgep17.clone = getelementptr double* %x, i64 %190
  %scevgep18.clone = getelementptr double* %w, i64 %190
  %194 = sitofp i32 %i.02.clone to double
  store double %194, double* %scevgep11.clone, align 8, !tbaa !1
  %195 = sitofp i32 %193 to double
  %196 = fdiv double %195, %187
  %197 = fmul double %196, 5.000000e-01
  store double %197, double* %scevgep12.clone, align 8, !tbaa !1
  %198 = fmul double %196, 2.500000e-01
  store double %198, double* %scevgep13.clone, align 8, !tbaa !1
  %199 = fdiv double %196, 6.000000e+00
  store double %199, double* %scevgep14.clone, align 8, !tbaa !1
  %200 = fmul double %196, 1.250000e-01
  store double %200, double* %scevgep15.clone, align 8, !tbaa !1
  %201 = fdiv double %196, 9.000000e+00
  store double %201, double* %scevgep16.clone, align 8, !tbaa !1
  store double 0.000000e+00, double* %scevgep17.clone, align 8, !tbaa !1
  store double 0.000000e+00, double* %scevgep18.clone, align 8, !tbaa !1
  br i1 %188, label %polly.cond163, label %polly.merge164

polly.merge164:                                   ; preds = %polly.then168, %polly.loop_header170, %polly.cond163, %189
  %exitcond9.clone = icmp ne i64 %192, %2
  br i1 %exitcond9.clone, label %189, label %.region.clone

.region.clone:                                    ; preds = %.split.split.clone, %polly.merge164, %polly.stmt..split.split
  ret void

polly.start:                                      ; preds = %.split
  %202 = sext i32 %n to i64
  %203 = icmp sge i64 %202, 1
  %204 = icmp sge i64 %2, 1
  %205 = and i1 %203, %204
  br i1 %205, label %polly.then, label %polly.cond128

polly.cond128:                                    ; preds = %polly.then, %polly.loop_exit100, %polly.start
  br i1 %205, label %polly.then130, label %polly.stmt..split.split

polly.stmt..split.split:                          ; preds = %polly.then130, %polly.loop_header132, %polly.cond128
  store double 1.500000e+00, double* %alpha
  store double 1.200000e+00, double* %beta
  br label %.region.clone

polly.then:                                       ; preds = %polly.start
  %polly.loop_guard = icmp sle i64 0, %3
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond128

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit100
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit100 ], [ 0, %polly.then ]
  %206 = mul i64 -11, %2
  %207 = add i64 %206, 5
  %208 = sub i64 %207, 32
  %209 = add i64 %208, 1
  %210 = icmp slt i64 %207, 0
  %211 = select i1 %210, i64 %209, i64 %207
  %212 = sdiv i64 %211, 32
  %213 = mul i64 -32, %212
  %214 = mul i64 -32, %2
  %215 = add i64 %213, %214
  %216 = mul i64 -32, %polly.indvar
  %217 = mul i64 -3, %polly.indvar
  %218 = add i64 %217, %2
  %219 = add i64 %218, 5
  %220 = sub i64 %219, 32
  %221 = add i64 %220, 1
  %222 = icmp slt i64 %219, 0
  %223 = select i1 %222, i64 %221, i64 %219
  %224 = sdiv i64 %223, 32
  %225 = mul i64 -32, %224
  %226 = add i64 %216, %225
  %227 = add i64 %226, -640
  %228 = icmp sgt i64 %215, %227
  %229 = select i1 %228, i64 %215, i64 %227
  %230 = mul i64 -20, %polly.indvar
  %polly.loop_guard101 = icmp sle i64 %229, %230
  br i1 %polly.loop_guard101, label %polly.loop_header98, label %polly.loop_exit100

polly.loop_exit100:                               ; preds = %polly.loop_exit109, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %3, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond128

polly.loop_header98:                              ; preds = %polly.loop_header, %polly.loop_exit109
  %polly.indvar102 = phi i64 [ %polly.indvar_next103, %polly.loop_exit109 ], [ %229, %polly.loop_header ]
  %231 = mul i64 -1, %polly.indvar102
  %232 = mul i64 -1, %2
  %233 = add i64 %231, %232
  %234 = add i64 %233, -30
  %235 = add i64 %234, 20
  %236 = sub i64 %235, 1
  %237 = icmp slt i64 %234, 0
  %238 = select i1 %237, i64 %234, i64 %236
  %239 = sdiv i64 %238, 20
  %240 = icmp sgt i64 %239, %polly.indvar
  %241 = select i1 %240, i64 %239, i64 %polly.indvar
  %242 = sub i64 %231, 20
  %243 = add i64 %242, 1
  %244 = icmp slt i64 %231, 0
  %245 = select i1 %244, i64 %243, i64 %231
  %246 = sdiv i64 %245, 20
  %247 = add i64 %polly.indvar, 31
  %248 = icmp slt i64 %246, %247
  %249 = select i1 %248, i64 %246, i64 %247
  %250 = icmp slt i64 %249, %3
  %251 = select i1 %250, i64 %249, i64 %3
  %polly.loop_guard110 = icmp sle i64 %241, %251
  br i1 %polly.loop_guard110, label %polly.loop_header107, label %polly.loop_exit109

polly.loop_exit109:                               ; preds = %polly.loop_exit118, %polly.loop_header98
  %polly.indvar_next103 = add nsw i64 %polly.indvar102, 32
  %polly.adjust_ub104 = sub i64 %230, 32
  %polly.loop_cond105 = icmp sle i64 %polly.indvar102, %polly.adjust_ub104
  br i1 %polly.loop_cond105, label %polly.loop_header98, label %polly.loop_exit100

polly.loop_header107:                             ; preds = %polly.loop_header98, %polly.loop_exit118
  %polly.indvar111 = phi i64 [ %polly.indvar_next112, %polly.loop_exit118 ], [ %241, %polly.loop_header98 ]
  %252 = mul i64 -20, %polly.indvar111
  %253 = add i64 %252, %232
  %254 = add i64 %253, 1
  %255 = icmp sgt i64 %polly.indvar102, %254
  %256 = select i1 %255, i64 %polly.indvar102, i64 %254
  %257 = add i64 %polly.indvar102, 31
  %258 = icmp slt i64 %252, %257
  %259 = select i1 %258, i64 %252, i64 %257
  %polly.loop_guard119 = icmp sle i64 %256, %259
  br i1 %polly.loop_guard119, label %polly.loop_header116, label %polly.loop_exit118

polly.loop_exit118:                               ; preds = %polly.loop_header116, %polly.loop_header107
  %polly.indvar_next112 = add nsw i64 %polly.indvar111, 1
  %polly.adjust_ub113 = sub i64 %251, 1
  %polly.loop_cond114 = icmp sle i64 %polly.indvar111, %polly.adjust_ub113
  br i1 %polly.loop_cond114, label %polly.loop_header107, label %polly.loop_exit109

polly.loop_header116:                             ; preds = %polly.loop_header107, %polly.loop_header116
  %polly.indvar120 = phi i64 [ %polly.indvar_next121, %polly.loop_header116 ], [ %256, %polly.loop_header107 ]
  %260 = mul i64 -1, %polly.indvar120
  %261 = add i64 %252, %260
  %p_.moved.to.94 = sitofp i32 %n to double
  %p_scevgep = getelementptr [2000 x double]* %A, i64 %polly.indvar111, i64 %261
  %p_ = mul i64 %polly.indvar111, %261
  %p_124 = trunc i64 %p_ to i32
  %p_125 = srem i32 %p_124, %n
  %p_126 = sitofp i32 %p_125 to double
  %p_127 = fdiv double %p_126, %p_.moved.to.94
  store double %p_127, double* %p_scevgep
  %p_indvar.next = add i64 %261, 1
  %polly.indvar_next121 = add nsw i64 %polly.indvar120, 1
  %polly.adjust_ub122 = sub i64 %259, 1
  %polly.loop_cond123 = icmp sle i64 %polly.indvar120, %polly.adjust_ub122
  br i1 %polly.loop_cond123, label %polly.loop_header116, label %polly.loop_exit118

polly.then130:                                    ; preds = %polly.cond128
  %polly.loop_guard135 = icmp sle i64 0, %3
  br i1 %polly.loop_guard135, label %polly.loop_header132, label %polly.stmt..split.split

polly.loop_header132:                             ; preds = %polly.then130, %polly.loop_header132
  %polly.indvar136 = phi i64 [ %polly.indvar_next137, %polly.loop_header132 ], [ 0, %polly.then130 ]
  %p_.moved.to. = sitofp i32 %n to double
  %p_i.02 = trunc i64 %polly.indvar136 to i32
  %p_141 = add i64 %polly.indvar136, 1
  %p_142 = trunc i64 %p_141 to i32
  %p_scevgep11 = getelementptr double* %u1, i64 %polly.indvar136
  %p_scevgep12 = getelementptr double* %u2, i64 %polly.indvar136
  %p_scevgep13 = getelementptr double* %v1, i64 %polly.indvar136
  %p_scevgep14 = getelementptr double* %v2, i64 %polly.indvar136
  %p_scevgep15 = getelementptr double* %y, i64 %polly.indvar136
  %p_scevgep16 = getelementptr double* %z, i64 %polly.indvar136
  %p_scevgep17 = getelementptr double* %x, i64 %polly.indvar136
  %p_scevgep18 = getelementptr double* %w, i64 %polly.indvar136
  %p_143 = sitofp i32 %p_i.02 to double
  store double %p_143, double* %p_scevgep11
  %p_144 = sitofp i32 %p_142 to double
  %p_145 = fdiv double %p_144, %p_.moved.to.
  %p_146 = fmul double %p_145, 5.000000e-01
  store double %p_146, double* %p_scevgep12
  %p_149 = fmul double %p_145, 2.500000e-01
  store double %p_149, double* %p_scevgep13
  %p_152 = fdiv double %p_145, 6.000000e+00
  store double %p_152, double* %p_scevgep14
  %p_155 = fmul double %p_145, 1.250000e-01
  store double %p_155, double* %p_scevgep15
  %p_158 = fdiv double %p_145, 9.000000e+00
  store double %p_158, double* %p_scevgep16
  store double 0.000000e+00, double* %p_scevgep17
  store double 0.000000e+00, double* %p_scevgep18
  %polly.indvar_next137 = add nsw i64 %polly.indvar136, 1
  %polly.adjust_ub138 = sub i64 %3, 1
  %polly.loop_cond139 = icmp sle i64 %polly.indvar136, %polly.adjust_ub138
  br i1 %polly.loop_cond139, label %polly.loop_header132, label %polly.stmt..split.split

polly.cond163:                                    ; preds = %189
  %262 = srem i64 %191, 8
  %263 = icmp eq i64 %262, 0
  %264 = icmp sge i64 %2, 1
  %or.cond = and i1 %263, %264
  br i1 %or.cond, label %polly.then168, label %polly.merge164

polly.then168:                                    ; preds = %polly.cond163
  %polly.loop_guard173 = icmp sle i64 0, %3
  br i1 %polly.loop_guard173, label %polly.loop_header170, label %polly.merge164

polly.loop_header170:                             ; preds = %polly.then168, %polly.loop_header170
  %polly.indvar174 = phi i64 [ %polly.indvar_next175, %polly.loop_header170 ], [ 0, %polly.then168 ]
  %p_scevgep.clone = getelementptr [2000 x double]* %A, i64 %190, i64 %polly.indvar174
  %p_179 = mul i64 %190, %polly.indvar174
  %p_180 = trunc i64 %p_179 to i32
  %p_181 = srem i32 %p_180, %n
  %p_182 = sitofp i32 %p_181 to double
  %p_183 = fdiv double %p_182, %187
  store double %p_183, double* %p_scevgep.clone
  %p_indvar.next.clone = add i64 %polly.indvar174, 1
  %polly.indvar_next175 = add nsw i64 %polly.indvar174, 1
  %polly.adjust_ub176 = sub i64 %3, 1
  %polly.loop_cond177 = icmp sle i64 %polly.indvar174, %polly.adjust_ub176
  br i1 %polly.loop_cond177, label %polly.loop_header170, label %polly.merge164
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_gemver(i32 %n, double %alpha, double %beta, [2000 x double]* %A, double* %u1, double* %v1, double* %u2, double* %v2, double* %w, double* %x, double* %y, double* %z) #0 {
.split:
  %A54 = bitcast [2000 x double]* %A to i8*
  %w82 = bitcast double* %w to i8*
  %x72 = bitcast double* %x to i8*
  %x71 = ptrtoint double* %x to i64
  %w81 = ptrtoint double* %w to i64
  %A52 = ptrtoint [2000 x double]* %A to i64
  %z79 = bitcast double* %z to i8*
  %z78 = ptrtoint double* %z to i64
  %y75 = bitcast double* %y to i8*
  %y74 = ptrtoint double* %y to i64
  %u155 = bitcast double* %u1 to i8*
  %v157 = bitcast double* %v1 to i8*
  %u260 = bitcast double* %u2 to i8*
  %v263 = bitcast double* %v2 to i8*
  %v262 = ptrtoint double* %v2 to i64
  %u259 = ptrtoint double* %u2 to i64
  %v156 = ptrtoint double* %v1 to i64
  %u153 = ptrtoint double* %u1 to i64
  %0 = zext i32 %n to i64
  %1 = add i64 %0, -1
  %2 = mul i64 16000, %1
  %3 = add i64 %A52, %2
  %4 = mul i64 8, %1
  %5 = add i64 %3, %4
  %6 = inttoptr i64 %5 to i8*
  %7 = add i64 %u153, %4
  %8 = inttoptr i64 %7 to i8*
  %9 = icmp ult i8* %6, %u155
  %10 = icmp ult i8* %8, %A54
  %pair-no-alias = or i1 %9, %10
  %11 = add i64 %v156, %4
  %12 = inttoptr i64 %11 to i8*
  %13 = icmp ult i8* %6, %v157
  %14 = icmp ult i8* %12, %A54
  %pair-no-alias58 = or i1 %13, %14
  %15 = and i1 %pair-no-alias, %pair-no-alias58
  %16 = add i64 %u259, %4
  %17 = inttoptr i64 %16 to i8*
  %18 = icmp ult i8* %6, %u260
  %19 = icmp ult i8* %17, %A54
  %pair-no-alias61 = or i1 %18, %19
  %20 = and i1 %15, %pair-no-alias61
  %21 = add i64 %v262, %4
  %22 = inttoptr i64 %21 to i8*
  %23 = icmp ult i8* %6, %v263
  %24 = icmp ult i8* %22, %A54
  %pair-no-alias64 = or i1 %23, %24
  %25 = and i1 %20, %pair-no-alias64
  %26 = icmp ult i8* %8, %v157
  %27 = icmp ult i8* %12, %u155
  %pair-no-alias65 = or i1 %26, %27
  %28 = and i1 %25, %pair-no-alias65
  %29 = icmp ult i8* %8, %u260
  %30 = icmp ult i8* %17, %u155
  %pair-no-alias66 = or i1 %29, %30
  %31 = and i1 %28, %pair-no-alias66
  %32 = icmp ult i8* %8, %v263
  %33 = icmp ult i8* %22, %u155
  %pair-no-alias67 = or i1 %32, %33
  %34 = and i1 %31, %pair-no-alias67
  %35 = icmp ult i8* %12, %u260
  %36 = icmp ult i8* %17, %v157
  %pair-no-alias68 = or i1 %35, %36
  %37 = and i1 %34, %pair-no-alias68
  %38 = icmp ult i8* %12, %v263
  %39 = icmp ult i8* %22, %v157
  %pair-no-alias69 = or i1 %38, %39
  %40 = and i1 %37, %pair-no-alias69
  %41 = icmp ult i8* %17, %v263
  %42 = icmp ult i8* %22, %u260
  %pair-no-alias70 = or i1 %41, %42
  %43 = and i1 %40, %pair-no-alias70
  br i1 %43, label %polly.start195, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  %44 = icmp sgt i32 %n, 0
  br i1 %44, label %.preheader5.lr.ph.clone, label %.preheader4

.preheader5.lr.ph.clone:                          ; preds = %.split.split.clone
  br label %.preheader5.clone

.preheader5.clone:                                ; preds = %._crit_edge17.clone, %.preheader5.lr.ph.clone
  %indvar43.clone = phi i64 [ 0, %.preheader5.lr.ph.clone ], [ %indvar.next44.clone, %._crit_edge17.clone ]
  %scevgep50.clone = getelementptr double* %u1, i64 %indvar43.clone
  %scevgep51.clone = getelementptr double* %u2, i64 %indvar43.clone
  br i1 %44, label %.lr.ph16.clone, label %._crit_edge17.clone

.lr.ph16.clone:                                   ; preds = %.preheader5.clone, %.lr.ph16.clone
  %indvar40.clone = phi i64 [ %indvar.next41.clone, %.lr.ph16.clone ], [ 0, %.preheader5.clone ]
  %scevgep45.clone = getelementptr [2000 x double]* %A, i64 %indvar43.clone, i64 %indvar40.clone
  %scevgep46.clone = getelementptr double* %v1, i64 %indvar40.clone
  %scevgep47.clone = getelementptr double* %v2, i64 %indvar40.clone
  %45 = load double* %scevgep45.clone, align 8, !tbaa !1
  %46 = load double* %scevgep50.clone, align 8, !tbaa !1
  %47 = load double* %scevgep46.clone, align 8, !tbaa !1
  %48 = fmul double %46, %47
  %49 = fadd double %45, %48
  %50 = load double* %scevgep51.clone, align 8, !tbaa !1
  %51 = load double* %scevgep47.clone, align 8, !tbaa !1
  %52 = fmul double %50, %51
  %53 = fadd double %49, %52
  store double %53, double* %scevgep45.clone, align 8, !tbaa !1
  %indvar.next41.clone = add i64 %indvar40.clone, 1
  %exitcond42.clone = icmp ne i64 %indvar.next41.clone, %0
  br i1 %exitcond42.clone, label %.lr.ph16.clone, label %._crit_edge17.clone

._crit_edge17.clone:                              ; preds = %.lr.ph16.clone, %.preheader5.clone
  %indvar.next44.clone = add i64 %indvar43.clone, 1
  %exitcond48.clone = icmp ne i64 %indvar.next44.clone, %0
  br i1 %exitcond48.clone, label %.preheader5.clone, label %.preheader4

.preheader4:                                      ; preds = %polly.then199, %polly.loop_exit212, %polly.start195, %.split.split.clone, %._crit_edge17.clone
  %54 = add i64 %A52, %4
  %55 = add i64 %54, %2
  %56 = inttoptr i64 %55 to i8*
  %57 = add i64 %x71, %4
  %58 = inttoptr i64 %57 to i8*
  %59 = icmp ult i8* %56, %x72
  %60 = icmp ult i8* %58, %A54
  %pair-no-alias73 = or i1 %59, %60
  %61 = add i64 %y74, %4
  %62 = inttoptr i64 %61 to i8*
  %63 = icmp ult i8* %56, %y75
  %64 = icmp ult i8* %62, %A54
  %pair-no-alias76 = or i1 %63, %64
  %65 = and i1 %pair-no-alias73, %pair-no-alias76
  %66 = icmp ult i8* %58, %y75
  %67 = icmp ult i8* %62, %x72
  %pair-no-alias77 = or i1 %66, %67
  %68 = and i1 %65, %pair-no-alias77
  br i1 %68, label %polly.start146, label %.preheader4.split.clone

.preheader4.split.clone:                          ; preds = %.preheader4
  %69 = icmp sgt i32 %n, 0
  br i1 %69, label %.preheader3.lr.ph.clone, label %.preheader2

.preheader3.lr.ph.clone:                          ; preds = %.preheader4.split.clone
  br label %.preheader3.clone

.preheader3.clone:                                ; preds = %._crit_edge13.clone, %.preheader3.lr.ph.clone
  %indvar33.clone = phi i64 [ 0, %.preheader3.lr.ph.clone ], [ %indvar.next34.clone, %._crit_edge13.clone ]
  %scevgep39.clone = getelementptr double* %x, i64 %indvar33.clone
  br i1 %69, label %.lr.ph12.clone, label %._crit_edge13.clone

.lr.ph12.clone:                                   ; preds = %.preheader3.clone, %.lr.ph12.clone
  %indvar30.clone = phi i64 [ %indvar.next31.clone, %.lr.ph12.clone ], [ 0, %.preheader3.clone ]
  %scevgep35.clone = getelementptr [2000 x double]* %A, i64 %indvar30.clone, i64 %indvar33.clone
  %scevgep36.clone = getelementptr double* %y, i64 %indvar30.clone
  %70 = load double* %scevgep39.clone, align 8, !tbaa !1
  %71 = load double* %scevgep35.clone, align 8, !tbaa !1
  %72 = fmul double %71, %beta
  %73 = load double* %scevgep36.clone, align 8, !tbaa !1
  %74 = fmul double %72, %73
  %75 = fadd double %70, %74
  store double %75, double* %scevgep39.clone, align 8, !tbaa !1
  %indvar.next31.clone = add i64 %indvar30.clone, 1
  %exitcond32.clone = icmp ne i64 %indvar.next31.clone, %0
  br i1 %exitcond32.clone, label %.lr.ph12.clone, label %._crit_edge13.clone

._crit_edge13.clone:                              ; preds = %.lr.ph12.clone, %.preheader3.clone
  %indvar.next34.clone = add i64 %indvar33.clone, 1
  %exitcond37.clone = icmp ne i64 %indvar.next34.clone, %0
  br i1 %exitcond37.clone, label %.preheader3.clone, label %.preheader2

.preheader2:                                      ; preds = %polly.then150, %polly.loop_exit163, %polly.start146, %.preheader4.split.clone, %._crit_edge13.clone
  %76 = add i64 %z78, %4
  %77 = inttoptr i64 %76 to i8*
  %78 = icmp ult i8* %58, %z79
  %79 = icmp ult i8* %77, %x72
  %pair-no-alias80 = or i1 %78, %79
  br i1 %pair-no-alias80, label %polly.start127, label %.preheader2.split.clone

.preheader2.split.clone:                          ; preds = %.preheader2
  %80 = icmp sgt i32 %n, 0
  br i1 %80, label %.lr.ph10.clone, label %.preheader1

.lr.ph10.clone:                                   ; preds = %.preheader2.split.clone
  br label %81

; <label>:81                                      ; preds = %81, %.lr.ph10.clone
  %indvar25.clone = phi i64 [ 0, %.lr.ph10.clone ], [ %indvar.next26.clone, %81 ]
  %scevgep28.clone = getelementptr double* %x, i64 %indvar25.clone
  %scevgep29.clone = getelementptr double* %z, i64 %indvar25.clone
  %82 = load double* %scevgep28.clone, align 8, !tbaa !1
  %83 = load double* %scevgep29.clone, align 8, !tbaa !1
  %84 = fadd double %82, %83
  store double %84, double* %scevgep28.clone, align 8, !tbaa !1
  %indvar.next26.clone = add i64 %indvar25.clone, 1
  %exitcond27.clone = icmp ne i64 %indvar.next26.clone, %0
  br i1 %exitcond27.clone, label %81, label %.preheader1

.preheader1:                                      ; preds = %polly.then131, %polly.loop_header133, %polly.start127, %.preheader2.split.clone, %81
  %85 = add i64 %w81, %4
  %86 = inttoptr i64 %85 to i8*
  %87 = icmp ult i8* %6, %w82
  %88 = icmp ult i8* %86, %A54
  %pair-no-alias83 = or i1 %87, %88
  %89 = icmp ult i8* %6, %x72
  %pair-no-alias84 = or i1 %89, %60
  %90 = and i1 %pair-no-alias83, %pair-no-alias84
  %91 = icmp ult i8* %86, %x72
  %92 = icmp ult i8* %58, %w82
  %pair-no-alias85 = or i1 %91, %92
  %93 = and i1 %90, %pair-no-alias85
  br i1 %93, label %polly.start, label %.preheader1.split.clone

.preheader1.split.clone:                          ; preds = %.preheader1
  %94 = icmp sgt i32 %n, 0
  br i1 %94, label %.preheader.lr.ph.clone, label %.region.clone

.preheader.lr.ph.clone:                           ; preds = %.preheader1.split.clone
  br label %.preheader.clone

.preheader.clone:                                 ; preds = %._crit_edge.clone, %.preheader.lr.ph.clone
  %indvar19.clone = phi i64 [ 0, %.preheader.lr.ph.clone ], [ %indvar.next20.clone, %._crit_edge.clone ]
  %scevgep24.clone = getelementptr double* %w, i64 %indvar19.clone
  br i1 %94, label %.lr.ph.clone, label %._crit_edge.clone

.lr.ph.clone:                                     ; preds = %.preheader.clone, %.lr.ph.clone
  %indvar.clone = phi i64 [ %indvar.next.clone, %.lr.ph.clone ], [ 0, %.preheader.clone ]
  %scevgep.clone = getelementptr [2000 x double]* %A, i64 %indvar19.clone, i64 %indvar.clone
  %scevgep21.clone = getelementptr double* %x, i64 %indvar.clone
  %95 = load double* %scevgep24.clone, align 8, !tbaa !1
  %96 = load double* %scevgep.clone, align 8, !tbaa !1
  %97 = fmul double %96, %alpha
  %98 = load double* %scevgep21.clone, align 8, !tbaa !1
  %99 = fmul double %97, %98
  %100 = fadd double %95, %99
  store double %100, double* %scevgep24.clone, align 8, !tbaa !1
  %indvar.next.clone = add i64 %indvar.clone, 1
  %exitcond.clone = icmp ne i64 %indvar.next.clone, %0
  br i1 %exitcond.clone, label %.lr.ph.clone, label %._crit_edge.clone

._crit_edge.clone:                                ; preds = %.lr.ph.clone, %.preheader.clone
  %indvar.next20.clone = add i64 %indvar19.clone, 1
  %exitcond22.clone = icmp ne i64 %indvar.next20.clone, %0
  br i1 %exitcond22.clone, label %.preheader.clone, label %.region.clone

.region.clone:                                    ; preds = %polly.then, %polly.loop_exit98, %polly.start, %.preheader1.split.clone, %._crit_edge.clone
  ret void

polly.start:                                      ; preds = %.preheader1
  %101 = sext i32 %n to i64
  %102 = icmp sge i64 %101, 1
  %103 = icmp sge i64 %0, 1
  %104 = and i1 %102, %103
  br i1 %104, label %polly.then, label %.region.clone

polly.then:                                       ; preds = %polly.start
  %polly.loop_guard = icmp sle i64 0, %1
  br i1 %polly.loop_guard, label %polly.loop_header, label %.region.clone

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit98
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit98 ], [ 0, %polly.then ]
  br i1 %polly.loop_guard, label %polly.loop_header96, label %polly.loop_exit98

polly.loop_exit98:                                ; preds = %polly.loop_exit107, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %1, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %.region.clone

polly.loop_header96:                              ; preds = %polly.loop_header, %polly.loop_exit107
  %polly.indvar100 = phi i64 [ %polly.indvar_next101, %polly.loop_exit107 ], [ 0, %polly.loop_header ]
  %105 = add i64 %polly.indvar, 31
  %106 = icmp slt i64 %105, %1
  %107 = select i1 %106, i64 %105, i64 %1
  %polly.loop_guard108 = icmp sle i64 %polly.indvar, %107
  br i1 %polly.loop_guard108, label %polly.loop_header105, label %polly.loop_exit107

polly.loop_exit107:                               ; preds = %polly.loop_exit116, %polly.loop_header96
  %polly.indvar_next101 = add nsw i64 %polly.indvar100, 32
  %polly.adjust_ub102 = sub i64 %1, 32
  %polly.loop_cond103 = icmp sle i64 %polly.indvar100, %polly.adjust_ub102
  br i1 %polly.loop_cond103, label %polly.loop_header96, label %polly.loop_exit98

polly.loop_header105:                             ; preds = %polly.loop_header96, %polly.loop_exit116
  %polly.indvar109 = phi i64 [ %polly.indvar_next110, %polly.loop_exit116 ], [ %polly.indvar, %polly.loop_header96 ]
  %108 = add i64 %polly.indvar100, 31
  %109 = icmp slt i64 %108, %1
  %110 = select i1 %109, i64 %108, i64 %1
  %polly.loop_guard117 = icmp sle i64 %polly.indvar100, %110
  br i1 %polly.loop_guard117, label %polly.loop_header114, label %polly.loop_exit116

polly.loop_exit116:                               ; preds = %polly.loop_header114, %polly.loop_header105
  %polly.indvar_next110 = add nsw i64 %polly.indvar109, 1
  %polly.adjust_ub111 = sub i64 %107, 1
  %polly.loop_cond112 = icmp sle i64 %polly.indvar109, %polly.adjust_ub111
  br i1 %polly.loop_cond112, label %polly.loop_header105, label %polly.loop_exit107

polly.loop_header114:                             ; preds = %polly.loop_header105, %polly.loop_header114
  %polly.indvar118 = phi i64 [ %polly.indvar_next119, %polly.loop_header114 ], [ %polly.indvar100, %polly.loop_header105 ]
  %p_scevgep24.moved.to. = getelementptr double* %w, i64 %polly.indvar109
  %p_scevgep = getelementptr [2000 x double]* %A, i64 %polly.indvar109, i64 %polly.indvar118
  %p_scevgep21 = getelementptr double* %x, i64 %polly.indvar118
  %_p_scalar_ = load double* %p_scevgep24.moved.to.
  %_p_scalar_122 = load double* %p_scevgep
  %p_ = fmul double %_p_scalar_122, %alpha
  %_p_scalar_123 = load double* %p_scevgep21
  %p_124 = fmul double %p_, %_p_scalar_123
  %p_125 = fadd double %_p_scalar_, %p_124
  store double %p_125, double* %p_scevgep24.moved.to.
  %p_indvar.next = add i64 %polly.indvar118, 1
  %polly.indvar_next119 = add nsw i64 %polly.indvar118, 1
  %polly.adjust_ub120 = sub i64 %110, 1
  %polly.loop_cond121 = icmp sle i64 %polly.indvar118, %polly.adjust_ub120
  br i1 %polly.loop_cond121, label %polly.loop_header114, label %polly.loop_exit116

polly.start127:                                   ; preds = %.preheader2
  %111 = sext i32 %n to i64
  %112 = icmp sge i64 %111, 1
  %113 = icmp sge i64 %0, 1
  %114 = and i1 %112, %113
  br i1 %114, label %polly.then131, label %.preheader1

polly.then131:                                    ; preds = %polly.start127
  %polly.loop_guard136 = icmp sle i64 0, %1
  br i1 %polly.loop_guard136, label %polly.loop_header133, label %.preheader1

polly.loop_header133:                             ; preds = %polly.then131, %polly.loop_header133
  %polly.indvar137 = phi i64 [ %polly.indvar_next138, %polly.loop_header133 ], [ 0, %polly.then131 ]
  %p_scevgep28 = getelementptr double* %x, i64 %polly.indvar137
  %p_scevgep29 = getelementptr double* %z, i64 %polly.indvar137
  %_p_scalar_142 = load double* %p_scevgep28
  %_p_scalar_143 = load double* %p_scevgep29
  %p_144 = fadd double %_p_scalar_142, %_p_scalar_143
  store double %p_144, double* %p_scevgep28
  %p_indvar.next26 = add i64 %polly.indvar137, 1
  %polly.indvar_next138 = add nsw i64 %polly.indvar137, 1
  %polly.adjust_ub139 = sub i64 %1, 1
  %polly.loop_cond140 = icmp sle i64 %polly.indvar137, %polly.adjust_ub139
  br i1 %polly.loop_cond140, label %polly.loop_header133, label %.preheader1

polly.start146:                                   ; preds = %.preheader4
  %115 = sext i32 %n to i64
  %116 = icmp sge i64 %115, 1
  %117 = icmp sge i64 %0, 1
  %118 = and i1 %116, %117
  br i1 %118, label %polly.then150, label %.preheader2

polly.then150:                                    ; preds = %polly.start146
  %polly.loop_guard155 = icmp sle i64 0, %1
  br i1 %polly.loop_guard155, label %polly.loop_header152, label %.preheader2

polly.loop_header152:                             ; preds = %polly.then150, %polly.loop_exit163
  %polly.indvar156 = phi i64 [ %polly.indvar_next157, %polly.loop_exit163 ], [ 0, %polly.then150 ]
  br i1 %polly.loop_guard155, label %polly.loop_header161, label %polly.loop_exit163

polly.loop_exit163:                               ; preds = %polly.loop_exit172, %polly.loop_header152
  %polly.indvar_next157 = add nsw i64 %polly.indvar156, 32
  %polly.adjust_ub158 = sub i64 %1, 32
  %polly.loop_cond159 = icmp sle i64 %polly.indvar156, %polly.adjust_ub158
  br i1 %polly.loop_cond159, label %polly.loop_header152, label %.preheader2

polly.loop_header161:                             ; preds = %polly.loop_header152, %polly.loop_exit172
  %polly.indvar165 = phi i64 [ %polly.indvar_next166, %polly.loop_exit172 ], [ 0, %polly.loop_header152 ]
  %119 = add i64 %polly.indvar156, 31
  %120 = icmp slt i64 %119, %1
  %121 = select i1 %120, i64 %119, i64 %1
  %polly.loop_guard173 = icmp sle i64 %polly.indvar156, %121
  br i1 %polly.loop_guard173, label %polly.loop_header170, label %polly.loop_exit172

polly.loop_exit172:                               ; preds = %polly.loop_exit181, %polly.loop_header161
  %polly.indvar_next166 = add nsw i64 %polly.indvar165, 32
  %polly.adjust_ub167 = sub i64 %1, 32
  %polly.loop_cond168 = icmp sle i64 %polly.indvar165, %polly.adjust_ub167
  br i1 %polly.loop_cond168, label %polly.loop_header161, label %polly.loop_exit163

polly.loop_header170:                             ; preds = %polly.loop_header161, %polly.loop_exit181
  %polly.indvar174 = phi i64 [ %polly.indvar_next175, %polly.loop_exit181 ], [ %polly.indvar156, %polly.loop_header161 ]
  %122 = add i64 %polly.indvar165, 31
  %123 = icmp slt i64 %122, %1
  %124 = select i1 %123, i64 %122, i64 %1
  %polly.loop_guard182 = icmp sle i64 %polly.indvar165, %124
  br i1 %polly.loop_guard182, label %polly.loop_header179, label %polly.loop_exit181

polly.loop_exit181:                               ; preds = %polly.loop_header179, %polly.loop_header170
  %polly.indvar_next175 = add nsw i64 %polly.indvar174, 1
  %polly.adjust_ub176 = sub i64 %121, 1
  %polly.loop_cond177 = icmp sle i64 %polly.indvar174, %polly.adjust_ub176
  br i1 %polly.loop_cond177, label %polly.loop_header170, label %polly.loop_exit172

polly.loop_header179:                             ; preds = %polly.loop_header170, %polly.loop_header179
  %polly.indvar183 = phi i64 [ %polly.indvar_next184, %polly.loop_header179 ], [ %polly.indvar165, %polly.loop_header170 ]
  %p_scevgep39.moved.to. = getelementptr double* %x, i64 %polly.indvar174
  %p_scevgep35 = getelementptr [2000 x double]* %A, i64 %polly.indvar183, i64 %polly.indvar174
  %p_scevgep36 = getelementptr double* %y, i64 %polly.indvar183
  %_p_scalar_188 = load double* %p_scevgep39.moved.to.
  %_p_scalar_189 = load double* %p_scevgep35
  %p_190 = fmul double %_p_scalar_189, %beta
  %_p_scalar_191 = load double* %p_scevgep36
  %p_192 = fmul double %p_190, %_p_scalar_191
  %p_193 = fadd double %_p_scalar_188, %p_192
  store double %p_193, double* %p_scevgep39.moved.to.
  %p_indvar.next31 = add i64 %polly.indvar183, 1
  %polly.indvar_next184 = add nsw i64 %polly.indvar183, 1
  %polly.adjust_ub185 = sub i64 %124, 1
  %polly.loop_cond186 = icmp sle i64 %polly.indvar183, %polly.adjust_ub185
  br i1 %polly.loop_cond186, label %polly.loop_header179, label %polly.loop_exit181

polly.start195:                                   ; preds = %.split
  %125 = sext i32 %n to i64
  %126 = icmp sge i64 %125, 1
  %127 = icmp sge i64 %0, 1
  %128 = and i1 %126, %127
  br i1 %128, label %polly.then199, label %.preheader4

polly.then199:                                    ; preds = %polly.start195
  %polly.loop_guard204 = icmp sle i64 0, %1
  br i1 %polly.loop_guard204, label %polly.loop_header201, label %.preheader4

polly.loop_header201:                             ; preds = %polly.then199, %polly.loop_exit212
  %polly.indvar205 = phi i64 [ %polly.indvar_next206, %polly.loop_exit212 ], [ 0, %polly.then199 ]
  %129 = mul i64 -11, %0
  %130 = add i64 %129, 5
  %131 = sub i64 %130, 32
  %132 = add i64 %131, 1
  %133 = icmp slt i64 %130, 0
  %134 = select i1 %133, i64 %132, i64 %130
  %135 = sdiv i64 %134, 32
  %136 = mul i64 -32, %135
  %137 = mul i64 -32, %0
  %138 = add i64 %136, %137
  %139 = mul i64 -32, %polly.indvar205
  %140 = mul i64 -3, %polly.indvar205
  %141 = add i64 %140, %0
  %142 = add i64 %141, 5
  %143 = sub i64 %142, 32
  %144 = add i64 %143, 1
  %145 = icmp slt i64 %142, 0
  %146 = select i1 %145, i64 %144, i64 %142
  %147 = sdiv i64 %146, 32
  %148 = mul i64 -32, %147
  %149 = add i64 %139, %148
  %150 = add i64 %149, -640
  %151 = icmp sgt i64 %138, %150
  %152 = select i1 %151, i64 %138, i64 %150
  %153 = mul i64 -20, %polly.indvar205
  %polly.loop_guard213 = icmp sle i64 %152, %153
  br i1 %polly.loop_guard213, label %polly.loop_header210, label %polly.loop_exit212

polly.loop_exit212:                               ; preds = %polly.loop_exit221, %polly.loop_header201
  %polly.indvar_next206 = add nsw i64 %polly.indvar205, 32
  %polly.adjust_ub207 = sub i64 %1, 32
  %polly.loop_cond208 = icmp sle i64 %polly.indvar205, %polly.adjust_ub207
  br i1 %polly.loop_cond208, label %polly.loop_header201, label %.preheader4

polly.loop_header210:                             ; preds = %polly.loop_header201, %polly.loop_exit221
  %polly.indvar214 = phi i64 [ %polly.indvar_next215, %polly.loop_exit221 ], [ %152, %polly.loop_header201 ]
  %154 = mul i64 -1, %polly.indvar214
  %155 = mul i64 -1, %0
  %156 = add i64 %154, %155
  %157 = add i64 %156, -30
  %158 = add i64 %157, 20
  %159 = sub i64 %158, 1
  %160 = icmp slt i64 %157, 0
  %161 = select i1 %160, i64 %157, i64 %159
  %162 = sdiv i64 %161, 20
  %163 = icmp sgt i64 %162, %polly.indvar205
  %164 = select i1 %163, i64 %162, i64 %polly.indvar205
  %165 = sub i64 %154, 20
  %166 = add i64 %165, 1
  %167 = icmp slt i64 %154, 0
  %168 = select i1 %167, i64 %166, i64 %154
  %169 = sdiv i64 %168, 20
  %170 = add i64 %polly.indvar205, 31
  %171 = icmp slt i64 %169, %170
  %172 = select i1 %171, i64 %169, i64 %170
  %173 = icmp slt i64 %172, %1
  %174 = select i1 %173, i64 %172, i64 %1
  %polly.loop_guard222 = icmp sle i64 %164, %174
  br i1 %polly.loop_guard222, label %polly.loop_header219, label %polly.loop_exit221

polly.loop_exit221:                               ; preds = %polly.loop_exit230, %polly.loop_header210
  %polly.indvar_next215 = add nsw i64 %polly.indvar214, 32
  %polly.adjust_ub216 = sub i64 %153, 32
  %polly.loop_cond217 = icmp sle i64 %polly.indvar214, %polly.adjust_ub216
  br i1 %polly.loop_cond217, label %polly.loop_header210, label %polly.loop_exit212

polly.loop_header219:                             ; preds = %polly.loop_header210, %polly.loop_exit230
  %polly.indvar223 = phi i64 [ %polly.indvar_next224, %polly.loop_exit230 ], [ %164, %polly.loop_header210 ]
  %175 = mul i64 -20, %polly.indvar223
  %176 = add i64 %175, %155
  %177 = add i64 %176, 1
  %178 = icmp sgt i64 %polly.indvar214, %177
  %179 = select i1 %178, i64 %polly.indvar214, i64 %177
  %180 = add i64 %polly.indvar214, 31
  %181 = icmp slt i64 %175, %180
  %182 = select i1 %181, i64 %175, i64 %180
  %polly.loop_guard231 = icmp sle i64 %179, %182
  br i1 %polly.loop_guard231, label %polly.loop_header228, label %polly.loop_exit230

polly.loop_exit230:                               ; preds = %polly.loop_header228, %polly.loop_header219
  %polly.indvar_next224 = add nsw i64 %polly.indvar223, 1
  %polly.adjust_ub225 = sub i64 %174, 1
  %polly.loop_cond226 = icmp sle i64 %polly.indvar223, %polly.adjust_ub225
  br i1 %polly.loop_cond226, label %polly.loop_header219, label %polly.loop_exit221

polly.loop_header228:                             ; preds = %polly.loop_header219, %polly.loop_header228
  %polly.indvar232 = phi i64 [ %polly.indvar_next233, %polly.loop_header228 ], [ %179, %polly.loop_header219 ]
  %183 = mul i64 -1, %polly.indvar232
  %184 = add i64 %175, %183
  %p_scevgep50.moved.to. = getelementptr double* %u1, i64 %polly.indvar223
  %p_scevgep51.moved.to. = getelementptr double* %u2, i64 %polly.indvar223
  %p_scevgep45 = getelementptr [2000 x double]* %A, i64 %polly.indvar223, i64 %184
  %p_scevgep46 = getelementptr double* %v1, i64 %184
  %p_scevgep47 = getelementptr double* %v2, i64 %184
  %_p_scalar_237 = load double* %p_scevgep45
  %_p_scalar_238 = load double* %p_scevgep50.moved.to.
  %_p_scalar_239 = load double* %p_scevgep46
  %p_240 = fmul double %_p_scalar_238, %_p_scalar_239
  %p_241 = fadd double %_p_scalar_237, %p_240
  %_p_scalar_242 = load double* %p_scevgep51.moved.to.
  %_p_scalar_243 = load double* %p_scevgep47
  %p_244 = fmul double %_p_scalar_242, %_p_scalar_243
  %p_245 = fadd double %p_241, %p_244
  store double %p_245, double* %p_scevgep45
  %p_indvar.next41 = add i64 %184, 1
  %polly.indvar_next233 = add nsw i64 %polly.indvar232, 1
  %polly.adjust_ub234 = sub i64 %182, 1
  %polly.loop_cond235 = icmp sle i64 %polly.indvar232, %polly.adjust_ub234
  br i1 %polly.loop_cond235, label %polly.loop_header228, label %polly.loop_exit230
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, double* %w) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %n, 0
  br i1 %5, label %.lr.ph, label %16

.lr.ph:                                           ; preds = %.split
  %6 = zext i32 %n to i64
  br label %7

; <label>:7                                       ; preds = %.lr.ph, %12
  %indvar = phi i64 [ 0, %.lr.ph ], [ %indvar.next, %12 ]
  %i.01 = trunc i64 %indvar to i32
  %scevgep = getelementptr double* %w, i64 %indvar
  %8 = srem i32 %i.01, 20
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %10, label %12

; <label>:10                                      ; preds = %7
  %11 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %11) #4
  br label %12

; <label>:12                                      ; preds = %10, %7
  %13 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %14 = load double* %scevgep, align 8, !tbaa !1
  %15 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %13, i8* getelementptr inbounds ([8 x i8]* @.str5, i64 0, i64 0), double %14) #5
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %6
  br i1 %exitcond, label %7, label %._crit_edge

._crit_edge:                                      ; preds = %12
  br label %16

; <label>:16                                      ; preds = %._crit_edge, %.split
  %17 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %18 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %17, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %19 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %20 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str7, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %19) #4
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
