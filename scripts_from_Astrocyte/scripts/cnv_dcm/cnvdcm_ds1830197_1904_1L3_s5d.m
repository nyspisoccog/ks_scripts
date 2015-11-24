disp ('Executing -r cnvdcm_ds1830197_1904_1L3_s5d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7659/func/s1830197_1904_1L3_s5/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7659/func/s1830197_1904_1L3_s5/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7659/func/s1830197_1904_1L3_s5/dicoms/anonout')
spm_dicom_convert(hdr)
exit()