% Set up the SPM defaults, just in case
addpath('/home/katie/ks_scripts/matlab_scripts')
spm('defaults', 'fmri');
V1 = spm_vol(fullfile('/media/truecrypt1/SocCog/results/noMV_noval_1stvs2nd_wbp/lrn', '7726', 'beta_0001.img'));
img1 = spm_read_vols(V1);
[maxVal,maxInd] = max(img1(:));
size(img1)
img(41, 37, 38)
