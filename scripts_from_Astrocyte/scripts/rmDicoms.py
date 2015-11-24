import os, subprocess

path = "/home/katie/scripts/"

for f in os.listdir(path):
	if "MRDC" in f:
		subprocess.call("rm " + path + f, shell=True)
