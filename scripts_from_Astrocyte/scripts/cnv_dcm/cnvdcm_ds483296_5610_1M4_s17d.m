disp ('Executing -r cnvdcm_ds483296_5610_1M4_s17d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7534/func/s483296_5610_1M4_s17/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7534/func/s483296_5610_1M4_s17/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7534/func/s483296_5610_1M4_s17/dicoms/anonout')
spm_dicom_convert(hdr)
exit()