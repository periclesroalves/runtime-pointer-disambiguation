cmake_minimum_required(VERSION 2.8)

#set som CMAKE variables
if(DEFINED ENV{LLVM_DIR_ENV})
  set(LLVM_DIR $ENV{LLVM_DIR_ENV})
  message(STATUS "LLVM_DIR_ENV environment variable defined, setting LLVM_DIR to ${LLVM_DIR_ENV}")
else()
  message(STATUS "LLVM_DIR_ENV environment variable undefined, using default LLVM_DIR: ${LLVM_DIR}")
endif()

if(DEFINED ENV{CMAKE_PREFIX_PATH_ENV})
    set(CMAKE_PREFIX_PATH $ENV{CMAKE_PREFIX_PATH_ENV})
endif()

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")


# Use clang/LLVM itself as compiler for the pass
# set(CMAKE_C_COMPILER "${CMAKE_PREFIX_PATH}gcc")
# set(CMAKE_CXX_COMPILER "${CMAKE_PREFIX_PATH}/g++")

message(STATUS "CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")
message(STATUS "CMAKE_C_COMPILER VERSION:")
execute_process(COMMAND "${CMAKE_C_COMPILER}" "--version")
message(STATUS "CMAKE_CXX_COMPILER VERSION:")
execute_process(COMMAND "${CMAKE_CXX_COMPILER}" "--version")

# Include the necessary files from LLVM
find_package(LLVM REQUIRED CONFIG)
add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})
message(STATUS "Using LLVM_INCLUDE_DIRS in: ${LLVM_INCLUDE_DIRS}")


# Follow C++11 standard and deactivate RTTI and exceptions to speed-up the resulting passes
set(CMAKE_CXX_FLAGS "-std=c++11 -fno-rtti -fno-exceptions ${CMAKE_CXX_FLAGS}")

# Default build type is Debug (for the moment)
set(CMAKE_BUILD_TYPE "Debug")

# Add the Common directory for includes
include_directories(Common)
#include_directories(/usr/include/llvm-3.4/)
#include_directories(/usr/include/llvm-c-3.4/)
#include_directories(/usr/include/llvm/)

# Finish by going through the new passes
add_subdirectory(Common)
add_subdirectory(TileUnroll)
add_subdirectory(TileGraph)
add_subdirectory(TileLoop)

