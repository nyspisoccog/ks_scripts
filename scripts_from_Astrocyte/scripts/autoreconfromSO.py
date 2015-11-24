import subprocess
import tempfile
import os
import stat


with tempfile.NamedTemporaryFile(mode='w', delete=False) as f:
    f.write('''\
#!/bin/bash
source ~/scripts/mySetUpFreeSurfer.sh
source /usr/local/freesurfer/FreeSurferEnv.sh
''')
    root = "/media/katie/storage/PanicPTSD/data-neworg/Panic/"
    for sub_dir in os.listdir(root):
        anat_dir = os.path.join(root, sub_dir, "anatomical")
        for directory in os.listdir(anat_dir):
            time_dir = os.path.join(anat_dir, directory)
            exam_dir = os.listdir(time_dir)[0]
            dicoms_dir = os.path.join(time_dir, exam_dir, 'dicoms')
            exam = 'e' + exam_dir[0:5] + exam_dir[-1]
            dicom_list = os.listdir(dicoms_dir)
            dicom = dicom_list[0]
            path = os.path.join(dicoms_dir, dicom)
            cmd1 = "recon-all -i {}  -subjid {}\n".format(path, exam)
            f.write(cmd1)
            cmd2 = "recon-all -all -subjid {}\n".format(exam)
            f.write(cmd2)

filename = f.name
os.chmod(filename, stat.S_IRUSR | stat.S_IXUSR)
subprocess.call([filename])
os.unlink(filename)
