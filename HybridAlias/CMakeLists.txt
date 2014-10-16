cmake_minimum_required(VERSION 2.8)

project("GCG hybrid alias")

### set compilers
set(CMAKE_C_COMPILER   /usr/bin/clang)
set(CMAKE_CXX_COMPILER /usr/bin/clang++)

### add some C++ compiler flags
## disable C++ RTTI
## disable C++ exceptions
## make sure clang prints fancy coloured output when run from make
set(CMAKE_CXX_FLAGS "-std=c++11 -fno-rtti -fno-exceptions -fcolor-diagnostics ${CMAKE_CXX_FLAGS}")

### export a compilation database so we can use tools like IWYU to process the source
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include_directories(${PROJECT_SOURCE_DIR})

add_subdirectory(instrumentation)
add_subdirectory(ilc)
add_subdirectory(runtime)
add_subdirectory(benchmark)
