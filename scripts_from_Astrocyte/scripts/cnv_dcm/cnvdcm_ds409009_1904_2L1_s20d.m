disp ('Executing -r cnvdcm_ds409009_1904_2L1_s20d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7542/func/s409009_1904_2L1_s20/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7542/func/s409009_1904_2L1_s20/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7542/func/s409009_1904_2L1_s20/dicoms/anonout')
spm_dicom_convert(hdr)
exit()