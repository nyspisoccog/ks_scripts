disp ('Executing -r cnvdcm_ds987980_166_fspgr_s10d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7714/anat/s987980_166_fspgr_s10/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7714/anat/s987980_166_fspgr_s10/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7714/anat/s987980_166_fspgr_s10/dicoms/anonout')
spm_dicom_convert(hdr)
exit()