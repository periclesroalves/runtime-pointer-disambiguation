#!/bin/bash

./clang -S -emit-llvm ~/ufmg-research/tests/licm-alias.cpp -o ~/ufmg-research/tests/licm-alias.s
