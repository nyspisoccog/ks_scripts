import os, subprocess

root = '/media/katie/SocCog/soccogfunc-edforJochen/'

for subj in os.listdir(root):
    path = root + subj + '/functional/orig/'
    subprocess.call("du -s " + path + '* >> ' + subj + 'soccogdirsz.txt', shell=True) 
    

