import re, mechanize, csv
from bs4 import BeautifulSoup

class Subject(object):
    def __init__(self, PPID=None):
        self.PPID = PPID
        self.exams = []      

class Exam(object):
    def __init__(self, PPID=None, number = None, date=None, study=None, unit=None,RA=None, num_series = None, notes=None):
        self.PPID = PPID
        self.number = number
        self.date = date
        self.study = study
        self.unit = unit
        self.RA = RA
        self.num_series = num_series
        self.notes = notes
        self.marker = None
        self.logbook = None
        self.series =[]
        self.series_run = None

class Series(object):
    def __init__(self, number=None, series_type=None, qual=None, comments2=None, post_qual = None,\
                 post_check_by=None, post_check_date=None):
        self.number = number; series_type = series_type; self.qual = qual; self.comments2 = comments2; self.post_qual = post_qual; 
        self.post_check_by = post_check_by; self.post_check_date = post_check_date
        self.study = None; self.s_type = None; self.psd_name = None; self.slice_orientation = None; self.acq_direction = None;
        self.head_coil = None; self.TR = None; self.TE = None; self.matrix_X = None; self.matrix_Y = None; self.FOV_x = None;
        self.FOV_y = None; self.nex = None; self.spacing = None; self.thickness = None; self.time = None; self.slices = None;
        self.num_volumes = None; self.dummy_scans = None; self.total_num_slices = None; self.flip_angle = None; self.RBW = None;
        self.PFOV = None; self.TI = None; self.voxel_x = None; self.voxel_y = None; self.voxel_z = None; self.plane_res_x = None;
        self.plane_res_y = None; self.SAR_est = None; self.b_value = None; self.SAR_peak = None; self.frequency = None;
        self.echo = None; self.num_echoes = None; self.directions = None; self.baseline = None; self.fmri_type = None
        self.scanning_options = None; self.comments2 = None
            
def sub_init(PPID=None):
    s = Subject(PPID=PPID)
    return s

def exam_init(PPID=None, number = None, date=None, study=None, unit=None,RA=None, num_series = None, notes=None):
    e = Exam(PPID=PPID, number = number, date=date, study=study, unit=unit, RA=RA,num_series = num_series, notes=notes)
    return e

def series_init(number=None, series_type=None, qual=None, comments2=None, post_qual = None,post_check_by=None, post_check_date=None):
    s = Series(number=number, series_type=series_type, qual=qual, comments2=comments2, post_qual = post_qual,\
               post_check_by=post_check_by, post_check_date=post_check_date)
    return s

#login = raw_input("login: ")
#pw = raw_input("password: ")

login = "surrenc"
pw = "2std.dev"

##in_list = raw_input("Please enter a path to the input list:")
##list_type = raw_input("Is this a list of exams or PPIDs. Type E or P:")
##out_list = raw_input("Please enter a path where you would like the output to be saved:")

##print "Do you want to write a new file, overwrite an existing file, or append to an existing file?"
##print "Note: if file does not exist new file will be created regardless of your choice."
##mode = raw_input("Type N, O or A:")

br = mechanize.Browser()
subjects = []
#exam_list = ['5927', '4319']

#PTSD examlist:
#exam_list = ['4319','4367','4434','4477','4585','4591','4657','4696','4838','4868','4940','4966','4989','5146','5189','5277','5276','5336','5538',
#             '5598','5707','5918','6015','6142','6462','6708','6790','6814','6894','6898','7003','7082','7166','5870','5981']

#Control exam_list:

##exam_list =['3817', '1918', '2071', '2356', '2369', '2452', '2571', '2599', '3511', '3522', '3655', '5630', '5637', '5655',
##            '5682', '5783', '5834', '5873', '5874', '5877', '5903', '5943', '5946', '5974', '5999', '6043', '6068', '6087', '3964',
##            '4070', '4406', '4973', '5148', '5197', '5314', '5316', '5422', '5507', '5578', '5580', '6144', '6146', '6156', '6170', '6185',
##            '6247', '6288', '6290', '5153', '5261', '5461', '5662', '5675', '5746', '6232', '6660', '6928', '7355', '7434', '7468', '7484',
##            '7899', '7974', '7975', '7996', '8031', '8124', '8271']

#soc cog exam_list:

##exam_list =['1570', '1710', '1714', '1845', '1858', '1849', '1853', '3575', '2480',\
##            '2472', '2492', '2474', '2434', '2530', '2539', '2489', '2693', '2592',\
##            '2590', '2662', '2679', '2728', '2727', '2849', '2750', '2880', '3184',\
##            '2961', '3380', '2908', '3222', '3140', '3743', '3308', '3078', '3310',\
##            '3685', '3240', '3189', '3449', '3274']

#Mihaela exam list:

exam_list=['4623', '4795', '4798', '3789', '3930', '3947', '4014', '4112', '4228', '4460',\
           '4462', '4495', '4504', '4607', '3755', '5357', '5220', '5588', '5680', '5996',\
           '6366', '6377', '6535', '6718', '6768', '6811', '6948', '7544', '4389', '3662'\
           '4681', '6928', '6995', '7185', '7355', '7434', '7468', '7572', '7619', '7657',\
           '7667', '7698', '7693', '7742', '7769', '7817', '7851', '7874', '7899', '7947',\
           '7952', '7975', '7981', '7996', '8031', '8040', '8065', '8082', '8107', '8124',\
           '8176', '8269', '8271', '8276', '8303', '5740']

PPID_count = -1

br.open("http://192.168.71.65/new_tracking/")
br.select_form(name="logon_form")
br["login"] = login
br["password"] = pw
response1 = br.submit()
br.select_form(nr=0)
response2 = br.submit()
br.select_form(nr=3)
response3 = br.submit()

for exam_num in exam_list:
    br.select_form(name="scan_search")
    br["exam_num"] = exam_num
    response4 = br.submit()
    page4 = response4.read()
    exam_ind = page4.rfind(exam_num)
    PPID = page4[exam_ind - 16: exam_ind-10]
    PPID_bool = False
    for sub in subjects:
        if sub.PPID == PPID:
            PPID_bool = True
    if PPID_bool == True:
        br.back()
        continue
    if PPID != '.exam_':
        s = sub_init(PPID)
        subjects.append(s)
    br.back()

br.back()
br.select_form(nr=2)
response5 = br.submit()

for sub in subjects:
    br.select_form(name="subject_search")
    br["subjectID"] = sub.PPID
    response6 = br.submit()
    page6 = response6.read()
    br.select_form(nr=0)
    response7 = br.submit()
    br.select_form(nr=2)
    response8 = br.submit()
    page8 = response8.read()
    soup8 = BeautifulSoup(page8)
    for tags in soup8.find_all('tr'):
        tag_list = []
        [tag_list.append(t) for t in tags.find_all('td')[1:]]
        if len(tag_list) > 1:
            text = [tag.get_text() for tag in tag_list]
            ascii_tags = [tag.encode('ascii', 'ignore') for tag in text]
            print ascii_tags
            e = exam_init(PPID=sub.PPID, number=ascii_tags[0], date=ascii_tags[1], study=ascii_tags[2],\
                unit=ascii_tags[3], RA=ascii_tags[4], num_series=ascii_tags[5], notes=ascii_tags[9])
            sub.exams.append(e)
    for i in range(len(sub.exams)):
        exam = sub.exams[i]
        br.select_form(nr=i)
        response9 = br.submit()
        page9 = response9.read()
        soup9 = BeautifulSoup(page9)
        tag_list = []
        for tags in soup9.find_all(['tr']):
            tag_list.append([tag.get_text() for tag in tags.find_all(['td', 'th', 'tr', 'td colspan=6'])])
        for tags in tag_list:
            for t in tags:
                t = unicode(t)
        stop = False
        for j, tags in enumerate(tag_list):
            for k, t in enumerate(tags):
                if 'Vitamin Marker:' in t: sub.exams[i].marker = tags[k+1]
                if 'Scan logbook:' in t: sub.exams[i].logbook = tags[k+1]
                if 'Scan logbook page(s):' in t: sub.exams[i].pages = tags[k+1]
                if 'Series #' in t:
                    stop = True
                    index = j + 1
                    break
            if stop == True: break
        for j, tags in enumerate(tag_list[index:index + int(exam.num_series)]):
            ascii_tags = [tag.encode('ascii', 'ignore') for tag in tags]
            s = series_init(number=ascii_tags[0], series_type=ascii_tags[1], qual=ascii_tags[2], comments2=ascii_tags[3], post_qual = ascii_tags[4],\
                            post_check_by=ascii_tags[5], post_check_date=ascii_tags[6])
            exam.series.append(s)
        counter = -1
        for tags in tag_list:
            for l, t in enumerate(tags):
                if t.replace(' ', '') == 'study': counter += 1
                var_list = ['study', 'series_type','psd_name','slice_orientation','acq_direction','head_coil','TR','TE','matrix_X',\
                            'matrix_Y','nex', 'spacing','FOV_x','FOV_y','thickness','time', 'num_volumes','dummy_scans','total_num_slices',\
                            'total_num_slices','flip_angle','RBW','PFOV', 'TI','voxel_x','voxel_y','voxel_z','plane_res_x','plane_res_y',\
                            'SAR_est','b_value', 'SAR_peak', 'frequency', 'echo','num_echoes','directions','baseline','fmri_type','scanning_options',\
                            'comments']
                for string in var_list:
                    if string == t.replace(' ', '_'):
                        new_string = tags[l+1].replace(';','')
                        new_string = new_string.replace(',','')
                        setattr(exam.series[counter], string, new_string) 
            if counter == int(exam.num_series): break
        series_run = ''
        for series in exam.series:
            series_run = '\n'.join([series_run, series.series_type])
        exam.series_run = series_run    
        br.back()
    br.back()
    br.back() 
    br.back()

with open('/home/katie/Mihaela_Scan_Record.csv', 'wb+') as csvfile:
    writer = csv.writer(csvfile, delimiter=',')
    writer.writerow(['PPID', 'Exam', 'Date', 'Study','Series_Run', 'Notes', 'Marker', 'Logbook', 'Logbook_Pages'])
    for sub in subjects:
        for exam in sub.exams: 
            writer.writerow([sub.PPID, exam.number, exam.date, exam.study, exam.series_run, exam.notes, exam.marker, exam.logbook, exam.pages])

with open('/home/katie/Mihaela_Scan_Details.csv', 'wb+') as csvfile:
    writer = csv.writer(csvfile, delimiter=',')
    writer.writerow(['PPID', 'Study', 'Exam', 'Series_Number', 'Series_Type', 'PSD_Name', 'Slice_Orientation', 'Acquisition_Direction', \
                     'Head_Coil', 'TR', 'TE', 'Matrix_X', 'Matrix_Y', 'FOV_X', 'FOV_Y', 'Nex', 'Spacing', 'Thickness', 'Time',\
                     'Slices', 'Num_Volumes', 'Dummy_Scans', 'Total_Num_Slices', 'Flip_Angle', 'RBW', 'PFOV', 'TI', 'Voxel_X',\
                     'Voxel_Y', 'Voxel_Z', 'Plane_Res_X', 'Plane_Res_Y', 'SAR_est', 'B_Value', 'SAR_peak', 'Frequency', 'Echo',\
                     'Num_Echoes', 'Directions', 'Baseline', 'FMRI_Type', 'Scanning_Options', 'Comments1', 'Series_Quality_at_Scan', 'Comments2',\
                     'Post_Check_Quality', 'Post_Scan_Check_By', 'Post_Scan_Check_Date'])
    for sub in subjects:
        for exam in sub.exams:
            for series in exam.series:
                writer.writerow([sub.PPID, series.study, exam.number, series.number, series.series_type, series.psd_name, series.slice_orientation,\
                                 series.acq_direction, series.head_coil, series.TR, series.TE, series.matrix_X, series.matrix_Y,\
                                 series.FOV_x, series.FOV_y, series.nex, series.spacing, series.thickness, series.time, series.slices,\
                                 series.num_volumes, series.dummy_scans, series.total_num_slices, series.flip_angle, series.RBW,\
                                 series.PFOV, series.TI, series.voxel_x, series.voxel_y, series.voxel_z, series.plane_res_x,\
                                 series.plane_res_y , series.SAR_est, series.b_value, series.SAR_peak, series.frequency,
                                 series.echo, series.num_echoes, series.directions, series.baseline, series.fmri_type, series.scanning_options,\
                                 series.comments, series.qual, series.comments2,  series.post_qual,  series.post_check_by,  series.post_check_date])
