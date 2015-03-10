# This file is distributed under the Modified BSD Open Source License.
# See LICENSE.TXT for details.

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

## add alias profiler
add_subdirectory(../alias_profiler "${CMAKE_BINARY_DIR}/alias_profiler")

### set compilers
if("${LLVM_TOOLS_BINARY_DIR}" STREQUAL "")
	message(FATAL_ERROR "\${LLVM_TOOLS_BINARY_DIR} was not set, try setting CMAKE_PREFIX_PATH")
endif()

find_program(CLANG   clang   NO_DEFAULT_PATH PATHS "${LLVM_TOOLS_BINARY_DIR}")
find_program(CLANGXX clang++ NO_DEFAULT_PATH PATHS "${LLVM_TOOLS_BINARY_DIR}")

if(("${CLANG}" STREQUAL "CLANG-NOTFOUND") OR ("${CLANGXX}" STREQUAL "CLANGXX-NOTFOUND"))
	message(FATAL_ERROR "Could not find clang, try setting CMAKE_PREFIX_PATH")
endif()

### add some C++ compiler flags
## unfortunately we can't use add_compile_options here since that would also add them to C files
set(CMAKE_CXX_FLAGS "-std=c++11 ${CMAKE_CXX_FLAGS}")      ## set C++ standard to use
set(CMAKE_CXX_FLAGS "-fno-rtti ${CMAKE_CXX_FLAGS}")       ## disable C++ RTTI
set(CMAKE_CXX_FLAGS "-fno-exceptions ${CMAKE_CXX_FLAGS}") ## disable C++ exceptions

set(CMAKE_CXX_FLAGS "-g ${CMAKE_CXX_FLAGS}")

## warn about ALL the things :)
set(CMAKE_C_FLAGS   "-Wall ${CMAKE_C_FLAGS}")
set(CMAKE_CXX_FLAGS "-Wall ${CMAKE_CXX_FLAGS}")

## make sure clang prints fancy coloured output when run from make
if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
	set(CMAKE_C_FLAGS   "-fcolor-diagnostics ${CMAKE_C_FLAGS}")
	set(CMAKE_CXX_FLAGS "-fcolor-diagnostics ${CMAKE_CXX_FLAGS}")
endif()

### export a compilation database so we can use tools like IWYU to process the source
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

### fix cmake's rpath defaults so install targets can find LLVM libraries

# use, i.e. don't skip, the full RPATH for the build tree
SET(CMAKE_SKIP_BUILD_RPATH  FALSE)

# when building, don't use the install RPATH already
# (but later on when installing)
SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)

SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")

# add the automatically determined parts of the RPATH
# which point to directories outside the build tree to the install RPATH
SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

# the RPATH to be used when installing, but only if it's not a system directory
LIST(FIND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES "${CMAKE_INSTALL_PREFIX}/lib" isSystemDir)
IF("${isSystemDir}" STREQUAL "-1")
   SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
ENDIF("${isSystemDir}" STREQUAL "-1")

### create targets

include_directories(${PROJECT_SOURCE_DIR})

enable_testing()

add_subdirectory(ilc)
add_subdirectory(benchmark)

install(
	FILES aggregate-alias-trace aggregate-time-and-alias-trace
	PERMISSIONS OWNER_READ OWNER_EXECUTE WORLD_EXECUTE
	DESTINATION bin
)
