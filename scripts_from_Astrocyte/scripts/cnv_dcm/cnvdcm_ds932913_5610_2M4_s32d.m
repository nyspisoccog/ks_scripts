disp ('Executing -r cnvdcm_ds932913_5610_2M4_s32d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7575/func/s932913_5610_2M4_s32/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7575/func/s932913_5610_2M4_s32/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7575/func/s932913_5610_2M4_s32/dicoms/anonout')
spm_dicom_convert(hdr)
exit()