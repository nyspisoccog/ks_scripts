disp ('Executing -r cnvdcm_ds1639693_1904_2L6_s29d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7404/func/s1639693_1904_2L6_s29/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7404/func/s1639693_1904_2L6_s29/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7404/func/s1639693_1904_2L6_s29/dicoms/anonout')
spm_dicom_convert(hdr)
exit()