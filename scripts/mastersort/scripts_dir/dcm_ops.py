from __future__ import with_statement
import os, subprocess, uf
__author__ = 'katie'

def cln_dcm(dcm_dir, ser_id, write_dir):
    q_string = 'qsub_' + ser_id + '.sh'
    m_string = 'cln_' + ser_id + '.m'
    with open(os.path.join(write_dir, m_string), 'w+') as j:
        j.write((
                "dirList = dir('" + dcm_dir + "');\n"
                "for i=1:length(dirList)\n"
                "   %check if not directory\n"
                "   if ~dirList(i).isdir\n"
                "       %check if dicom file\n"
                "       str=dirList(i).name;\n"
                "       extension=[str(length(str)-2) str(length(str)-1) str(length(str))];\n"
                "       if extension == 'dcm'\n"
                "           info=dicominfo(['" + dcm_dir + "/' dirList(i).name]);\n"
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
                "           d=dicomread(['" + dcm_dir + "/' dirList(i).name]);\n"
                "           mkdir('" + dcm_dir +  "/anonout');\n"
                "           dicomwrite(d, ['" + dcm_dir + "/anonout/' dirList(i).name], info, 'createmode', 'copy', 'BitDepth', 12, 'BitsStored', 12, 'HighBit', 11);\n"
                "       end\n"
                "   end\n"
                "end\n"
                "logname = fullfile('" + dcm_dir + ",'anonout', 'cln_complete.txt');\n"
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
            f.write('#$ -N ' + 'cln' + ser_id + '\n#$ -j y\n#$ -o ' + ser_id + '.txt\n')
            f.write('''\
    echo "Starting on : $(date)"
    echo "Running on node : $(hostname)"
    echo "Current directory : $(pwd)"
    echo "Current job ID : $JOB_ID"
    echo "Current job name : $JOB_NAME"
    #The following is the job to be performed:
    ''')
            f.write(('cd ' + write_dir + ';\n'
                     '/nfs/apps/matlab/2012a/bin/matlab -r '
                    ) + m_string + ';')
    return subprocess.check_output(
        'qsub ' + q_string,
        cwd=write_dir,
        shell=True,
        stderr=subprocess.STDOUT)

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
        f.write('#$ -N ' + 'cnv_' + ser_id + '\n#$ -j y\n#$ -o ' + ser_id + '.txt\n')
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
        return uf.check_output(
        'qsub ' + q_string,
        cwd=write_dir,
        shell=True)

