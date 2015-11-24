from __future__ import with_statement
import os, csv, shutil,tarfile, uf, dcm_ops
dest_root = '/ifs/scratch/pimri/soccog/test_working'
dst_path_lst = ['7562', 'run1M5']
uf.buildtree(dest_root, dst_path_lst)
uf.copytree('/ifs/scratch/pimri/soccog/old/SocCog_Raw_Data_By_Exam_Number/2880/E2880_e3084893/s3119497_5610_1M5_s15', '/ifs/scratch/pimri/soccog/test_working/7562/run1M5')
t = tarfile.open(os.path.join('/ifs/scratch/pimri/soccog/test_working/7562/run1M5','MRDC_files.tar.gz'), 'r')
t.extractall('/ifs/scratch/pimri/soccog/test_working/7562/run1M5')
for f in os.listdir('/ifs/scratch/pimri/soccog/test_working/7562/run1M5'):
   if 'MRDC' in f and 'gz' not in f:
       old = os.path.join('/ifs/scratch/pimri/soccog/test_working/7562/run1M5', f)
       new = os.path.join('/ifs/scratch/pimri/soccog/test_working/7562/run1M5', f + '.dcm')
       os.rename(old, new)
qsub_cnv_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7562/run1M5', '7562_run1M5', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cnv')
#qsub_cln_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7562/run1M5', '7562_run1M5', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cln')
