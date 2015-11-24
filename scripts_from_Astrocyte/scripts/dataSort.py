import os, shutil, csv

src1 = '/media/katie/storage/Fornix_Backup/documents_and_settings/mri/Desktop/Behavioral_Data/'
src2 = '/media/katie/storage/PanicPTSD/behavioral_data/'


dst = '/media/katie/storage/PanicPTSD/data-neworg/Panic/'

lst = '/media/katie/storage/PanicPTSD/data/PanicSubjListPHI.csv'

lst = open(lst)

affpaths = [os.path.join(src1, 'PTSD', 'Affect'), os.path.join(src1, 'Panic', 'Affect'),
            os.path.join(src2, 'PTSD', 'AFFECT'), os.path.join(src2, 'panic', 'affect')]

simpaths = [os.path.join(src1, 'PTSD', 'Rapid Simon'), os.path.join(src1, 'Panic', 'Rapid Simon'),
            os.path.join(src2, 'PTSD', 'RAPID SIMON'), os.path.join(src2, 'panic', 'rapid simon')]


def copy_and_rename(sub, exam, time):
    simfound = False
    afffound = False
    #affect    
    for d in affpaths:
        if afffound != True:
            for f in os.listdir(d):
                if exam in f[8:]:
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
                if exam in f[8:]:
                    srcdir = os.path.join(d, f)
                    newname = exam + "-Simon"
                    destdir = os.path.join(dst, sub, 'behavioral/simon/', time, newname)
                    shutil.copytree(srcdir, destdir)
                    print newname
                    simfound = True
                
                
exam1 = 'zzzzz'
exam2 = 'zzzzz'
exam3 = 'zzzzz'

for subj in csv.DictReader(lst, dialect='excel', delimiter='\t'):
    print subj
    subj_id = subj['Study No.'] + '-' + subj['PPID']
    if subj['Study No.'] == '1029' or subj['Study No.'] == '1010':
        os.mkdir(dst + subj_id)
        os.mkdir(os.path.join(dst, subj_id, 'behavioral'))
        os.mkdir(os.path.join(dst, subj_id, 'behavioral/affect/'))
        os.mkdir(os.path.join(dst, subj_id, 'behavioral/simon/'))
        if subj['Exam 1']:
            exam1 = subj['Exam 1']
            copy_and_rename(subj_id, exam1, 'Time1')
        if subj['Exam 2']:
            exam2 = subj['Exam 2']
            copy_and_rename(subj_id, exam2, 'Time2')
        if subj['Exam 3']:
            exam3 = subj['Exam 3']
            copy_and_rename(subj_id, exam3, 'Time3')
        if subj['Exam 4']:
            exam3 = subj['Exam 4']
            copy_and_rename(subj_id, exam3, 'Time4')
            
      
            
                 
            
                 
                     
             
        
                 
                 
            
    
        
        
        



