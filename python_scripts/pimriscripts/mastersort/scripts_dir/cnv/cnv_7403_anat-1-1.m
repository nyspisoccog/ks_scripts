disp ('Executing -r cnv_7403_anat-1-1.m')
addpath('/ifs/scratch/pimri/core/software/SPM/8-latest/spm8');
disp ('/ifs/scratch/pimri/soccog/test_working/7403/anat-1-1')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/test_working/7403/anat-1-1', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/test_working/7403/anat-1-1')
spm_dicom_convert(hdr)
logname = fullfile('/ifs/scratch/pimri/soccog/test_working/7403/anat-1-1, 'cnv_complete.txt');
log = fopen(logname,'wt');
frintf(log, 'done');
fclose(log);
exit()