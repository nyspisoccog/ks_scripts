__author__ = 'katie'

import os
root = "/ifs/scratch/pimri/soccog/working_data/"

g = open('sansAnonoutList.txt', 'w+')

for rt, dirs, files in os.walk(root):
    print "entering loop"
    if rt[-6:] == 'dicoms':
        if not os.path.isdir(os.path.join(rt, 'anonout')):
            g.write(rt)

g.close()
