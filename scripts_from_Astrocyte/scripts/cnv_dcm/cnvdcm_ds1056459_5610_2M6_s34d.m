disp ('Executing -r cnvdcm_ds1056459_5610_2M6_s34d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7436/func/s1056459_5610_2M6_s34/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7436/func/s1056459_5610_2M6_s34/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7436/func/s1056459_5610_2M6_s34/dicoms/anonout')
spm_dicom_convert(hdr)
exit()