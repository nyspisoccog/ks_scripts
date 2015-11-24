import subprocess


subprocess.call("bash", shell=True)
subprocess.call('/bin/bash -c ". /home/katie/scripts/startFreesurfer.sh"', shell=True)

print "I'm sad"
