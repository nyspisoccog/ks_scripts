author__ = 'root'

import os
from datetime import datetime

def splitall(path):
    allparts = []
    while 1:
        parts = os.path.split(path)
        if parts[0] == path:   # sentinel for absolute paths
            allparts.insert(0, parts[0])
            break
        elif parts[1] == path:  # sentinel for relative paths
            allparts.insert(0, parts[1])
            break
        else:
            path = parts[0]
            allparts.insert(0, parts[1])
    return allparts

def done(fullpath):
    h = open(fullpath, 'w')
    h.write('done')
    h.write(str(datetime.now()))
    h.close
