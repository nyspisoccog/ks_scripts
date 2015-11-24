disp ('Executing -r cnvdcm_ds971069_1904_1L1_s3d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7436/func/s971069_1904_1L1_s3/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7436/func/s971069_1904_1L1_s3/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7436/func/s971069_1904_1L1_s3/dicoms/anonout')
spm_dicom_convert(hdr)
exit()