disp ('Executing -r cnvdcm_ds1382088_166_fspgr_s9d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7645/anat/s1382088_166_fspgr_s9/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7645/anat/s1382088_166_fspgr_s9/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7645/anat/s1382088_166_fspgr_s9/dicoms/anonout')
spm_dicom_convert(hdr)
exit()