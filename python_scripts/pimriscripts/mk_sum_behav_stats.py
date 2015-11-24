__author__ = 'katie'

import os, csv
import numpy as np

class Subject():
    def __init__(self):
        self.id  = str
        self.namedict = {}
        self.Slist = []
        self.Ylist = []
        self.Nlist = []
        self.all_answers = []
        self.num_list = []
        self.runs = []


class Run():
    def __init__(self):
        self.id = str
        self.name = str
        self.type = str
        self.score = float
        self.num = str

Msubs = {}
Lsubs = []
goodsubs = ['7404', '7408', '7412', '7414', '7418', '7430', '7432',
            '7436', '7443', '7453', '7458', '7474', '7477', '7478', '7480',
            '7498', '7508', '7521', '7533', '7534', '7542', '7558', '7561',
            '7562', '7575', '7580', '7607', '7613', '7619', '7623', '7638',
            '7641', '7645', '7648', '7649', '7659', '7714', '7719', '7726']

runlist = ['run1L1', 'run1L2', 'run1L3', 'run1L4', 'run1L5', 'run1L6',
           'run2L1', 'run2L2', 'run2L3', 'run2L4', 'run2L5', 'run2L6',
           'run1M1', 'run1M2', 'run1M3', 'run1M4', 'run1M5', 'run1M6',
           'run2M1', 'run2M2', 'run2M3', 'run2M4', 'run2M5', 'run2M6']

bad_runs = {'7432': [runlist[3] + runlist[15]],
            '7404': runlist[0:6] + runlist[12:18],
            '7436': runlist[0] + runlist[12],
            '7641': runlist[6] + runlist[18],
            '7726': runlist[6] + runlist[18]}
#note: runs are bad either if learning imaging data are missing.
#runs for which memory imaging data are missing but behavioral data were
#collected successfully are good.

root = '/media/truecrypt1/SocCog/eprime_data'
sub_path = '/media/truecrypt1/SocCog/results/noMV_noval_1stvs2nd_wbp_cov_new/lrn'

f = open(os.path.join(root, 'ks-trialsdata-wtrialtypename-targetname-behavioral.csv'), 'r')

for line in csv.DictReader(f, dialect='excel', delimiter=','):
    subid = line['subject']
    if subid not in goodsubs:
        continue
    runid = line['run']
    if subid in bad_runs.keys() and runid in bad_runs[subid]:
        continue
    if 'M' not in runid:
        continue
    if subid not in [k for k in Msubs.keys()]:
        s = Subject()
        s.id = subid
        Msubs[s.id] = s
    name = line['name']
    fullcond = line['fullcond']
    if fullcond[-2:] == 'RU':
        if name in s.namedict.keys():
            s.namedict[name].append(line['ans'])
        else:
            s.namedict[name] = [line['ans']]
f.close()

f = open(os.path.join(root, 'ks-trialsdata-wtrialtypename-targetname-behavioral.csv'), 'r')

for line in csv.DictReader(f, dialect='excel', delimiter=','):
    subid = line['subject']
    if subid not in goodsubs:
        continue
    runid = line['run']
    if subid in bad_runs.keys() and runid in bad_runs[subid]:
        continue
    if 'L' not in runid:
        continue
    name = line['name']
    if subid not in [sub.id for sub in Lsubs]:
        s = Subject()
        s.id = subid
        Lsubs.append(s)
    if runid not in [run.id for run in s.runs]:
        r = Run()
        r.id = runid
        r.name = name
        r.answers = [float(ans) for ans in Msubs[s.id].namedict[name]]
        r.score = np.mean(r.answers)
        s.runs.append(r)
        r.type = line['type']
        for m, t in enumerate(['S', 'Y', 'N']):
            if r.type == t:
                r.num = str(m+1)
        if line['type'] == 'S':
            s.Slist.append(r)
        if line['type'] == 'Y':
            s.Ylist.append(r)
        if line['type'] == 'N':
            s.Nlist.append(r)
        s.all_answers = s.all_answers + r.answers

all_answers = []

for sub in Lsubs:
    all_answers = all_answers + sub.all_answers

answer_mean = np.mean(all_answers)

for sub in Lsubs:
    for target in [sub.Slist, sub.Ylist, sub.Nlist]:
        for run in target:
            run.mean_centered = run.score - answer_mean
        target = sorted(target, key=lambda x: x.id)

Lsubs = sorted(Lsubs, key=lambda x: int(x.id))

covlist = []
Scovlist = []
Ycovlist = []
Ncovlist= []

outfile = open(os.path.join(root, 'RUavgbyrun.csv'), 'w')

for Lsub in Lsubs:
    for cat in [Lsub.Slist, Lsub.Ylist, Lsub.Nlist]:
        for run in cat:
            outfile.write(",".join([Lsub.id, run.id, run.type, str(run.score), str(run.mean_centered)]))
            outfile.write("\n")
            Lsub.num_list.append(run.num)
            covlist.append(str(run.score))
            for poss_cat in [('S', Scovlist), ('Y', Ycovlist), ('N', Ncovlist)]:
                if run.type == poss_cat[0]:
                    poss_cat[1].append(str(run.mean_centered))
                else:
                    poss_cat[1].append('0')
    with open(os.path.join(sub_path, Lsub.id, 'runs.txt'), 'w') as sub_file:
        sub_file.write(' '.join(Lsub.num_list))
    with open(os.path.join(sub_path, Lsub.id, 'oneruns.txt'), 'w') as sub_file:
        sub_file.write(' '.join(['1' for run in Lsub.num_list]))

outfile.close()

file_list = [(covlist, 'covlist.csv'), (Scovlist, 'Scovlist.csv'), (Ycovlist, 'Ycovlist.csv'),
    (Ncovlist, 'Ncovlist.csv')]

for pair in file_list:
    with open(os.path.join(sub_path, pair[1]), 'w') as covcsv:
     covcsv.write('\n'.join(pair[0]))


