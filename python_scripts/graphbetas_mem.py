__author__ = 'katherine'


import matplotlib
import numpy as np
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
    def __init__(self, positions):
        self.subjects = []
        self.positions = positions
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


root = '/Volumes/Lacie/LaPrivate/soccog/results/feb2017memfirstlev/mem/'

contrasts = ['robust0003']

fname = 'betadata_con3.csv'


f = open(os.path.join(root, contrasts[0], fname))

subjects = []

for row in csv.DictReader(f):
    s = Subject()
    s.id = row['subject']
    s.MSRT = float(row['MSRT'])
    s.MSRU = float(row['MSRU'])
    s.MSIT = float(row['MSIT'])
    s.MSIU = float(row['MSIU'])
    s.MYRT = float(row['MYRT'])
    s.MYRU = float(row['MYRU'])
    s.MYIT = float(row['MYIT'])
    s.MYIU = float(row['MYIU'])
    s.MNRT = float(row['MNRT'])
    s.MNRU = float(row['MNRU'])
    s.MNIT = float(row['MNIT'])
    s.MNIU = float(row['MNIU'])
    s.MCRT = (float(row['MYRT']) + float(row['MNRT'])/2)
    s.MCRU = (float(row['MYRU']) + float(row['MNRU'])/2)
    s.MCIT = (float(row['MYIT']) + float(row['MNIT'])/2)
    s.MCIU = (float(row['MYIU']) + float(row['MNIU'])/2)
    s.MSR = s.MSRT - s.MSRU
    s.MSI = s.MSIT - s.MSRU
    s.MST = s.MSRT - s.MSIT
    s.MSU = s.MSRU - s.MSRT
    s.MYR = s.MYRT - s.MYRU
    s.MYI = s.MYIT - s.MYRU
    s.MYT = s.MYRT - s.MYIT
    s.MYU = s.MYRU - s.MYRT
    s.MNR = s.MNRT - s.MNRU
    s.MNI = s.MNIT - s.MNRU
    s.MNT = s.MNRT - s.MNIT
    s.MNU = s.MNRU - s.MNRT
    s.MCR = s.MCRT - s.MCRU
    s.MCI = s.MCIT - s.MCRU
    s.MCT = s.MCRT - s.MCIT
    s.MCU = s.MCRU - s.MCRT
    s.MS = s.MSR - s.MSI
    s.MY = s.MYR - s.MYI
    s.MN = s.MNR - s.MNI
    s.MC = s.MCR - s.MCI
    s.MR = s.MSR - (s.MYR + s.MNR)/2
    s.MI = s.MSI - (s.MYI + s.MYI)/2
    s.MT = s.MST - (s.MYT + s.MNT)/2
    s.MU = s.MSU - (s.MYU + s.MNU)/2
    subjects.append(s)

avg = Subject()
avg.id = 'avg'
attlist = ['MSRT', 'MSRU', 'MSIT', 'MSIU', 'MYRT', 'MYRU', 'MYIT', 'MYIU', 'MNRT', 'MNRU', 'MNIT', 'MNIU',\
           'MCRT', 'MCRU', 'MCIT', 'MCIU', 'MSR', 'MSI', 'MST', 'MSU', 'MYR', 'MYI', 'MYT', 'MYU', 'MNR', \
           'MNI', 'MNT', 'MNU', 'MCR', 'MCI', 'MCT', 'MCU', 'MS', 'MY', 'MN', 'MC', 'MR', 'MI', 'MU']

for att in attlist:
    setattr(avg, att, float(np.mean([getattr(sub, att) for sub in subjects])))

subjects.insert(0, avg)


graphset = [[('MSIT', 'MSRT'),('MCIT', 'MCRT'),('MSIU', 'MSRU'), ('MCIU', 'MCRU')],
            [('MSI', 'MSR'), ('MCI', 'MCR')],
            [('MS', 'MC')]]
graphs = []


g = Graph()
g.ticks = range(len(subjects))
g.positions = [list([[x - .3, x -.1, x + .1, x + .3] for x in g.ticks]), \
               list([[x - .1, x + .1] for x in g.ticks]), [[x] for x in g.ticks]]
g.labels = tuple([sub.id for sub in subjects])
ymin = float('Inf')
ymax = -float('Inf')



for j, row in enumerate(graphset):
    r = Row(g.positions[j])
    cols = np.linspace(0, 1, len(r.positions[0])) #return evenly spaced numbers over interval
    for l, pair in enumerate(row):
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
                diff = Diff()
                diff.min = min(s,m); diff.s = s; diff.m = m; diff.d = difference; diff.pair = pair; diff.subid = sub.id
                if s > m: diff.direction = 'up'
                else: diff.direction = 'down'
                diffs.append(diff)
                rect = mpatches.Rectangle([rs.positions[l], diff.min], 0.25, abs(diff.d), ec="none")
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
    print len(graph.rows)
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
    plt.savefig(os.path.join(root, contrasts[0], '_graphno' + str(graphno+1)))
    plt.close(fig)







