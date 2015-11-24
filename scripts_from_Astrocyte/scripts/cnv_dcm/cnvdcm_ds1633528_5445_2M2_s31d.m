disp ('Executing -r cnvdcm_ds1633528_5445_2M2_s31d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7443/func/s1633528_5445_2M2_s31/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7443/func/s1633528_5445_2M2_s31/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7443/func/s1633528_5445_2M2_s31/dicoms/anonout')
spm_dicom_convert(hdr)
exit()