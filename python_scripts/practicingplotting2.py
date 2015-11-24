__author__ = 'katie'

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.collections import PatchCollection
import matplotlib.patches as mpatches
import os, csv

class Reg():
    def __init__(self):
        self.id = str
        self.ord = int
        self.clr = str
        self.rct = list
        self.mrk = str
        self.sig = str
        self.sgm = list
        self.lab = list
        self.cmp = list
        self.vls = list
        self.avg = float
        self.cvb = float
        self.pvl = float
        self.row = int
        self.pos = float

class Row():
    def __init__(self):
        self.ord = int
        self.delt = float
        self.maxy = float
        self.many = float
        self.regs = []
        self.difs = []
        self.labs = []
        self.rects = []
        self.rct_patches = PatchCollection

class Dif():
    def __init__(self):
        self.min = float
        self.max = float
        self.avs = float

root = '/media/truecrypt1/SocCog/results/noMV_noval_1stvs2nd_wbp_cov/lrn/'

clust_files = [1, 3, 6, 12, 15, 16, 20, 21, 23, 24, 26, 28]

for clust in clust_files:
    data_file = os.path.join(root, 'regandcovclust' + str(clust) + '.csv')
    regs = {}
    with open(data_file, 'r') as data:
        for line in csv.DictReader(data):
            r = Reg()
            regs[line['regressor']] = r
            r.id = line['regressor']
            r.cvb = float(line['cov_beta'])
            r.avg = float(line['avg_val'])
            r.pvl = float(line['p'])
            r.sig = line['significant?']
    regs1 = ('LSRB-LSRA', 'LSIB-LSIA', 'LYNRB-LYNRA', 'LYNIB-LYNIA')
    regs2 = ('LSR-LSI', 'LYNR-LYNI')
    regs3 = 'LS-LYN'

    reg_labs = [regs1, regs2, regs3]
    print reg_labs[2]

    reg_trips = [[('LSR', 'LSRS', 'LSRF'), ('LSI', 'LSIS', 'LSIF'),
            ('LYNR', 'LYNRS', 'LYNRF'), ('LYNI', 'LYNIS', 'LYNIF')],
            [('LS', 'LSR', 'LSI'), ('LYN', 'LYNR', 'LYNI')],
            [('L', 'LS', 'LYN')]]

    colors = [['blue', '#97FF00', 'orange', 'purple'],
           [ 'cyan', 'red'], ['magenta']]

    X3 = np.arange(4)
    xshift = [.2, -.1, .1, -.2]
    X3 = [x + xshift[x] for x in X3]
    X2 = [np.mean([X3[0], X3[1]]), np.mean([X3[2], X3[3]])]
    X1 = [np.mean([X2[0], X2[1]])]
    X = [X3, X2, X1]

    fig, (ax1, ax2, ax3) = plt.subplots(ncols=1, nrows=3)
    axes = [ax3, ax2, ax1]
    rows = []
    for i, trip_list in enumerate(reg_trips):
        row = Row()
        rows.append(row)
        row.miny = float('inf')
        row.maxy = float('-inf')
        for j, trip in enumerate(trip_list):
            row.labs.append(trip[0])
            reg = regs[trip[0]]
            row.regs.append(reg)
            reg.cmp = [regs[trip[1]], regs[trip[2]]]
            reg.row = i
            reg.ord = j
            reg.pos = X[i][j]
            reg.clr = colors[i][j]
            s = regs[trip[1]].avg
            m = regs[trip[2]].avg
            reg.min = min(s, m)
            reg.max = max(s, m)
            if reg.min < row.miny:
                row.miny = reg.min
            if reg.max > row.maxy:
                row.maxy = reg.max
            reg.dif = abs(s - m)
            if s >= m:
                reg.mrk = '^'
            else:
                reg.mrk = 'v'
            rect = mpatches.Rectangle([reg.pos - .1, reg.min], 0.2, reg.dif, ec="none",
                                  color=reg.clr)
            row.rects.append(rect)
        row.delt = abs(row.miny - row.maxy)*.1
        row.rct_patches = PatchCollection(row.rects, match_original=True)
        axes[i].add_collection(row.rct_patches)

    for i, row in enumerate(rows):
        axes[i].set_xticks(X[i])
        axes[i].set_xticklabels(reg_labs[i])
        axes[i].set_ylim(row.miny - .50, row.maxy + .50)
        axes[i].set_xlim(X[1][0] - .75, X[1][-1] + .7)
        for j, reg in enumerate(row.regs):
            if reg.mrk == '^':
                posy = reg.max + row.delt
            else:
                posy = reg.min - row.delt
            axes[i].plot(X[i][j], posy, reg.mrk, markersize=8, color=reg.clr)
            if reg.sig[0] == 'T':
                if reg.cvb > 0:
                    posy = reg.max + 2*row.delt
                else:
                    posy = reg.min - 2*row.delt
                axes[i].plot(X[i][j], posy, '*', markersize=10, color=reg.clr)
    plt.savefig(os.path.join(root, 'graphclust' + str(clust)))
    plt.close(fig)
    #plt.show()



