__author__ = 'katie'

import os, errno, shutil


def mkdir_p(path):
    try:
        os.makedirs(path)
    except OSError as exc:  # Python >2.5
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else: raise


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


root = '/media/katie/storage/7508/func'

for d in os.listdir(root):
    for letter in ['L', 'M']:
        if letter in s_name:
            old_path = os.path.join(root, d)
            dir_name = 'run_' + d[d.find(letter)-1:d.find(letter)+2]
            new_path = os.path.join(root, dir_name)
            print old_path
            print new_path
            os.move(old_path, new_path)

