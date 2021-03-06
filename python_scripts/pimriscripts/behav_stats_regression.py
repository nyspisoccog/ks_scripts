__author__ = 'katie'

import os, csv
import numpy as np

class Subject():
    def __init__(self):
        self.id  = str
        self.Sbeh = []
        self.Ybeh = []
        self.Nbeh = []
        self.LSRS = []
        self.LSRF = []
        self.LSIS = []
        self.LSIF = []
        self.LYRS = []
        self.LYRF = []
        self.LYIS = []
        self.LYIF = []
        self.LNRS = []
        self.LNRF = []
        self.LNIS = []
        self.LNIF = []



Isubs = {}
Bsubs = {}
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

beh_root = '/media/truecrypt1/SocCog/eprime_data'
img_root = '/media/truecrypt1/SocCog/results/noMV_noval_1stvs2nd_wbp_cov/lrn'
beh_dat = open(os.path.join(beh_root, 'RUavgbyrun.csv'), 'r')

for line in csv.reader(beh_dat, dialect='excel', delimiter=','):
    subid = line[0]
    if subid not in Bsubs.keys():
        s = Subject()
        s.id = subid
        Bsubs[subid] = s
    for pair in [('S', s.Sbeh), ('Y', s.Ybeh), ('N', s.Nbeh)]:
        if line[2] == pair[0]:
            pair[1].append(line[4])
beh_dat.close()

clust_files = [1, 3, 6, 12, 15, 16, 20, 21, 23, 24, 26, 28]
for clust in clust_files:
    img_dat = open(os.path.join(img_root, 'RU-SvYNclustno' + str(clust) + '.csv'), 'r')
    for line in csv.DictReader(img_dat, dialect='excel', delimiter=','):
        subid = line['subject']
        if subid not in goodsubs:
            continue
        if subid not in [k for k in Isubs.keys()]:
            s = Subject()
            s.id = subid
            Isubs[s.id] = s
        for k, v in line.items():
            if k != 'subject' and v != '':
                target = k[1]
                reg_str = k[0:4]
                reg_ind = int(k[4]) - 1
                reg = getattr(s, reg_str)
                beh_sub = Bsubs[subid]
                for pair in [('S', beh_sub.Sbeh), ('Y', beh_sub.Ybeh),
                         ('N', beh_sub.Nbeh)]:
                    if target == pair[0]:
                        cov = pair[1][reg_ind]
                reg.append((cov, v))


    with open(os.path.join(img_root, 'RUcovforreg' + str(clust) + '.csv'), 'w') as out:
        for k, v in Isubs.items():
            lists = [('LSRS', v.LSRS), ('LSRF', v.LSRF), ('LSIS', v.LSIS), ('LSIF', v.LSIF),
                 ('LYRS', v.LYRS), ('LYRF', v.LYRF), ('LYIS', v.LYIS), ('LYIF', v.LSIF),
                 ('LNRS', v.LSRS), ('LNRF', v.LNRF), ('LNIS', v.LNIS), ('LNIF', v.LNIF)]
            for lst in lists:
                for pair in lst[1]:
                    out.write(','.join([k, lst[0], pair[0], pair[1]]))
                    out.write('\n')





