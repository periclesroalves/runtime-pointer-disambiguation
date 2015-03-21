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
define internal void @init_array(i32 %n, [2000 x double]* %A, double* %b, double* %x, double* %y) #0 {
.split:
  %b89 = bitcast double* %b to i8*
  %x90 = bitcast double* %x to i8*
  %y92 = bitcast double* %y to i8*
  %A100 = bitcast [2000 x double]* %A to i8*
  %A95 = ptrtoint [2000 x double]* %A to i64
  %y91 = ptrtoint double* %y to i64
  %x88 = ptrtoint double* %x to i64
  %b87 = ptrtoint double* %b to i64
  %0 = zext i32 %n to i64
  %1 = add i64 %0, -1
  %2 = mul i64 8, %1
  %3 = add i64 %b87, %2
  %4 = inttoptr i64 %3 to i8*
  %5 = add i64 %x88, %2
  %6 = inttoptr i64 %5 to i8*
  %7 = icmp ult i8* %4, %x90
  %8 = icmp ult i8* %6, %b89
  %pair-no-alias = or i1 %7, %8
  %9 = add i64 %y91, %2
  %10 = inttoptr i64 %9 to i8*
  %11 = icmp ult i8* %4, %y92
  %12 = icmp ult i8* %10, %b89
  %pair-no-alias93 = or i1 %11, %12
  %13 = and i1 %pair-no-alias, %pair-no-alias93
  %14 = icmp ult i8* %6, %y92
  %15 = icmp ult i8* %10, %x90
  %pair-no-alias94 = or i1 %14, %15
  %16 = and i1 %13, %pair-no-alias94
  br i1 %16, label %polly.start337, label %.split.split.clone

.split.split.clone:                               ; preds = %.split
  %17 = sitofp i32 %n to double
  %18 = icmp sgt i32 %n, 0
  br i1 %18, label %.lr.ph32.clone, label %.preheader8.split

.lr.ph32.clone:                                   ; preds = %.split.split.clone
  br label %19

; <label>:19                                      ; preds = %19, %.lr.ph32.clone
  %indvar81.clone = phi i64 [ 0, %.lr.ph32.clone ], [ %20, %19 ]
  %scevgep84.clone = getelementptr double* %x, i64 %indvar81.clone
  %scevgep85.clone = getelementptr double* %y, i64 %indvar81.clone
  %20 = add i64 %indvar81.clone, 1
  %21 = trunc i64 %20 to i32
  %scevgep86.clone = getelementptr double* %b, i64 %indvar81.clone
  store double 0.000000e+00, double* %scevgep84.clone, align 8, !tbaa !6
  store double 0.000000e+00, double* %scevgep85.clone, align 8, !tbaa !6
  %22 = sitofp i32 %21 to double
  %23 = fdiv double %22, %17
  %24 = fmul double %23, 5.000000e-01
  %25 = fadd double %24, 4.000000e+00
  store double %25, double* %scevgep86.clone, align 8, !tbaa !6
  %exitcond83.clone = icmp ne i64 %20, %0
  br i1 %exitcond83.clone, label %19, label %.preheader8.split

.preheader8.split:                                ; preds = %polly.then341, %polly.loop_header343, %polly.start337, %19, %.split.split.clone
  %26 = icmp sgt i32 %n, 0
  br i1 %26, label %.preheader7.lr.ph, label %.region

.preheader7.lr.ph:                                ; preds = %.preheader8.split
  %27 = add i32 %n, -2
  %28 = zext i32 %27 to i64
  %29 = sitofp i32 %n to double
  br label %.preheader7

.preheader7:                                      ; preds = %.preheader7.lr.ph, %polly.merge295
  %indvar69 = phi i64 [ 0, %.preheader7.lr.ph ], [ %38, %polly.merge295 ]
  %30 = mul i64 %indvar69, 16000
  %31 = mul i64 %indvar69, -1
  %32 = add i64 %28, %31
  %33 = trunc i64 %32 to i32
  %34 = zext i32 %33 to i64
  %35 = mul i64 %indvar69, 16008
  %i.128 = trunc i64 %indvar69 to i32
  %36 = mul i64 %indvar69, 2001
  %37 = add i64 %36, 1
  %38 = add i64 %indvar69, 1
  %j.124 = trunc i64 %38 to i32
  %scevgep80 = getelementptr [2000 x double]* %A, i64 0, i64 %36
  %39 = add i64 %34, 1
  %40 = icmp slt i32 %i.128, 0
  br i1 %40, label %.preheader6, label %polly.cond314

.preheader6:                                      ; preds = %polly.then319, %polly.loop_header321, %polly.cond314, %.preheader7
  %41 = icmp slt i32 %j.124, %n
  br i1 %41, label %polly.cond294, label %polly.merge295

polly.merge295:                                   ; preds = %polly.then299, %polly.loop_header301, %polly.cond294, %.preheader6
  store double 1.000000e+00, double* %scevgep80, align 8, !tbaa !6, !alias.scope !8
  %exitcond77 = icmp ne i64 %38, %0
  br i1 %exitcond77, label %.preheader7, label %.region

.region:                                          ; preds = %.preheader8.split, %polly.merge295
  %42 = tail call i8* @polybench_alloc_data(i64 4000000, i32 8) #3
  %43 = ptrtoint i8* %42 to i64
  br i1 %26, label %.preheader5.lr.ph, label %.preheader4

.preheader5.lr.ph:                                ; preds = %.region
  %44 = sext i32 %n to i64
  %45 = icmp sge i64 %44, 1
  %46 = icmp sge i64 %0, 1
  %47 = and i1 %45, %46
  br i1 %47, label %polly.then206, label %.preheader4

.preheader4:                                      ; preds = %polly.then206, %polly.loop_exit219, %.preheader5.lr.ph, %.region
  %48 = add i64 %A95, %2
  %49 = mul i64 16000, %1
  %50 = add i64 %48, %49
  %umax97 = inttoptr i64 %50 to i8*
  %51 = add i64 %43, %49
  %52 = add i64 %51, %2
  %53 = inttoptr i64 %52 to i8*
  %54 = icmp ult i8* %umax97, %42
  %55 = icmp ult i8* %53, %A100
  %pair-no-alias98 = or i1 %54, %55
  br i1 %pair-no-alias98, label %polly.start143, label %.preheader4.split.clone

.preheader4.split.clone:                          ; preds = %.preheader4
  br i1 %26, label %.preheader3.lr.ph.clone, label %.preheader1

.preheader3.lr.ph.clone:                          ; preds = %.preheader4.split.clone
  br label %.preheader3.clone

.preheader3.clone:                                ; preds = %._crit_edge16.clone, %.preheader3.lr.ph.clone
  %indvar44.clone = phi i64 [ 0, %.preheader3.lr.ph.clone ], [ %indvar.next45.clone, %._crit_edge16.clone ]
  br i1 %26, label %.preheader2.clone, label %._crit_edge16.clone

.preheader2.clone:                                ; preds = %.preheader3.clone, %._crit_edge14.clone
  %indvar46.clone = phi i64 [ %indvar.next47.clone, %._crit_edge14.clone ], [ 0, %.preheader3.clone ]
  %scevgep53.clone = getelementptr [2000 x double]* %A, i64 %indvar46.clone, i64 %indvar44.clone
  %56 = mul i64 %indvar46.clone, 16000
  br i1 %26, label %.lr.ph13.clone, label %._crit_edge14.clone

.lr.ph13.clone:                                   ; preds = %.preheader2.clone, %.lr.ph13.clone
  %indvar41.clone = phi i64 [ %indvar.next42.clone, %.lr.ph13.clone ], [ 0, %.preheader2.clone ]
  %scevgep.clone = getelementptr [2000 x double]* %A, i64 %indvar41.clone, i64 %indvar44.clone
  %57 = mul i64 %indvar41.clone, 8
  %58 = add i64 %56, %57
  %scevgep51.clone = getelementptr i8* %42, i64 %58
  %scevgep4849.clone = bitcast i8* %scevgep51.clone to double*
  %59 = load double* %scevgep53.clone, align 8, !tbaa !6
  %60 = load double* %scevgep.clone, align 8, !tbaa !6
  %61 = fmul double %59, %60
  %62 = load double* %scevgep4849.clone, align 8, !tbaa !6
  %63 = fadd double %62, %61
  store double %63, double* %scevgep4849.clone, align 8, !tbaa !6
  %indvar.next42.clone = add i64 %indvar41.clone, 1
  %exitcond43.clone = icmp ne i64 %indvar.next42.clone, %0
  br i1 %exitcond43.clone, label %.lr.ph13.clone, label %._crit_edge14.clone

._crit_edge14.clone:                              ; preds = %.lr.ph13.clone, %.preheader2.clone
  %indvar.next47.clone = add i64 %indvar46.clone, 1
  %exitcond50.clone = icmp ne i64 %indvar.next47.clone, %0
  br i1 %exitcond50.clone, label %.preheader2.clone, label %._crit_edge16.clone

._crit_edge16.clone:                              ; preds = %._crit_edge14.clone, %.preheader3.clone
  %indvar.next45.clone = add i64 %indvar44.clone, 1
  %exitcond54.clone = icmp ne i64 %indvar.next45.clone, %0
  br i1 %exitcond54.clone, label %.preheader3.clone, label %.preheader1

.preheader1:                                      ; preds = %polly.then147, %polly.loop_exit160, %polly.start143, %.preheader4.split.clone, %._crit_edge16.clone
  %64 = add i64 %A95, %49
  %65 = add i64 %64, %2
  %66 = inttoptr i64 %65 to i8*
  %67 = icmp ult i8* %66, %42
  %pair-no-alias101 = or i1 %67, %55
  br i1 %pair-no-alias101, label %polly.start, label %.preheader1.split.clone

.preheader1.split.clone:                          ; preds = %.preheader1
  br i1 %26, label %.preheader.lr.ph.clone, label %.region99.clone

.preheader.lr.ph.clone:                           ; preds = %.preheader1.split.clone
  br label %.preheader.clone

.preheader.clone:                                 ; preds = %._crit_edge.clone, %.preheader.lr.ph.clone
  %indvar33.clone = phi i64 [ 0, %.preheader.lr.ph.clone ], [ %indvar.next34.clone, %._crit_edge.clone ]
  %68 = mul i64 %indvar33.clone, 16000
  br i1 %26, label %.lr.ph.clone, label %._crit_edge.clone

.lr.ph.clone:                                     ; preds = %.preheader.clone, %.lr.ph.clone
  %indvar.clone = phi i64 [ %indvar.next.clone, %.lr.ph.clone ], [ 0, %.preheader.clone ]
  %scevgep36.clone = getelementptr [2000 x double]* %A, i64 %indvar33.clone, i64 %indvar.clone
  %69 = mul i64 %indvar.clone, 8
  %70 = add i64 %68, %69
  %scevgep39.clone = getelementptr i8* %42, i64 %70
  %scevgep35.clone = bitcast i8* %scevgep39.clone to double*
  %71 = load double* %scevgep35.clone, align 8, !tbaa !6
  store double %71, double* %scevgep36.clone, align 8, !tbaa !6
  %indvar.next.clone = add i64 %indvar.clone, 1
  %exitcond.clone = icmp ne i64 %indvar.next.clone, %0
  br i1 %exitcond.clone, label %.lr.ph.clone, label %._crit_edge.clone

._crit_edge.clone:                                ; preds = %.lr.ph.clone, %.preheader.clone
  %indvar.next34.clone = add i64 %indvar33.clone, 1
  %exitcond37.clone = icmp ne i64 %indvar.next34.clone, %0
  br i1 %exitcond37.clone, label %.preheader.clone, label %.region99.clone

.region99.clone:                                  ; preds = %polly.then, %polly.loop_exit117, %polly.start, %.preheader1.split.clone, %._crit_edge.clone
  tail call void @free(i8* %42) #3
  ret void

polly.start:                                      ; preds = %.preheader1
  %72 = sext i32 %n to i64
  %73 = icmp sge i64 %72, 1
  %74 = icmp sge i64 %0, 1
  %75 = and i1 %73, %74
  br i1 %75, label %polly.then, label %.region99.clone

polly.then:                                       ; preds = %polly.start
  %polly.loop_guard = icmp sle i64 0, %1
  br i1 %polly.loop_guard, label %polly.loop_header, label %.region99.clone

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit117
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit117 ], [ 0, %polly.then ]
  %76 = mul i64 -11, %0
  %77 = add i64 %76, 5
  %78 = sub i64 %77, 32
  %79 = add i64 %78, 1
  %80 = icmp slt i64 %77, 0
  %81 = select i1 %80, i64 %79, i64 %77
  %82 = sdiv i64 %81, 32
  %83 = mul i64 -32, %82
  %84 = mul i64 -32, %0
  %85 = add i64 %83, %84
  %86 = mul i64 -32, %polly.indvar
  %87 = mul i64 -3, %polly.indvar
  %88 = add i64 %87, %0
  %89 = add i64 %88, 5
  %90 = sub i64 %89, 32
  %91 = add i64 %90, 1
  %92 = icmp slt i64 %89, 0
  %93 = select i1 %92, i64 %91, i64 %89
  %94 = sdiv i64 %93, 32
  %95 = mul i64 -32, %94
  %96 = add i64 %86, %95
  %97 = add i64 %96, -640
  %98 = icmp sgt i64 %85, %97
  %99 = select i1 %98, i64 %85, i64 %97
  %100 = mul i64 -20, %polly.indvar
  %polly.loop_guard118 = icmp sle i64 %99, %100
  br i1 %polly.loop_guard118, label %polly.loop_header115, label %polly.loop_exit117

polly.loop_exit117:                               ; preds = %polly.loop_exit126, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %1, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %.region99.clone

polly.loop_header115:                             ; preds = %polly.loop_header, %polly.loop_exit126
  %polly.indvar119 = phi i64 [ %polly.indvar_next120, %polly.loop_exit126 ], [ %99, %polly.loop_header ]
  %101 = mul i64 -1, %polly.indvar119
  %102 = mul i64 -1, %0
  %103 = add i64 %101, %102
  %104 = add i64 %103, -30
  %105 = add i64 %104, 20
  %106 = sub i64 %105, 1
  %107 = icmp slt i64 %104, 0
  %108 = select i1 %107, i64 %104, i64 %106
  %109 = sdiv i64 %108, 20
  %110 = icmp sgt i64 %109, %polly.indvar
  %111 = select i1 %110, i64 %109, i64 %polly.indvar
  %112 = sub i64 %101, 20
  %113 = add i64 %112, 1
  %114 = icmp slt i64 %101, 0
  %115 = select i1 %114, i64 %113, i64 %101
  %116 = sdiv i64 %115, 20
  %117 = add i64 %polly.indvar, 31
  %118 = icmp slt i64 %116, %117
  %119 = select i1 %118, i64 %116, i64 %117
  %120 = icmp slt i64 %119, %1
  %121 = select i1 %120, i64 %119, i64 %1
  %polly.loop_guard127 = icmp sle i64 %111, %121
  br i1 %polly.loop_guard127, label %polly.loop_header124, label %polly.loop_exit126

polly.loop_exit126:                               ; preds = %polly.loop_exit135, %polly.loop_header115
  %polly.indvar_next120 = add nsw i64 %polly.indvar119, 32
  %polly.adjust_ub121 = sub i64 %100, 32
  %polly.loop_cond122 = icmp sle i64 %polly.indvar119, %polly.adjust_ub121
  br i1 %polly.loop_cond122, label %polly.loop_header115, label %polly.loop_exit117

polly.loop_header124:                             ; preds = %polly.loop_header115, %polly.loop_exit135
  %polly.indvar128 = phi i64 [ %polly.indvar_next129, %polly.loop_exit135 ], [ %111, %polly.loop_header115 ]
  %122 = mul i64 -20, %polly.indvar128
  %123 = add i64 %122, %102
  %124 = add i64 %123, 1
  %125 = icmp sgt i64 %polly.indvar119, %124
  %126 = select i1 %125, i64 %polly.indvar119, i64 %124
  %127 = add i64 %polly.indvar119, 31
  %128 = icmp slt i64 %122, %127
  %129 = select i1 %128, i64 %122, i64 %127
  %polly.loop_guard136 = icmp sle i64 %126, %129
  br i1 %polly.loop_guard136, label %polly.loop_header133, label %polly.loop_exit135

polly.loop_exit135:                               ; preds = %polly.loop_header133, %polly.loop_header124
  %polly.indvar_next129 = add nsw i64 %polly.indvar128, 1
  %polly.adjust_ub130 = sub i64 %121, 1
  %polly.loop_cond131 = icmp sle i64 %polly.indvar128, %polly.adjust_ub130
  br i1 %polly.loop_cond131, label %polly.loop_header124, label %polly.loop_exit126

polly.loop_header133:                             ; preds = %polly.loop_header124, %polly.loop_header133
  %polly.indvar137 = phi i64 [ %polly.indvar_next138, %polly.loop_header133 ], [ %126, %polly.loop_header124 ]
  %130 = mul i64 -1, %polly.indvar137
  %131 = add i64 %122, %130
  %p_.moved.to.111 = mul i64 %polly.indvar128, 16000
  %p_scevgep36 = getelementptr [2000 x double]* %A, i64 %polly.indvar128, i64 %131
  %p_ = mul i64 %131, 8
  %p_141 = add i64 %p_.moved.to.111, %p_
  %p_scevgep39 = getelementptr i8* %42, i64 %p_141
  %p_scevgep35 = bitcast i8* %p_scevgep39 to double*
  %_p_scalar_ = load double* %p_scevgep35
  store double %_p_scalar_, double* %p_scevgep36
  %p_indvar.next = add i64 %131, 1
  %polly.indvar_next138 = add nsw i64 %polly.indvar137, 1
  %polly.adjust_ub139 = sub i64 %129, 1
  %polly.loop_cond140 = icmp sle i64 %polly.indvar137, %polly.adjust_ub139
  br i1 %polly.loop_cond140, label %polly.loop_header133, label %polly.loop_exit135

polly.start143:                                   ; preds = %.preheader4
  %132 = sext i32 %n to i64
  %133 = icmp sge i64 %132, 1
  %134 = icmp sge i64 %0, 1
  %135 = and i1 %133, %134
  br i1 %135, label %polly.then147, label %.preheader1

polly.then147:                                    ; preds = %polly.start143
  %polly.loop_guard152 = icmp sle i64 0, %1
  br i1 %polly.loop_guard152, label %polly.loop_header149, label %.preheader1

polly.loop_header149:                             ; preds = %polly.then147, %polly.loop_exit160
  %polly.indvar153 = phi i64 [ %polly.indvar_next154, %polly.loop_exit160 ], [ 0, %polly.then147 ]
  br i1 %polly.loop_guard152, label %polly.loop_header158, label %polly.loop_exit160

polly.loop_exit160:                               ; preds = %polly.loop_exit169, %polly.loop_header149
  %polly.indvar_next154 = add nsw i64 %polly.indvar153, 1
  %polly.adjust_ub155 = sub i64 %1, 1
  %polly.loop_cond156 = icmp sle i64 %polly.indvar153, %polly.adjust_ub155
  br i1 %polly.loop_cond156, label %polly.loop_header149, label %.preheader1

polly.loop_header158:                             ; preds = %polly.loop_header149, %polly.loop_exit169
  %polly.indvar162 = phi i64 [ %polly.indvar_next163, %polly.loop_exit169 ], [ 0, %polly.loop_header149 ]
  %136 = mul i64 -11, %0
  %137 = add i64 %136, 5
  %138 = sub i64 %137, 32
  %139 = add i64 %138, 1
  %140 = icmp slt i64 %137, 0
  %141 = select i1 %140, i64 %139, i64 %137
  %142 = sdiv i64 %141, 32
  %143 = mul i64 -32, %142
  %144 = mul i64 -32, %0
  %145 = add i64 %143, %144
  %146 = mul i64 -32, %polly.indvar162
  %147 = mul i64 -3, %polly.indvar162
  %148 = add i64 %147, %0
  %149 = add i64 %148, 5
  %150 = sub i64 %149, 32
  %151 = add i64 %150, 1
  %152 = icmp slt i64 %149, 0
  %153 = select i1 %152, i64 %151, i64 %149
  %154 = sdiv i64 %153, 32
  %155 = mul i64 -32, %154
  %156 = add i64 %146, %155
  %157 = add i64 %156, -640
  %158 = icmp sgt i64 %145, %157
  %159 = select i1 %158, i64 %145, i64 %157
  %160 = mul i64 -20, %polly.indvar162
  %polly.loop_guard170 = icmp sle i64 %159, %160
  br i1 %polly.loop_guard170, label %polly.loop_header167, label %polly.loop_exit169

polly.loop_exit169:                               ; preds = %polly.loop_exit178, %polly.loop_header158
  %polly.indvar_next163 = add nsw i64 %polly.indvar162, 32
  %polly.adjust_ub164 = sub i64 %1, 32
  %polly.loop_cond165 = icmp sle i64 %polly.indvar162, %polly.adjust_ub164
  br i1 %polly.loop_cond165, label %polly.loop_header158, label %polly.loop_exit160

polly.loop_header167:                             ; preds = %polly.loop_header158, %polly.loop_exit178
  %polly.indvar171 = phi i64 [ %polly.indvar_next172, %polly.loop_exit178 ], [ %159, %polly.loop_header158 ]
  %161 = mul i64 -1, %polly.indvar171
  %162 = mul i64 -1, %0
  %163 = add i64 %161, %162
  %164 = add i64 %163, -30
  %165 = add i64 %164, 20
  %166 = sub i64 %165, 1
  %167 = icmp slt i64 %164, 0
  %168 = select i1 %167, i64 %164, i64 %166
  %169 = sdiv i64 %168, 20
  %170 = icmp sgt i64 %169, %polly.indvar162
  %171 = select i1 %170, i64 %169, i64 %polly.indvar162
  %172 = sub i64 %161, 20
  %173 = add i64 %172, 1
  %174 = icmp slt i64 %161, 0
  %175 = select i1 %174, i64 %173, i64 %161
  %176 = sdiv i64 %175, 20
  %177 = add i64 %polly.indvar162, 31
  %178 = icmp slt i64 %176, %177
  %179 = select i1 %178, i64 %176, i64 %177
  %180 = icmp slt i64 %179, %1
  %181 = select i1 %180, i64 %179, i64 %1
  %polly.loop_guard179 = icmp sle i64 %171, %181
  br i1 %polly.loop_guard179, label %polly.loop_header176, label %polly.loop_exit178

polly.loop_exit178:                               ; preds = %polly.loop_exit187, %polly.loop_header167
  %polly.indvar_next172 = add nsw i64 %polly.indvar171, 32
  %polly.adjust_ub173 = sub i64 %160, 32
  %polly.loop_cond174 = icmp sle i64 %polly.indvar171, %polly.adjust_ub173
  br i1 %polly.loop_cond174, label %polly.loop_header167, label %polly.loop_exit169

polly.loop_header176:                             ; preds = %polly.loop_header167, %polly.loop_exit187
  %polly.indvar180 = phi i64 [ %polly.indvar_next181, %polly.loop_exit187 ], [ %171, %polly.loop_header167 ]
  %182 = mul i64 -20, %polly.indvar180
  %183 = add i64 %182, %162
  %184 = add i64 %183, 1
  %185 = icmp sgt i64 %polly.indvar171, %184
  %186 = select i1 %185, i64 %polly.indvar171, i64 %184
  %187 = add i64 %polly.indvar171, 31
  %188 = icmp slt i64 %182, %187
  %189 = select i1 %188, i64 %182, i64 %187
  %polly.loop_guard188 = icmp sle i64 %186, %189
  br i1 %polly.loop_guard188, label %polly.loop_header185, label %polly.loop_exit187

polly.loop_exit187:                               ; preds = %polly.loop_header185, %polly.loop_header176
  %polly.indvar_next181 = add nsw i64 %polly.indvar180, 1
  %polly.adjust_ub182 = sub i64 %181, 1
  %polly.loop_cond183 = icmp sle i64 %polly.indvar180, %polly.adjust_ub182
  br i1 %polly.loop_cond183, label %polly.loop_header176, label %polly.loop_exit178

polly.loop_header185:                             ; preds = %polly.loop_header176, %polly.loop_header185
  %polly.indvar189 = phi i64 [ %polly.indvar_next190, %polly.loop_header185 ], [ %186, %polly.loop_header176 ]
  %190 = mul i64 -1, %polly.indvar189
  %191 = add i64 %182, %190
  %p_scevgep53.moved.to. = getelementptr [2000 x double]* %A, i64 %polly.indvar180, i64 %polly.indvar153
  %p_.moved.to.106 = mul i64 %polly.indvar180, 16000
  %p_scevgep = getelementptr [2000 x double]* %A, i64 %191, i64 %polly.indvar153
  %p_194 = mul i64 %191, 8
  %p_195 = add i64 %p_.moved.to.106, %p_194
  %p_scevgep51 = getelementptr i8* %42, i64 %p_195
  %p_scevgep4849 = bitcast i8* %p_scevgep51 to double*
  %_p_scalar_196 = load double* %p_scevgep53.moved.to.
  %_p_scalar_197 = load double* %p_scevgep
  %p_198 = fmul double %_p_scalar_196, %_p_scalar_197
  %_p_scalar_199 = load double* %p_scevgep4849
  %p_200 = fadd double %_p_scalar_199, %p_198
  store double %p_200, double* %p_scevgep4849
  %p_indvar.next42 = add i64 %191, 1
  %polly.indvar_next190 = add nsw i64 %polly.indvar189, 1
  %polly.adjust_ub191 = sub i64 %189, 1
  %polly.loop_cond192 = icmp sle i64 %polly.indvar189, %polly.adjust_ub191
  br i1 %polly.loop_cond192, label %polly.loop_header185, label %polly.loop_exit187

polly.then206:                                    ; preds = %.preheader5.lr.ph
  %polly.loop_guard211 = icmp sle i64 0, %1
  br i1 %polly.loop_guard211, label %polly.loop_header208, label %.preheader4

polly.loop_header208:                             ; preds = %polly.then206, %polly.loop_exit219
  %polly.indvar212 = phi i64 [ %polly.indvar_next213, %polly.loop_exit219 ], [ 0, %polly.then206 ]
  %192 = mul i64 -11, %0
  %193 = add i64 %192, 5
  %194 = sub i64 %193, 32
  %195 = add i64 %194, 1
  %196 = icmp slt i64 %193, 0
  %197 = select i1 %196, i64 %195, i64 %193
  %198 = sdiv i64 %197, 32
  %199 = mul i64 -32, %198
  %200 = mul i64 -32, %0
  %201 = add i64 %199, %200
  %202 = mul i64 -32, %polly.indvar212
  %203 = mul i64 -3, %polly.indvar212
  %204 = add i64 %203, %0
  %205 = add i64 %204, 5
  %206 = sub i64 %205, 32
  %207 = add i64 %206, 1
  %208 = icmp slt i64 %205, 0
  %209 = select i1 %208, i64 %207, i64 %205
  %210 = sdiv i64 %209, 32
  %211 = mul i64 -32, %210
  %212 = add i64 %202, %211
  %213 = add i64 %212, -640
  %214 = icmp sgt i64 %201, %213
  %215 = select i1 %214, i64 %201, i64 %213
  %216 = mul i64 -20, %polly.indvar212
  %polly.loop_guard220 = icmp sle i64 %215, %216
  br i1 %polly.loop_guard220, label %polly.loop_header217, label %polly.loop_exit219

polly.loop_exit219:                               ; preds = %polly.loop_exit228, %polly.loop_header208
  %polly.indvar_next213 = add nsw i64 %polly.indvar212, 32
  %polly.adjust_ub214 = sub i64 %1, 32
  %polly.loop_cond215 = icmp sle i64 %polly.indvar212, %polly.adjust_ub214
  br i1 %polly.loop_cond215, label %polly.loop_header208, label %.preheader4

polly.loop_header217:                             ; preds = %polly.loop_header208, %polly.loop_exit228
  %polly.indvar221 = phi i64 [ %polly.indvar_next222, %polly.loop_exit228 ], [ %215, %polly.loop_header208 ]
  %217 = mul i64 -1, %polly.indvar221
  %218 = mul i64 -1, %0
  %219 = add i64 %217, %218
  %220 = add i64 %219, -30
  %221 = add i64 %220, 20
  %222 = sub i64 %221, 1
  %223 = icmp slt i64 %220, 0
  %224 = select i1 %223, i64 %220, i64 %222
  %225 = sdiv i64 %224, 20
  %226 = icmp sgt i64 %225, %polly.indvar212
  %227 = select i1 %226, i64 %225, i64 %polly.indvar212
  %228 = sub i64 %217, 20
  %229 = add i64 %228, 1
  %230 = icmp slt i64 %217, 0
  %231 = select i1 %230, i64 %229, i64 %217
  %232 = sdiv i64 %231, 20
  %233 = add i64 %polly.indvar212, 31
  %234 = icmp slt i64 %232, %233
  %235 = select i1 %234, i64 %232, i64 %233
  %236 = icmp slt i64 %235, %1
  %237 = select i1 %236, i64 %235, i64 %1
  %polly.loop_guard229 = icmp sle i64 %227, %237
  br i1 %polly.loop_guard229, label %polly.loop_header226, label %polly.loop_exit228

polly.loop_exit228:                               ; preds = %polly.loop_exit237, %polly.loop_header217
  %polly.indvar_next222 = add nsw i64 %polly.indvar221, 32
  %polly.adjust_ub223 = sub i64 %216, 32
  %polly.loop_cond224 = icmp sle i64 %polly.indvar221, %polly.adjust_ub223
  br i1 %polly.loop_cond224, label %polly.loop_header217, label %polly.loop_exit219

polly.loop_header226:                             ; preds = %polly.loop_header217, %polly.loop_exit237
  %polly.indvar230 = phi i64 [ %polly.indvar_next231, %polly.loop_exit237 ], [ %227, %polly.loop_header217 ]
  %238 = mul i64 -20, %polly.indvar230
  %239 = add i64 %238, %218
  %240 = add i64 %239, 1
  %241 = icmp sgt i64 %polly.indvar221, %240
  %242 = select i1 %241, i64 %polly.indvar221, i64 %240
  %243 = add i64 %polly.indvar221, 31
  %244 = icmp slt i64 %238, %243
  %245 = select i1 %244, i64 %238, i64 %243
  %polly.loop_guard238 = icmp sle i64 %242, %245
  br i1 %polly.loop_guard238, label %polly.loop_header235, label %polly.loop_exit237

polly.loop_exit237:                               ; preds = %polly.loop_header235, %polly.loop_header226
  %polly.indvar_next231 = add nsw i64 %polly.indvar230, 1
  %polly.adjust_ub232 = sub i64 %237, 1
  %polly.loop_cond233 = icmp sle i64 %polly.indvar230, %polly.adjust_ub232
  br i1 %polly.loop_cond233, label %polly.loop_header226, label %polly.loop_exit228

polly.loop_header235:                             ; preds = %polly.loop_header226, %polly.loop_header235
  %polly.indvar239 = phi i64 [ %polly.indvar_next240, %polly.loop_header235 ], [ %242, %polly.loop_header226 ]
  %246 = mul i64 -1, %polly.indvar239
  %247 = add i64 %238, %246
  %p_.moved.to. = mul i64 %polly.indvar230, 16000
  %p_244 = mul i64 %247, 8
  %p_245 = add i64 %p_.moved.to., %p_244
  %p_scevgep65 = getelementptr i8* %42, i64 %p_245
  %p_scevgep6263 = bitcast i8* %p_scevgep65 to double*
  store double 0.000000e+00, double* %p_scevgep6263
  %p_indvar.next58 = add i64 %247, 1
  %polly.indvar_next240 = add nsw i64 %polly.indvar239, 1
  %polly.adjust_ub241 = sub i64 %245, 1
  %polly.loop_cond242 = icmp sle i64 %polly.indvar239, %polly.adjust_ub241
  br i1 %polly.loop_cond242, label %polly.loop_header235, label %polly.loop_exit237

polly.cond294:                                    ; preds = %.preheader6
  %248 = srem i64 %35, 8
  %249 = icmp eq i64 %248, 0
  br i1 %249, label %polly.then299, label %polly.merge295

polly.then299:                                    ; preds = %polly.cond294
  br i1 true, label %polly.loop_header301, label %polly.merge295

polly.loop_header301:                             ; preds = %polly.then299, %polly.loop_header301
  %polly.indvar305 = phi i64 [ %polly.indvar_next306, %polly.loop_header301 ], [ 0, %polly.then299 ]
  %p_310 = add i64 %37, %polly.indvar305
  %p_scevgep76 = getelementptr [2000 x double]* %A, i64 0, i64 %p_310
  store double 0.000000e+00, double* %p_scevgep76
  %p_indvar.next74 = add i64 %polly.indvar305, 1
  %polly.indvar_next306 = add nsw i64 %polly.indvar305, 1
  %polly.adjust_ub307 = sub i64 %34, 1
  %polly.loop_cond308 = icmp sle i64 %polly.indvar305, %polly.adjust_ub307
  br i1 %polly.loop_cond308, label %polly.loop_header301, label %polly.merge295

polly.cond314:                                    ; preds = %.preheader7
  %250 = srem i64 %30, 8
  %251 = icmp eq i64 %250, 0
  %252 = icmp sge i64 %indvar69, 0
  %or.cond360 = and i1 %251, %252
  br i1 %or.cond360, label %polly.then319, label %.preheader6

polly.then319:                                    ; preds = %polly.cond314
  br i1 %252, label %polly.loop_header321, label %.preheader6

polly.loop_header321:                             ; preds = %polly.then319, %polly.loop_header321
  %polly.indvar325 = phi i64 [ %polly.indvar_next326, %polly.loop_header321 ], [ 0, %polly.then319 ]
  %p_scevgep72 = getelementptr [2000 x double]* %A, i64 %indvar69, i64 %polly.indvar325
  %p_330 = mul i64 %polly.indvar325, -1
  %p_331 = trunc i64 %p_330 to i32
  %p_332 = srem i32 %p_331, %n
  %p_333 = sitofp i32 %p_332 to double
  %p_334 = fdiv double %p_333, %29
  %p_335 = fadd double %p_334, 1.000000e+00
  store double %p_335, double* %p_scevgep72
  %p_indvar.next68 = add i64 %polly.indvar325, 1
  %polly.indvar_next326 = add nsw i64 %polly.indvar325, 1
  %polly.adjust_ub327 = sub i64 %indvar69, 1
  %polly.loop_cond328 = icmp sle i64 %polly.indvar325, %polly.adjust_ub327
  br i1 %polly.loop_cond328, label %polly.loop_header321, label %.preheader6

polly.start337:                                   ; preds = %.split
  %253 = sext i32 %n to i64
  %254 = icmp sge i64 %253, 1
  %255 = icmp sge i64 %0, 1
  %256 = and i1 %254, %255
  br i1 %256, label %polly.then341, label %.preheader8.split

polly.then341:                                    ; preds = %polly.start337
  %polly.loop_guard346 = icmp sle i64 0, %1
  br i1 %polly.loop_guard346, label %polly.loop_header343, label %.preheader8.split

polly.loop_header343:                             ; preds = %polly.then341, %polly.loop_header343
  %polly.indvar347 = phi i64 [ %polly.indvar_next348, %polly.loop_header343 ], [ 0, %polly.then341 ]
  %p_.moved.to.103 = sitofp i32 %n to double
  %p_scevgep84 = getelementptr double* %x, i64 %polly.indvar347
  %p_scevgep85 = getelementptr double* %y, i64 %polly.indvar347
  %p_352 = add i64 %polly.indvar347, 1
  %p_353 = trunc i64 %p_352 to i32
  %p_scevgep86 = getelementptr double* %b, i64 %polly.indvar347
  store double 0.000000e+00, double* %p_scevgep84
  store double 0.000000e+00, double* %p_scevgep85
  %p_354 = sitofp i32 %p_353 to double
  %p_355 = fdiv double %p_354, %p_.moved.to.103
  %p_356 = fmul double %p_355, 5.000000e-01
  %p_357 = fadd double %p_356, 4.000000e+00
  store double %p_357, double* %p_scevgep86
  %polly.indvar_next348 = add nsw i64 %polly.indvar347, 1
  %polly.adjust_ub349 = sub i64 %1, 1
  %polly.loop_cond350 = icmp sle i64 %polly.indvar347, %polly.adjust_ub349
  br i1 %polly.loop_cond350, label %polly.loop_header343, label %.preheader8.split
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_ludcmp(i32 %n, [2000 x double]* %A, double* %b, double* %x, double* %y) #0 {
.split:
  %A97 = bitcast [2000 x double]* %A to i8*
  %b98 = bitcast double* %b to i8*
  %y99 = ptrtoint double* %y to i64
  %b96 = ptrtoint double* %b to i64
  %A95 = ptrtoint [2000 x double]* %A to i64
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.preheader3.lr.ph, label %.preheader1

.preheader3.lr.ph:                                ; preds = %.split
  %1 = add i32 %n, -1
  %2 = zext i32 %n to i64
  %3 = zext i32 %1 to i64
  br label %.preheader3

.preheader3:                                      ; preds = %.preheader3.lr.ph, %polly.merge436
  %4 = phi i64 [ 0, %.preheader3.lr.ph ], [ %indvar.next72, %polly.merge436 ]
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
  br i1 %or.cond, label %polly.stmt.622, label %.preheader2

.preheader1:                                      ; preds = %.split, %polly.merge436
  %15 = zext i32 %n to i64
  %16 = add i64 %15, -1
  %17 = mul i64 16000, %16
  %18 = add i64 %A95, %17
  %19 = add i64 -1, %16
  %20 = mul i64 8, %19
  %21 = add i64 %18, %20
  %22 = inttoptr i64 %21 to i8*
  %23 = mul i64 8, %16
  %24 = add i64 %b96, %23
  %25 = inttoptr i64 %24 to i8*
  %26 = icmp ult i8* %22, %b98
  %27 = icmp ult i8* %25, %A97
  %pair-no-alias = or i1 %26, %27
  %umin100 = bitcast double* %y to i8*
  %28 = add i64 %y99, %20
  %29 = add i64 %y99, %23
  %30 = icmp ugt i64 %29, %28
  %umax = select i1 %30, i64 %29, i64 %28
  %umax101 = inttoptr i64 %umax to i8*
  %31 = icmp ult i8* %22, %umin100
  %32 = icmp ult i8* %umax101, %A97
  %pair-no-alias102 = or i1 %31, %32
  %33 = and i1 %pair-no-alias, %pair-no-alias102
  %34 = icmp ult i8* %25, %umin100
  %35 = icmp ult i8* %umax101, %b98
  %pair-no-alias103 = or i1 %34, %35
  %36 = and i1 %33, %pair-no-alias103
  br i1 %36, label %polly.start154, label %.preheader1.split.clone

.preheader1.split.clone:                          ; preds = %.preheader1
  br i1 %0, label %.lr.ph21.clone, label %.preheader

.lr.ph21.clone:                                   ; preds = %.preheader1.split.clone
  br label %37

; <label>:37                                      ; preds = %46, %.lr.ph21.clone
  %38 = phi i64 [ 0, %.lr.ph21.clone ], [ %indvar.next58.clone, %46 ]
  %i.120.clone = trunc i64 %38 to i32
  %scevgep64.clone = getelementptr double* %b, i64 %38
  %scevgep65.clone = getelementptr double* %y, i64 %38
  %39 = load double* %scevgep64.clone, align 8, !tbaa !6
  %40 = icmp sgt i32 %i.120.clone, 0
  br i1 %40, label %.lr.ph16.clone, label %46

.lr.ph16.clone:                                   ; preds = %37
  br label %41

; <label>:41                                      ; preds = %41, %.lr.ph16.clone
  %w.214.reg2mem.0 = phi double [ %39, %.lr.ph16.clone ], [ %45, %41 ]
  %indvar55.clone = phi i64 [ 0, %.lr.ph16.clone ], [ %indvar.next56.clone, %41 ]
  %scevgep60.clone = getelementptr [2000 x double]* %A, i64 %38, i64 %indvar55.clone
  %scevgep61.clone = getelementptr double* %y, i64 %indvar55.clone
  %42 = load double* %scevgep60.clone, align 8, !tbaa !6
  %43 = load double* %scevgep61.clone, align 8, !tbaa !6
  %44 = fmul double %42, %43
  %45 = fsub double %w.214.reg2mem.0, %44
  %indvar.next56.clone = add i64 %indvar55.clone, 1
  %exitcond59.clone = icmp ne i64 %indvar.next56.clone, %38
  br i1 %exitcond59.clone, label %41, label %._crit_edge17.clone

._crit_edge17.clone:                              ; preds = %41
  br label %46

; <label>:46                                      ; preds = %._crit_edge17.clone, %37
  %w.2.lcssa.reg2mem.0 = phi double [ %45, %._crit_edge17.clone ], [ %39, %37 ]
  store double %w.2.lcssa.reg2mem.0, double* %scevgep65.clone, align 8, !tbaa !6
  %indvar.next58.clone = add i64 %38, 1
  %exitcond62.clone = icmp ne i64 %indvar.next58.clone, %15
  br i1 %exitcond62.clone, label %37, label %.preheader

.preheader2:                                      ; preds = %polly.stmt.622, %polly.loop_exit645, %.preheader3
  %47 = icmp slt i32 %5, %n
  br i1 %47, label %.lr.ph37, label %polly.merge436

.lr.ph37:                                         ; preds = %.preheader2
  br i1 true, label %polly.cond438, label %polly.merge436

polly.merge436:                                   ; preds = %polly.then601, %polly.loop_header603, %polly.cond599, %polly.cond596, %.lr.ph37, %.preheader2
  %indvar.next72 = add i64 %4, 1
  %exitcond89 = icmp ne i64 %indvar.next72, %2
  br i1 %exitcond89, label %.preheader3, label %.preheader1

.preheader:                                       ; preds = %polly.stmt.159, %polly.loop_exit180, %polly.start154, %.preheader1.split.clone, %46
  %48 = sext i32 %n to i64
  %49 = mul i64 2001, %48
  %scevgep104 = getelementptr [2000 x double]* %A, i64 -1, i64 %49
  %50 = add i64 %49, -1
  %scevgep105 = getelementptr [2000 x double]* %A, i64 -1, i64 %50
  %51 = icmp ult double* %scevgep105, %scevgep104
  %umin106 = select i1 %51, double* %scevgep105, double* %scevgep104
  %umin106120 = bitcast double* %umin106 to i8*
  %scevgep107108 = ptrtoint double* %scevgep104 to i64
  %52 = mul i64 -16008, %16
  %53 = add i64 %scevgep107108, %52
  %54 = add i32 %n, -1
  %55 = add i32 -1, %54
  %56 = zext i32 %55 to i64
  %57 = mul i64 8, %56
  %58 = add i64 %53, %57
  %scevgep109110 = ptrtoint double* %scevgep105 to i64
  %59 = add i64 %scevgep109110, %52
  %60 = icmp ugt i64 %59, %58
  %umax111 = select i1 %60, i64 %59, i64 %58
  %umax111121 = inttoptr i64 %umax111 to i8*
  %scevgep112 = getelementptr double* %x, i64 %48
  %61 = add i64 %48, -1
  %scevgep113 = getelementptr double* %x, i64 %61
  %62 = icmp ult double* %scevgep113, %scevgep112
  %umin114 = select i1 %62, double* %scevgep113, double* %scevgep112
  %umin114122 = bitcast double* %umin114 to i8*
  %scevgep115116 = ptrtoint double* %scevgep112 to i64
  %63 = mul i64 -8, %16
  %64 = add i64 %scevgep115116, %63
  %65 = add i64 %64, %57
  %scevgep117118 = ptrtoint double* %scevgep113 to i64
  %66 = add i64 %scevgep117118, %63
  %67 = icmp ugt i64 %66, %65
  %umax119 = select i1 %67, i64 %66, i64 %65
  %umax119123 = inttoptr i64 %umax119 to i8*
  %68 = icmp ult i8* %umax111121, %umin114122
  %69 = icmp ult i8* %umax119123, %umin106120
  %pair-no-alias124 = or i1 %68, %69
  %scevgep125 = getelementptr double* %y, i64 %61
  %scevgep125128 = bitcast double* %scevgep125 to i8*
  %scevgep126127 = ptrtoint double* %scevgep125 to i64
  %70 = add i64 %scevgep126127, %63
  %71 = inttoptr i64 %70 to i8*
  %72 = icmp ult i8* %umax111121, %scevgep125128
  %73 = icmp ult i8* %71, %umin106120
  %pair-no-alias129 = or i1 %72, %73
  %74 = and i1 %pair-no-alias124, %pair-no-alias129
  %75 = icmp ult i8* %umax119123, %scevgep125128
  %76 = icmp ult i8* %71, %umin114122
  %pair-no-alias130 = or i1 %75, %76
  %77 = and i1 %74, %pair-no-alias130
  br i1 %77, label %.preheader.split, label %.preheader.split.clone

.preheader.split.clone:                           ; preds = %.preheader
  br i1 %0, label %.lr.ph11.clone, label %.region.clone

.lr.ph11.clone:                                   ; preds = %.preheader.split.clone
  br label %78

; <label>:78                                      ; preds = %99, %.lr.ph11.clone
  %indvar46.clone = phi i64 [ 0, %.lr.ph11.clone ], [ %indvar.next47.clone, %99 ]
  %79 = mul i64 %indvar46.clone, -1
  %80 = add i64 %48, %79
  %81 = mul i64 %indvar46.clone, -2001
  %82 = add i64 %49, %81
  %83 = add i64 %indvar46.clone, -1
  %84 = trunc i64 %83 to i32
  %85 = add i64 %61, %79
  %scevgep52.clone = getelementptr double* %y, i64 %85
  %86 = add i64 %50, %81
  %scevgep53.clone = getelementptr [2000 x double]* %A, i64 -1, i64 %86
  %scevgep54.clone = getelementptr double* %x, i64 %85
  %87 = add i64 %15, %79
  %i.2.in9.clone = trunc i64 %87 to i32
  %88 = zext i32 %84 to i64
  %89 = add i64 %88, 1
  %90 = load double* %scevgep52.clone, align 8, !tbaa !6
  %91 = icmp slt i32 %i.2.in9.clone, %n
  br i1 %91, label %.lr.ph.clone, label %99

.lr.ph.clone:                                     ; preds = %78
  br label %92

; <label>:92                                      ; preds = %92, %.lr.ph.clone
  %w.36.reg2mem.0 = phi double [ %90, %.lr.ph.clone ], [ %98, %92 ]
  %indvar.clone = phi i64 [ 0, %.lr.ph.clone ], [ %indvar.next.clone, %92 ]
  %93 = add i64 %80, %indvar.clone
  %scevgep48.clone = getelementptr double* %x, i64 %93
  %94 = add i64 %82, %indvar.clone
  %scevgep.clone = getelementptr [2000 x double]* %A, i64 -1, i64 %94
  %95 = load double* %scevgep.clone, align 8, !tbaa !6
  %96 = load double* %scevgep48.clone, align 8, !tbaa !6
  %97 = fmul double %95, %96
  %98 = fsub double %w.36.reg2mem.0, %97
  %indvar.next.clone = add i64 %indvar.clone, 1
  %exitcond.clone = icmp ne i64 %indvar.next.clone, %89
  br i1 %exitcond.clone, label %92, label %._crit_edge.clone

._crit_edge.clone:                                ; preds = %92
  br label %99

; <label>:99                                      ; preds = %._crit_edge.clone, %78
  %w.3.lcssa.reg2mem.0 = phi double [ %98, %._crit_edge.clone ], [ %90, %78 ]
  %100 = load double* %scevgep53.clone, align 8, !tbaa !6
  %101 = fdiv double %w.3.lcssa.reg2mem.0, %100
  store double %101, double* %scevgep54.clone, align 8, !tbaa !6
  %indvar.next47.clone = add i64 %indvar46.clone, 1
  %exitcond49.clone = icmp ne i64 %indvar.next47.clone, %15
  br i1 %exitcond49.clone, label %78, label %.region.clone

.preheader.split:                                 ; preds = %.preheader
  br i1 %0, label %.lr.ph11, label %.region.clone

.lr.ph11:                                         ; preds = %.preheader.split
  br label %102

; <label>:102                                     ; preds = %.lr.ph11, %116
  %indvar46 = phi i64 [ 0, %.lr.ph11 ], [ %indvar.next47, %116 ]
  %103 = add i64 %indvar46, -1
  %104 = trunc i64 %103 to i32
  %105 = zext i32 %104 to i64
  %106 = mul i64 %indvar46, -1
  %107 = add i64 %48, %106
  %108 = mul i64 %indvar46, -2001
  %109 = add i64 %49, %108
  %110 = add i64 %61, %106
  %scevgep52 = getelementptr double* %y, i64 %110
  %111 = add i64 %50, %108
  %scevgep53 = getelementptr [2000 x double]* %A, i64 -1, i64 %111
  %scevgep54 = getelementptr double* %x, i64 %110
  %112 = add i64 %15, %106
  %i.2.in9 = trunc i64 %112 to i32
  %113 = add i64 %105, 1
  %114 = load double* %scevgep52, align 8, !tbaa !6, !alias.scope !11, !noalias !13
  %115 = icmp slt i32 %i.2.in9, %n
  br i1 %115, label %.lr.ph, label %116

.lr.ph:                                           ; preds = %102
  br i1 true, label %polly.then, label %polly.stmt.._crit_edge

; <label>:116                                     ; preds = %polly.stmt.._crit_edge, %102
  %w.3.lcssa.reg2mem.1 = phi double [ %w.36.reg2mem.1, %polly.stmt.._crit_edge ], [ %114, %102 ]
  %117 = load double* %scevgep53, align 8, !tbaa !6, !alias.scope !18, !noalias !19
  %118 = fdiv double %w.3.lcssa.reg2mem.1, %117
  store double %118, double* %scevgep54, align 8, !tbaa !6, !alias.scope !20, !noalias !21
  %indvar.next47 = add i64 %indvar46, 1
  %exitcond49 = icmp ne i64 %indvar.next47, %15
  br i1 %exitcond49, label %102, label %.region.clone

.region.clone:                                    ; preds = %.preheader.split, %116, %.preheader.split.clone, %99
  ret void

polly.stmt.._crit_edge:                           ; preds = %polly.then, %polly.loop_header, %.lr.ph
  %w.36.reg2mem.1 = phi double [ %p_151, %polly.loop_header ], [ %114, %polly.then ], [ %114, %.lr.ph ]
  br label %116

polly.then:                                       ; preds = %.lr.ph
  br i1 true, label %polly.loop_header, label %polly.stmt.._crit_edge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_header
  %w.36.reg2mem.2 = phi double [ %114, %polly.then ], [ %p_151, %polly.loop_header ]
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_header ], [ 0, %polly.then ]
  %p_ = add i64 %107, %polly.indvar
  %p_scevgep48 = getelementptr double* %x, i64 %p_
  %p_148 = add i64 %109, %polly.indvar
  %p_scevgep = getelementptr [2000 x double]* %A, i64 -1, i64 %p_148
  %_p_scalar_ = load double* %p_scevgep
  %_p_scalar_149 = load double* %p_scevgep48
  %p_150 = fmul double %_p_scalar_, %_p_scalar_149
  %p_151 = fsub double %w.36.reg2mem.2, %p_150
  %p_indvar.next = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.adjust_ub = sub i64 %105, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.stmt.._crit_edge

polly.start154:                                   ; preds = %.preheader1
  %119 = sext i32 %n to i64
  %120 = icmp sge i64 %119, 1
  %121 = icmp sge i64 %15, 1
  %122 = and i1 %120, %121
  br i1 %122, label %polly.stmt.159, label %.preheader

polly.stmt.159:                                   ; preds = %polly.start154
  %_p_scalar_160 = load double* %b
  store double %_p_scalar_160, double* %y
  %polly.loop_guard167 = icmp sle i64 1, %16
  br i1 %polly.loop_guard167, label %polly.loop_header164, label %.preheader

polly.loop_header164:                             ; preds = %polly.stmt.159, %polly.loop_exit180
  %polly.indvar168 = phi i64 [ %polly.indvar_next169, %polly.loop_exit180 ], [ 1, %polly.stmt.159 ]
  %p_i.120173 = trunc i64 %polly.indvar168 to i32
  %p_scevgep64174 = getelementptr double* %b, i64 %polly.indvar168
  %_p_scalar_175 = load double* %p_scevgep64174
  %123 = add i64 %polly.indvar168, -1
  %polly.loop_guard181 = icmp sle i64 0, %123
  br i1 %polly.loop_guard181, label %polly.loop_header178, label %polly.loop_exit180

polly.loop_exit180:                               ; preds = %polly.loop_header178, %polly.loop_header164
  %w.214.reg2mem.1 = phi double [ %p_190, %polly.loop_header178 ], [ %_p_scalar_175, %polly.loop_header164 ]
  %p_scevgep65.moved.to.193 = getelementptr double* %y, i64 %polly.indvar168
  store double %w.214.reg2mem.1, double* %p_scevgep65.moved.to.193
  %p_indvar.next58196 = add i64 %polly.indvar168, 1
  %polly.indvar_next169 = add nsw i64 %polly.indvar168, 1
  %polly.adjust_ub170 = sub i64 %16, 1
  %polly.loop_cond171 = icmp sle i64 %polly.indvar168, %polly.adjust_ub170
  br i1 %polly.loop_cond171, label %polly.loop_header164, label %.preheader

polly.loop_header178:                             ; preds = %polly.loop_header164, %polly.loop_header178
  %w.214.reg2mem.2 = phi double [ %_p_scalar_175, %polly.loop_header164 ], [ %p_190, %polly.loop_header178 ]
  %polly.indvar182 = phi i64 [ %polly.indvar_next183, %polly.loop_header178 ], [ 0, %polly.loop_header164 ]
  %p_scevgep60 = getelementptr [2000 x double]* %A, i64 %polly.indvar168, i64 %polly.indvar182
  %p_scevgep61 = getelementptr double* %y, i64 %polly.indvar182
  %_p_scalar_187 = load double* %p_scevgep60
  %_p_scalar_188 = load double* %p_scevgep61
  %p_189 = fmul double %_p_scalar_187, %_p_scalar_188
  %p_190 = fsub double %w.214.reg2mem.2, %p_189
  %p_indvar.next56 = add i64 %polly.indvar182, 1
  %polly.indvar_next183 = add nsw i64 %polly.indvar182, 1
  %polly.adjust_ub184 = sub i64 %123, 1
  %polly.loop_cond185 = icmp sle i64 %polly.indvar182, %polly.adjust_ub184
  br i1 %polly.loop_cond185, label %polly.loop_header178, label %polly.loop_exit180

polly.cond438:                                    ; preds = %.lr.ph37
  %124 = srem i64 %10, 8
  %125 = icmp eq i64 %124, 0
  br i1 %125, label %polly.cond441, label %polly.cond472

polly.cond472:                                    ; preds = %polly.then443, %polly.loop_exit459, %polly.cond441, %polly.cond438
  %126 = add i64 %10, 7
  %127 = srem i64 %126, 8
  %128 = icmp sle i64 %127, 6
  br i1 %128, label %polly.cond475, label %polly.cond516

polly.cond516:                                    ; preds = %polly.then477, %polly.loop_exit497, %polly.cond475, %polly.cond472
  br i1 %125, label %polly.cond519, label %polly.cond546

polly.cond546:                                    ; preds = %polly.then521, %polly.loop_header523, %polly.cond519, %polly.cond516
  br i1 %128, label %polly.cond549, label %polly.cond570

polly.cond570:                                    ; preds = %polly.then551, %polly.loop_header553, %polly.cond549, %polly.cond546
  br i1 %125, label %polly.cond573, label %polly.cond596

polly.cond596:                                    ; preds = %polly.then575, %polly.loop_header577, %polly.cond573, %polly.cond570
  br i1 %128, label %polly.cond599, label %polly.merge436

polly.cond441:                                    ; preds = %polly.cond438
  %129 = sext i32 %5 to i64
  %130 = icmp sge i64 %129, 1
  %131 = and i1 %130, %14
  br i1 %131, label %polly.then443, label %polly.cond472

polly.then443:                                    ; preds = %polly.cond441
  br i1 true, label %polly.loop_header445, label %polly.cond472

polly.loop_header445:                             ; preds = %polly.then443, %polly.loop_exit459
  %polly.indvar449 = phi i64 [ %polly.indvar_next450, %polly.loop_exit459 ], [ 0, %polly.then443 ]
  %p_454 = add i64 %11, %polly.indvar449
  %p_scevgep88 = getelementptr [2000 x double]* %A, i64 0, i64 %p_454
  %_p_scalar_455 = load double* %p_scevgep88
  %132 = add i64 %4, -1
  %polly.loop_guard460 = icmp sle i64 0, %132
  br i1 %polly.loop_guard460, label %polly.loop_header457, label %polly.loop_exit459

polly.loop_exit459:                               ; preds = %polly.loop_header457, %polly.loop_header445
  %w.131.reg2mem.0 = phi double [ %p_469, %polly.loop_header457 ], [ %_p_scalar_455, %polly.loop_header445 ]
  store double %w.131.reg2mem.0, double* %p_scevgep88
  %p_indvar.next84 = add i64 %polly.indvar449, 1
  %polly.indvar_next450 = add nsw i64 %polly.indvar449, 1
  %polly.adjust_ub451 = sub i64 %9, 1
  %polly.loop_cond452 = icmp sle i64 %polly.indvar449, %polly.adjust_ub451
  br i1 %polly.loop_cond452, label %polly.loop_header445, label %polly.cond472

polly.loop_header457:                             ; preds = %polly.loop_header445, %polly.loop_header457
  %w.131.reg2mem.1 = phi double [ %_p_scalar_455, %polly.loop_header445 ], [ %p_469, %polly.loop_header457 ]
  %polly.indvar461 = phi i64 [ %polly.indvar_next462, %polly.loop_header457 ], [ 0, %polly.loop_header445 ]
  %p_.moved.to.134 = add i64 %4, %polly.indvar449
  %p_scevgep85 = getelementptr [2000 x double]* %A, i64 %polly.indvar461, i64 %p_.moved.to.134
  %p_scevgep82 = getelementptr [2000 x double]* %A, i64 %4, i64 %polly.indvar461
  %_p_scalar_466 = load double* %p_scevgep82
  %_p_scalar_467 = load double* %p_scevgep85
  %p_468 = fmul double %_p_scalar_466, %_p_scalar_467
  %p_469 = fsub double %w.131.reg2mem.1, %p_468
  %p_indvar.next80 = add i64 %polly.indvar461, 1
  %polly.indvar_next462 = add nsw i64 %polly.indvar461, 1
  %polly.adjust_ub463 = sub i64 %132, 1
  %polly.loop_cond464 = icmp sle i64 %polly.indvar461, %polly.adjust_ub463
  br i1 %polly.loop_cond464, label %polly.loop_header457, label %polly.loop_exit459

polly.cond475:                                    ; preds = %polly.cond472
  %133 = sext i32 %5 to i64
  %134 = icmp sge i64 %133, 1
  %135 = and i1 %134, %14
  br i1 %135, label %polly.then477, label %polly.cond516

polly.then477:                                    ; preds = %polly.cond475
  br i1 true, label %polly.loop_header479, label %polly.cond516

polly.loop_header479:                             ; preds = %polly.then477, %polly.loop_exit497
  %polly.indvar483 = phi i64 [ %polly.indvar_next484, %polly.loop_exit497 ], [ 0, %polly.then477 ]
  %p_489 = add i64 %11, %polly.indvar483
  %p_scevgep88490 = getelementptr [2000 x double]* %A, i64 0, i64 %p_489
  %_p_scalar_491 = load double* %p_scevgep88490
  %136 = add i64 %4, -1
  %polly.loop_guard498 = icmp sle i64 0, %136
  br i1 %polly.loop_guard498, label %polly.loop_header495, label %polly.loop_exit497

polly.loop_exit497:                               ; preds = %polly.loop_header495, %polly.loop_header479
  %polly.indvar_next484 = add nsw i64 %polly.indvar483, 1
  %polly.adjust_ub485 = sub i64 %9, 1
  %polly.loop_cond486 = icmp sle i64 %polly.indvar483, %polly.adjust_ub485
  br i1 %polly.loop_cond486, label %polly.loop_header479, label %polly.cond516

polly.loop_header495:                             ; preds = %polly.loop_header479, %polly.loop_header495
  %w.131.reg2mem.3 = phi double [ %_p_scalar_491, %polly.loop_header479 ], [ %p_511, %polly.loop_header495 ]
  %polly.indvar499 = phi i64 [ %polly.indvar_next500, %polly.loop_header495 ], [ 0, %polly.loop_header479 ]
  %p_.moved.to.134504 = add i64 %4, %polly.indvar483
  %p_scevgep85506 = getelementptr [2000 x double]* %A, i64 %polly.indvar499, i64 %p_.moved.to.134504
  %p_scevgep82507 = getelementptr [2000 x double]* %A, i64 %4, i64 %polly.indvar499
  %_p_scalar_508 = load double* %p_scevgep82507
  %_p_scalar_509 = load double* %p_scevgep85506
  %p_510 = fmul double %_p_scalar_508, %_p_scalar_509
  %p_511 = fsub double %w.131.reg2mem.3, %p_510
  %p_indvar.next80512 = add i64 %polly.indvar499, 1
  %polly.indvar_next500 = add nsw i64 %polly.indvar499, 1
  %polly.adjust_ub501 = sub i64 %136, 1
  %polly.loop_cond502 = icmp sle i64 %polly.indvar499, %polly.adjust_ub501
  br i1 %polly.loop_cond502, label %polly.loop_header495, label %polly.loop_exit497

polly.cond519:                                    ; preds = %polly.cond516
  %137 = sext i32 %5 to i64
  %138 = icmp sge i64 %137, 1
  %139 = icmp sle i64 %4, 0
  %140 = and i1 %138, %139
  br i1 %140, label %polly.then521, label %polly.cond546

polly.then521:                                    ; preds = %polly.cond519
  br i1 true, label %polly.loop_header523, label %polly.cond546

polly.loop_header523:                             ; preds = %polly.then521, %polly.loop_header523
  %polly.indvar527 = phi i64 [ %polly.indvar_next528, %polly.loop_header523 ], [ 0, %polly.then521 ]
  %p_533 = add i64 %11, %polly.indvar527
  %p_scevgep88534 = getelementptr [2000 x double]* %A, i64 0, i64 %p_533
  %_p_scalar_535 = load double* %p_scevgep88534
  store double %_p_scalar_535, double* %p_scevgep88534
  %p_indvar.next84544 = add i64 %polly.indvar527, 1
  %polly.indvar_next528 = add nsw i64 %polly.indvar527, 1
  %polly.adjust_ub529 = sub i64 %9, 1
  %polly.loop_cond530 = icmp sle i64 %polly.indvar527, %polly.adjust_ub529
  br i1 %polly.loop_cond530, label %polly.loop_header523, label %polly.cond546

polly.cond549:                                    ; preds = %polly.cond546
  %141 = sext i32 %5 to i64
  %142 = icmp sge i64 %141, 1
  %143 = icmp sle i64 %4, 0
  %144 = and i1 %142, %143
  br i1 %144, label %polly.then551, label %polly.cond570

polly.then551:                                    ; preds = %polly.cond549
  br i1 true, label %polly.loop_header553, label %polly.cond570

polly.loop_header553:                             ; preds = %polly.then551, %polly.loop_header553
  %polly.indvar557 = phi i64 [ %polly.indvar_next558, %polly.loop_header553 ], [ 0, %polly.then551 ]
  %p_563 = add i64 %11, %polly.indvar557
  %p_scevgep88564 = getelementptr [2000 x double]* %A, i64 0, i64 %p_563
  %polly.indvar_next558 = add nsw i64 %polly.indvar557, 1
  %polly.adjust_ub559 = sub i64 %9, 1
  %polly.loop_cond560 = icmp sle i64 %polly.indvar557, %polly.adjust_ub559
  br i1 %polly.loop_cond560, label %polly.loop_header553, label %polly.cond570

polly.cond573:                                    ; preds = %polly.cond570
  %145 = sext i32 %5 to i64
  %146 = icmp sle i64 %145, 0
  br i1 %146, label %polly.then575, label %polly.cond596

polly.then575:                                    ; preds = %polly.cond573
  br i1 true, label %polly.loop_header577, label %polly.cond596

polly.loop_header577:                             ; preds = %polly.then575, %polly.loop_header577
  %polly.indvar581 = phi i64 [ %polly.indvar_next582, %polly.loop_header577 ], [ 0, %polly.then575 ]
  %p_587 = add i64 %11, %polly.indvar581
  %p_scevgep88588 = getelementptr [2000 x double]* %A, i64 0, i64 %p_587
  %_p_scalar_589 = load double* %p_scevgep88588
  store double %_p_scalar_589, double* %p_scevgep88588
  %p_indvar.next84594 = add i64 %polly.indvar581, 1
  %polly.indvar_next582 = add nsw i64 %polly.indvar581, 1
  %polly.adjust_ub583 = sub i64 %9, 1
  %polly.loop_cond584 = icmp sle i64 %polly.indvar581, %polly.adjust_ub583
  br i1 %polly.loop_cond584, label %polly.loop_header577, label %polly.cond596

polly.cond599:                                    ; preds = %polly.cond596
  %147 = sext i32 %5 to i64
  %148 = icmp sle i64 %147, 0
  br i1 %148, label %polly.then601, label %polly.merge436

polly.then601:                                    ; preds = %polly.cond599
  br i1 true, label %polly.loop_header603, label %polly.merge436

polly.loop_header603:                             ; preds = %polly.then601, %polly.loop_header603
  %polly.indvar607 = phi i64 [ %polly.indvar_next608, %polly.loop_header603 ], [ 0, %polly.then601 ]
  %p_613 = add i64 %11, %polly.indvar607
  %p_scevgep88614 = getelementptr [2000 x double]* %A, i64 0, i64 %p_613
  %polly.indvar_next608 = add nsw i64 %polly.indvar607, 1
  %polly.adjust_ub609 = sub i64 %9, 1
  %polly.loop_cond610 = icmp sle i64 %polly.indvar607, %polly.adjust_ub609
  br i1 %polly.loop_cond610, label %polly.loop_header603, label %polly.merge436

polly.stmt.622:                                   ; preds = %.preheader3
  %p_scevgep77 = getelementptr [2000 x double]* %A, i64 %4, i64 0
  %_p_scalar_623 = load double* %p_scevgep77
  %p_scevgep78.moved.to. = getelementptr [2000 x double]* %A, i64 0, i64 0
  %_p_scalar_626 = load double* %p_scevgep78.moved.to.
  %p_627 = fdiv double %_p_scalar_623, %_p_scalar_626
  store double %p_627, double* %p_scevgep77
  %149 = add i64 %4, -1
  %polly.loop_guard632 = icmp sle i64 1, %149
  br i1 %polly.loop_guard632, label %polly.loop_header629, label %.preheader2

polly.loop_header629:                             ; preds = %polly.stmt.622, %polly.loop_exit645
  %polly.indvar633 = phi i64 [ %polly.indvar_next634, %polly.loop_exit645 ], [ 1, %polly.stmt.622 ]
  %p_scevgep77638 = getelementptr [2000 x double]* %A, i64 %4, i64 %polly.indvar633
  %p_j.028639 = trunc i64 %polly.indvar633 to i32
  %_p_scalar_640 = load double* %p_scevgep77638
  %150 = add i64 %polly.indvar633, -1
  %polly.loop_guard646 = icmp sle i64 0, %150
  br i1 %polly.loop_guard646, label %polly.loop_header643, label %polly.loop_exit645

polly.loop_exit645:                               ; preds = %polly.loop_header643, %polly.loop_header629
  %w.023.reg2mem.0 = phi double [ %p_655, %polly.loop_header643 ], [ %_p_scalar_640, %polly.loop_header629 ]
  %p_.moved.to.658 = mul i64 %polly.indvar633, 2001
  %p_scevgep78.moved.to.659 = getelementptr [2000 x double]* %A, i64 0, i64 %p_.moved.to.658
  %_p_scalar_662 = load double* %p_scevgep78.moved.to.659
  %p_663 = fdiv double %w.023.reg2mem.0, %_p_scalar_662
  store double %p_663, double* %p_scevgep77638
  %p_indvar.next69664 = add i64 %polly.indvar633, 1
  %polly.indvar_next634 = add nsw i64 %polly.indvar633, 1
  %polly.adjust_ub635 = sub i64 %149, 1
  %polly.loop_cond636 = icmp sle i64 %polly.indvar633, %polly.adjust_ub635
  br i1 %polly.loop_cond636, label %polly.loop_header629, label %.preheader2

polly.loop_header643:                             ; preds = %polly.loop_header629, %polly.loop_header643
  %w.023.reg2mem.1 = phi double [ %_p_scalar_640, %polly.loop_header629 ], [ %p_655, %polly.loop_header643 ]
  %polly.indvar647 = phi i64 [ %polly.indvar_next648, %polly.loop_header643 ], [ 0, %polly.loop_header629 ]
  %p_scevgep73 = getelementptr [2000 x double]* %A, i64 %4, i64 %polly.indvar647
  %p_scevgep74 = getelementptr [2000 x double]* %A, i64 %polly.indvar647, i64 %polly.indvar633
  %_p_scalar_652 = load double* %p_scevgep73
  %_p_scalar_653 = load double* %p_scevgep74
  %p_654 = fmul double %_p_scalar_652, %_p_scalar_653
  %p_655 = fsub double %w.023.reg2mem.1, %p_654
  %p_indvar.next67 = add i64 %polly.indvar647, 1
  %polly.indvar_next648 = add nsw i64 %polly.indvar647, 1
  %polly.adjust_ub649 = sub i64 %150, 1
  %polly.loop_cond650 = icmp sle i64 %polly.indvar647, %polly.adjust_ub649
  br i1 %polly.loop_cond650, label %polly.loop_header643, label %polly.loop_exit645
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, double* %x) #0 {
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
!11 = metadata !{metadata !12}
!12 = metadata !{metadata !12, metadata !10, metadata !"kernel_ludcmp: %y"}
!13 = metadata !{metadata !14, metadata !15, metadata !16, metadata !17}
!14 = metadata !{metadata !14, metadata !10, metadata !"kernel_ludcmp: %A"}
!15 = metadata !{metadata !15, metadata !10, metadata !"kernel_ludcmp: %x"}
!16 = metadata !{metadata !16, metadata !10, metadata !"kernel_ludcmp: %w.3.lcssa.reg2mem"}
!17 = metadata !{metadata !17, metadata !10, metadata !"kernel_ludcmp: %w.36.reg2mem"}
!18 = metadata !{metadata !14}
!19 = metadata !{metadata !15, metadata !16, metadata !12, metadata !17}
!20 = metadata !{metadata !15}
!21 = metadata !{metadata !14, metadata !16, metadata !12, metadata !17}
