from __future__ import with_statement
import os, csv, shutil,tarfile, uf, dcm_ops
dest_root = '/ifs/scratch/pimri/soccog/test_working'
dst_path_lst = ['7659', 'run2M2']
uf.buildtree(dest_root, dst_path_lst)
uf.copytree('/ifs/scratch/pimri/soccog/old/SocCog_Raw_Data_By_Exam_Number/3240/E3240_e1826369/s1893323_5610_2M2_s31', '/ifs/scratch/pimri/soccog/test_working/7659/run2M2')
t = tarfile.open(os.path.join('/ifs/scratch/pimri/soccog/test_working/7659/run2M2','MRDC_files.tar.gz'), 'r')
t.extractall('/ifs/scratch/pimri/soccog/test_working/7659/run2M2')
for f in os.listdir('/ifs/scratch/pimri/soccog/test_working/7659/run2M2'):
   if 'MRDC' in f and 'gz' not in f:
       old = os.path.join('/ifs/scratch/pimri/soccog/test_working/7659/run2M2', f)
       new = os.path.join('/ifs/scratch/pimri/soccog/test_working/7659/run2M2', f + '.dcm')
       os.rename(old, new)
qsub_cnv_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7659/run2M2', '7659_run2M2', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cnv')
#qsub_cln_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7659/run2M2', '7659_run2M2', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cln')
