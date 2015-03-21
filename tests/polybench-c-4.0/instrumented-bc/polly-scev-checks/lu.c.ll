; ModuleID = './linear-algebra/solvers/lu/lu.c'
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
  tail call void @kernel_lu(i32 2000, [2000 x double]* %1)
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
define internal void @init_array(i32 %n, [2000 x double]* %A) #0 {
.split:
  %A81 = bitcast [2000 x double]* %A to i8*
  %A77 = ptrtoint [2000 x double]* %A to i64
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.preheader7.lr.ph, label %.region

.preheader7.lr.ph:                                ; preds = %.split
  %1 = add i32 %n, -2
  %2 = zext i32 %n to i64
  %3 = zext i32 %1 to i64
  %4 = sitofp i32 %n to double
  br label %.preheader7

.preheader7:                                      ; preds = %.preheader7.lr.ph, %polly.merge273
  %indvar65 = phi i64 [ 0, %.preheader7.lr.ph ], [ %13, %polly.merge273 ]
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
  br i1 %15, label %.preheader6, label %polly.cond292

.preheader6:                                      ; preds = %polly.then297, %polly.loop_header299, %polly.cond292, %.preheader7
  %16 = icmp slt i32 %j.123, %n
  br i1 %16, label %polly.cond272, label %polly.merge273

polly.merge273:                                   ; preds = %polly.then277, %polly.loop_header279, %polly.cond272, %.preheader6
  store double 1.000000e+00, double* %scevgep76, align 8, !tbaa !6, !alias.scope !8
  %exitcond73 = icmp ne i64 %13, %2
  br i1 %exitcond73, label %.preheader7, label %.region

.region:                                          ; preds = %.split, %polly.merge273
  %17 = tail call i8* @polybench_alloc_data(i64 4000000, i32 8) #3
  %18 = ptrtoint i8* %17 to i64
  br i1 %0, label %.preheader5.lr.ph, label %.preheader4

.preheader5.lr.ph:                                ; preds = %.region
  %19 = zext i32 %n to i64
  %20 = sext i32 %n to i64
  %21 = icmp sge i64 %20, 1
  %22 = icmp sge i64 %19, 1
  %23 = and i1 %21, %22
  br i1 %23, label %polly.then184, label %.preheader4

.preheader4:                                      ; preds = %polly.then184, %polly.loop_exit197, %.preheader5.lr.ph, %.region
  %24 = zext i32 %n to i64
  %25 = add i64 %24, -1
  %26 = mul i64 8, %25
  %27 = add i64 %A77, %26
  %28 = mul i64 16000, %25
  %29 = add i64 %27, %28
  %umax79 = inttoptr i64 %29 to i8*
  %30 = add i64 %18, %28
  %31 = add i64 %30, %26
  %32 = inttoptr i64 %31 to i8*
  %33 = icmp ult i8* %umax79, %17
  %34 = icmp ult i8* %32, %A81
  %pair-no-alias = or i1 %33, %34
  br i1 %pair-no-alias, label %polly.start121, label %.preheader4.split.clone

.preheader4.split.clone:                          ; preds = %.preheader4
  br i1 %0, label %.preheader3.lr.ph.clone, label %.preheader1

.preheader3.lr.ph.clone:                          ; preds = %.preheader4.split.clone
  br label %.preheader3.clone

.preheader3.clone:                                ; preds = %._crit_edge15.clone, %.preheader3.lr.ph.clone
  %indvar40.clone = phi i64 [ 0, %.preheader3.lr.ph.clone ], [ %indvar.next41.clone, %._crit_edge15.clone ]
  br i1 %0, label %.preheader2.clone, label %._crit_edge15.clone

.preheader2.clone:                                ; preds = %.preheader3.clone, %._crit_edge13.clone
  %indvar42.clone = phi i64 [ %indvar.next43.clone, %._crit_edge13.clone ], [ 0, %.preheader3.clone ]
  %scevgep49.clone = getelementptr [2000 x double]* %A, i64 %indvar42.clone, i64 %indvar40.clone
  %35 = mul i64 %indvar42.clone, 16000
  br i1 %0, label %.lr.ph12.clone, label %._crit_edge13.clone

.lr.ph12.clone:                                   ; preds = %.preheader2.clone, %.lr.ph12.clone
  %indvar37.clone = phi i64 [ %indvar.next38.clone, %.lr.ph12.clone ], [ 0, %.preheader2.clone ]
  %scevgep.clone = getelementptr [2000 x double]* %A, i64 %indvar37.clone, i64 %indvar40.clone
  %36 = mul i64 %indvar37.clone, 8
  %37 = add i64 %35, %36
  %scevgep47.clone = getelementptr i8* %17, i64 %37
  %scevgep4445.clone = bitcast i8* %scevgep47.clone to double*
  %38 = load double* %scevgep49.clone, align 8, !tbaa !6
  %39 = load double* %scevgep.clone, align 8, !tbaa !6
  %40 = fmul double %38, %39
  %41 = load double* %scevgep4445.clone, align 8, !tbaa !6
  %42 = fadd double %41, %40
  store double %42, double* %scevgep4445.clone, align 8, !tbaa !6
  %indvar.next38.clone = add i64 %indvar37.clone, 1
  %exitcond39.clone = icmp ne i64 %indvar.next38.clone, %24
  br i1 %exitcond39.clone, label %.lr.ph12.clone, label %._crit_edge13.clone

._crit_edge13.clone:                              ; preds = %.lr.ph12.clone, %.preheader2.clone
  %indvar.next43.clone = add i64 %indvar42.clone, 1
  %exitcond46.clone = icmp ne i64 %indvar.next43.clone, %24
  br i1 %exitcond46.clone, label %.preheader2.clone, label %._crit_edge15.clone

._crit_edge15.clone:                              ; preds = %._crit_edge13.clone, %.preheader3.clone
  %indvar.next41.clone = add i64 %indvar40.clone, 1
  %exitcond50.clone = icmp ne i64 %indvar.next41.clone, %24
  br i1 %exitcond50.clone, label %.preheader3.clone, label %.preheader1

.preheader1:                                      ; preds = %polly.then125, %polly.loop_exit138, %polly.start121, %.preheader4.split.clone, %._crit_edge15.clone
  %43 = add i64 %A77, %28
  %44 = add i64 %43, %26
  %45 = inttoptr i64 %44 to i8*
  %46 = icmp ult i8* %45, %17
  %pair-no-alias82 = or i1 %46, %34
  br i1 %pair-no-alias82, label %polly.start, label %.preheader1.split.clone

.preheader1.split.clone:                          ; preds = %.preheader1
  br i1 %0, label %.preheader.lr.ph.clone, label %.region80.clone

.preheader.lr.ph.clone:                           ; preds = %.preheader1.split.clone
  br label %.preheader.clone

.preheader.clone:                                 ; preds = %._crit_edge.clone, %.preheader.lr.ph.clone
  %indvar29.clone = phi i64 [ 0, %.preheader.lr.ph.clone ], [ %indvar.next30.clone, %._crit_edge.clone ]
  %47 = mul i64 %indvar29.clone, 16000
  br i1 %0, label %.lr.ph.clone, label %._crit_edge.clone

.lr.ph.clone:                                     ; preds = %.preheader.clone, %.lr.ph.clone
  %indvar.clone = phi i64 [ %indvar.next.clone, %.lr.ph.clone ], [ 0, %.preheader.clone ]
  %scevgep32.clone = getelementptr [2000 x double]* %A, i64 %indvar29.clone, i64 %indvar.clone
  %48 = mul i64 %indvar.clone, 8
  %49 = add i64 %47, %48
  %scevgep35.clone = getelementptr i8* %17, i64 %49
  %scevgep31.clone = bitcast i8* %scevgep35.clone to double*
  %50 = load double* %scevgep31.clone, align 8, !tbaa !6
  store double %50, double* %scevgep32.clone, align 8, !tbaa !6
  %indvar.next.clone = add i64 %indvar.clone, 1
  %exitcond.clone = icmp ne i64 %indvar.next.clone, %24
  br i1 %exitcond.clone, label %.lr.ph.clone, label %._crit_edge.clone

._crit_edge.clone:                                ; preds = %.lr.ph.clone, %.preheader.clone
  %indvar.next30.clone = add i64 %indvar29.clone, 1
  %exitcond33.clone = icmp ne i64 %indvar.next30.clone, %24
  br i1 %exitcond33.clone, label %.preheader.clone, label %.region80.clone

.region80.clone:                                  ; preds = %polly.then, %polly.loop_exit95, %polly.start, %.preheader1.split.clone, %._crit_edge.clone
  tail call void @free(i8* %17) #3
  ret void

polly.start:                                      ; preds = %.preheader1
  %51 = sext i32 %n to i64
  %52 = icmp sge i64 %51, 1
  %53 = icmp sge i64 %24, 1
  %54 = and i1 %52, %53
  br i1 %54, label %polly.then, label %.region80.clone

polly.then:                                       ; preds = %polly.start
  %polly.loop_guard = icmp sle i64 0, %25
  br i1 %polly.loop_guard, label %polly.loop_header, label %.region80.clone

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit95
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit95 ], [ 0, %polly.then ]
  %55 = mul i64 -11, %24
  %56 = add i64 %55, 5
  %57 = sub i64 %56, 32
  %58 = add i64 %57, 1
  %59 = icmp slt i64 %56, 0
  %60 = select i1 %59, i64 %58, i64 %56
  %61 = sdiv i64 %60, 32
  %62 = mul i64 -32, %61
  %63 = mul i64 -32, %24
  %64 = add i64 %62, %63
  %65 = mul i64 -32, %polly.indvar
  %66 = mul i64 -3, %polly.indvar
  %67 = add i64 %66, %24
  %68 = add i64 %67, 5
  %69 = sub i64 %68, 32
  %70 = add i64 %69, 1
  %71 = icmp slt i64 %68, 0
  %72 = select i1 %71, i64 %70, i64 %68
  %73 = sdiv i64 %72, 32
  %74 = mul i64 -32, %73
  %75 = add i64 %65, %74
  %76 = add i64 %75, -640
  %77 = icmp sgt i64 %64, %76
  %78 = select i1 %77, i64 %64, i64 %76
  %79 = mul i64 -20, %polly.indvar
  %polly.loop_guard96 = icmp sle i64 %78, %79
  br i1 %polly.loop_guard96, label %polly.loop_header93, label %polly.loop_exit95

polly.loop_exit95:                                ; preds = %polly.loop_exit104, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %25, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %.region80.clone

polly.loop_header93:                              ; preds = %polly.loop_header, %polly.loop_exit104
  %polly.indvar97 = phi i64 [ %polly.indvar_next98, %polly.loop_exit104 ], [ %78, %polly.loop_header ]
  %80 = mul i64 -1, %polly.indvar97
  %81 = mul i64 -1, %24
  %82 = add i64 %80, %81
  %83 = add i64 %82, -30
  %84 = add i64 %83, 20
  %85 = sub i64 %84, 1
  %86 = icmp slt i64 %83, 0
  %87 = select i1 %86, i64 %83, i64 %85
  %88 = sdiv i64 %87, 20
  %89 = icmp sgt i64 %88, %polly.indvar
  %90 = select i1 %89, i64 %88, i64 %polly.indvar
  %91 = sub i64 %80, 20
  %92 = add i64 %91, 1
  %93 = icmp slt i64 %80, 0
  %94 = select i1 %93, i64 %92, i64 %80
  %95 = sdiv i64 %94, 20
  %96 = add i64 %polly.indvar, 31
  %97 = icmp slt i64 %95, %96
  %98 = select i1 %97, i64 %95, i64 %96
  %99 = icmp slt i64 %98, %25
  %100 = select i1 %99, i64 %98, i64 %25
  %polly.loop_guard105 = icmp sle i64 %90, %100
  br i1 %polly.loop_guard105, label %polly.loop_header102, label %polly.loop_exit104

polly.loop_exit104:                               ; preds = %polly.loop_exit113, %polly.loop_header93
  %polly.indvar_next98 = add nsw i64 %polly.indvar97, 32
  %polly.adjust_ub99 = sub i64 %79, 32
  %polly.loop_cond100 = icmp sle i64 %polly.indvar97, %polly.adjust_ub99
  br i1 %polly.loop_cond100, label %polly.loop_header93, label %polly.loop_exit95

polly.loop_header102:                             ; preds = %polly.loop_header93, %polly.loop_exit113
  %polly.indvar106 = phi i64 [ %polly.indvar_next107, %polly.loop_exit113 ], [ %90, %polly.loop_header93 ]
  %101 = mul i64 -20, %polly.indvar106
  %102 = add i64 %101, %81
  %103 = add i64 %102, 1
  %104 = icmp sgt i64 %polly.indvar97, %103
  %105 = select i1 %104, i64 %polly.indvar97, i64 %103
  %106 = add i64 %polly.indvar97, 31
  %107 = icmp slt i64 %101, %106
  %108 = select i1 %107, i64 %101, i64 %106
  %polly.loop_guard114 = icmp sle i64 %105, %108
  br i1 %polly.loop_guard114, label %polly.loop_header111, label %polly.loop_exit113

polly.loop_exit113:                               ; preds = %polly.loop_header111, %polly.loop_header102
  %polly.indvar_next107 = add nsw i64 %polly.indvar106, 1
  %polly.adjust_ub108 = sub i64 %100, 1
  %polly.loop_cond109 = icmp sle i64 %polly.indvar106, %polly.adjust_ub108
  br i1 %polly.loop_cond109, label %polly.loop_header102, label %polly.loop_exit104

polly.loop_header111:                             ; preds = %polly.loop_header102, %polly.loop_header111
  %polly.indvar115 = phi i64 [ %polly.indvar_next116, %polly.loop_header111 ], [ %105, %polly.loop_header102 ]
  %109 = mul i64 -1, %polly.indvar115
  %110 = add i64 %101, %109
  %p_.moved.to.89 = mul i64 %polly.indvar106, 16000
  %p_scevgep32 = getelementptr [2000 x double]* %A, i64 %polly.indvar106, i64 %110
  %p_ = mul i64 %110, 8
  %p_119 = add i64 %p_.moved.to.89, %p_
  %p_scevgep35 = getelementptr i8* %17, i64 %p_119
  %p_scevgep31 = bitcast i8* %p_scevgep35 to double*
  %_p_scalar_ = load double* %p_scevgep31
  store double %_p_scalar_, double* %p_scevgep32
  %p_indvar.next = add i64 %110, 1
  %polly.indvar_next116 = add nsw i64 %polly.indvar115, 1
  %polly.adjust_ub117 = sub i64 %108, 1
  %polly.loop_cond118 = icmp sle i64 %polly.indvar115, %polly.adjust_ub117
  br i1 %polly.loop_cond118, label %polly.loop_header111, label %polly.loop_exit113

polly.start121:                                   ; preds = %.preheader4
  %111 = sext i32 %n to i64
  %112 = icmp sge i64 %111, 1
  %113 = icmp sge i64 %24, 1
  %114 = and i1 %112, %113
  br i1 %114, label %polly.then125, label %.preheader1

polly.then125:                                    ; preds = %polly.start121
  %polly.loop_guard130 = icmp sle i64 0, %25
  br i1 %polly.loop_guard130, label %polly.loop_header127, label %.preheader1

polly.loop_header127:                             ; preds = %polly.then125, %polly.loop_exit138
  %polly.indvar131 = phi i64 [ %polly.indvar_next132, %polly.loop_exit138 ], [ 0, %polly.then125 ]
  br i1 %polly.loop_guard130, label %polly.loop_header136, label %polly.loop_exit138

polly.loop_exit138:                               ; preds = %polly.loop_exit147, %polly.loop_header127
  %polly.indvar_next132 = add nsw i64 %polly.indvar131, 1
  %polly.adjust_ub133 = sub i64 %25, 1
  %polly.loop_cond134 = icmp sle i64 %polly.indvar131, %polly.adjust_ub133
  br i1 %polly.loop_cond134, label %polly.loop_header127, label %.preheader1

polly.loop_header136:                             ; preds = %polly.loop_header127, %polly.loop_exit147
  %polly.indvar140 = phi i64 [ %polly.indvar_next141, %polly.loop_exit147 ], [ 0, %polly.loop_header127 ]
  %115 = mul i64 -11, %24
  %116 = add i64 %115, 5
  %117 = sub i64 %116, 32
  %118 = add i64 %117, 1
  %119 = icmp slt i64 %116, 0
  %120 = select i1 %119, i64 %118, i64 %116
  %121 = sdiv i64 %120, 32
  %122 = mul i64 -32, %121
  %123 = mul i64 -32, %24
  %124 = add i64 %122, %123
  %125 = mul i64 -32, %polly.indvar140
  %126 = mul i64 -3, %polly.indvar140
  %127 = add i64 %126, %24
  %128 = add i64 %127, 5
  %129 = sub i64 %128, 32
  %130 = add i64 %129, 1
  %131 = icmp slt i64 %128, 0
  %132 = select i1 %131, i64 %130, i64 %128
  %133 = sdiv i64 %132, 32
  %134 = mul i64 -32, %133
  %135 = add i64 %125, %134
  %136 = add i64 %135, -640
  %137 = icmp sgt i64 %124, %136
  %138 = select i1 %137, i64 %124, i64 %136
  %139 = mul i64 -20, %polly.indvar140
  %polly.loop_guard148 = icmp sle i64 %138, %139
  br i1 %polly.loop_guard148, label %polly.loop_header145, label %polly.loop_exit147

polly.loop_exit147:                               ; preds = %polly.loop_exit156, %polly.loop_header136
  %polly.indvar_next141 = add nsw i64 %polly.indvar140, 32
  %polly.adjust_ub142 = sub i64 %25, 32
  %polly.loop_cond143 = icmp sle i64 %polly.indvar140, %polly.adjust_ub142
  br i1 %polly.loop_cond143, label %polly.loop_header136, label %polly.loop_exit138

polly.loop_header145:                             ; preds = %polly.loop_header136, %polly.loop_exit156
  %polly.indvar149 = phi i64 [ %polly.indvar_next150, %polly.loop_exit156 ], [ %138, %polly.loop_header136 ]
  %140 = mul i64 -1, %polly.indvar149
  %141 = mul i64 -1, %24
  %142 = add i64 %140, %141
  %143 = add i64 %142, -30
  %144 = add i64 %143, 20
  %145 = sub i64 %144, 1
  %146 = icmp slt i64 %143, 0
  %147 = select i1 %146, i64 %143, i64 %145
  %148 = sdiv i64 %147, 20
  %149 = icmp sgt i64 %148, %polly.indvar140
  %150 = select i1 %149, i64 %148, i64 %polly.indvar140
  %151 = sub i64 %140, 20
  %152 = add i64 %151, 1
  %153 = icmp slt i64 %140, 0
  %154 = select i1 %153, i64 %152, i64 %140
  %155 = sdiv i64 %154, 20
  %156 = add i64 %polly.indvar140, 31
  %157 = icmp slt i64 %155, %156
  %158 = select i1 %157, i64 %155, i64 %156
  %159 = icmp slt i64 %158, %25
  %160 = select i1 %159, i64 %158, i64 %25
  %polly.loop_guard157 = icmp sle i64 %150, %160
  br i1 %polly.loop_guard157, label %polly.loop_header154, label %polly.loop_exit156

polly.loop_exit156:                               ; preds = %polly.loop_exit165, %polly.loop_header145
  %polly.indvar_next150 = add nsw i64 %polly.indvar149, 32
  %polly.adjust_ub151 = sub i64 %139, 32
  %polly.loop_cond152 = icmp sle i64 %polly.indvar149, %polly.adjust_ub151
  br i1 %polly.loop_cond152, label %polly.loop_header145, label %polly.loop_exit147

polly.loop_header154:                             ; preds = %polly.loop_header145, %polly.loop_exit165
  %polly.indvar158 = phi i64 [ %polly.indvar_next159, %polly.loop_exit165 ], [ %150, %polly.loop_header145 ]
  %161 = mul i64 -20, %polly.indvar158
  %162 = add i64 %161, %141
  %163 = add i64 %162, 1
  %164 = icmp sgt i64 %polly.indvar149, %163
  %165 = select i1 %164, i64 %polly.indvar149, i64 %163
  %166 = add i64 %polly.indvar149, 31
  %167 = icmp slt i64 %161, %166
  %168 = select i1 %167, i64 %161, i64 %166
  %polly.loop_guard166 = icmp sle i64 %165, %168
  br i1 %polly.loop_guard166, label %polly.loop_header163, label %polly.loop_exit165

polly.loop_exit165:                               ; preds = %polly.loop_header163, %polly.loop_header154
  %polly.indvar_next159 = add nsw i64 %polly.indvar158, 1
  %polly.adjust_ub160 = sub i64 %160, 1
  %polly.loop_cond161 = icmp sle i64 %polly.indvar158, %polly.adjust_ub160
  br i1 %polly.loop_cond161, label %polly.loop_header154, label %polly.loop_exit156

polly.loop_header163:                             ; preds = %polly.loop_header154, %polly.loop_header163
  %polly.indvar167 = phi i64 [ %polly.indvar_next168, %polly.loop_header163 ], [ %165, %polly.loop_header154 ]
  %169 = mul i64 -1, %polly.indvar167
  %170 = add i64 %161, %169
  %p_scevgep49.moved.to. = getelementptr [2000 x double]* %A, i64 %polly.indvar158, i64 %polly.indvar131
  %p_.moved.to.84 = mul i64 %polly.indvar158, 16000
  %p_scevgep = getelementptr [2000 x double]* %A, i64 %170, i64 %polly.indvar131
  %p_172 = mul i64 %170, 8
  %p_173 = add i64 %p_.moved.to.84, %p_172
  %p_scevgep47 = getelementptr i8* %17, i64 %p_173
  %p_scevgep4445 = bitcast i8* %p_scevgep47 to double*
  %_p_scalar_174 = load double* %p_scevgep49.moved.to.
  %_p_scalar_175 = load double* %p_scevgep
  %p_176 = fmul double %_p_scalar_174, %_p_scalar_175
  %_p_scalar_177 = load double* %p_scevgep4445
  %p_178 = fadd double %_p_scalar_177, %p_176
  store double %p_178, double* %p_scevgep4445
  %p_indvar.next38 = add i64 %170, 1
  %polly.indvar_next168 = add nsw i64 %polly.indvar167, 1
  %polly.adjust_ub169 = sub i64 %168, 1
  %polly.loop_cond170 = icmp sle i64 %polly.indvar167, %polly.adjust_ub169
  br i1 %polly.loop_cond170, label %polly.loop_header163, label %polly.loop_exit165

polly.then184:                                    ; preds = %.preheader5.lr.ph
  %171 = add i64 %19, -1
  %polly.loop_guard189 = icmp sle i64 0, %171
  br i1 %polly.loop_guard189, label %polly.loop_header186, label %.preheader4

polly.loop_header186:                             ; preds = %polly.then184, %polly.loop_exit197
  %polly.indvar190 = phi i64 [ %polly.indvar_next191, %polly.loop_exit197 ], [ 0, %polly.then184 ]
  %172 = mul i64 -11, %19
  %173 = add i64 %172, 5
  %174 = sub i64 %173, 32
  %175 = add i64 %174, 1
  %176 = icmp slt i64 %173, 0
  %177 = select i1 %176, i64 %175, i64 %173
  %178 = sdiv i64 %177, 32
  %179 = mul i64 -32, %178
  %180 = mul i64 -32, %19
  %181 = add i64 %179, %180
  %182 = mul i64 -32, %polly.indvar190
  %183 = mul i64 -3, %polly.indvar190
  %184 = add i64 %183, %19
  %185 = add i64 %184, 5
  %186 = sub i64 %185, 32
  %187 = add i64 %186, 1
  %188 = icmp slt i64 %185, 0
  %189 = select i1 %188, i64 %187, i64 %185
  %190 = sdiv i64 %189, 32
  %191 = mul i64 -32, %190
  %192 = add i64 %182, %191
  %193 = add i64 %192, -640
  %194 = icmp sgt i64 %181, %193
  %195 = select i1 %194, i64 %181, i64 %193
  %196 = mul i64 -20, %polly.indvar190
  %polly.loop_guard198 = icmp sle i64 %195, %196
  br i1 %polly.loop_guard198, label %polly.loop_header195, label %polly.loop_exit197

polly.loop_exit197:                               ; preds = %polly.loop_exit206, %polly.loop_header186
  %polly.indvar_next191 = add nsw i64 %polly.indvar190, 32
  %polly.adjust_ub192 = sub i64 %171, 32
  %polly.loop_cond193 = icmp sle i64 %polly.indvar190, %polly.adjust_ub192
  br i1 %polly.loop_cond193, label %polly.loop_header186, label %.preheader4

polly.loop_header195:                             ; preds = %polly.loop_header186, %polly.loop_exit206
  %polly.indvar199 = phi i64 [ %polly.indvar_next200, %polly.loop_exit206 ], [ %195, %polly.loop_header186 ]
  %197 = mul i64 -1, %polly.indvar199
  %198 = mul i64 -1, %19
  %199 = add i64 %197, %198
  %200 = add i64 %199, -30
  %201 = add i64 %200, 20
  %202 = sub i64 %201, 1
  %203 = icmp slt i64 %200, 0
  %204 = select i1 %203, i64 %200, i64 %202
  %205 = sdiv i64 %204, 20
  %206 = icmp sgt i64 %205, %polly.indvar190
  %207 = select i1 %206, i64 %205, i64 %polly.indvar190
  %208 = sub i64 %197, 20
  %209 = add i64 %208, 1
  %210 = icmp slt i64 %197, 0
  %211 = select i1 %210, i64 %209, i64 %197
  %212 = sdiv i64 %211, 20
  %213 = add i64 %polly.indvar190, 31
  %214 = icmp slt i64 %212, %213
  %215 = select i1 %214, i64 %212, i64 %213
  %216 = icmp slt i64 %215, %171
  %217 = select i1 %216, i64 %215, i64 %171
  %polly.loop_guard207 = icmp sle i64 %207, %217
  br i1 %polly.loop_guard207, label %polly.loop_header204, label %polly.loop_exit206

polly.loop_exit206:                               ; preds = %polly.loop_exit215, %polly.loop_header195
  %polly.indvar_next200 = add nsw i64 %polly.indvar199, 32
  %polly.adjust_ub201 = sub i64 %196, 32
  %polly.loop_cond202 = icmp sle i64 %polly.indvar199, %polly.adjust_ub201
  br i1 %polly.loop_cond202, label %polly.loop_header195, label %polly.loop_exit197

polly.loop_header204:                             ; preds = %polly.loop_header195, %polly.loop_exit215
  %polly.indvar208 = phi i64 [ %polly.indvar_next209, %polly.loop_exit215 ], [ %207, %polly.loop_header195 ]
  %218 = mul i64 -20, %polly.indvar208
  %219 = add i64 %218, %198
  %220 = add i64 %219, 1
  %221 = icmp sgt i64 %polly.indvar199, %220
  %222 = select i1 %221, i64 %polly.indvar199, i64 %220
  %223 = add i64 %polly.indvar199, 31
  %224 = icmp slt i64 %218, %223
  %225 = select i1 %224, i64 %218, i64 %223
  %polly.loop_guard216 = icmp sle i64 %222, %225
  br i1 %polly.loop_guard216, label %polly.loop_header213, label %polly.loop_exit215

polly.loop_exit215:                               ; preds = %polly.loop_header213, %polly.loop_header204
  %polly.indvar_next209 = add nsw i64 %polly.indvar208, 1
  %polly.adjust_ub210 = sub i64 %217, 1
  %polly.loop_cond211 = icmp sle i64 %polly.indvar208, %polly.adjust_ub210
  br i1 %polly.loop_cond211, label %polly.loop_header204, label %polly.loop_exit206

polly.loop_header213:                             ; preds = %polly.loop_header204, %polly.loop_header213
  %polly.indvar217 = phi i64 [ %polly.indvar_next218, %polly.loop_header213 ], [ %222, %polly.loop_header204 ]
  %226 = mul i64 -1, %polly.indvar217
  %227 = add i64 %218, %226
  %p_.moved.to. = mul i64 %polly.indvar208, 16000
  %p_222 = mul i64 %227, 8
  %p_223 = add i64 %p_.moved.to., %p_222
  %p_scevgep61 = getelementptr i8* %17, i64 %p_223
  %p_scevgep5859 = bitcast i8* %p_scevgep61 to double*
  store double 0.000000e+00, double* %p_scevgep5859
  %p_indvar.next54 = add i64 %227, 1
  %polly.indvar_next218 = add nsw i64 %polly.indvar217, 1
  %polly.adjust_ub219 = sub i64 %225, 1
  %polly.loop_cond220 = icmp sle i64 %polly.indvar217, %polly.adjust_ub219
  br i1 %polly.loop_cond220, label %polly.loop_header213, label %polly.loop_exit215

polly.cond272:                                    ; preds = %.preheader6
  %228 = srem i64 %10, 8
  %229 = icmp eq i64 %228, 0
  br i1 %229, label %polly.then277, label %polly.merge273

polly.then277:                                    ; preds = %polly.cond272
  br i1 true, label %polly.loop_header279, label %polly.merge273

polly.loop_header279:                             ; preds = %polly.then277, %polly.loop_header279
  %polly.indvar283 = phi i64 [ %polly.indvar_next284, %polly.loop_header279 ], [ 0, %polly.then277 ]
  %p_288 = add i64 %12, %polly.indvar283
  %p_scevgep72 = getelementptr [2000 x double]* %A, i64 0, i64 %p_288
  store double 0.000000e+00, double* %p_scevgep72
  %p_indvar.next70 = add i64 %polly.indvar283, 1
  %polly.indvar_next284 = add nsw i64 %polly.indvar283, 1
  %polly.adjust_ub285 = sub i64 %9, 1
  %polly.loop_cond286 = icmp sle i64 %polly.indvar283, %polly.adjust_ub285
  br i1 %polly.loop_cond286, label %polly.loop_header279, label %polly.merge273

polly.cond292:                                    ; preds = %.preheader7
  %230 = srem i64 %5, 8
  %231 = icmp eq i64 %230, 0
  %232 = icmp sge i64 %indvar65, 0
  %or.cond316 = and i1 %231, %232
  br i1 %or.cond316, label %polly.then297, label %.preheader6

polly.then297:                                    ; preds = %polly.cond292
  br i1 %232, label %polly.loop_header299, label %.preheader6

polly.loop_header299:                             ; preds = %polly.then297, %polly.loop_header299
  %polly.indvar303 = phi i64 [ %polly.indvar_next304, %polly.loop_header299 ], [ 0, %polly.then297 ]
  %p_scevgep68 = getelementptr [2000 x double]* %A, i64 %indvar65, i64 %polly.indvar303
  %p_308 = mul i64 %polly.indvar303, -1
  %p_309 = trunc i64 %p_308 to i32
  %p_310 = srem i32 %p_309, %n
  %p_311 = sitofp i32 %p_310 to double
  %p_312 = fdiv double %p_311, %4
  %p_313 = fadd double %p_312, 1.000000e+00
  store double %p_313, double* %p_scevgep68
  %p_indvar.next64 = add i64 %polly.indvar303, 1
  %polly.indvar_next304 = add nsw i64 %polly.indvar303, 1
  %polly.adjust_ub305 = sub i64 %indvar65, 1
  %polly.loop_cond306 = icmp sle i64 %polly.indvar303, %polly.adjust_ub305
  br i1 %polly.loop_cond306, label %polly.loop_header299, label %.preheader6
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_lu(i32 %n, [2000 x double]* %A) #0 {
.split:
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.preheader3.lr.ph, label %.region

.preheader3.lr.ph:                                ; preds = %.split
  %1 = add i32 %n, -1
  %2 = zext i32 %n to i64
  %3 = zext i32 %1 to i64
  br label %.preheader3

.preheader3:                                      ; preds = %.preheader3.lr.ph, %polly.merge111
  %4 = phi i64 [ 0, %.preheader3.lr.ph ], [ %indvar.next17, %polly.merge111 ]
  %5 = mul i64 %4, 16000
  %6 = trunc i64 %4 to i32
  %7 = mul i64 %4, -1
  %8 = add i64 %3, %7
  %9 = trunc i64 %8 to i32
  %10 = zext i32 %9 to i64
  %11 = mul i64 %4, 16008
  %12 = mul i64 %4, 2001
  %13 = icmp sgt i32 %6, 0
  br i1 %13, label %polly.cond143, label %.preheader2

.preheader2:                                      ; preds = %polly.stmt.149, %polly.loop_exit165, %polly.cond143, %.preheader3
  %14 = icmp slt i32 %6, %n
  br i1 %14, label %.preheader.lr.ph, label %polly.merge111

.preheader.lr.ph:                                 ; preds = %.preheader2
  %15 = srem i64 %11, 8
  %16 = icmp eq i64 %15, 0
  br i1 %16, label %polly.cond113, label %polly.merge111

polly.merge111:                                   ; preds = %polly.then115, %polly.loop_exit128, %polly.cond113, %.preheader.lr.ph, %.preheader2
  %indvar.next17 = add i64 %4, 1
  %exitcond33 = icmp ne i64 %indvar.next17, %2
  br i1 %exitcond33, label %.preheader3, label %.region

.region:                                          ; preds = %.split, %polly.merge111
  ret void

polly.cond113:                                    ; preds = %.preheader.lr.ph
  %17 = icmp sge i64 %4, 1
  %18 = sext i32 %6 to i64
  %19 = icmp sge i64 %18, 1
  %20 = and i1 %17, %19
  br i1 %20, label %polly.then115, label %polly.merge111

polly.then115:                                    ; preds = %polly.cond113
  br i1 true, label %polly.loop_header117, label %polly.merge111

polly.loop_header117:                             ; preds = %polly.then115, %polly.loop_exit128
  %polly.indvar121 = phi i64 [ %polly.indvar_next122, %polly.loop_exit128 ], [ 0, %polly.then115 ]
  %21 = add i64 %4, -1
  %polly.loop_guard129 = icmp sle i64 0, %21
  br i1 %polly.loop_guard129, label %polly.loop_header126, label %polly.loop_exit128

polly.loop_exit128:                               ; preds = %polly.loop_header126, %polly.loop_header117
  %polly.indvar_next122 = add nsw i64 %polly.indvar121, 1
  %polly.adjust_ub123 = sub i64 %10, 1
  %polly.loop_cond124 = icmp sle i64 %polly.indvar121, %polly.adjust_ub123
  br i1 %polly.loop_cond124, label %polly.loop_header117, label %polly.merge111

polly.loop_header126:                             ; preds = %polly.loop_header117, %polly.loop_header126
  %polly.indvar130 = phi i64 [ %polly.indvar_next131, %polly.loop_header126 ], [ 0, %polly.loop_header117 ]
  %p_.moved.to.40 = add i64 %4, %polly.indvar121
  %p_.moved.to.41 = add i64 %12, %polly.indvar121
  %p_scevgep32.moved.to. = getelementptr [2000 x double]* %A, i64 0, i64 %p_.moved.to.41
  %p_scevgep29 = getelementptr [2000 x double]* %A, i64 %polly.indvar130, i64 %p_.moved.to.40
  %p_scevgep26 = getelementptr [2000 x double]* %A, i64 %4, i64 %polly.indvar130
  %_p_scalar_135 = load double* %p_scevgep26
  %_p_scalar_136 = load double* %p_scevgep29
  %p_137 = fmul double %_p_scalar_135, %_p_scalar_136
  %_p_scalar_138 = load double* %p_scevgep32.moved.to.
  %p_139 = fsub double %_p_scalar_138, %p_137
  store double %p_139, double* %p_scevgep32.moved.to.
  %p_indvar.next24 = add i64 %polly.indvar130, 1
  %polly.indvar_next131 = add nsw i64 %polly.indvar130, 1
  %polly.adjust_ub132 = sub i64 %21, 1
  %polly.loop_cond133 = icmp sle i64 %polly.indvar130, %polly.adjust_ub132
  br i1 %polly.loop_cond133, label %polly.loop_header126, label %polly.loop_exit128

polly.cond143:                                    ; preds = %.preheader3
  %22 = srem i64 %5, 8
  %23 = icmp eq i64 %22, 0
  %24 = icmp sge i64 %4, 1
  %or.cond = and i1 %23, %24
  br i1 %or.cond, label %polly.stmt.149, label %.preheader2

polly.stmt.149:                                   ; preds = %polly.cond143
  %p_scevgep22.moved.to. = getelementptr [2000 x double]* %A, i64 0, i64 0
  %p_scevgep21.moved.to.45 = getelementptr [2000 x double]* %A, i64 %4, i64 0
  %_p_scalar_150 = load double* %p_scevgep22.moved.to.
  %_p_scalar_151 = load double* %p_scevgep21.moved.to.45
  %p_152 = fdiv double %_p_scalar_151, %_p_scalar_150
  store double %p_152, double* %p_scevgep21.moved.to.45
  %25 = add i64 %4, -1
  %polly.loop_guard157 = icmp sle i64 1, %25
  br i1 %polly.loop_guard157, label %polly.loop_header154, label %.preheader2

polly.loop_header154:                             ; preds = %polly.stmt.149, %polly.loop_exit165
  %polly.indvar158 = phi i64 [ %polly.indvar_next159, %polly.loop_exit165 ], [ 1, %polly.stmt.149 ]
  %26 = add i64 %polly.indvar158, -1
  %polly.loop_guard166 = icmp sle i64 0, %26
  br i1 %polly.loop_guard166, label %polly.loop_header163, label %polly.loop_exit165

polly.loop_exit165:                               ; preds = %polly.loop_header163, %polly.loop_header154
  %p_.moved.to.44178 = mul i64 %polly.indvar158, 2001
  %p_scevgep22.moved.to.179 = getelementptr [2000 x double]* %A, i64 0, i64 %p_.moved.to.44178
  %p_scevgep21.moved.to.45180 = getelementptr [2000 x double]* %A, i64 %4, i64 %polly.indvar158
  %_p_scalar_181 = load double* %p_scevgep22.moved.to.179
  %_p_scalar_182 = load double* %p_scevgep21.moved.to.45180
  %p_183 = fdiv double %_p_scalar_182, %_p_scalar_181
  store double %p_183, double* %p_scevgep21.moved.to.45180
  %p_indvar.next15184 = add i64 %polly.indvar158, 1
  %polly.indvar_next159 = add nsw i64 %polly.indvar158, 1
  %polly.adjust_ub160 = sub i64 %25, 1
  %polly.loop_cond161 = icmp sle i64 %polly.indvar158, %polly.adjust_ub160
  br i1 %polly.loop_cond161, label %polly.loop_header154, label %.preheader2

polly.loop_header163:                             ; preds = %polly.loop_header154, %polly.loop_header163
  %polly.indvar167 = phi i64 [ %polly.indvar_next168, %polly.loop_header163 ], [ 0, %polly.loop_header154 ]
  %p_scevgep21.moved.to. = getelementptr [2000 x double]* %A, i64 %4, i64 %polly.indvar158
  %p_scevgep = getelementptr [2000 x double]* %A, i64 %4, i64 %polly.indvar167
  %p_scevgep18 = getelementptr [2000 x double]* %A, i64 %polly.indvar167, i64 %polly.indvar158
  %_p_scalar_172 = load double* %p_scevgep
  %_p_scalar_173 = load double* %p_scevgep18
  %p_174 = fmul double %_p_scalar_172, %_p_scalar_173
  %_p_scalar_175 = load double* %p_scevgep21.moved.to.
  %p_176 = fsub double %_p_scalar_175, %p_174
  store double %p_176, double* %p_scevgep21.moved.to.
  %p_indvar.next = add i64 %polly.indvar167, 1
  %polly.indvar_next168 = add nsw i64 %polly.indvar167, 1
  %polly.adjust_ub169 = sub i64 %26, 1
  %polly.loop_cond170 = icmp sle i64 %polly.indvar167, %polly.adjust_ub169
  br i1 %polly.loop_cond170, label %polly.loop_header163, label %polly.loop_exit165
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, [2000 x double]* %A) #0 {
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
  %23 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %24 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8]* @.str3, i64 0, i64 0)) #5
  %25 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
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
!2 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{metadata !3, metadata !3, i64 0}
!6 = metadata !{metadata !7, metadata !7, i64 0}
!7 = metadata !{metadata !"double", metadata !3, i64 0}
!8 = metadata !{metadata !9}
!9 = metadata !{metadata !9, metadata !10, metadata !"init_array: %A"}
!10 = metadata !{metadata !10, metadata !"init_array"}
