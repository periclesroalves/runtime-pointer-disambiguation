cmake_minimum_required(VERSION 2.8)

project("GCG hybrid alias")

## LLVMs module support
find_package(LLVM REQUIRED CONFIG)

list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
include(AddLLVM)

add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})

## add google benchmark library
include_directories(google-benchmark/include)
add_subdirectory(google-benchmark)

### set compilers
if("${LLVM_TOOLS_BINARY_DIR}" STREQUAL "")
	message(FATAL_ERROR "\${LLVM_TOOLS_BINARY_DIR} was not set, try setting CMAKE_PREFIX_PATH")
endif()

find_program(CLANG   clang   NO_DEFAULT_PATH PATHS "${LLVM_TOOLS_BINARY_DIR}")
find_program(CLANGXX clang++ NO_DEFAULT_PATH PATHS "${LLVM_TOOLS_BINARY_DIR}")

if(("${CLANG}" STREQUAL "CLANG-NOTFOUND") OR ("${CLANGXX}" STREQUAL "CLANGXX-NOTFOUND"))
	message(FATAL_ERROR "Could not find clang, try setting CMAKE_PREFIX_PATH")
endif()

set(CMAKE_C_COMPILER   "${CLANG}")
set(CMAKE_CXX_COMPILER "${CLANGXX}")

### add some C++ compiler flags
## unfortunately we can't use add_compile_options here since that would also add them to C files
set(CMAKE_CXX_FLAGS "-std=c++11 ${CMAKE_CXX_FLAGS}")      ## set C++ standard to use
set(CMAKE_CXX_FLAGS "-fno-rtti ${CMAKE_CXX_FLAGS}")       ## disable C++ RTTI
set(CMAKE_CXX_FLAGS "-fno-exceptions ${CMAKE_CXX_FLAGS}") ## disable C++ exceptions

## warn about ALL the things :)
set(CMAKE_C_FLAGS   "-Wall ${CMAKE_C_FLAGS}")
set(CMAKE_CXX_FLAGS "-Wall ${CMAKE_CXX_FLAGS}")

## make sure clang prints fancy coloured output when run from make
set(CMAKE_C_FLAGS   "-fcolor-diagnostics ${CMAKE_C_FLAGS}")
set(CMAKE_CXX_FLAGS "-fcolor-diagnostics ${CMAKE_CXX_FLAGS}")

### export a compilation database so we can use tools like IWYU to process the source
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include_directories(${PROJECT_SOURCE_DIR})

enable_testing()

add_subdirectory(ilc)
add_subdirectory(RC)
add_subdirectory(runtime)
add_subdirectory(benchmark)
