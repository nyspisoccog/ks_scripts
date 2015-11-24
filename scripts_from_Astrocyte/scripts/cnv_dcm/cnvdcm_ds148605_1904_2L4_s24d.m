disp ('Executing -r cnvdcm_ds148605_1904_2L4_s24d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7623/func/s148605_1904_2L4_s24/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7623/func/s148605_1904_2L4_s24/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7623/func/s148605_1904_2L4_s24/dicoms/anonout')
spm_dicom_convert(hdr)
exit()