disp ('Executing -r cnvdcm_ds352349_166d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7641/anat/s352349_166/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7641/anat/s352349_166/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7641/anat/s352349_166/dicoms/anonout')
spm_dicom_convert(hdr)
exit()