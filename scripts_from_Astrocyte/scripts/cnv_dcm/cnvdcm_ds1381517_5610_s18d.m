disp ('Executing -r cnvdcm_ds1381517_5610_s18d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7412/func/s1381517_5610_s18/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7412/func/s1381517_5610_s18/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7412/func/s1381517_5610_s18/dicoms/anonout')
spm_dicom_convert(hdr)
exit()