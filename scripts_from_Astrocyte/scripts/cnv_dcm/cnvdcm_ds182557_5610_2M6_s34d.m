disp ('Executing -r cnvdcm_ds182557_5610_2M6_s34d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7623/func/s182557_5610_2M6_s34/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7623/func/s182557_5610_2M6_s34/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7623/func/s182557_5610_2M6_s34/dicoms/anonout')
spm_dicom_convert(hdr)
exit()