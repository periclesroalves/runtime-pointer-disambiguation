#!/bin/bash

set -o errexit
set -o nounset

## CONFIGURATION

# what kind of optimzations to run
MODES=(
	normal
	speculative
)

FAST_BENCH_ITERATIONS=${FAST_BENCH_ITERATIONS-10}
SLOW_BENCH_ITERATIONS=${SLOW_BENCH_ITERATIONS-5}
VERY_SLOW_BENCH_ITERATIONS=${VERY_SLOW_BENCH_ITERATIONS-2}

BUILD_TYPE=debug

case "$USER" in
	fader)
		SRC_BASE=~/workspace/loop-opt/loop-opt/
		BIN_BASE=~/workspace/loop-opt/
		;;
	inria_ufmg)
		SRC_BASE=~/loop-opt/
		BIN_BASE=~/loop-opt/
		;;
	*)
		>&2 echo "Unknown configuration"
		exit 1
		;;
esac

LLVM_SRC_DIR="$SRC_BASE"/llvm/
LLVM_BIN_DIR="$BIN_BASE"/build-llvm-"$BUILD_TYPE"/bin/
LLVM_LIB_DIR="$BIN_BASE"/build-llvm-"$BUILD_TYPE"/lib/
HA_SRC_DIR="$SRC_BASE"/HybridAlias
HA_LIB_DIR="$BIN_BASE"/build-ha-"$BUILD_TYPE"

MEMTRACK_SRC="$SRC_BASE"/alias_profiler/src

LLVM_LINK="$LLVM_BIN_DIR/llvm-link"
OPT="$LLVM_BIN_DIR/opt"
CLANG="$LLVM_BIN_DIR/clang"
CLANGXX="$LLVM_BIN_DIR/clang++"
POLLYCC="$CLANG -Xclang -load -Xclang $LLVM_LIB_DIR/LLVMPolly.so -mllvm -polly"
POLLYCXX="$CLANGXX -Xclang -load -Xclang $LLVM_LIB_DIR/LLVMPolly.so -mllvm -polly"

## MAIN

function main {
	if [[ "$#" -gt 0 ]]
	then
		BENCH_LIST=( "$@" )
	else
		BENCH_LIST=( $(benchmark_list) )
	fi

	[ "${#BENCH_LIST[@]}" -eq 0 ] && _error "BENCH_LIST is empty"
	[ -z "$BIN_DIR" ]             && _error "BIN_DIR not set"

	MEMTRACK_LL="$BIN_DIR/memtrack.ll"
	ALIAS_PROFILER_LL="$BIN_DIR/alias_profiler.ll"

	for BENCH in "${BENCH_LIST[@]}"
	do
		check_bench_name "$BENCH"
	done

	mkdir -p "$BIN_DIR"

	compile_libraries
	compile_benchmarks
	run_benchmarks
}

function compile_libraries {
	echo "#### compiling alias profiler"

	"$LLVM_LINK" -o "$MEMTRACK_LL" \
		<("$CLANG" -std=c11 -O3 -S -emit-llvm -I"$MEMTRACK_SRC" "$MEMTRACK_SRC/memtrack.c"       -o -) \
		<("$CLANG" -std=c11 -O3 -S -emit-llvm -I"$MEMTRACK_SRC" "$MEMTRACK_SRC/misc.c"           -o -) \
	;
	"$LLVM_LINK" -o "$ALIAS_PROFILER_LL" \
		"$BIN_DIR/memtrack.ll" \
		<("$CLANG" -std=c11 -O3 -S -emit-llvm -I"$MEMTRACK_SRC" "$MEMTRACK_SRC/alias_profiler.c" -o -) \
	;
}

function compile_benchmarks {
	echo "#### compiling benchmarks"

	for BENCH in "${BENCH_LIST[@]}"
	do
		echo "## $BENCH"

		local BASENAME=$(basename "$BENCH")
		local FILE="$BIN_DIR"/"$BASENAME"

		local LL_UNOPTIMIZED="$FILE"".ll"
		local LL_CANONICAL="$FILE"".canonical.ll"
		local LL_CANONICAL_O3="$FILE"".canonical.O3.ll"
		local LL_CANONICAL_PERF="$FILE"".canonical.perf.ll"
		local LL_CANONICAL_PERF_O3="$FILE"".canonical.perf.O3.ll"
		local LL_INSTRUMENTED="$FILE"".instrumented.ll"
		local LL_INSTRUMENTED_O3="$FILE"".instrumented.O3.ll"
		local LL_SPECULATIVE="$FILE"".speculative.ll"
		local LL_SPECULATIVE_O3="$FILE"".speculative.O3.ll"
		local LL_SPECULATIVE_PERF="$FILE"".speculative.perf.ll"
		local LL_SPECULATIVE_PERF_O3="$FILE"".speculative.perf.O3.ll"
		local LL_FINAL="$FILE"".final.ll"
		local LL_FINAL_O3="$FILE"".final.O3.ll"

		local BENCHMARK="$FILE"-normal
		local PERF_BENCHMARK="$FILE"-perf
		local INSTRUMENTED_BENCHMARK="$FILE"-instrumented
		local SPECULATIVE_BENCHMARK="$FILE"-speculative
		local SPECULATIVE_PERF_BENCHMARK="$FILE"-perf-speculative
		local FINAL_BENCHMARK="$FILE"-final

		local ALIAS_TRACE="$FILE"".alias.trace"
		local ALIAS_YAML="$FILE"".alias.yaml"  # processed trace file
		local ALIAS_YAML_FILTERED="$FILE"".filtered.alias.yaml"
		local CLONEINFO_YAML="$FILE"".cloneInfo.yaml"
		local CLONEINFO_YAML_FILTERED="$FILE"".cloneInfo.filtered.yaml"
		local CANONICAL_PERF_TRACE="$FILE"".canonical.perf.trace"
		local SPECULATIVE_PERF_TRACE="$FILE"".speculative.perf.trace"

		local ALIAS_TRACE="$FILE"".alias.trace"
		local ALIAS_YAML="$FILE"".alias.yaml"  # processed trace file
		local ALIAS_YAML_FILTERED="$FILE"".filtered.alias.yaml"
		local CLONEINFO_YAML="$FILE"".cloneInfo.yaml"
		local CLONEINFO_YAML_FILTERED="$FILE"".cloneInfo.filtered.yaml"
		local INPUT_PERF_TRACE="$FILE"".input.perf.trace"
		local SPECULATIVE_PERF_TRACE="$FILE"".speculative.perf.trace"

		local LIBS=$(benchmark_libs "$BENCH")

		compile_benchmark "$BENCH" "$LL_UNOPTIMIZED"

		if [ ! -r "$LL_UNOPTIMIZED" ]
		then
			_error "error while building '$BENCH' in mode '$MODE'"
		fi

		if benchmark_is_cpp "$BENCH"
		then
			local CC="$POLLYCXX"
		else
			local CC="$POLLYCC"
		fi

		#### canonicalize
		# "$CLANG" -S -emit-llvm -Xclang -load -Xclang "$LLVM_LIB_DIR/LLVMPolly.so" -mllvm -polly -O0 "$DST" -o - | sponge "$DST"
		"$LLVM_BIN_DIR/canonicalize" "$LL_UNOPTIMIZED" -o "$LL_CANONICAL"

		#### create baseline version
		$CC -O3 "$LL_CANONICAL" $LIBS -o "$BENCHMARK"

		#### alias profiling
		# "$LLVM_BIN_DIR/alias-instrument" "$LL_CANONICAL" -o "$LL_INSTRUMENTED"

		# # link in alias profiler
		# "$LLVM_LINK" -S "$LL_INSTRUMENTED" alias_profiler.ll | sponge "$LL_INSTRUMENTED"

		# ## optimize
		# "$OPT" -S "$LL_INSTRUMENTED" -O3 -o "$LL_INSTRUMENTED_O3"

		# ## link
		# "$LLVM_BIN_DIR/clang" -O3 "$LL_INSTRUMENTED_O3" -ldl $LIBS -o "$INSTRUMENTED_BENCHMARK"

		# ## run instrumented version
		# # export TRACE_FILE="$ALIAS_TRACE"
		# # run_benchmark "$BENCH" "$INSTRUMENTED_BENCHMARK" >/dev/null

		# ## aggregate alias trace
		# python3 "$HA_SRC_DIR/aggregate-alias-trace" "$ALIAS_TRACE" "$ALIAS_YAML"

		#### optimize with profiling feedback

		## create speculatively optimized version
		$CC -mllvm -polly-use-scev-alias-checks -O3 "$LL_CANONICAL" -S -emit-llvm -o "$LL_SPECULATIVE_O3"

		## link speculatively optimized version
		if grep -q gcg_getBasePtr "$LL_SPECULATIVE_O3"
		then
			echo "# using memtrack"
			local LIBMEMTRACK="$MEMTRACK_LL"
		else
			echo "# not using memtrack"
			local LIBMEMTRACK=
		fi

		$CC -mllvm -polly-use-scev-alias-checks -O3 "$LL_CANONICAL" $LIBMEMTRACK -ldl $LIBS -o "$SPECULATIVE_BENCHMARK"
	done
}

function run_benchmarks {
	echo "#### running"

	for BENCH in "${BENCH_LIST[@]}"
	do
			echo
			echo "BENCHMARK $BENCH"

		for MODE in "${MODES[@]}"
		do
			echo
			echo "MODE $MODE"

			ITERATIONS=$(benchmark_iterations "$BENCH")

			echo "# $ITERATIONS iteration(s)"

			for I in $(seq 1 "$ITERATIONS")
			do
				run_benchmark "$BENCH" "$MODE" "$BIN_DIR"/"$BENCH"-"$MODE"
			done
		done
	done
}

function check_bench_name {
	local NAME="$1"

	if benchmark_list | grep -q "$NAME"
	then
		true
	else
		_error "Unknown benchmark '$NAME'"
	fi
}

## helpers

function _error {
	>&2 echo "$@"
	exit 1
}

function _time {
	command time -f '%U' "$@"
}

function _pushd {
	command pushd "$@" > /dev/null
}

function _popd {
	command popd "$@" > /dev/null
}
