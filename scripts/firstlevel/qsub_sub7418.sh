#! /bin/bash
#$ -l mem=4G,time=24:00:00
#$ -cwd
#$ -N sub7418
#$ -j y
#$ -o sub7418.txt
echo "Starting on : $(date)"
echo "Running on node : $(hostname)"
echo "Current directory : $(pwd)"
echo "Current job ID : $JOB_ID"
echo "Current job name : $JOB_NAME"
#The following is the job to be performed:
cd /ifs/scratch/pimri/soccog/scripts/firstlevel;
/nfs/apps/matlab/2012a/bin/matlab -singleCompThread -nojvm -nodisplay -nosplash -r fstlev_sub7418