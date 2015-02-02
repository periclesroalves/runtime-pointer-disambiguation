LLVM_BIN = $(CMAKE_PREFIX_PATH_ENV)
#LLVM_BIN = ~/work/inria/llvm/llvm-gcg/install/bin/
ARCH:= -march=native
CXX := $(LLVM_BIN)clang
LLVM_LINK=$(LLVM_BIN)llvm-link
LLVM_LLC=$(LLVM_BIN)llc
#CXX := g++
#CXXFLAGS := -march=native -O0
CXXFLAGS := $(ARCH) -O0 -std=c++11 
LLCFLAGS := -filetype=obj 

MAIN = must-dep-tst
EXT = cpp

SRCS = must-dep-tst.$(EXT)
IRS = $(SRCS:%.$(EXT)=%.ll)
OBJS = $(SRCS:%.$(EXT)=%.o)
OBJS_IR = $(ALL_IR:%.ll=%.o) 
INCLUDES = -I./

MAIN_IR =  $(MAIN)_raw.out
ALL_IR = $(MAIN)_raw.ll

all: $(MAIN_IR)

$(MAIN): $(OBJS) 
	$(CXX) $(CXXFLAGS) $(INCLUDES) -o $(MAIN) $(OBJS) 

$(ALL_IR): $(IRS)
	$(LLVM_LINK) -S -o $(ALL_IR) $(IRS)  

$(MAIN_IR): $(OBJS_IR) 
	$(CXX) $(CXXFLAGS) $(INCLUDES) -o $(MAIN_IR) $(OBJS_IR) 

%.o:%.$(EXT)
	$(CXX) $< $(CXXFLAGS) -o $@

%.ll:%.$(EXT)
	$(CXX) $< $(CXXFLAGS) -S -emit-llvm -o $@

%.o:%.ll
	$(LLVM_LLC) $< $(LLCFLAGS) -o $@

clean:
	$(RM) *.o *~ $(MAIN) *.ll $(MAIN_IR)

depend: $(SRCS)
	makedepend $(INCLUDES) $^

# DO NOT DELETE THIS LINE -- make depend needs it
