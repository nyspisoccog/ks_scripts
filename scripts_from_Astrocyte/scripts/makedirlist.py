import os

root = '/media/katie/storage/PanicPTSD/data/control_raw_data/'
dirlist = open(root + 'dirlist.csv', 'w')

for rt, dirs, files in os.walk(root):
    if 'rapid' in rt or 'SPGR' in rt:
        if os.path.isdir(os.path.join(rt, 'dicoms')):
            dirlist.write(os.path.join(rt, 'dicoms') + '\n')

dirlist.close()
    
