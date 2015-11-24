
#!/bin/bash
#$ -S /bin/bash
#$ -l mem=4G,time=24:00:00
#$ -cwd
#$ -N s1151872_160_s28
#$ -j y
#$ -o s1151872_160_s28.txt
echo "Starting on : $(date)"
echo "Running on node : $(hostname)"
echo "Current directory : $(pwd)"
echo "Current job ID : $JOB_ID"
echo "Current job name : $JOB_NAME"
#The following is the job to be performed:
cd /ifs/scratch/pimri/soccog/matlab_scripts/cln_dcm_m_files;
/nfs/apps/matlab/2012a/bin/matlab -r clndcm_s1151872_160_s28;