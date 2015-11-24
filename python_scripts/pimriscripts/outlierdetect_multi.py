__author__ = 'katie'

import os
import csv

root = '/media/truecrypt1/SocCog/results/noMV_noval_1stvs2nd_wbp_cov_new/lrn/con5'
outliers = {}

for clust in [1, 3, 6, 12, 15, 16, 20, 21, 23, 24, 26, 28]:
    fname = 'MDclust' + str(clust) + '.csv'
    fpath = os.path.join(root, fname)
    with open(fpath, 'r') as f:
        for i, row in enumerate(csv.DictReader(f)):
            if row['is.outlier'] == 'TRUE':
                print row['subject'] + "   " + row['descrip'] + ' is an outlier on ' + str(clust)
                print "It's MD^2 is " + row['mah_d']
                print " "
                row['num'] = i + 2
                if i + 2 not in outliers.keys():
                    outliers[i + 2] = row

outfname = os.path.join(root, 'outliers' + '.csv')
with open(outfname, 'w') as outfile:
    writer = csv.writer(outfile)
    writer.writerow(['subj', 'tt', 'con', 'num'])
    for key in sorted(outliers):
        row = outliers[key]
        descrip = row['descrip']
        ind_0 = descrip.find('-')
        ind_1 = descrip.find(':')
        con = descrip[ind_0+1:ind_1]
        tt = descrip[ind_1 + 2]
        writer.writerow([row['subject'], con, tt, row['num']])