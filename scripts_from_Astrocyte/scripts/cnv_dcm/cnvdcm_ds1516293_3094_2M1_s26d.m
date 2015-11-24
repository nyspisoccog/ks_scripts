disp ('Executing -r cnvdcm_ds1516293_3094_2M1_s26d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7403/func/s1516293_3094_2M1_s26/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7403/func/s1516293_3094_2M1_s26/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7403/func/s1516293_3094_2M1_s26/dicoms/anonout')
spm_dicom_convert(hdr)
exit()