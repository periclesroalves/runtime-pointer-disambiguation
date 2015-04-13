#!/bin/bash

DIR_LIST=(b+tree backprop bfs heartwall hotspot kmeans lavaMD particlefilter pathfinder streamcluster)

# Build all benchmarks.
for dir in "${DIR_LIST[@]}"
do
  cd $dir
  make clean > /dev/null 2> /dev/null
  make > /dev/null 2> /dev/null
  cd ..
done

# Run benchmarks.
echo $'./b+tree'
for i in {1..30}; do ./b+tree/b+tree.out core 1 file ../data/b+tree/mil.txt command ../data/b+tree/command.txt ; done

echo $'./backprop'
for i in {1..30}; do ./backprop/backprop 65536 ; done

echo $'./bfs'
for i in {1..10}; do ./bfs/bfs 1 ../data/bfs/graph1MW_6.txt ; done

echo $'./hotspot'
for i in {1..30}; do ./hotspot/hotspot 512 512 2 1 ../data/hotspot/temp_512 ../data/hotspot/power_512 ; done

echo $'./particlefilter'
for i in {1..10}; do ./particlefilter/particle_filter -x 128 -y 128 -z 10 -np 10000 ; done

echo $'./streamcluster'
for i in {1..10}; do ./streamcluster/sco 10 20 10 59999 6553 1000 none output.txt 1 ; done

echo $'./pathfinder'
for i in {1..10}; do ./pathfinder/pathfinder 100000 100 ; done

echo $'./heartwall'
for i in {1..2}; do ./heartwall/heartwall ../data/heartwall/test.avi 20 1 ; done

echo $'./kmeans'
for i in {1..3}; do ./kmeans/kmeans -i ../data/kmeans/kdd_cup ; done

echo $'./lavaMD'
for i in {1..4}; do ./lavaMD/lavaMD -cores 1 -boxes1d 10 ; done


# Clean all benchmarks.
for dir in "${DIR_LIST[@]}"
do
  cd $dir
  make clean > /dev/null 2> /dev/null
  cd ..
done
