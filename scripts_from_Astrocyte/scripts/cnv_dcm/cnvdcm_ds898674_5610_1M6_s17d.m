disp ('Executing -r cnvdcm_ds898674_5610_1M6_s17d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7575/func/s898674_5610_1M6_s17/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7575/func/s898674_5610_1M6_s17/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7575/func/s898674_5610_1M6_s17/dicoms/anonout')
spm_dicom_convert(hdr)
exit()