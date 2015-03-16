#!/bin/bash

set -o errexit
set -o nounset

. bench-profiling-common.sh

## CONFIGURATION

POLYBENCH_SRC_DIR="$SRC_BASE"/tests/polybench-c-4.0
BIN_DIR=bin/polybench4

MODES=(
	normal
	speculative
)

## FUNCTIONS TO BUILD & RUN BENCHMARKS

function benchmark_src_files {
	local NAME="$1"

	echo "$POLYBENCH_SRC_DIR"/utilities/polybench.c
	echo "$(find "$POLYBENCH_SRC_DIR" -name "$NAME".c)"
}

function benchmark_include_dirs {
	local NAME="$1"

	echo -I"$POLYBENCH_SRC_DIR"/utilities/
}

function benchmark_flags {
	local NAME="$1"

	echo -I"$POLYBENCH_SRC_DIR"/utilities
	echo -DPOLYBENCH_TIME
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
		2mm | 3mm | symm | cholesky)
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
	local NAME="$1"

	false
}

function benchmark_list {
	local LIST=(
		2mm
		3mm
		adi
		atax
		bicg
		cholesky
		correlation
		covariance
		deriche
		doitgen
		durbin
		fdtd-2d
		floyd-warshall
		gemm
		gemver
		gesummv
		gramschmidt
		heat-3d
		jacobi-1d
		jacobi-2d
		lu
		ludcmp
		mvt
		nussinov
		seidel-2d
		symm
		syr2k
		syrk
		trisolv
		trmm
	)

	for BENCH in "${LIST[@]}"
	do
		echo "$BENCH"
	done
}

function benchmark_sampling_rate {
	local NAME="$1"

	echo "0"
}

## run main

main "$@"
