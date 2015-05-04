#!/bin/bash

for i in {0..29}; do
  echo $i
  ./mysandbox/bin/lnt runtest nt --sandbox base-sandbox/ \
    --cc ~/ufmg-research/build-release/bin/clang \
    --cxx ~/ufmg-research/build-release/bin/clang++ \
    --test-suite ~/ufmg-research/tests/llvm-test-suite/ \
    --test-externals /home/pericles/ufmg-research/tests/llvm-test-suite/External \
    --optimize-option -O3 -j20 \
    --cflag -Xclang --cflag -load --cflag -Xclang --cflag /home/pericles/ufmg-research/build-release/lib/LLVMPolly.so \
    --cflag -O3 \
    --mllvm -polly --mllvm -polly-code-generator=none --mllvm -polly-optimizer=none ;
done

for i in {0..29}; do
  echo $i
  ./mysandbox/bin/lnt runtest nt --sandbox opt-sandbox/ \
    --cc ~/ufmg-research/build-release/bin/clang \
    --cxx ~/ufmg-research/build-release/bin/clang++ \
    --test-suite ~/ufmg-research/tests/llvm-test-suite/ \
    --test-externals /home/pericles/ufmg-research/tests/llvm-test-suite/External \
    --optimize-option -O3 -j20 \
    --cflag -Xclang --cflag -load --cflag -Xclang --cflag /home/pericles/ufmg-research/build-release/lib/LLVMPolly.so \
    --cflag -O3 \
    --mllvm -polly --mllvm -polly-code-generator=none --mllvm -polly-optimizer=none --mllvm -polly-use-scev-alias-checks ;
done

for i in {0..29}; do
  echo $i
  ./mysandbox/bin/lnt runtest nt --sandbox base-noinline-sandbox/ \
    --cc ~/ufmg-research/build-release/bin/clang \
    --cxx ~/ufmg-research/build-release/bin/clang++ \
    --test-suite ~/ufmg-research/tests/llvm-test-suite/ \
    --test-externals /home/pericles/ufmg-research/tests/llvm-test-suite/External \
    --optimize-option -O3 -j20 \
    --cflag -Xclang --cflag -load --cflag -Xclang --cflag /home/pericles/ufmg-research/build-release/lib/LLVMPolly.so \
    --cflag -O3 \
    --cflag -fno-inline \
    --mllvm -polly --mllvm -polly-code-generator=none --mllvm -polly-optimizer=none ;
done

for i in {0..29}; do
  echo $i
  ./mysandbox/bin/lnt runtest nt --sandbox opt-noinline-sandbox/ \
    --cc ~/ufmg-research/build-release/bin/clang \
    --cxx ~/ufmg-research/build-release/bin/clang++ \
    --test-suite ~/ufmg-research/tests/llvm-test-suite/ \
    --test-externals /home/pericles/ufmg-research/tests/llvm-test-suite/External \
    --optimize-option -O3 -j20 \
    --cflag -Xclang --cflag -load --cflag -Xclang --cflag /home/pericles/ufmg-research/build-release/lib/LLVMPolly.so \
    --cflag -O3 \
    --cflag -fno-inline \
    --mllvm -polly --mllvm -polly-code-generator=none --mllvm -polly-optimizer=none --mllvm -polly-use-scev-alias-checks ;
done
