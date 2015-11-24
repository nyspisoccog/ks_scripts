disp ('Executing -r cnvdcm_ds925591_164_fspgrQuad_s30d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7408/anat/s925591_164_fspgrQuad_s30/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7408/anat/s925591_164_fspgrQuad_s30/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7408/anat/s925591_164_fspgrQuad_s30/dicoms/anonout')
spm_dicom_convert(hdr)
exit()