disp ('Executing -r cnvdcm_ds2948510_1904_1L2_s3d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7561/func/s2948510_1904_1L2_s3/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7561/func/s2948510_1904_1L2_s3/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7561/func/s2948510_1904_1L2_s3/dicoms/anonout')
spm_dicom_convert(hdr)
exit()