disp ('Executing -r cnvdcm_ds994116_5610_1M3_s14d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7436/func/s994116_5610_1M3_s14/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7436/func/s994116_5610_1M3_s14/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7436/func/s994116_5610_1M3_s14/dicoms/anonout')
spm_dicom_convert(hdr)
exit()