import os, shutil, csv, tarfile, distutils.core, tarfile

root = "/media/katie/SocCog/newPreProc/"

for rt, dirname, files in os.walk(root + '7403'):
    for f in files:
        if 'img' in f or 'hdr' in f:
            os.remove(os.path.join(rt, f))
