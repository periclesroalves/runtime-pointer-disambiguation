cmake_minimum_required(VERSION 2.8)

find_package(LLVM REQUIRED CONFIG)

## LLVMs module support
list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
include(AddLLVM)

add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})

add_library(instrument-loop MODULE InstrumentLoop.cpp)

#target_link_libraries(instrument-loop memtrack)

## eventually we should use LLVMs cmake infrastructure for registering plugins
#add_llvm_loadable_module(ILC ILC.cpp)

