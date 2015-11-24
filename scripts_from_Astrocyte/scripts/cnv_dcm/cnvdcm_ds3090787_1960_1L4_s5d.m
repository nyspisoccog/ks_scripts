disp ('Executing -r cnvdcm_ds3090787_1960_1L4_s5d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7562/func/s3090787_1960_1L4_s5/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7562/func/s3090787_1960_1L4_s5/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7562/func/s3090787_1960_1L4_s5/dicoms/anonout')
spm_dicom_convert(hdr)
exit()