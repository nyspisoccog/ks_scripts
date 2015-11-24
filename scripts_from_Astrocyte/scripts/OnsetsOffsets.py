import utilityFuncs as u
from copy import copy


class Subject():
    def __init__(self):

class Run():
    def __init__(self):

class Condition():
    def __init__(self):
    

root = '/media/katie/SocCog/'

f = open('/media/katie/SocCog/testexport.csv', 'r')

f = u.split_lines(f, '\t')

g = copy(f)

coldict = {col:i for i, col in enumerate(g[0])}

def getRun(line):
    sess = line[coldict['Session']]
    if line[coldict['ProcedureTarget']] == 'LearningTargetProc':
        phase = 'L'
        target = int(float(line[coldict['LearningTargetList']]))
    elif line[coldict['ProcedureTarget']] == 'MemoryTargetProc':
        phase = 'M'
        target = int(float(line[coldict['MemoryTargetList']]))
    else:
        return "", ""
    return sess + phase + str(target), phase

root = '/media/katie/SocCog/'

subjects_dict = {}
           
for line in g[1:]:
    if line[coldict['Subject']] not in subjects_dict.keys():
        subjects_dict[line[coldict['Subject']]] = [[]]

for line in g[1:]:
    subj = line[coldict['Subject']]
    subjects_dict[subj][0].append(line)
   

for k, sub in subjects_dict.iteritems():
    print k
    run_dict = {}
    sub.append(run_dict) #run_dict is first element in the list that is the val of subjects_dict[subj]
    for line in sub[0]:  #zeroth element in sub is list of lines for that subj
        run = getRun(line)[0] #zeroth return value of get run is string that names the run
        if run not in run_dict.keys():
            run_dict[run] = []
        if run in run_dict.keys():
            if getRun(line)[1] == 'L':
                onset = line[coldict['LearningTrialDescriptionOnsetTime']]
                offset = line[coldict['LearningTrialDescriptionOffsetTime']]
                if onset == '':
                    print k, run, "empty onset!"
                    continue
                if offset == '':
                    print k, run, "empty offset!"
                    continue
                run_dict[run].append([line[coldict['TargetTypeTarget']], line[coldict['TrialType']], int(onset), int(offset)])
            elif getRun(line)[1] == 'M':
                onset = line[coldict['MemoryTrialDescriptionOnsetTime']]
                offset = line[coldict['MemoryTrialDescriptionOffsetTime']]
                if onset == '':
                    print k, run, "empty onset!"
                    continue
                if offset == '':
                    print k, run, "empty offset!"
                    continue
                run_dict[run].append([line[coldict['TargetTypeTarget']], line[coldict['TrialType']],int(onset), int(offset)])
            else:
                continue
            
    
    for k, run in run_dict.iteritems():
        cond_dict = {}
        for line in run:
            cond = line[0] + line[1] #TargetTypeTarget + TrialType
            if cond not in cond_dict.keys():
                cond_dict[cond] = []
            cond_dict[cond].append((line[2], line[3]))
        run.append(cond_dict) #cond_dict is first el of run_dict[name of run]
        
header = ['subject', 'run', 'condition', 'onset', 'offset']
for sub, sub_val in subjects_dict.iteritems():
    h = open(root+str(sub), 'w')
    h.write("\t".join(header) + "\n")
    for run in sorted(sub_val[1].keys()):
        for cond in sorted(sub[run][-1].keys()):
            for on_off in sub[run][-1][cond][-1]:
                h.write("\t".join([str(sub), run, cond, str(on_off[0]), str(on_off[1])]))
                h.write("\n")

