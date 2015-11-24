disp ('Executing -r cnvdcm_ds3692453_166_fspgr_s25d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7613/anat/s3692453_166_fspgr_s25/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7613/anat/s3692453_166_fspgr_s25/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7613/anat/s3692453_166_fspgr_s25/dicoms/anonout')
spm_dicom_convert(hdr)
exit()