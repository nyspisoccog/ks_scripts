disp ('Executing -r cnvdcm_ds2259358_f9_s1_3_P_Localizerd')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7638/func/s2259358_f9_s1_3_P_Localizer/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7638/func/s2259358_f9_s1_3_P_Localizer/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7638/func/s2259358_f9_s1_3_P_Localizer/dicoms/anonout')
spm_dicom_convert(hdr)
exit()