from __future__ import with_statement
import os, csv, shutil,tarfile, uf, dcm_ops
dest_root = '/ifs/scratch/pimri/soccog/test_working'
dst_path_lst = ['7659', 'run2M6']
uf.buildtree(dest_root, dst_path_lst)
uf.copytree('/ifs/scratch/pimri/soccog/old/SocCog_Raw_Data_By_Exam_Number/3240/E3240_e1826369/s1915767_5610_2M6_s35', '/ifs/scratch/pimri/soccog/test_working/7659/run2M6')
t = tarfile.open(os.path.join('/ifs/scratch/pimri/soccog/test_working/7659/run2M6','MRDC_files.tar.gz'), 'r')
t.extractall('/ifs/scratch/pimri/soccog/test_working/7659/run2M6')
for f in os.listdir('/ifs/scratch/pimri/soccog/test_working/7659/run2M6'):
   if 'MRDC' in f and 'gz' not in f:
       old = os.path.join('/ifs/scratch/pimri/soccog/test_working/7659/run2M6', f)
       new = os.path.join('/ifs/scratch/pimri/soccog/test_working/7659/run2M6', f + '.dcm')
       os.rename(old, new)
qsub_cnv_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7659/run2M6', '7659_run2M6', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cnv')
#qsub_cln_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7659/run2M6', '7659_run2M6', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cln')
