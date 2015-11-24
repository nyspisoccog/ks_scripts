disp ('Executing -r cnvdcm_ds4356310_1904_1L2_s4d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7580/func/s4356310_1904_1L2_s4/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7580/func/s4356310_1904_1L2_s4/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7580/func/s4356310_1904_1L2_s4/dicoms/anonout')
spm_dicom_convert(hdr)
exit()