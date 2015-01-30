# C compiler
CC ?= gcc

kmeans: cluster.o getopt.o kmeans.o kmeans_clustering.o 
	$(CC) cluster.o getopt.o kmeans.o kmeans_clustering.o  -o kmeans

%.o: %.[ch]
	$(CC) $< -c

cluster.o: cluster.c 
	$(CC) cluster.c -c
	
getopt.o: getopt.c 
	$(CC) getopt.c -c
	
kmeans.o: kmeans.c 
	$(CC) kmeans.c -c

kmeans_clustering.o: kmeans_clustering.c kmeans.h
	$(CC) kmeans_clustering.c -c

clean:
	rm -f *.o *~ kmeans 
