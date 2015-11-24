__author__ = 'katie'


f = open('/home/katie/scripts/cln_dcm/sansAnonoutList.txt', 'r')

g = open('/home/katie/scripts/cln_dcm/sansAnonoutList.csv', 'w+')


for line in f.readlines():
    g.write(line.replace(',', '\n'))

g.close()
f.close()