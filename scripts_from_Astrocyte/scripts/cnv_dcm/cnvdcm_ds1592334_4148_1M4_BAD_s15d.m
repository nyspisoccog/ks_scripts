disp ('Executing -r cnvdcm_ds1592334_4148_1M4_BAD_s15d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7404/func/s1592334_4148_1M4_BAD_s15/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7404/func/s1592334_4148_1M4_BAD_s15/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7404/func/s1592334_4148_1M4_BAD_s15/dicoms/anonout')
spm_dicom_convert(hdr)
exit()