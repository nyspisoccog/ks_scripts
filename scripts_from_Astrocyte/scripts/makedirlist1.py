import os

root = '/media/katie/storage/PanicPTSD/data-neworg/Panic'
dirlist = open(root + 'dirlist.csv', 'w')

for rt, dirs, files in os.walk(root):
    if 'affect' in rt or 'simon' in rt:
        if os.path.isdir(os.path.join(rt, 'dicoms')):
            dirlist.write(os.path.join(rt, 'dicoms') + '\n')

dirlist.close()
    
