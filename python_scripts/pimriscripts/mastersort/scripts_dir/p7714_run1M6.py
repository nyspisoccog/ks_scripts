from __future__ import with_statement
import os, csv, shutil,tarfile, uf, dcm_ops
dest_root = '/ifs/scratch/pimri/soccog/test_working'
dst_path_lst = ['7714', 'run1M6']
uf.buildtree(dest_root, dst_path_lst)
uf.copytree('/ifs/scratch/pimri/soccog/old/SocCog_Raw_Data_By_Exam_Number/3189/E3189_e976517/s1016369_5610_1M6_s17', '/ifs/scratch/pimri/soccog/test_working/7714/run1M6')
t = tarfile.open(os.path.join('/ifs/scratch/pimri/soccog/test_working/7714/run1M6','MRDC_files.tar.gz'), 'r')
t.extractall('/ifs/scratch/pimri/soccog/test_working/7714/run1M6')
for f in os.listdir('/ifs/scratch/pimri/soccog/test_working/7714/run1M6'):
   if 'MRDC' in f and 'gz' not in f:
       old = os.path.join('/ifs/scratch/pimri/soccog/test_working/7714/run1M6', f)
       new = os.path.join('/ifs/scratch/pimri/soccog/test_working/7714/run1M6', f + '.dcm')
       os.rename(old, new)
qsub_cnv_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7714/run1M6', '7714_run1M6', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cnv')
#qsub_cln_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7714/run1M6', '7714_run1M6', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cln')
