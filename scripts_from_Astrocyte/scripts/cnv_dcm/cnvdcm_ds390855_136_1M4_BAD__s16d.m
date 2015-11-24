disp ('Executing -r cnvdcm_ds390855_136_1M4_BAD__s16d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7533/func/s390855_136_1M4_BAD__s16/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7533/func/s390855_136_1M4_BAD__s16/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7533/func/s390855_136_1M4_BAD__s16/dicoms/anonout')
spm_dicom_convert(hdr)
exit()