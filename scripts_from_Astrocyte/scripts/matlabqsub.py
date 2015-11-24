__author__ = 'katie'

import csv

#Create bash script that will have list of qsub commands
g = open('/home/katie/scripts/clean_dicoms_script.sh', 'w+')
g.write('#!/bin/bash\ncd /ifs/scratch/pimri/soccog/qsub_scripts/\n')  #start script w/ shebang; navigate to dir

#Write out the qsub scripts

dirs = open('/media/katie/SocCog/working_data/dirlist.csv', 'r')
prefix = '/ifs/scratch/pimri'


for d in csv.reader(dirs, dialect='excel', delimiter='\n'):
    dir_name = prefix + d[0][d[0].find('working_data')+ len('working_data'):]
    name = d[0][d[0][:-7].rfind("/")+1:-7]
    sh_string = 'qsub_' + name + '.sh'
    qsub_dir = '/home/katie/scripts/qsub_matlab/'
    with open(qsub_dir + sh_string, 'w+') as f:
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
        f.write('matlab -r clean_dicoms_cluster(' + dir_name + ')')
    g.write('qsub ' + sh_string + '\n')

g.close()
