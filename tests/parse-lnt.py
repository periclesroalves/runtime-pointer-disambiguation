#!/usr/bin/python

import json
import os

dirList = next(os.walk('.'))[1]

results = {}

for dir in dirList:
  try:
    f = open(dir + '/report.json')
  except:
    continue

  report = json.load(f)

  for test in report['Tests']:
    if not test['Name'].endswith('.exec'):
      continue

    if test['Name'] not in results:
      results[test['Name']] = []

    results[test['Name']].append(test['Data'][0])

results = { k:(sum(results[k])/float(len(results[k]))) for k in results}

for k in results:
  print k + '\t' + str(results[k])
