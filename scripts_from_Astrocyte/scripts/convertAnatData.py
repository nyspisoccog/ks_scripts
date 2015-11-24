import os, subprocess

path = "/media/My Passport/SocCog Raw Data By Exam Number/3308/e340886/"
escape_path = "/media/My\ Passport/SocCog\ Raw\ Data\ By\ Exam\ Number/3308/e340886/"

#for series in os.listdir(path):
	#for tar in os.listdir(path + series):
		#if tar[-2:] == "gz":
			#tarpath = escape_path + series 
			#fullpath = escape_path + series + "/" + tar 
			#subprocess.call("tar -zxvf " + fullpath + " -C " + tarpath, shell=True)

subprocess.call("source /home/astrocyte/Desktop/startFreesurfer.sh", shell=True)

#for series in os.listdir(path):
	#d = path + series
	#for f in os.listdir(d):
		#if "MRDC" in f:
			#orig = escape_path + series + "/" + f
			#dest = escape_path + series + "/" + series + ".img"
			#subprocess.call("mri_convert " + orig + " " + dest, shell=True)
			#break




