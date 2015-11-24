disp ('Executing -r cnvdcm_ds2280703_1904_2L5_s27d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7474/func/s2280703_1904_2L5_s27/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7474/func/s2280703_1904_2L5_s27/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7474/func/s2280703_1904_2L5_s27/dicoms/anonout')
spm_dicom_convert(hdr)
exit()