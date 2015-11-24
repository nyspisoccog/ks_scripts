disp ('Executing -r cnvdcm_ds959424d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7408/anat/e959423_fspgr/s959424/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7408/anat/e959423_fspgr/s959424/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7408/anat/e959423_fspgr/s959424/dicoms/anonout')
spm_dicom_convert(hdr)
exit()