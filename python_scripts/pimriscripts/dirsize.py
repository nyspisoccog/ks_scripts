__author__ = 'katie'

import locale
import os

locale.setlocale(locale.LC_ALL, "")

def get_size(state, root, names):
    paths = [os.path.realpath(os.path.join(root, n)) for n in names]
    # handles dangling symlinks
    state[0] += sum(os.stat(p).st_size for p in paths if os.path.exists(p))

def print_sizes(root):
    total = 0
    paths = []
    state = [0]
    n_ind = s_ind = 0
    for name in sorted(os.listdir(root)):
        path = os.path.join(root, name)
        if not os.path.isdir(path):
            continue

        state[0] = 0
        os.path.walk(path, get_size, state)
        total += state[0]
        s_size = locale.format('%8.0f', state[0], 3)
        n_ind = max(n_ind, len(name), 5)
        s_ind = max(s_ind, len(s_size))
        paths.append((name, s_size))

    for name, size in paths:
        print name.ljust(n_ind), size.rjust(s_ind), 'bytes'
        if str(size)[0:3] != '145' and str(size)[0:3] != '428':
            print "OH NOOOOOOOO!!!!!"

        s_total = locale.format('%8.0f', total, 3)
        print '\ntotal'.ljust(n_ind), s_total.rjust(s_ind), 'bytes'

root = '/media/truecrypt1/SocCog/SocCog/preproc_data'

for dir in os.listdir(root):
    subdir = os.path.join(root, dir)
    if os.path.isdir(subdir):
        if dir[0] == '7':
            fulldir = os.path.join(subdir, 'func')
            print_sizes(fulldir)

