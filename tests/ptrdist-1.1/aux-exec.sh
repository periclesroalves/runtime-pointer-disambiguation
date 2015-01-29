#/bin/bash

# Run Anagram
cd anagram
make clean  > /dev/null 2> /dev/null 
make  > /dev/null 2> /dev/null 

echo "BENCHMARK: ANAGRAM"
for i in {1..30}
do
  echo "ITERATION: " $i
  time ./anagram words < input.in > FOO 2> FOO
done

cd ..


# Run BC
cd bc
make clean  > /dev/null 2> /dev/null 
make  > /dev/null 2> /dev/null 

echo "BENCHMARK: BC"
for i in {1..30}
do
  echo "ITERATION: " $i
  time ./bc < array.b > FOO
  time ./bc < etest.b > FOO
  time ./bc < fact.b > FOO
  time ./bc < libmath.b > FOO
  time ./bc < primes.b > FOO
  time ./bc < sqrt.b > FOO
done

cd ..


# Run FT
cd ft
make clean  > /dev/null 2> /dev/null 
make  > /dev/null 2> /dev/null 

echo "BENCHMARK: FT"
for i in {1..30}
do
  echo "ITERATION: " $i
  time ./ft 20000 20000 > FOO 2> FOO
done

cd ..


# Run KS
cd ks
make clean  > /dev/null 2> /dev/null 
make  > /dev/null 2> /dev/null 

echo "BENCHMARK: KS"
for i in {1..30}
do
  echo "ITERATION: " $i
  time ./ks KL-1.in > FOO
  time ./ks KL-2.in > FOO
  time ./ks KL-3.in > FOO
  time ./ks KL-4.in > FOO
  time ./ks KL-5.in > FOO
  time ./ks KL-6.in > FOO
done

cd ..
