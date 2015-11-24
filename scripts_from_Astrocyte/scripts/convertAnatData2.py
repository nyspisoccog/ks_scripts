import os, subprocess

root = "/media/My Passport/SocCogAnatDataEdByKatie/"

#subprocess.call("/home/astrocyte/Desktop/startFreesurfer.sh", shell=False)


rec = open(root + 'convertrec.txt', 'w')		
		

for child in os.walk(root):
	for item in child[2]:
		if "MRDC" in item:
			dicom = item
			path = child[0]
			slash_ind = path.rfind("/")
			name = path[slash_ind + 1:]
			name = name.replace(" ", "")
			escape_path = path.replace(" ", "\ ")
			orig = escape_path + "/" + dicom
			dest = escape_path + "/" + name + ".img"
			subprocess.call("mri_convert " + orig + " " + dest, shell=True)
			rec.write(path + "/" + name + "\n")
			break

