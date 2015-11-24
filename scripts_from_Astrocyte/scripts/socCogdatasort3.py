import  csv, os, shutil

root = '/media/katie/SocCog/working_data/'

source = '/media/katie/SocCog/SocCog_Raw_Data_By_Exam_Number'

lst = '/media/katie/SocCog/SocCogSubInfo.csv'

lst = open(lst)

subj_dict = {}

for subj in csv.DictReader(lst, dialect='excel', delimiter=','):
    print subj
    subj_id = subj['Subject_Code']
    exams = [subj[ex] for ex in ['Exam1', 'Exam2', 'Exam3', 'Exam4'] if subj[ex]]
    subj_dict[subj_id] = exams

for k, v in subj_dict.items():
    os.mkdir(os.path.join(root, k))
    anat_dir = os.path.join(root, k, 'anat')
    func_dir = os.path.join(root, k, 'func')
    os.mkdir(anat_dir)
    os.mkdir(func_dir)    
    for exam in v:
        exam_dir = os.path.join(source, exam)
        for rt, dirs, files in os.walk(exam_dir):
            for d in dirs:
                if "spgr" in d or "SPGR" in d or '166' in d:
                    src_dir = os.path.join(rt, d)
                    dest_dir = os.path.join(anat_dir, d)
                    shutil.copytree(src_dir, dest_dir)
                    with open('/media/katie/SocCog/working_data/copyrec1.txt', 'a+') as copyrec:
                        copyrec.write(''.join(["d", d, '\n', "src", src_dir, '\n', "dest", dest_dir]))
                if "M" in d or "L" in d or '1904' in d or '1960' in d or '5610' in d:
                    src_dir = os.path.join(rt, d)
                    dest_dir = os.path.join(func_dir, d)
                    shutil.copytree(src_dir, dest_dir)
                    with open('/media/katie/SocCog/working_data/copyrec1.txt', 'a+') as copyrec:
                        copyrec.write(''.join(["d", d, '\n', "src", src_dir, '\n', "dest", dest_dir]))

                    
                    

    
                
        


