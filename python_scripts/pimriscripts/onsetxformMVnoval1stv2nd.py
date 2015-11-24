from __future__ import division
import os, csv, copy


__author__ = 'katie'

#data note: for subj 7619, run 1M3, target "Kelly", there is a line of data that didn't get recorded, probably because the
#eprime crashed.  1M3 then is fully collected with a new startup point on the next line.  It is too much work
#to code around this one line, so 23583 in the spreadsheet I'm working with is deleted.  Keep in mind if you ever start with a
#new spreadsheet.  KS 8/27/14


#this version omits valence as a condition.

#This version contrasts the first and second half of a learning run.

class Subject():
    def __init__(self):
        self.id  = str
        self.runs = []

class Run():
    def __init__(self):
        self.id = str
        self.trials = []
        self.start = None

def initsub():
    s = Subject()
    return s

def initrun():
    r = Run()
    return r

root = '/media/truecrypt1/SocCog/eprime_data'

f = open(os.path.join(root, 'EPrimeData.csv'), 'r')

def getRun(line):
    sess = line['Session']
    startup = line['StartupPoint']
    if startup != '':
        start = (startup[0], int(startup[1]))
    if line['ProcedureTarget'] == 'LearningTargetProc':
        phase = 'L'
        target = int(line['LearningTargetList'])
        if startup != '':
            if phase == start[0]:
                target = str(int(target) + int(start[1]) - 1)
    elif line['ProcedureTarget'] == 'MemoryTargetProc':
        phase = 'M'
        target = int(line['MemoryTargetList'])
        if startup != '':
            if phase == start[0]:
                target = str(int(target) + int(start[1]) - 1)
    else:
        return "", ""
    return "run" + sess + phase + str(target), sess, phase, str(target)

subjects_dict = {}

subs = []

for line in csv.DictReader(f, dialect='excel', delimiter=','):

    if getRun(line)[0] != '':

        subid = line['Subject']

        if subid not in [sub.id for sub in subs]:
            s = initsub()
            s.id = subid
            subs.append(s)

        for sub in subs:
            if subid == sub.id:
                cursub = sub

        runid = getRun(line)[0]
        runs = cursub.runs

        if runid not in [run.id for run in runs]:
            r = initrun()
            r.id = runid
            runs.append(r)
            relcount = 0
            irrcount = 0

        for run in runs:
            if runid == run.id:
                currun = run

        typ = line['TargetTypeTarget']

        trialtype = line['TrialType']

        rel = ''
        taught = ''
        fullcond = ''

        if 'T' in trialtype: taught = 'T'
        if 'N' in trialtype: taught  = 'U'
        if 'D' in trialtype:
            rel = 'R'
            relcount += 1
        if 'I' in trialtype: rel = 'I'
        if 'R' in trialtype: rel = 'R'

        if getRun(line)[2] == 'L':
            offset = line['LearningTrialDescriptionOffsetTime']
            offset = int(offset)
            onset = offset - 4000 # this is a necessary fix for an error in how the data were recorded
            fullcond += 'L'

        elif getRun(line)[2] == 'M':
            onset = int(line['MemoryTrialDescriptionOnsetTime'])
            offset = int(line['MemoryTrialDescriptionOffsetTime'])
            fullcond += 'M'

        fullcond = ''.join([fullcond, typ, rel, taught])

        if int(line['Trial']) == 1:
            currun.start = (offset - 4000)/1000

        onset = onset/1000
        offset = offset/1000


        if getRun(line)[2] == 'M' or getRun(line)[2] == 'L':
            RT = line['ResponseTime']
            ans = line['ResponseClicked']
            if RT != '':
                RT = int(RT)/1000

        if onset == '' or offset == '':
            print subid, runid, "empty onset or offset!"

        if RT == '':
            if fullcond[0] == 'M':
                print "true"
                RT = 4
                ans = 'R3.5'
                trial = [fullcond, typ, rel, taught, onset, offset, RT, ans]
                currun.trials.append(trial)
        else:
            trial = [fullcond, typ, rel, taught, onset, offset, RT, ans]
            currun.trials.append(trial)


header = ['subject', 'run', 'fullcond', 'type', 'rel', 'taught', 'half', 'onset', 'offset', 'RT', 'ans', 'BP']

with open(os.path.join(root, 'ks-trialsdata-wtrialtypename-noMV-noval-1stv2nd.csv'), 'w') as out:
    out.write("\t".join(header) + "\n")
    for sub in subs:
        sub.runs = sorted(sub.runs, key=lambda x: x.id)
        for run in sub.runs:
            relcount = 0
            irrcount = 0
            run.trials = sorted(run.trials, key=lambda x: x[4])
            if 'L' in run.id:
                reltot = len([trial for trial in run.trials if trial[2] == 'R'])
                irrtot = len([trial for trial in run.trials if trial[2] == 'I'])
                for trial in run.trials:
                    if trial[2] == 'I':
                        irrcount += 1
                        if irrcount > irrtot/2:
                            trial.insert(4, 'S')
                            trial[0] = trial[0] + 'S'
                        else:
                            trial.insert(4, 'F')
                            trial[0] = trial[0] + 'F'
                    if trial[2] == 'R':
                        relcount += 1
                        if relcount > reltot/2:
                            trial.insert(4, 'S')
                            trial[0]  = trial[0] + 'S'
                        else:
                            trial.insert(4, 'F')
                            trial[0] = trial[0] + 'F'
            if 'M' in run.id:
                for trial in run.trials: trial.insert(4, '')
            for trial in run.trials:
                trial[5] = trial[5] - run.start
                trial[6] = trial[6] - run.start
                if trial[7] != '':
                    bp = trial[5] + trial[7]
                trial.append(bp)
                bp = ''
                out.write("\t".join([sub.id, run.id] + [str(el) for el in trial]) + "\n")




