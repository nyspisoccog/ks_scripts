import os, tarfile

root = '/media/katie/storage/PanicPTSD/data-neworg/Panic/'

for rt, dirs, files in os.walk(root):
    for file1 in files:
        if 'tar.gz' in file1:
            print rt
            if not os.path.isdir(os.path.join(rt, 'dicoms')):
                os.mkdir(os.path.join(rt, 'dicoms'))
                tar = tarfile.open(os.path.join(rt, file1), 'r')
                tar.extractall(os.path.join(rt, 'dicoms'))

