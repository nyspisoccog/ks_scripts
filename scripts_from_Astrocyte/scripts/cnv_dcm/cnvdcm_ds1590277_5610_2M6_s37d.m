disp ('Executing -r cnvdcm_ds1590277_5610_2M6_s37d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7619/func/s1590277_5610_2M6_s37/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7619/func/s1590277_5610_2M6_s37/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7619/func/s1590277_5610_2M6_s37/dicoms/anonout')
spm_dicom_convert(hdr)
exit()