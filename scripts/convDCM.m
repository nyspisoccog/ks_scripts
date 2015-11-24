function img = convDCM(fold)
	addpath('/ifs/scratch/pimri/core/fmri/spm8');
	display(fold)
	files = spm_select('FPList', fold, '\.dcm');
	spm_defaults;
	hdr = spm_dicom_headers(files)
	cd(fold)
	spm_dicom_convert(hdr)
end