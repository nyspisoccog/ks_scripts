disp ('Executing -r cnvdcm_ds2486841_5610_2M6_s34d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7477/func/s2486841_5610_2M6_s34/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7477/func/s2486841_5610_2M6_s34/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7477/func/s2486841_5610_2M6_s34/dicoms/anonout')
spm_dicom_convert(hdr)
exit()