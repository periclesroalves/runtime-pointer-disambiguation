LLVM_BIN = $(CMAKE_PREFIX_PATH_ENV)
ARCH:= -march=core-avx2 #core-avx2 native
CXX := $(LLVM_BIN)clang++
#CXX := g++
LLVM_LINK=$(LLVM_BIN)llvm-link
LLVM_LLC=$(LLVM_BIN)llc
#CXXFLAGS := -march=native -O0
CXXFLAGS := $(ARCH) -O0
LLCFLAGS := -filetype=obj 
INCLUDES = -I./

MAIN_GEN = jacobi3d_gen.out
SRCS_GEN = jacobi3d_generator.cc
OBJS_GEN = $(SRCS_GEN:%.cc=%.o)
JACOBI_GENERATED = jacobi3d_generated.cc

MAIN = jacobi3d
MAIN_NOIR = $(MAIN)_noir.out
MAIN_IR =  $(MAIN)_raw.out
ALL_IR = $(MAIN)_raw.ll
SRCS = jacobi3d.cc helper.cc memcpy.cc $(JACOBI_GENERATED)
IRS = $(SRCS:%.cc=%.ll)
OBJS = $(SRCS:%.cc=%.o)
OBJS_IR = $(ALL_IR:%.ll=%.o) 


all: $(MAIN_GEN) $(MAIN_IR) 

$(MAIN_GEN): $(OBJS_GEN) 
	$(CXX) $(CXXFLAGS) $(INCLUDES) -o $(MAIN_GEN) $(OBJS_GEN) 

$(JACOBI_GENERATED): $(MAIN_GEN)
	./$(MAIN_GEN) > ./$(JACOBI_GENERATED)


$(MAIN_NOIR): $(OBJS) 
	$(CXX) $(CXXFLAGS) $(INCLUDES) -o $(MAIN_NOIR) $(OBJS) 

$(ALL_IR): $(IRS)
	$(LLVM_LINK) -S -o $(ALL_IR) $(IRS)  

$(MAIN_IR): $(OBJS_IR) 
	$(CXX) $(CXXFLAGS) $(INCLUDES) -o $(MAIN_IR) $(OBJS_IR) 

%.o:%.c
	$(CXX) $< $(CXXFLAGS) -o $@

%.ll:%.cc
	$(CXX) $< $(CXXFLAGS) -S -emit-llvm -o $@

%.o:%.ll
	$(LLVM_LLC) $< $(LLCFLAGS) -o $@

clean:
	$(RM) *.o *.out *~  *.ll $(JACOBI_GENERATED)

depend: $(SRCS)
	makedepend $(INCLUDES) $^

# DO NOT DELETE THIS LINE -- make depend needs it
