import os, csv

controlinfo = open('/media/katie/storage/PanicPTSD/data/control_raw_data/controlinfo.txt', 'r')

exam_list = []

for exam in csv.DictReader(controlinfo):
    filename = exam['Filename']
    exam_ind = filename.find('raw_data') + 9
    exam_name = filename[exam_ind:exam_ind + 4]
    exam['exam'] = exam_name

    byear = exam['DOB'][0:4] 
    bmonth = exam['DOB'][4:6] 
    bday = exam['DOB'][6:8] 

    exam['DOB'] = bmonth + '/' + bday + '/' + byear

    syear = exam['StudyDate'][0:4] 
    smonth = exam['StudyDate'][4:6] 
    sday = exam['StudyDate'][6:8]

    age = exam['Age'][1:3]

    exam['StudyDate'] = smonth + '/' + sday + '/' + syear

    exam['Age'] = age

    exam_list.append(exam)
    


with open('/media/katie/storage/PanicPTSD/data/control_raw_data/controlinfo.csv', 'wb') as csvfile:
    writer = csv.writer(csvfile, delimiter=',')
    writer.writerow([s.encode("ascii") for s in ['OldPPID', 'Sex', 'DOB', 'exam', 'StudyDate', 'Age']])
    for exam in exam_list:
        print exam
        writer.writerow([s.encode("ascii") for s in [exam['OldPPID'], exam['Sex'],  exam['DOB'], exam['exam'], exam['StudyDate'], exam['Age']]])


    
