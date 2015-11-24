disp ('Executing -r cnvdcm_ds2270991_f170_s11_SAG3D_FSPGR_11_Flip_1_NEXd')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7638/anat/s2270991_f170_s11_SAG3D_FSPGR_11_Flip_1_NEX/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7638/anat/s2270991_f170_s11_SAG3D_FSPGR_11_Flip_1_NEX/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7638/anat/s2270991_f170_s11_SAG3D_FSPGR_11_Flip_1_NEX/dicoms/anonout')
spm_dicom_convert(hdr)
exit()