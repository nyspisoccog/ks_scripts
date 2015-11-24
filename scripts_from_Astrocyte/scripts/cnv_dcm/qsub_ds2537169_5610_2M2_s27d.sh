
#!/bin/bash
#$ -S /bin/bash
#$ -l mem=4G,time=24:00:00
#$ -cwd
#$ -N ds2537169_5610_2M2_s27d
#$ -j y
#$ -o ds2537169_5610_2M2_s27d.txt
echo "Starting on : $(date)"
echo "Running on node : $(hostname)"
echo "Current directory : $(pwd)"
echo "Current job ID : $JOB_ID"
echo "Current job name : $JOB_NAME"
#The following is the job to be performed:
cd /ifs/scratch/pimri/soccog/matlab_scripts/cnv_dcm;
/nfs/apps/matlab/2012a/bin/matlab -r cnvdcm_ds2537169_5610_2M2_s27d;