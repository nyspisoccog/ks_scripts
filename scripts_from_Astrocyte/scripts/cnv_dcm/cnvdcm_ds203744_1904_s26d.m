disp ('Executing -r cnvdcm_ds203744_1904_s26d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7607/func/s203744_1904_s26/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7607/func/s203744_1904_s26/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7607/func/s203744_1904_s26/dicoms/anonout')
spm_dicom_convert(hdr)
exit()