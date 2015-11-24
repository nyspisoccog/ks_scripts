
import csv

PPIDsource = open('/media/katie/storage/PanicPTSD/data-neworg/Controls/Control_Scan_Record.csv', 'r')
examsource = open('/media/katie/storage/PanicPTSD/notesonautismcontrols.csv', 'r')

PPIDsource = csv.reader(PPIDsource, delimiter = '\t', dialect='excel')
examsource = csv.reader(examsource, delimiter = '\t', dialect='excel')

exam_list = []
PPID_list = []


for row in examsource:
    exam_list.append(row)

for row in PPIDsource:
    PPID_list.append(row)

for exam in exam_list:
    exam_number=exam[3]
    for line in PPID_list:
        if line[1] in exam_number:
            print line[0]
    




