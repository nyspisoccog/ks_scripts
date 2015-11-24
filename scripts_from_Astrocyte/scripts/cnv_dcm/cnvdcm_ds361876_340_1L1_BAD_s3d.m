disp ('Executing -r cnvdcm_ds361876_340_1L1_BAD_s3d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7533/func/s361876_340_1L1_BAD_s3/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7533/func/s361876_340_1L1_BAD_s3/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7533/func/s361876_340_1L1_BAD_s3/dicoms/anonout')
spm_dicom_convert(hdr)
exit()