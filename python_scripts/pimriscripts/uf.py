__author__ = 'root'

import os
from datetime import datetime
import shutil

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

def done(fullpath, txt):
    h = open(fullpath, 'w')
    h.write(txt)
    h.write('\n')
    h.write(str(datetime.now()))
    h.close


def buildtree(rt,lst):
    path = rt
    for n in lst:
        if n != '':
            path = os.path.join(path, n)
            if not os.path.isdir(path):
                os.mkdir(path)
    return path

def modification_date(filename):
    t = os.path.getmtime(filename)
    return datetime.datetime.fromtimestamp(t)

def copytree(src, dst, symlinks=False, ignore=None):
    for item in os.listdir(src):
        s = os.path.join(src, item)
        d = os.path.join(dst, item)
        if os.path.isdir(s):
            shutil.copytree(s, d, symlinks, ignore)
        else:
            shutil.copy2(s, d)


def split_lines(f, delim):
    ###Arg1: text file, Arg2: delimiter
    ###Return: text as list of lists. Outer list: list of lines. Inner lists: lists of line contents.
    lines = f.readlines()
    lineslist = []
    for line in lines:
        if line[-1] == '\n': line = line[:-1]
        lineslist.append(line.split(delim))
    return lineslist