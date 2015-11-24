__author__ = 'root'


import os
root = '/ifs/scratch/pimri/soccog'

for d in os.listdir(root):
    sub_path = os.path.join(root, d)
    if d[0] == '7':
        for e in os.listdir(sub_path):
            if 'anat' in e:
                anat_path = os.path.join(sub_path, e)
                for g in os.listdir(anat_path):
                    ser_path = os.path.join(anat_path, g)
                    if os.path.isdir(ser_path):
                        print ser_path
                        f = open(os.path.join(ser_path, 'orig_series_name.txt'), 'w+')
                        f.write(g)
                        f.close