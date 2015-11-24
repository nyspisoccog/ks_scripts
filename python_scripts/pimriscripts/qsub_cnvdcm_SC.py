__author__ = 'katie'


import csv
import os

root = '/media/truecrypt1/tmp'
#Create bash script that will have list of qsub commands
g = open(os.path.join(root, 'cnv_dicoms_script.sh'), 'w+')
g.write('#!/bin/bash\ncd /ifs/scratch/pimri/soccog/scripts/cnv_dcm\n')  #start script w/ shebang; navigate to dir

#Write out the qsub scripts

dirs = open(os.path.join(root, 'dirlist.txt'), 'r')
#prefix = '/ifs/scratch/pimri/soccog'

for d in csv.reader(dirs, dialect='excel', delimiter='\n'):
    #dir_name = prefix + d[0][d[0].find('working_data')+ len('working_data'):] + '/anonout'
    dir_name = d[0]
    print dir_name
    name = 'd' + d[0][d[0][:-15].rfind("/")+1:-15] + 'd'
    name = name.replace('-', '_')
    sh_string = 'qsub_' + name + '.sh'
    m_name = 'cnvdcm_' + name
    m_string = 'cnvdcm_' + name + '.m'
    with open(os.path.join(root, m_string), 'w+') as j:
        j.write((
                "disp ('Executing -r " + m_name + "')\n"
                "addpath('/ifs/scratch/pimri/core/software/SPM/8-latest/spm8');\n"
                "disp ('" + dir_name + "')\n"
                "files = spm_select('FPList', '" + dir_name + "', '\.dcm');\n"
                "spm_defaults;\n"
                "hdr = spm_dicom_headers(files)\n"
                "cd('" + dir_name + "')\n"
                "spm_dicom_convert(hdr)\n"
                "exit()"
        ))
    with open(os.path.join(root, sh_string), 'w+') as f:
        f.write(('\n'
                 '#!/bin/bash\n'
                 '#$ -S /bin/bash\n'
                 '#$ -l mem=4G,time=24:00:00\n'
                 '#$ -cwd\n'
        ))
        f.write('#$ -N ' + name + '\n#$ -j y\n#$ -o ' + name + '.txt\n')
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
                ) + m_name + ';')
    g.write('qsub ' + sh_string + '\n')

g.close()