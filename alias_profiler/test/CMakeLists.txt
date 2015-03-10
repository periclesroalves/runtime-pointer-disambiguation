# This file is distributed under the Modified BSD Open Source License.
# See LICENSE.TXT for details.

cmake_minimum_required(VERSION 2.8)

include_directories("${PROJECT_SOURCE_DIR}/src")
include_directories("${PROJECT_SOURCE_DIR}/test")

function(add_simple_test NAME)
	add_executable("${NAME}_shared" "${NAME}.c" test.c)
	add_executable("${NAME}_static" "${NAME}.c" test.c)

	target_link_libraries("${NAME}_shared" memtrack)
	target_link_libraries("${NAME}_static" memtrack_static)

	add_test("${NAME}_shared" "${NAME}_shared")
	add_test("${NAME}_static" "${NAME}_static")
endfunction(add_simple_test)

add_simple_test(smoke_test)
add_simple_test(align_test)
