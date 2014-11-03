cmake_minimum_required(VERSION 2.8)

## list of benchmarks

set(BENCHMARKS
	b.cpp
	bad_alias.cpp
	copy.cpp
	double_memset.cpp
	dotprod.cpp
	fft.cpp
)

## split command line args because add_custom_command excepts a list
if (WIN32)
	separate_arguments(cxx_flags WINDOWS_COMMAND "${CMAKE_CXX_FLAGS}")
else()
	separate_arguments(cxx_flags UNIX_COMMAND    "${CMAKE_CXX_FLAGS}")
endif()

### FIND EXECUTABLES USED BY BUILD

## find LLVMs opt

find_program(OPT "opt" NO_DEFAULT_PATH PATHS "${LLVM_TOOLS_BINARY_DIR}")

if ("${OPT}" STREQUAL "${OPT-NOTFOUND}")
	message(FATAL_ERROR "Could not find opt executable")
endif()

## find python

find_program(PYTHON3 "python3")

if ("${PYTHON3}" STREQUAL "${PYTHON3-NOTFOUND}")
	message(FATAL_ERROR "Could not find python3 executable")
endif()

### DEFINE INDIVIDUAL BENCHMARKS

set(IR_files) # contains names of instrumented .ll files

### add benchmarks to main benchmark executable
## the individual benchmarks will be processed by alias-tracer etc.
#function(add_benchmark cpp_file)
foreach(cpp_file ${BENCHMARKS})
	set(PASS_LIB "${CMAKE_BINARY_DIR}/ilc/libILC.so")

	get_filename_component(basename "${cpp_file}" NAME_WE)

	set(LL_UNOPTIMIZED      "${cpp_file}.ll")
	set(LL_INPUT            "${cpp_file}.input.ll") # mem2reg has been run
	set(LL_INPUT_O3         "${cpp_file}.input.O3.ll")
	set(LL_INSTRUMENTED     "${cpp_file}.instrumented.ll")
	set(LL_INSTRUMENTED_O3  "${cpp_file}.instrumented.O3.ll")
	set(LL_SPECULATIVE      "${cpp_file}.speculative.ll")
	set(LL_SPECULATIVE_O3   "${cpp_file}.speculative.O3.ll")

	set(S_INPUT_O3       "${cpp_file}.input.O3.s")
	set(S_SPECULATIVE_O3 "${cpp_file}.speculative.O3.s")

	set(PLAIN_BENCHMARK        "bench-${basename}")
	set(INSTRUMENTED_BENCHMARK "bench-${basename}-instrumented")
	set(SPECULATIVE_BENCHMARK  "bench-${basename}-optimized")

	set(ALIAS_TRACE "${cpp_file}.alias.trace")
	set(ALIAS_YAML  "${cpp_file}.alias.yaml")  # processed trace file

	## command that generates instrumented benchmark

	add_custom_command(
		OUTPUT  "${PLAIN_BENCHMARK}" "${INSTRUMENTED_BENCHMARK}" "${LL_UNOPTIMIZED}" "${LL_INPUT}" "${LL_INPUT_O3}" "${LL_INSTRUMENTED}" "${LL_INSTRUMENTED_O3}"
		## compile .cpp to unoptimized .ll
		COMMAND ${CMAKE_CXX_COMPILER} ${cxx_flags} -S -emit-llvm -I${CMAKE_CURRENT_SOURCE_DIR} "${CMAKE_CURRENT_SOURCE_DIR}/${cpp_file}" -o "${LL_UNOPTIMIZED}"
		## mem2reg makes IR more readable
		COMMAND "${OPT}" "${LL_UNOPTIMIZED}" -S -mem2reg -instnamer > "${LL_INPUT}"
		## created instrumented .ll
		COMMAND "${OPT}" "${LL_INPUT}" -load=${PASS_LIB} -S -trace-loop-alias -instrument-only=AA_       > "${LL_INSTRUMENTED}"
		## optimize .ll files
		COMMAND "${OPT}" "${LL_INPUT}"                   -S -O3                                          > "${LL_INPUT_O3}"
		COMMAND "${OPT}" "${LL_INSTRUMENTED}"            -S -O3                                          > "${LL_INSTRUMENTED_O3}"
		## .ll -> .s
		COMMAND ${CMAKE_CXX_COMPILER} ${cxx_flags} -O3 "${LL_INPUT_O3}" -S -o "${S_INPUT_O3}"
		## link benchmark executables
		COMMAND ${CMAKE_CXX_COMPILER} ${cxx_flags} -O3 "${LL_INPUT_O3}"        "${CMAKE_CURRENT_SOURCE_DIR}/benchmark.cpp" -lbenchmark -lpthread "${CMAKE_CURRENT_SOURCE_DIR}/bench_util.cpp"                                                                                         -o "${PLAIN_BENCHMARK}"
		COMMAND ${CMAKE_CXX_COMPILER} ${cxx_flags} -O3 "${LL_INPUT_O3}"        "${CMAKE_CURRENT_SOURCE_DIR}/benchmark.cpp" -lbenchmark -lpthread "${CMAKE_CURRENT_SOURCE_DIR}/bench_util.cpp"                                                                                         -o "${PLAIN_BENCHMARK}"
		COMMAND ${CMAKE_CXX_COMPILER} ${cxx_flags} -O3 "${LL_INSTRUMENTED_O3}" "${CMAKE_CURRENT_SOURCE_DIR}/benchmark.cpp" -lbenchmark -lpthread "${CMAKE_CURRENT_SOURCE_DIR}/bench_util.cpp" "-Wl,-rpath,${CMAKE_BINARY_DIR}/runtime/" "-L${CMAKE_BINARY_DIR}/runtime/" "-lmemtrack" -o "${INSTRUMENTED_BENCHMARK}"
		DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/${cpp_file}"
		        "${CMAKE_CURRENT_SOURCE_DIR}/benchmark.cpp"
		        "${CMAKE_CURRENT_SOURCE_DIR}/bench_util.hpp"
		        "${CMAKE_CURRENT_SOURCE_DIR}/bench_util.cpp"
		        ILC
		        memtrack
		VERBATIM
	)

	## command that generates trace file

	add_custom_command(
		OUTPUT  "${ALIAS_TRACE}"
		## run instrumented benchmark
		COMMAND env "TRACE_FILE=${ALIAS_TRACE}" "${CMAKE_BINARY_DIR}/benchmark/${INSTRUMENTED_BENCHMARK}"

		DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/${cpp_file}"
		        "${INSTRUMENTED_BENCHMARK}"
		        ILC
		VERBATIM
	)

	## command that analyses trace file

	add_custom_command(
		OUTPUT  "${ALIAS_YAML}"

		## run instrumented benchmark
		COMMAND "${PYTHON3}" "${PROJECT_SOURCE_DIR}/aggregate-alias-trace.py" "${ALIAS_TRACE}" > "${ALIAS_YAML}"

		DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/${cpp_file}"
		        "${ALIAS_TRACE}"
		        ILC
		VERBATIM
	)

	## command that generates speculatively optimized benchmark

	add_custom_command(
		OUTPUT  "${SPECULATIVE_BENCHMARK}" "${LL_SPECULATIVE}" "${LL_SPECULATIVE_O3}"

		## created speculatively optimized .ll
		COMMAND "${OPT}" "${LL_INPUT}" -load=${PASS_LIB} -S -clone-loop -clone-only=AA_ "-trace-file=${ALIAS_YAML}" > "${LL_SPECULATIVE}"
		## run speculatively optimized .ll through O3
		COMMAND "${OPT}" "${LL_SPECULATIVE}"             -S -O3                                                     > "${LL_SPECULATIVE_O3}"
		## .ll -> .s
		COMMAND ${CMAKE_CXX_COMPILER} ${cxx_flags} -O3 "${LL_SPECULATIVE_O3}" -S -o "${S_SPECULATIVE_O3}"
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

	## add test for benchmarks base ptrs
	# you have to create this file by hand!
	set(EXPECTED_BASE_PTR_YAML "${cpp_file}.base-ptrs.yaml")

	configure_file("${EXPECTED_BASE_PTR_YAML}" "${EXPECTED_BASE_PTR_YAML}")

	add_test("${cpp_file}.base-ptrs" check-base-ptrs "${LL_INPUT}" "${EXPECTED_BASE_PTR_YAML}")

#	list(APPEND IR_files "${LL_INSTRUMENTED_O3}")
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

### TESTING

# copy utilities to bin dir
configure_file(yamleq          yamleq)
configure_file(check-base-ptrs check-base-ptrs)
