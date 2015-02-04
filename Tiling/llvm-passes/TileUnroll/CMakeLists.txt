# Add the new pass as a library module
add_library(TileUnroll MODULE
	TileUnroll.cpp)

add_dependencies(TileUnroll Common)
target_link_libraries(TileUnroll Common)
