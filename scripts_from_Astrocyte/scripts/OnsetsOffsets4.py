import utilityFuncs as u


class Subject():
    def __init__(self):
        self.label  = str
        self.run_strings = []
        self.runs = []
        self.sorted_runs = []

class Run():
    def __init__(self):
        self.label = str
        self.cond_strings = []
        self.conds = []
        self.sorted_conds = []
        self.events = []
        self.subtracted_events = []

class Condition():
    def __init__(self):
        self.label = str
        self.start = int
        self.events = []
        self.sorted_events = []
        self.subtracted_events = []
    

root = '/media/katie/SocCog/'

f = open('/media/katie/SocCog/testexport.csv', 'r')

f = u.split_lines(f, '\t')

coldict = {col:i for i, col in enumerate(f[0])}

def getRun(line):
    sess = line[coldict['Session']]
    startup = line[coldict['StartupPoint']]
    if startup != '':
        start = (startup[0], int(startup[1]))
    if line[coldict['ProcedureTarget']] == 'LearningTargetProc':
        phase = 'L'
        target = int(line[coldict['LearningTargetList']])
        if startup != '':
            if phase == start[0]:
                target = str(int(target) + int(start[1]) - 1) 
    elif line[coldict['ProcedureTarget']] == 'MemoryTargetProc':
        phase = 'M'
        target = int(line[coldict['MemoryTargetList']])
        if startup != '':
            if phase == start[0]:
                target = str(int(target) + int(start[1]) - 1)
    else:
        return "", ""
    return "r" + sess + phase + str(target), phase

root = '/media/katie/SocCog/OnsetData/'

subjects_dict = {}

sub_strings = []
subs = []

for line in f[1:]:

    if getRun(line)[0] != '':
    
        sub_string = "s" + line[coldict['Subject']]
        if sub_string not in sub_strings:
            naming_command = ''.join([sub_string, ' = Subject()'])
            exec naming_command
            sub_strings.append(sub_string)
        sub = eval(sub_string)
        sub.label = sub_string[1:]
        if sub not in subs: subs.append(sub)
                                     
        run_string = getRun(line)[0]
        if run_string not in sub.run_strings:
            naming_command = ''.join([sub_string, '.', run_string, ' = Run()'])
            exec naming_command
            sub.run_strings.append(run_string)
        run = eval(sub_string + '.' + run_string)
        run.label = run_string[1:]
        if run not in sub.runs: sub.runs.append(run)

        cond_string = line[coldict['TargetTypeTarget']] + line[coldict['TrialType']]
        if cond_string[-1] == '+':
            cond_string = cond_string[:-1] + 'pos'
        if cond_string[-1] == '-':
            cond_string = cond_string[:-1] + 'neg'
        if cond_string not in run.cond_strings:
            naming_command = ''.join([sub_string, '.', run_string, '.', cond_string, ' = Condition()'])
            exec naming_command
            run.cond_strings.append(cond_string)
        cond = eval(sub_string + '.' + run_string + '.' + cond_string)
        cond.label = cond_string
        if cond not in run.conds: run.conds.append(cond)

        if getRun(line)[1] == 'L':
            onset = line[coldict['LearningTrialDescriptionOnsetTime']]
            offset = line[coldict['LearningTrialDescriptionOffsetTime']]
        elif getRun(line)[1] == 'M':
            onset = line[coldict['MemoryTrialDescriptionOnsetTime']]
            offset = line[coldict['MemoryTrialDescriptionOffsetTime']]
        
        if getRun(line)[1] == 'M' or getRun(line)[1] == 'L':
            RT = line[coldict['ResponseTime']]
            ans = line[coldict['ResponseClicked']]
            
        if onset == '' or offset == '':
            print sub_string, run_string, cond_string, "empty onset or offset!"
            continue
        
        onset = int(onset)
        offset = int(offset)
        run.events.append((onset, offset, ans, RT))
        counter = len(run.events)
        cond.events.append((onset, offset, ans, RT, counter))
        if counter > 30:
            cond.events.pop(0)
                
g= open(root+'onsetRecord', 'w')

for sub in subs:
    sub.sorted_runs = sorted(sub.runs, key=lambda x: x.label) 
    for run in sub.sorted_runs:
        if len(run.events) > 0:
            run.start = sorted(run.events[-30:])[0][0]
            g.write("\t".join([sub.label, run.label, str(run.start)]) + "\n")
        run.sorted_conds = sorted(run.conds, key=lambda x: x.label)
        for cond in run.sorted_conds:
            cond.sorted_events = sorted(cond.events)
            for event in cond.sorted_events:
                sub_event = (event[0] - run.start, event[1] - run.start, event[2], event[3] )
                cond.subtracted_events.append(sub_event)


header = ['subject', 'run', 'cond', 'onset', 'offset', 'ans', 'RT']
                                 
for sub in subs:
    h = open(root+sub.label, 'w')
    h.write("\t\t".join(header) + "\n")
    for run in sub.sorted_runs:
        for cond in run.sorted_conds:
            for event in cond.subtracted_events:
                h.write("\t\t".join([sub.label, run.label, cond.label, str(event[0]), str(event[1]), str(event[2]), str(event[3])]) + '\n')
        
    

