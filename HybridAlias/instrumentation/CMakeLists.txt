cmake_minimum_required(VERSION 2.8)

add_library(instrument-loop MODULE InstrumentLoop.cpp)

target_link_libraries (instrument-loop
	## we use LLVMs YAML parsing but the symbols are not available in opt,
	## but we can't just link in libLLVMSupport.a
	## see http://lists.cs.uiuc.edu/pipermail/llvmdev/2010-June/032508.html
	## TODO: Maybe use another YAML library like cpp-yaml
	"${LLVM_BUILD_LIBRARY_DIR}/Support/CMakeFiles/LLVMSupport.dir/YAMLParser.cpp.o"
	"${LLVM_BUILD_LIBRARY_DIR}/Support/CMakeFiles/LLVMSupport.dir/YAMLTraits.cpp.o"
)

#target_link_libraries(instrument-loop memtrack)

## eventually we should use LLVMs cmake infrastructure for registering plugins
#add_llvm_loadable_module(ILC ILC.cpp)

