# estimate_cluster.py is a program to parallelize and automate the estimation of first-level models in SPM via the C2B2
# cluster. It is tested in python 2.6.6, the version of python that as of this writing was running by default on C2B2.
# It contains two functions.  The first, job_spec(), reads two generic files, estimate.m, a generic m-file, and
# qsub_estimate.sh, a generic qsub submission script.  It then writes subject-specific m-files,
# subject-specific qsub bash scripts, and a bash script to submit all the qsub jobs.  job_spec() takes four arguments:
# (1) the name of the directory that contains the generic files, where the m-files, qsub scripts, and submission
# script will be written, (2) a list of subject-specific directory names that contain SPM.mat files
# with each subjects' design matrix, (3) the name of the parent directory that houses the subject specific directories,
# and (4) the directory where the .mat file containing the record of the job that was run will be written.
# submit_job() takes just one argument: the directory where all the scripts job_spec generated are stored.

# estimate_cluster.py can be run as a standalone script, by uncommenting the last six lines and replacing the lines that
# define subs, mat_file_dir, script_dir, and log_dir with the relevant values for your directory structure. You would
# then save the file somewhere on the cluster and run it by typing python estimate_cluster.py from the command line
# of the directory where it is located. Make sure that the generic files are saved in the directory specified by
# scriptDir. Alternatively, job_spec() and and submit_job() can be called as functions from another python script.
# To do this, you would write a python script saved in the same directory as estimate_cluster.py, and put the line
# "import estimate_cluster" at the beginning of your script.  You could then call estimate_cluster.job_spec(arg1, arg2,
# arg3, arg4) and/or estimate_cluster.submit_job(arg1) with the appropriate arguments
#
# A note: this script calls SPM8, Matlab2012a, and a form of SPM's change directory function that gives a "deprecated"
# warning. Any contributions from others to bring this script up-to-date would be welcome; this is what I got to work
# on the cluster.-Katie Surrence Nov-24-2014



__author__ = 'katie'

import os, subprocess

def job_spec(scriptDir, subjList, matDir, logDir):
    '''write subject-specific m-files and qsub scripts, and a script to submit the jobs'''
    mdraft = os.path.join(scriptDir, 'estimate.m')
    qdraft = os.path.join(scriptDir, 'qsub_estimate.sh')
    run_script = open(os.path.join(scriptDir, 'submit_qsubs.sh'), 'w')
    run_script.write('#! /bin/bash\n')
    for sub_num in subjList:
        sub_name = 'sub' + sub_num
        q_string = 'qsub_' + sub_name + '.sh'
        m_string = 'est_' + sub_name + '.m'
        m = open(mdraft, 'r')
        q = open(qdraft, 'r')
        mlines = m.readlines()
        mlines_copy = mlines[:]
        for i, line in enumerate(mlines):
            if '<subjects>' in line:
                mlines_copy[i]  = "subjects = {'" + sub_num + "'};\n"
            if '<res_dir>' in line:
                mlines_copy[i]  = "res_dir = '" + matDir + "';\n"
            if '<log_dir>' in line:
                mlines_copy[i] = "log_dir = '" + logDir + "';\n"
        mscript_path = os.path.join(scriptDir, m_string)
        m_out = open(mscript_path, 'w')
        for line in mlines_copy:
            m_out.write(line)
        qlines = q.readlines()
        qlines_copy = qlines[:]
        for j, line in enumerate(qlines):
            if '<job_name>' in line:
                qlines_copy[j] = "#$ -N " + sub_name + "\n"
            if '<txt_name>' in line:
                qlines_copy[j] = "#$ -o " + sub_name + ".txt\n"
            if '<script_dir>' in line:
                qlines_copy[j] = "cd " + scriptDir + ";\n"
            if '<script_name>' in line:
                qlines_copy[j] = "/nfs/apps/matlab/2012a/bin/matlab -singleCompThread -nojvm -nodisplay -nosplash -r " \
                                 + m_string[:-2]
        qscript_path = os.path.join(scriptDir, q_string)
        q_out = open(qscript_path, 'w')
        for line in qlines_copy:
            q_out.write(line)
        run_script.write('qsub ' + q_string + "\n")

def submit_job(scriptDir):
    '''submit the qsub jobs to the cluster'''
    subprocess.call("cd " + scriptDir + "; " + "source " + os.path.join(scriptDir, 'submit_qsubs.sh'), shell=True)

#To run this program as a script,uncomment out these six lines and replace the definition of subs, mat_file_dir,
#script_dir, and log_dir with values that pertain to your directory structure.

#subs = ['7408', '7412', '7414']

#mat_file_dir = '/ifs/scratch/pimri/soccog/scripts/test_estimate/mat_files'

#script_dir = '/ifs/scratch/pimri/soccog/scripts/test_estimate'

#log_dir = '/ifs/scratch/pimri/soccog/scripts/test_estimate/logdir'

#job_spec(script_dir, subs, mat_file_dir, log_dir)

#submit_job(script_dir)




