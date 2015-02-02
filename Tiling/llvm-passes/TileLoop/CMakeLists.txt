# Add the new pass as a library module
add_library(TileLoop MODULE
	Tile.cpp
	Tiling.cpp
	TileLoop.cpp)

add_dependencies(TileLoop Common)
target_link_libraries(TileLoop Common)
