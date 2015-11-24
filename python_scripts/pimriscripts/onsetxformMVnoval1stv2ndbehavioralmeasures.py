from __future__ import division
import os, csv, copy, numpy


__author__ = 'katie'

#data note: for subj 7619, run 1M3, target "Kelly", there is a line of data that didn't get recorded, probably because the
#eprime crashed.  1M3 then is fully collected with a new startup point on the next line.  It is too much work
#to code around this one line, so 23583 in the spreadsheet I'm working with is deleted.  Keep in mind if you ever start with a
#new spreadsheet.  KS 8/27/14


#this version omits valence as a condition.

#This version contrasts the first and second half of a learning run.

#This version includes several transformations of the behavioral measure

class Subject():
    def __init__(self):
        self.id  = str
        self.runs = []
        self.Slist = []
        self.Ylist = []
        self.Nlist = []

class Run():
    def __init__(self):
        self.id = str
        self.name = str
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
            r.name = line['TargetName']
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
            ans = line['ResponseClicked'][1:]
            if RT != '':
                RT = int(RT)/1000

        if onset == '' or offset == '':
            print subid, runid, "empty onset or offset!"

        if RT == '':
            if fullcond[0] == 'M':
                RT = 4
                ans = '3.5'
                trial = [fullcond, typ, rel, taught, onset, offset, RT, ans]
                currun.trials.append(trial)
        else:
            trial = [fullcond, typ, rel, taught, onset, offset, RT, ans]
            currun.trials.append(trial)


header = ['subject', 'run', 'fullcond', 'type', 'rel', 'taught', 'half', 'onset', 'offset', 'RT', 'ans', 'BP']

with open(os.path.join(root, 'ks-trialsdata-wtrialtypename-behavioral.csv'), 'w') as out:
    out.write(",".join(header) + "\n")
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
                out.write(",".join([sub.id, run.id] + [str(el) for el in trial]) + "\n")
# skip = [('7432', 'run1L3'), ('2022', 'run1L1'), ('4004', 'run2L4')]
# for sub in subs:
#     Lruns = [run for run in sub.runs if (sub.id, run.id) not in skip and run.trials[0][0][0] == 'L']
#     Mruns = [run for run in sub.runs if (sub.id, run.id) not in skip and run.trials[0][0][0] == 'M']
#     for mrun in Mruns:
#          RT = []
#          RU = []
#          IT = []
#          IU = []
#          for trial in mrun.trials:
#              fullcond = trial[0]
#              if fullcond[2:4] == 'RT':
#                  RT.append(float(trial[8][1:]))
#              if fullcond[2:4] == 'RU':
#                  RU.append(float(trial[8][1:]))
#              if fullcond[2:4] == 'IT':
#                  IT.append(float(trial[8][1:]))
#              if fullcond[2:4] == 'IU':
#                  IU.append(float(trial[8][1:]))
#          mrun.RT = RT
#          mrun.RU = RU
#          mrun.IT = IT
#          mrun.IU = IU
#          mrun.fpr =  numpy.mean(RU)
#          mrun.fptp = numpy.mean(RU) - numpy.mean(RT)
#          cond = mrun.trials[0][0][1]
#          if cond == 'S': sub.Slist.append(mrun.fpr)
#          if cond == 'Y': sub.Ylist.append(mrun.fpr)
#          if cond == 'N': sub.Nlist.append(mrun.fpr)
#     for lrun in Lruns:
#         match = False
#         for mrun in Mruns:
#             if mrun.name == lrun.name:
#                 match = True
#                 lrun.RT = mrun.RT
#                 lrun.RU = mrun.RU
#                 lrun.IT = mrun.IT
#                 lrun.IU = mrun.IU
#                 lrun.fpr = mrun.fpr
#                 lrun.fptp = mrun.fptp
#
#         if not match:
#             lrun.fpr = 'NaN'
#             lrun.fptp = 'NaN'
#
# header = ['subject', 'run', 'condition', 'fp', 'fp-tp']
# with open(os.path.join(root, 'behavioralsummarystats.csv'), 'w') as out:
#     out.write(",".join(header) + "\n")
#     for sub in subs:
#         for run in sub.runs:
#             if (sub.id, run.id) not in skip:
#                 out.write(",".join([sub.id, run.id, run.trials[0][1], str(run.fpr), str(run.fptp)]))
#                 out.write("\n")
#
# header = ['subject', 'condition', 'meanfp']
# with open(os.path.join(root, 'averagebycondition.csv'), 'w') as out:
#     out.write(",".join(header) + "\n")
#     for sub in subs:
#         for condition in [('S', sub.Slist), ('Y', sub.Ylist), ('N', sub.Nlist)]:
#             out.write(",".join([sub.id, condition[0], str(numpy.mean(condition[1]))]))
#             out.write("\n")

