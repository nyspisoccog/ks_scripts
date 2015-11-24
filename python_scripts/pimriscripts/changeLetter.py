__author__ = 'root'

import os

#root = '/media/soccog'

root = '/ifs/scratch/pimri/soccog'

for dir in os.listdir(root):
    anat = os.path.join(root, dir, 'anat')
    if os.path.isdir(anat):
        for d in os.listdir(anat):
            scan = os.path.join(anat, d, 'dicoms', 'anonout', 'img')
            if os.path.isdir(scan)
                for f in os.listdir(scan):
                    if f[0] == 'm':
                        old = os.path.join(scan, f)
                        new = os.path.join(scan, 'f' + f[1:])
                        print old
                        print new
                        print ' '
                        #os.rename(old, new)





