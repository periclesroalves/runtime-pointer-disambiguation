cmake_minimum_required(VERSION 2.8)

set(LLVM_LINK_COMPONENTS
  ${LLVM_TARGETS_TO_BUILD}
  Analysis
  BitWriter
  Core
  IPA
  IPO
  IRReader
  Instrumentation
  ScalarOpts
  Support
  TransformUtils
  )

# Support plugins.
set(LLVM_NO_DEAD_STRIP 1)

add_llvm_tool(alias-instrument
  alias_instrument.cpp
  )
set_target_properties(alias-instrument PROPERTIES ENABLE_EXPORTS 1)
