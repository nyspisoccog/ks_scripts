disp ('Executing -r cnvdcm_ds3142196_166_fspgr_s26d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7562/anat/s3142196_166_fspgr_s26/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7562/anat/s3142196_166_fspgr_s26/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7562/anat/s3142196_166_fspgr_s26/dicoms/anonout')
spm_dicom_convert(hdr)
exit()