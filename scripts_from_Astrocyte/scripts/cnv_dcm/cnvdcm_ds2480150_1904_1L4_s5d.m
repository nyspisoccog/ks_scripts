disp ('Executing -r cnvdcm_ds2480150_1904_1L4_s5d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7558/func/s2480150_1904_1L4_s5/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7558/func/s2480150_1904_1L4_s5/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7558/func/s2480150_1904_1L4_s5/dicoms/anonout')
spm_dicom_convert(hdr)
exit()