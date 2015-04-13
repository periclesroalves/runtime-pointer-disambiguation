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

function benchmark_src_files {
	local NAME="$1"

	case $NAME in
		## heartwall includes some .c files so just compiling all .c files
		## separately doesn't work here
		heartwall)
			find "$RODINIA_SRC_DIR/$NAME/AVI" -name '*.c'
			find "$RODINIA_SRC_DIR/$NAME" -name 'main.c'
			;;

		*)
			find "$RODINIA_SRC_DIR/$NAME" -name '*.c'
			find "$RODINIA_SRC_DIR/$NAME" -name '*.cpp'
			;;
	esac
}

function benchmark_include_dirs {
	local NAME="$1"

	case $NAME in
		heartwall)
			echo "-I$RODINIA_SRC_DIR/$NAME/AVI"
			;;

		*)
			true
			;;
	esac
}

function benchmark_flags {
	local NAME="$1"

	true
	# echo -I"$POLYBENCH_SRC_DIR"/utilities
	# echo -DPOLYBENCH_TIME
}

function run_benchmark {
	local NAME="$1"
	local MODE="$2"
	local BIN="$3"
	local DATA="$RODINIA_DATA_DIR"

	case $NAME in
		'b+tree')
			_time "$BIN" core 1 file "$DATA"/b+tree/mil.txt command "$DATA"/b+tree/command.txt 2>&1
			;;
		backprop)
			"$BIN" 65536 | get_elapsed_time
			;;

		bfs)
			_time "$BIN" 1 "$DATA"/bfs/graph1MW_6.txt 2>&1
			;;

		'hotspot')
			_time "$BIN" 512 512 2 1 "$DATA"/hotspot/temp_512 "$DATA"/hotspot/power_512  2>&1
			;;

		'particlefilter')
			"$BIN" -x 128 -y 128 -z 10 -np 10000 | get_elapsed_time
			;;

		'pathfinder')
			"$BIN" 100000 100 | get_elapsed_time
			;;

		'heartwall')
			_time "$BIN" "$DATA"/heartwall/test.avi 20 1 2>&1
			;;

		'kmeans')
			"$BIN" -i "$DATA"/kmeans/kdd_cup | get_elapsed_time
			;;

		'lavaMD')
			_time "$BIN" -cores 1 -boxes1d 10 2>&1
			;;

		'streamcluster')
			"$BIN" 10 20 256 65536 65536 1000 none output.txt 1 | get_elapsed_time
			;;

		*)
			_error "unknown benchmark '$NAME'"
			;;
	esac
}

function benchmark_iterations {
	local NAME="$1"

	case $NAME in
		# 'heartwall' | 'kmeans' | 'lavaMD' | 'streamcluster')
		# 	echo $SLOW_BENCH_ITERATIONS
		# 	;;
		*)
			echo $FAST_BENCH_ITERATIONS
			;;
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

function benchmark_sampling_rate {
	local NAME="$1"

	case $NAME in
		kmeans)
			echo "1000"
			;;

		streamcluster)
			echo "100000"
			;;

		*)
			echo "0"
			;;
	esac
}

## helpers

function get_elapsed_time {
	# find line that contains timing
	local TIME="$(grep "Elapsed time:")"

	# extract timing from line
	local REGEX='Elapsed time: ([^[:blank:]]+)'
    [[ $TIME =~ $REGEX ]]

    echo "${BASH_REMATCH[1]}"
}

## run main

main "$@"
