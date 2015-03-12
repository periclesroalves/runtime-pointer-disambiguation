#!/bin/bash

set -o errexit
set -o nounset

. bench-profiling-common.sh

## CONFIGURATION

POLYBENCH_SRC_DIR="$SRC_BASE"/tests/polybench-c-3.2
BIN_DIR=bin/polybench

MODES=(
	normal
	speculative
)

## FUNCTIONS TO BUILD & RUN BENCHMARKS

function compile_benchmark {
	local NAME="$1"
	local DST="$2"

	local CC="$LLVM_BIN_DIR/clang"
	local FILE=$(find "$POLYBENCH_SRC_DIR" -name "$NAME".c)

	"$LLVM_BIN_DIR/llvm-link" -S -o "$DST" \
		<(
			"$CC" \
				$FILE \
				-I"$POLYBENCH_SRC_DIR"/utilities \
				-DPOLYBENCH_TIME \
				-S -emit-llvm \
				-o -
		) \
		<(
			"$CC" \
				"$POLYBENCH_SRC_DIR"/utilities/polybench.c \
				-I"$POLYBENCH_SRC_DIR"/utilities \
				-DPOLYBENCH_TIME \
				-S -emit-llvm \
				-o -
		)
}

function build_benchmark {
	local NAME="$1"
	local MODE="$2"
	local DST="$3"

	local CC="$LLVM_BIN_DIR/clang"
	local CXX="$LLVM_BIN_DIR/clang++"
	local FILE=$(find -name "$NAME".c)
	local BASENAME=$(basename $FILE)

	"$LLVM_BIN_DIR/llvm-link" -o "$DST" \
		<(
			"$CC" \
				$FILE \
				-I"$POLYBENCH_SRC_DIR"/utilities \
				-DPOLYBENCH_TIME \
				-S -emit-llvm \
				-o -
		) \
		<(
			"$CC" \
				"$POLYBENCH_SRC_DIR"/utilities/polybench.c \
				-I"$POLYBENCH_SRC_DIR"/utilities \
				-DPOLYBENCH_TIME \
				-S -emit-llvm \
				-o -
		)
}

function run_benchmark {
	local NAME="$1"
	local MODE="$2"
	local BIN="$3"

	"$BIN"
}

function benchmark_iterations {
	local NAME="$1"

	case $NAME in
		2mm | 3mm | symm)
			echo $SLOW_BENCH_ITERATIONS
			;;
		*)
			echo $FAST_BENCH_ITERATIONS
			;;
	esac
}

function benchmark_libs {
	local NAME="$1"

	echo -lm
}

function benchmark_is_cpp {
	false
}

function benchmark_list {
	local LIST=(
		covariance
		2mm
		3mm
		atax
		bicg
		cholesky
		doitgen
		gemm
		gemver
		gesummv
		mvt
		symm
		syr2k
		syrk
		trisolv
		trmm
		durbin
		dynprog
		gramschmidt
		lu
		ludcmp
		floyd-warshall
		reg_detect
		adi
		fdtd-2d
		fdtd-apml
		jacobi-1d-imper
		jacobi-2d-imper
		seidel-2d
	)

	for BENCH in "${LIST[@]}"
	do
		echo "$BENCH"
	done
}

## run main

main "$@"
