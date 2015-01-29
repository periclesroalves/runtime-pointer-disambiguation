#!/bin/bash

echo "--------------------------------------------------"
echo "IMPORTANT: remember to replace the master Makefile"
echo "--------------------------------------------------"
echo ""
echo "This will take a while..."

OUT_FILE=tmp.out
rm $OUT_FILE 2> /dev/null

# Excute actual experiments.
./aux-exec.sh >> $OUT_FILE 2>> $OUT_FILE

# Parse results.
./aux-parse-result.py $OUT_FILE

rm $OUT_FILE
