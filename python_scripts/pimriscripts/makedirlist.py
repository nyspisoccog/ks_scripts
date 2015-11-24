__author__ = 'katie'


import os,datetime

root= '/ifs/scratch/pimri/soccog'

filestr = 'dirlist.txt'
donestr = 'done.txt'

f = open(filestr, 'w+')

for rt, dirs, files in os.walk(root):
    if rt[-7:] == 'anonout':
        f.write(os.path.join(root,rt) + '\n')

f.close()

g = open(donestr, 'w+')
g.write("makedirlist.py finished at " + str(datetime.datetime.now()))


