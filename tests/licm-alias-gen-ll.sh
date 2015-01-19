#!/bin/bash

clang -S -emit-llvm -O3 ~/ufmg-research/tests/licm-alias.cpp -o ~/ufmg-research/tests/licm-alias.s
./opt -load ~/ufmg-research/build/tools/polly/Debug+Asserts/lib/LLVMPolly.dylib -O3 -S -polly-canonicalize ~/ufmg-research/tests/licm-alias.s > ~/ufmg-research/tests/licm-alias.ll
