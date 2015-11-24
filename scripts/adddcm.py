import os, tarfile

root = '/ifs/scratch/pimri/soccog/7436/func/'

pathlist = []

for f in os.listdir(root):
    path = os.path.join(root, f)
    pathlist.append(path)
    print path

#for path in pathlist:
#    for f in os.listdir(path):
#	if 'tar.gz' in f:
#	    tarpath = os.path.join(path, f)
#	    print tarpath 
#	    tarfile = tarfile.open(tarpath)
#	    tarfile.extractall(path)
	    
#for path in pathlist:
#    for f in os.listdir(path):
#    	if 'MRDC' in f and 'tar' not in f:
#	    oldname = os.path.join(path, f)
#	    newname = oldname + '.dcm'
#	    os.rename(oldname, newname)
#           print oldname
#	    print newname
#           print ' '


for path in pathlist:
    dicompath = os.path.join(path, 'dicoms')
    if not os.path.isdir(dicompath):    
	os.mkdir(os.path.join(path, 'dicoms'))
    for f in os.listdir(path):
        filename = os.path.join(path, f)
	if not os.path.isdir(filename):
	    newname = os.path.join(path, 'dicoms', f)
	    print filename
	    print newname
	    print '  ' 
	    os.rename(filename, newname)


