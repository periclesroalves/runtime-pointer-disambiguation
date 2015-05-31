# Install script for directory: /Users/periclesalves/Downloads/opencv-2.4.10/modules/java

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "java")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/OpenCV/java" TYPE FILE FILES "/Users/periclesalves/Downloads/opencv-2.4.10/bin/opencv-2410.jar")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "java")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/OpenCV/java" TYPE SHARED_LIBRARY FILES "/Users/periclesalves/Downloads/opencv-2.4.10/lib/libopencv_java2410.dylib")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/share/OpenCV/java/libopencv_java2410.dylib" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/share/OpenCV/java/libopencv_java2410.dylib")
    execute_process(COMMAND "/usr/bin/install_name_tool"
      -id "lib/libopencv_java2410.dylib"
      -change "/Users/periclesalves/Downloads/opencv-2.4.10/lib/libopencv_calib3d.2.4.dylib" "lib/libopencv_calib3d.2.4.dylib"
      -change "/Users/periclesalves/Downloads/opencv-2.4.10/lib/libopencv_contrib.2.4.dylib" "lib/libopencv_contrib.2.4.dylib"
      -change "/Users/periclesalves/Downloads/opencv-2.4.10/lib/libopencv_core.2.4.dylib" "lib/libopencv_core.2.4.dylib"
      -change "/Users/periclesalves/Downloads/opencv-2.4.10/lib/libopencv_features2d.2.4.dylib" "lib/libopencv_features2d.2.4.dylib"
      -change "/Users/periclesalves/Downloads/opencv-2.4.10/lib/libopencv_flann.2.4.dylib" "lib/libopencv_flann.2.4.dylib"
      -change "/Users/periclesalves/Downloads/opencv-2.4.10/lib/libopencv_gpu.2.4.dylib" "lib/libopencv_gpu.2.4.dylib"
      -change "/Users/periclesalves/Downloads/opencv-2.4.10/lib/libopencv_highgui.2.4.dylib" "lib/libopencv_highgui.2.4.dylib"
      -change "/Users/periclesalves/Downloads/opencv-2.4.10/lib/libopencv_imgproc.2.4.dylib" "lib/libopencv_imgproc.2.4.dylib"
      -change "/Users/periclesalves/Downloads/opencv-2.4.10/lib/libopencv_legacy.2.4.dylib" "lib/libopencv_legacy.2.4.dylib"
      -change "/Users/periclesalves/Downloads/opencv-2.4.10/lib/libopencv_ml.2.4.dylib" "lib/libopencv_ml.2.4.dylib"
      -change "/Users/periclesalves/Downloads/opencv-2.4.10/lib/libopencv_nonfree.2.4.dylib" "lib/libopencv_nonfree.2.4.dylib"
      -change "/Users/periclesalves/Downloads/opencv-2.4.10/lib/libopencv_objdetect.2.4.dylib" "lib/libopencv_objdetect.2.4.dylib"
      -change "/Users/periclesalves/Downloads/opencv-2.4.10/lib/libopencv_ocl.2.4.dylib" "lib/libopencv_ocl.2.4.dylib"
      -change "/Users/periclesalves/Downloads/opencv-2.4.10/lib/libopencv_photo.2.4.dylib" "lib/libopencv_photo.2.4.dylib"
      -change "/Users/periclesalves/Downloads/opencv-2.4.10/lib/libopencv_video.2.4.dylib" "lib/libopencv_video.2.4.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/share/OpenCV/java/libopencv_java2410.dylib")
    execute_process(COMMAND /usr/bin/install_name_tool
      -add_rpath "/usr/local/lib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/share/OpenCV/java/libopencv_java2410.dylib")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/share/OpenCV/java/libopencv_java2410.dylib")
    endif()
  endif()
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/Users/periclesalves/Downloads/opencv-2.4.10/modules/java/test/cmake_install.cmake")

endif()

