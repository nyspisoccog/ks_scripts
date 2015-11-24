disp ('Executing -r cnvdcm_ds1594135_5610_1M3_s15d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7443/func/s1594135_5610_1M3_s15/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7443/func/s1594135_5610_1M3_s15/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7443/func/s1594135_5610_1M3_s15/dicoms/anonout')
spm_dicom_convert(hdr)
exit()