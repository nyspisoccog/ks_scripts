disp ('Executing -r cnvdcm_ds1382422_5610_1M1_s11d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7645/func/s1382422_5610_1M1_s11/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7645/func/s1382422_5610_1M1_s11/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7645/func/s1382422_5610_1M1_s11/dicoms/anonout')
spm_dicom_convert(hdr)
exit()