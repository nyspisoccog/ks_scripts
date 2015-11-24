import os, subprocess

root = "/media/katie/PanicPTSD/data/anat_data/PTSD/"

def bash_command(cmd):
    subprocess.Popen(['/bin/bash', '-c', cmd])

print "I'm happy"

#subprocess.call('bash', shell=True)


subprocess.call('/bin/bash -c "~/scripts/startFreesurfer.sh 2>&1"', shell=True)

#subprocess.call('/bin/bash -c "source ~/scripts/startFreesurfer.sh"', shell=True)

#subprocess.call(['/bin/bash', '-c', 'source ~/scripts/startFreesurfer.sh'], shell=True)

#bash_command('. ~/scripts/startFreesurfer.sh')

print "I'm sad"

subjects = ["5707", "5918", "5981", "6015", "6142", "6462"]

for exam in os.listdir(root):
    if exam not in subjects:
	    print exam, " dead"
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
	print "recon-all -all -subjid " + sub
	subprocess.call("recon-all -all -subjid " + sub, shell = True)
    else:
	print "recon-all -i " + path0 + " -subjid " + sub
	subprocess.call("recon-all -i " + path0 + " -subjid " + sub, shell=True)
	print "recon-all -all -subjid " + sub
	subprocess.call("recon-all -all -subjid " + sub, shell = True)
