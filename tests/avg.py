#!/usr/bin/env python3

## reads stdin line by line.
## consecutive lines that contain only some spaces a number are averaged
## and printed to stdout.
## all other lines are print to stdout untouched.
##
## i.e. the following input:
##  > # some comment
##  > 5
##  > 6
##  >
##  > 13
## becomes:
##  > # some comment
##  > 5.5
##  >
##  > 13

import sys
import decimal

def avg(ns):
	return sum(ns)/len(ns)

numbers = []

for line in sys.stdin:
	try:
		number = decimal.Decimal(line.strip())
		numbers.append(number)
	except decimal.InvalidOperation:
		if numbers:
			print(avg(numbers))
			numbers = []
		print(line, end='' if line.endswith('\n') else '\n')

if numbers:
	print(avg(numbers))
