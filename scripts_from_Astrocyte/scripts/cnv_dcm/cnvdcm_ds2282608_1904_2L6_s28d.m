disp ('Executing -r cnvdcm_ds2282608_1904_2L6_s28d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7474/func/s2282608_1904_2L6_s28/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7474/func/s2282608_1904_2L6_s28/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7474/func/s2282608_1904_2L6_s28/dicoms/anonout')
spm_dicom_convert(hdr)
exit()