# This file is distributed under the Modified BSD Open Source License.
# See LICENSE.TXT for details.

cmake_minimum_required(VERSION 2.8)

find_package(LLVM REQUIRED CONFIG)

## LLVMs module support
list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
include(AddLLVM)

add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})

add_library(memtrack SHARED alias_tracing.cpp)

## set where executables & libraries will be placed
INSTALL(TARGETS memtrack
	LIBRARY DESTINATION lib
)