from __future__ import with_statement
import os, csv, shutil,tarfile, uf, dcm_ops
dest_root = '/ifs/scratch/pimri/soccog/test_working'
dst_path_lst = ['7432', 'run2M4']
uf.buildtree(dest_root, dst_path_lst)
uf.copytree('/ifs/scratch/pimri/soccog/old/SocCog_Raw_Data_By_Exam_Number/2480/e1331017/s1405187_5610_2M4_s33', '/ifs/scratch/pimri/soccog/test_working/7432/run2M4')
t = tarfile.open(os.path.join('/ifs/scratch/pimri/soccog/test_working/7432/run2M4','MRDC_files.tar.gz'), 'r')
t.extractall('/ifs/scratch/pimri/soccog/test_working/7432/run2M4')
for f in os.listdir('/ifs/scratch/pimri/soccog/test_working/7432/run2M4'):
   if 'MRDC' in f and 'gz' not in f:
       old = os.path.join('/ifs/scratch/pimri/soccog/test_working/7432/run2M4', f)
       new = os.path.join('/ifs/scratch/pimri/soccog/test_working/7432/run2M4', f + '.dcm')
       os.rename(old, new)
qsub_cnv_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7432/run2M4', '7432_run2M4', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cnv')
#qsub_cln_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7432/run2M4', '7432_run2M4', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cln')
