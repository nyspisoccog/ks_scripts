disp ('Executing -r cnvdcm_ds1864693_5610_1M5_s17d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7659/func/s1864693_5610_1M5_s17/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7659/func/s1864693_5610_1M5_s17/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7659/func/s1864693_5610_1M5_s17/dicoms/anonout')
spm_dicom_convert(hdr)
exit()