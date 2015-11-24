disp ('Executing -r cnvdcm_ds522912_5610_2M2_s4d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7508/func/s522912_5610_2M2_s4/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7508/func/s522912_5610_2M2_s4/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7508/func/s522912_5610_2M2_s4/dicoms/anonout')
spm_dicom_convert(hdr)
exit()