__author__ = 'root'

import os
root = '/ifs/scratch/pimri/soccog/7408/func'

for d in os.listdir(root):
    if os.path.isdir(d):
        f = open(os.path.join(root, d, 'orig_series_name.txt'), 'w+')
        f.write(d)
        f.close


