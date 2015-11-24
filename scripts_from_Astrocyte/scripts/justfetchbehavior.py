import os, shutil

root = '/media/katie/storage/PanicPTSD/data-neworg/'
dest = '/media/katie/storage/PanicPTSD/just-behavioral/'

def listPath(root):
    for d in os.listdir(root):
        yield os.path.join(root, d), d

for p1, d1 in listPath(root):
    for p2, d2 in listPath(p1):
        src = os.path.join(p2, 'behavioral')
        dst = os.path.join(dest, d2)
        if os.path.isdir(dst):
            shutil.rmtree(dst)
        if os.path.isdir(src):
            shutil.copytree(src, dst)
        
   
