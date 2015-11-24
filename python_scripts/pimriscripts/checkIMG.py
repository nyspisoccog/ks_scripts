__author__ = 'katie'

import os

pathlist = ['/media/truecrypt2/7403']
#pathlist = ["/ifs/scratch/pimri/soccog/7403", "/ifs/scratch/pimri/soccog/7404", "/ifs/scratch/pimri/soccog/7408"]

g = open('sansIMG.txt', 'w+')

for path in pathlist:
    for rt, dirs, files in os.walk(path):
        if rt[-7:] == 'anonout':
            img = 0
            for subdir, dirs, files in os.walk(rt):
                if subdir[-3:] == 'img':
                    print files
                for f in files:
                    if 'img' in f:
                        print "ture"
                if len([f for f in files if 'img' in f]) > 0 :
                    print "img = 1"
                    img = 1
                    break
            if img == 1:
                continue
            if img == 0:
                g.write(rt + '\n')

g.close()
