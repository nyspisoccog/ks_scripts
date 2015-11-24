disp ('Executing -r cnvdcm_ds1052576_160_fspgr8ch_s35d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7414/anat/s1052576_160_fspgr8ch_s35/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7414/anat/s1052576_160_fspgr8ch_s35/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7414/anat/s1052576_160_fspgr8ch_s35/dicoms/anonout')
spm_dicom_convert(hdr)
exit()