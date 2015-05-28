#!/bin/bash

# Change these to reflect you compilation command (executable + flags).
export CC="/home/pericles/ufmg-research/build-release/bin/clang -Xclang -load -Xclang /home/pericles/ufmg-research/build-release/lib/LLVMPolly.so -O3 -mllvm -polly -mllvm -polly-code-generator=none -mllvm -polly-optimizer=none -mllvm -polly-use-scev-alias-checks"
export CXX="/home/pericles/ufmg-research/build-release/bin/clang++ -Xclang -load -Xclang /home/pericles/ufmg-research/build-release/lib/LLVMPolly.so -O3 -mllvm -polly -mllvm -polly-code-generator=none -mllvm -polly-optimizer=none -mllvm -polly-use-scev-alias-checks"

DIR_LIST=(b+tree backprop bfs heartwall hotspot kmeans lavaMD particlefilter pathfinder streamcluster)

# Build all benchmarks.
for dir in "${DIR_LIST[@]}"
do
  cd $dir
  make clean > /dev/null 2> /dev/null
  make > /dev/null 2> /dev/null
  cd ..
done

# Run smaller benchmarks 10 times.
echo $'\nb+tree'
for i in {1..10}; do time ./b+tree/b+tree.out core 1 file ../data/b+tree/mil.txt command ../data/b+tree/command.txt > /dev/null; done

echo $'\nbackprop'
for i in {1..10}; do time ./backprop/backprop 65536 > /dev/null; done

echo $'\nbfs'
for i in {1..10}; do time ./bfs/bfs 1 ../data/bfs/graph1MW_6.txt > /dev/null; done

echo $'\nhotspot'
for i in {1..10}; do time ./hotspot/hotspot 512 512 2 1 ../data/hotspot/temp_512 ../data/hotspot/power_512 > /dev/null; done

echo $'\nparticlefilter'
for i in {1..10}; do time ./particlefilter/particle_filter -x 128 -y 128 -z 10 -np 10000 > /dev/null; done

echo $'\npathfinder'
for i in {1..10}; do time ./pathfinder/pathfinder 100000 100 > /dev/null; done


# Run larger benchmarks twice.
echo $'\nheartwall'
for i in {1..2}; do time ./heartwall/heartwall ../data/heartwall/test.avi 20 1 > /dev/null; done

echo $'\nkmeans'
for i in {1..2}; do time ./kmeans/kmeans -i ../data/kmeans/kdd_cup > /dev/null; done

echo $'\nlavaMD'
for i in {1..2}; do time ./lavaMD/lavaMD -cores 1 -boxes1d 10 > /dev/null; done

echo $'\nstreamcluster'
for i in {1..2}; do time ./streamcluster/sc_omp 10 20 256 65536 65536 1000 none output.txt 1 > /dev/null 2> /dev/null; done


# Clean all benchmarks.
for dir in "${DIR_LIST[@]}"
do
  cd $dir
  make clean > /dev/null 2> /dev/null
  cd ..
done
