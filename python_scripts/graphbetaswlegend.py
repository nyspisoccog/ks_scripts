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
        self.ticks = list

class Row():
    def __init__(self):
        self.subjects = []
        self.positions = []
        self.diffs = []
        self.patches = PatchCollection
        self.proxies = []
        self.labels = []
        self.ymax = float
        self.ymin = float
        self.lastsub = [float('Inf'), float('-Inf')]

class Rowsub():
    def __init__(self):
        self.diffs = []
        self.id = str
        self.patches = PatchCollection

class Diff():
    def __init__(self):
        self.min = float
        self.max = float
        self.s = float
        self.m = float
        self.d = float
        self.pair = tuple
        self.subid = str
        self.positions = []
        self.direction = str
        self.pos = float
        self.marker = []


root = '/media/truecrypt1/SocCog/results/noMV_noval_1stvs2nd_wbp/lrn'
contrasts = ['con3']

fname = 'con3negativetclustno1.csv'

colors = ['blue', 'red', 'cyan', 'orange']

clust_dict = {2:'l_insula', 3:'r_insula', 4: 'midbrain', 7: 'r_caudate', 11: 'r_suppmotor'}

for clust in clust_dict.keys():
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

    varpairs: [['LSIA', 'LSIB', 'LSRA', 'LSRB', 'LYRA', 'LYRB', 'LYIA', 'LYIB'],
               ['LSR', 'LSI', 'LYR', 'LYI', 'LSA', 'LYA', 'LS']]


    varpairs = [('LSIA', 'LSRA'), ('LSIB', 'LSRB'), ('LYIA', 'LYRA'), ('LYIB', 'LYRB'),
                ('LSRB','LSRA'),('LSIB', 'LSIA'),('LYRA')
                ('LSI', 'LSR'), ('LSA', 'LSB'), ('LRA', 'LRB'), ('LYI', 'LYR'), ('LYA', 'LYB'), ('LIA', 'LIB'),
                ('LY', 'LS'), ('LA', 'LB'),('LI', 'LR')]

    pairs = []


    vars = ['Rel', 'Half', 'Type']
    hier_dict = {'Type':['S', 'Y'], 'Rel':['R', 'I'], 'Half':['B', 'A']}
    orders = itr.permutations(vars)
    for i, order in enumerate(orders):
        pairs.append([])
        for j, cat in enumerate(order):
            pairs[i].append([])
            cpy = [att for att in attlist if len(att) == 4-j]
            for var in cpy:
                for letter in var:

            hier_dict[cat]


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
        g.positions = [list([[x - .36, x -.12, x + .12, x + .36] for x in g.ticks]), \
                       list([[x - .12, x + .12] for x in g.ticks]), [[x] for x in g.ticks]]
        g.ticks = [.11 + x for x in range(len(subjects))]
        g.labels = tuple([sub.id for sub in subjects])
        for j, row in enumerate(graphset):
            ymin = float('Inf')
            ymax = -float('Inf')
            r = Row()
            r.positions = g.positions[j]
            for l, pair in enumerate(row):
                proxy = plt.Rectangle((0, 0), 1, 1, color=colors[l])
                r.proxies.append(proxy)
                r.labels.append(pair[1]+"-"+pair[0])
            for k, sub in enumerate(subjects):
                rs = Rowsub()
                rs.positions = r.positions[k]
                diffs = []
                patches = []
                for l, pair in enumerate(row):
                    s = getattr(sub, pair[1])
                    m = getattr(sub, pair[0])
                    difference = s-m
                    for point in [s, m]:
                        if point > ymax: ymax = point
                        if point < ymin: ymin = point
                    diff = Diff()
                    diff.min = min(s,m); diff.s = s; diff.m = m; diff.d = difference; diff.pair = pair; diff.subid = sub.id
                    diff.max = max(s,m); diff.color = colors[l]
                    if s > m:
                        diff.marker = [rs.positions[l] + .1 , diff.max, '^']
                    else:
                        diff.marker = [rs.positions[l] + .1 , diff.min, 'v']
                    diffs.append(diff)
                    rect = mpatches.Rectangle([rs.positions[l], diff.min], 0.22, abs(diff.d), ec="none", color=colors[l])
                    #arrow = mpatches.Arrow(rs.positions[l], diff.m, 0, diff.d, width=0.2)
                    #patches.append(arrow)
                    patches.append(rect)
                    if sub.id == '7726':
                        if diff.min < r.lastsub[0]:
                            r.lastsub[0] = diff.min
                        if diff.min + abs(diff.d) > r.lastsub[1]:
                            r.lastsub[1] = diff.min + abs(diff.d)
                rs.patches = PatchCollection(patches, match_original=True)
                rs.diffs = diffs
                rs.id = sub.id
                r.subjects.append(rs)
                r.ymax = ymax
                r.ymin = ymin
            g.rows.append(r)
        graphs.append(g)

    for graphno, graph in enumerate(graphs):
        fig, (ax1, ax2, ax3) = plt.subplots(ncols=1, nrows=3, sharex=True)
        fig.set_size_inches(80,30)
        axes = [ax3, ax2, ax1]
        plt.xticks(graph.ticks, graph.labels)
        for ax in axes:
            ax.tick_params(labelsize=40)
        plt.xlim(graph.ticks[0] -.5 , g.ticks[-1] + .75)
        for i, row in enumerate(graph.rows):
            delta = abs(r.ymax -r.ymin)*.1
            for j, rowsub in enumerate(row.subjects):
                axes[i].add_collection(rowsub.patches)
                for k, diff in enumerate(rowsub.diffs):
                    if diff.marker[2] == '^':
                        diff.marker[1] += delta
                    else:
                        diff.marker[1] -= delta
                    axes[i].plot(diff.marker[0], diff.marker[1], diff.marker[2], markersize=13, color=diff.color)
            if abs(axes[i].get_ylim()[1] - row.lastsub[1]) < abs(row.lastsub[0] - axes[i].get_ylim()[0]):
                axes[i].legend(row.proxies, row.labels, loc=4, prop={'size':35})
            else:
                axes[i].legend(row.proxies, row.labels, loc=1, prop={'size':35})    #vars = {}
                    #for lab in diff.pair:
                        #id = rowsub.id
                        #for sub in subjects:
                            #if sub.id == id:
                                #vars[lab] = getattr(sub, lab)
                    #for name, num in vars.items():
                        #if num == max(val for val in vars.values()):
                            #ylabcor = 4
                        #else:
                            #ylabcor = -8
                        #axes[i].annotate(name, xy=(rowsub.positions[k], num), xycoords='data',
                                         #xytext = (-5,ylabcor), textcoords='offset points', size='x-small')
        plt.tight_layout()
        plt.savefig(os.path.join(root, contrasts[0], clust_dict[clust] + '_graphno' + str(graphno+1)))
        plt.close(fig)







