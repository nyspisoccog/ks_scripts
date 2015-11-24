from __future__ import with_statement
import os, csv, shutil,tarfile, uf, dcm_ops
dest_root = '/ifs/scratch/pimri/soccog/test_working'
dst_path_lst = ['7404', 'run1L1']
uf.buildtree(dest_root, dst_path_lst)
uf.copytree('/ifs/scratch/pimri/soccog/old/SocCog_Raw_Data_By_Exam_Number/1714/E1714_e1563685/s1563906_1904_1L1_s5', '/ifs/scratch/pimri/soccog/test_working/7404/run1L1')
t = tarfile.open(os.path.join('/ifs/scratch/pimri/soccog/test_working/7404/run1L1','MRDC_files.tar.gz'), 'r')
t.extractall('/ifs/scratch/pimri/soccog/test_working/7404/run1L1')
for f in os.listdir('/ifs/scratch/pimri/soccog/test_working/7404/run1L1'):
   if 'MRDC' in f and 'gz' not in f:
       old = os.path.join('/ifs/scratch/pimri/soccog/test_working/7404/run1L1', f)
       new = os.path.join('/ifs/scratch/pimri/soccog/test_working/7404/run1L1', f + '.dcm')
       os.rename(old, new)
qsub_cnv_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7404/run1L1', '7404_run1L1', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cnv')
#qsub_cln_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7404/run1L1', '7404_run1L1', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cln')
