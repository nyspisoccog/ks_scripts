clear all

addpath(genpath('/Users/katherine/spm12'));
addpath('/Users/katherine/marsbar-0.44/');

subjects = {'7404', '7408', '7412', '7414', '7418', '7430', '7432',...
            '7436', '7443', '7453', '7458', '7474', '7477', '7478', '7480',...
            '7498', '7508', '7521', '7533', '7534', '7542', '7558', '7561',...
            '7562', '7575', '7580', '7607', '7619', '7623', '7638',...
            '7641', '7645', '7648', '7649', '7659', '7714', '7719', '7726'};


resdir = '/Volumes/LaCie/LaPrivate/soccog/results/hrfsancheck/lrn/';


marsbar('on')

% Set up the SPM defaults
spm('defaults', 'fmri');

LBA4img = fullfile(resdir, 'ROI_LBA4_MNI.img');
RBA4img = fullfile(resdir, 'ROI_RBA4_MNI.img');
Lroi = maroi_image(struct('vol', spm_vol(LBA4img), 'binarize',0,...
        'func', 'img'));
Rroi = maroi_image(struct('vol', spm_vol(RBA4img), 'binarize',0,...
        'func', 'img'));
saveroi(Lroi, fullfile(resdir, 'LBA4.mat'));
saveroi(Rroi, fullfile(resdir, 'RBA4.mat'));

for nsub = 1:length(subjects)
    subject = subjects(nsub);
    fname = fullfile(resdir, subject, 'HRF_params_cond0001.img,1');
    fname = fname{1, 1};
    LBA4 = maroi(fullfile(resdir, 'LBA4.mat'));
    RBA4 = maroi(fullfile(resdir, 'RBA4.mat'));
    LmarsY = get_marsy(LBA4, fname, 'mean', 'v');
    RmarsY = get_marsy(RBA4, fname, 'mean', 'v');
    Lrno = marsbar('get_region', region_name(LmarsY));
    LY = region_data(LmarsY, Lrno);    
    LY = mean(LY{1});
    Rrno = marsbar('get_region', region_name(RmarsY));
    RY = region_data(RmarsY, Rrno);    
    RY = mean(RY{1});
    roivals(nsub).L = LY;
    roivals(nsub).R = RY;
end

data = cell(nsub, 3);
for nsub = 1:length(subjects)
    data{nsub,1} = subjects(nsub);
    data{nsub,2} = roivals(nsub).L;
    data{nsub,3} = roivals(nsub).R;
end

outfile = fullfile(resdir, 'ba4data');
T = cell2table(data, 'RowNames', subjects, 'VariableNames', {'Subjects', 'LBA4', 'RBA4'});
writetable(T, outfile);
