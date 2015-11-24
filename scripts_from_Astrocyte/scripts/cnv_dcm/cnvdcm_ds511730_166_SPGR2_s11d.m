disp ('Executing -r cnvdcm_ds511730_166_SPGR2_s11d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7480/anat/s511730_166_SPGR2_s11/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7480/anat/s511730_166_SPGR2_s11/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7480/anat/s511730_166_SPGR2_s11/dicoms/anonout')
spm_dicom_convert(hdr)
exit()