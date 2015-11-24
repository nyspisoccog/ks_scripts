import csv, os, shutil

lst = '/media/katie/SocCog/SocCogSubInfo.csv'

root = '/media/katie/SocCog/newPreProc/'

lst = open(lst)

subj_dict = {}

for subj in csv.DictReader(lst, dialect='excel', delimiter=','):
    subj_id = subj['Subject_Code']
    exams = [subj[ex] for ex in ['Exam1', 'Exam2', 'Exam3', 'Exam4'] if subj[ex]]
    subj_dict[subj_id] = exams

for path1 in os.listdir(root):
    path2 = os.path.join(root, path1)
    for rt, files, dirs in os.walk(path2):
        if "spgr" in rt or "SPGR" in rt:
            dest = os.path.join(root, path1, 'anat')
            if os.path.isdir(dest):
                shutil.rmtree(dest)
            print "rt", rt
            print "dest", dest
            shutil.copytree(rt, dest)
        if "M" in rt or "L" in rt:
            dest = os.path.join(root, path1, 'func')
            if os.path.isdir(dest):
                shutil.rmtree(dest)
            print "rt", rt
            print "dest", dest
            shutil.copytree(rt, dest)
        


