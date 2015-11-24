disp ('Executing -r cnvdcm_ds3669750_5610_1M5_s15d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7613/func/s3669750_5610_1M5_s15/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7613/func/s3669750_5610_1M5_s15/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7613/func/s3669750_5610_1M5_s15/dicoms/anonout')
spm_dicom_convert(hdr)
exit()