from __future__ import with_statement
import os, csv, shutil,tarfile, uf, dcm_ops
dest_root = '/ifs/scratch/pimri/soccog/test_working'
dst_path_lst = ['7645', 'run1L6']
uf.buildtree(dest_root, dst_path_lst)
uf.copytree('/ifs/scratch/pimri/soccog/old/SocCog_Raw_Data_By_Exam_Number/3078/E3078_e1370606/s1380142_1904_1L6_s7', '/ifs/scratch/pimri/soccog/test_working/7645/run1L6')
t = tarfile.open(os.path.join('/ifs/scratch/pimri/soccog/test_working/7645/run1L6','MRDC_files.tar.gz'), 'r')
t.extractall('/ifs/scratch/pimri/soccog/test_working/7645/run1L6')
for f in os.listdir('/ifs/scratch/pimri/soccog/test_working/7645/run1L6'):
   if 'MRDC' in f and 'gz' not in f:
       old = os.path.join('/ifs/scratch/pimri/soccog/test_working/7645/run1L6', f)
       new = os.path.join('/ifs/scratch/pimri/soccog/test_working/7645/run1L6', f + '.dcm')
       os.rename(old, new)
qsub_cnv_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7645/run1L6', '7645_run1L6', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cnv')
#qsub_cln_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7645/run1L6', '7645_run1L6', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cln')
