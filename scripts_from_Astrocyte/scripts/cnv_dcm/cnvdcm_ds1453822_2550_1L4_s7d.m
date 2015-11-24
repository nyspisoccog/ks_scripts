disp ('Executing -r cnvdcm_ds1453822_2550_1L4_s7d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7403/func/s1453822_2550_1L4_s7/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7403/func/s1453822_2550_1L4_s7/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7403/func/s1453822_2550_1L4_s7/dicoms/anonout')
spm_dicom_convert(hdr)
exit()