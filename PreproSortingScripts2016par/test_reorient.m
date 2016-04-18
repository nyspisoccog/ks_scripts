


reo_path = '/Volumes/LaCie/LaPrivate/soccog/August2014snapshot/reoriented_data';
orig_path = '/Volumes/LaCie/LaPrivate/soccog/August2014snapshot/sorted_img'
new_orig_path = '/Volumes/LaCie/LaPrivate/soccog/preproc_data_new';

orig_anat_7404_f2 = fullfile(orig_path, '7404', 'spare_anat', 'anat-2-1', 's000001.hdr');
orig_anat_7404_v2 = spm_vol(orig_anat_7404_f2);
orig_anat_7404_m2 = orig_anat_7404_v2.mat;
orig_func_7404_2L1_f1 = fullfile(orig_path, '7404', 'func', 'run2L1', 'f000001.hdr');
orig_func_7404_2L1_v1 = spm_vol(orig_func_7404_2L1_f1);
orig_func_7404_2L1_m1 = orig_func_7404_2L1_v1.mat;
reod_anat_7404_f2 = fullfile(reo_path, '7404', 'spare_anat', 'anat-2-1', 's000001.hdr');
reod_anat_7404_v2 = spm_vol(reod_anat_7404_f2);
reod_anat_7404_m2 = reod_anat_7404_v2.mat;
reod_func_7404_2L1_f1 = fullfile(reo_path, '7404', 'func', 'run2L1', 'f000001.hdr');
reod_func_7404_2L1_v1 = spm_vol(reod_func_7404_2L1_f1);
reod_func_7404_2L1_m1 = reod_func_7404_2L1_v1.mat;
new_orig_anat_f2 = fullfile(new_orig_path, '7404', 'spare_anat', 'anat-2-1', ...
    's7404-0030-00001-000001-01.nii');
new_orig_anat_7404_v2 = spm_vol(new_orig_anat_f2);
new_orig_anat_7404_m2 = new_orig_anat_7404_v2.mat;
new_orig_func_7404_2L1_f1 = fullfile(new_orig_path, '7404', 'func', 'run2L1', '7404run2L14D.nii');
new_orig_func_7404_2L1_v1 = spm_vol(new_orig_func_7404_2L1_f1);
new_orig_func_7404_2L1_m1 = new_orig_func_7404_2L1_v1(1).mat;

reomat_I_calculate = reod_anat_7404_m2*inv(new_orig_anat_7404_m2);
resulting_anat_reod_mat = reomat_I_calculate * new_orig_anat_7404_m2;
resulting_func_reod_mat = reomat_I_calculate * new_orig_func_7404_2L1_m1;