from __future__ import with_statement
import os, csv, shutil,tarfile, uf, dcm_ops
dest_root = '/ifs/scratch/pimri/soccog/test_working'
dst_path_lst = ['7474', 'anat-1-1']
uf.buildtree(dest_root, dst_path_lst)
uf.copytree('/ifs/scratch/pimri/soccog/old/SocCog_Raw_Data_By_Exam_Number/2530/e2227547/s2239067_166_SPGR1_s12', '/ifs/scratch/pimri/soccog/test_working/7474/anat-1-1')
t = tarfile.open(os.path.join('/ifs/scratch/pimri/soccog/test_working/7474/anat-1-1','MRDC_files.tar.gz'), 'r')
t.extractall('/ifs/scratch/pimri/soccog/test_working/7474/anat-1-1')
for f in os.listdir('/ifs/scratch/pimri/soccog/test_working/7474/anat-1-1'):
   if 'MRDC' in f and 'gz' not in f:
       old = os.path.join('/ifs/scratch/pimri/soccog/test_working/7474/anat-1-1', f)
       new = os.path.join('/ifs/scratch/pimri/soccog/test_working/7474/anat-1-1', f + '.dcm')
       os.rename(old, new)
qsub_cnv_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7474/anat-1-1', '7474_anat-1-1', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cnv')
#qsub_cln_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7474/anat-1-1', '7474_anat-1-1', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cln')
