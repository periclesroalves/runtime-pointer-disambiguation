; ModuleID = '/Users/periclesalves/ufmg-research/tests/bad-alias.cpp'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

define void @_Z3fooPiS_(i32* noalias %A, i32* noalias %B) nounwind uwtable ssp {
  %1 = alloca i32*, align 8
  %2 = alloca i32*, align 8
  %i = alloca i32, align 4
  store i32* %A, i32** %1, align 8
  store i32* %B, i32** %2, align 8
  store i32 0, i32* %i, align 4
  br label %3

; <label>:3                                       ; preds = %24, %0
  %4 = load i32* %i, align 4
  %5 = icmp slt i32 %4, 100
  br i1 %5, label %6, label %27

; <label>:6                                       ; preds = %3
  %7 = load i32* %i, align 4
  %8 = sitofp i32 %7 to double
  %9 = call double @fmax(double %8, double 3.000000e+00) nounwind readnone
  %10 = fptosi double %9 to i32
  %11 = load i32* %i, align 4
  %12 = sext i32 %11 to i64
  %13 = load i32** %1, align 8
  %14 = getelementptr inbounds i32* %13, i64 %12
  store i32 %10, i32* %14, align 4
  %15 = load i32* %i, align 4
  %16 = sext i32 %15 to i64
  %17 = load i32** %1, align 8
  %18 = getelementptr inbounds i32* %17, i64 %16
  %19 = load i32* %18, align 4
  %20 = load i32* %i, align 4
  %21 = sext i32 %20 to i64
  %22 = load i32** %2, align 8
  %23 = getelementptr inbounds i32* %22, i64 %21
  store i32 %19, i32* %23, align 4
  br label %24

; <label>:24                                      ; preds = %6
  %25 = load i32* %i, align 4
  %26 = add nsw i32 %25, 1
  store i32 %26, i32* %i, align 4
  br label %3

; <label>:27                                      ; preds = %3
  ret void
}

declare double @fmax(double, double) nounwind readnone

define i32 @main() uwtable ssp {
  %A = alloca [100 x i32], align 16
  %B = alloca [100 x i32], align 16
  %1 = getelementptr inbounds [100 x i32]* %A, i32 0, i32 0
  %2 = getelementptr inbounds [100 x i32]* %B, i32 0, i32 0
  call void @_Z3fooPiS_(i32* %1, i32* %2)
  %3 = getelementptr inbounds [100 x i32]* %B, i32 0, i64 5
  %4 = load i32* %3, align 4
  %5 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str, i32 0, i32 0), i32 %4)
  ret i32 0
}

declare i32 @printf(i8*, ...)
