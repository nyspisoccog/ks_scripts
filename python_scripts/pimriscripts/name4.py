__author__ = 'katie'
__author__ = 'root'

import os, shutil
root = '/ifs/scratch/pimri/soccog/7414/func'

L=0
M=0
S=1

ser_dict = {}

for d in os.listdir(root):
    if os.path.isdir(d):
        s_ind = d.find('s', 2)
        ser_dict[int(d[s_ind + 1:])] = d
        f = open(os.path.join(root, d, 'orig_series_name.txt'), 'w+')
        f.write(d)
        f.close

for key in sorted(ser_dict.iterkeys()):
    d = ser_dict[key]
    if '1904' in d:
        L += 1
        new_name = "run_" + str(S) + "L" + str(L)
        print d
        print new_name
        os.rename(os.path.join(root, d), os.path.join(root, new_name))
        if L == 6:
            L = 0
    if '5610' in d:
        M += 1
        new_name = "run_" + str(S) + "M" + str(M)
        print d
        print new_name
        os.rename(os.path.join(root, d), os.path.join(root, new_name))
    if M == 6:
        M = 0
        S = 2