
#!/bin/bash
#$ -S /bin/bash
#$ -l mem=4G,time=24:00:00
#$ -cwd
#$ -N ds1350011_f5610_s19_MEM_6_RUNS_34_SL_165_6d
#$ -j y
#$ -o ds1350011_f5610_s19_MEM_6_RUNS_34_SL_165_6d.txt
echo "Starting on : $(date)"
echo "Running on node : $(hostname)"
echo "Current directory : $(pwd)"
echo "Current job ID : $JOB_ID"
echo "Current job name : $JOB_NAME"
#The following is the job to be performed:
cd /ifs/scratch/pimri/soccog/matlab_scripts/cnv_dcm;
/nfs/apps/matlab/2012a/bin/matlab -r cnvdcm_ds1350011_f5610_s19_MEM_6_RUNS_34_SL_165_6d;