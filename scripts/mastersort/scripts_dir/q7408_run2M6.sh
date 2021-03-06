
#!/bin/bash
#$ -S /bin/bash
#$ -l mem=4G,time=24:00:00
#$ -cwd
#$ -N j7408_run2M6
#$ -j y
#$ -o 7408_run2M6.txt
echo "Starting on : $(date)"
echo "Running on node : $(hostname)"
echo "Current directory : $(pwd)"
echo "Current job ID : $JOB_ID"
echo "Current job name : $JOB_NAME"
#The following is the job to be performed:
python /ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/p7408_run2M6.py