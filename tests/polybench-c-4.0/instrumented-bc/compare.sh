#!/bin/bash

echo "Version: SCEV checks + old Polly"

for test in `ls polly-scev-checks/*.bc`; do
  /home/pericles/ufmg-research/build-release/bin/clang -Xclang \
  -load -Xclang /home/pericles/ufmg-research/build-release/lib/LLVMPolly.so \
  -lm -O3 -mllvm -polly \
  $test polybench-polly-scev-checks.c.bc;
  echo $test;
  ./a.out; ./a.out; ./a.out; ./a.out; ./a.out; ./a.out;
done

echo "Version: SCEV checks + newest Polly"

for test in `ls polly-scev-checks/*.bc`; do
  /home/pericles/llvm-bleeding-edge/build-release/bin/clang -Xclang \
  -load -Xclang /home/pericles/llvm-bleeding-edge/build-release/lib/LLVMPolly.so \
  -lm -O3 -mllvm -polly -mllvm -polly-use-runtime-alias-checks=false \
  $test polybench-polly-scev-checks.c.bc;
  echo $test;
  ./a.out; ./a.out; ./a.out; ./a.out; ./a.out; ./a.out;
done

echo "Version: clean + old Polly"

for test in `ls polly-clean/*.bc`; do
  /home/pericles/ufmg-research/build-release/bin/clang -Xclang \
  -load -Xclang /home/pericles/ufmg-research/build-release/lib/LLVMPolly.so \
  -lm -O3 -mllvm -polly \
  $test polybench-polly-clean.c.bc;
  echo $test;
  ./a.out; ./a.out; ./a.out; ./a.out; ./a.out; ./a.out;
done

echo "Version: clean + newest Polly"

for test in `ls polly-clean/*.bc`; do
  /home/pericles/llvm-bleeding-edge/build-release/bin/clang -Xclang \
  -load -Xclang /home/pericles/llvm-bleeding-edge/build-release/lib/LLVMPolly.so \
  -lm -O3 -mllvm -polly -mllvm -polly-use-runtime-alias-checks=false \
  $test polybench-polly-clean.c.bc;
  echo $test;
  ./a.out; ./a.out; ./a.out; ./a.out; ./a.out; ./a.out;
done
