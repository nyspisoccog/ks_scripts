disp ('Executing -r cnvdcm_ds1184398_5610_1M4_s17d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7458/func/s1184398_5610_1M4_s17/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7458/func/s1184398_5610_1M4_s17/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7458/func/s1184398_5610_1M4_s17/dicoms/anonout')
spm_dicom_convert(hdr)
exit()