from __future__ import with_statement
import os, csv, shutil,tarfile, uf, dcm_ops
dest_root = '/ifs/scratch/pimri/soccog/test_working'
dst_path_lst = ['7508', 'run2M3']
uf.buildtree(dest_root, dst_path_lst)
uf.copytree('/ifs/scratch/pimri/soccog/old/SocCog_Raw_Data_By_Exam_Number/2591/E2591_e517283/s528523_5610_2M3_s5', '/ifs/scratch/pimri/soccog/test_working/7508/run2M3')
t = tarfile.open(os.path.join('/ifs/scratch/pimri/soccog/test_working/7508/run2M3','MRDC_files.tar.gz'), 'r')
t.extractall('/ifs/scratch/pimri/soccog/test_working/7508/run2M3')
for f in os.listdir('/ifs/scratch/pimri/soccog/test_working/7508/run2M3'):
   if 'MRDC' in f and 'gz' not in f:
       old = os.path.join('/ifs/scratch/pimri/soccog/test_working/7508/run2M3', f)
       new = os.path.join('/ifs/scratch/pimri/soccog/test_working/7508/run2M3', f + '.dcm')
       os.rename(old, new)
qsub_cnv_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7508/run2M3', '7508_run2M3', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cnv')
#qsub_cln_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7508/run2M3', '7508_run2M3', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cln')
