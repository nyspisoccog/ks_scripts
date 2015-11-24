disp ('Executing -r cnvdcm_ds1616595_1848_2L1_s21d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7443/func/s1616595_1848_2L1_s21/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7443/func/s1616595_1848_2L1_s21/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7443/func/s1616595_1848_2L1_s21/dicoms/anonout')
spm_dicom_convert(hdr)
exit()