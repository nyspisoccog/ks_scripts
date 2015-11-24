import os, subprocess, shutil

dest = "/media/katie/SocCog/soccogfunc-edforJochen/"
orig = "/media/katie/SocCog/avgAnat/"

#for folder in os.listdir(dest):
	#path = root + folder + "/"
	#subprocess.call("mkdir " + path + "anatomical", shell=True)

for folder in os.listdir(dest):
	if "txt" in folder: 
		continue
	if len(folder) > 20:
		continue
	destpath = dest + folder + "/anatomical/"
	sub = "s" + folder
	origpath = orig + sub + "/mri/"
	shutil.copy(origpath + "rawavg.mgz.img", destpath)
	shutil.copy(origpath + "rawavg.mgz.hdr", destpath)
	shutil.copy(origpath + "rawavg.mgz.mat", destpath)

i = 0

for folder in os.listdir(dest):
	destpath = dest + folder + "/anatomical/"
	if len(os.listdir(destpath)) == 3:
		i += 1

print i


	
	




