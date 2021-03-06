import os

nm_dirs = ['/ifs/scratch/pimri/pyschotherapy/data/Panic/', '/ifs/scratch/pimri/pyschotherapy/data/PTSD/',\
            '/ifs/scratch/pimri/pyschotherapy/data/Controls/']

src_dirs = ['/media/katie/storage/PanicPTSD/data-neworg/Panic/', '/media/katie/storage/PanicPTSD/data-neworg/PTSD/',\
            '/media/katie/storage/PanicPTSD/data-neworg/Controls/']


###Create file that will have list of qsub commands
g = open('/home/katie/scripts/recon_script.sh', 'w+')
g.write('#!/bin/bash\ncd /ifs/scratch/pimri/pyschotherapy/qsub_scripts/\n')


###Build up a list of paths for a single dicom.  This is written for my directory structure.  

fspgr_dirs = []
for i, src_dir in enumerate(src_dirs):
    for subj_dir in os.listdir(src_dir):
        anat_dir = os.path.join(src_dir, subj_dir, 'anatomical')
        for time_dir in os.listdir(anat_dir):
            time_dir = os.path.join(anat_dir, time_dir)
            for files_dir in os.listdir(time_dir):
                for entry in os.listdir(os.path.join(time_dir, files_dir)):
                    if 'dicoms' in entry:
                        dicom1 = [d for d in os.listdir(os.path.join(time_dir, files_dir, entry))][3]
                        remote_time_dir = os.path.join(nm_dirs[i], time_dir[len(src_dir):])
                        fspgr_dirs.append((os.path.join(remote_time_dir, files_dir, entry, dicom1), files_dir))


###Write out the qsub scripts

for fspgr_dir in fspgr_dirs:
    subjid = 's' + fspgr_dir[1]
    sh_string = 'qsub_' + subjid + '.sh'
    with open(sh_string, 'w+') as f:
        f.write('''\
#!/bin/bash
#$ -S /bin/bash
#$ -l mem=4G,time=24:00:00
#$ -cwd
''')
        f.write('#$ -N ' + subjid + '\n#$ -j y\n#$ -o '+ subjid + '.txt\n')
        f.write('''\
echo "Starting on : $(date)"
echo "Running on node : $(hostname)"
echo "Current directory : $(pwd)"
echo "Current job ID : $JOB_ID"
echo "Current job name : $JOB_NAME"
#The following is the job to be performed:

export FREESURFER_HOME=/ifs/scratch/pimri/core/fmri/freesurfer
export SUBJECTS_DIR=/ifs/scratch/pimri/pyschotherapy/freesurfer_output
export NO_FSFAST=NO_FSFAST
source $FREESURFER_HOME/SetUpFreeSurfer.sh
export LD_LIBRARY_PATH=/nfs/apps/gcc/4.6.0/lib64


''')
        f.write('recon-all -i ' + fspgr_dir[0] + ' -subject ' + subjid + ' -all -qcache')
    g.write('qsub ' + sh_string + '\n')

g.close()

        







        
