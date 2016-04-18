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
addpath('/Users/katherine/spm12');   % SPM path
addpath('/Users/katherine/spm12/matlabbatch');

%% Initialise SPM defaults
%--------------------------------------------------------------------------
spm('Defaults','fMRI');

spm_jobman('initcfg');

%--------------------------------------------------------------------------
clear matlabbatch



temp = cellstr(spm_select('FPList', fullfile(data_path, subjects(1).ID,'anat'), '^Template_6.*\.nii$'));



for i = 1:length(subjects)
    subs(i).matlabbatch
    subject = subjects(i).ID;
    sessions = subjects(i).Runs;
    subs(i).matlabbatch{1}.cfg_basicio.cfg_cd.dir = cellstr(data_path);
    subs(i).matlabbatch{2}.spm.tools.dartel.mni_norm.template = temp;
    subs(i).matlabbatch{3}.spm.tools.dartel.mni_norm.template = temp;
    o = {};
    for y=1:length(sessions)
        files=spm_select('FPList', fullfile(data_path, subject, 'func', sessions{y}), '^corr.*\.nii$');
        f_c=cellstr(files);
        o=vertcat(o,f_c);
    end 
    subs(i).matlabbatch{2}.spm.tools.dartel.mni_norm.data.subj(i).flowfield = ...
        cellstr(spm_select('FPList', fullfile(data_path, subject,'anat'), '^u.*\.nii$'));  
    subs(i).matlabbatch{2}.spm.tools.dartel.mni_norm.data.subj(i).images = o;
    subs(i).matlabbatch{3}.spm.tools.dartel.mni_norm.data.subj(i).flowfield = ...
        cellstr(spm_select('FPList', fullfile(data_path, subject,'anat'), '^u.*\.nii$'));  
    subs(i).matlabbatch{3}.spm.tools.dartel.mni_norm.data.subj(i).images = o;


    subs(i).matlabbatch{2}.spm.tools.dartel.mni_norm.vox = [2 2 2];
    subs(i).matlabbatch{2}.spm.tools.dartel.mni_norm.bb = [NaN NaN NaN
                                               NaN NaN NaN];
    subs(i).matlabbatch{2}.spm.tools.dartel.mni_norm.preserve = 0;
    subs(i).matlabbatch{2}.spm.tools.dartel.mni_norm.fwhm = [0 0 0];

    subs(i).matlabbatch{3}.spm.tools.dartel.mni_norm.vox = [2 2 2];
    subs(i).matlabbatch{3}.spm.tools.dartel.mni_norm.bb = [NaN NaN NaN
                                               NaN NaN NaN];
    subs(i).matlabbatch{3}.spm.tools.dartel.mni_norm.preserve = 0;
    subs(i).matlabbatch{3}.spm.tools.dartel.mni_norm.fwhm = [6 6 6];

    subs(i)matlabbatch{4}.spm.tools.dartel.mni_norm.template = temp;



    subs(i)matlabbatch{4}.spm.tools.dartel.mni_norm.data.subj(i).flowfield = ...
        cellstr(spm_select('FPList', fullfile(data_path, subject,'anat'), '^u.*\.nii$'));  
    subs(i).matlabbatch{4}.spm.tools.dartel.mni_norm.data.subj(i).images = ...
        cellstr(spm_select('FPList', fullfile(data_path, subject, 'anat'), '^no.*nii$'));


    subs(i).matlabbatch{4}.spm.tools.dartel.mni_norm.vox = [1 1 1];
    subs(i).matlabbatch{4}.spm.tools.dartel.mni_norm.bb = [NaN NaN NaN
                                               NaN NaN NaN];
    subs(i).matlabbatch{4}.spm.tools.dartel.mni_norm.preserve = 0;
    subs(i).matlabbatch{4}.spm.tools.dartel.mni_norm.fwhm = [0 0 0];


end
 
    
for nsub = 1:length(subs)
    save(fullfile(logdir, ['Group_', date, 'Time', time1, time2, '_norm.mat']), 'matlabbatch');
output = spm_jobman('run',matlabbatch);
    