disp ('Executing -r cnvdcm_ds1513742_2550_2L6_s25d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7403/func/s1513742_2550_2L6_s25/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7403/func/s1513742_2550_2L6_s25/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7403/func/s1513742_2550_2L6_s25/dicoms/anonout')
spm_dicom_convert(hdr)
exit()