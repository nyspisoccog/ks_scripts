disp ('Executing -r cnvdcm_ds1028237_166_SPGR4_s28d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7436/anat/s1028237_166_SPGR4_s28/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7436/anat/s1028237_166_SPGR4_s28/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7436/anat/s1028237_166_SPGR4_s28/dicoms/anonout')
spm_dicom_convert(hdr)
exit()