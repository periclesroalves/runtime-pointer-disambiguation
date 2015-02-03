cmake_minimum_required(VERSION 2.8)

set(LLVM_LINK_COMPONENTS)

# TODO
# set(LLVM_EXPORTED_SYMBOL_FILE ${CMAKE_CURRENT_SOURCE_DIR}/alias-profiler.exports)

add_llvm_library(alias-profiler SHARED alias_profiler.cpp)

target_link_libraries(alias-profiler dl)

set_target_properties(alias-profiler PROPERTIES ENABLE_EXPORTS 1)
