import os, csv, shutil, uf

root = '/media/truecrypt1/SocCog/working_data'

source = '/media/katie/SocCog/SocCog_Raw_Data_By_Exam_Number'

lst = '/media/katie/SocCog/SocCogSubInfo.csv'

lst = open(lst)

subj_dict = {}


for subj in csv.DictReader(lst, dialect='excel', delimiter=','):
    print subj
    subj_id = subj['Subject_Code']
    exams = [subj[ex] for ex in ['Exam1', 'Exam2', 'Exam3', 'Exam4'] if subj[ex]]
    subj_dict[subj_id] = exams
    os.mkdir(os.path.join(subj_id))
    anat_dir = os.path.join(root, subj_id, 'anat')
    func_dir = os.path.join(root, subj_id, 'func')
    os.mkdir(anat_dir)
    os.mkdir(func_dir)
    for exam in exams:
        exam_dir = os.path.join(source, exam)
        for rt, dirs, files in os.walk(exam_dir):
            for d in dirs:
                for str in ["spgr", "SPGR", '_166_', '_160_', '_164', 'f166']:
                    if str in d or str in root:
                        src_dir = os.path.join(rt, d)
                        dest_dir = os.path.join(anat_dir, d)
                        shutil.copytree(src_dir, dest_dir)
                        path_list = uf.splitall(src_dir)
                        ind = path_list.find('SocCog_Raw_Data_By_Exam_Number')
                        exam = path_list(ind + 1)
                        ex_dir = path_list(ind + 2)
                        with open(os.path.join(dest_dir, exam + 'txt')) as recfile:
                            recfile.write(''.join([exam, '\n', ex_dir]))
                        with open('/media/katie/SocCog/working_data/copyrec1.txt', 'a+') as copyrec:
                            copyrec.write(''.join(["d", d, '\n', "src", src_dir, '\n', "dest", dest_dir]))
                for str in ['M', 'L', '_1904', '_1960', '_5610', 'f5610', 'f1903', '_1848', '_5455', '_4522', '_2234', '_3374'\
                    '_5236', '_442', '_2550', '_6528', '_3094']:
                    if str in d:
                        src_dir = os.path.join(rt, d)
                        dest_dir = os.path.join(func_dir, d)
                        shutil.copytree(src_dir, dest_dir)
                        with open(os.path.join(root, 'copyrec1.txt', 'a+')) as copyrec:
                            copyrec.write(''.join(["d", d, '\n', "src", src_dir, '\n', "dest", dest_dir]))

uf.done(root, "SocCogMasterSort.py, program to sort ")


