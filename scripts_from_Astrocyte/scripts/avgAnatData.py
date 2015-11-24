import os, subprocess

root = "/media/katie/My Passport1/SocCogAnatDataEdByKatie/"

#subprocess.call("/home/astrocyte/Desktop/startFreesurfer.sh", shell=False)


rec = open(root + 'convertrec.txt', 'w')		
		

subs = {}

for child in os.walk(root):
	for item in child[2]:
		if "MRDC" in item:
			path = child[0]
			sev_ind = path.find("7")
			subjid = path[sev_ind:sev_ind + 4]
			esc_path = path.replace(" ", "\ ")
			print esc_path
			if subjid in subs.keys():
				subs[subjid].append(esc_path + "/" + item)
				print subjid
			else:
				subs[subjid] = [esc_path + "/" + item]
				print "first time " + subjid
		break	

for sub, paths in subs.iteritems():
	print sub, paths

for sub, paths in subs.iteritems():
	if len(paths) > 1:
		subprocess.call("recon-all -i " + paths[0] + " -i " + paths[1] + "-subjid s" + sub, shell=True)		



