disp ('Executing -r cnvdcm_ds1075698_166_SPGR1_s10d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7453/anat/s1075698_166_SPGR1_s10/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7453/anat/s1075698_166_SPGR1_s10/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7453/anat/s1075698_166_SPGR1_s10/dicoms/anonout')
spm_dicom_convert(hdr)
exit()