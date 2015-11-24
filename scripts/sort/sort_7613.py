uthor__ = 'katie'


import os
import shutil
import sys

dirlist = ['/ifs/scratch/pimri/soccog/7613']

for d in dirlist:
    filestr = d + '/movetest.txt'
    g = open(filestr, 'w+')
    for rt, dirs, files in os.walk(d):
        if rt[-7:] == "anonout":
            print rt
            img_path = os.path.join(rt, 'img')
            dcm_path = os.path.join(rt, 'dcm')
            if not os.path.isdir(img_path): os.mkdir(img_path)
            if not os.path.isdir(dcm_path): os.mkdir(dcm_path)
            for f in files:
                if "img" in f or "hdr" in f:
                    src = os.path.join(rt, f)
                    dst = img_path
                    try:
                        shutil.move(src, dst)
                        g.write(src + '  ' + dst + '\n')
                    except (OSError, IOError, shutil.Error), e:
                        print >> sys.stderr, 'Error moving %s to %s: %s' % (src, dst, e)
                        pass
                if "dcm" in f:
                    src = os.path.join(rt, f)
                    dst = dcm_path
                    try:
                        shutil.move(src, dst)
                        g.write(src + '  ' + dst + '\n')
                    except (OSError, IOError, shutil.Error), e:
                        print >> sys.stderr, 'Error moving %s to %s: %s' % (src, dst, e)
                        pass

