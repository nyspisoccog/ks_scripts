__author__ = 'katie'

import numpy as np
import matplotlib.patches as mpatches
from matplotlib.collections import PatchCollection
import matplotlib.pyplot as plt
import itertools as itr
import matplotlib.lines as lines
import csv, os
import copy
import Image

class Subject():
    def __init__(self):
        self.id  = str

class Graph():
    def __init__(self):
        self.rows = []
        self.ticks = list
        self.order = []
        self.filename = str
        self.set = []
        self.vert_line_xs = []

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
contrasts = ['con1']

fname = 'con1negativetclustno1.csv'

colors = ['blue', '#97FF00', 'cyan']

clust_dict = {1:'l_BA21', 6:'l_wm_frontalinfoper', 9: 'r_BA9', 12: 'l_suppmotor', 15: 'l_BA3_postcentral', 16: 'supp_motor'}

for clust in clust_dict.keys():
    fname = 'con1tnegativeclustno'+ str(clust) + '.csv'
    f = open(os.path.join(root, contrasts[0], fname))

    subjects = []

    for row in csv.DictReader(f):
        s = Subject()
        s.id = row['subject']
        s.LSRB = float(row['LSRS'])
        s.LSIB = float(row['LSIS'])
        s.LYRB = float(row['LYRS'])
        s.LYIB = float(row['LYIS'])
        s.LSB = s.LSRB - s.LSIB
        s.LYB = s.LYRB - s.LYIB
        s.LIB = s.LSIB - s.LYIB
        s.LRB = s.LSRB - s.LYRB
        subjects.append(s)

    avg = Subject()
    avg.id = 'avg'
    attlist = ['LSRB', 'LYRB', 'LSIB', 'LYIB', 'LSB', 'LYB', 'LRB', 'LIB']

    for att in attlist:
        setattr(avg, att, float(np.mean([getattr(sub, att) for sub in subjects])))

    subjects.insert(0, avg)

    pairs = {'Rel_Type': [[('LSIB', 'LSRB'),('LYIB', 'LYRB')],
                                [('LYB', 'LSB')]],
             'Type_Rel': [[('LYRB', 'LSRB'), ('LYIB', 'LSIB')],
                               [('LIB', 'LRB')]]}



    print pairs
    graphs = []
    for filename, graphset in pairs.items():
        g = Graph()
        g.filename = filename
        g.order = filename.split('_')
        g.set = graphset
        g.ticks = range(len(subjects))
        g.positions = [list([[x - .12, x + .12] for x in g.ticks]), [[x] for x in g.ticks]]
        g.ticks = [.11 + x for x in range(len(subjects))]
        g.labels = tuple([sub.id for sub in subjects])
        for j, row in enumerate(graphset):
            ymin = float('Inf')
            ymax = -float('Inf')
            r = Row()
            r.positions = g.positions[j]

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
                    diff.max = max(s,m); diff.color = colors[3*j - j**2 + l]
                    if s > m:
                        diff.marker = [rs.positions[l] + .1 , diff.max, '^']
                    else:
                        diff.marker = [rs.positions[l] + .1 , diff.min, 'v']
                    diffs.append(diff)
                    rect = mpatches.Rectangle([rs.positions[l], diff.min], 0.22, abs(diff.d), ec="none", color=colors[3*j - j**2 + l])
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
            for m, pair in enumerate(row):
                proxy = plt.Rectangle((0, 0), 1, 1, color=colors[3*j - j**2 + m])#look here for the problem with the rectangles
                #
                r.proxies.append(proxy)
                r.labels.append(pair[1]+"-"+pair[0])
            g.rows.append(r)
        graphs.append(g)

    for graphno, graph in enumerate(graphs):
        fig, (ax1, ax2) = plt.subplots(ncols=1, nrows=2, sharex=True)
        fig.set_size_inches(80,30)
        axes = [ax2, ax1]
        plt.xticks(graph.ticks, graph.labels)
        for ax in axes:
            ax.tick_params(labelsize=40)
        plt.xlim(graph.ticks[0] -.5 , g.ticks[-1] + .75)
        vert_line_xs = []
        for i, row in enumerate(graph.rows):
            delta = abs(r.ymax -r.ymin)*.1
            for j, rowsub in enumerate(row.subjects):
                #add rectangles
                axes[i].add_collection(rowsub.patches)
                #add carat markers
                for k, diff in enumerate(rowsub.diffs):
                    if diff.marker[2] == '^':
                        diff.marker[1] += delta
                    else:
                        diff.marker[1] -= delta
                    axes[i].plot(diff.marker[0], diff.marker[1], diff.marker[2], markersize=13, color=diff.color)
            #make regular legend
            if abs(axes[i].get_ylim()[1] - row.lastsub[1]) < abs(row.lastsub[0] - axes[i].get_ylim()[0]):
                axes[i].legend(row.proxies, row.labels, loc=4, prop={'size':35})
            else:
                axes[i].legend(row.proxies, row.labels, loc=1, prop={'size':35})

        #make legend tree

        left, right = ax2.get_xlim()
        bot, top = ax2.get_ylim()
        bbox = ax2.get_window_extent().transformed(fig.dpi_scale_trans.inverted())
        w, h = bbox.width, bbox.height

        if abs(ax2.get_ylim()[1] - graph.rows[0].lastsub[1]) < abs(graph.rows[0].lastsub[0] - ax2.get_ylim()[0]):
            leg_pos = bot
            mult = 1
        else:
            leg_pos = top
            mult = -1
        posits = [[left + .015*w, leg_pos + mult*.30*h], [left + .040*w, leg_pos + mult*0.20*h],
                  [left + .040*w, leg_pos + mult*.40*h]]
        leg = []
        bw = .50
        bh = 1.25
        #make the rectangles on the legend tree
        for p, position in enumerate(posits):
            rect = mpatches.Rectangle(position, bw, bh, ec="none", color=colors[len(colors) - p - 1])
            leg.append(rect)
        leg_patches = PatchCollection(leg, match_original=True)
        ax2.add_collection(leg_patches)
        #draw the lines on the legend tree
        for ln in range(2):
            line = [(posits[ln/2][0] + bw, posits[ln/2][1] + .5*bh), (posits[ln + 1][0], posits[ln + 1][1] + .5*bh)]
            (line_xs, line_ys) = zip(*line)
            ax2.add_line(lines.Line2D(line_xs, line_ys, linewidth=1))
        count = 0
        #put labels on legend tree
        for rw_num, rw in enumerate(graph.set[::-1]):
            for pr_num, pr in enumerate(rw[::-1]):
                annot = pr[1] + '-' + pr[0]
                posit = posits[count]
                count += 1
                if count < 2:
                    x = posit[0] - .5*bw
                    y = posit[1] - bh
                    text = (0,-12)
                else:
                    x = posit[0] + bw
                    y = posit[1]
                    text = (2, 0)
                ax2.annotate(annot, xy=(x, y), xytext = text, textcoords='offset points',
                             fontsize=34)
        #graph vertical lines
        for rwsb in graph.positions[0]:
            vert_line_xs.append(rwsb[0])
        vert_line_xs = [x - .02 for x in vert_line_xs]
        for c, x in enumerate(vert_line_xs):
            if c % 4 == 0:
                for ax in axes:
                    #line = [(x, ax.get_ylim()[0]), (x, ax.get_ylim()[1])]
                    line_xs = [x, x]
                    line_ys = ax.get_ylim()
                    #(line_xs, line_ys) = zip(*line)
                    ax.add_line(lines.Line2D(line_xs, line_ys, linewidth=1, alpha=.3, color='black'))
        plt.tight_layout()
        plt.savefig(os.path.join(root, contrasts[0], clust_dict[clust] + '_' + graph.filename + '_graphno' +  str(graphno+1)))
        plt.close(fig)







