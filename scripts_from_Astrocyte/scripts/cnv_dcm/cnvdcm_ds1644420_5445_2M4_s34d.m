disp ('Executing -r cnvdcm_ds1644420_5445_2M4_s34d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7443/func/s1644420_5445_2M4_s34/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7443/func/s1644420_5445_2M4_s34/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7443/func/s1644420_5445_2M4_s34/dicoms/anonout')
spm_dicom_convert(hdr)
exit()