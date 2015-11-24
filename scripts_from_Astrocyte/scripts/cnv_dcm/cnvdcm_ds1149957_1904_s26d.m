disp ('Executing -r cnvdcm_ds1149957_1904_s26d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7418/func/s1149957_1904_s26/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7418/func/s1149957_1904_s26/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7418/func/s1149957_1904_s26/dicoms/anonout')
spm_dicom_convert(hdr)
exit()