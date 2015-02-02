file(GLOB SRC_FILES *.cpp)

#option1 works
set(CMAKE_CXX_FLAGS "-fPIC ${CMAKE_CXX_FLAGS}")
add_library(Common STATIC ${SRC_FILES})

#option2 
#add_library(Common OBJECT ${SRC_FILES})
