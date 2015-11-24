
import os, csv, uf, tarfile, dcm_ops_local, subprocess
from collections import OrderedDict

dst_root = '/media/truecrypt1/sorted_dcm'
src_root = '/media/truecrypt1/SocCog/SocCog/old/SocCog_Raw_Data_By_Exam_Number'
dirInfo = '/media/truecrypt1/SocCog/SocCog/records-nophi/subj-exam-dir-matching.csv'
scripts_dir = '/media/truecrypt1/scripts'
cnv_dir = '/media/truecrypt1/scripts/cnv'
ult_root = '/media/truecrypt1/sorted_img'

lst = open(dirInfo, 'r')

ordered_fieldnames = OrderedDict([('Subject',None),('Exam',None),('ExDir', None),('SeriesName', None),('SerDir', None),
                                  ('Notes', None),('CopiedRaw', None),('Extracted', None),('DCMadded', None),
                                  ('Converted', None), ('Renamed', None), ('Moved', None)])

logfile = os.path.join(dst_root, 'logfile.csv')

with open(logfile,'wb') as log:
    dw = csv.DictWriter(log, delimiter='\t', fieldnames=ordered_fieldnames)
    dw.writeheader()

for line in csv.DictReader(lst, dialect='excel', delimiter=','):
    logline = line
    subj_id = line['Subject']
    exam = line['Exam']
    ex_dir = line['ExDir']
    ser_name = line['SeriesName']
    ser_dir = line['SerDir']
    ser_dir = ser_dir.replace(' ', '')
    ser_id = subj_id + '_' + ser_name
    src_path = os.path.join(src_root, exam, ex_dir, ser_dir)
    notes = line['Notes']
    if 'anat' in ser_name:
        if 'best' in notes:
            dst_path_lst = [subj_id, 'anat']
        else:
            dst_path_lst = [subj_id, 'spare_anat', ser_name]

    if 'run' in ser_name:
        dst_path_lst = [subj_id, 'func', ser_name]

    ###COPY RAW DIRECTORY TO NEW DIR, SORTED BY SUBJECT###

    dst_path = uf.buildtree(dst_root, dst_path_lst)
    uf.copytree(src_path, dst_path)

    logline['CopiedRaw'] = dst_path

    ###UNTAR FILES###

    t = tarfile.open(os.path.join(dst_path,'MRDC_files.tar.gz'), 'r')
    t.extractall(dst_path)

    #cmd = 'tar -xvzf MRDC_files.tar.gz'
    #res = subprocess.check_output(cmd,cwd=dst_path,shell=True)

    files = [f for f in os.listdir(dst_path) if f[0] == 'i']
    logline['Extracted'] = 'Extracted_' + str(len(files)) + '_files_' + os.path.join(dst_path, files[0])

    ###ADD DCM EXTENSION###
    for f in os.listdir(dst_path):
        if 'MRDC' in f and 'gz' not in f and 'dcm' not in f:
            old = os.path.join(dst_path, f)
            new = os.path.join(dst_path, f + '.dcm')
            os.rename(old, new)
    files = [f for f in os.listdir(dst_path) if f[-3:] == 'dcm']
    logline['DCMadded'] = 'DCMadded_' + str(len(files)) + '_files_' + os.path.join(dst_path, files[0])

    ###CNV DICOMS###

    cnv_out = dcm_ops_local.cnv_dcm(dst_path, ser_id, cnv_dir)
    cnv_out = cnv_out.split(' ')
    for i, l in enumerate(cnv_out):
        if 'Executing' in l:
            report = ' '.join([l, cnv_out[i + 1], cnv_out[i +2 ]])
    done = False
    while done == False:
        if 'cnv_complete.txt' in [f for f in os.listdir(dst_path)]:
            done = True
    files = [f for f in os.listdir(dst_path) if (f[-3:] == 'dcm' or f[-3] == 'img')]
    logline['Converted'] = report + 'Converted_' + str(len(files)) + '_files'

    ###RENAME IMG###

    for f in os.listdir(dst_path):
        old = os.path.join(dst_path, f)
        if (f[-3:] == 'img' or f[-3:] == 'hdr') and 'run' in dst_path:
            newname = 'f' + f[-13:-7] + f[-4:]
            new = os.path.join(dst_path, newname)
            os.rename(old, new)
        if (f[-3:] == 'img' or f[-3:] == 'hdr') and ('anat' in dst_path):
            newname = 's' + f[-13:-7] + f[-4:]
            new = os.path.join(dst_path, newname)
            os.rename(old, new)
    files = [f for f in os.listdir(dst_path) if len(f) <= 12]
    logline['Renamed'] = 'Renamed_' + str(len(files)) + '_files_' + os.path.join(dst_path, files[0])

    ###MOVE IMG####

    ult_path = uf.buildtree(ult_root, dst_path_lst)
    for f in os.listdir(dst_path):
        if (f[-3:] == 'img' or f[-3:] == 'hdr'):
            old = os.path.join(dst_path, f)
            new = os.path.join(ult_path, f)
            print old
            print new
            print ' '
            os.rename(old, new)
    files = [f for f in os.listdir(ult_path)]
    logline['Moved'] = 'Moved_' + str(len(files)) + '_files_' + os.path.join(ult_path, files[0])

    #del(logline[''])
    with open(logfile,'a+') as log:
        dw = csv.DictWriter(log, delimiter='\t', fieldnames=ordered_fieldnames)
        dw.writerow(logline)

uf.done(os.path.join(dst_root, 'done.txt'), "ks_mastersort_no_clust.py, program to sort has completed")



