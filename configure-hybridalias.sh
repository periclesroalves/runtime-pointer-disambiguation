#!/bin/bash

BASE=/Users/periclesalves/ufmg-research
LLVM_SRC=${BASE}/llvm
LLVM_BUILD=${BASE}/build
BIN_DIR=${BASE}/build/Debug+Asserts/bin
LIB_DIR=${BASE}/Debug+Asserts/lib
HYBRID_SRC=${BASE}/HybridAlias

# Hardcode /bin and /lib paths into the CMake files.
grep -q -e "set(LLVM_TOOLS_BINARY_DIR \"${BIN_DIR}\")" ${HYBRID_SRC}/CMakeLists.txt || (awk -v str="set\(LLVM_TOOLS_BINARY_DIR \"${BIN_DIR}\"\)" 'NR==18{print str}1' ${HYBRID_SRC}/CMakeLists.txt > ${HYBRID_SRC}/CMakeLists.txt_; mv ${HYBRID_SRC}/CMakeLists.txt_ ${HYBRID_SRC}/CMakeLists.txt)

grep -q -e "set(LLVM_TOOLS_BINARY_DIR \"${BIN_DIR}\")" ${HYBRID_SRC}/benchmark/CMakeLists.txt || (awk -v str="set\(LLVM_TOOLS_BINARY_DIR \"${BIN_DIR}\"\)" 'NR==24{print str}1' ${HYBRID_SRC}/benchmark/CMakeLists.txt > ${HYBRID_SRC}/benchmark/CMakeLists.txt_; mv ${HYBRID_SRC}/benchmark/CMakeLists.txt_ ${HYBRID_SRC}/benchmark/CMakeLists.txt)

grep -q -e "set(LLVM_BUILD_LIBRARY_DIR \"${LIB_DIR}\")" ${HYBRID_SRC}/ilc/CMakeLists.txt || (awk -v str="set\(LLVM_BUILD_LIBRARY_DIR \"${LIB_DIR}\"\)" 'NR==4{print str}1' ${HYBRID_SRC}/ilc/CMakeLists.txt > ${HYBRID_SRC}/ilc/CMakeLists.txt_; mv ${HYBRID_SRC}/ilc/CMakeLists.txt_ ${HYBRID_SRC}/ilc/CMakeLists.txt)

# Set all /include /lib /bin flags to our LLVM build.
export CXXFLAGS="-std=c++11 -stdlib=libc++ -D__STDC_CONSTANT_MACROS -D__STDC_LIMIT_MACROS"
export C_INCLUDE_PATH=${LLVM_BUILD}/include:${LLVM_SRC}/include:$C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=${LLVM_BUILD}/include:${LLVM_SRC}/include:$CPLUS_INCLUDE_PATH

# Run CMake.
rm CMakeCache.txt
rm -r CMakeFiles
LLVM_DIR="${LLVM_SRC}/cmake/modules" cmake -DCMAKE_MODULE_PATH="${LLVM_SRC}/cmake/modules" ${HYBRID_SRC}
