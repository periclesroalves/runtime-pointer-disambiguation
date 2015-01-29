#!/usr/bin/python

import sys

file = open(sys.argv[1])
file = file.read()

file = file.split("BENCHMARK: ")
file = [entry for entry in file if entry != '']

benchList = [entry.split("\n", 1)[0] for entry in file]
file = [entry.split("\n", 1)[1] for entry in file]

print "------------------------------------------------"
print "RESULTS: average execution time of 30 executions"
print "------------------------------------------------"

for i in range(len(file)):
  benchData = file[i]
  benchData = benchData.split("ITERATION:")
  benchData = [entry for entry in benchData if entry != '']

  benchTotal = 0

  for iteration in benchData:
    iteration = iteration.split("real\t0m")[1:]
    iteration = [entry.split("s")[0] for entry in iteration]
    iteration = [float(entry) for entry in iteration]
    iterationTime = sum(iteration)
    benchTotal += iterationTime

  numIt = len(benchData)
  benchAverage = float(benchTotal)/float(numIt)

  print benchList[i] + ": " + str(benchAverage) + "s"
