# C compiler
CC ?= gcc

backprop: backprop.o facetrain.o imagenet.o backprop_kernel.o 
	$(CC) backprop.o facetrain.o imagenet.o backprop_kernel.o -o backprop -lm

%.o: %.[ch]
	$(CC) $< -c

facetrain.o: facetrain.c backprop.h
	$(CC) facetrain.c -c
	
backprop.o: backprop.c backprop.h
	$(CC) backprop.c -c

backprop_kernel.o: backprop_kernel.c backprop.h
	$(CC) backprop_kernel.c -c

imagenet.o: imagenet.c backprop.h
	$(CC) imagenet.c -c


clean:
	rm -f *.o *~ backprop backprop_cuda.linkinfo
