import os, csv, datetime, uf

#dst_root = '/media/truecrypt1/working_SocCog'
#src_root = '/media/truecrypt1/SocCog/SocCog/old/SocCog_Raw_Data_By_Exam_Number'
#dirInfo = '/media/truecrypt1/SocCog/SocCog/records-nophi/subj-exam-dir-matching.csv'
#scripts_dir = '/media/truecrypt1/scripts'

dst_root = '/ifs/scratch/pimri/soccog/test_working'
src_root = '/ifs/archive/pimri/soccog/old/SocCog_Raw_Data_By_Exam_Number'
dirInfo = '/ifs/scratch/pimri/soccog/scripts/subj-exam-dir-matching.csv'
scripts_dir = '/ifs/scratch/pimri/soccog/scripts'


lst = open(dirInfo, 'r')
now = datetime.datetime.now()

for line in csv.DictReader(lst, dialect='excel', delimiter=','):
    subj_id = line['Subject']
    exam = line['Exam']
    ex_dir = line['ExDir']
    ser_name = line['SeriesName']
    ser_dir = line['SerDir']
    ser_id = subj_id + '_' + ser_name
    src_path = os.path.join(src_root, exam, ex_dir, ser_dir)
    dst_path = os.path.join(dst_root, subj_id, ser_name)
    cnv_dir = '/ifs/scratch/pimri/soccog/scripts/cnv_dcm'
    cln_dir = '/ifs/scratch/pimri/soccog/scripts/cln_dcm'
    q_string = 'q' + ser_id + '.sh'
    p_string = 'p' + ser_id + '.py'
    p_path = os.path.join(scripts_dir, p_string)

    with open(p_path, 'w+') as p:

        p.write("import os, csv, shutil,tarfile, uf, dcm_ops" + "\n")

        ###COPY RAW DIRECTORY TO NEW DIR, SORTED BY SUBJECT###
        p.write("dest_root = '" + dst_root + "'" + "\n")
        p.write("dst_path_lst = ['" + subj_id + "', '" + ser_name + "']" + "\n")
        p.write("uf.buildtree(dest_root, dst_path_lst)" + "\n")
        p.write("uf.copytree('" + src_path + "', '" + dst_path + "')")
        p.write("\n")
        #log.write something about dst dir

        ###UNTAR FILES###
        p.write("t = tarfile.open(os.path.join('" + dst_path + "','MRDC_files.tar.gz'), 'r')")
        p.write("\n")
        p.write("t.extractall('" + dst_path + "')")
        p.write("\n")

        ###ADD DCM EXTENSION###
        p.write("for f in os.listdir('" + dst_path + "'):" + "\n")
        p.write("   if 'MRDC' in f and 'gz' not in f:" + "\n")
        p.write("       old = os.path.join('" + dst_path + "', f)" + "\n")
        p.write("       new = os.path.join('" + dst_path + "', f + '.dcm')" + "\n")
        p.write("       os.rename(old, new)" + "\n")

        #write something to log file about whether completed.  check that number of dcms = orig number of dicoms?

        ###CNV DICOMS###

        p.write("#qsub_cnv_out = dcm_ops.cnv_dcm('" + dst_path + "', '" + ser_id + "', '" + cnv_dir + "'\n")
        #log.write

        ###ANONYMIZE DICOMS###
        p.write("#qsub_cln_out = dcm_ops.cnv_dcm('" + dst_path + "', '" + ser_id + "', '" + cln_dir + "'\n")
        #log.write

        ###CHECK IMG IS DONE"
#        done = False
#        while done == False:
#            if 'cnv_complete.txt' in [f for f in os.listdir(dst_path)]:
#                if start < uf.modification_date(os.path.join(dst_path, 'cnv_complete.txt')):
#                    done = True


        ###RENAME IMG###


        ###MOVE IMG####

    with open(os.path.join(scripts_dir, q_string), 'w+') as q:
        q.write("""
#!/bin/bash
#$ -S /bin/bash
#$ -l mem=4G,time=24:00:00
#$ -cwd
""")
        q.write('#$ -N ' + ser_id + '\n#$ -j y\n#$ -o ' + ser_id + '.txt\n')
        q.write('''\
echo "Starting on : $(date)"
echo "Running on node : $(hostname)"
echo "Current directory : $(pwd)"
echo "Current job ID : $JOB_ID"
echo "Current job name : $JOB_NAME"
#The following is the job to be performed:
''')
        q.write("python " + p_path)

uf.done(os.path.join(dst_root, 'done.txt'), "SocCogMasterSort.py, program to sort has completed")


