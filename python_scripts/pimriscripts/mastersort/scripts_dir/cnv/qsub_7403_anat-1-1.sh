
#!/bin/bash
#$ -S /bin/bash
#$ -l mem=4G,time=24:00:00
#$ - /ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cnv
#$ -N cnv_7403_anat-1-1
#$ -j y
#$ -o 7403_anat-1-1.txt
echo "Starting on : $(date)"
echo "Running on node : $(hostname)"
echo "Current directory : $(pwd)"
echo "Current job ID : $JOB_ID"
echo "Current job name : $JOB_NAME"
#The following is the job to be performed:
cd /ifs/scratch/pimri/soccog/scripts/cnv_dcm;
/nfs/apps/matlab/2012a/bin/matlab -r cnv_7403_anat-1-1.m;