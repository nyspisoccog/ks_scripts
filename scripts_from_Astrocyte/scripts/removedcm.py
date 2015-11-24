import os

root = '/media/katie/SocCog/working_data/'

for rt, dirs, files in os.walk(root):
    for f in files:
        if 'MRDC' in f and 'dcm' in f and 'gz' in f:
            old = os.path.join(rt, f)
            new = os.path.join(rt, f[:-4])
            print old
            print new
            os.rename(old, new)
