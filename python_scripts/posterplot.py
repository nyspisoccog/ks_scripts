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

class Subject():
    def __init__(self):
        self.id  = str
        self.SR2 = float
        self.SR1 = float
        self.SI2 = float
        self.SI1 = float
        self.YR2 = float
        self.YR1 = float
        self.YI2 = float
        self.YI1 = float
        self.mean = float
        self.serr = float
        self.regs = {}

class Reg():
    def __init__(self):
        self.id
        self.se
        self.mean


root = '/Volumes/Untitled/results/noMV_noval_1stvs2nd_wbp/lrn/con3'

clust_files = [2, 3, 4, 7, 11]
subjects = {}
reg_strs = ['SR2', 'SI2', 'SR1', 'SI1','YR2', 'YI2', 'YR1', 'YI1']

for clust in clust_files:
    data_file = os.path.join(root, 'con3negativetclustno' + str(clust) + '.csv')
    with open(data_file, 'r') as data:
        for row in csv.DictReader(f):
            s = Subject()
            s.id = row['subject']
            s.LSRA = float(row['LSRF'])
            s.LSRB = float(row['LSRS'])
            s.LSIA = float(row['LSIF'])
            s.LSIB = float(row['LSIS'])
            s.LYRA = float(row['LYRF'])
            s.LYRB = float(row['LYRS'])
            s.LYIA = float(row['LYIF'])
            s.LYIB = float(row['LYIS'])
            subjects[id] = s
    avg = Subject()

    for reg in regs:
        mn = np.mean([getattr(s, reg) for id, s in subjects.items()])
        se = np.sterr([getattr(s, reg) for id, s in subjects.items()])
        r = Reg()
        r.mean = mn
        r.se = se
        r.id = reg
        avg.regs[reg] = r

    ax1means = getattr([avg.regs[id].mean for id in reg_strs])
    ax1ses = getattr([avg.regs[id].se for id in reg_strs])
    colors = ['blue', '#97FF00', 'orange', 'purple', 'cyan', 'red', 'magenta', 'green']
    X = np.arange(8)
    xshift = [.2, -.1, .1, -.2, .2, -.1, .1, -2]
    X = [x + xshift[x] for x in X3]
    fig, (ax1) = plt.subplots(ncols=1, nrows=1)
    for i in range(8):
        ax1.bar(X[i], ax1means[i], color=colors1[i], width=0.25, alpha = .8, zorder=2)
    line_xs = ax1.get_xlim()
    line_ys = [0, 0]
    ax1.add_line(lines.Line2D(line_xs, line_ys, linewidth=1, alpha=.5, color='black'))
    for i in range(8):
        line_xs = [ax1means[i], ax1means[i]]
        line_ys = [ax1means[i] - .5 * ax1ses[i], ax1means[i] - .5 * ax1ses[i]]
        ax1.add_line(lines.Line2D(line_xs, line_ys, linewidth=1, alpha=.5, color='black'))

    plt.show()



