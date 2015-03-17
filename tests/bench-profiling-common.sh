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

CLANG_POLLY_FLAGS=( -Xclang -load -Xclang "$LLVM_LIB_DIR/LLVMPolly.so" -mllvm -polly )

## MAIN

function main {
	if [[ "$#" -eq 0 ]]
	then
		echo "Expected a command (one of: compile, benchmark, aa-eval, aa-profile)"
		exit 1
	fi
	local COMMAND="$1"
	shift 1

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

	case "$COMMAND" in
		compile)
			compile_libraries
			alias_profile_benchmarks
			compile_benchmarks
			;;
		benchmark)
			compile_libraries
			alias_profile_benchmarks
			compile_benchmarks
			run_benchmarks
			;;
		aa-eval)
			static_alias_analyis_benchmarks
			;;
		aa-profile)
			compile_libraries
			alias_profile_benchmarks
			;;
	esac
}

function compile_libraries {
	echo "##### compiling alias profiler"

	"$LLVM_LINK" -o "$MEMTRACK_LL" \
		<("$CLANG" -std=c11 -O3 -g -S -emit-llvm -I"$MEMTRACK_SRC" "$MEMTRACK_SRC/memtrack.c"       -o -) \
		<("$CLANG" -std=c11 -O3 -g -S -emit-llvm -I"$MEMTRACK_SRC" "$MEMTRACK_SRC/misc.c"           -o -) \
	;
	"$LLVM_LINK" -o "$ALIAS_PROFILER_LL" \
		"$BIN_DIR/memtrack.ll" \
		<("$CLANG" -std=c11 -O3 -g -S -emit-llvm -I"$MEMTRACK_SRC" "$MEMTRACK_SRC/alias_profiler.c" -o -) \
	;
}

function alias_profile_benchmarks {
	echo "##### alias-profiling"

	for BENCH in "${BENCH_LIST[@]}"
	do
		echo "### instrument $BENCH"

		local FILE="$BIN_DIR"/"$(basename "$BENCH")"

		local INSTRUMENTED_BENCHMARK="$FILE"-instrumented

		compile_benchmark "$BENCH" alias-profiling "$INSTRUMENTED_BENCHMARK"
	done

	for BENCH in "${BENCH_LIST[@]}"
	do
		echo "### profile $BENCH"

		local FILE="$BIN_DIR"/"$(basename "$BENCH")"

		local ALIAS_TRACE="$FILE"".alias.trace"
		local ALIAS_YAML="$FILE"".alias.yaml"  # processed trace file
		local INSTRUMENTED_BENCHMARK="$FILE"-instrumented

		echo "## run"
		export SAMPLING_RATE="$(benchmark_sampling_rate "$BENCH")"
		export TRACE_FILE="$ALIAS_TRACE"
		run_benchmark "$BENCH" alias-profiling "$INSTRUMENTED_BENCHMARK" >/dev/null

		echo "## aggregate trace"
		python3 "$HA_SRC_DIR/aggregate-alias-trace" "$ALIAS_TRACE" "$ALIAS_YAML"
	done
}

function compile_benchmarks {
	echo "##### compiling benchmarks"

	echo "#### compile normal"
	for BENCH in "${BENCH_LIST[@]}"
	do
		echo "### $BENCH"

		local FILE="$BIN_DIR"/"$(basename "$BENCH")"

		local BENCHMARK="$FILE"-normal

		#### create speculatively optimized version
		compile_benchmark "$BENCH" normal "$BENCHMARK"
	done

	echo "#### compile speculative"
	for BENCH in "${BENCH_LIST[@]}"
	do
		echo "### $BENCH"

		local FILE="$BIN_DIR"/"$(basename "$BENCH")"

		local ALIAS_YAML="$FILE"".alias.yaml"  # processed trace file
		local SPECULATIVE_BENCHMARK="$FILE"-speculative

		#### create speculatively optimized version
		compile_benchmark "$BENCH" speculative "$SPECULATIVE_BENCHMARK" "$ALIAS_YAML"
	done
}

function static_alias_analyis_benchmarks {
	echo "##### static alias eval"

	for BENCH in "${BENCH_LIST[@]}"
	do
		echo "### static alias eval $BENCH"

		local FILE="$BIN_DIR"/"$(basename "$BENCH")"

		local ALIAS_YAML="$FILE"".alias.yaml"  # processed trace file

		compile_benchmark "$BENCH" aa-eval "/dev/null" "$ALIAS_YAML"
	done
}

function run_benchmarks {
	echo "##### running"

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

function compile_benchmark {
	local NAME="$1"
	local MODE="$2"
	local DST="$3"

	### get information about benchmark
	local BENCH_INCLUDE_DIRS=( "$(benchmark_include_dirs "$BENCH")" )
	local BENCH_LIBRARIES=( "$(benchmark_libs "$BENCH")" )
	local BENCH_FLAGS=( "$(benchmark_flags "$BENCH")" )
	local SRC_FILES=( $(benchmark_src_files "$BENCH") )

	### decide which compiler flags to use
	local FLAGS=( -g )
	local LIBRARIES=()

	case "$MODE" in
		aa-eval)
			local ALIAS_YAML_FILE="$4"

			FLAGS+=(
				"${CLANG_POLLY_FLAGS[@]}" -O3
				-mllvm -polly-aa-eval
				-mllvm -polly-alias-profile-file="$ALIAS_YAML_FILE"
				-o /dev/null
			)
			;;

		alias-profiling)
			FLAGS+=( "${CLANG_POLLY_FLAGS[@]}" -O3 -mllvm -polly-use-alias-profiling )
			LIBRARIES+=( "$ALIAS_PROFILER_LL" -ldl )
			;;

		normal)
			FLAGS+=( "${CLANG_POLLY_FLAGS[@]}" -O3 )
			;;

		speculative)
			local ALIAS_YAML_FILE="$4"

			FLAGS+=(
				"${CLANG_POLLY_FLAGS[@]}" -O3
				# -mllvm -profiling-spec-aa ## broken in clang
				-mllvm -polly-use-scev-alias-checks
				-mllvm -polly-alias-profile-file="$ALIAS_YAML_FILE"
			)
			;;

		*)
			_error "Unknown mode '$MODE'"
			;;
	esac

	### compile src files to obj files
	local LINKER="$CLANG"
	local OBJ_FILES=()

	for SRC_FILE in "${SRC_FILES[@]}"
	do
		echo "# $(basename $SRC_FILE)"

		case "$SRC_FILE" in
			*.c)
				local SUFFIX=".c"
				local COMPILER="$CLANG"
				;;
			*.cpp)
				local SUFFIX=".cpp"
				local COMPILER="$CLANGXX"
				LINKER="$CLANGXX"
				;;
			*)
				_error "Can't compile file '$FILE'"
				;;
		esac

		local OBJ="$BIN_DIR/$(basename "$SRC_FILE" "$SUFFIX").o"

		"$COMPILER" \
			"${FLAGS[@]:-}" \
			"${BENCH_INCLUDE_DIRS[@]:-}" \
			"${BENCH_LIBRARIES[@]:-}" \
			"${BENCH_FLAGS[@]:-}" \
			-c -w \
			"$SRC_FILE" -o "$OBJ"

		OBJ_FILES+=( "$OBJ" )
	done

	if [[ "$MODE" != aa-eval ]]
	then
		# only link in memtrack if it is actually needed
		if nm "${OBJ_FILES[@]}" | grep -q 'U gcg_getBasePtr' \
			&& [[ "$MODE" != alias-profiling ]]
		then
			echo "# linking in memtrack"
			LIBRARIES+=( "$MEMTRACK_LL" -ldl )
		fi

		echo "# link"
		"$LINKER" "${OBJ_FILES[@]}" "${LIBRARIES[@]:-}" "${BENCH_LIBRARIES:-}" -o "$DST"
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
