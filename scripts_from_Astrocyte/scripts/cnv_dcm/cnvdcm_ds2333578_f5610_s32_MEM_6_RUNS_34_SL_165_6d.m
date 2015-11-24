disp ('Executing -r cnvdcm_ds2333578_f5610_s32_MEM_6_RUNS_34_SL_165_6d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7638/func/s2333578_f5610_s32_MEM_6_RUNS_34_SL_165_6/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7638/func/s2333578_f5610_s32_MEM_6_RUNS_34_SL_165_6/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7638/func/s2333578_f5610_s32_MEM_6_RUNS_34_SL_165_6/dicoms/anonout')
spm_dicom_convert(hdr)
exit()