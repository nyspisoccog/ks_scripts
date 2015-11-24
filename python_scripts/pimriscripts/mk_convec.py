__author__ = 'katie'

import os, csv, uf
from copy import deepcopy


root = '/media/truecrypt1/SocCog/SocCog/cond_onsets_noMV_noval'

f = open(os.path.join(root, 'ks-trialsdata-wtrialtypename-noMV-noval.csv'), 'r')
last_sub = ''
subs_lrn = []
subs_mem = []


class Subject(object):
    def __init__(self, id='', runlist = []):
        self.id = id
        self.runlist = runlist
        self.conds = []
        self.LYcount = 0
        self.LScount = 0
        self.LNcount = 0
        self.convec = []

class Run(object):
    def __init__(self, id='', condlist = []):
        self.id = id
        self.conds = []

subjects = ['7404', '7408', '7412', '7414', '7418', '7430', '7432',
            '7436', '7443', '7453', '7458', '7474', '7477', '7478', '7480',
            '7498', '7508', '7521', '7533', '7534', '7542', '7558', '7561',
            '7562', '7575', '7580', '7607', '7613', '7619', '7623', '7638',
            '7641', '7645', '7648', '7649', '7659', '7714', '7719', '7726']

for lm in ['lrn', 'mem']:
    for sub in subjects:
        s = Subject(id=sub)
        subdir = os.path.join(root, lm, sub)
        runlist = []
        for d in os.listdir(subdir):
            if d[0:3] == 'run':
                r = Run(id = d)
                runlist.append(r)
                cond_file = os.path.join(subdir, d, "conds.txt")
                cond_list = []
                conds = open(cond_file, 'r')
                for line in conds.readlines():
                    cond_list.append(line)
        s.runlist = runlist
        for run in s.runlist:
            s.conds = s.conds + run.conds
            if lm == 'L':
                if 'LYI' in r.conds:
                    s.LYcount += 1
                if 'LSI' in r.conds:
                    s.LScount += 1
                if 'LNI' in r.conds:
                    s.LNcount += 1
        counter = 0
        for c in s.conds:
            counter += 1
            if c == 'LYI':

            if counter%2 == 0:
                convec += [0 0 0 0 0 0]

        subs_lrn.append(s)







for line in csv.DictReader(f, dialect='excel', delimiter='\t'):
    fullcond = line['fullcond']
    lm = fullcond[0]
    subject = line['subject']
    if subject != last_sub:
        last_sub = subject
        if lm == 'L':
            subs_lrn[subject] = []
        if lm == 'M':
            subs_mem[subject] = []
    if lm == 'L':
        if fullcond not in

