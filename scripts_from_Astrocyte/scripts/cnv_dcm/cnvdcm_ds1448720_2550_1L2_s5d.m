disp ('Executing -r cnvdcm_ds1448720_2550_1L2_s5d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7403/func/s1448720_2550_1L2_s5/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7403/func/s1448720_2550_1L2_s5/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7403/func/s1448720_2550_1L2_s5/dicoms/anonout')
spm_dicom_convert(hdr)
exit()