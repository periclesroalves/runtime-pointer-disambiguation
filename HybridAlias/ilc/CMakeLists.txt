cmake_minimum_required(VERSION 2.8)

add_library(ILC MODULE ILC.cpp Common.cpp TraceLoopAlias.cpp FullInstNamer.cpp BasePtrInfo.cpp)

if("${LLVM_BUILD_LIBRARY_DIR}" STREQUAL "")
	message(FATAL_ERROR "\${LLVM_BUILD_LIBRARY_DIR} not set, configure with proper CMAKE_PREFIX_PATH")
endif()

target_link_libraries (ILC
	## we use LLVMs YAML parsing but the symbols are not available in opt,
	## but we can't just link in libLLVMSupport.a
	## see http://lists.cs.uiuc.edu/pipermail/llvmdev/2010-June/032508.html
	## TODO: Maybe use another YAML library like cpp-yaml
	"${LLVM_BUILD_LIBRARY_DIR}/Support/CMakeFiles/LLVMSupport.dir/YAMLParser.cpp.o"
	"${LLVM_BUILD_LIBRARY_DIR}/Support/CMakeFiles/LLVMSupport.dir/YAMLTraits.cpp.o"
)

add_library(FullInstNamer MODULE FullInstNamer.cpp)

add_executable(print-base-ptrs PrintBasePtrs.cpp FullInstNamer.cpp BasePtrInfo.cpp Common.cpp)

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
