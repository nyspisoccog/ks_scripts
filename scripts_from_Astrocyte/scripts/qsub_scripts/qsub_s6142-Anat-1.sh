#!/bin/bash
#$ -S /bin/bash
#$ -l mem=4G,time=24:00:00
#$ -cwd
#$ -N s6142-Anat-1
#$ -j y
#$ -o s6142-Anat-1.txt
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


recon-all -i /ifs/scratch/pimri/pyschotherapy/data/PTSD/1127-XHSJCG/anatomical/Time1/6142-Anat-1/dicoms/i4575195.MRDC.1 -subject s6142-Anat-1 -all -qcache