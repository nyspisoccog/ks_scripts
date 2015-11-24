disp ('Executing -r cnvdcm_ds1503538_2550_2L2_s21d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7403/func/s1503538_2550_2L2_s21/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7403/func/s1503538_2550_2L2_s21/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7403/func/s1503538_2550_2L2_s21/dicoms/anonout')
spm_dicom_convert(hdr)
exit()