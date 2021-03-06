
#!/bin/bash
#$ -S /bin/bash
#$ -l mem=4G,time=24:00:00
#$ -cwd
#$ -N j7645_run1L3
#$ -j y
#$ -o 7645_run1L3.txt
echo "Starting on : $(date)"
echo "Running on node : $(hostname)"
echo "Current directory : $(pwd)"
echo "Current job ID : $JOB_ID"
echo "Current job name : $JOB_NAME"
#The following is the job to be performed:
python /ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/p7645_run1L3.py