LIBRARYNAME = LLVMILC

CLANG = clang
CLANG_FLAGS = -emit-llvm -O2 #-g
OPT = opt
OPT_FLAGS = -load
LIB_FLAGS = -mtrack
PASS_FLAGS = -ilc -basicaa #-loops #-SplitLoop
#SRC = test2.c
#SRC = matmul_func.c matmul_novec.c
SRC = foo.c bar.c
ASM = $(SRC:.c=.ll)

exe: $(ASM)
	$(CLANG) $(LIB_FLAGS) -o $@ $(ASM:.ll=.bc)

%.ll: %.c
	$(CLANG) -c -S $(CLANG_FLAGS) $<
	$(OPT) $(OPT_FLAGS) $(LIBRARYNAME).so -S $(PASS_FLAGS) < $@ > $*.bc	
	
clean:
	rm -rf exe *.ll *.bc

