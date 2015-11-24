__author__ = 'katie'

import numpy as np
import os, csv

class Sub:
    def __init__(self):
        self.subject = str
        self.regs = []
        self.cons = []
        self.LSRS = float
        self.LSRF = float
        self.LSIS = float
        self.LSIF = float
        self.LYRS = float
        self.LYRF = float
        self.LYIS = float
        self.LYIF = float
        self.three = float
        self.two = float

class Con:
    def __init__(self):
        self.id = str
        self.vals = []
        self.mean = float
        self.stdev = float
        self.z = float

class Reg:
    def __init__(self):
        self.id = str
        self.vals = []
        self.mean = float
        self.stddev = float
        self.z = float


class Clust:
    def __init__(self):
        self.id = str
        self.regs = {}
        self.cons = {}
        self.subs = []


root = '/media/truecrypt1/SocCog/results/noMV_noval_1stvs2nd_wbp/lrn/con3'
clust_list = [2, 3, 4, 7, 11]
clusts = []

for clst in clust_list:
    clust = Clust()
    clusts.append(clust)
    subs = clust.subs
    regs = clust.regs
    cons = clust.cons
    print clst, "\n"
    fname = os.path.join(root, 'con3negativetclustno' + str(clst) + '.csv')
    f = open(fname, 'r')
    for i, line in enumerate(csv.DictReader(f)):
        s = Sub()
        if i == 0:
            regnames = [k for k in line.keys() if k != 'subject']
        for k, v in line.items():
            if k == 'subject':
                setattr(s, k, v)
            else:
                setattr(s, k, float(v))
                r = Reg()
                r.id = k
                s.regs.append(r)
        subs.append(s)
    for reg in regnames:
        r = Reg()
        r.id = reg
        for sub in subs:
            r.vals.append(getattr(sub, reg))
        r.mean = np.mean(r.vals)
        r.stddev = np.std(r.vals)
        regs[reg] = r
    for sub in subs:
        for reg in sub.regs:
            id = reg.id
            mean = regs[id].mean
            stddev = regs[id].stddev
            val = getattr(sub, id)
            z = (val - mean)/stddev
            reg.z = z
        temp = Sub()
        for regname in regnames:
            setattr(temp, regname, getattr(sub, regname))
        three = ((temp.LSRS - temp.LSRF) - (temp.LSIS-temp.LSIF)) \
                -((temp.LYRS - temp.LYRF) - (temp.LYIS-temp.LYIF))
        two = (temp.LSRS-temp.LSIS) - (temp.LYRS-temp.LYIS)
        sub.three = three
        sub.two = two
        c = Con()
        c.id = 'three'
        sub.cons.append(c)
        c = Con()
        c.id = 'two'
        sub.cons.append(c)
    for conname in ['three', 'two']:
        c = Con()
        c.id = conname
        for sub in subs:
            c.vals.append(getattr(sub, conname))
        c.mean = np.mean(c.vals)
        c.stddev = np.std(c.vals)
        cons[c.id] = c
    for sub in subs:
        for con in sub.cons:
            id = con.id
            mean = cons[id].mean
            stddev = cons[id].stddev
            val = getattr(sub, id)
            z = (val - mean)/stddev
            con.z = z
    #for sub in subs:
        #print sub.subject, "\n"
        #for reg in sub.regs:
            #print "reg is ", reg.id, " and z is ", str(abs(reg.z))
        #for con in sub.cons:
            #print "con is ", con.id, " and z is ", str(abs(con.z))

    for sub in subs:
        for con in sub.cons:
            if abs(con.z) > 4:
                print sub.subject, " is an OUTLIER on con ", con.id, " for cluster ", str(clst), "\n"
