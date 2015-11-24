__author__ = 'root'

import os, sys

root = '/media/truecrypt2/7404/'

for rt, dirs, files in os.walk(root):
    if rt[-3:] == 'dcm':
        for f in files:
            parent_dir = rt[:-3]
            higher_file = (os.path.join(parent_dir, f))
            if os.path.isfile(higher_file):
                print higher_file
                os.remove(higher_file)
