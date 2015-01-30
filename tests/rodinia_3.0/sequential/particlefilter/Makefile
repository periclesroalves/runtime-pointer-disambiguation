#makefile

CC ?= gcc

openmp: ex_particle_OPENMP_seq.c
	$(CC) -ffast-math ex_particle_OPENMP_seq.c -o particle_filter -lm 

clean:
	rm particle_filter
