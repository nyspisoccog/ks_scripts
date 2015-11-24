from __future__ import with_statement
import os, subprocess, uf
__author__ = 'katie'

def cnv_dcm(dcm_dir, ser_id, write_dir):
    serid = ser_id.replace('-', '_')
    m_string = 'cnv_' + serid + '_script.m'
    m_run = m_string[:-2]
    with open(os.path.join(write_dir, m_string), 'w+') as j:
        j.write((
                "disp ('Executing -r " + m_string + "')\n"
                "addpath('/home/katie/spm8');\n"
                "disp ('" + dcm_dir + "')\n"
                "files = spm_select('FPList', '" + dcm_dir + "', '\.dcm');\n"
                "spm_defaults;\n"
                "hdr = spm_dicom_headers(files)\n"
                "cd('" + dcm_dir + "')\n"
                "spm_dicom_convert(hdr)\n"
                "logname = fullfile('" + dcm_dir + "', 'cnv_complete.txt');\n"
                "log = fopen(logname,'wt');\n"
                "fprintf(log, 'done');\n"
                "fclose(log);\n"
                "exit()"
        ))
    cmd = 'cd ' + write_dir + ';\n' + '/usr/local/MATLAB/R2014a/bin/matlab -r ' + m_run
    return subprocess.check_output(cmd,cwd=write_dir,shell=True)

