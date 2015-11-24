import os, subprocess, shutil

root = "/media/katie/SocCog/working_data/"

for root, dirs, files in os.walk(root):
    for f in files:
        if "tar.gz" in f:
            src = os.path.join(root, f)
            dst = os.path.join(root, "dicoms")
            os.mkdir(dst)
            shutil.move(src, dst)
            newfile = os.path.join(dst, f)
            subprocess.call("tar xvzf " + newfile, shell=True)
            
                        

