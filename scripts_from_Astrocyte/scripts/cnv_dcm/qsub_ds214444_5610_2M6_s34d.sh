
#!/bin/bash
#$ -S /bin/bash
#$ -l mem=4G,time=24:00:00
#$ -cwd
#$ -N ds214444_5610_2M6_s34d
#$ -j y
#$ -o ds214444_5610_2M6_s34d.txt
echo "Starting on : $(date)"
echo "Running on node : $(hostname)"
echo "Current directory : $(pwd)"
echo "Current job ID : $JOB_ID"
echo "Current job name : $JOB_NAME"
#The following is the job to be performed:
cd /ifs/scratch/pimri/soccog/matlab_scripts/cnv_dcm;
/nfs/apps/matlab/2012a/bin/matlab -r cnvdcm_ds214444_5610_2M6_s34d;