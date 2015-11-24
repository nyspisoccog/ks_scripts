__author__ = 'katie'

import os, csv, uf
from copy import deepcopy

class Subrun(object):
    def __init__(self, id='', subid='', runid='', conds=[]):
        self.id = id
        self.subid = subid
        self.runid = runid
        self.conds = conds

class Cond(object):
    def __init__(self, id='', onsets=[]):
        self.id = id
        self.onsets = []

root = '/media/truecrypt1/SocCog/SocCog/tmp2'

f = open(os.path.join(root, 'ks-trialsdata-wtrialtypename.csv'), 'r')
last_run = ''
subruns = []

for line in csv.DictReader(f, dialect='excel', delimiter='\t'):
    subject = line['subject']
    run = line['run']
    run_name = subject + run
    fullcond = line['fullcond']
    if run_name != last_run and last_run != '':
        subruns.append(deepcopy(subrun))
        subrun = Subrun(subid=subject, runid=run, id=run_name, conds = [])
    if run_name != last_run:
        subrun = Subrun(subid=subject, runid=run, id=run_name, conds = [])
    if fullcond not in [cond.id for cond in subrun.conds]:
        subrun.conds.append(Cond(id=fullcond))
    for cond in subrun.conds:
        if cond.id == fullcond:
            cond.onsets.append(line['onset'])
            cond.onsets = sorted([float(onset) for onset in cond.onsets])
    last_run = run_name

for subrun in subruns:
    outpath = uf.buildtree(root, [subrun.subid, subrun.runid])
    out = open(os.path.join(outpath, 'conds.txt'), 'w')
    out.write('\n'.join([cond.id for cond in subrun.conds]))
    out.close()
    for cond in subrun.conds:
        out = open(os.path.join(outpath, cond.id + '.txt'), 'w')
        out.write('\n'.join([str(onset) for onset in cond.onsets]))
        out.close()









