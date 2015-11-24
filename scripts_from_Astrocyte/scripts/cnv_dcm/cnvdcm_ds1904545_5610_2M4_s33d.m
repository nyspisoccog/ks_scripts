disp ('Executing -r cnvdcm_ds1904545_5610_2M4_s33d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7659/func/s1904545_5610_2M4_s33/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7659/func/s1904545_5610_2M4_s33/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7659/func/s1904545_5610_2M4_s33/dicoms/anonout')
spm_dicom_convert(hdr)
exit()