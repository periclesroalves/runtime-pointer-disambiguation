# This file is distributed under the Modified BSD Open Source License.
# See LICENSE.TXT for details.

cmake_minimum_required(VERSION 2.8)

project("alias_profiler")

### add some compiler flags
set(CMAKE_C_FLAGS "-std=c11 ${CMAKE_C_FLAGS}")   ## set C standard to use

## warn about ALL the things :)
set(CMAKE_C_FLAGS "-Wall ${CMAKE_C_FLAGS}")

## make sure clang prints fancy coloured output when run from make
if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
	set(CMAKE_C_FLAGS "-fcolor-diagnostics ${CMAKE_C_FLAGS}")
endif()

### export a compilation database so we can use tools like IWYU to process the source
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

enable_testing()

add_subdirectory(src)
add_subdirectory(test)
