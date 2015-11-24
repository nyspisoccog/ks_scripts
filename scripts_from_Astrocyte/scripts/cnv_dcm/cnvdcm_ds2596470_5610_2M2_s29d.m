disp ('Executing -r cnvdcm_ds2596470_5610_2M2_s29d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7726/func/s2596470_5610_2M2_s29/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7726/func/s2596470_5610_2M2_s29/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7726/func/s2596470_5610_2M2_s29/dicoms/anonout')
spm_dicom_convert(hdr)
exit()