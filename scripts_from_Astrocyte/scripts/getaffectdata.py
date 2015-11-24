import eprime, csv, os

def listpath(root):
    for p in os.listdir(root):
        yield os.path.join(root, p)

root='/media/katie/storage/PanicPTSD/working_data/'

si_hed_lst = ['Experiment', 'Subject', 'Sex', 'Handedness',  'Session', 'SessionDate', 'SessionTime', 'RandomSeed', 'Display.RefreshRate',\
              'Group', 'TextDisplay4.ACC', 'TextDisplay4.CRESP', 'TextDisplay4.DurationError', 'TextDisplay4.OnsetDelay',\
              'TextDisplay4.OnsetTime', 'TextDisplay4.RESP', 'TextDisplay4.RT', 'TextDisplay4.RTTime', 'Block', 'Face',\
              'FaceSlide.ActionDelay', 'FaceSlide.ActionTime', 'FaceSlide.CustomOffsetTime', 'FaceSlide.CustomOnsetTime',\
              'FaceSlide.Duration', 'FaceSlide.DurationError', 'FaceSlide.FinishTime', 'FaceSlide.OffsetDelay', 'FaceSlide.OffsetTime',\
              'FaceSlide.OnsetDelay', 'FaceSlide.OnsetTime', 'FaceSlide.PreRelease', 'FaceSlide.RESP', 'FaceSlide.RT',\
              'FaceSlide.RTTime', 'FaceSlide.StartTime', 'FaceSlide.TargetOffsetTime', 'FaceSlide.TargetOnsetTime', 'FaceSlide.TimingMode',\
              'Fixation.ActionDelay', 'Fixation.ActionTime', 'Fixation.CustomOffsetTime', 'Fixation.CustomOnsetTime', 'Fixation.Duration',\
              'Fixation.DurationError', 'Fixation.FinishTime', 'Fixation.OffsetDelay', 'Fixation.OffsetTime', 'Fixation.OnsetDelay',\
              'Fixation.OnsetTime', 'Fixation.PreRelease', 'Fixation.RESP', 'Fixation.RT', 'Fixation.RTTime', 'Fixation.StartTime',\
              'Fixation.TargetOffsetTime', 'Fixation.TargetOnsetTime', 'Fixation.TimingMode', 'FixDur', 'List1', 'List1.Cycle', 'List1.Sample',\
              'MouseMovementTime', 'Procedure', 'ResponseClicked', 'Running', 'Stimulus.ActionDelay', 'Stimulus.ActionTime',\
              'Stimulus.CustomOffsetTime', 'Stimulus.CustomOnsetTime', 'Stimulus.Duration', 'Stimulus.DurationError', 'Stimulus.FinishTime',\
              'Stimulus.OffsetDelayStimulus.OffsetTimeStimulus.OnsetDelay', 'Stimulus.OnsetTime', 'Stimulus.PreRelease', 'Stimulus.RESP',\
              'Stimulus.RT', 'Stimulus.RTTime', 'Stimulus.StartTime', 'Stimulus.TargetOffsetTime', 'Stimulus.TargetOnsetTime',\
              'Stimulus.TimingMode']

behave_list = []
simon_list = []
affect_list = []

for p1 in listpath(root):
    for p2 in listpath(p1):
        for p3 in listpath(p2):
            if 'behavioral' in p3:
                behave_list.append(p3)
                
for p in behave_list:
    for rt, dirs, files in os.walk(p):
        for f in files:
            if 'Simon' in f and 'txt' in f and 'log' not in f:
                simon_list.append(os.path.join(rt, f))
            if 'Face' in f and 'txt' in f and 'log' not in f:
                affect_list.append(os.path.join(rt, f))

for txt_file in affect_list:
    data = eprime.LogData(txt_file)
    if len(data.blocks) > 1:
        for block in data.blocks:
            for k, v in data.header.items():
                block[k] = v
            for k, v in data.blocks[-1].items():
                block[k] = v
            
             
    outfile = txt_file[:-3] + 'csv'
    with open(outfile,'wb') as fou:
        w = csv.writer(fou, delimiter='\t', dialect='excel')
        w.writerow(si_hed_lst)
        for block in data.blocks:
            row = []
            for col in si_hed_lst:
                if col in block.keys():
                    row.append(block[col])
                else:
                    row.append('')
            w.writerow(row)
