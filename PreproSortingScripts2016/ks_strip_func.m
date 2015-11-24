function ks_strip_func(data, time)

%% Subjects folders

data_path = data.data_path;
subjects = data.Subjects;
logdir = data.logdir; 


%% Time Info

date = time.date;
time1 = time.time1;
time2 = time.time2;
%--------------------------------------------------------------------------
addpath('/home/katie/spm12');   % SPM path
addpath('/home/katie/spm12'); % path containing <editfilename.m>
addpath('/home/katie/spm12/matlabbatch');

%% Initialise SPM defaults
%--------------------------------------------------------------------------
spm('Defaults','fMRI');

spm_jobman('initcfg');

%% Loop over subjects
%--------------------------------------------------------------------------
for i=1:numel(subjects)
    
    clear matlabbatch a l c
    
    subject = subjects(i).ID;
    
    a = spm_select('FPList', fullfile(data_path, subject,'anat'), '^s.*\.img$');
    
    matlabbatch{1}.cfg_basicio.cfg_cd.dir = cellstr(fullfile(data_path, subject));
    
    for l=1:3
        c{l,:} = spm_select('FPList', fullfile(data_path, subject,'anat'), ['^c' num2str(l) '.*\.nii$']); 
    end
    c{4,:} = a;
    matlabbatch{2}.spm.util.imcalc.input = c;
    matlabbatch{2}.spm.util.imcalc.output = 'noskull.nii';
    matlabbatch{2}.spm.util.imcalc.outdir = cellstr(fullfile(data_path, subject,'anat'));
    matlabbatch{2}.spm.util.imcalc.expression = 'i4.*(i1 + i2 + i3)';
    matlabbatch{2}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{2}.spm.util.imcalc.options.mask = 0;
    matlabbatch{2}.spm.util.imcalc.options.interp = 1;
    matlabbatch{2}.spm.util.imcalc.options.dtype = 16;
    
    %% SAVE AND RUN JOB
    %----------------------------------------------------------------------
    save(fullfile(logdir, [subject, '_', date, '_', 'Time', time1, time2, '_strip.mat']),'matlabbatch');
    %spm_jobman('interactive',jobs);
    output = spm_jobman('run',matlabbatch);
    
end