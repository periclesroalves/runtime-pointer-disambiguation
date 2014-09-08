#!/bin/bash

# Counts the number of SCoPs not handled by Polly due to poor alias info.

# Statistics files.
tmpNoAlias=/tmp/polly-tmp-1.txt
tmpBadAlias=/tmp/polly-tmp-2.txt

rm $tmpNoAlias $tmpBadAlias 2> /dev/null

for test in `cat utilities/benchmark_list`; do
  # Ignore alias.
  ~/ufmg-research/build/Debug+Asserts/bin/clang -Xclang -load -Xclang ~/ufmg-research/build/tools/polly/Debug+Asserts/lib/LLVMPolly.dylib -O3 $test -I utilities/ -O3 -mllvm -polly -mllvm -polly-ignore-aliasing -mllvm -stats utilities/polybench.c 2>> $tmpNoAlias;

  # Do not ignore alias.
  ~/ufmg-research/build/Debug+Asserts/bin/clang -Xclang -load -Xclang ~/ufmg-research/build/tools/polly/Debug+Asserts/lib/LLVMPolly.dylib -O3 $test -I utilities/ -O3 -mllvm -polly -mllvm -stats utilities/polybench.c 2>> $tmpBadAlias;
done

# Get final numbers.
nScopsNoAlias=`grep "Number of valid Scops" $tmpNoAlias | awk '{sum += $1;} END {print sum}'`
nScopsBadAlias=`grep "Number of valid Scops" $tmpBadAlias | awk '{sum += $1;} END {print sum}'`
ratio=`bc <<< 'scale=2; (1-'$nScopsBadAlias'/'$nScopsNoAlias')*100'`

echo "Number of SCoPs when ignoring aliasing: " $nScopsNoAlias
echo "Number of SCoPs when considering aliasing: " $nScopsBadAlias
echo "Reduction: " $ratio "%"
