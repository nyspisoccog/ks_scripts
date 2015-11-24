disp ('Executing -r cnvdcm_ds868441_164_fspgr8ch_s2d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7408/anat/s868441_164_fspgr8ch_s2/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7408/anat/s868441_164_fspgr8ch_s2/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7408/anat/s868441_164_fspgr8ch_s2/dicoms/anonout')
spm_dicom_convert(hdr)
exit()