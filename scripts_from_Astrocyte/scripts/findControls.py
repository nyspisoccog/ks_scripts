import random, csv, numpy, re

controlinfo = open('/media/katie/storage/PanicPTSD/data/control_raw_data/controlinfo.csv', 'r')

def random_comb(iterable, r):
    "Random selection from itertools.combinations(iterable, r)"
    pool = tuple(iterable)
    n = len(pool)
    indices = sorted(random.sample(xrange(n), r))
    return tuple(pool[i] for i in indices)

PPID_dict = {}

for exam in csv.DictReader(controlinfo, dialect = "excel"):
    
    if len(exam['OldPPID']) > 3:
        if exam['OldPPID'] not in PPID_dict.keys() and int(exam['Age']) > 17:
            PPID_dict[exam['OldPPID']] = [exam['Sex'], int(exam['Age'])]

print len(PPID_dict)

opt_set = []

num_f = 0

for k, v in PPID_dict.iteritems():
    if v[0] == 'F':
        num_f += 1

print num_f

for i in range(10000000):
    opt_test = 100000000
    test = random_comb(PPID_dict, 35)
    no_females = 0
    for PPID in test:
        if PPID_dict[PPID][0] == 'F':
            no_females += 1
    ages = [v[1] for k, v in test]
    ages = array(ages)
    mean_diff = abs(42 - numpy.mean(ages))
    sd_diff = abs(17.5 - numpy.std(ages))
    print mean_diff + sd_diff
    if mean_diff + sd_diff < opt_test:
        opt_test = mean_diff + sd_diff
        opt_set = test
        opt_mean = mean_diff
        opt_sd = sd_diff

print opt_set, opt_mean, opt_sd
    
    
    
    


