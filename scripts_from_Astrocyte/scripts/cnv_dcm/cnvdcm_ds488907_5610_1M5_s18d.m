disp ('Executing -r cnvdcm_ds488907_5610_1M5_s18d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7534/func/s488907_5610_1M5_s18/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7534/func/s488907_5610_1M5_s18/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7534/func/s488907_5610_1M5_s18/dicoms/anonout')
spm_dicom_convert(hdr)
exit()