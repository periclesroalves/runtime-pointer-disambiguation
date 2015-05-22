#!/bin/bash

echo "------------------"
echo "      LLVM CLEAN"
echo "------------------"

./bin-llvm-clean/mg.B.x
./bin-llvm-clean/ft.B.x
./bin-llvm-clean/cg.C.x
./bin-llvm-clean/is.C.x
./bin-llvm-clean/ep.A.x
./bin-llvm-clean/dc.A.x


echo "------------------"
echo "      LLVM OPT"
echo "------------------"

./bin-llvm-opt/mg.B.x
./bin-llvm-opt/ft.B.x
./bin-llvm-opt/cg.C.x
./bin-llvm-opt/is.C.x
./bin-llvm-opt/ep.A.x
./bin-llvm-opt/dc.A.x


echo "------------------"
echo "      LLVM NOINLINE CLEAN"
echo "------------------"

./bin-llvm-noinline-clean/mg.B.x
./bin-llvm-noinline-clean/ft.B.x
./bin-llvm-noinline-clean/cg.C.x
./bin-llvm-noinline-clean/is.C.x
./bin-llvm-noinline-clean/ep.A.x
./bin-llvm-noinline-clean/dc.A.x


echo "------------------"
echo "      LLVM NOINLINE OPT"
echo "------------------"

./bin-llvm-noinline-opt/mg.B.x
./bin-llvm-noinline-opt/ft.B.x
./bin-llvm-noinline-opt/cg.C.x
./bin-llvm-noinline-opt/is.C.x
./bin-llvm-noinline-opt/ep.A.x
./bin-llvm-noinline-opt/dc.A.x
