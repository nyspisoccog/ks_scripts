import os, subprocess

root = "/media/katie/PanicPTSD/data/anat_data/Panic/"

print "I'm happy"

subprocess.call('/bin/bash -c ". /home/katie/scripts/startFreesurfer.sh"', shell=True
#subprocess.call('/bin/bash ". /home/katie/scripts/startFreesurfer.sh"', shell=True)
#subprocess.call('/bin/bash "source /home/katie/scripts/startFreesurfer.sh"', shell=True)

print "I'm sad"

#subprocess.call('. /home/katie/scripts/startFreesurfer1.sh', shell=True)

dead_to_me = ["proc_data", "1823", "2578", "2579"]

for exam in os.listdir(root):
	if exam in dead_to_me:
		print "dead"
		continue
	series_list = os.listdir(root + exam)
	sub = "s" + exam[-4:]
	dicom_list = []
	for series in series_list:
		for f in os.listdir(root + exam + "/" + series):
			if "MRDC" in f:
				dicom_list.append(f)
			break
	path0 = root + exam + "/" + series_list[0] + "/" + dicom_list[0]
	if len(series_list) > 1:
		path1 = root + exam + "/" + series_list[1] + "/" + dicom_list[1]
		print "recon-all -i " + path0 + " -i " + path1 + " -subjid " + sub
		subprocess.call("recon-all -i " + path0 + " -i " + path1 + " -subjid " + sub, shell=True)
	else:
		print "recon-all -i " + path0 + " -subjid " + sub
		subprocess.call("recon-all -i " + path0 + " -subjid " + sub, shell=True)
	print "recon-all -all -subjid " + sub
	subprocess.call("recon-all -all -subjid " + sub, shell = True)




