#!/bin/bash
#$ -S /bin/bash
#$ -l mem=4G,time=24:00:00
#$ -cwd
#$ -N s2589-Anat-1
#$ -j y
#$ -o s2589-Anat-1.txt
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


recon-all -i /ifs/scratch/pimri/pyschotherapy/data/Panic/1009-VTSDHA/anatomical/Time1/2589-Anat-1/dicoms/i410085.MRDC.6 -subject s2589-Anat-1 -all -qcache