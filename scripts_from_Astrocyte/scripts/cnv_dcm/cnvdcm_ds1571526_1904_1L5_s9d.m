disp ('Executing -r cnvdcm_ds1571526_1904_1L5_s9d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7404/func/s1571526_1904_1L5_s9/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7404/func/s1571526_1904_1L5_s9/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7404/func/s1571526_1904_1L5_s9/dicoms/anonout')
spm_dicom_convert(hdr)
exit()