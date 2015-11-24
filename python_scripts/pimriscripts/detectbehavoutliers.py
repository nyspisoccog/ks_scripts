__author__ = 'katie'

import os
import csv
import numpy as np

class Subject():
    def __init__(self):
        self.id = str
        self.Ss = []
        self.Ys = []
        self.Ns = []
        self.Smean = float
        self.Ymean = float
        self.Nmean = float

class Diff():
    def __init__(self):
        self.id = str
        self.vals = []
        self.mean = float
        self.std = float
        self.zs = []
        self.abzs = []

root = '/media/truecrypt1/SocCog/eprime_data'

rows = []
subjects = {}

dead_to_me = ['7413', '7403', '7404', '7418', '7436', '7521', '7533', '7534', '7480',
              '7561', '7619', '7659', '7641', '7480', '7477']

in_fname = os.path.join(root, 'RU.csv')

with open(in_fname, 'r') as in_file:
    reader = csv.DictReader(in_file)
    for row in reader:
        rows.append(row)
        id = row['subject']
        if id in dead_to_me:
            continue
        if row['ans'] == '3.5':
            continue
        if id not in subjects.keys():
            s = Subject()
            s.id = id
            subjects[id] = s
        typ = row['type']
        if typ == 'N':
            subjects[id].Ns.append(row)
        if typ == 'S':
            subjects[id].Ss.append(row)
        if typ == 'Y':
            subjects[id].Ys.append(row)
SY = Diff()
SY.id = 'SY'

for id, sub in subjects.items():
    sub.Smean = np.mean([float(row['ans']) for row in sub.Ss])
    sub.Ymean = np.mean([float(row['ans']) for row in sub.Ys])
    sub.Nmean = np.mean([float(row['ans']) for row in sub.Ns])
    sub.SY = sub.Smean - sub.Ymean
    sub.SN = sub.Smean - sub.Nmean
    sub.globmean = np.mean([float(row['ans']) for row in sub.Ss + sub.Ys +
        sub.Ns])
    SY.vals.append(sub.SY)

SY.mean = np.mean(SY.vals)
SY.std = np.std(SY.vals)

for k, sub in subjects.items():
    print sub.id
    print abs((sub.SY-SY.mean)/SY.std)
    print "\n"







