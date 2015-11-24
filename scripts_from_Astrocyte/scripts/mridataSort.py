import os, shutil, csv

src = '/media/katie/storage/PanicPTSD/data/raw_data'

dst = '/media/katie/storage/PanicPTSD/data-neworg/Panic/'

lst = '/media/katie/storage/PanicPTSD/data/PanicSubjListPHI.csv'

lst = open(lst)

def copy_and_rename(sub, exam, time):     
    for folder in os.listdir(src):
        if folder == exam:
            for root, dirs, files in os.walk(src + "/" + folder):
                print dirs
                anatcount = 0
                simoncount = 0
                affectcount = 0
                for d in dirs:
                    if 'spgr' in d or 'SPGR' in d:
                        anatcount += 1
                        print anatcount
                        print "anat ", d
                        newname = exam + "-Anat-" + str(anatcount)
                        srcdir = os.path.join(root, d)
                        dstdir = os.path.join(dst, sub, 'anatomical', time, newname)
                        shutil.copytree(srcdir, dstdir)
                        recstring = os.path.join(dstdir, newname + '-record.txt')
                        record = open(recstring, 'w')
                        record.write(srcdir)
                    if 'simon' in d or 'SIMON' in d or 'rapid' in d or 'RAPID' in d:
                        simoncount += 1
                        print "simon ", d
                        newname = exam + "-Simon-" + str(simoncount)
                        srcdir = os.path.join(root, d)
                        dstdir = os.path.join(dst, sub, 'functional/simon/', time, newname)
                        shutil.copytree(srcdir, dstdir)
                        recstring = os.path.join(dstdir, newname + '-record.txt')
                        record = open(recstring, 'w')
                        record.write(srcdir)
                    if 'affect' in d or 'AFFECT' in d:
                        affectcount += 1
                        print "affect ", d
                        newname = exam + "-Affect-" + str(affectcount)
                        srcdir = os.path.join(root, d)
                        dstdir = os.path.join(dst, sub, 'functional/affect/', time, newname)
                        shutil.copytree(srcdir, dstdir)
                        recstring = os.path.join(dstdir, newname + '-record.txt')
                        record = open(recstring, 'w')
                        record.write(srcdir)

def makedir(dirlist):
    newpath = ''
    newdir = ''
    for d in dirlist:
        newpath = os.path.join(newpath, d)
    for d in dirlist[0:-1]:
        newdir = os.path.join(newdir, d)
    endpath = dirlist[-1]
    if endpath in os.listdir(newdir):
        pass
    else:
        os.mkdir(newpath)
    
                
                
exam1 = 'zzzzz'
exam2 = 'zzzzz'
exam3 = 'zzzzz'
exam4 = 'zzzzz'

for subj in csv.DictReader(lst, dialect='excel', delimiter='\t'):
    keys = [key for key in subj.keys()]
    print keys
    if subj['Study No.'] == '1010' or subj['Study No.'] == '1029':
        subj_id = subj['Study No.'] + '-' + subj['PPID']
        makedir([dst, subj_id])
        makedir([dst, subj_id, 'anatomical'])
        makedir([dst, subj_id, 'functional'])
        makedir([dst, subj_id, 'functional', 'affect'])
        makedir([dst, subj_id, 'functional', 'simon'])
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
        
      
            
                 
            
                 
                     
             
        
                 
                 
            
    
        
        
        



