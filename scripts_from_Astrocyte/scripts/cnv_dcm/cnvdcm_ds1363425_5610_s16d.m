disp ('Executing -r cnvdcm_ds1363425_5610_s16d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7719/func/s1363425_5610_s16/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7719/func/s1363425_5610_s16/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7719/func/s1363425_5610_s16/dicoms/anonout')
spm_dicom_convert(hdr)
exit()