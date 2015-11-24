disp ('Executing -r cnvdcm_ds246952_5610_s34d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7648/func/s246952_5610_s34/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7648/func/s246952_5610_s34/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7648/func/s246952_5610_s34/dicoms/anonout')
spm_dicom_convert(hdr)
exit()