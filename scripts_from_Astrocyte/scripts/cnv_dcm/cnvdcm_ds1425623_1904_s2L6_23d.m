disp ('Executing -r cnvdcm_ds1425623_1904_s2L6_23d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7645/func/s1425623_1904_s2L6_23/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7645/func/s1425623_1904_s2L6_23/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7645/func/s1425623_1904_s2L6_23/dicoms/anonout')
spm_dicom_convert(hdr)
exit()