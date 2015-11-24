disp ('Executing -r cnvdcm_ds2430281_5610_1M4_s16d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7477/func/s2430281_5610_1M4_s16/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7477/func/s2430281_5610_1M4_s16/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7477/func/s2430281_5610_1M4_s16/dicoms/anonout')
spm_dicom_convert(hdr)
exit()