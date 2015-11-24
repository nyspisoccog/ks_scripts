__author__ = 'root'

import os

pathlist = ['/ifs/scratch/pimri/soccog']

for path in pathlist:
    for rt, dirs, files in os.walk(path):
        if rt[-7:] == 'anonout':
            for f in files:
                if f[-3:] == 'dcm':
                    newdir = os.path.join(rt, 'raw')
                    if not os.path.isdir(newdir):
                        os.mkdir(newdir)
                    print " "
                    oldname = os.path.join(rt, f)
                    newname = os.path.join(newdir, f)
                    print oldname
                    print newname
                    os.rename(oldname, newname)

    for rt, dirs, files in os.walk(path):
        if rt[-7] == 'anonout':
            alist = []
            blist = []
            alist.append([f for f in files if f[-3:] == 'dcm'])
            subdir = os.path.join(rt, 'dcm')
            if os.path.isdir(subdir):
                blist.append([f for f in os.listdir(subdir) if f[-3:] == 'dcm'])
            if sorted(alist) == sorted(blist):
                [os.remove(os.path.join(rt, f)) for f in os.listdir(rt)]





