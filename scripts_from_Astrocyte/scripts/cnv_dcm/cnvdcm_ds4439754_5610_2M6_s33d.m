disp ('Executing -r cnvdcm_ds4439754_5610_2M6_s33d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7580/func/s4439754_5610_2M6_s33/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7580/func/s4439754_5610_2M6_s33/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7580/func/s4439754_5610_2M6_s33/dicoms/anonout')
spm_dicom_convert(hdr)
exit()