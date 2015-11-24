__author__ = 'katie'

import os, subprocess
dir = ''

for rt, dirs, files in os.walk(dir):
    if 'anonout' in rt:
        subprocess.call('cd ' + rt, shell=True)
        subprocess.call('echo $PWD')
        #subprocess.call('rm -r *', shell=True)