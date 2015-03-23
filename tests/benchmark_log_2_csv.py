#!/usr/bin/env python3

### log file is line based

import collections
import sys

REFERENCE_MODE = 'normal'

def main(argv):
	# drop name of script from args
	name = argv[0]
	argv = argv[1:]

	if not argv:
		input  = sys.stdin
		output = sys.stdout
	elif len(argv) == 1:
		input  = open(argv[0], 'r')
		output = sys.stdout
	elif len(argv) == 2:
		input  = open(argv[0], 'r')
		output = open(argv[1], 'w')
	else:
		print('usage: {name} [INPUT [OUTPUT]]'.format(name=name), file=sys.stderr)

	data = parse_log(input)
	data = average_data(data)
	data = normalize_data(data)

	print_csv(data, output)

def parse_log(input):
	mode      = None
	benchmark = None
	data      = Matrix(2, default=list)

	data.name_dimension('modes',      0)
	data.name_dimension('benchmarks', 1)

	lineno = 0

	for line in input:
		lineno += 1

		line = line.strip()

		# skip empty lines and comments
		if not line or line.startswith('#'):
			continue

		if line.startswith('MODE'):
			line      = line[len('MODE'):].strip()
			mode      = line
			continue

		if line.startswith('BENCHMARK'):
			line      = line[len('BENCHMARK'):].strip()
			benchmark = line
			continue

		try:
			result = float(line)
		except ValueError:
			error('In line ' + str(lineno) + ": Invalid line " + repr(line) + ", expected a benchmark result (a float)")

		if mode is None:
			error('In line ' + str(lineno) + ': Benchmark result before first MODE directive')
		if benchmark is None:
			error('In line ' + str(lineno) + ': Benchmark result before first BENCHMARK directive')

		results = setdefault(data, (mode, benchmark), list)

		# benchmarks = setdefault(data,       mode,      collections.OrderedDict)
		# results    = setdefault(benchmarks, benchmark, list)
		results.append(result)

	return data

def average_data(data):
	"""
		`data' maps benchmark names to lists of timings.
		This step combines timings lists into a single number.
	"""

	new_data = data.copy(default=0)

	for key in data:
		results       = data[key]
		new_data[key] = combine_results(results)

	return new_data

def normalize_data(data):
	if REFERENCE_MODE not in data.modes:
		warning('could not not normalize data, reference benchmark set was not run')
		return data

	references = data.copy()

	for mode, benchmark in data:
		if benchmark not in references.benchmarks:
			warning('no reference for benchmark', benchmark)

		reference = references[REFERENCE_MODE, benchmark]
		result    = data[mode, benchmark]

		try:
			normalized = result / reference
		except ZeroDivisionError as e:
			warning(e, "(" + str(result), '/', str(reference) + ')')
			normalized = result

		data[mode, benchmark] = normalized

	return data

def print_csv(data, output):
	y_axis = data.benchmarks
	x_axis = data.modes

	if not data:
		warning('printing CSV for empty matrix')
		return

	## find widths of columns for prettier printing

	column_lens = Matrix(1, default=8)

	for x in x_axis:
		column_lens[x] = max(column_lens[x], len(x))

	label_column = 'benchmark'

	label_column_len = max(max(map(len, y_axis)), len(label_column) + 1)

	## print header
	print(
		label_column.ljust(label_column_len),
		*[x.ljust(column_lens[x]) for x in x_axis],
		sep=', '
	)

	def fmt(num):
		return '%3.5f' % (num,)

	## print matrix
	for y in y_axis:
		print(
			y.ljust(label_column_len),
			*[('%3.5f' % (data[x, y],)).rjust(column_lens[x]) for x in x_axis],
			sep=', '
		)

def combine_results(results):
	return average(results)

def average(seq):
	lst = list(seq)

	return sum(lst) / len(lst)

def median(seq):
	lst = sorted(seq)

	if not lst:
		return None
	if len(lst) % 2:
		return lst[len(lst)//2]
	else:
		return (lst[len(lst)//2] + lst[idiv_up(len(lst), 2)]) / 2

def geometric_mean(seq):
	lst     = list(seq)
	product = 1

	for item in lst:
		product = product * item

	return product ** (1.0/len(lst))

def idiv_up(n, d):
	"""Integer division of `n' by `d', rounding up."""

	return (n + d // 2) // d

def setdefault(map, key, thunk):
	try:
		return map[key]
	except KeyError:
		val = thunk()
		map[key] = val
		return val

def nub(seq):
	nub = set()
	out = []

	for item in seq:
		if item not in nub:
			nub.add(item)
			out.append(item)

	return out

UNIQUE = object()

class Matrix:
	def __init__(self, dimensions, indexer=lambda k: k, default=0):
		self.data       = collections.OrderedDict()
		self.dimensions = dimensions
		self.indexer    = indexer
		self.default    = default if callable(default) else lambda: default

		self.dimension_aliases = {}

	def copy(self, dimensions=UNIQUE, indexer=UNIQUE, default=UNIQUE):
		dimensions = dimensions if dimensions is not UNIQUE else self.dimensions
		indexer    = indexer    if indexer    is not UNIQUE else self.indexer
		default    = default    if default    is not UNIQUE else self.default

		copy                   = Matrix(dimensions, indexer, default)
		copy.data              = self.data.copy()
		copy.dimension_aliases = self.dimension_aliases.copy()

		return copy

	def __getitem__(self, key):
		key = key if type(key) is tuple else (key,)

		assert len(key) == self.dimensions

		key = self.indexer(key)

		try:
			return self.data[key]
		except KeyError:
			return self.data.setdefault(key, self.default())

	def __contains__(self, key):
		key = key if type(key) is tuple else (key,)
		key = self.indexer(key)

		return key in self.data

	def __setitem__(self, key, val):
		key = key if type(key) is tuple else (key,)

		assert len(key) == self.dimensions

		key = self.indexer(key)

		self.data[key] = val

	def __bool__(self):
		return bool(self.data)

	def dimension(self, dimension):
		out = []

		for key in self.data.keys():
			out.append(key[dimension])

		return nub(out)

	def name_dimension(self, name, dimension):
		self.dimension_aliases[name] = dimension

	def __getattr__(self, name):
		try:
			dimension = self.dimension_aliases[name]
		except KeyError:
			raise AttributeError(name)

		return self.dimension(dimension)

	def __iter__(self):
		return iter(self.data)

	def items(self):
		return self.data.items()

	def __str__(self):
		def txt(key):
			return str(self.indexer(key)) + '=' + str(self.data[key])

		return 'Matrix{' + ", ".join(map(txt, self.data)) + "}"

def error(*args, **kwargs):
	print('error:', *args, file=sys.stderr, **kwargs)
	exit(1)

def warning(*args, **kwargs):
	print('warning:', *args, file=sys.stderr, **kwargs)

if __name__ == '__main__':
	main(sys.argv)
