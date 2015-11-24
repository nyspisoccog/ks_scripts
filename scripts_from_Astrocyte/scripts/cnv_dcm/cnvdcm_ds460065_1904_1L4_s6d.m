disp ('Executing -r cnvdcm_ds460065_1904_1L4_s6d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7534/func/s460065_1904_1L4_s6/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7534/func/s460065_1904_1L4_s6/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7534/func/s460065_1904_1L4_s6/dicoms/anonout')
spm_dicom_convert(hdr)
exit()