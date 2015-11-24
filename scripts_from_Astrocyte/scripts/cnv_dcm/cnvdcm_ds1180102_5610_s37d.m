disp ('Executing -r cnvdcm_ds1180102_5610_s37d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7418/func/s1180102_5610_s37/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7418/func/s1180102_5610_s37/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7418/func/s1180102_5610_s37/dicoms/anonout')
spm_dicom_convert(hdr)
exit()