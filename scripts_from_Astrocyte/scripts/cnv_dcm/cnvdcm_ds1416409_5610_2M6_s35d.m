disp ('Executing -r cnvdcm_ds1416409_5610_2M6_s35d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7432/func/s1416409_5610_2M6_s35/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7432/func/s1416409_5610_2M6_s35/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7432/func/s1416409_5610_2M6_s35/dicoms/anonout')
spm_dicom_convert(hdr)
exit()