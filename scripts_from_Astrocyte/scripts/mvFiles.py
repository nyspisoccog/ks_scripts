import os, shutil

root = "/media/katie/SocCog/SocCog_Raw_Data_By_Exam_Number/2480/e1331017/s1334845_1904_1L3_s6/MRDC_files/SPMfiles/"

filelist = []

for f in os.listdir(root):
    if f[-3:] == 'img' or f[-3:] == 'hdr':
        filelist.append(f)

for f in filelist:   
    shutil.copy(root+ f, '/media/katie/SocCog/SubjectData/7432/functional/orig/1L3/')
