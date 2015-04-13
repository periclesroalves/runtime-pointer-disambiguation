#!/usr/bin/env python3

import re
import sys
import os
import collections

def input_files():
	roots = sys.argv[1:]

	if not roots:
		yield sys.stdin
	else:
		for root in roots:
			if os.path.isfile(root):
				yield open(root)
			else:
				for root, dirs, files in os.walk(root):
					for file in files:
						path = os.path.join(root, file)

						if not path.endswith('yaml'):
							continue

						yield open(path)

accum = collections.OrderedDict()

for file in input_files():
	for line in file:
		while line.endswith('\n'):
			line = line[:-1]

		if not line:
			continue

		# print('"%s"' % (line,))

		match = re.match("^\s*([\w\-']+):\s*(\d+)", line)

		if not match:
			continue

		key, count = match.groups()

		current = accum.get(key, 0)

		accum[key] = current + int(count)

for key, count in accum.items():
	print("%25s %4s" % (str(key) + ":", count))
