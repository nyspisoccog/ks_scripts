disp ('Executing -r cnvdcm_ds1456373_2550_1L5_s8d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7403/func/s1456373_2550_1L5_s8/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7403/func/s1456373_2550_1L5_s8/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7403/func/s1456373_2550_1L5_s8/dicoms/anonout')
spm_dicom_convert(hdr)
exit()