disp ('Executing -r cnvdcm_ds1111884_5610_s12d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7418/func/s1111884_5610_s12/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7418/func/s1111884_5610_s12/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7418/func/s1111884_5610_s12/dicoms/anonout')
spm_dicom_convert(hdr)
exit()