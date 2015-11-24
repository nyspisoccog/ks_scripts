disp ('Executing -r cnvdcm_ds1655312_5445_2M6_s36d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7443/func/s1655312_5445_2M6_s36/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7443/func/s1655312_5445_2M6_s36/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7443/func/s1655312_5445_2M6_s36/dicoms/anonout')
spm_dicom_convert(hdr)
exit()