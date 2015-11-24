disp ('Executing -r cnvdcm_ds1433357_5610_2M2_s28d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7645/func/s1433357_5610_2M2_s28/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7645/func/s1433357_5610_2M2_s28/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7645/func/s1433357_5610_2M2_s28/dicoms/anonout')
spm_dicom_convert(hdr)
exit()