; ModuleID = './medley/floyd-warshall/floyd-warshall.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@stderr = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [23 x i8] c"==BEGIN DUMP_ARRAYS==\0A\00", align 1
@.str2 = private unnamed_addr constant [15 x i8] c"begin dump: %s\00", align 1
@.str3 = private unnamed_addr constant [5 x i8] c"path\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str5 = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str6 = private unnamed_addr constant [17 x i8] c"\0Aend   dump: %s\0A\00", align 1
@.str7 = private unnamed_addr constant [23 x i8] c"==END   DUMP_ARRAYS==\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
.split:
  %0 = tail call i8* @polybench_alloc_data(i64 7840000, i32 4) #3
  %1 = bitcast i8* %0 to [2800 x i32]*
  tail call void @init_array(i32 2800, [2800 x i32]* %1)
  tail call void (...)* @polybench_timer_start() #3
  tail call void @kernel_floyd_warshall(i32 2800, [2800 x i32]* %1)
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
  tail call void @print_array(i32 2800, [2800 x i32]* %1)
  br label %7

; <label>:7                                       ; preds = %3, %6, %.split
  tail call void @free(i8* %0) #3
  ret i32 0
}

declare i8* @polybench_alloc_data(i64, i32) #1

; Function Attrs: nounwind uwtable
define internal void @init_array(i32 %n, [2800 x i32]* %path) #0 {
.split:
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.preheader.lr.ph, label %.region

.preheader.lr.ph:                                 ; preds = %.split
  %1 = zext i32 %n to i64
  br label %.preheader

.preheader:                                       ; preds = %.preheader.lr.ph, %._crit_edge
  %2 = phi i64 [ 0, %.preheader.lr.ph ], [ %indvar.next6, %._crit_edge ]
  br i1 %0, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %.preheader, %16
  %indvar = phi i64 [ %indvar.next, %16 ], [ 0, %.preheader ]
  %3 = add i64 %2, %indvar
  %4 = trunc i64 %3 to i32
  %scevgep = getelementptr [2800 x i32]* %path, i64 %2, i64 %indvar
  %5 = mul i64 %2, %indvar
  %6 = trunc i64 %5 to i32
  %7 = srem i32 %6, 7
  %8 = add nsw i32 %7, 1
  store i32 %8, i32* %scevgep, align 4, !tbaa !6, !alias.scope !8
  %9 = srem i32 %4, 13
  %10 = icmp eq i32 %9, 0
  %11 = srem i32 %4, 7
  %12 = icmp eq i32 %11, 0
  %or.cond = or i1 %10, %12
  %13 = srem i32 %4, 11
  %14 = icmp eq i32 %13, 0
  %or.cond11 = or i1 %or.cond, %14
  br i1 %or.cond11, label %15, label %16

; <label>:15                                      ; preds = %.lr.ph
  store i32 999, i32* %scevgep, align 4, !tbaa !6, !alias.scope !8
  br label %16

; <label>:16                                      ; preds = %.lr.ph, %15
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %1
  br i1 %exitcond, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %16, %.preheader
  %indvar.next6 = add i64 %2, 1
  %exitcond7 = icmp ne i64 %indvar.next6, %1
  br i1 %exitcond7, label %.preheader, label %.region

.region:                                          ; preds = %.split, %._crit_edge
  ret void
}

declare void @polybench_timer_start(...) #1

; Function Attrs: nounwind uwtable
define internal void @kernel_floyd_warshall(i32 %n, [2800 x i32]* %path) #0 {
.split:
  %0 = icmp sgt i32 %n, 0
  br i1 %0, label %.preheader1.lr.ph, label %.region

.preheader1.lr.ph:                                ; preds = %.split
  %1 = zext i32 %n to i64
  br label %.preheader1

.preheader1:                                      ; preds = %.preheader1.lr.ph, %._crit_edge4
  %indvar9 = phi i64 [ 0, %.preheader1.lr.ph ], [ %indvar.next10, %._crit_edge4 ]
  br i1 %0, label %.preheader, label %._crit_edge4

.preheader:                                       ; preds = %.preheader1, %._crit_edge
  %indvar7 = phi i64 [ %indvar.next8, %._crit_edge ], [ 0, %.preheader1 ]
  %scevgep14 = getelementptr [2800 x i32]* %path, i64 %indvar7, i64 %indvar9
  br i1 %0, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %.preheader, %9
  %indvar = phi i64 [ %indvar.next, %9 ], [ 0, %.preheader ]
  %scevgep11 = getelementptr [2800 x i32]* %path, i64 %indvar9, i64 %indvar
  %scevgep = getelementptr [2800 x i32]* %path, i64 %indvar7, i64 %indvar
  %2 = load i32* %scevgep, align 4, !tbaa !6, !alias.scope !11, !noalias !13
  %3 = load i32* %scevgep14, align 4, !tbaa !6, !alias.scope !11, !noalias !13
  %4 = load i32* %scevgep11, align 4, !tbaa !6, !alias.scope !11, !noalias !13
  %5 = add nsw i32 %4, %3
  %6 = icmp slt i32 %2, %5
  br i1 %6, label %7, label %8

; <label>:7                                       ; preds = %.lr.ph
  br label %9

; <label>:8                                       ; preds = %.lr.ph
  br label %9

; <label>:9                                       ; preds = %8, %7
  %.reg2mem.0 = phi i32 [ %2, %7 ], [ %5, %8 ]
  store i32 %.reg2mem.0, i32* %scevgep, align 4, !tbaa !6, !alias.scope !11, !noalias !13
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %1
  br i1 %exitcond, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %9, %.preheader
  %indvar.next8 = add i64 %indvar7, 1
  %exitcond12 = icmp ne i64 %indvar.next8, %1
  br i1 %exitcond12, label %.preheader, label %._crit_edge4

._crit_edge4:                                     ; preds = %._crit_edge, %.preheader1
  %indvar.next10 = add i64 %indvar9, 1
  %exitcond15 = icmp ne i64 %indvar.next10, %1
  br i1 %exitcond15, label %.preheader1, label %.region

.region:                                          ; preds = %.split, %._crit_edge4
  ret void
}

declare void @polybench_timer_stop(...) #1

declare void @polybench_timer_print(...) #1

; Function Attrs: nounwind
declare i32 @strcmp(i8*, i8*) #2

; Function Attrs: nounwind uwtable
define internal void @print_array(i32 %n, [2800 x i32]* %path) #0 {
  br label %.split

.split:                                           ; preds = %0
  %1 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %2 = tail call i64 @fwrite(i8* getelementptr inbounds ([23 x i8]* @.str1, i64 0, i64 0), i64 22, i64 1, %struct._IO_FILE* %1) #4
  %3 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %4 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([15 x i8]* @.str2, i64 0, i64 0), i8* getelementptr inbounds ([5 x i8]* @.str3, i64 0, i64 0)) #5
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
  %scevgep = getelementptr [2800 x i32]* %path, i64 %indvar4, i64 %indvar
  %13 = srem i32 %12, 20
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %15, label %17

; <label>:15                                      ; preds = %10
  %16 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %fputc = tail call i32 @fputc(i32 10, %struct._IO_FILE* %16) #4
  br label %17

; <label>:17                                      ; preds = %15, %10
  %18 = load %struct._IO_FILE** @stderr, align 8, !tbaa !1
  %19 = load i32* %scevgep, align 4, !tbaa !6
  %20 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %18, i8* getelementptr inbounds ([4 x i8]* @.str5, i64 0, i64 0), i32 %19) #5
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
  %24 = tail call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %23, i8* getelementptr inbounds ([17 x i8]* @.str6, i64 0, i64 0), i8* getelementptr inbounds ([5 x i8]* @.str3, i64 0, i64 0)) #5
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
!7 = metadata !{metadata !"int", metadata !3, i64 0}
!8 = metadata !{metadata !9}
!9 = metadata !{metadata !9, metadata !10, metadata !"init_array: %path"}
!10 = metadata !{metadata !10, metadata !"init_array"}
!11 = metadata !{metadata !12}
!12 = metadata !{metadata !12, metadata !10, metadata !"kernel_floyd_warshall: %path"}
!13 = metadata !{metadata !14}
!14 = metadata !{metadata !14, metadata !10, metadata !"kernel_floyd_warshall: %.reg2mem"}
