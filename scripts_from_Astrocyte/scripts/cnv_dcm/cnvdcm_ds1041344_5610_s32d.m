disp ('Executing -r cnvdcm_ds1041344_5610_s32d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7414/func/s1041344_5610_s32/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7414/func/s1041344_5610_s32/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7414/func/s1041344_5610_s32/dicoms/anonout')
spm_dicom_convert(hdr)
exit()