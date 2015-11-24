__author__ = 'katie'

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.collections import PatchCollection
import matplotlib.patches as mpatches
import matplotlib.lines as lines
import os, csv

class Reg():
    def __init__(self):
        self.id = str
        self.cov_beta = float
        self.avg_val = float
        self.hi = float
        self.low = float



root = '/media/truecrypt1/SocCog/results/noMV_noval_1stvs2nd_wbp_cov/lrn/'

clust_files = [1, 3, 6, 12, 15, 16, 20, 21, 23, 24, 26, 28]
subjects = {}

S_strs = ['SR1_lo', 'SR1_hi', 'SI1_lo', 'SI1_hi', 'SR2_lo', 'SR2_hi', 'SI2_lo', 'SI2_hi']
YN_strs = ['YNR1_lo', 'YNR1_hi', 'YNI1_lo', 'YNI1_hi', 'YNR2_lo', 'YNR2_hi', 'YNI2_lo', 'YNI2_hi']
reg_ord_s = ['LSRF', 'LSIF', 'LSRS', 'LSIS']
reg_ord_yn = ['LYNRF', 'LYNIF', 'LYNRS', 'LYNIS']
regs = {}
ax1vals = []
ax2vals = []

for clust in clust_files:
    data_file = os.path.join(root, 'regandcovclust' + str(clust) + '.csv')
    with open(data_file, 'r') as data:
        for row in csv.DictReader(data):
            r = Reg()
            r.id = row['regressor']
            r.cov_beta = row['cov_beta']
            r.avg_val = row['avg_val']
            r.hi = row['predplus']
            r.low = row['predminus']
            regs[r.id] = r
    for reg in reg_ord_s:
        ax1vals.append(float(regs[reg].low))
        ax1vals.append(float(regs[reg].hi))
    for reg in reg_ord_yn:
        ax2vals.append(float(regs[reg].low))
        ax2vals.append(float(regs[reg].hi))

    #ax1ses = getattr([avg.regs[id].se for id in reg_strs])
    colors = ['blue', '#97FF00', 'orange', 'purple', 'cyan', 'red', 'magenta', 'green']
    X = np.arange(8)
    xshift = [.2, -.1, .1, -.2, .2, -.1, .1, -2]
    X = [x + xshift[x] for x in X]
    fig, (ax1, ax2) = plt.subplots(ncols=1, nrows=2)
    for i in range(8):
        ax1.bar(X[i], ax1vals[i], color=colors[i], width=0.25, alpha = .8, zorder=2)
        ax2.bar(X[i], ax2vals[i], color=colors[i], width=0.25, alpha = .8, zorder=2)
    ax1.set_xticklabels(S_strs)
    ax2.set_xticklabels(YN_strs)
    line_xs = ax1.get_xlim()
    line_ys = [0, 0]
    ax1.add_line(lines.Line2D(line_xs, line_ys, linewidth=1, alpha=.5, color='black'))


    plt.show()



