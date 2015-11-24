import os

root = '/media/katie/storage/PanicPTSD/working_data/'
with open(root + 'dirlist.csv', 'w') as dirlist:
    for rt, dirs, files in os.walk(root):
        if 'dicoms' in rt:
            dirlist.write(rt + '\n')


    
