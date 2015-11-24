import  csv, os, shutil

root = '/media/katie/SocCog/working_data/'

with open('/media/katie/SocCog/working_data/copyrec1.txt', 'a+') as copyrec:

subj_dict = {}

done = ['7533', '7403', '7404', '7408', '7412',' 7414', '7418', '7430',
        '7432', '7436', ]

for path1 in os.listdir(root):
    if path1 not in done:    
        path2 = os.path.join(root, path1)
        for rt, dirs, files in os.walk(path2):
            if "func" not in rt and "anat" not in rt:
                for d in dirs:
                    if "spgr" in d or "SPGR" in d or '166' in d:
                        dest = os.path.join(root, path1, 'anat', d)
                        if os.path.isdir(dest):
                            shutil.rmtree(dest)
                        src = os.path.join(rt, d)
                        print "d", d, '\n', "src", src, '\n', "dest", dest
                        with open('/media/katie/SocCog/working_data/copyrec1.txt', 'a+') as copyrec:
                            copyrec.write(''.join(["d", d, '\n', "src", src, '\n', "dest", dest]))
                        shutil.copytree(src, dest)
                    if "M" in d or "L" in d or '1904' in d or '1960' in d or '5610' in d:
                        dest = os.path.join(root, path1, 'func', d)
                        if os.path.isdir(dest):
                            shutil.rmtree(dest)
                        src = os.path.join(rt, d)
                        print "d", d, '\n', "src", src, '\n', "dest", dest
                        with open('/media/katie/SocCog/working_data/copyrec1.txt', 'a+') as copyrec:
                            copyrec.write(''.join(["d", d, '\n', "src", src, '\n', "dest", dest]))
                        shutil.copytree(src, dest)
        
                
        


