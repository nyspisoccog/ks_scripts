disp ('Executing -r cnvdcm_ds160819_1904_1L6_s8d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7533/func/s160819_1904_1L6_s8/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7533/func/s160819_1904_1L6_s8/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7533/func/s160819_1904_1L6_s8/dicoms/anonout')
spm_dicom_convert(hdr)
exit()