disp ('Executing -r cnvdcm_ds973428_160_fspgrQuad_s11d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7414/anat/s973428_160_fspgrQuad_s11/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7414/anat/s973428_160_fspgrQuad_s11/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7414/anat/s973428_160_fspgrQuad_s11/dicoms/anonout')
spm_dicom_convert(hdr)
exit()