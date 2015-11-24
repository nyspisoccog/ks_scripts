import os, shutil

root = '/media/katie/SocCog/7561_2M6_s16/MRDC_files/'
dest = '/media/katie/SocCog/7561_2M6_s16/Analyze_Files/'

for f in os.listdir(root):
    print f
    if 'MRDC' in f and os.path.isdir(f) == False:
        shutil.move(root + f, dest)



##activesubs = []
##
##
##
##for f in os.listdir(dest):
##    activesubs.append(f)
##
##print activesubs
##
##for f in os.listdir(root):
##    if f[-3:] == 'prt':
##        prtfile = os.path.basename(f)
##        sub = os.path.basename(f)[0:4]
##        if sub in activesubs:
##            dst = dest + sub
##            print root + f
##            print dst
##            if os.path.exists(dst + '/' + prtfile):
##                os.remove(dst + '/' + prtfile)
##            shutil.move(root + f, dst)
##
##
