
#!/bin/bash
#$ -S /bin/bash
#$ -l mem=4G,time=24:00:00
#$ -cwd
#$ -N ds1637788_1904_2L5_s28d
#$ -j y
#$ -o ds1637788_1904_2L5_s28d.txt
echo "Starting on : $(date)"
echo "Running on node : $(hostname)"
echo "Current directory : $(pwd)"
echo "Current job ID : $JOB_ID"
echo "Current job name : $JOB_NAME"
#The following is the job to be performed:
cd /ifs/scratch/pimri/soccog/matlab_scripts/cnv_dcm;
/nfs/apps/matlab/2012a/bin/matlab -r cnvdcm_ds1637788_1904_2L5_s28d;