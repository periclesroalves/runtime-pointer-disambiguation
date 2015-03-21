; ModuleID = './linear-algebra/blas/trmm/trmm.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [2 x i8] c"B\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [8 x i8] c"%0.2lf \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %alpha = alloca double, align 8
  %0 = tail call i8* @polybench_alloc_data(i64 1000000, i32 8) #3
  %1 = tail call i8* @polybench_alloc_data(i64 1200000, i32 8) #3
  %2 = bitcast i8* %0 to [1000 x double]*
  %3 = bitcast i8* %1 to [1200 x double]*
  call void @init_array(i32 1000, i32 1200, double* %alpha, [1000 x double]* %2, [1200 x double]* %3)
  call void (...)* @polybench_timer_start() #3
  %4 = load double* %alpha, align 8, !tbaa !1
  call void @kernel_trmm(i32 1000, i32 1200, double %4, [1000 x double]* %2, [1200 x double]* %3)
  call void (...)* @polybench_timer_stop() #3
  call void (...)* @polybench_timer_print() #3
  %5 = icmp sgt i32 %argc, 42
  br i1 %5, label %6, label %10

; <label>:6                                       ; preds = %.split
  %7 = load i8** %argv, align 8, !tbaa !5
  %8 = load i8* %7, align 1, !tbaa !7
  %phitmp = icmp eq i8 %8, 0
  br i1 %phitmp, label %9, label %10

; <label>:9                                       ; preds = %6
  call void @print_array(i32 1000, i32 1200, [1200 x double]* %3)
  br label %10

; <label>:10                                      ; preds = %6, %9, %.split
  call void @free(i8* %0) #3
  call void @free(i8* %1) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %m, i32 %n, double* %alpha, [1000 x double]* %A, [1200 x double]* %B) #0 {
.split:
  %alpha20 = bitcast double* %alpha to i8*
  %B24 = bitcast [1200 x double]* %B to i8*
  %B23 = ptrtoint [1200 x double]* %B to i64
  %A19 = ptrtoint [1000 x double]* %A to i64
  %umin21 = bitcast [1000 x double]* %A to i8*
  %0 = zext i32 %m to i64
  %1 = add i64 %0, -1
  %2 = mul i64 8000, %1
  %3 = add i64 %A19, %2
  %4 = add i64 -1, %1
  %5 = mul i64 8, %4
  %6 = add i64 %3, %5
  %7 = mul i64 8008, %1
  %8 = add i64 %A19, %7
  %9 = icmp ugt i64 %8, %6
  %umax = select i1 %9, i64 %8, i64 %6
  %umax22 = inttoptr i64 %umax to i8*
  %10 = icmp ult i8* %alpha20, %umin21
  %11 = icmp ult i8* %umax22, %alpha20
  %pair-no-alias = or i1 %10, %11
  %12 = mul i64 9600, %1
  %13 = add i64 %B23, %12
  %14 = zext i32 %n to i64
  %15 = add i64 %14, -1
  %16 = mul i64 8, %15
  %17 = add i64 %13, %16
  %18 = inttoptr i64 %17 to i8*
  %19 = icmp ult i8* %alpha20, %B24
  %20 = icmp ult i8* %18, %alpha20
  %pair-no-alias25 = or i1 %19, %20
  %21 = and i1 %pair-no-alias, %pair-no-alias25
  %22 = icmp ult i8* %umax22, %B24
  %23 = icmp ult i8* %18, %umin21
  %pair-no-alias26 = or i1 %22, %23
  %24 = and i1 %21, %pair-no-alias26
  br i1 %24, label %polly.start, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  store double 1.500000e+00, double* %alpha, align 8, !tbaa !1
  %25 = icmp sgt i32 %m, 0
  br i1 %25, label %.preheader.lr.ph.clone, label %.region.clone

.preheader.lr.ph.clone:                           ; preds = %.split.split.clone
  %26 = icmp sgt i32 %n, 0
  %27 = sitofp i32 %n to double
  %28 = sitofp i32 %m to double
  br label %.preheader.clone

.preheader.clone:                                 ; preds = %polly.merge130, %.preheader.lr.ph.clone
  %29 = phi i64 [ 0, %.preheader.lr.ph.clone ], [ %indvar.next10.clone, %polly.merge130 ]
  %30 = mul i64 %29, 8000
  %31 = mul i64 %29, 9600
  %i.06.clone = trunc i64 %29 to i32
  %32 = add i64 %14, %29
  %33 = mul i64 %29, 1001
  %scevgep18.clone = getelementptr [1000 x double]* %A, i64 0, i64 %33
  %34 = icmp sgt i32 %i.06.clone, 0
  br i1 %34, label %polly.cond154, label %polly.merge155

polly.merge155:                                   ; preds = %polly.then159, %polly.loop_header161, %polly.cond154, %.preheader.clone
  store double 1.000000e+00, double* %scevgep18.clone, align 8, !tbaa !1
  br i1 %26, label %polly.cond129, label %polly.merge130

polly.merge130:                                   ; preds = %polly.then134, %polly.loop_header136, %polly.cond129, %polly.merge155
  %indvar.next10.clone = add i64 %29, 1
  %exitcond15.clone = icmp ne i64 %indvar.next10.clone, %0
  br i1 %exitcond15.clone, label %.preheader.clone, label %.region.clone

.region.clone:                                    ; preds = %.split.split.clone, %polly.merge130, %polly.stmt..split.split
  ret void

polly.start:                                      ; preds = %.split
  %35 = sext i32 %m to i64
  %36 = icmp sge i64 %35, 1
  %37 = icmp sge i64 %0, 1
  %38 = and i1 %36, %37
  br i1 %38, label %polly.then, label %polly.cond35

polly.cond35:                                     ; preds = %polly.then, %polly.loop_header, %polly.start
  %39 = icmp sge i64 %0, 2
  %40 = and i1 %36, %39
  br i1 %40, label %polly.then37, label %polly.cond79

polly.cond79:                                     ; preds = %polly.then37, %polly.loop_exit50, %polly.cond35
  %41 = sext i32 %n to i64
  %42 = icmp sge i64 %41, 1
  %43 = and i1 %36, %42
  %44 = and i1 %43, %37
  %45 = icmp sge i64 %14, 1
  %46 = and i1 %44, %45
  br i1 %46, label %polly.then81, label %polly.stmt..split.split

polly.stmt..split.split:                          ; preds = %polly.then81, %polly.loop_exit94, %polly.cond79
  store double 1.500000e+00, double* %alpha
  br label %.region.clone

polly.then:                                       ; preds = %polly.start
  %polly.loop_guard = icmp sle i64 0, %1
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.cond35

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_.moved.to.28 = mul i64 %polly.indvar, 1001
  %p_scevgep18.moved.to. = getelementptr [1000 x double]* %A, i64 0, i64 %p_.moved.to.28
  store double 1.000000e+00, double* %p_scevgep18.moved.to.
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %1, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.cond35

polly.then37:                                     ; preds = %polly.cond35
  %polly.loop_guard42 = icmp sle i64 0, %1
  br i1 %polly.loop_guard42, label %polly.loop_header39, label %polly.cond79

polly.loop_header39:                              ; preds = %polly.then37, %polly.loop_exit50
  %polly.indvar43 = phi i64 [ %polly.indvar_next44, %polly.loop_exit50 ], [ 0, %polly.then37 ]
  %47 = mul i64 -11, %0
  %48 = add i64 %47, 9
  %49 = sub i64 %48, 32
  %50 = add i64 %49, 1
  %51 = icmp slt i64 %48, 0
  %52 = select i1 %51, i64 %50, i64 %48
  %53 = sdiv i64 %52, 32
  %54 = mul i64 -32, %53
  %55 = mul i64 -32, %0
  %56 = add i64 %54, %55
  %57 = mul i64 -32, %polly.indvar43
  %58 = mul i64 11, %polly.indvar43
  %59 = add i64 %58, -1
  %60 = sub i64 %59, 32
  %61 = add i64 %60, 1
  %62 = icmp slt i64 %59, 0
  %63 = select i1 %62, i64 %61, i64 %59
  %64 = sdiv i64 %63, 32
  %65 = mul i64 32, %64
  %66 = add i64 %57, %65
  %67 = add i64 %66, -640
  %68 = icmp sgt i64 %56, %67
  %69 = select i1 %68, i64 %56, i64 %67
  %70 = mul i64 -20, %polly.indvar43
  %71 = icmp slt i64 -20, %70
  %72 = select i1 %71, i64 -20, i64 %70
  %polly.loop_guard51 = icmp sle i64 %69, %72
  br i1 %polly.loop_guard51, label %polly.loop_header48, label %polly.loop_exit50

polly.loop_exit50:                                ; preds = %polly.loop_exit59, %polly.loop_header39
  %polly.indvar_next44 = add nsw i64 %polly.indvar43, 32
  %polly.adjust_ub45 = sub i64 %1, 32
  %polly.loop_cond46 = icmp sle i64 %polly.indvar43, %polly.adjust_ub45
  br i1 %polly.loop_cond46, label %polly.loop_header39, label %polly.cond79

polly.loop_header48:                              ; preds = %polly.loop_header39, %polly.loop_exit59
  %polly.indvar52 = phi i64 [ %polly.indvar_next53, %polly.loop_exit59 ], [ %69, %polly.loop_header39 ]
  %73 = mul i64 -1, %polly.indvar52
  %74 = add i64 %73, -30
  %75 = add i64 %74, 21
  %76 = sub i64 %75, 1
  %77 = icmp slt i64 %74, 0
  %78 = select i1 %77, i64 %74, i64 %76
  %79 = sdiv i64 %78, 21
  %80 = icmp sgt i64 %79, %polly.indvar43
  %81 = select i1 %80, i64 %79, i64 %polly.indvar43
  %82 = sub i64 %73, 20
  %83 = add i64 %82, 1
  %84 = icmp slt i64 %73, 0
  %85 = select i1 %84, i64 %83, i64 %73
  %86 = sdiv i64 %85, 20
  %87 = add i64 %polly.indvar43, 31
  %88 = icmp slt i64 %86, %87
  %89 = select i1 %88, i64 %86, i64 %87
  %90 = icmp slt i64 %89, %1
  %91 = select i1 %90, i64 %89, i64 %1
  %polly.loop_guard60 = icmp sle i64 %81, %91
  br i1 %polly.loop_guard60, label %polly.loop_header57, label %polly.loop_exit59

polly.loop_exit59:                                ; preds = %polly.loop_exit68, %polly.loop_header48
  %polly.indvar_next53 = add nsw i64 %polly.indvar52, 32
  %polly.adjust_ub54 = sub i64 %72, 32
  %polly.loop_cond55 = icmp sle i64 %polly.indvar52, %polly.adjust_ub54
  br i1 %polly.loop_cond55, label %polly.loop_header48, label %polly.loop_exit50

polly.loop_header57:                              ; preds = %polly.loop_header48, %polly.loop_exit68
  %polly.indvar61 = phi i64 [ %polly.indvar_next62, %polly.loop_exit68 ], [ %81, %polly.loop_header48 ]
  %92 = mul i64 -21, %polly.indvar61
  %93 = add i64 %92, 1
  %94 = icmp sgt i64 %polly.indvar52, %93
  %95 = select i1 %94, i64 %polly.indvar52, i64 %93
  %96 = mul i64 -20, %polly.indvar61
  %97 = add i64 %polly.indvar52, 31
  %98 = icmp slt i64 %96, %97
  %99 = select i1 %98, i64 %96, i64 %97
  %polly.loop_guard69 = icmp sle i64 %95, %99
  br i1 %polly.loop_guard69, label %polly.loop_header66, label %polly.loop_exit68

polly.loop_exit68:                                ; preds = %polly.loop_header66, %polly.loop_header57
  %polly.indvar_next62 = add nsw i64 %polly.indvar61, 1
  %polly.adjust_ub63 = sub i64 %91, 1
  %polly.loop_cond64 = icmp sle i64 %polly.indvar61, %polly.adjust_ub63
  br i1 %polly.loop_cond64, label %polly.loop_header57, label %polly.loop_exit59

polly.loop_header66:                              ; preds = %polly.loop_header57, %polly.loop_header66
  %polly.indvar70 = phi i64 [ %polly.indvar_next71, %polly.loop_header66 ], [ %95, %polly.loop_header57 ]
  %100 = mul i64 -1, %polly.indvar70
  %101 = add i64 %96, %100
  %p_.moved.to. = sitofp i32 %m to double
  %p_ = add i64 %polly.indvar61, %101
  %p_75 = trunc i64 %p_ to i32
  %p_scevgep = getelementptr [1000 x double]* %A, i64 %polly.indvar61, i64 %101
  %p_76 = srem i32 %p_75, %m
  %p_77 = sitofp i32 %p_76 to double
  %p_78 = fdiv double %p_77, %p_.moved.to.
  store double %p_78, double* %p_scevgep
  %p_indvar.next = add i64 %101, 1
  %polly.indvar_next71 = add nsw i64 %polly.indvar70, 1
  %polly.adjust_ub72 = sub i64 %99, 1
  %polly.loop_cond73 = icmp sle i64 %polly.indvar70, %polly.adjust_ub72
  br i1 %polly.loop_cond73, label %polly.loop_header66, label %polly.loop_exit68

polly.then81:                                     ; preds = %polly.cond79
  %polly.loop_guard86 = icmp sle i64 0, %1
  br i1 %polly.loop_guard86, label %polly.loop_header83, label %polly.stmt..split.split

polly.loop_header83:                              ; preds = %polly.then81, %polly.loop_exit94
  %polly.indvar87 = phi i64 [ %polly.indvar_next88, %polly.loop_exit94 ], [ 0, %polly.then81 ]
  %102 = mul i64 -3, %0
  %103 = add i64 %102, %14
  %104 = add i64 %103, 5
  %105 = sub i64 %104, 32
  %106 = add i64 %105, 1
  %107 = icmp slt i64 %104, 0
  %108 = select i1 %107, i64 %106, i64 %104
  %109 = sdiv i64 %108, 32
  %110 = mul i64 -32, %109
  %111 = mul i64 -32, %0
  %112 = add i64 %110, %111
  %113 = mul i64 -32, %polly.indvar87
  %114 = mul i64 -3, %polly.indvar87
  %115 = add i64 %114, %14
  %116 = add i64 %115, 5
  %117 = sub i64 %116, 32
  %118 = add i64 %117, 1
  %119 = icmp slt i64 %116, 0
  %120 = select i1 %119, i64 %118, i64 %116
  %121 = sdiv i64 %120, 32
  %122 = mul i64 -32, %121
  %123 = add i64 %113, %122
  %124 = add i64 %123, -640
  %125 = icmp sgt i64 %112, %124
  %126 = select i1 %125, i64 %112, i64 %124
  %127 = mul i64 -20, %polly.indvar87
  %polly.loop_guard95 = icmp sle i64 %126, %127
  br i1 %polly.loop_guard95, label %polly.loop_header92, label %polly.loop_exit94

polly.loop_exit94:                                ; preds = %polly.loop_exit103, %polly.loop_header83
  %polly.indvar_next88 = add nsw i64 %polly.indvar87, 32
  %polly.adjust_ub89 = sub i64 %1, 32
  %polly.loop_cond90 = icmp sle i64 %polly.indvar87, %polly.adjust_ub89
  br i1 %polly.loop_cond90, label %polly.loop_header83, label %polly.stmt..split.split

polly.loop_header92:                              ; preds = %polly.loop_header83, %polly.loop_exit103
  %polly.indvar96 = phi i64 [ %polly.indvar_next97, %polly.loop_exit103 ], [ %126, %polly.loop_header83 ]
  %128 = mul i64 -1, %polly.indvar96
  %129 = mul i64 -1, %14
  %130 = add i64 %128, %129
  %131 = add i64 %130, -30
  %132 = add i64 %131, 20
  %133 = sub i64 %132, 1
  %134 = icmp slt i64 %131, 0
  %135 = select i1 %134, i64 %131, i64 %133
  %136 = sdiv i64 %135, 20
  %137 = icmp sgt i64 %136, %polly.indvar87
  %138 = select i1 %137, i64 %136, i64 %polly.indvar87
  %139 = sub i64 %128, 20
  %140 = add i64 %139, 1
  %141 = icmp slt i64 %128, 0
  %142 = select i1 %141, i64 %140, i64 %128
  %143 = sdiv i64 %142, 20
  %144 = add i64 %polly.indvar87, 31
  %145 = icmp slt i64 %143, %144
  %146 = select i1 %145, i64 %143, i64 %144
  %147 = icmp slt i64 %146, %1
  %148 = select i1 %147, i64 %146, i64 %1
  %polly.loop_guard104 = icmp sle i64 %138, %148
  br i1 %polly.loop_guard104, label %polly.loop_header101, label %polly.loop_exit103

polly.loop_exit103:                               ; preds = %polly.loop_exit112, %polly.loop_header92
  %polly.indvar_next97 = add nsw i64 %polly.indvar96, 32
  %polly.adjust_ub98 = sub i64 %127, 32
  %polly.loop_cond99 = icmp sle i64 %polly.indvar96, %polly.adjust_ub98
  br i1 %polly.loop_cond99, label %polly.loop_header92, label %polly.loop_exit94

polly.loop_header101:                             ; preds = %polly.loop_header92, %polly.loop_exit112
  %polly.indvar105 = phi i64 [ %polly.indvar_next106, %polly.loop_exit112 ], [ %138, %polly.loop_header92 ]
  %149 = mul i64 -20, %polly.indvar105
  %150 = add i64 %149, %129
  %151 = add i64 %150, 1
  %152 = icmp sgt i64 %polly.indvar96, %151
  %153 = select i1 %152, i64 %polly.indvar96, i64 %151
  %154 = add i64 %polly.indvar96, 31
  %155 = icmp slt i64 %149, %154
  %156 = select i1 %155, i64 %149, i64 %154
  %polly.loop_guard113 = icmp sle i64 %153, %156
  br i1 %polly.loop_guard113, label %polly.loop_header110, label %polly.loop_exit112

polly.loop_exit112:                               ; preds = %polly.loop_header110, %polly.loop_header101
  %polly.indvar_next106 = add nsw i64 %polly.indvar105, 1
  %polly.adjust_ub107 = sub i64 %148, 1
  %polly.loop_cond108 = icmp sle i64 %polly.indvar105, %polly.adjust_ub107
  br i1 %polly.loop_cond108, label %polly.loop_header101, label %polly.loop_exit103

polly.loop_header110:                             ; preds = %polly.loop_header101, %polly.loop_header110
  %polly.indvar114 = phi i64 [ %polly.indvar_next115, %polly.loop_header110 ], [ %153, %polly.loop_header101 ]
  %157 = mul i64 -1, %polly.indvar114
  %158 = add i64 %149, %157
  %p_.moved.to.31 = add i64 %14, %polly.indvar105
  %p_.moved.to.32 = sitofp i32 %n to double
  %p_scevgep14 = getelementptr [1200 x double]* %B, i64 %polly.indvar105, i64 %158
  %p_119 = mul i64 %158, -1
  %p_120 = add i64 %p_.moved.to.31, %p_119
  %p_121 = trunc i64 %p_120 to i32
  %p_122 = srem i32 %p_121, %n
  %p_123 = sitofp i32 %p_122 to double
  %p_124 = fdiv double %p_123, %p_.moved.to.32
  store double %p_124, double* %p_scevgep14
  %p_indvar.next12 = add i64 %158, 1
  %polly.indvar_next115 = add nsw i64 %polly.indvar114, 1
  %polly.adjust_ub116 = sub i64 %156, 1
  %polly.loop_cond117 = icmp sle i64 %polly.indvar114, %polly.adjust_ub116
  br i1 %polly.loop_cond117, label %polly.loop_header110, label %polly.loop_exit112

polly.cond129:                                    ; preds = %polly.merge155
  %159 = srem i64 %31, 8
  %160 = icmp eq i64 %159, 0
  %161 = icmp sge i64 %14, 1
  %or.cond = and i1 %160, %161
  br i1 %or.cond, label %polly.then134, label %polly.merge130

polly.then134:                                    ; preds = %polly.cond129
  %polly.loop_guard139 = icmp sle i64 0, %15
  br i1 %polly.loop_guard139, label %polly.loop_header136, label %polly.merge130

polly.loop_header136:                             ; preds = %polly.then134, %polly.loop_header136
  %polly.indvar140 = phi i64 [ %polly.indvar_next141, %polly.loop_header136 ], [ 0, %polly.then134 ]
  %p_scevgep14.clone = getelementptr [1200 x double]* %B, i64 %29, i64 %polly.indvar140
  %p_145 = mul i64 %polly.indvar140, -1
  %p_146 = add i64 %32, %p_145
  %p_147 = trunc i64 %p_146 to i32
  %p_148 = srem i32 %p_147, %n
  %p_149 = sitofp i32 %p_148 to double
  %p_150 = fdiv double %p_149, %27
  store double %p_150, double* %p_scevgep14.clone
  %p_indvar.next12.clone = add i64 %polly.indvar140, 1
  %polly.indvar_next141 = add nsw i64 %polly.indvar140, 1
  %polly.adjust_ub142 = sub i64 %15, 1
  %polly.loop_cond143 = icmp sle i64 %polly.indvar140, %polly.adjust_ub142
  br i1 %polly.loop_cond143, label %polly.loop_header136, label %polly.merge130

polly.cond154:                                    ; preds = %.preheader.clone
  %162 = srem i64 %30, 8
  %163 = icmp eq i64 %162, 0
  %164 = icmp sge i64 %29, 1
  %or.cond177 = and i1 %163, %164
  br i1 %or.cond177, label %polly.then159, label %polly.merge155

polly.then159:                                    ; preds = %polly.cond154
  %165 = add i64 %29, -1
  %polly.loop_guard164 = icmp sle i64 0, %165
  br i1 %polly.loop_guard164, label %polly.loop_header161, label %polly.merge155

polly.loop_header161:                             ; preds = %polly.then159, %polly.loop_header161
  %polly.indvar165 = phi i64 [ %polly.indvar_next166, %polly.loop_header161 ], [ 0, %polly.then159 ]
  %p_170 = add i64 %29, %polly.indvar165
  %p_171 = trunc i64 %p_170 to i32
  %p_scevgep.clone = getelementptr [1000 x double]* %A, i64 %29, i64 %polly.indvar165
  %p_172 = srem i32 %p_171, %m
  %p_173 = sitofp i32 %p_172 to double
  %p_174 = fdiv double %p_173, %28
  store double %p_174, double* %p_scevgep.clone
  %p_indvar.next.clone = add i64 %polly.indvar165, 1
  %polly.indvar_next166 = add nsw i64 %polly.indvar165, 1
  %polly.adjust_ub167 = sub i64 %165, 1
  %polly.loop_cond168 = icmp sle i64 %polly.indvar165, %polly.adjust_ub167
  br i1 %polly.loop_cond168, label %polly.loop_header161, label %polly.merge155
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_trmm(i32 %m, i32 %n, double %alpha, [1000 x double]* %A, [1200 x double]* %B) #0 {
.split:
  %B28 = ptrtoint [1200 x double]* %B to i64
  %scevgep21 = getelementptr [1000 x double]* %A, i64 1, i64 0
  %scevgep2129 = bitcast double* %scevgep21 to i8*
  %scevgep2223 = ptrtoint double* %scevgep21 to i64
  %0 = zext i32 %m to i64
  %1 = add i64 %0, -1
  %2 = mul i64 8008, %1
  %3 = add i64 %scevgep2223, %2
  %4 = add i32 %m, -2
  %5 = add i32 %m, -1
  %6 = mul i32 -1, %5
  %7 = add i32 %4, %6
  %8 = zext i32 %7 to i64
  %9 = mul i64 8000, %8
  %10 = add i64 %3, %9
  %11 = inttoptr i64 %10 to i8*
  %scevgep24 = getelementptr [1200 x double]* %B, i64 1, i64 0
  %scevgep2425 = bitcast double* %scevgep24 to [1200 x double]*
  %12 = icmp ult [1200 x double]* %B, %scevgep2425
  %umin = select i1 %12, [1200 x double]* %B, [1200 x double]* %scevgep2425
  %umin30 = bitcast [1200 x double]* %umin to i8*
  %scevgep2627 = ptrtoint double* %scevgep24 to i64
  %13 = mul i64 9600, %1
  %14 = add i64 %scevgep2627, %13
  %15 = zext i32 %n to i64
  %16 = add i64 %15, -1
  %17 = mul i64 8, %16
  %18 = add i64 %14, %17
  %19 = mul i64 9600, %8
  %20 = add i64 %18, %19
  %21 = add i64 %B28, %13
  %22 = add i64 %21, %17
  %23 = icmp ugt i64 %22, %20
  %umax = select i1 %23, i64 %22, i64 %20
  %umax31 = inttoptr i64 %umax to i8*
  %24 = icmp ult i8* %11, %umin30
  %25 = icmp ult i8* %umax31, %scevgep2129
  %pair-no-alias = or i1 %24, %25
  %26 = icmp sgt i32 %m, 0
  br i1 %pair-no-alias, label %.split.split, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  br i1 %26, label %.preheader1.lr.ph.clone, label %.region.clone

.preheader1.lr.ph.clone:                          ; preds = %.split.split.clone
  %27 = zext i32 %4 to i64
  %28 = icmp sgt i32 %n, 0
  br label %.preheader1.clone

.preheader1.clone:                                ; preds = %._crit_edge5.clone, %.preheader1.lr.ph.clone
  %indvar9.clone = phi i64 [ 0, %.preheader1.lr.ph.clone ], [ %29, %._crit_edge5.clone ]
  %29 = add i64 %indvar9.clone, 1
  %k.02.clone = trunc i64 %29 to i32
  %30 = mul i64 %indvar9.clone, 1001
  %31 = mul i64 %indvar9.clone, -1
  %32 = add i64 %27, %31
  %33 = trunc i64 %32 to i32
  %34 = zext i32 %33 to i64
  %35 = add i64 %34, 1
  br i1 %28, label %.preheader.lr.ph.clone, label %._crit_edge5.clone

.preheader.lr.ph.clone:                           ; preds = %.preheader1.clone
  %36 = icmp slt i32 %k.02.clone, %m
  br label %.preheader.clone

.preheader.clone:                                 ; preds = %._crit_edge.clone, %.preheader.lr.ph.clone
  %indvar11.clone = phi i64 [ 0, %.preheader.lr.ph.clone ], [ %indvar.next12.clone, %._crit_edge.clone ]
  %scevgep16.clone = getelementptr [1200 x double]* %B, i64 %indvar9.clone, i64 %indvar11.clone
  br i1 %36, label %.lr.ph.clone, label %._crit_edge.clone

.lr.ph.clone:                                     ; preds = %.preheader.clone, %.lr.ph.clone
  %indvar.clone = phi i64 [ %38, %.lr.ph.clone ], [ 0, %.preheader.clone ]
  %37 = add i64 %29, %indvar.clone
  %scevgep.clone = getelementptr [1200 x double]* %B, i64 %37, i64 %indvar11.clone
  %38 = add i64 %indvar.clone, 1
  %scevgep13.clone = getelementptr [1000 x double]* %A, i64 %38, i64 %30
  %39 = load double* %scevgep13.clone, align 8, !tbaa !1
  %40 = load double* %scevgep.clone, align 8, !tbaa !1
  %41 = fmul double %39, %40
  %42 = load double* %scevgep16.clone, align 8, !tbaa !1
  %43 = fadd double %42, %41
  store double %43, double* %scevgep16.clone, align 8, !tbaa !1
  %exitcond.clone = icmp ne i64 %38, %35
  br i1 %exitcond.clone, label %.lr.ph.clone, label %._crit_edge.clone

._crit_edge.clone:                                ; preds = %.lr.ph.clone, %.preheader.clone
  %44 = load double* %scevgep16.clone, align 8, !tbaa !1
  %45 = fmul double %44, %alpha
  store double %45, double* %scevgep16.clone, align 8, !tbaa !1
  %indvar.next12.clone = add i64 %indvar11.clone, 1
  %exitcond14.clone = icmp ne i64 %indvar.next12.clone, %15
  br i1 %exitcond14.clone, label %.preheader.clone, label %._crit_edge5.clone

._crit_edge5.clone:                               ; preds = %._crit_edge.clone, %.preheader1.clone
  %exitcond17.clone = icmp ne i64 %29, %0
  br i1 %exitcond17.clone, label %.preheader1.clone, label %.region.clone

.split.split:                                     ; preds = %.split
  br i1 %26, label %.preheader1.lr.ph, label %.region.clone

.preheader1.lr.ph:                                ; preds = %.split.split
  %46 = zext i32 %4 to i64
  %47 = icmp sgt i32 %n, 0
  br label %.preheader1

.preheader1:                                      ; preds = %.preheader1.lr.ph, %polly.merge
  %indvar9 = phi i64 [ 0, %.preheader1.lr.ph ], [ %54, %polly.merge ]
  %48 = trunc i64 %indvar9 to i32
  %49 = mul i64 %indvar9, -1
  %50 = add i64 %46, %49
  %51 = trunc i64 %50 to i32
  %52 = zext i32 %51 to i64
  %53 = mul i64 %indvar9, 9600
  %54 = add i64 %indvar9, 1
  %k.02 = trunc i64 %54 to i32
  %55 = mul i64 %indvar9, 1001
  %56 = add i64 %52, 1
  br i1 %47, label %.preheader.lr.ph, label %polly.merge

.preheader.lr.ph:                                 ; preds = %.preheader1
  %57 = srem i64 %53, 8
  %58 = icmp eq i64 %57, 0
  %59 = icmp sge i64 %15, 1
  %or.cond = and i1 %58, %59
  br i1 %or.cond, label %polly.cond36, label %polly.merge

polly.merge:                                      ; preds = %polly.merge37, %polly.loop_header54, %.preheader.lr.ph, %.preheader1
  %exitcond17 = icmp ne i64 %54, %0
  br i1 %exitcond17, label %.preheader1, label %.region.clone

.region.clone:                                    ; preds = %.split.split, %polly.merge, %.split.split.clone, %._crit_edge5.clone
  ret void

polly.cond36:                                     ; preds = %.preheader.lr.ph
  %60 = sext i32 %48 to i64
  %61 = sext i32 %m to i64
  %62 = add i64 %61, -2
  %63 = icmp sle i64 %60, %62
  br i1 %63, label %polly.then38, label %polly.merge37

polly.merge37:                                    ; preds = %polly.then38, %polly.loop_exit42, %polly.cond36
  %polly.loop_guard57 = icmp sle i64 0, %16
  br i1 %polly.loop_guard57, label %polly.loop_header54, label %polly.merge

polly.then38:                                     ; preds = %polly.cond36
  %64 = mul i64 1200, %52
  %65 = add i64 %15, %64
  %66 = add i64 %65, -1
  %polly.loop_guard = icmp sle i64 0, %66
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.merge37

polly.loop_header:                                ; preds = %polly.then38, %polly.loop_exit42
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit42 ], [ 0, %polly.then38 ]
  %67 = mul i64 -1, %15
  %68 = add i64 %polly.indvar, %67
  %69 = add i64 %68, 1
  %70 = add i64 %69, 1200
  %71 = sub i64 %70, 1
  %72 = icmp slt i64 %69, 0
  %73 = select i1 %72, i64 %69, i64 %71
  %74 = sdiv i64 %73, 1200
  %75 = icmp sgt i64 0, %74
  %76 = select i1 %75, i64 0, i64 %74
  %77 = sub i64 %polly.indvar, 1200
  %78 = add i64 %77, 1
  %79 = icmp slt i64 %polly.indvar, 0
  %80 = select i1 %79, i64 %78, i64 %polly.indvar
  %81 = sdiv i64 %80, 1200
  %82 = icmp slt i64 %81, %52
  %83 = select i1 %82, i64 %81, i64 %52
  %polly.loop_guard43 = icmp sle i64 %76, %83
  br i1 %polly.loop_guard43, label %polly.loop_header40, label %polly.loop_exit42

polly.loop_exit42:                                ; preds = %polly.loop_header40, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %66, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.merge37

polly.loop_header40:                              ; preds = %polly.loop_header, %polly.loop_header40
  %polly.indvar44 = phi i64 [ %polly.indvar_next45, %polly.loop_header40 ], [ %76, %polly.loop_header ]
  %84 = mul i64 -1200, %polly.indvar44
  %85 = add i64 %polly.indvar, %84
  %p_scevgep16.moved.to. = getelementptr [1200 x double]* %B, i64 %indvar9, i64 %85
  %p_ = add i64 %54, %polly.indvar44
  %p_scevgep = getelementptr [1200 x double]* %B, i64 %p_, i64 %85
  %p_48 = add i64 %polly.indvar44, 1
  %p_scevgep13 = getelementptr [1000 x double]* %A, i64 %p_48, i64 %55
  %_p_scalar_ = load double* %p_scevgep13
  %_p_scalar_49 = load double* %p_scevgep
  %p_50 = fmul double %_p_scalar_, %_p_scalar_49
  %_p_scalar_51 = load double* %p_scevgep16.moved.to.
  %p_52 = fadd double %_p_scalar_51, %p_50
  store double %p_52, double* %p_scevgep16.moved.to.
  %polly.indvar_next45 = add nsw i64 %polly.indvar44, 1
  %polly.adjust_ub46 = sub i64 %83, 1
  %polly.loop_cond47 = icmp sle i64 %polly.indvar44, %polly.adjust_ub46
  br i1 %polly.loop_cond47, label %polly.loop_header40, label %polly.loop_exit42

polly.loop_header54:                              ; preds = %polly.merge37, %polly.loop_header54
  %polly.indvar58 = phi i64 [ %polly.indvar_next59, %polly.loop_header54 ], [ 0, %polly.merge37 ]
  %p_scevgep16.moved.to.32 = getelementptr [1200 x double]* %B, i64 %indvar9, i64 %polly.indvar58
  %_p_scalar_63 = load double* %p_scevgep16.moved.to.32
  %p_64 = fmul double %_p_scalar_63, %alpha
  store double %p_64, double* %p_scevgep16.moved.to.32
  %p_indvar.next12 = add i64 %polly.indvar58, 1
  %polly.indvar_next59 = add nsw i64 %polly.indvar58, 1
  %polly.adjust_ub60 = sub i64 %16, 1
  %polly.loop_cond61 = icmp sle i64 %polly.indvar58, %polly.adjust_ub60
  br i1 %polly.loop_cond61, label %polly.loop_header54, label %polly.merge
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %m, i32 %n, [1200 x double]* %B) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %m, 0
  br i1 %5, label %.preheader.lr.ph, label %22

.preheader.lr.ph:                                 ; preds = %.split
  %6 = zext i32 %n to i64
  %7 = zext i32 %m to i64
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
  %scevgep = getelementptr [1200 x double]* %B, i64 %indvar4, i64 %indvar
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
