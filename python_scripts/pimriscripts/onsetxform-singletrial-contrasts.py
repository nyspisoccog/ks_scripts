from __future__ import division
import os, csv, copy


__author__ = 'katie'

#data note: for subj 7619, run 1M3, target "Kelly", there is a line of data that didn't get recorded, probably because the
#eprime crashed.  1M3 then is fully collected with a new startup point on the next line.  It is too much work
#to code around this one line, so 23583 in the spreadsheet I'm working with is deleted.  Keep in mind if you ever start with a
#new spreadsheet.  KS 8/27/14



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

root = '/media/truecrypt1/SocCog/SocCog/eprime_data'

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

        for run in runs:
            if runid == run.id:
                currun = run

        typ = line['TargetTypeTarget']

        trialtype = line['TrialType']

        rel = ''
        val = ''
        taught = ''
        fullcond = ''

        if '+' in trialtype: val = '+'
        if '-' in trialtype: val = '-'
        if 'T' in trialtype: taught = 'T'
        if 'N' in trialtype: taught  = 'U'
        if 'D' in trialtype: rel = 'R'
        if 'I' in trialtype: rel = 'I'
        if 'R' in trialtype: rel = 'R'

        if getRun(line)[2] == 'L':
            offset = line['LearningTrialDescriptionOffsetTime']
            offset = int(offset)
            onset = offset - 4000
            fullcond += 'L'

        elif getRun(line)[2] == 'M':
            onset = int(line['MemoryTrialDescriptionOnsetTime'])
            offset = int(line['MemoryTrialDescriptionOffsetTime'])
            fullcond += 'M'

        fullcond = ''.join([fullcond, typ, rel, taught, val])

        if val == '+': val = 'pos'
        if val == '-': val = 'neg'

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
                RT = 4
                ans = 'R3.5'
                trial = [fullcond, typ, rel, val, taught, onset, offset, RT, ans]
                currun.trials.append(trial)
        else:
            trial = [fullcond, typ, rel, val, taught, onset, offset, RT, ans]
            currun.trials.append(trial)


header = ['subject', 'run', 'fullcond', 'singletrial', 'type', 'rel', 'val', 'taught', 'onset', 'offset', 'RT', 'ans', 'BP']

with open(os.path.join(root, 'ks-trialsdata-noMV-singtri-contrast.csv'), 'w') as out:
    out.write("\t".join(header) + "\n")
    for sub in subs:
        sub.runs = sorted(sub.runs, key=lambda x: x.id)
        for run in sub.runs:
            run.trials = sorted(run.trials, key=lambda x: x[4])
            relcount = 0
            irrcount = 0
            for trial in run.trials:
                trial[5] = trial[5] - run.start
                trial[6] = trial[6] - run.start
                if trial[7] != '':
                    bp = trial[5] + trial[7]
                trial.append(bp)
                bp = ''
                count = 0
                if trial[2] == 'R':
                    relcount += 1
                    count = relcount
                if trial[2] == 'I':
                    irrcount += 1
                    count == irrcount
                if trial[3] == 'pos': val = '+'
                elif trial[3] == 'neg':val = '-'
                else:val = ''
                sing_tri_cond = trial[0][0] + trial[1] + trial[2]  + str(count) + val
                trial.insert(1, sing_tri_cond)
                out.write("\t".join([sub.id, run.id] + [str(el) for el in trial] + ['']))

                contrast = []

                #contrast learning rel-irrel

                if sing_tri_cond[0] == 'L':
                    if sing_tri_cond[1] == 'S':
                        if sing_tri_cond[2] == 'R':
                            contrast.append('1')
                        else:
                            contrast.append('-1')
                    else:
                        print "else true"
                        if sing_tri_cond[2] == 'R':
                            print sing_tri_cond
                            contrast.append("-0.5")
                        else:
                            contrast.append("0.5")

                out.write("\t".join(contrast) + "\n")






