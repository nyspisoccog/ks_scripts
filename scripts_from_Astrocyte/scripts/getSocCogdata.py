#!/home/bin/python

import shutil, os

rootDir = "/home/astrocyte/jungledisk-work/soccog/"
destDir = "/media/My Passport/soccog/"

funcDir = "functional - 7xxx/"

def printWrite(string, destFile):
	print string
	destFile.write(string + "\n")

f = open(destDir + 'funcCopyRec3.txt', 'w')

path = rootDir + funcDir

for sub in os.listdir(path):
	newOrigDir = destDir + sub + "/functional/orig/"
	newPreProcDir = destDir + sub + "/functional/preproc/"
	try:
		os.makedirs(newOrigDir)
		os.makedirs(newPreProcDir)
	except:
		pass
	for block in os.listdir(path + sub):
		fileSrc = path + sub + "/" + block
		fileDest1 = newOrigDir + block
		try:
			os.makedirs(fileDest1)
		except:
			pass
		fileDest2 = newPreProcDir + block
		try:
			os.makedirs(fileDest2)
		except:
			pass
		for volFile in os.listdir(fileSrc):
			if volFile[0] == "m":
				if volFile in os.listdir(fileDest1):
					copyRec = "There already " + sub + " " + block + " " + volFile
					printWrite(copyRec, f)
					continue
				try: 
					copyRec = "Copied orig " + sub + " " + block + " " + volFile
					printWrite(copyRec, f)
					shutil.copy2(fileSrc + "/" + volFile, fileDest1)
				except:
					copyRec = "Did not copy orig" + sub + " " + block + " " + volFile
					printWrite(copyRec, f)
					pass
			if volFile[0] == "s":
				if volFile in os.listdir(fileDest2):
					copyRec = "There already " + sub + " " + block + " " + volFile
					printWrite(copyRec, f)
					continue
				try:
					copyRec = "Copied preproc " + sub + " " + block + " " + volFile					
					printWrite(copyRec, f)
					shutil.copy2(fileSrc + "/" + volFile, fileDest2)
				except:
					copyRec = "Did not copy preproc" + sub + " " + block + " " + volFile					
					printWrite(copyRec, f)
					pass



