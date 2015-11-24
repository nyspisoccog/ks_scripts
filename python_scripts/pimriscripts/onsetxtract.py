__author__ = 'katie'

import os, csv

root = '/media/truecrypt1/SocCog/SocCog/tmp'

f = open(os.path.join(root, 'ks-trialsdata.csv'), 'r')
last_run = ''
last_cond = ''

for line in csv.DictReader(f, dialect='excel', delimiter='\t'):
    subject = line['subject']
    run = line['run']
    subrun = subject + run
    fullcond = line['fullcond']
    if subrun != last_run and last_run != '':
        out = open(os.path.join(root, last_run, ), 'w')
        out.write('\n'.join(onset_list))
        out.close()
    if subrun != last_run:
        cond_list = []
        onset_list = []
        last_run = subrun
    onset_list.append(line['BP'])




