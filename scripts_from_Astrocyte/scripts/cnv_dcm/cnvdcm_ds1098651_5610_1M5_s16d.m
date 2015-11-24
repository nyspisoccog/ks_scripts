disp ('Executing -r cnvdcm_ds1098651_5610_1M5_s16d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7453/func/s1098651_5610_1M5_s16/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7453/func/s1098651_5610_1M5_s16/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7453/func/s1098651_5610_1M5_s16/dicoms/anonout')
spm_dicom_convert(hdr)
exit()