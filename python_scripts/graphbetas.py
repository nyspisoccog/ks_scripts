__author__ = 'katie'

import matplotlib
import numpy as np
from numpy import mean
import matplotlib.patches as mpatches
from matplotlib.collections import PatchCollection
import matplotlib.pyplot as plt
import itertools as itr
import csv, os

class Subject():
    def __init__(self):
        self.id  = str

class Graph():
    def __init__(self):
        self.rows = []
        self.ymin = float
        self.ymax = float
        self.ticks = list
        self.labels = tuple

class Row():
    def __init__(self):
        self.subjects = []
        self.positions = []
        self.diffs = []
        self.patches = PatchCollection
        self.colors = list
        self.legend = list

class Rowsub():
    def __init__(self):
        self.diffs = []
        self.id = str
        self.patches = PatchCollection

class Diff():
    def __init__(self):
        self.min = float
        self.s = float
        self.m = float
        self.d = float
        self.pair = tuple
        self.subid = str
        self.positions = []
        self.direction = str


root = '/media/truecrypt1/SocCog/results/noMV_noval_1stvs2nd_wbp/lrn'
contrasts = ['con3']

fname = 'con3negativetclustno1.csv'

for clust in [2, 3, 4, 7, 11]:
    fname = 'con3negativetclustno'+ str(clust) + '.csv'
    f = open(os.path.join(root, contrasts[0], fname))

    subjects = []

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
        s.LSA = s.LSRA - s.LSIA
        s.LSB = s.LSRB - s.LSIB
        s.LYA = s.LYRA - s.LYIA
        s.LYB = s.LYRB - s.LYIB
        s.LSR = s.LSRB - s.LSRA
        s.LSI = s.LSIB - s.LSIA
        s.LYR = s.LYRB - s.LYRA
        s.LYI = s.LYIB - s.LYIA
        s.LIA = s.LSIA - s.LYIA
        s.LIB = s.LSIB - s.LYIB
        s.LRA = s.LSRA - s.LYRA
        s.LRB = s.LSRB - s.LYRB
        s.LS = s.LSR - s.LSI
        s.LY = s.LYR - s.LYI
        s.LR = s.LSR - s.LYR
        s.LI = s.LSI - s.LYI
        s.LA = s.LRA - s.LIA
        s.LB = s.LRB - s.LIB
        subjects.append(s)

    avg = Subject()
    avg.id = 'avg'
    attlist = ['LSRA', 'LSRB', 'LSIA', 'LSIB', 'LYRA', 'LYRB', 'LYIA', 'LYIB', 'LSA', 'LSB', 'LYA', 'LYB', 'LA', 'LB',
               'LSR', 'LSI', 'LYR', 'LYI', 'LIA', 'LRA', 'LIB', 'LRB', 'LS', 'LY', 'LR', 'LI']

    for att in attlist:
        setattr(avg, att, float(np.mean([getattr(sub, att) for sub in subjects])))

    subjects.insert(0, avg)

    varpairs = [('LSIA', 'LSRA'), ('LSIB', 'LSRB'), ('LYIA', 'LYRA'), ('LYIB', 'LYRB'),
                ('LSI', 'LSR'), ('LSA', 'LSB'), ('LRA', 'LRB'), ('LYI', 'LYR'), ('LYA', 'LYB'), ('LIA', 'LIB'),
                ('LS', 'LY'), ('LA', 'LB'),('LR', 'LI')]

    pairs = []
    vars = ['Rel', 'Half', 'Type']
    hier_dict = {'Type':['S', 'Y'], 'Rel':['R', 'I'], 'Half':['B', 'A']}
    orders = itr.permutations(vars)
    for i, order in enumerate(orders):
        pairs.append([])
        for j, cat in enumerate(order):
            pairs[i].append([])
            length = 4-j
            if j == 0:
                verboten = []
            if j == 1:
                verboten = hier_dict[cat]
            if j == 2:
                verboten = hier_dict[cat] + hier_dict[order[j-1]]
            for varpair in varpairs:
                boo = True
                if len(varpair[0]) != length:
                    boo = False
                for letter in verboten:
                    if letter in varpair[0]+varpair[1]:
                        boo = False
                if boo == True:
                    pairs[i][j].append(varpair)

    graphs = []
    for i, graphset in enumerate(pairs):
        g = Graph()
        g.ticks = range(len(subjects))
        g.positions = [list([[x - .3, x -.1, x + .1, x + .3] for x in g.ticks]), \
                       list([[x - .1, x + .1] for x in g.ticks]), [[x] for x in g.ticks]]
        g.labels = tuple([sub.id for sub in subjects])
        ymin = float('Inf')
        ymax = -float('Inf')
        for j, row in enumerate(graphset):
            r = Row()
            r.positions = g.positions[j]
            cols = np.linspace(0, 1, len(row.positions[0]))
            for l, pair in enumerate(row):
                for lab in pair:
                    leg_patch = mpatches.Patch(color=cols(l), label=lab)
                    r.legend.append(leg_patch)

            #r.flatpositions = [item for sublist in positions for item in sublist]
            for k, sub in enumerate(subjects):
                rs = Rowsub()
                rs.positions = r.positions[k]
                diffs = []
                patches = []
                for l, pair in enumerate(row):
                    s = getattr(sub, pair[1])
                    m = getattr(sub, pair[0])
                    difference = s-m
                    endpoints = [s, m]
                    for point in endpoints:
                        if point > ymax: ymax = point
                        if point < ymin: ymin = point
                    #diff = Diff(min = min(s,m), s = s, m = m, d = difference, pair=pair, subid=sub.id)
                    diff = Diff()
                    diff.min = min(s,m); diff.s = s; diff.m = m; diff.d = difference; diff.pair = pair; diff.subid = sub.id
                    if s > m: diff.direction = 'up'
                    else: diff.direction = 'down'
                    diffs.append(diff)
                    rect = mpatches.Rectangle([rs.positions[l], diff.min], 0.25, abs(diff.d), ec="none")
                    #arrow = mpatches.Arrow(rs.positions[l], diff.m, 0, diff.d, width=0.2)
                    #patches.append(arrow)
                    patches.append(rect)
                rs.colors = np.linspace(0, 1, len(diffs))
                rs.patches = PatchCollection(patches, cmap=matplotlib.cm.jet, alpha=0.4)
                rs.patches.set_array(np.array(rs.colors))
                rs.diffs = diffs
                rs.id = sub.id
                r.subjects.append(rs)

            g.rows.append(r)
        delta = abs(ymax - ymin) * .15
        g.ymin = ymin - delta
        g.ymax = ymax + delta
        graphs.append(g)



    for graphno, graph in enumerate(graphs):
        fig, (ax1, ax2, ax3) = plt.subplots(ncols=1, nrows=3, sharex=True, sharey=True)
        fig.set_size_inches(80,30)
        axes = [ax3, ax2, ax1]
        plt.xticks(graph.ticks, graph.labels)
        plt.tick_params(labelsize=40)
        plt.xlim(graph.ticks[0] -.4 , g.ticks[-1] + .4)
        plt.ylim(graph.ymin, graph.ymax)
        for i, row in enumerate(graph.rows):
            axes[i].legend(handles=row.legend)
            for j, rowsub in enumerate(row.subjects):
                axes[i].add_collection(rowsub.patches)
                for k, diff in enumerate(rowsub.diffs):
                    vars = {}
                    for lab in diff.pair:
                        id = rowsub.id
                        for sub in subjects:
                            if sub.id == id:
                                vars[lab] = getattr(sub, lab)
                    for name, num in vars.items():
                        if num == max(val for val in vars.values()):
                            ylabcor = 4
                        else:
                            ylabcor = -8
                        axes[i].annotate(name, xy=(rowsub.positions[k], num), xycoords='data',
                                         xytext = (-5,ylabcor), textcoords='offset points', size='x-small')
        plt.tight_layout()
        #plt.show()
        plt.savefig(os.path.join(root, contrasts[0], 'clustno' + str(clust) + '_graphno' + str(graphno+1)))
        plt.close(fig)







