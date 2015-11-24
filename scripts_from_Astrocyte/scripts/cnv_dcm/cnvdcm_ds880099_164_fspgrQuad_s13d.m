disp ('Executing -r cnvdcm_ds880099_164_fspgrQuad_s13d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7408/anat/s880099_164_fspgrQuad_s13/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7408/anat/s880099_164_fspgrQuad_s13/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7408/anat/s880099_164_fspgrQuad_s13/dicoms/anonout')
spm_dicom_convert(hdr)
exit()