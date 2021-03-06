
#!/bin/bash
#$ -S /bin/bash
#$ -l mem=4G,time=24:00:00
#$ -cwd
#$ -N j7443_run2M4
#$ -j y
#$ -o 7443_run2M4.txt
echo "Starting on : $(date)"
echo "Running on node : $(hostname)"
echo "Current directory : $(pwd)"
echo "Current job ID : $JOB_ID"
echo "Current job name : $JOB_NAME"
#The following is the job to be performed:
python /ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/p7443_run2M4.py