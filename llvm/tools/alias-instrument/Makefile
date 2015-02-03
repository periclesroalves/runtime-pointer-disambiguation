##===- tools/alias-instrument/Makefile ---------------------*- Makefile -*-===##
#
#                     The LLVM Compiler Infrastructure
#
# This file is distributed under the University of Illinois Open Source
# License. See LICENSE.TXT for details.
#
##===----------------------------------------------------------------------===##

LEVEL := ../..
TOOLNAME := alias-instrument
LINK_COMPONENTS := bitreader bitwriter asmparser irreader instrumentation scalaropts ipo

# Disable plugin support.
NO_DEAD_STRIP := 0

include $(LEVEL)/Makefile.common
