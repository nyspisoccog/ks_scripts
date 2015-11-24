% Set up the SPM defaults, just in case
addpath('/home/katie/ks_scripts/matlab_scripts')
disp('hello')
spm('defaults', 'fmri');
2+2
V = spm_vol(fullfile('/media/truecrypt1/SocCog/results/noMV_noval_1stvs2nd_wbp/lrn', '7726', 'beta_0001.img'));