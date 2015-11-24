import os, shutil

root = "/media/katie/SocCog/7561_2M6_s16/AnalyzeFiles/"
		
for i, f in enumerate(sorted(os.listdir(root))):
        num = i/2 + 1
        string = ""
        suffix = f[-4:]
        string = "".join([string + '0' for j in range(4-len(str(num)))])
        string = "m" + string + str(num) + suffix
        src = root + f
        dst = root + string
        shutil.move(src, dst)
        print(src, dst)
