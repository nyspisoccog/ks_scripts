__author__ = 'root'

import os, shutil
root = '/ifs/scratch/pimri/soccog/7412/func'

L=0
M=0
S=1

for d in os.listdir(root):
    if os.path.isdir(d):
        f = open(os.path.join(root, d, 'orig_series_name.txt'), 'w+')
        f.write(d)
        f.close
        if '1904' in d:
            L += 1
            new_name = "run_" + str(S) + "L" + str(L)
            os.rename(os.path.join(root, d), os.path.join(root, new_name))
        if L == 6:
            L = 0
        if '5610' in d:
            M += 1
            new_name = "run_" + str(S) + "M" + str(M)
            os.rename(os.path.join(root, d), os.path.join(root, new_name))
        if M == 6:
            M = 0
            S = 2
