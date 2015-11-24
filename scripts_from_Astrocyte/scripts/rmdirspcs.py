import os, subprocess

root = "/media/katie/SocCog/"

space_dirs = []

for child in os.walk(root):
	if child[0].find(' ') != -1:
		space_dirs.append(child[0])

for space_dir in space_dirs:
	new_dir = space_dir.replace(' ', '_')
	subprocess.call('mv "' + space_dir + '" "' + new_dir + '"', shell=True)
	
