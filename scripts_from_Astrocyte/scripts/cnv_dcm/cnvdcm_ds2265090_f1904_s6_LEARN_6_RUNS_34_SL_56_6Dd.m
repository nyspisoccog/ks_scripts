disp ('Executing -r cnvdcm_ds2265090_f1904_s6_LEARN_6_RUNS_34_SL_56_6Dd')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7638/func/s2265090_f1904_s6_LEARN_6_RUNS_34_SL_56_6D/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7638/func/s2265090_f1904_s6_LEARN_6_RUNS_34_SL_56_6D/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7638/func/s2265090_f1904_s6_LEARN_6_RUNS_34_SL_56_6D/dicoms/anonout')
spm_dicom_convert(hdr)
exit()