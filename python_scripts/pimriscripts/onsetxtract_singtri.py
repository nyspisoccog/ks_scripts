__author__ = 'katie'

import os, csv, uf
from copy import deepcopy

class Subrun(object):
    def __init__(self, id='', subid='', runid='', conds=[]):
        self.id = id
        self.subid = subid
        self.runid = runid
        self.conds = []

class Cond(object):
    def __init__(self, id='', onsets=[]):
        self.id = id
        self.onsets = []

root = '/media/truecrypt1/SocCog/SocCog/cond_onsets_singtri'

f = open(os.path.join(root, 'ks-trialsdata-noMV-singtri.csv'), 'r')
last_run = ''
subruns = []

for line in csv.DictReader(f, dialect='excel', delimiter='\t'):
    subject = line['subject']
    run = line['run']
    run_name = subject + run
    tricond = line['singletrial']
    if run_name != last_run and last_run != '':
        subruns.append(deepcopy(subrun))
        subrun = Subrun(subid=subject, runid=run, id=run_name, conds = [])
    if run_name != last_run:
        subrun = Subrun(subid=subject, runid=run, id=run_name, conds = [])
    if tricond not in [cond.id for cond in subrun.conds]:
        subrun.conds.append(Cond(id=tricond))
    for cond in subrun.conds:
        if cond.id == tricond:
            onset = line['onset']
            if len(line['RT'])>1:
                RT = line['RT']
            if len(line['ans'])>1:
                ans = line['ans'][1:]
            if cond.id[0] == 'M':
                cond_nums = (onset, RT, ans)
            if cond.id[0] == 'L':
                cond_nums = (onset, RT)
            cond.onsets.append(cond_nums)


    last_run = run_name

for subrun in subruns:
    if 'L' in subrun.id: lm = 'lrn'
    if 'M' in subrun.id: lm = 'mem'
    outpath = uf.buildtree(root, [lm, subrun.subid, subrun.runid])
    out = open(os.path.join(outpath, 'conds.txt'), 'w')
    out.write('\n'.join([cond.id for cond in subrun.conds]))
    out.close()
    for cond in subrun.conds:
        cond.onsets = sorted(cond.onsets, key=lambda tup:float(tup[0]))
        cond_out = open(os.path.join(outpath, cond.id + '.txt'), 'w')
        cond_out.write('\n'.join([str(onset[0]) for onset in cond.onsets]))
        cond_out.close()
        RT_out = open(os.path.join(outpath, cond.id + '_RT.txt'), 'w')
        RT_out.write('\n'.join([str(onset[1]) for onset in cond.onsets]))
        RT_out.close()
        if cond.id[0] == 'M':
            ans_out = open(os.path.join(outpath, cond.id + '_ans.txt'), 'w')
            ans_out.write('\n'.join([str(onset[2]) for onset in cond.onsets]))








