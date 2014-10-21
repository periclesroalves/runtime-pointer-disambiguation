cmake_minimum_required(VERSION 2.8)

## list of benchmarks

set(BENCHMARKS
	b.cpp
	double_memset.cpp
)

## split command line args because add_custom_command excepts a list
if (WIN32)
	separate_arguments(cxx_flags WINDOWS_COMMAND "${CMAKE_CXX_FLAGS}")
else()
	separate_arguments(cxx_flags UNIX_COMMAND    "${CMAKE_CXX_FLAGS}")
endif()

### FIND EXECUTABLES USED BY BUILD

## find LLVMs opt

if("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
	# use a debug version of opt, if possible
	find_program(OPT "opt-dbg" PATH "${LLVM_TOOLS_BINARY_DIR}")

	if ("${OPT}" EQUAL "${OPT-NOTFOUND}")
		find_program(OPT "opt" PATH "${LLVM_TOOLS_BINARY_DIR}")
	endif()
else()
	find_program(OPT "opt" PATH "${LLVM_TOOLS_BINARY_DIR}")
endif()

find_program(PYTHON3 "python3")

### DEFINE INDIVIDUAL BENCHMARKS

set(IR_files) # contains names of instrumented .ll files

### add benchmarks to main benchmark executable
## the individual benchmarks will be processed by alias-tracer etc.
#function(add_benchmark cpp_file)
foreach(cpp_file ${BENCHMARKS})
	set(INSTRUMENT_PLUGIN "${CMAKE_BINARY_DIR}/instrumentation/libinstrument-loop.so")
	set(OPTIMIZE_PLUGIN   "${CMAKE_BINARY_DIR}/ilc/libILC.so")

	get_filename_component(basename "${cpp_file}" NAME_WE)

	set(LL_UNOPTIMIZED      "${cpp_file}.ll")
	set(LL_INPUT            "${cpp_file}.input.ll") # mem2reg and instnamer have been run
	set(LL_INSTRUMENTED     "${cpp_file}.instrumented.ll")
	set(LL_INSTRUMENTED_O3  "${cpp_file}.instrumented.O3.ll")
	set(LL_SPECULATIVE      "${cpp_file}.speculative.ll")
	set(LL_SPECULATIVE_O3   "${cpp_file}.speculative.O3.ll")

	set(PLAIN_BENCHMARK        "bench-${basename}")
	set(INSTRUMENTED_BENCHMARK "bench-${basename}-instrumented")
	set(SPECULATIVE_BENCHMARK  "bench-${basename}-optimized")

	set(ALIAS_TRACE "${cpp_file}.alias.trace")
	set(ALIAS_YAML  "${cpp_file}.alias.yaml")  # processed trace file

	## command that generates instrumented benchmark

	add_custom_command(
		OUTPUT  "${PLAIN_BENCHMARK}" "${INSTRUMENTED_BENCHMARK}" "${LL_UNOPTIMIZED}" "${LL_INPUT}" "${LL_INSTRUMENTED}" "${LL_INSTRUMENTED_O3}"
		## compile .cpp to unoptimized .ll
		COMMAND ${CMAKE_CXX_COMPILER} ${cxx_flags} -S -emit-llvm -I${CMAKE_CURRENT_SOURCE_DIR} "${CMAKE_CURRENT_SOURCE_DIR}/${cpp_file}" -o "${LL_UNOPTIMIZED}"
		## mem2reg and instnamer are required by our instrumentation pass
		COMMAND "${OPT}" "${LL_UNOPTIMIZED}" -S -mem2reg -instnamer > "${LL_INPUT}"
		## created instrumented .ll
		COMMAND "${OPT}" "${LL_INPUT}" -load=${INSTRUMENT_PLUGIN} -S -mem2reg -instnamer -alias-instrument-loops -instrument-only=AA_ > "${LL_INSTRUMENTED}"
		## optimize instrumented .ll
		COMMAND "${OPT}" "${LL_INSTRUMENTED}"                     -S -O3                                                              > "${LL_INSTRUMENTED_O3}"
		## link benchmark executables
		COMMAND ${CMAKE_CXX_COMPILER} ${cxx_flags} -O3 "${CMAKE_CURRENT_SOURCE_DIR}/${cpp_file}"  "${CMAKE_CURRENT_SOURCE_DIR}/benchmark.cpp" -lbenchmark -lpthread "${CMAKE_CURRENT_SOURCE_DIR}/bench_util.cpp"                                                                                         -o "${PLAIN_BENCHMARK}"
		COMMAND ${CMAKE_CXX_COMPILER} ${cxx_flags} -O3 "${LL_INSTRUMENTED_O3}"                    "${CMAKE_CURRENT_SOURCE_DIR}/benchmark.cpp" -lbenchmark -lpthread "${CMAKE_CURRENT_SOURCE_DIR}/bench_util.cpp" "-Wl,-rpath,${CMAKE_BINARY_DIR}/runtime/" "-L${CMAKE_BINARY_DIR}/runtime/" "-lmemtrack" -o "${INSTRUMENTED_BENCHMARK}"
		DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/${cpp_file}"
		        "${CMAKE_CURRENT_SOURCE_DIR}/benchmark.cpp"
		        "${CMAKE_CURRENT_SOURCE_DIR}/bench_util.hpp"
		        "${CMAKE_CURRENT_SOURCE_DIR}/bench_util.cpp"
		        instrument-loop
		        memtrack
		VERBATIM
	)

	## command that generates trace file

	add_custom_command(
		OUTPUT  "${ALIAS_TRACE}"
		## run instrumented benchmark
		COMMAND env "TRACE_FILE=${ALIAS_TRACE}" "${CMAKE_BINARY_DIR}/benchmark/${INSTRUMENTED_BENCHMARK}"

		DEPENDS "${INSTRUMENTED_BENCHMARK}"
		VERBATIM
	)

	## command that analyses trace file

	add_custom_command(
		OUTPUT  "${ALIAS_YAML}"

		## run instrumented benchmark
		COMMAND "${PYTHON3}" "${PROJECT_SOURCE_DIR}/aggregate-alias-trace.py" "${ALIAS_TRACE}" > "${ALIAS_YAML}"

		DEPENDS "${ALIAS_TRACE}"
		VERBATIM
	)

	## command that generates speculatively optimized benchmark

	add_custom_command(
		OUTPUT  "${SPECULATIVE_BENCHMARK}" "${LL_SPECULATIVE}" "${LL_SPECULATIVE_O3}"

		## created speculatively optimized .ll
		COMMAND "${OPT}" "${LL_INPUT}" -load=${OPTIMIZE_PLUGIN} -S -mem2reg -instnamer -clone-loop -clone-only=AA_ "-trace-file=${ALIAS_YAML}" > "${LL_SPECULATIVE}"
		## run speculatively optimized .ll through O3
		COMMAND "${OPT}" "${LL_SPECULATIVE}"                    -S -O3                                                                         > "${LL_SPECULATIVE_O3}"
		## link benchmark executables
		COMMAND ${CMAKE_CXX_COMPILER} ${cxx_flags} -O3 "${LL_SPECULATIVE_O3}" "${CMAKE_CURRENT_SOURCE_DIR}/benchmark.cpp" -lbenchmark -lpthread "${CMAKE_CURRENT_SOURCE_DIR}/bench_util.cpp" "-Wl,-rpath,${CMAKE_BINARY_DIR}/runtime/" "-L${CMAKE_BINARY_DIR}/runtime/" -lmemtrack -o "${SPECULATIVE_BENCHMARK}"

		DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/${cpp_file}"
		        "${CMAKE_CURRENT_SOURCE_DIR}/benchmark.cpp"
		        "${CMAKE_CURRENT_SOURCE_DIR}/bench_util.hpp"
		        "${CMAKE_CURRENT_SOURCE_DIR}/bench_util.cpp"
		        "${LL_INPUT}"
		        "${ALIAS_YAML}"
		        ILC
		        memtrack
		VERBATIM
	)

	add_custom_target("mk-${SPECULATIVE_BENCHMARK}" ALL DEPENDS "${SPECULATIVE_BENCHMARK}")

	list(APPEND IR_files "${LL_INSTRUMENTED_O3}")
endforeach()

#message(FATAL_ERROR ">> ${IR_files}")

### DEFINE MAIN BENCHMARK EXECUTABLE

#add_custom_command(
#	OUTPUT  benchmark
#	COMMAND ${CMAKE_CXX_COMPILER} ${cxx_flags} "${CMAKE_CURRENT_SOURCE_DIR}/benchmark.cpp"
#	        -lbenchmark -lpthread
#	        ${IR_files} "${CMAKE_BINARY_DIR}/runtime/libmemtrack.a"
#			"${CMAKE_CURRENT_SOURCE_DIR}/bench_util.cpp"
#			-o benchmark
#	DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/benchmark.cpp"
#	        "${CMAKE_CURRENT_SOURCE_DIR}/bench_util.hpp"
#	        "${CMAKE_CURRENT_SOURCE_DIR}/bench_util.cpp"
#	        ${IR_files}
#	        memtrack
#	VERBATIM
#)
#add_custom_target(bench ALL DEPENDS benchmark)

### TARGET THAT RUNS INSTRUMENTED BENCHMARKS AND GENERATES OPTIMIZED VERSIONS

#add_custom_target(gen_opt
#	COMMAND for $F in  "${CMAKE_BINARY_DIR}/
#	DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/benchmark.cpp"
#	        "${CMAKE_CURRENT_SOURCE_DIR}/bench_util.hpp"
#	        "${CMAKE_CURRENT_SOURCE_DIR}/bench_util.cpp"
#	        ${IR_files}
#	        memtrack
#	VERBATIM
#)

