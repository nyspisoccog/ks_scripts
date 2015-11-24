disp ('Executing -r cnvdcm_ds165724_5610_2M3_s31d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7623/func/s165724_5610_2M3_s31/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7623/func/s165724_5610_2M3_s31/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7623/func/s165724_5610_2M3_s31/dicoms/anonout')
spm_dicom_convert(hdr)
exit()