from __future__ import with_statement
import os, csv, shutil,tarfile, uf, dcm_ops
dest_root = '/ifs/scratch/pimri/soccog/test_working'
dst_path_lst = ['7478', 'anat-2-2']
uf.buildtree(dest_root, dst_path_lst)
uf.copytree('/ifs/scratch/pimri/soccog/old/SocCog_Raw_Data_By_Exam_Number/2489/E2489_e1477970/s1535153_166_SPGR4_s28', '/ifs/scratch/pimri/soccog/test_working/7478/anat-2-2')
t = tarfile.open(os.path.join('/ifs/scratch/pimri/soccog/test_working/7478/anat-2-2','MRDC_files.tar.gz'), 'r')
t.extractall('/ifs/scratch/pimri/soccog/test_working/7478/anat-2-2')
for f in os.listdir('/ifs/scratch/pimri/soccog/test_working/7478/anat-2-2'):
   if 'MRDC' in f and 'gz' not in f:
       old = os.path.join('/ifs/scratch/pimri/soccog/test_working/7478/anat-2-2', f)
       new = os.path.join('/ifs/scratch/pimri/soccog/test_working/7478/anat-2-2', f + '.dcm')
       os.rename(old, new)
qsub_cnv_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7478/anat-2-2', '7478_anat-2-2', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cnv')
#qsub_cln_out = dcm_ops.cnv_dcm('/ifs/scratch/pimri/soccog/test_working/7478/anat-2-2', '7478_anat-2-2', '/ifs/scratch/pimri/soccog/scripts/mastersort/scripts_dir/cln')
