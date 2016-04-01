function ks_normalize_func(data, time)


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


temp = cellstr(spm_select('FPList', fullfile(data_path, subjects(1).ID,'anat'), '^Template_6.*\.nii$'));

matlabbatch{1}.cfg_basicio.cfg_cd.dir = cellstr(data_path);
matlabbatch{2}.spm.tools.dartel.mni_norm.template = temp;

for i = 1:numel(subjects)
    subject = subjects(i).ID;
    sessions = subjects(i).Runs;
    o = {};
    for y=1:numel(sessions)
        files=spm_select('FPList', fullfile(data_path, subject,sessions{y}), '^r.*\.img$');
        f_c=cellstr(files);
        o=vertcat(o,f_c);
    end 
    matlabbatch{2}.spm.tools.dartel.mni_norm.data.subj(i).flowfield = ...
        cellstr(spm_select('FPList', fullfile(data_path, subject,'anat'), '^u.*\.nii$'));  
    matlabbatch{2}.spm.tools.dartel.mni_norm.data.subj(i).images = o;
end

matlabbatch{2}.spm.tools.dartel.mni_norm.vox = [2 2 2];
matlabbatch{2}.spm.tools.dartel.mni_norm.bb = [NaN NaN NaN
                                               NaN NaN NaN];
matlabbatch{2}.spm.tools.dartel.mni_norm.preserve = 0;
matlabbatch{2}.spm.tools.dartel.mni_norm.fwhm = [6 6 6];


matlabbatch{3}.spm.tools.dartel.mni_norm.template = temp;

for i = 1:numel(subjects)
    subject = subjects(i).ID;
    matlabbatch{3}.spm.tools.dartel.mni_norm.data.subj(i).flowfield = ...
        cellstr(spm_select('FPList', fullfile(data_path, subject,'anat'), '^u.*\.nii$'));  
    matlabbatch{3}.spm.tools.dartel.mni_norm.data.subj(i).images = ...
        cellstr(spm_select('FPList', fullfile(data_path, subject, 'anat'), '^no.*img$'));
end

matlabbatch{3}.spm.tools.dartel.mni_norm.vox = [1 1 1];
matlabbatch{3}.spm.tools.dartel.mni_norm.bb = [NaN NaN NaN
                                               NaN NaN NaN];
matlabbatch{3}.spm.tools.dartel.mni_norm.preserve = 0;
matlabbatch{3}.spm.tools.dartel.mni_norm.fwhm = [0 0 0];
 
    
%----------------------------------------------------------------------
save(fullfile(logdir, ['Group_', date, 'Time', time1, time2, '_norm.mat']), 'matlabbatch');
%spm_jobman('interactive',jobs);
output = spm_jobman('run',matlabbatch);
    