cmake_minimum_required(VERSION 2.8)

add_library(RC MODULE RegionPass.cpp AliasInstrumentRegion.cpp )

add_library(perf MODULE perflib.cpp)

add_executable(perf-instrument-regions PerfInstrumentRegions.cpp)

target_link_libraries(perf-instrument-regions
	# LLVM
	LLVMCore
	LLVMBitReader LLVMBitWriter
	LLVMIRReader
	LLVMTransformUtils LLVMAnalysis
	LLVMSupport
	LLVMOption
	LLVMDebugInfo
	# std libs
	pthread dl m
)
