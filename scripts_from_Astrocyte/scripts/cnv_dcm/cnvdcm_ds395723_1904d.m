disp ('Executing -r cnvdcm_ds395723_1904d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7641/func/s395723_1904/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7641/func/s395723_1904/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7641/func/s395723_1904/dicoms/anonout')
spm_dicom_convert(hdr)
exit()