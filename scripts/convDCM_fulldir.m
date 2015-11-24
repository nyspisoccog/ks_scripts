addpath('/ifs/scratch/pimri/core/fmri/spm8');
display('/ifs/scratch/pimri/soccog/7403/anat/s1461475_160_fspgrquad_s10/dicoms/anonout')
files = spm_select('FPList', '/ifs/scratch/pimri/soccog/7403/anat/s1461475_160_fspgrquad_s10/dicoms/anonout', '\.dcm');
spm_defaults;
hdr = spm_dicom_headers(files)
cd('/ifs/scratch/pimri/soccog/7403/anat/s1461475_160_fspgrquad_s10/dicoms/anonout')
spm_dicom_convert(hdr)
