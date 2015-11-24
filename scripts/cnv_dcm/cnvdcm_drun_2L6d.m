disp ('Executing -r cnvdcm_drun_2L6d')
addpath('/ifs/scratch/pimri/core/software/SPM/8-latest/spm8');
disp ('/ifs/scratch/pimri/soccog/7648/func/run_2L6/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7648/func/run_2L6/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7648/func/run_2L6/dicoms/anonout')
spm_dicom_convert(hdr)
exit()