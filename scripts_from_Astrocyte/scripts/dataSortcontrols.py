import os, shutil, csv

src1 = '/media/katie/storage/Fornix_Backup/documents_and_settings/mri/Desktop/Behavioral_Data/Autism/'
src2 = '/media/katie/storage/Fornix_Backup/documents_and_settings/mri/Desktop/Behavioral_Data/OCD/'
src3 = '/media/katie/storage/Fornix_Backup/documents_and_settings/mri/Desktop/Behavioral_Data/Parkinsons_ICD/'
src4 = '/media/katie/storage/Fornix_Backup/documents_and_settings/mri/Desktop/Behavioral_Data/Obese/'
src5 = '/media/katie/storage/PanicPTSD/behavioral_data/autism/'


dst = '/media/katie/storage/PanicPTSD/data-neworg/Controls/'

lst = '/media/katie/storage/PanicPTSD/notesonautismcontrols.csv'

lst = open(lst)

affpaths = [os.path.join(src1, 'Affect'), os.path.join(src5, 'affect')]

simpaths = [os.path.join(src1, 'Rapid Simon'), os.path.join(src2, 'Rapid Simon'), os.path.join(src3, 'Rapid'),\
            os.path.join(src5, 'rapid_simon')]


def copy_and_rename(sub, exam, time):
    simfound = False
    afffound = False
    #affect    
    for d in affpaths:
        if afffound != True:
            for f in os.listdir(d):
                if (len(exam) > 6 and exam in f[8:]) or (len(exam) < 6 and exam in f):
                    srcdir = os.path.join(d, f)
                    print srcdir
                    newname = exam + "-Affect"
                    destdir = os.path.join(dst, sub, 'behavioral/affect/', time, newname)
                    print destdir
                    shutil.copytree(srcdir, destdir)
                    print newname
                    afffound = True              
    #simon
    for d in simpaths:
        if simfound != True:
            for f in os.listdir(d):
                if (len(exam) > 6 and exam in f[8:]) or (len(exam) < 6 and exam in f):
                    srcdir = os.path.join(d, f)
                    newname = exam + "-Simon"
                    destdir = os.path.join(dst, sub, 'behavioral/simon/', time, newname)
                    shutil.copytree(srcdir, destdir)
                    print newname
                    simfound = True
                
                
exam1 = 'zzzzz'
exam2 = 'zzzzz'
exam3 = 'zzzzz'

for subj in csv.DictReader(lst, delimiter='\t', dialect='excel'):
    print subj
    subj_id = subj['Study No.'] + '-' + subj['PPID']
    #if int(subj['Study No.']) < 1121:
    #else:
    os.mkdir(dst + subj_id)
    os.mkdir(os.path.join(dst, subj_id, 'behavioral'))
    os.mkdir(os.path.join(dst, subj_id, 'behavioral/affect/'))
    os.mkdir(os.path.join(dst, subj_id, 'behavioral/simon/'))
    if subj['Exam1']:
        exam1 = subj['Exam1']
        copy_and_rename(subj_id, exam1, 'Time1')
    if subj['Exam2']:
        exam2 = subj['Exam2']
        copy_and_rename(subj_id, exam2, 'Time2')
    if subj['Exam3']:
        exam3 = subj['Exam3']
        copy_and_rename(subj_id, exam3, 'Time3')
    if subj['Exam4']:
        exam3 = subj['Exam4']
        copy_and_rename(subj_id, exam3, 'Time4')



