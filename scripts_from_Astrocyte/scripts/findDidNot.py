import os

path = "/media/My Passport/soccog/"
texts = ["funcCopyRec.txt", "funcCopyRec2.txt"]
fo = open(path + 'notCopyRec.txt', 'w')


for text in texts:
	fi = open(path + text, "r")
	for line in fi:
		if line[0:3] == "Did":
			print "true"
			fo.write(line)

