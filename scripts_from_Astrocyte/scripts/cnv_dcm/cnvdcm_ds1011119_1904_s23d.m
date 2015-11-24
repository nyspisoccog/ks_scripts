disp ('Executing -r cnvdcm_ds1011119_1904_s23d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7414/func/s1011119_1904_s23/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7414/func/s1011119_1904_s23/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7414/func/s1011119_1904_s23/dicoms/anonout')
spm_dicom_convert(hdr)
exit()