disp ('Executing -r cnvdcm_ds3682887_1904_2L2_s19d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7613/func/s3682887_1904_2L2_s19/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7613/func/s3682887_1904_2L2_s19/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7613/func/s3682887_1904_2L2_s19/dicoms/anonout')
spm_dicom_convert(hdr)
exit()