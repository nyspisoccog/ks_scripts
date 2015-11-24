disp ('Executing -r cnvdcm_ds1618444_1848_2L2_s22d')
addpath('/ifs/scratch/pimri/core/fmri/spm8');
disp ('/ifs/scratch/pimri/soccog/7443/func/s1618444_1848_2L2_s22/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7443/func/s1618444_1848_2L2_s22/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7443/func/s1618444_1848_2L2_s22/dicoms/anonout')
spm_dicom_convert(hdr)
exit()