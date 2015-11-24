#! /bin/bash
#$ -l mem=4G,time=24:00:00
#$ -cwd
#$ -N <job_name>
#$ -j y
#$ -o <txt_name>
echo "Starting on : $(date)"
echo "Running on node : $(hostname)"
echo "Current directory : $(pwd)"
echo "Current job ID : $JOB_ID"
echo "Current job name : $JOB_NAME"
#The following is the job to be performed:
cd /ifs/scratch/pimri/soccog/scripts/test_estimate;
/nfs/apps/matlab/2012a/bin/matlab -singleCompThread -nojvm -nodisplay -nosplash -r <script_name>;