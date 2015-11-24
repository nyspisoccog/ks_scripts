
__author__ = 'katie'
from datetime import datetime

import os
import shutil

root = '/ifs/scratch/pimri/soccog'
prefix = os.path.join(root, 'working_data')
filestr = root + '/movetest.txt'

g = open(filestr, 'w+')


def buildtree(rt,lst):
    print lst
    path = rt
    for n in lst:
        if n != '':
            path = os.path.join(path, n)
            if not os.path.isdir(path):
                os.mkdir(path)
    return path

for rt, dirs, files in os.walk(root):
    print "walking rt", rt
    if rt[-3:] == "img" or rt[-3:] == 'dcm':
        print "true"
        subj_ind = rt.find('7')
        end_path = rt[subj_ind:]
        path_list = rt.split('/')
        path_list = path_list[5:]
        path_list.insert(0, 'working_data')
        path_list.remove('dicoms')
        path_list.remove('anonout')
        dst = buildtree(root, path_list)
        print rt, '\n', dst
        #shutil.move(rt, dst)
        g.write(rt + '\n' + dst)

g.close()
h = open(root + '/done.txt', 'w')
h.write('done')
h.write(str(datetime.now()))
h.close()
