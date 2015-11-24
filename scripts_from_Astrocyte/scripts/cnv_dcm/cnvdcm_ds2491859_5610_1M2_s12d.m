disp ('Executing -r cnvdcm_ds2491859_5610_1M2_s12d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7558/func/s2491859_5610_1M2_s12/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7558/func/s2491859_5610_1M2_s12/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7558/func/s2491859_5610_1M2_s12/dicoms/anonout')
spm_dicom_convert(hdr)
exit()