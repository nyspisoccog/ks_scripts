__author__ = 'root'


import os
import shutil


def splitall(path):
    allparts = []
    while 1:
        parts = os.path.split(path)
        if parts[0] == path:   # sentinel for absolute paths
            allparts.insert(0, parts[0])
            break
        elif parts[1] == path:  # sentinel for relative paths
            allparts.insert(0, parts[1])
            break
        else:
            path = parts[0]
            allparts.insert(0, parts[1])
    return allparts

root = "/media/truecrypt2/7000"

for rt, dirs, files in os.walk(root):
    run = ''
    if rt[-3:] == "img":
        split_path = splitall(rt)
        for d in split_path:
            print d
            if d[0] == '7':
                print "true"
                subj = 'm' + d
            if d[0:3] == 'run':
                print "run"
                run = d[4:]
            if d[0:4] == 'anat':
                run = d[:5]
        for f in files:
            if f[-3:] in ['img', 'hdr'] and len(run) > 0 and 'sanon' in f:
                start = f.rfind('-00', 0, -9) + 1
                end = start + 6
                volno = f[start:end]
                suffix = f[-4:]
                new_name = '_'.join([subj, run, volno])
                new_name = new_name + suffix
                src = os.path.join(rt, f)
                dst = os.path.join(rt, new_name)
                print src
                print dst
                #shutil.move(src, dst)