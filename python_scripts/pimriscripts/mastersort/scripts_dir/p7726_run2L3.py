from __future__ import with_statement
import os, csv, shutil,tarfile, uf, dcm_ops
dest_root = '/ifs/scratch/pimri/soccog/test_working'
dst_path_lst = ['7726', 'run2L3']
uf.buildtree(dest_root, dst_path_lst)
uf.copytree('/ifs/scratch/pimri/soccog/old/SocCog_Raw_Data_By_Exam_Number/3274/E3274_e2535432/s2583055_1904_2L3_s22', '/ifs/scratch/pimri/soccog/test_working/7726/run2L3')
t = tarfile.open(os.path.join('/ifs/scratch/pimri/soccog/test_working/7726/run2L3','MRDC_files.tar.gz'), 'r')
t.extractall('/ifs/scratch/pimri/soccog/test_working/7726/run2L3')
for f in os.listdir('/ifs/scratch/pimri/soccog/test_working/7726/run2L3'):
   if 'MRDC' in f and 'gz' not in f:
       old = os.path.join('/ifs/scratch/pimri/soccog/test_working/7726/run2L3', f)
       new = os.path.join('/ifs/scratch/pimri/soccog/test_working/7726/run2L3', f + '.dcm')
       os.rename(old, new)
qsub_cnv_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7726/run2L3', '7726_run2L3', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cnv')
#qsub_cln_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7726/run2L3', '7726_run2L3', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cln')
