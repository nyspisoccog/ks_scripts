disp ('Executing -r cnvdcm_ds409032_5610d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7641/func/s409032_5610/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7641/func/s409032_5610/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7641/func/s409032_5610/dicoms/anonout')
spm_dicom_convert(hdr)
exit()