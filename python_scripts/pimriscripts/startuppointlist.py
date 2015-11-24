__author__ = 'katie'

import os
import csv

root = '/media/truecrypt1/SocCog/eprime_data'

f_name = 'EPrimeData.csv'

bad_subs = []

p_name = os.path.join(root, f_name)

with open(p_name, 'r') as f:
    reader = csv.DictReader(f)
    for row in reader:
        if row['StartupPoint'] not in ['L1']:
            if row['Subject'] not in bad_subs:
                bad_subs.append(row['Subject'])

print bad_subs