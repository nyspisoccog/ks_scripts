disp ('Executing -r cnvdcm_ds2284741_5610_2M1_s31d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7474/func/s2284741_5610_2M1_s31/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7474/func/s2284741_5610_2M1_s31/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7474/func/s2284741_5610_2M1_s31/dicoms/anonout')
spm_dicom_convert(hdr)
exit()