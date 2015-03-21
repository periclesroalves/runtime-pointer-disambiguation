; ModuleID = './medley/nussinov/nussinov.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [6 x i8] c"table\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %0 = tail call i8* @polybench_alloc_data(i64 2500, i32 1) #3
  %1 = tail call i8* @polybench_alloc_data(i64 6250000, i32 4) #3
  %2 = bitcast i8* %1 to [2500 x i32]*
  tail call void @init_array(i32 2500, i8* %0, [2500 x i32]* %2)
  tail call void (...)* @polybench_timer_start() #3
  tail call void @kernel_nussinov(i32 2500, i8* %0, [2500 x i32]* %2)
  tail call void (...)* @polybench_timer_stop() #3
  tail call void (...)* @polybench_timer_print() #3
  %3 = icmp sgt i32 %argc, 42
  br i1 %3, label %4, label %8

; <label>:4                                       ; preds = %.split
  %5 = load i8** %argv, align 8, !tbaa !1
  %6 = load i8* %5, align 1, !tbaa !5
  %phitmp = icmp eq i8 %6, 0
  br i1 %phitmp, label %7, label %8

; <label>:7                                       ; preds = %4
  tail call void @print_array(i32 2500, [2500 x i32]* %2)
  br label %8

; <label>:8                                       ; preds = %4, %7, %.split
  tail call void @free(i8* %0) #3
  tail call void @free(i8* %1) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %n, i8* noalias %seq, [2500 x i32]* noalias %table) #0 {
polly.split_new_and_old:
  %0 = zext i32 %n to i64
  %1 = sext i32 %n to i64
  %2 = icmp sge i64 %1, 1
  %3 = icmp sge i64 %0, 1
  %4 = and i1 %2, %3
  br i1 %4, label %polly.then, label %polly.merge

polly.merge:                                      ; preds = %polly.loop_exit, %polly.loop_header46, %polly.split_new_and_old
  ret void

polly.then:                                       ; preds = %polly.split_new_and_old
  %5 = add i64 %0, -1
  %polly.loop_guard = icmp sle i64 0, %5
  br i1 %polly.loop_guard, label %polly.loop_header, label %polly.loop_exit

polly.loop_exit:                                  ; preds = %polly.loop_exit21, %polly.then
  br i1 %polly.loop_guard, label %polly.loop_header46, label %polly.merge

polly.loop_header:                                ; preds = %polly.then, %polly.loop_exit21
  %polly.indvar = phi i64 [ %polly.indvar_next, %polly.loop_exit21 ], [ 0, %polly.then ]
  %6 = mul i64 -11, %0
  %7 = add i64 %6, 5
  %8 = sub i64 %7, 32
  %9 = add i64 %8, 1
  %10 = icmp slt i64 %7, 0
  %11 = select i1 %10, i64 %9, i64 %7
  %12 = sdiv i64 %11, 32
  %13 = mul i64 -32, %12
  %14 = mul i64 -32, %0
  %15 = add i64 %13, %14
  %16 = mul i64 -32, %polly.indvar
  %17 = mul i64 -3, %polly.indvar
  %18 = add i64 %17, %0
  %19 = add i64 %18, 5
  %20 = sub i64 %19, 32
  %21 = add i64 %20, 1
  %22 = icmp slt i64 %19, 0
  %23 = select i1 %22, i64 %21, i64 %19
  %24 = sdiv i64 %23, 32
  %25 = mul i64 -32, %24
  %26 = add i64 %16, %25
  %27 = add i64 %26, -640
  %28 = icmp sgt i64 %15, %27
  %29 = select i1 %28, i64 %15, i64 %27
  %30 = mul i64 -20, %polly.indvar
  %polly.loop_guard22 = icmp sle i64 %29, %30
  br i1 %polly.loop_guard22, label %polly.loop_header19, label %polly.loop_exit21

polly.loop_exit21:                                ; preds = %polly.loop_exit30, %polly.loop_header
  %polly.indvar_next = add nsw i64 %polly.indvar, 32
  %polly.adjust_ub = sub i64 %5, 32
  %polly.loop_cond = icmp sle i64 %polly.indvar, %polly.adjust_ub
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.loop_exit

polly.loop_header19:                              ; preds = %polly.loop_header, %polly.loop_exit30
  %polly.indvar23 = phi i64 [ %polly.indvar_next24, %polly.loop_exit30 ], [ %29, %polly.loop_header ]
  %31 = mul i64 -1, %polly.indvar23
  %32 = mul i64 -1, %0
  %33 = add i64 %31, %32
  %34 = add i64 %33, -30
  %35 = add i64 %34, 20
  %36 = sub i64 %35, 1
  %37 = icmp slt i64 %34, 0
  %38 = select i1 %37, i64 %34, i64 %36
  %39 = sdiv i64 %38, 20
  %40 = icmp sgt i64 %39, %polly.indvar
  %41 = select i1 %40, i64 %39, i64 %polly.indvar
  %42 = sub i64 %31, 20
  %43 = add i64 %42, 1
  %44 = icmp slt i64 %31, 0
  %45 = select i1 %44, i64 %43, i64 %31
  %46 = sdiv i64 %45, 20
  %47 = add i64 %polly.indvar, 31
  %48 = icmp slt i64 %46, %47
  %49 = select i1 %48, i64 %46, i64 %47
  %50 = icmp slt i64 %49, %5
  %51 = select i1 %50, i64 %49, i64 %5
  %polly.loop_guard31 = icmp sle i64 %41, %51
  br i1 %polly.loop_guard31, label %polly.loop_header28, label %polly.loop_exit30

polly.loop_exit30:                                ; preds = %polly.loop_exit39, %polly.loop_header19
  %polly.indvar_next24 = add nsw i64 %polly.indvar23, 32
  %polly.adjust_ub25 = sub i64 %30, 32
  %polly.loop_cond26 = icmp sle i64 %polly.indvar23, %polly.adjust_ub25
  br i1 %polly.loop_cond26, label %polly.loop_header19, label %polly.loop_exit21

polly.loop_header28:                              ; preds = %polly.loop_header19, %polly.loop_exit39
  %polly.indvar32 = phi i64 [ %polly.indvar_next33, %polly.loop_exit39 ], [ %41, %polly.loop_header19 ]
  %52 = mul i64 -20, %polly.indvar32
  %53 = add i64 %52, %32
  %54 = add i64 %53, 1
  %55 = icmp sgt i64 %polly.indvar23, %54
  %56 = select i1 %55, i64 %polly.indvar23, i64 %54
  %57 = add i64 %polly.indvar23, 31
  %58 = icmp slt i64 %52, %57
  %59 = select i1 %58, i64 %52, i64 %57
  %polly.loop_guard40 = icmp sle i64 %56, %59
  br i1 %polly.loop_guard40, label %polly.loop_header37, label %polly.loop_exit39

polly.loop_exit39:                                ; preds = %polly.loop_header37, %polly.loop_header28
  %polly.indvar_next33 = add nsw i64 %polly.indvar32, 1
  %polly.adjust_ub34 = sub i64 %51, 1
  %polly.loop_cond35 = icmp sle i64 %polly.indvar32, %polly.adjust_ub34
  br i1 %polly.loop_cond35, label %polly.loop_header28, label %polly.loop_exit30

polly.loop_header37:                              ; preds = %polly.loop_header28, %polly.loop_header37
  %polly.indvar41 = phi i64 [ %polly.indvar_next42, %polly.loop_header37 ], [ %56, %polly.loop_header28 ]
  %60 = mul i64 -1, %polly.indvar41
  %61 = add i64 %52, %60
  %p_scevgep = getelementptr [2500 x i32]* %table, i64 %polly.indvar32, i64 %61
  store i32 0, i32* %p_scevgep
  %p_indvar.next = add i64 %61, 1
  %polly.indvar_next42 = add nsw i64 %polly.indvar41, 1
  %polly.adjust_ub43 = sub i64 %59, 1
  %polly.loop_cond44 = icmp sle i64 %polly.indvar41, %polly.adjust_ub43
  br i1 %polly.loop_cond44, label %polly.loop_header37, label %polly.loop_exit39

polly.loop_header46:                              ; preds = %polly.loop_exit, %polly.loop_header46
  %polly.indvar50 = phi i64 [ %polly.indvar_next51, %polly.loop_header46 ], [ 0, %polly.loop_exit ]
  %p_ = add i64 %polly.indvar50, 1
  %p_55 = trunc i64 %p_ to i32
  %p_scevgep15 = getelementptr i8* %seq, i64 %polly.indvar50
  %p_56 = srem i32 %p_55, 4
  %p_57 = trunc i32 %p_56 to i8
  store i8 %p_57, i8* %p_scevgep15
  %polly.indvar_next51 = add nsw i64 %polly.indvar50, 1
  %polly.adjust_ub52 = sub i64 %5, 1
  %polly.loop_cond53 = icmp sle i64 %polly.indvar50, %polly.adjust_ub52
  br i1 %polly.loop_cond53, label %polly.loop_header46, label %polly.merge
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_nussinov(i32 %n, i8* noalias %seq, [2500 x i32]* noalias %table) #0 {
.split:
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.preheader3.lr.ph, label %._crit_edge10

.preheader3.lr.ph:                                ; preds = %.split
  %1 = zext i32 %n to i64
  %2 = sext i32 %n to i64
  %3 = mul i64 %2, 2501
  %4 = add i64 %2, -1
  %5 = add i32 %n, 1
  %6 = zext i32 %5 to i64
  %7 = add i32 %n, -1
  %8 = zext i32 %7 to i64
  br label %.preheader3

.loopexit:                                        ; preds = %._crit_edge, %.preheader3
  %indvar.next14 = add i64 %indvar13, 1
  %exitcond25 = icmp ne i64 %indvar.next14, %1
  br i1 %exitcond25, label %.preheader3, label %._crit_edge10

.preheader3:                                      ; preds = %.preheader3.lr.ph, %.loopexit
  %indvar13 = phi i64 [ 0, %.preheader3.lr.ph ], [ %indvar.next14, %.loopexit ]
  %9 = mul i64 %indvar13, -2501
  %10 = add i64 %3, %9
  %11 = mul i64 %indvar13, -1
  %12 = add i64 %4, %11
  %13 = add i64 %2, %11
  %14 = add i64 %6, %11
  %15 = trunc i64 %14 to i32
  %16 = sext i32 %15 to i64
  %17 = add i64 %indvar13, -1
  %18 = trunc i64 %17 to i32
  %19 = add i64 %8, %11
  %i.09 = trunc i64 %19 to i32
  %scevgep33 = getelementptr [2500 x i32]* %table, i64 %12, i64 0
  %scevgep35 = getelementptr i8* %seq, i64 %12
  %20 = add i64 %1, %11
  %i.0.in8 = trunc i64 %20 to i32
  %scevgep36 = getelementptr [2500 x i32]* %table, i64 %13, i64 0
  %21 = zext i32 %18 to i64
  %22 = add i64 %21, 1
  %23 = icmp slt i32 %i.0.in8, %n
  br i1 %23, label %.lr.ph6, label %.loopexit

.lr.ph6:                                          ; preds = %.preheader3
  br label %24

; <label>:24                                      ; preds = %.lr.ph6, %._crit_edge
  %indvar15 = phi i64 [ 0, %.lr.ph6 ], [ %indvar.next16, %._crit_edge ]
  %25 = add i64 %10, %indvar15
  %scevgep21 = getelementptr [2500 x i32]* %table, i64 0, i64 %25
  %scevgep20 = getelementptr [2500 x i32]* %table, i64 -1, i64 %25
  %26 = add i64 %12, %indvar15
  %27 = trunc i64 %26 to i32
  %28 = add i64 %13, %indvar15
  %j.05 = trunc i64 %28 to i32
  %scevgep28 = getelementptr [2500 x i32]* %table, i64 0, i64 %28
  %scevgep22 = getelementptr i8* %seq, i64 %28
  %29 = sext i32 %27 to i64
  %scevgep34 = getelementptr i32* %scevgep33, i64 %29
  %scevgep37 = getelementptr i32* %scevgep36, i64 %29
  %30 = add i64 %indvar15, -1
  %31 = trunc i64 %30 to i32
  %32 = zext i32 %31 to i64
  %33 = add i64 %32, 1
  %34 = icmp sgt i32 %j.05, 0
  br i1 %34, label %35, label %43

; <label>:35                                      ; preds = %24
  %36 = load i32* %scevgep20, align 4, !tbaa !6
  %37 = load i32* %scevgep34, align 4, !tbaa !6
  %38 = icmp slt i32 %36, %37
  br i1 %38, label %40, label %39

; <label>:39                                      ; preds = %35
  br label %41

; <label>:40                                      ; preds = %35
  br label %41

; <label>:41                                      ; preds = %40, %39
  %.in2.reg2mem.0 = phi i32* [ %scevgep34, %40 ], [ %scevgep20, %39 ]
  %42 = load i32* %.in2.reg2mem.0, align 4
  store i32 %42, i32* %scevgep20, align 4, !tbaa !6
  br label %43

; <label>:43                                      ; preds = %41, %24
  br i1 %23, label %44, label %51

; <label>:44                                      ; preds = %43
  %45 = load i32* %scevgep20, align 4, !tbaa !6
  %46 = load i32* %scevgep21, align 4, !tbaa !6
  %47 = icmp slt i32 %45, %46
  %i.0.sink = select i1 %47, i32 %i.0.in8, i32 %i.09
  %48 = sext i32 %i.0.sink to i64
  %49 = mul i64 %48, 2500
  %scevgep24 = getelementptr i32* %scevgep28, i64 %49
  %50 = load i32* %scevgep24, align 4
  store i32 %50, i32* %scevgep20, align 4, !tbaa !6
  br label %51

; <label>:51                                      ; preds = %44, %43
  %or.cond = and i1 %34, %23
  br i1 %or.cond, label %52, label %.preheader

; <label>:52                                      ; preds = %51
  %53 = icmp sgt i32 %i.0.in8, %27
  %54 = load i32* %scevgep20, align 4, !tbaa !6
  %55 = load i32* %scevgep37, align 4, !tbaa !6
  br i1 %53, label %69, label %56

; <label>:56                                      ; preds = %52
  %57 = load i8* %scevgep35, align 1, !tbaa !5
  %58 = sext i8 %57 to i32
  %59 = load i8* %scevgep22, align 1, !tbaa !5
  %60 = sext i8 %59 to i32
  %61 = add nsw i32 %60, %58
  %62 = icmp eq i32 %61, 3
  %63 = zext i1 %62 to i32
  %64 = add nsw i32 %63, %55
  %65 = icmp slt i32 %54, %64
  br i1 %65, label %67, label %66

; <label>:66                                      ; preds = %56
  br label %68

; <label>:67                                      ; preds = %56
  br label %68

; <label>:68                                      ; preds = %67, %66
  %.reg2mem38.0 = phi i32 [ %64, %67 ], [ %54, %66 ]
  store i32 %.reg2mem38.0, i32* %scevgep20, align 4, !tbaa !6
  br label %.preheader

; <label>:69                                      ; preds = %52
  %70 = icmp slt i32 %54, %55
  br i1 %70, label %72, label %71

; <label>:71                                      ; preds = %69
  br label %73

; <label>:72                                      ; preds = %69
  br label %73

; <label>:73                                      ; preds = %72, %71
  %.in.reg2mem.0 = phi i32* [ %scevgep37, %72 ], [ %scevgep20, %71 ]
  %74 = load i32* %.in.reg2mem.0, align 4
  store i32 %74, i32* %scevgep20, align 4, !tbaa !6
  br label %.preheader

.preheader:                                       ; preds = %68, %73, %51
  %75 = icmp slt i32 %i.0.in8, %j.05
  br i1 %75, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %.preheader, %85
  %indvar = phi i64 [ %indvar.next, %85 ], [ 0, %.preheader ]
  %76 = add i64 %16, %indvar
  %scevgep17 = getelementptr [2500 x i32]* %table, i64 %76, i64 %28
  %77 = add i64 %10, %indvar
  %scevgep = getelementptr [2500 x i32]* %table, i64 -1, i64 %77
  %78 = load i32* %scevgep20, align 4, !tbaa !6
  %79 = load i32* %scevgep, align 4, !tbaa !6
  %80 = load i32* %scevgep17, align 4, !tbaa !6
  %81 = add nsw i32 %80, %79
  %82 = icmp slt i32 %78, %81
  br i1 %82, label %84, label %83

; <label>:83                                      ; preds = %.lr.ph
  br label %85

; <label>:84                                      ; preds = %.lr.ph
  br label %85

; <label>:85                                      ; preds = %84, %83
  %.reg2mem.0 = phi i32 [ %81, %84 ], [ %78, %83 ]
  store i32 %.reg2mem.0, i32* %scevgep20, align 4, !tbaa !6
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %33
  br i1 %exitcond, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %85, %.preheader
  %indvar.next16 = add i64 %indvar15, 1
  %exitcond18 = icmp ne i64 %indvar.next16, %22
  br i1 %exitcond18, label %24, label %.loopexit

._crit_edge10:                                    ; preds = %.loopexit, %.split
  ret void
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, [2500 x i32]* noalias %table) #0 {
  %t.04.reg2mem = alloca i32
  %t.1.lcssa.reg2mem = alloca i32
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([6 x i8]* @.str3, i64 0, i64 0)) #5
  %5 = icmp sgt i32 %n, 0
  br i1 %5, label %.preheader.lr.ph, label %32

.preheader.lr.ph:                                 ; preds = %.split
  %6 = add i32 %n, -1
  %7 = zext i32 %n to i64
  %8 = zext i32 %6 to i64
  store i32 0, i32* %t.04.reg2mem
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %31
  %indvar6 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next7, %31 ]
  %t.04.reload = load i32* %t.04.reg2mem
  %i.03 = trunc i64 %indvar6 to i32
  %9 = mul i64 %indvar6, 2501
  %10 = mul i64 %indvar6, -1
  %11 = add i64 %8, %10
  %12 = trunc i64 %11 to i32
  %13 = add i64 %7, %10
  %14 = trunc i64 %13 to i32
  %15 = zext i32 %12 to i64
  %16 = add i64 %15, 1
  %17 = icmp slt i32 %i.03, %n
  store i32 %t.04.reload, i32* %t.1.lcssa.reg2mem
  br i1 %17, label %.lr.ph, label %31

.lr.ph:                                           ; preds = %.preheader
  %18 = zext i32 %t.04.reload to i64
  br label %19

; <label>:19                                      ; preds = %.lr.ph, %26
  %indvar = phi i64 [ 0, %.lr.ph ], [ %indvar.next, %26 ]
  %20 = add i64 %9, %indvar
  %scevgep = getelementptr [2500 x i32]* %table, i64 0, i64 %20
  %21 = add i64 %18, %indvar
  %t.12 = trunc i64 %21 to i32
  %22 = srem i32 %t.12, 20
  %23 = icmp eq i32 %22, 0
  br i1 %23, label %24, label %26

; <label>:24                                      ; preds = %19
  %25 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %25) #4
  br label %26

; <label>:26                                      ; preds = %24, %19
  %27 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %28 = load i32* %scevgep, align 4, !tbaa !6
  %29 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %27, i8* getelementptr inbounds ([4 x i8]* @.str5, i64 0, i64 0), i32 %28) #5
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %16
  br i1 %exitcond, label %19, label %._crit_edge

._crit_edge:                                      ; preds = %26
  %30 = add i32 %t.04.reload, %14
  store i32 %30, i32* %t.1.lcssa.reg2mem
  br label %31

; <label>:31                                      ; preds = %._crit_edge, %.preheader
  %t.1.lcssa.reload = load i32* %t.1.lcssa.reg2mem
  %indvar.next7 = add i64 %indvar6, 1
  %exitcond8 = icmp ne i64 %indvar.next7, %7
  store i32 %t.1.lcssa.reload, i32* %t.04.reg2mem
  br i1 %exitcond8, label %.preheader, label %._crit_edge5

._crit_edge5:                                     ; preds = %31
  br label %32

; <label>:32                                      ; preds = %._crit_edge5, %.split
  %33 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %34 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %33, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([6 x i8]* @.str3, i64 0, i64 0)) #5
  %35 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %36 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str7, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %35) #4
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
!7 = metadata !{metadata !"int", metadata !3, i64 0}
