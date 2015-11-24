disp ('Executing -r cnvdcm_ds3830949_5610d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7430/func/s3830949_5610/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7430/func/s3830949_5610/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7430/func/s3830949_5610/dicoms/anonout')
spm_dicom_convert(hdr)
exit()