__author__ = 'katie'

import os, subprocess

def cnv_dcm(dcm_dir, ser_id, write_dir):
    q_string = 'qsub_' + ser_id + '.sh'
    m_string = 'cnv_' + ser_id + '.m'
    with open(os.path.join(write_dir, m_string), 'w+') as j:
        j.write((
                "disp ('Executing -r " + m_string + "')\n"
                "addpath('/ifs/scratch/pimri/core/software/SPM/8-latest/spm8');\n"
                "disp ('" + dcm_dir + "')\n"
                "files = spm_select('FPList', '" + dcm_dir + "', '\.dcm');\n"
                "spm_defaults;\n"
                "hdr = spm_dicom_headers(files)\n"
                "cd('" + dcm_dir + "')\n"
                "spm_dicom_convert(hdr)\n"
                "logname = fullfile('" + dcm_dir + ", 'cnv_complete.txt');\n"
                "log = fopen(logname,'wt');\n"
                "frintf(log, 'done');\n"
                "fclose(log);\n"
                "exit()"
        ))
    with open(os.path.join(write_dir, q_string), 'w+') as f:
        f.write(('\n'
                 '#!/bin/bash\n'
                 '#$ -S /bin/bash\n'
                 '#$ -l mem=4G,time=24:00:00\n'
                 '#$ -cwd\n'
        ))
        f.write('#$ -N ' + ser_id + '\n#$ -j y\n#$ -o ' + ser_id + '.txt\n')
        f.write('''\
echo "Starting on : $(date)"
echo "Running on node : $(hostname)"
echo "Current directory : $(pwd)"
echo "Current job ID : $JOB_ID"
echo "Current job name : $JOB_NAME"
#The following is the job to be performed:
''')
        f.write(('cd /ifs/scratch/pimri/soccog/scripts/cnv_dcm;\n'
                 '/nfs/apps/matlab/2012a/bin/matlab -r '
                ) + m_string + ';')
        return subprocess.check_output(
        'qsub ' + q_string,
        cwd=write_dir,
        shell=True,
        stderr=subprocess.STDOUT)
