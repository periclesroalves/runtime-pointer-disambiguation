cmake_minimum_required(VERSION 2.8)

set(LLVM_LINK_COMPONENTS
  ${LLVM_TARGETS_TO_BUILD}
  Analysis
  BitWriter
  Core
  IRReader
  ScalarOpts
  Support
  TransformUtils
  )

# Support plugins.
set(LLVM_NO_DEAD_STRIP 1)

add_llvm_tool(canonicalize
  canonicalize.cpp
  )
set_target_properties(canonicalize PROPERTIES ENABLE_EXPORTS 1)
