disp ('Executing -r cnvdcm_ds864555_1904_1L4_s6d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7575/func/s864555_1904_1L4_s6/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7575/func/s864555_1904_1L4_s6/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7575/func/s864555_1904_1L4_s6/dicoms/anonout')
spm_dicom_convert(hdr)
exit()