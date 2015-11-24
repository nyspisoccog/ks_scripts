import os, codecs, unicodedata

fileLoc = '/home/astrocyte/Documents/'

spreadsheet = codecs.open(fileLoc + 'soccogsample.csv', encoding='utf-16')

unicodedata.normalize('NFKD', spreadsheet).encode('ascii','ignore')

f = open(fileLoc + 'soccog.csv', 'w')

for line in spreadsheet:
	f.write(line)

