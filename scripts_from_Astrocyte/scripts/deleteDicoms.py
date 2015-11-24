import shutil, os

root = "/home/katie/scripts"

for d in os.listdir(root):
    if 'MRDC' in d:
        path = os.path.join(root, d)
        print path
        os.remove(path)

        
