disp ('Executing -r cnvdcm_ds1418003_1904_2L2_s19d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7645/func/s1418003_1904_2L2_s19/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7645/func/s1418003_1904_2L2_s19/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7645/func/s1418003_1904_2L2_s19/dicoms/anonout')
spm_dicom_convert(hdr)
exit()