__author__ = 'katie'

import os

mdraft = '/ifs/scratch/pimri/soccog/scripts/test_estimate/ks_1stlevel_main_clust.m'
qdraft = '/ifs/scratch/pimri/soccog/scripts/test_estimate/qsub_1stlevel.sh'
write_dir = '/ifs/scratch/pimri/soccog/scripts/test_estimate'

run_script = open('/ifs/scratch/pimri/soccog/scripts/test_estimate/firstlevel.sh', 'w')
run_script.write('#! /bin/bash\n')

#subs = ['7404']

subs = ['7408', '7412', '7414']

for sub_num in subs:
    sub_name = 'sub' + sub_num
    q_string = 'qsub_' + sub_name + '.sh'
    m_string = 'fstlev_' + sub_name + '.m'
    m = open(mdraft, 'r')
    q = open(qdraft, 'r')
    mlines = m.readlines()
    mlines_copy = mlines[:]
    for i, line in enumerate(mlines):
        if '<subjects>' in line:
            mlines_copy[i]  = "subjects = {'" + sub_num + "'};\n"
    mscript_path = os.path.join(write_dir, m_string)
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
        if '<script_name>' in line:
            qlines_copy[j] = "/nfs/apps/matlab/2012a/bin/matlab -singleCompThread -nojvm -nodisplay -nosplash -r " + m_string[:-2]
    qscript_path = os.path.join(write_dir, q_string)
    q_out = open(qscript_path, 'w')
    for line in qlines_copy:
        q_out.write(line)
    run_script.write('qsub ' + q_string + '\n')
