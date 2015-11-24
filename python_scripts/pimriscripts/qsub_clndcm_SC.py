__author__ = 'katie'

import csv

#Create bash script that will have list of qsub commands
g = open('/media/truecrypt1/tmp/clean_dicoms_script.sh', 'w+')
g.write('#!/bin/bash\n')  #start script w/ shebang; navigate to dir

#Write out the qsub scripts

dirs = open('/media/truecrypt1/tmp/dirlist.txt', 'r')
prefix = '/ifs/scratch/pimri/soccog'

for d in csv.reader(dirs, dialect='excel', delimiter='\n'):
    #dir_name = prefix + d[0][d[0].find('working_data')+ len('working_data'):]
    dir_name = d[0]
    print dir_name
    name = d[0][25:43].replace('/', '')
    sh_string = 'qsub_' + name + '.sh'
    write_dir = '/media/truecrypt1/tmp/'
    m_name = 'clndcm_' + name
    m_string = 'clndcm_' + name + '.m'
    with open(write_dir + m_string, 'w+') as j:
        j.write((
                "dirList = dir('" + dir_name + "');\n"
                "for i=1:length(dirList)\n"
                "   %check if not directory\n"
                "   if ~dirList(i).isdir\n"
                "       %check if dicom file\n"
                "       str=dirList(i).name;\n"
                "       extension=[str(length(str)-2) str(length(str)-1) str(length(str))];\n"
                "       if extension == 'dcm'\n"
                "           info=dicominfo(['" + dir_name + "/' dirList(i).name]);\n"
                "           info.StudyDate='00000000';\n"
                "           info.SeriesDate='00000000';\n"
                "           info.AcquisitionDate='00000000';\n"
                "           info.ContentDate='00000000';\n"
                "           info.InstitutionName='anon';\n"
                "           info.InstitutionAddress='anon';\n"
                "           info.StationName='anon';\n"
                "           info.StudyDescription='anon';\n"
                "           info.PerformingPhysicianName.FamilyName='anon';\n"
                "           info.OperatorName.FamilyName='anon';\n"
                "           info.PatientName.FamilyName='anon';\n"
                "           info.PatientID='anon';\n"
                "           info.PatientBirthDate='00000000';\n"
                "           info.PatientAge='000Y';\n"
                "           info.DeviceSerialNumber='00000';\n"
                "           info.RequestedProcedureDescription='anon';\n"
                "           info.PerformedProcedureStepStartDate='00000000';\n"
                "           info.PerformedProcedureStepStartTime='000000.000000';\n"
                "           info.PerformedProcedureStepID='0000000000';\n"
                "           info.DateOfLastCalibration='0000000000';\n"
                "           info.BitDepth=12;\n"
                "           info.BitsStored=12;\n"
                "           info.HighBit=11;\n"
                "           d=dicomread(['" + dir_name + "/' dirList(i).name]);\n"
                "           mkdir('" + dir_name +  "/anonout');\n"
                "           dicomwrite(d, ['" + dir_name + "/anonout/' dirList(i).name], info, 'createmode', 'copy', 'BitDepth', 12, 'BitsStored', 12, 'HighBit', 11);\n"
                "       end\n"
                "   end\n"
                "end\n"
                "exit()"
        ))
    with open(write_dir + sh_string, 'w+') as f:
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
        f.write(('cd /ifs/scratch/pimri/soccog/scripts/cln_dcm;\n'
                 '/nfs/apps/matlab/2012a/bin/matlab -r '
                ) + m_name + ';')
    g.write('qsub ' + sh_string + '\n')

g.close()