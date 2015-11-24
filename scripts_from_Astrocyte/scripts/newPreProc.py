import os, shutil, csv, tarfile, distutils.core, tarfile

root = "/media/katie/SocCog/"

key = open("/media/katie/SocCog/subj-exam-matching.csv")

#os.mkdir(root + "newPreProc")


exam_dict = {}

for subj in csv.reader(key, dialect='excel'):
    print subj
    if subj[0][0] == '7':
        exam_dict[subj[0]] = []
        for ex in subj[1:]:
            if ex != '': exam_dict[subj[0]].append(ex)

print exam_dict

##for k, v in exam_dict.iteritems():
##    dst = root + "newPreProc/" + k
##    os.mkdir(dst)
##    os.mkdir(dst + "/anat")
##    os.mkdir(dst + "/func")
##    for exam in v:
##        if len(exam) > 0:
##            src = root + "SocCog_Raw_Data_By_Exam_Number/" + exam
##            dst = root + "newPreProc/" + k
##            print src
##            print dst
##            try: 
##                distutils.dir_util.copy_tree(src, dst)
##            except:
##                print k, " ", exam, " is probably not a source directory; not copied"
            
##
##for rt, dirname, files in os.walk(root + "newPreProc/"):
####    if 'M' in rt or 'L' in rt:
##    if '5610' in rt or '1904' in rt:
##        if 'M' not in rt and 'L' not in rt:
##            print rt
##            for file1 in files:
##                if 'tar.gz' in file1:
##                    print file1
##                    tar = tarfile.open(os.path.join(rt, file1), 'r')
##                    tar.extractall(rt)
            
        
        
##for rt, dirnames, files in os.walk(root + "newPreProc/"):
##    for f in files:
##        if 'MRDC' in f and 'tar' not in f and 'dcm' not in f:
##            os.rename(rt + '/' + f, rt + '/' + f + '.dcm')

##drtxt = open(root + 'dirlist.txt', 'w')
##
##for rt, dirnames, files in os.walk(root + "newPreProc/"):
##    for f in files:
##        if 'MRDC' in f and 'tar' not in f:
##            i = rt.find('newPreProc')
##            subj = rt[i + 11: i + 15]
##            drtxt.write(subj + ',' + rt + '\n')
##            break
##    





