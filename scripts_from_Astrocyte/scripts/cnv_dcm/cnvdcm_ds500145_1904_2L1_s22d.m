disp ('Executing -r cnvdcm_ds500145_1904_2L1_s22d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7534/func/s500145_1904_2L1_s22/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7534/func/s500145_1904_2L1_s22/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7534/func/s500145_1904_2L1_s22/dicoms/anonout')
spm_dicom_convert(hdr)
exit()