disp ('Executing -r cnvdcm_ds3686697_1904_2L4_s21d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7613/func/s3686697_1904_2L4_s21/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7613/func/s3686697_1904_2L4_s21/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7613/func/s3686697_1904_2L4_s21/dicoms/anonout')
spm_dicom_convert(hdr)
exit()