from subprocess import Popen, PIPE, call, check_output
import os

root = "/media/katie/storage/PanicPTSD/data-neworg/Panic/"

def source(script, update=1):
    pipe = Popen(". %s; env" % script, stdout=PIPE, shell=True)
    data = pipe.communicate()[0]
    env = dict((line.split("=", 1) for line in data.splitlines()))
    if update:
        os.environ.update(env)
    return env

env = {}
env.update(os.environ)
env.update(source('~/scripts/mySetUpFreeSurfer.sh'))
env.update(source('/usr/local/freesurfer/FreeSurferEnv.sh'))

print env['GNOME_DESKTOP_SESSION_ID']
print env['TEST_ENV_VAR']

f = open("/media/katie/storage/PanicPTSD/" + 'recon_rec.txt', 'w')

for sub_dir in os.listdir(root):
    sub = "s" + sub_dir[0:4]
    anat_dir = os.path.join(root, sub_dir, "anatomical")
    for directory in os.listdir(anat_dir):
        time_dir = os.path.join(anat_dir, directory)
        for d in os.listdir(time_dir):
            dicoms_dir = os.path.join(time_dir, d, 'dicoms')
            dicom_list = os.listdir(dicoms_dir)
            dicom = dicom_list[0]
            path = os.path.join(dicoms_dir, dicom)
            cmd = 'mkdir $TEST_ENV_VAR/test'
            #check_output(cmd, shell=True, env=env)
            call(cmd, shell=True, env=env)
            Popen(cmd, shell=True, env=env)
            cmd1 = "recon-all -i " + path + " -subjid " + sub
            check_output(cmd1, shell=True, env=env)
            call(cmd1, shell=True, env=env)
            print cmd1
            f.write(cmd1)
            cmd2 = "recon-all -all -subjid " + sub,
            call(cmd2, shell=True, env=env)
            print cmd2
            f.write(cmd2)

