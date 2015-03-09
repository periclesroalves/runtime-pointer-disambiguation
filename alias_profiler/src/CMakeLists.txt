# This file is distributed under the Modified BSD Open Source License.
# See LICENSE.TXT for details.

cmake_minimum_required(VERSION 2.8)

### create targets

add_library(memtrack        SHARED memtrack.c misc.c)
add_library(memtrack_static STATIC memtrack.c misc.c)
add_library(alias_profiler  SHARED alias_profiler.c memtrack.c misc.c)

target_link_libraries(memtrack        dl)
target_link_libraries(memtrack_static dl)
target_link_libraries(alias_profiler  dl)

### create install target

install(
	FILES memtrack memtrack_static alias_profiler
	LIBRARY DESTINATION lib
)
