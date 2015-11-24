import eprime, csv, os

def listpath(root):
    for p in os.listdir(root):
        yield os.path.join(root, p)

root='/media/katie/storage/PanicPTSD/working_data/'

si_hed_lst = ['Experiment', 'Subject', 'Session', 'Display.RefreshRate', 'Group', 'RandomSeed', 'SessionDate', 'SessionTime',\
    'SignaWarmingUp.Duration', 'SignaWarmingUp.FinishTime', 'SignaWarmingUp.OnsetTime', 'WaitForSigna.Duration',\
    'WaitForSigna.FinishTime', 'WaitForSigna.OnsetTime', 'Block', 'BlockList', 'BlockList.Cycle', 'BlockList.Sample',\
    'Procedure[Block]', 'Running[Block]', 'TrialList', 'Blank', 'CongruentListLeft', 'CongruentListRight', 'CorrectAnswer',\
    'Fixation.Duration', 'Fixation.FinishTime', 'Fixation.OnsetTime', 'IncongruentListLeft', 'IncongruentListRight',\
    'NewFixOnsetTime', 'NewStimOnsetTime', 'Procedure[Trial]', 'Running[Trial]', 'StateName', 'Stimulus.ACC',\
    'Stimulus.CRESP', 'Stimulus.Duration', 'Stimulus.DurationError', 'Stimulus.FinishTime', 'Stimulus.OnsetDelay',\
    'Stimulus.OnsetTime', 'Stimulus.RESP', 'Stimulus.RT', 'Stimulus.RTTime', 'Target', 'TrialList', 'TrialList.Cycle',\
    'TrialList.Sample']

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
            if 'Affect' in f and 'txt' in f and 'log' not in f:
                affect_list.append(os.path.join(rt, f))

for txt_file in simon_list:
    data = eprime.LogData(txt_file)
    if len(data.blocks) > 1:
        for block in data.blocks:
            for k, v in block.items():
                if k == 'Procedure' and v[0] == 'T':
                    block['Procedure[Trial]'] = v
                if k == 'Running' and v[0] == 'T':
                    block['Running[Trial]'] = v
            for k, v in data.header.items():
                block[k] = v
            for k, v in data.blocks[-1].items():
                block[k] = v
            for k, v in data.blocks[-2].items():
                if k == 'Procedure' and v[0] == 'B':
                    block['Procedure[Block]'] = v
                if k == 'Running' and v[0] == 'B':
                    block['Running[Block]'] = v 
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
