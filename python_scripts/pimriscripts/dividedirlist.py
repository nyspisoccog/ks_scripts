__author__ = 'katie'


root = '/media/katie/SocCog/'

f = open('/media/katie/SocCog/dirlist.txt', 'r')

j = 0
k = 0


filestr = root + "dirlist" + str(k) + ".txt"
g = open(filestr, 'w+')

for i, line in enumerate(f.readlines()):
    j = j + 1
    if j < 101:
        g.write(line)
    else:
        j = 0
        k = k+1
        filestr = root + "dirlist" + str(k) + ".txt"
        g.close()
        g = open(filestr, 'w+')

g.close()



