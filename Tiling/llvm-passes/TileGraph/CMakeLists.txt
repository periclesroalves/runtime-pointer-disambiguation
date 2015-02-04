# Add the new pass as a library module
#aux_source_directory(../Common CommonCpp)
#add_library(TileGraph MODULE  ${CommonCpp} TileGraph.cpp  )
add_library(TileGraph MODULE
	ScheduleHeuristic.cpp
	TileHeuristic.cpp
	TileGraph.cpp)
add_dependencies(TileGraph Common)
target_link_libraries(TileGraph Common)
