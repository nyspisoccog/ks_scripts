__author__ = 'katie'

import os

direc = '/media/truecrypt1/SocCog/SocCog/working'

for rt, dirs, files in os.walk(direc):
    for f in files:
        if f[0] == 'c' and 'noskull' in f:
            os.remove(os.path.join(rt, f))
            print f
            print rt
            print os.path.join(rt, f)
            print ' '

