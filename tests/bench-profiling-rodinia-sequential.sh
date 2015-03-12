#!/bin/bash

set -o errexit
set -o nounset

. bench-profiling-common.sh

## CONFIGURATION

BIN_DIR=bin/rodinia-sequential

# set your local paths

RODINIA_SRC_DIR="$SRC_BASE"/tests/rodinia_3.0/sequential
RODINIA_DATA_DIR="$SRC_BASE"/tests/rodinia_3.0/data

## FUNCTIONS TO BUILD & RUN BENCHMARKS

function compile_benchmark {
	local NAME="$1"
	# local MODE="$2"
	local DST="$2"

	# _pushd "$RODINIA_SRC_DIR/$NAME"

	# should be split into CC and CC_FLAGS but rodinia's makefiles are not very clean
	export CC="$LLVM_BIN_DIR/clang"
	export CXX="$LLVM_BIN_DIR/clang++"

	case $NAME in
		## heartwall includes some .c files so just compiling all .c files
		## separately doesn't work here
		heartwall)
			local INCLUDE_DIRS="-I$RODINIA_SRC_DIR/$NAME/AVI"
			local C_FILES=( $(find "$RODINIA_SRC_DIR/$NAME/AVI" -name '*.c') $(find "$RODINIA_SRC_DIR/$NAME" -name 'main.c') )
			local CPP_FILES=()
			;;

		*)
			local INCLUDE_DIRS=""
			local C_FILES=( $(find "$RODINIA_SRC_DIR/$NAME" -name '*.c') )
			local CPP_FILES=( $(find "$RODINIA_SRC_DIR/$NAME" -name '*.cpp') )
			;;
	esac

	local LL_FILES=()

	for FILE in "${C_FILES[@]:+${C_FILES[@]}}"
	do
		echo "# $(basename $FILE)"
		local LL="$BIN_DIR/$(basename "$FILE" .c).ll"

		"$CC" "$FILE" $INCLUDE_DIRS -S -emit-llvm -o "$LL" -w

		LL_FILES+=( "$LL" )
	done
	for FILE in "${CPP_FILES[@]:+${CPP_FILES[@]}}"
	do
		echo "# $(basename $FILE)"
		local LL="$BIN_DIR/$(basename "$FILE" .cpp).ll"

		"$CXX" "$FILE" -S -emit-llvm -o "$LL" -w

		LL_FILES+=( "$LL" )
	done

	echo "# link"
	"$LLVM_LINK" "${LL_FILES[@]}" -o "$DST"
}

function run_benchmark {
	local NAME="$1"
	local MODE="$2"
	local BIN="$3"
	local DATA="$RODINIA_DATA_DIR"

	case $NAME in
		'b+tree')
			_time "$BIN" core 1 file "$DATA"/b+tree/mil.txt command "$DATA"/b+tree/command.txt > /dev/null
			;;
		backprop)
			_time "$BIN" 65536 > /dev/null
			;;

		bfs)
			_time "$BIN" 1 "$DATA"/bfs/graph1MW_6.txt > /dev/null
			;;

		'hotspot')
			_time "$BIN" 512 512 2 1 "$DATA"/hotspot/temp_512 "$DATA"/hotspot/power_512 > /dev/null
			;;

		'particlefilter')
			_time "$BIN" -x 128 -y 128 -z 10 -np 10000 > /dev/null
			;;

		'pathfinder')
			_time "$BIN" 100000 100 > /dev/null
			;;

		'heartwall')
			_time "$BIN" "$DATA"/heartwall/test.avi 20 1 > /dev/null
			;;

		'kmeans')
			_time "$BIN" -i "$DATA"/kmeans/kdd_cup > /dev/null
			;;

		'lavaMD')
			_time "$BIN" -cores 1 -boxes1d 10 > /dev/null
			;;

		'streamcluster')
			_time "$BIN" 10 20 256 65536 65536 1000 none output.txt 1 > /dev/null 2> /dev/null
			;;

		*)
			_error "unknown benchmark '$NAME'"
	esac
}

function benchmark_iterations {
	local NAME="$1"

	case $NAME in
		'b+tree' | 'backprop' | 'bfs' | 'hotspot' | 'particlefilter' | 'pathfinder')
			echo $FAST_BENCH_ITERATIONS
			;;

		'heartwall' | 'kmeans' | 'lavaMD' | 'streamcluster')
			echo $SLOW_BENCH_ITERATIONS
			;;
		*)
			_error "unknown benchmark '$NAME'"
	esac
}

function benchmark_libs {
	local NAME="$1"

	case $NAME in
		'b+tree' | backprop | particlefilter | heartwall | lavaMD)
			echo "-lm"
			;;
		*)
			;;
	esac
}

function benchmark_is_cpp {
	local NAME="$1"

	case $NAME in
		bfs | hotspot | pathfinder | streamcluster)
			true
			;;
		*)
			false
			;;
	esac
}

function benchmark_list {
	local LIST=(
		'b+tree'
		backprop
		bfs
		heartwall
		hotspot
		kmeans
		lavaMD
		particlefilter
		pathfinder
		streamcluster
	)

	for BENCH in "${LIST[@]}"
	do
		echo "$BENCH"
	done
}

## helpers

function benchmark_binary {
	local NAME="$1"

	case $NAME in
		'b+tree')
			echo 'b+tree.out'
			;;

		backprop | bfs | hotspot | pathfinder | heartwall | kmeans | lavaMD)
			echo "$NAME"
			;;

		'particlefilter')
			echo particle_filter
			;;

		'streamcluster')
			echo sc_omp
			;;

		*)
			_error "unknown benchmark '$NAME'"
	esac
}

## run main

main "$@"
