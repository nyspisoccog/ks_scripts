disp ('Executing -r cnvdcm_ds953811_5610_s36d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7408/func/s953811_5610_s36/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7408/func/s953811_5610_s36/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7408/func/s953811_5610_s36/dicoms/anonout')
spm_dicom_convert(hdr)
exit()