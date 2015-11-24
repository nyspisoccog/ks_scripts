import os, subprocess

root = "/media/katie/PanicPTSD/data/anat_data/Panic/"


subprocess.call("/home/katie/scripts/startFreesurfer.sh", shell=True)

for exam in os.listdir(root):
	if exam == "proc_data":
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




