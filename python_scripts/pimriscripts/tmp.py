__author__ = 'katie'

import os, shutil

exams = ['4319', '4367', '4434', '4477', '4585', '4591', '4657', '4696', '4838', '4868', '4940', '4966', '4989', '5146', '5189', '5277', '5276',\
        '5336', '5538', '5598', '5707', '5918', '6015', '6142', '6462', '6708', '6790', '6814', '6894', '6898', '7003', '7082', '7166', '5870',\
        '5981', '4891', '4628', '4688', '5763', '4949', '5599', '5439', '5368', '5425', '5543', '5807', '6421', '6439', '7085', '7195', '7267',\
        '7363', '7836', '6376', '5931', '5929']



srcroot = '/media/truecrypt2/PanicPTSD/raw_data/raw_data'
dstroot = '/media/truecrypt2/PanicPTSD/forJohn'

for exam in exams:
    src = os.path.join(srcroot, exam)
    dst = os.path.join(dstroot, exam)
    print src
    print dst
    print '\n'
    try:
        shutil.copytree(src, dst)
    except:
        print exam, " not found!"