# This file is distributed under the Modified BSD Open Source License.
# See LICENSE.TXT for details.

cmake_minimum_required(VERSION 2.8)

## list of benchmarks

set(BENCHMARKS
	b.cpp
	bad_alias.cpp
	copy.cpp
	double_memset.cpp
	dotprod.cpp
	fft.cpp
	sum.cpp
)

## split command line args because add_custom_command excepts a list
if (WIN32)
	separate_arguments(cxx_flags WINDOWS_COMMAND "${CMAKE_CXX_FLAGS}")
else()
	separate_arguments(cxx_flags UNIX_COMMAND    "${CMAKE_CXX_FLAGS}")
endif()

### FIND EXECUTABLES USED BY BUILD

## find LLVM tools

find_program(OPT              "opt"              NO_DEFAULT_PATH PATHS "${LLVM_TOOLS_BINARY_DIR}")
find_program(ALIAS_INSTRUMENT "alias-instrument" NO_DEFAULT_PATH PATHS "${LLVM_TOOLS_BINARY_DIR}")

if ("${OPT}" STREQUAL "OPT-NOTFOUND")
	message(FATAL_ERROR "Could not find opt executable")
endif()

if ("${ALIAS_INSTRUMENT}" STREQUAL "ALIAS_INSTRUMENT-NOTFOUND")
	message(FATAL_ERROR "Could not find alias-instrument executable")
endif()

## find python

find_program(PYTHON3 "python3")

if ("${PYTHON3}" STREQUAL "PYTHON3-NOTFOUND")
	message(FATAL_ERROR "Could not find python3 executable")
endif()

### DEFINE INDIVIDUAL BENCHMARKS

add_library(bench_util STATIC benchmark.cpp bench_util.cpp)

foreach(CPP_FILE ${BENCHMARKS})
	get_filename_component(basename "${CPP_FILE}" NAME_WE)

	set(LL_UNOPTIMIZED           "${CPP_FILE}.ll")
	set(LL_INPUT                 "${CPP_FILE}.input.ll") # mem2reg has been run
	set(LL_INPUT_O3              "${CPP_FILE}.input.O3.ll")
	set(LL_INPUT_PERF            "${CPP_FILE}.input.perf.ll")
	set(LL_INPUT_PERF_O3         "${CPP_FILE}.input.perf.O3.ll")
	set(LL_INSTRUMENTED          "${CPP_FILE}.instrumented.ll")
	set(LL_INSTRUMENTED_O3       "${CPP_FILE}.instrumented.O3.ll")
	set(LL_SPECULATIVE           "${CPP_FILE}.speculative.ll")
	set(LL_SPECULATIVE_O3        "${CPP_FILE}.speculative.O3.ll")
	set(LL_SPECULATIVE_PERF      "${CPP_FILE}.speculative.perf.ll")
	set(LL_SPECULATIVE_PERF_O3   "${CPP_FILE}.speculative.perf.O3.ll")
	set(LL_FINAL                 "${CPP_FILE}.final.ll")
	set(LL_FINAL_O3              "${CPP_FILE}.final.O3.ll")

	set(S_INPUT_O3             "${CPP_FILE}.input.O3.s")
	set(S_INPUT_PERF_O3        "${CPP_FILE}.input.perf.O3.s")
	set(S_SPECULATIVE_O3       "${CPP_FILE}.speculative.O3.s")
	set(S_SPECULATIVE_PERF_O3  "${CPP_FILE}.speculative.perf.O3.s")

	set(BENCHMARK                  "bench-${basename}")
	set(PERF_BENCHMARK             "bench-${basename}-perf")
	set(INSTRUMENTED_BENCHMARK     "bench-${basename}-instrumented")
	set(SPECULATIVE_BENCHMARK      "bench-${basename}-speculative")
	set(SPECULATIVE_PERF_BENCHMARK "bench-${basename}-perf-speculative")
	set(FINAL_BENCHMARK            "bench-${basename}-final")

	set(ALIAS_TRACE             "${CPP_FILE}.alias.trace")
	set(ALIAS_YAML              "${CPP_FILE}.alias.yaml")  # processed trace file
	set(ALIAS_YAML_FILTERED     "${CPP_FILE}.filtered.alias.yaml")
	set(CLONEINFO_YAML          "${CPP_FILE}.cloneInfo.yaml")
	set(CLONEINFO_YAML_FILTERED "${CPP_FILE}.cloneInfo.filtered.yaml")
	set(INPUT_PERF_TRACE        "${CPP_FILE}.input.perf.trace")
	set(SPECULATIVE_PERF_TRACE  "${CPP_FILE}.speculative.perf.trace")

	set(CLONED_REGION_FILE "${CPP_FILE}.cloned_regions")

	#### command that generates instrumented benchmark

	## compile .cpp to unoptimized .ll
	add_custom_command(
		OUTPUT "${LL_UNOPTIMIZED}"
		COMMAND ${CLANGXX} ${cxx_flags} -S -emit-llvm "-I${CMAKE_CURRENT_SOURCE_DIR}" "-I${PROJECT_SOURCE_DIR}/google-benchmark/include" "${CMAKE_CURRENT_SOURCE_DIR}/${CPP_FILE}" -o "${LL_UNOPTIMIZED}"
		DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/${CPP_FILE}"
		VERBATIM
	)

	## apply passes required for cloning
	add_custom_command(
		OUTPUT  "${LL_INPUT}"
		COMMAND "$<TARGET_FILE:canonicalize>" "${LL_UNOPTIMIZED}" -o "${LL_INPUT}"
		DEPENDS "${LL_UNOPTIMIZED}" canonicalize
		VERBATIM
	)

	## created instrumented .ll
	add_custom_command(
		OUTPUT  "${LL_INSTRUMENTED}"
		COMMAND "${ALIAS_INSTRUMENT}" "${LL_INPUT}" -instrument-only=AA_ -o "${LL_INSTRUMENTED}"
		DEPENDS "${LL_INPUT}" alias-instrument
		VERBATIM
	)

	## optimize .ll files
	add_custom_command(
		OUTPUT  "${LL_INPUT_O3}"
		COMMAND "${OPT}" "${LL_INPUT}" -S -O3 -o "${LL_INPUT_O3}"
		DEPENDS "${LL_INPUT}"
		VERBATIM
	)
	add_custom_command(
		OUTPUT  "${LL_INSTRUMENTED_O3}"
		COMMAND "${OPT}" "${LL_INSTRUMENTED}" -S -O3 -o "${LL_INSTRUMENTED_O3}"
		DEPENDS "${LL_INSTRUMENTED}"
		VERBATIM
	)

	## .ll -> .s
	add_custom_command(
		OUTPUT  "${S_INPUT_O3}"
		COMMAND ${CLANGXX} ${cxx_flags} -O3 "${LL_INPUT_O3}" -S -o "${S_INPUT_O3}"
		DEPENDS "${LL_INPUT_O3}"
		VERBATIM
	)

	## link benchmark executables
	add_custom_command(
		OUTPUT  "${BENCHMARK}"
		COMMAND ${CLANGXX} ${cxx_flags} -O3 "${LL_INPUT_O3}" "$<TARGET_LINKER_FILE:benchmark>" "$<TARGET_LINKER_FILE:bench_util>" -lpthread -o "${BENCHMARK}"
		DEPENDS "${LL_INPUT_O3}"
		        benchmark
		        bench_util
		VERBATIM
	)
	add_custom_command(
		OUTPUT  "${INSTRUMENTED_BENCHMARK}"
		COMMAND ${CLANGXX} ${cxx_flags} -O3 "${LL_INSTRUMENTED_O3}" "$<TARGET_LINKER_FILE:benchmark>" "$<TARGET_LINKER_FILE:bench_util>" -lpthread "-Wl,-rpath,${CMAKE_BINARY_DIR}/runtime/" "-L${CMAKE_BINARY_DIR}/runtime/" -lmemtrack -o "${INSTRUMENTED_BENCHMARK}"
		DEPENDS "${LL_INSTRUMENTED_O3}"
		        memtrack
		        benchmark
		        bench_util
		VERBATIM
	)

	## command that generates trace file

	# alias trace
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
		COMMAND "${PYTHON3}" "${PROJECT_SOURCE_DIR}/aggregate-alias-trace" "${ALIAS_TRACE}" "${ALIAS_YAML}"
		DEPENDS "${ALIAS_TRACE}"
		        "${PROJECT_SOURCE_DIR}/aggregate-alias-trace"
		VERBATIM
	)

	#### command that generates speculatively optimized benchmark

	## create speculatively optimized .ll
	add_custom_command(
		OUTPUT  "${LL_SPECULATIVE}" "${CLONEINFO_YAML}"
		COMMAND rm -f "${CLONEINFO_YAML}"
		COMMAND "$<TARGET_FILE:clone-loops>" "${LL_INPUT}" "${ALIAS_YAML}" -clone-only=AA_ "-clonedLoops-file=${CLONEINFO_YAML}" -o "${LL_SPECULATIVE}"
		DEPENDS "${LL_INPUT}"
		        "${ALIAS_YAML}"
		        clone-loops
		VERBATIM
	)

	## run .ll through O3
	add_custom_command(
		OUTPUT  "${LL_SPECULATIVE_O3}"
		COMMAND "${OPT}" "${LL_SPECULATIVE}" -S -O3 -o "${LL_SPECULATIVE_O3}"
		DEPENDS "${LL_SPECULATIVE}"
		VERBATIM
	)

	## .ll -> .s
	# COMMAND ${CLANGXX} ${cxx_flags} -O3 "${LL_SPECULATIVE_O3}"       -S -o "${S_SPECULATIVE_O3}"
	# COMMAND ${CLANGXX} ${cxx_flags} -O3 "${LL_INPUT_PERF_O3}"        -S -o "${S_INPUT_PERF_O3}"
	# COMMAND ${CLANGXX} ${cxx_flags} -O3 "${LL_SPECULATIVE_PERF_O3}"  -S -o "${S_SPECULATIVE_PERF_O3}"

	## link benchmark executables
	add_custom_command(
		OUTPUT  "${SPECULATIVE_BENCHMARK}"
		COMMAND ${CLANGXX} ${cxx_flags} -O3 "${LL_SPECULATIVE_O3}" "$<TARGET_LINKER_FILE:benchmark>" "$<TARGET_LINKER_FILE:bench_util>" -lpthread "-Wl,-rpath,$<TARGET_LINKER_FILE_DIR:memtrack>" "-L$<TARGET_LINKER_FILE_DIR:memtrack>" -lmemtrack -o "${SPECULATIVE_BENCHMARK}"
		DEPENDS "${LL_SPECULATIVE_O3}"
		        memtrack
		        benchmark
		        bench_util
		VERBATIM
	)

	#### instrument for performance profiling

	## instrument for performance profiling

	add_custom_command(
		OUTPUT  "${LL_INPUT_PERF}" "${LL_SPECULATIVE_PERF}"
		COMMAND "$<TARGET_FILE:perf-instrument>" "${LL_INPUT}" "${LL_SPECULATIVE}" "${CLONEINFO_YAML}"
		DEPENDS perf-instrument
		        "${LL_INPUT}"
		        "${LL_SPECULATIVE}"
		        "${ALIAS_YAML}"
		VERBATIM
	)

	## run .ll through O3
	add_custom_command(
		OUTPUT  "${LL_INPUT_PERF_O3}"
		COMMAND "${OPT}" "${LL_INPUT_PERF}" -S -O3 -o "${LL_INPUT_PERF_O3}"
		DEPENDS "${LL_INPUT_PERF}"
		VERBATIM
	)
	add_custom_command(
		OUTPUT  "${LL_SPECULATIVE_PERF_O3}"
		COMMAND "${OPT}" "${LL_SPECULATIVE_PERF}" -S -O3 -o "${LL_SPECULATIVE_PERF_O3}"
		DEPENDS "${LL_SPECULATIVE_PERF}"
		VERBATIM
	)

	## link perf instrumented benchmarks
	add_custom_command(
		OUTPUT  "${PERF_BENCHMARK}"
		COMMAND ${CLANGXX} ${cxx_flags} -O3 "${LL_INPUT_PERF_O3}" "$<TARGET_LINKER_FILE:perf>" "$<TARGET_LINKER_FILE:benchmark>" "$<TARGET_LINKER_FILE:bench_util>" -lpthread "-Wl,-rpath,$<TARGET_LINKER_FILE_DIR:perf>" "-L$<TARGET_LINKER_FILE_DIR:perf>" -lperf -o "${PERF_BENCHMARK}"
		DEPENDS "${LL_INPUT_PERF_O3}"
		        bench_util
		        benchmark
		VERBATIM
	)
	add_custom_command(
		OUTPUT  "${SPECULATIVE_PERF_BENCHMARK}"
		COMMAND ${CLANGXX} ${cxx_flags} -O3 "${LL_SPECULATIVE_PERF_O3}" "$<TARGET_LINKER_FILE:perf>" "$<TARGET_LINKER_FILE:benchmark>" "$<TARGET_LINKER_FILE:bench_util>" -lpthread "-Wl,-rpath,$<TARGET_LINKER_FILE_DIR:memtrack>" "-L$<TARGET_LINKER_FILE_DIR:memtrack>" -lmemtrack "-Wl,-rpath,$<TARGET_LINKER_FILE_DIR:perf>" "-L$<TARGET_LINKER_FILE_DIR:perf>" -lperf -o "${SPECULATIVE_PERF_BENCHMARK}"
		DEPENDS "${LL_SPECULATIVE_PERF_O3}"
		        bench_util
		        benchmark
		        memtrack
		VERBATIM
	)

	## run perf instrumented benchmarks
	add_custom_command(
		OUTPUT  "${INPUT_PERF_TRACE}"
		COMMAND env "TRACE_FILE=${INPUT_PERF_TRACE}" "${CMAKE_BINARY_DIR}/benchmark/${PERF_BENCHMARK}"
		DEPENDS "${PERF_BENCHMARK}"
		VERBATIM
	)
	add_custom_command(
		OUTPUT  "${SPECULATIVE_PERF_TRACE}"
		COMMAND env "TRACE_FILE=${SPECULATIVE_PERF_TRACE}" "${CMAKE_BINARY_DIR}/benchmark/${SPECULATIVE_PERF_BENCHMARK}"
		DEPENDS "${SPECULATIVE_PERF_BENCHMARK}"
		VERBATIM
	)

	## filter alias.yaml with perf profiling data
	add_custom_command(
		OUTPUT  "${ALIAS_YAML_FILTERED}"
		COMMAND "${PYTHON3}" "${PROJECT_SOURCE_DIR}/aggregate-time-and-alias-trace" "${ALIAS_YAML}" "${INPUT_PERF_TRACE}" "${SPECULATIVE_PERF_TRACE}" "${ALIAS_YAML_FILTERED}"
		DEPENDS "${PROJECT_SOURCE_DIR}/aggregate-time-and-alias-trace"
		        "${ALIAS_YAML}" "${INPUT_PERF_TRACE}" "${SPECULATIVE_PERF_TRACE}"
		VERBATIM
	)

	## do cloning with filtered alias data
	add_custom_command(
		OUTPUT  "${LL_FINAL}"
		COMMAND rm -f "${CLONEINFO_YAML_FILTERED}"
		COMMAND "$<TARGET_FILE:clone-loops>" "${LL_INPUT}" "${ALIAS_YAML_FILTERED}" -clone-only=AA_ "-clonedLoops-file=${CLONEINFO_YAML_FILTERED}" -o "${LL_FINAL}"
		DEPENDS "${LL_INPUT}"
		        "${ALIAS_YAML_FILTERED}"
		        clone-loops
		VERBATIM
	)

	## run .ll through O3
	add_custom_command(
		OUTPUT  "${LL_FINAL_O3}"
		COMMAND "${OPT}" "${LL_FINAL}" -S -O3 -o "${LL_FINAL_O3}"
		DEPENDS "${LL_FINAL}"
		VERBATIM
	)

	## link final executable
	add_custom_command(
		OUTPUT  "${FINAL_BENCHMARK}"
		COMMAND ${CLANGXX} ${cxx_flags} -O3 "${LL_FINAL_O3}" "$<TARGET_LINKER_FILE:benchmark>" "$<TARGET_LINKER_FILE:bench_util>" -lpthread "-Wl,-rpath,$<TARGET_LINKER_FILE_DIR:memtrack>" "-L$<TARGET_LINKER_FILE_DIR:memtrack>" -lmemtrack -o "${FINAL_BENCHMARK}"
		DEPENDS "${LL_FINAL_O3}"
		        memtrack
		        benchmark
		        bench_util
		VERBATIM
	)

	## .ll -> .s
	# COMMAND ${CLANGXX} ${cxx_flags} -O3 "${LL_SPECULATIVE_O3}"       -S -o "${S_SPECULATIVE_O3}"
	# COMMAND ${CLANGXX} ${cxx_flags} -O3 "${LL_INPUT_PERF_O3}"        -S -o "${S_INPUT_PERF_O3}"
	# COMMAND ${CLANGXX} ${cxx_flags} -O3 "${LL_SPECULATIVE_PERF_O3}"  -S -o "${S_SPECULATIVE_PERF_O3}"

	## add to global list of benchmark executables
	add_custom_target("${basename}" DEPENDS "${BENCHMARK}" "${SPECULATIVE_BENCHMARK}" "${FINAL_BENCHMARK}")
	list(APPEND BENCHMARKS "${basename}")

	## add test for benchmarks base ptrs
	# you have to create this file by hand!
	set(EXPECTED_BASE_PTR_YAML "${CPP_FILE}.base-ptrs.yaml")

	configure_file("${EXPECTED_BASE_PTR_YAML}" "${EXPECTED_BASE_PTR_YAML}")

	add_test("${CPP_FILE}.base-ptrs" check-base-ptrs "${LL_INPUT}" "${EXPECTED_BASE_PTR_YAML}")
endforeach()

#### target that builds all benchmarks
add_custom_target(bench DEPENDS ${BENCHMARKS})

#message(FATAL_ERROR ">> ${IR_files}")

### DEFINE MAIN BENCHMARK EXECUTABLE

#add_custom_command(
#	OUTPUT  benchmark
#	COMMAND ${CLANGXX} ${cxx_flags} "${CMAKE_CURRENT_SOURCE_DIR}/benchmark.cpp"
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

### TESTING

# copy utilities to bin dir
configure_file(yamleq          yamleq)
configure_file(check-base-ptrs check-base-ptrs)
