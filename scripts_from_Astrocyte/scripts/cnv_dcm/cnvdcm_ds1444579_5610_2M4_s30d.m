disp ('Executing -r cnvdcm_ds1444579_5610_2M4_s30d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7645/func/s1444579_5610_2M4_s30/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7645/func/s1444579_5610_2M4_s30/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7645/func/s1444579_5610_2M4_s30/dicoms/anonout')
spm_dicom_convert(hdr)
exit()