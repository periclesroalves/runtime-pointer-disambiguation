# This file is distributed under the Modified BSD Open Source License.
# See LICENSE.TXT for details.

cmake_minimum_required(VERSION 2.8)

add_executable(print-base-ptrs
	PrintBasePtrs.cpp
	BasePtrInfo.cpp
	Common.cpp
	YamlUtils.cpp
)

target_link_libraries(print-base-ptrs
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

add_executable(clone-loops
	ILCWrapper.cpp
	ILC.cpp
	YamlUtils.cpp
	Common.cpp
	BasePtrInfo.cpp
)

target_link_libraries(clone-loops
	# LLVM
	LLVMCore
	LLVMBitReader LLVMBitWriter
	LLVMIRReader
	LLVMTransformUtils LLVMAnalysis
	LLVMSupport
	LLVMOption
	LLVMDebugInfo
)

add_executable(perf-instrument
	PerfInstrumentRegions.cpp
	YamlUtils.cpp
	Common.cpp
)

target_link_libraries(perf-instrument
	# LLVM
	LLVMCore
	LLVMBitReader LLVMBitWriter
	LLVMIRReader
	LLVMTransformUtils LLVMAnalysis
	LLVMSupport
	LLVMOption
	LLVMDebugInfo
)

add_library(perf MODULE perflib.cpp)

## set where executables & libraries will be placed
INSTALL(TARGETS clone-loops perf-instrument perf
	RUNTIME DESTINATION bin
	LIBRARY DESTINATION lib
)
