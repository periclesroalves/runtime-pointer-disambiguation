#!/usr/bin/env python3

import yaml
import sys
import os

PERCENTAGE = 1.0

total                  = 0
no_range_or_heap_alias = 0
no_heap_alias          = 0
no_range_alias         = 0
range_and_heap_alias   = 0
exact_alias            = 0

def no_heap(pair):
	return pair.get("NO_HEAP_ALIAS", 0) == PERCENTAGE

def no_range(pair):
	return pair.get("NO_RANGE_ALIAS", 0) == PERCENTAGE

def exact(pair):
	return pair.get("EXACT_ALIAS", 0) == PERCENTAGE

for root in sys.argv[1:]:
	for root, dirs, files in os.walk(root):
		for file in files:
			path = os.path.join(root, file)

			if not path.endswith('yaml'):
				continue

			for function in yaml.load_all(open(path)):
				for pair in function['alias_pairs']:
					total += 1

					if no_heap(pair):
						if no_range(pair):
							no_range_or_heap_alias += 1
						else:
							no_heap_alias += 1
					else:
						if no_range(pair):
							no_range_alias += 1
						else:
							range_and_heap_alias += 1

					if exact(pair):
						exact_alias += 1

print('total                  ', total)
print('no_range_or_heap_alias ', no_range_or_heap_alias)
print('no_heap_alias          ', no_heap_alias)
print('no_range_alias         ', no_range_alias)
print('range_and_heap_alias   ', range_and_heap_alias)
print('exact_alias            ', exact_alias)
