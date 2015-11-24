disp ('Executing -r cnvdcm_ds1207270_1904_2L4_s25d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7458/func/s1207270_1904_2L4_s25/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7458/func/s1207270_1904_2L4_s25/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7458/func/s1207270_1904_2L4_s25/dicoms/anonout')
spm_dicom_convert(hdr)
exit()