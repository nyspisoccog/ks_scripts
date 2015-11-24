__author__ = 'katie'

import csv

triallist = []

class Trial(object):
    def __init__(self):
        pass

root = '/media/katie/storage/'
txt = 'infile.csv'
infile = root + txt

#with open(infile, 'rb') as csvrfile:
csvrfile = open(infile, 'rb') 
filereader = csv.DictReader(csvrfile, delimiter='\t', dialect='excel')
#runonset = sorted([int(row['TextDisplay4.RTTime']) for row in filereader])[0]
#print runonset
for row in filereader:
    print "entering loop"
    trial = Trial()
    triallist.append(trial)
    trial.subject = row['Subject']
    a = trial.subject
    print a
    trial.block = row['Block']
    trial.pres = row['Face']
    trial.arousallet = row['ResponseClicked'][0]
    trial.arousal = 106 - ord(trial.arousallet)
    trial.valence = row['ResponseClicked'][-1]
    trial.runonset = runonset
    trial.preson = int(row['FaceSlideOnsetTime'])
    trial.rateon = int(row['StimulusOnsetTime'])
    trial.fixon = int(row['FixationOnsetTime'])
    trial.fixoff = int(row['FixationOffsetTime'])
    tr = 2800
    dummyno = 6
    dummylength = dummyno*tr
    milisec = 1000
    if (trial.preson - trial.runonset) < dummylength:
        trial.presonr = 0
    else:
        trial.presonr = (trial.preson - trial.runonset - dummylength) / milisec
    trial.rateonr = (trial.rateon - trial.runonset - dummylength) / milisec
    trial.fixonr = (trial.rateon - trial. runonset - dummylength) / milisec
    trial.fixoffr = (trial.rateon - trial.runonset - dummylength) / milisec
    trial.presdurr = (trial.rateonr - trial.presonr)
    trial.ratedurr = trial.fixonr - trial.rateonr
    trial.fixdurr = trial.fixoffr-trial.fixonr
    trial.ratefixdurr = trial.fixoffr-trial.rateonr
    if (trial.preson-trial.runonset) < dummylength:
        trial.presons = 1
    else:
        trial.presons = int(1.5 + (trial.rateon-trial.runonset) / tr - dummyno)
    trial.rateons = int(1.5 + (trial.rateon-trial.runonset) / tr - dummyno)
    trial.fixons = int(1.5 + (trial.fixon-trial.runonset) / tr - dummyno)
    trial.fixoffs = int(.5 + (trial.fixon-trial.runonset) / tr - dummyno)
    trial.presdurs = trial.rateons - trial.presons
    trial.ratedurs = trial.fixons - trial.rateons
    trial.fixdurs = trial.fixoffs - trial.fixons + 1
    trial.ratefixdurs = trial.fixoffs - trial.rateons + 1


with open(root + 'onsets_' + txt, 'w') as csvwfile:
    filewriter = csv.writer(csvwfile, delimiter=',')
    for trial in triallist:
        filewriter.writerow(trial.subject, trial.run, trial.block, trial.pres, trial.arousallet, trial.arousal,
                            trial.valence, trial.runonset, trial.preson, trial.rateon, trial.fixon, trial.fixoff,
                            trial.presonr, trial.rateonr, trial.fixonr, trial.fixoffr, trial.presdurr, trial.ratedurr,
                            trial.fixdurr, trial.ratefixdurr, trial.preson, trial.presons, trial.rateons, trial.fixons,
                            trial.fixoffs, trial.presdurs, trial.ratedurs, trial.fixdurs, trial.ratefixdurs)
