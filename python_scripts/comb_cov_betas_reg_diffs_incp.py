__author__ = 'katie'

import os, csv
import numpy as np



class Reg:
    def __init__(self):
        self.id = str
        self.vals = []
        self.mean = float

att_list = ["LSRS", "LSRF", "LSIS", "LSIF", "LYRS", "LYRF", "LYIS", "LYIF",
            "LNRS", "LNRF", "LNIS", "LNIF", "LYNRS", "LYNRF", "LYNIS", "LYNIF",
            "LSR", "LSI", "LYR", "LYI", "LNR", "LNI", "LYNR", "LYNI",
            "LS", "LY", "LN", "LYN", "all", "L"]

reg_dict = {}

for att in att_list:
    r = Reg()
    r.id = att
    reg_dict[att] = r

clust_list = [1, 3, 6, 12, 15, 16, 20, 21, 23, 24, 26, 28]

root = '/media/truecrypt1/SocCog/results/noMV_noval_1stvs2nd_wbp_cov/lrn'

for clust in clust_list:
    covb_fname = os.path.join(root, 'clust' + str(clust) + '.csv')
    regval_fname = os.path.join(root, 'RU-SvYNclustno' + str(clust) + '.csv')
    with open(regval_fname, 'r') as regval:
        for line in csv.DictReader(regval):
            for reg_name, val in line.items():
                if val != '' and reg_name != 'subject':
                    reg_dict['all'].vals.append(float(val))
                    reg_dict[reg_name[0:4]].vals.append(float(val))

    att_subset = ['LSRS', 'LSRF', 'LSIS', 'LSIF', 'LYRS', 'LYRF', 'LYIS', 'LYIF',
                  'LNRS', 'LNRF', 'LNIS', 'LNIF']
    reg_dict['all'].mean = np.mean(reg_dict['all'].vals)
    grand_mean = reg_dict['all'].mean
    for att in att_subset:
        reg_dict[att].mean = np.mean(reg_dict[att].vals)# - grand_mean

    avg_trips = [('LYRS', 'LNRS', 'LYNRS'), ('LYRF', 'LNRF', 'LYNRF'),
                 ('LYIS', 'LNIS', 'LYNIS'), ('LYIF', 'LNIF', 'LYNIF')]

    dif_trips = [('LSRS', 'LSRF', 'LSR'), ('LYRS', 'LYRF', 'LYR'),
                 ('LNRS', 'LNRF', 'LNR'), ('LYNRS', 'LYNRF', 'LYNR'),
                 ('LSIS', 'LSIF', 'LSI'), ('LYIS', 'LYIF', 'LYI'),
                 ('LNIS', 'LNIF', 'LNI'), ('LYNIS', 'LYNIF', 'LYNI'),
                 ('LSR', 'LSI', 'LS'), ('LYR', 'LYI', 'LY'),
                 ('LNR', 'LNI', 'LN'), ('LYNR', 'LYNI', 'LYN'),
                 ('LS', 'LYN', 'L')]
    for trip in avg_trips:
        reg_dict[trip[2]].mean = np.mean([reg_dict[trip[0]].mean, reg_dict[trip[1]].mean])

    for trip in dif_trips:
        print reg_dict[trip[0]].id
        print reg_dict[trip[0]].mean
        print reg_dict[trip[1]].id
        print reg_dict[trip[1]].mean
        reg_dict[trip[2]].mean = np.mean([reg_dict[trip[0]].mean, reg_dict[trip[1]].mean])

    out_fname = os.path.join(root, 'regandcovclust' + str(clust) + '.csv')

    out = open(out_fname, 'w')
    out.write(','.join(['regressor', 'cov_beta', 'avg_val', 'p', 'significant?',
                        'predplus', 'predminus']))
    out.write('\n')
    with open(covb_fname, 'r') as covb:
        for i, line in enumerate(csv.reader(covb)):
            if i > 0:
                reg_name = line[1]
                b = line[2]
                p = line[3]
                sig = line[4]
                predplus = line[5]
                predmnus = line[6]
                reg = reg_dict[reg_name].mean
                out.write(','.join([reg_name, b, str(reg), str(p), sig,
                                    str(predplus), str(predmnus)]))
                out.write('\n')

