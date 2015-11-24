disp ('Executing -r cnvdcm_ds1898934_5610_2M3_s32d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7659/func/s1898934_5610_2M3_s32/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7659/func/s1898934_5610_2M3_s32/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7659/func/s1898934_5610_2M3_s32/dicoms/anonout')
spm_dicom_convert(hdr)
exit()