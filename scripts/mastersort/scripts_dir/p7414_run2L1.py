from __future__ import with_statement
import os, csv, shutil,tarfile, uf, dcm_ops
dest_root = '/ifs/scratch/pimri/soccog/test_working'
dst_path_lst = ['7414', 'run2L1']
uf.buildtree(dest_root, dst_path_lst)
uf.copytree('/ifs/scratch/pimri/soccog/old/SocCog_Raw_Data_By_Exam_Number/1849/e1341519/s1007309_1904_s21', '/ifs/scratch/pimri/soccog/test_working/7414/run2L1')
t = tarfile.open(os.path.join('/ifs/scratch/pimri/soccog/test_working/7414/run2L1','MRDC_files.tar.gz'), 'r')
t.extractall('/ifs/scratch/pimri/soccog/test_working/7414/run2L1')
for f in os.listdir('/ifs/scratch/pimri/soccog/test_working/7414/run2L1'):
   if 'MRDC' in f and 'gz' not in f:
       old = os.path.join('/ifs/scratch/pimri/soccog/test_working/7414/run2L1', f)
       new = os.path.join('/ifs/scratch/pimri/soccog/test_working/7414/run2L1', f + '.dcm')
       os.rename(old, new)
qsub_cnv_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7414/run2L1', '7414_run2L1', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cnv')
#qsub_cln_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7414/run2L1', '7414_run2L1', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cln')
