disp ('Executing -r cnvdcm_ds1367084_f166_s29_SAG3D_FSPGR_11_Flip_1_NEXd')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7649/anat/s1367084_f166_s29_SAG3D_FSPGR_11_Flip_1_NEX/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7649/anat/s1367084_f166_s29_SAG3D_FSPGR_11_Flip_1_NEX/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7649/anat/s1367084_f166_s29_SAG3D_FSPGR_11_Flip_1_NEX/dicoms/anonout')
spm_dicom_convert(hdr)
exit()