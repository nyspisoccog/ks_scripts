__author__ = 'katie'

import os

mdraft = '/ifs/scratch/pimri/soccog/scripts/firstlevel/ks_1stlevel_main_clust.m'
qdraft = '/ifs/scratch/pimri/soccog/scripts/firstlevel/qsub_1stlevel.sh'
write_dir = '/ifs/scratch/pimri/soccog/scripts/firstlevel'

run_script = open('/ifs/scratch/pimri/soccog/scripts/firstlevel/firstlevel.sh', 'w')
run_script.write('#! /bin/bash\n')

subs =      ['7408', '7412', '7414', '7418', '7430', '7432',
            '7436', '7443', '7453', '7458', '7474', '7477', '7478', '7480',
            '7498', '7508', '7521', '7533', '7534', '7542', '7558', '7561',
            '7562', '7575', '7580', '7607', '7613', '7619', '7623', '7638',
            '7641', '7645', '7648', '7649', '7659', '7714', '7719', '7726']

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
            qlines_copy[j] = "/nfs/apps/matlab/2012a/bin/matlab -singleCompThread -nojvm -nodisplay -nosplash -r" + m_string[:-2]
    qscript_path = os.path.join(write_dir, q_string)
    q_out = open(qscript_path, 'w')
    for line in qlines_copy:
        q_out.write(line)
    run_script.write('qsub ' + q_string)


