disp ('Executing -r cnvdcm_ds2407527_1904_1L4_s8d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7477/func/s2407527_1904_1L4_s8/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7477/func/s2407527_1904_1L4_s8/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7477/func/s2407527_1904_1L4_s8/dicoms/anonout')
spm_dicom_convert(hdr)
exit()