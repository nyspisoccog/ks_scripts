disp ('Executing -r cnvdcm_ds2464397_5610_2M2_s30d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7477/func/s2464397_5610_2M2_s30/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7477/func/s2464397_5610_2M2_s30/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7477/func/s2464397_5610_2M2_s30/dicoms/anonout')
spm_dicom_convert(hdr)
exit()