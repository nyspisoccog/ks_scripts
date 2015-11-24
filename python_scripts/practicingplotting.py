__author__ = 'katie'



import numpy as np
import matplotlib.pyplot as plt
import matplotlib.lines as lines
from matplotlib.collections import PatchCollection
import matplotlib.patches as mpatches

#data = [[5., 25., 50., 20.],
  #[4., 23., 51., 17.],
  #[6., 22., 52., 19.]]

#X = np.arange(4)
#plt.bar(X + 0.00, data[0], color = 'b', width = 0.25)
#plt.bar(X + 0.25, data[1], color = 'g', width = 0.25)
#plt.bar(X + 0.50, data[2], color = 'r', width = 0.25)

#plt.show()

import os, csv
root = '/media/truecrypt1/SocCog/results/noMV_noval_1stvs2nd_wbp_cov/lrn/'
data_dict = {}
data_file = os.path.join(root, 'regandcovclust1.csv')

with open(data_file, 'r') as data:
    for line in csv.DictReader(data):
        data_dict[line['regressor']] = (float(line['cov_beta']), float(line['avg_val']))

regs1 = ('LSRF','LSRS', 'LSIF', 'LSIS', 'LYNRF', 'LYNRS', 'LYNIF', 'LYNIS' )
regs2 = ('LSR', 'LSI', 'LYNR', 'LYNI')
regs3 = ('LS', 'LYN')

labs1 = []
for reg in regs1:
    if reg[-1] == 'S':
        newreg = reg[0:-1] + 'B'
    else:
        newreg = reg[0:-1] + 'A'
    labs1.append(newreg)
labs1 = tuple(labs1)



fig, (ax1, ax2, ax3) = plt.subplots(ncols=1, nrows=3)

betastr = u"\u03B2"

# add some text for labels, title and axes ticks
X3 = np.arange(8)
xshift = [.3, -.1, .1, -.3, .1, -.1, +.1, -.3]
X3 = [x + xshift[x] for x in X3]


#fst = [x + .1 for x in X[0:4]]
#scd = [x - .3 for x in X[4:8]]
#X = fst + scd


#0 add .1 add .05  equals + .30
#1 add .1 subtract .05 equals + .1
#2 subtract .1 add .05 equals - .1
#3 subtract .1 subtract .05 equals -.15
#4 add .1  add .05 equals .15
#5 add .1 subtract .05 equals .05
#6 subtract .1 add .05 equals - .05
#7 substract .1 subtract .05 equals -.15

print(X3)
ax3.set_ylabel('cov ' + betastr)
#fig.set_title(betastr + ' for reg 1st level beta ~ cov score')
ax3.set_xticks(X3)
ax3data = [data_dict[reg][0] for reg in regs1]
ax3dots = [data_dict[reg][1] for reg in regs1]
colors1 = ['purple', 'peachpuff', 'darkred', 'yellow', 'darkblue', 'lightskyblue',
          'darkolivegreen', 'lightgreen']
patches = []
for i, dot in enumerate(ax3dots):
    circ = mpatches.Ellipse(xy = (X3[i] + .125, ax3dots[i]), width = .05, height = .05, color = 'black')
    patches.append(circ)
patches = PatchCollection(patches, match_original=True, zorder=10)
patches.set_zorder(20)
ax3.set_xticks([x + .125 for x in X3])
for i in range(8):
    ax3.bar(X3[i], ax3data[i], color=colors1[i], width=0.25, alpha = .8, zorder=2)
ax3.set_xticklabels(labs1)
ax3.set_ylim(min(ax3data) - .25, max(ax3data) + .25)
line_xs = ax3.get_xlim()
line_ys = [0, 0]
ax3.add_line(lines.Line2D(line_xs, line_ys, linewidth=1, alpha=.5, color='black'))
ax3.add_collection(patches)
ax3.set_xlim(X3[0] - .5, X3[-1] + .7)

X2= []
for i, x in enumerate(X3[::2]):
    X2.append(np.mean([X3[2*i], X3[2*i + 1]]))
X2 = np.arange(4)

xshift = [.2, -.2, .2, -.2]
X2 = [x + xshift[x] for x in X2]
print X2
ax2.set_ylabel('cov ' + betastr)
ax2.set_xticks(X2)
ax2data = [data_dict[reg][0] for reg in regs2]
ax2dots = [data_dict[reg][1] for reg in regs2]
colors2 = ['magenta', 'orange', 'steelblue', 'green']
patches = []
for i, dot in enumerate(ax2dots):
    circ = mpatches.Ellipse(xy = (X2[i] + .075, ax2dots[i]), width = .05, height = .05, color = 'black')
    patches.append(circ)
patches = PatchCollection(patches, match_original=True, zorder=10)
patches.set_zorder(20)
ax2.set_xticks([x + .075 for x in X2])
for i in range(4):
    ax2.bar(X2[i], ax2data[i], color=colors2[i], width=0.125, alpha = .8, zorder=2)
ax2.add_line(lines.Line2D(line_xs, line_ys, linewidth=1, alpha=.5, color='black'))
ax2.add_collection(patches)
ax2.set_xticklabels(regs2)
ax2.set_xlim(X2[0] - .125, X2[-1] + .4)

X1 = []
for i, x in enumerate(X2[::2]):
    X1.append(np.mean([X2[2*i], X2[2*i + 1]]))
ax1.set_ylabel('cov ' + betastr)
ax1.set_xticks(X1)
ax1data = [data_dict[reg][0] for reg in regs3]
ax1dots = [data_dict[reg][1] for reg in regs3]
colors1 = ['red', 'cyan']
patches = []
for i, dot in enumerate(ax1dots):
    circ = mpatches.Ellipse(xy = (X1[i] + .125, ax2dots[i]), width = .05, height = .05, color = 'black')
    patches.append(circ)
patches = PatchCollection(patches, match_original=True, zorder=10)
patches.set_zorder(20)
ax1.set_xticks([x + .125 for x in X1])
for i in range(2):
    ax1.bar(X1[i], ax1data[i], color=colors1[i], width=0.25, alpha = .8, zorder=2)
ax1.add_line(lines.Line2D(line_xs, line_ys, linewidth=1, alpha=.5, color='black'))
ax1.add_collection(patches)
ax1.set_xticklabels(regs3)
mini = min(min(ax1data), min(ax1dots))
maxi = max(max(ax1data), max(ax1dots))
delta = abs(mini-maxi)*.1
print delta

ax1.set_ylim(mini - delta, maxi+ delta)
plt.show()

#my color schemes are going to be
#SRB Purple
#SRA Pink
#SIB Dark Red
#SIA Yellow
#YNRB Dark Blue
#YNRA Light Blue
#YNIB Dark Green
#YNIA Light Green
#SR Magenta
#SI Orange
#YNR Medium Blue
#YNI Medium Green
#S Red
#YN Blue Green



