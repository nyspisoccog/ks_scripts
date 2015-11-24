disp ('Executing -r cnvdcm_ds3639311_1904_1L3_s4d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7613/func/s3639311_1904_1L3_s4/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7613/func/s3639311_1904_1L3_s4/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7613/func/s3639311_1904_1L3_s4/dicoms/anonout')
spm_dicom_convert(hdr)
exit()