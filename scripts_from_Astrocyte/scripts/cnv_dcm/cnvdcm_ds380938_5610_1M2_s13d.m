disp ('Executing -r cnvdcm_ds380938_5610_1M2_s13d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7542/func/s380938_5610_1M2_s13/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7542/func/s380938_5610_1M2_s13/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7542/func/s380938_5610_1M2_s13/dicoms/anonout')
spm_dicom_convert(hdr)
exit()