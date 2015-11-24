from __future__ import division

__author__ = 'katie'

import os
import csv
import numpy


class Target:
    def __init__(self):
        self.vals = []
        self.stvals = []
        self.mean = float
        self.std = float

root = '/media/truecrypt1/SocCog/results/noMV_noval_1stvs2nd_wbp_cov_new/lrn/'

covs = []
cov_fname = os.path.join(root, 'covlist.csv')
cov_file = open(cov_fname, 'r')
for row in csv.reader(cov_file):
    covs.append(row[0])
S = Target()
Y = Target()
N = Target()

clust_list = [1, 3, 6, 12, 15, 16, 20, 21, 23, 24, 26, 28]
for clust in clust_list:
    con = []
    fname = os.path.join(root, 'con5', 'RelvHalfConValsclustno' + str(clust) + '.csv')
    con_file = open(fname, 'r')
    for row in csv.DictReader(con_file):
        con.append(row)
    for row in con:
        for pair in [('S', S.vals), ('Y', Y.vals), ('N', N.vals)]:
            if row['TargetType'] == pair[0]:
                pair[1].append(1)
            else:
                pair[1].append(0)
    for target in [S,Y,N]:
        target.mean = numpy.mean(target.vals)
        target.std = numpy.mean(target.vals)
        target.stvals = [(val-target.mean)/target.std for val in target.vals]
    outfname = os.path.join(root, 'con5', 'cov_con_clustno' + str(clust) + '.csv')
    with open(outfname, 'w') as outfile:
        writer = csv.writer(outfile, delimiter = ',')
        writer.writerow(('subject', 'descrip', 'S', 'Y', 'N', 'RelxHalf', 'cov'))
        for i, row in enumerate(con):
            new_row = [con[i]['Subject'], con[i]['Descrip'], S.stvals[i], Y.stvals[i], N.stvals[i], con[i]['RelxHalfmean'], covs[i]]
            writer.writerow(new_row)





