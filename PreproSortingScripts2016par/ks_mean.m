function ks_mean(data, time)

time.date = date;
time.time1 = time1;
time.time2 = time2;

data_path = data.data_path;
subjects = data.Subjects;
logdir = data.logdir; 

%% Initialise SPM defaults
%--------------------------------------------------------------------------
spm('Defaults','fMRI');

spm_jobman('initcfg');

%% Loop over subjects
%--------------------------------------------------------------------------
for i=1:numel(subjects)
    
    clear matlabbatch a 
    
    subject = subjects(i).ID;
    
    a = spm_select('FPList', fullfile(data_path, subject,'func'), '^corr.*\.nii$');
    
    matlabbatch{1}.cfg_basicio.cfg_cd.dir = cellstr(fullfile(data_path, subject));
    matlabbatch{2}.spm.util.imcalc.input = cellstr(a);
    matlabbatch{2}.spm.util.imcalc.output = 'mean.nii';
    matlabbatch{2}.spm.util.imcalc.outdir = {''};
    matlabbatch{2}.spm.util.imcalc.expression = 'mean(X)';
    matlabbatch{2}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{2}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{2}.spm.util.imcalc.options.mask = 0;
    matlabbatch{2}.spm.util.imcalc.options.interp = 1;
    matlabbatch{2}.spm.util.imcalc.options.dtype = 4;
    
    %% SAVE AND RUN JOB
    %----------------------------------------------------------------------
    save(fullfile(logdir, [subject, '_', date, '_', 'Time', time1, time2, '_mean.mat']),'matlabbatch');
    %spm_jobman('interactive',jobs);
    output = spm_jobman('run',matlabbatch);
    
end