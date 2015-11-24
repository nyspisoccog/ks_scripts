import os, subprocess

path = "/media/My Passport/SocCogAnatDataEdByKatie/"
escape_path = "/media/My\ Passport/SocCogAnatDataEdByKatie/"

#for series in os.listdir(path):
	#for tar in os.listdir(path + series):
		#if tar[-2:] == "gz":
			#tarpath = escape_path + series 
			#fullpath = escape_path + series + "/" + tar 
			#subprocess.call("tar -zxvf " + fullpath + " -C " + tarpath, shell=True)

#subprocess.call("/home/astrocyte/Desktop/./startFreesurfer.sh", shell=True)


rec = open(path + 'convertrec.txt', 'w')

for subject in os.walk(path).next()[1]:
	if "xls" in subject or "txt" in subject:
		continue
	long_path = path + subject + "/anatomical/orig/" 
	for series in os.listdir(long_path):
		d = long_path + series
		for f in os.listdir(d):
			if 
			if "MRDC" in f:
				esc_series = series
				new_name = series
				space_ind = series.find(" ")
				if space_ind != -1:
					esc_series = series[0:space_ind] + "\ " + series[space_ind + 1:]
					new_name = series[0:space_ind] + series[space_ind + 1:]
				orig = escape_path + subject + "/anatomical/orig/" + esc_series + "/" + f
				dest = escape_path + subject + "/anatomical/orig/" + esc_series + "/" + new_name + ".img"
				subprocess.call("mri_convert " + orig + " " + dest, shell=True)
				rec.write(series + "\n")
				break

