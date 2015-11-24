disp ('Executing -r cnvdcm_ds1641598_164_SPGR3_s30d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7404/anat/s1641598_164_SPGR3_s30/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7404/anat/s1641598_164_SPGR3_s30/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7404/anat/s1641598_164_SPGR3_s30/dicoms/anonout')
spm_dicom_convert(hdr)
exit()