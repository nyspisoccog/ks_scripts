disp ('Executing -r cnvdcm_ds1151872_160_s28d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7418/anat/s1151872_160_s28/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7418/anat/s1151872_160_s28/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7418/anat/s1151872_160_s28/dicoms/anonout')
spm_dicom_convert(hdr)
exit()