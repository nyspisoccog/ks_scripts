import os

root = '/media/katie/SocCog/working_data/'

for rt, dirs, files in os.walk(root):
    for f in files:
        if 'MRDC' in f and 'dcm' not in f:
            old = os.path.join(rt, f)
            new = os.path.join(rt, f + '.dcm')
            os.rename(old, new)
