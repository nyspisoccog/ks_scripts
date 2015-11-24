__author__ = 'katie'

root = '/media/truecrypt2/sample/7436test'
import os, uf

for rt, dirs, files in os.walk(root):
    for f in files:
        if (f[-3:] == 'img' or f[-3:] == 'hdr') and ('L' in f or 'M' in f):
            old = os.path.join(rt, f)
            newname = 'f' + f[-10:]
            new = os.path.join(rt, newname)
            os.rename(old, new)
            print old
            print new
            print ' '
        if (f[-3:] == 'img' or f[-3:] == 'hdr') and ('anat' in f and f[0] == 's'):
            old = os.path.join(rt, f)
            newname = 's' + f[-10:]
            new = os.path.join(rt, newname)
            os.rename(old, new)
            print old
            print new
            print ' '

uf.done('/media/truecrypt2/sample/7436new/done.txt')

