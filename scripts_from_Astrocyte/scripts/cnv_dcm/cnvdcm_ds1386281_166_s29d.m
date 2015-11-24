disp ('Executing -r cnvdcm_ds1386281_166_s29d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7719/anat/s1386281_166_s29/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7719/anat/s1386281_166_s29/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7719/anat/s1386281_166_s29/dicoms/anonout')
spm_dicom_convert(hdr)
exit()