from __future__ import with_statement
import os, csv, shutil,tarfile, uf, dcm_ops
dest_root = '/ifs/scratch/pimri/soccog/test_working'
dst_path_lst = ['7726', 'run1L5']
uf.buildtree(dest_root, dst_path_lst)
uf.copytree('/ifs/scratch/pimri/soccog/old/SocCog_Raw_Data_By_Exam_Number/3274/E3274_e2535432/s2543070_1904_1L5_s7', '/ifs/scratch/pimri/soccog/test_working/7726/run1L5')
t = tarfile.open(os.path.join('/ifs/scratch/pimri/soccog/test_working/7726/run1L5','MRDC_files.tar.gz'), 'r')
t.extractall('/ifs/scratch/pimri/soccog/test_working/7726/run1L5')
for f in os.listdir('/ifs/scratch/pimri/soccog/test_working/7726/run1L5'):
   if 'MRDC' in f and 'gz' not in f:
       old = os.path.join('/ifs/scratch/pimri/soccog/test_working/7726/run1L5', f)
       new = os.path.join('/ifs/scratch/pimri/soccog/test_working/7726/run1L5', f + '.dcm')
       os.rename(old, new)
qsub_cnv_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7726/run1L5', '7726_run1L5', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cnv')
#qsub_cln_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7726/run1L5', '7726_run1L5', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cln')