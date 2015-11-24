disp ('Executing -r cnvdcm_ds218563_166_s27d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7648/anat/s218563_166_s27/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7648/anat/s218563_166_s27/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7648/anat/s218563_166_s27/dicoms/anonout')
spm_dicom_convert(hdr)
exit()