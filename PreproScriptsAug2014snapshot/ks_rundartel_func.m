function ks_rundartel_func(data, time)


%% Subjects folders

data_path = data.data_path;
subjects = data.Subjects;
logdir = data.logdir; 


%% Time Info

date = time.date;
time1 = time.time1;
time2 = time.time2;

%--------------------------------------------------------------------------
addpath('/home/katie/spm8');   % SPM path
addpath('/home/katie/spm8'); % path containing <editfilename.m>
addpath('/home/katie/spm8/matlabbatch');

%% Initialise SPM defaults
%--------------------------------------------------------------------------
spm('Defaults','fMRI');

spm_jobman('initcfg');

%--------------------------------------------------------------------------
clear matlabbatch

gray = {};
white = {};
csf = {};

for i=1:numel(subjects)
    subject = subjects(i).ID;
    sub_gray = cellstr(spm_select('FPList', fullfile(data_path, subject,'anat'), '^rc1.*nii$'));
    gray = vertcat(gray, sub_gray);
    sub_white = cellstr(spm_select('FPList', fullfile(data_path, subject,'anat'), '^rc2.*nii$'));
    white = vertcat(white, sub_white);
    sub_csf = cellstr(spm_select('FPList', fullfile(data_path, subject,'anat'), '^rc3.*nii$'));
    csf = vertcat(csf, sub_csf);    
end

matlabbatch{1}.cfg_basicio.cfg_cd.dir = cellstr(fullfile(data_path, subject));

matlabbatch{2}.spm.tools.dartel.warp.images = {
                                               gray
                                               white
                                               csf
                                              };
matlabbatch{2}.spm.tools.dartel.warp.settings.template = 'Template';
matlabbatch{2}.spm.tools.dartel.warp.settings.rform = 0;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(1).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(1).rparam = [4 2 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(1).K = 0;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(1).slam = 16;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(2).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(2).rparam = [2 1 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(2).K = 0;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(2).slam = 8;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(3).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(3).rparam = [1 0.5 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(3).K = 1;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(3).slam = 4;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(4).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(4).rparam = [0.5 0.25 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(4).K = 2;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(4).slam = 2;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(5).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(5).rparam = [0.25 0.125 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(5).K = 4;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(5).slam = 1;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(6).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(6).rparam = [0.25 0.125 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(6).K = 6;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(6).slam = 0.5;
matlabbatch{2}.spm.tools.dartel.warp.settings.optim.lmreg = 0.01;
matlabbatch{2}.spm.tools.dartel.warp.settings.optim.cyc = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.optim.its = 3;


    
%----------------------------------------------------------------------
save(fullfile(logdir, ['Group_', date, '_', 'Time', time1, time2, '_rundartel.mat']),'matlabbatch');
%spm_jobman('interactive',jobs);
output = spm_jobman('run',matlabbatch);
    