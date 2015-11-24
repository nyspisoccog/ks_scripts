__author__ = 'katie'

import os, subprocess

root = '/media/truecrypt1/SocCog/SocCog/preproc_data'

for dir in os.listdir(root):
    subdir = os.path.join(root, dir)
    if os.path.isdir(subdir):
        if dir[0] == '7':
            fulldir = os.path.join(subdir, 'func')
            print 'du -s ' + fulldir +'/*'
            print subprocess.check_output('du -s ' + fulldir +'/*', shell=True)
