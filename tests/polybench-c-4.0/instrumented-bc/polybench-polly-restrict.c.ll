; ModuleID = 'utilities/polybench.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%struct.timeval = type { i64, i64 }
%struct.timezone = type { i32, i32 }

@polybench_papi_counters_threadid = global i32 0, align 4
@polybench_program_total_flops = global double 0.000000e+00, align 8
@.str = private unnamed_addr constant [12 x i8] c"tmp <= 10.0\00", align 1
@.str1 = private unnamed_addr constant [22 x i8] c"utilities/polybench.c\00", align 1
@__PRETTY_FUNCTION__.polybench_flush_cache = private unnamed_addr constant [29 x i8] c"void polybench_flush_cache()\00", align 1
@polybench_t_start = common global double 0.000000e+00, align 8
@polybench_t_end = common global double 0.000000e+00, align 8
@.str2 = private unnamed_addr constant [7 x i8] c"%0.6f\0A\00", align 1
@polybench_c_start = common global i64 0, align 8
@polybench_c_end = common global i64 0, align 8
@stderr = external global %struct._IO_FILE*
@.str3 = private unnamed_addr constant [51 x i8] c"[PolyBench] posix_memalign: cannot allocate memory\00", align 1
@.str4 = private unnamed_addr constant [35 x i8] c"Error return from gettimeofday: %d\00", align 1

; Function Attrs: nounwind uwtable
define void @polybench_flush_cache() #0 {
.split:
  %0 = tail call noalias i8* @calloc(i64 4194560, i64 8) #4
  br label %polly.loop_header

; <label>:1                                       ; preds = %polly.loop_exit
  tail call void @__assert_fail(i8* getelementptr inbounds ([12 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([22 x i8]* @.str1, i64 0, i64 0), i32 98, i8* getelementptr inbounds ([29 x i8]* @__PRETTY_FUNCTION__.polybench_flush_cache, i64 0, i64 0)) #5
  unreachable

; <label>:2                                       ; preds = %polly.loop_exit
  tail call void @free(i8* %0) #4
  ret void

polly.loop_exit:                                  ; preds = %polly.loop_header
  %3 = fcmp ugt double %p_4, 1.000000e+01
  br i1 %3, label %1, label %2

polly.loop_header:                                ; preds = %polly.loop_header, %.split
  %tmp.02.reg2mem.0 = phi double [ 0.000000e+00, %.split ], [ %p_4, %polly.loop_header ]
  %polly.indvar = phi i64 [ 0, %.split ], [ %polly.indvar_next, %polly.loop_header ]
  %p_ = mul i64 %polly.indvar, 8
  %p_scevgep = getelementptr i8* %0, i64 %p_
  %p_scevgep3 = bitcast i8* %p_scevgep to double*
  %_p_scalar_ = load double* %p_scevgep3
  %p_4 = fadd double %tmp.02.reg2mem.0, %_p_scalar_
  %p_indvar.next = add i64 %polly.indvar, 1
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.loop_cond = icmp sle i64 %polly.indvar, 4194558
  br i1 %polly.loop_cond, label %polly.loop_header, label %polly.loop_exit
}

; Function Attrs: nounwind
declare noalias i8* @calloc(i64, i64) #1

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8*, i8*, i32, i8*) #2

; Function Attrs: nounwind
declare void @free(i8*) #1

; Function Attrs: nounwind uwtable
define void @polybench_prepare_instruments() #0 {
.split:
  tail call void @polybench_flush_cache()
  ret void
}

; Function Attrs: nounwind uwtable
define void @polybench_timer_start() #0 {
.split:
  tail call void @polybench_prepare_instruments()
  %0 = tail call double @rtclock()
  store double %0, double* @polybench_t_start, align 8, !tbaa !1
  ret void
}

; Function Attrs: nounwind uwtable
define void @polybench_timer_stop() #0 {
.split:
  %0 = tail call double @rtclock()
  store double %0, double* @polybench_t_end, align 8, !tbaa !1
  ret void
}

; Function Attrs: nounwind uwtable
define void @polybench_timer_print() #0 {
.split:
  %0 = load double* @polybench_t_end, align 8, !tbaa !1
  %1 = load double* @polybench_t_start, align 8, !tbaa !1
  %2 = fsub double %0, %1
  %3 = tail call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([7 x i8]* @.str2, i64 0, i64 0), double %2) #4
  ret void
}

declare i32 @printf(i8*, ...) #3

; Function Attrs: nounwind uwtable
define i8* @polybench_alloc_data(i64 %n, i32 %elt_size) #0 {
.split:
  %0 = sext i32 %elt_size to i64
  %1 = mul i64 %0, %n
  %2 = tail call i8* @xmalloc(i64 %1)
  ret i8* %2
}

; Function Attrs: nounwind uwtable
define internal i8* @xmalloc(i64 %num) #0 {
.split:
  %cur = alloca i8*, align 8
  store i8* null, i8** %cur, align 8, !tbaa !5
  %0 = call i32 @posix_memalign(i8** %cur, i64 32, i64 %num) #4
  %1 = load i8** %cur, align 8, !tbaa !5
  %2 = icmp ne i8* %1, null
  %3 = icmp eq i32 %0, 0
  %or.cond = and i1 %2, %3
  br i1 %or.cond, label %7, label %4

; <label>:4                                       ; preds = %.split
  %5 = load %struct._IO_FILE** @stderr, align 8, !tbaa !5
  %6 = call i64 @fwrite(i8* getelementptr inbounds ([51 x i8]* @.str3, i64 0, i64 0), i64 50, i64 1, %struct._IO_FILE* %5) #6
  call void @exit(i32 1) #5
  unreachable

; <label>:7                                       ; preds = %.split
  ret i8* %1
}

; Function Attrs: nounwind
declare i32 @posix_memalign(i8**, i64, i64) #1

declare i32 @fprintf(%struct._IO_FILE*, i8*, ...) #3

; Function Attrs: noreturn nounwind
declare void @exit(i32) #2

; Function Attrs: nounwind uwtable
define internal double @rtclock() #0 {
  %Tp = alloca %struct.timeval, align 8
  br label %.split

.split:                                           ; preds = %0
  %1 = call i32 @gettimeofday(%struct.timeval* %Tp, %struct.timezone* null) #4
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %5, label %3

; <label>:3                                       ; preds = %.split
  %4 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([35 x i8]* @.str4, i64 0, i64 0), i32 %1) #4
  br label %5

; <label>:5                                       ; preds = %.split, %3
  %6 = getelementptr inbounds %struct.timeval* %Tp, i64 0, i32 0
  %7 = load i64* %6, align 8, !tbaa !7
  %8 = sitofp i64 %7 to double
  %9 = getelementptr inbounds %struct.timeval* %Tp, i64 0, i32 1
  %10 = load i64* %9, align 8, !tbaa !10
  %11 = sitofp i64 %10 to double
  %12 = fmul double %11, 1.000000e-06
  %13 = fadd double %8, %12
  ret double %13
}

; Function Attrs: nounwind
declare i32 @gettimeofday(%struct.timeval*, %struct.timezone*) #1

; Function Attrs: nounwind
declare i64 @fwrite(i8* nocapture, i64, i64, %struct._IO_FILE* nocapture) #4

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { noreturn nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }
attributes #5 = { noreturn nounwind }
attributes #6 = { cold }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.6.0 (trunk)"}
!1 = metadata !{metadata !2, metadata !2, i64 0}
!2 = metadata !{metadata !"double", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
!5 = metadata !{metadata !6, metadata !6, i64 0}
!6 = metadata !{metadata !"any pointer", metadata !3, i64 0}
!7 = metadata !{metadata !8, metadata !9, i64 0}
!8 = metadata !{metadata !"timeval", metadata !9, i64 0, metadata !9, i64 8}
!9 = metadata !{metadata !"long", metadata !3, i64 0}
!10 = metadata !{metadata !8, metadata !9, i64 8}
