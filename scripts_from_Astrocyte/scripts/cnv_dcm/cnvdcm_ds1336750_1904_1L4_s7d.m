disp ('Executing -r cnvdcm_ds1336750_1904_1L4_s7d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7432/func/s1336750_1904_1L4_s7/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7432/func/s1336750_1904_1L4_s7/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7432/func/s1336750_1904_1L4_s7/dicoms/anonout')
spm_dicom_convert(hdr)
exit()