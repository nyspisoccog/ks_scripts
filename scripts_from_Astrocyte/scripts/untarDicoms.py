import os, subprocess

root = "/media/katie/SocCog/working_data"

for child in os.walk(root):
	if len(child[2]) > 0:
		#print child[2][0] 
		if "tar.gz" in child[2][0]:
			print "tar xvzf " + child[0] + "/" + child[2][0] + " -C " + child[0]
			subprocess.call("tar xvzf " + child[0] + "/" + child[2][0] + " -C " + child[0], shell=True)
