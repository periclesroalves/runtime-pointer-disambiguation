#!/bin/bash

echo "CLEAN"
for test in `cat utilities/benchmark_list`; do
  echo $test;
  /home/pericles/ufmg-research/build-release/bin/clang -Xclang \
  -load -Xclang /home/pericles/ufmg-research/build-release/lib/LLVMPolly.so \
  -I utilities/ utilities/polybench.c $test \
  -lm -O3 -DPOLYBENCH_TIME -mllvm -polly -mllvm -polly-code-generator=none -mllvm -polly-optimizer=none ;
  ./a.out; ./a.out; ./a.out; ./a.out; ./a.out ;
done;

echo "OPT"
for test in `cat utilities/benchmark_list`; do
  echo $test;
  /home/pericles/ufmg-research/build-release/bin/clang -Xclang \
  -load -Xclang /home/pericles/ufmg-research/build-release/lib/LLVMPolly.so \
  -I utilities/ utilities/polybench.c $test \
  -lm -O3 -DPOLYBENCH_TIME -mllvm -polly -mllvm -polly-code-generator=none -mllvm -polly-optimizer=none -mllvm -polly-use-scev-alias-checks ;
  ./a.out; ./a.out; ./a.out; ./a.out; ./a.out ;
done;
