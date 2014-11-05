set(LLVM_LINK_COMPONENTS
  # ${LLVM_TARGETS_TO_BUILD}
  # Analysis
  # BitWriter
  # CodeGen
  # Core
  # IPA
  # IPO
  # IRReader
  # InstCombine
  # Instrumentation
  # MC
  # ObjCARCOpts
  # ScalarOpts
  # Support
  # Target
  # TransformUtils
  # Vectorize

	## LLVM
	Core
	BitReader BitWriter
	IRReader
	TransformUtils Analysis
	Support
	Option
	DebugInfo
	## std libs
	# pthread dl m
)

# Support plugins.
set(LLVM_NO_DEAD_STRIP 1)

add_llvm_tool(perf-instrument-regions
	PerfInstrumentRegions.cpp
	## we don't actually use it here but LLVM dies when there are unused files
	perflib.cpp
)
set_target_properties(opt PROPERTIES ENABLE_EXPORTS 1)

add_library(perf perflib.cpp)

if(WITH_POLLY AND LINK_POLLY_INTO_TOOLS)
  target_link_libraries(opt Polly)
  if(POLLY_LINK_LIBS)
    foreach(lib ${POLLY_LINK_LIBS})
      target_link_libraries(opt ${lib})
    endforeach(lib)
  endif(POLLY_LINK_LIBS)
endif(WITH_POLLY AND LINK_POLLY_INTO_TOOLS)
