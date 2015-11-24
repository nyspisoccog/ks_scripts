import subprocess
import os
import stat

src_dirs = ['/ifs/scratch/pimri/pyschotherapy/data/Panic/', '/ifs/scratch/pimri/pyschotherapy/data/PTSD/',\
            '/ifs/scratch/pimri/pyschotherapy/data/Controls/']

with open('recon_script.sh', 'w') as g:
        g.write('#!/bin/bash\n cd /ifs/scratch/pimri/pyschotherapy/qsub_scripts/')

fspgr_dirs = []
for src_dir in src_dirs:
    for subj_dir in os.listdir(src_dir):
        anat_dir = os.path.join(src_dir, subj_dir, 'anatomical')
        for time_dir in os.listdir(anat_dir):
            time_dir = os.path.join(anat_dir, time_dir)
            for files_dir in os.listdir(time_dir):
                for entry in os.listdir(os.path.join(time_dir, files_dir)):
                    if 'dicoms' in entry:
                        dicom1 = [d for d in os.listdir(os.path.join(time_dir, files_dir, entry))][3]
                        fspgr_dirs.append((os.path.join(time_dir, files_dir, entry, dicom1), files_dir))

for fspgr_dir in fspgr_dirs:
    subjid = fspgr_dir[1]
    sh_string = 'qsub_' + subjid + '.sh'
    with open(sh_string, 'w') as f:
        f.write('''\
#!/bin/bash
#$ -S /bin/bash
#$ -l mem=4G,time=24:00:00
#$ -cwd
#$ -N
''')
        f.write('qsub_example\n')
        f.write('''\
#$ -j y
#$ -o
''')
        f.write(subjid + '.txt')
        f.write('''\
echo "Starting on : $(date)"
echo "Running on node : $(hostname)"
echo "Current directory : $(pwd)"
echo "Current job ID : $JOB_ID"
echo "Current job name : $JOB_NAME"
#The following is the job to be performed:

export SUBJECTS_DIR=/ifs/scratch/pimri/pyschotherapy/freesurfer_output
''')
        f.write('recon-all -i ' + fspgr_dir[0] + ' -subject ' + subjid + ' -all -qcache')
    with open('/ifs/scratch/pimri/pyschotherapy/bash_scripts/recon_script.sh', 'w') as g:
        g.write('qsub ' + sh_string + '\n')

        
filename = g.name
os.chmod(filename, stat.S_IRUSR | stat.S_IXUSR)
#subprocess.call([filename])
os.unlink(filename)                                                                                                      







        
