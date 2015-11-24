__author__ = 'katie'

import os, shutil

src = '/media/truecrypt2/forMartine/old'
dst = '/media/truecrypt2/forMartine/new'

#shutil.copytree(src, dst)

for rt, dirs, files in os.walk(dst):
    for f in files:
        if 'MRDC' in f:
            oldpath = os.path.join(rt, f)
            newfname = f + '.dcm'
            newpath = os.path.join(rt, newfname)
            os.rename(oldpath, newpath)
            print oldpath
            print newpath


