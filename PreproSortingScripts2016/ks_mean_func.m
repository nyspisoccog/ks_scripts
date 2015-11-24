function ks_mean_func(data, time)

date = time.date;
time1 = time.time1;
time2 = time.time2;

data_path = data.data_path;
subjects = data.Subjects;
logdir = data.logdir; 

%% Initialise SPM defaults
%--------------------------------------------------------------------------
spm('Defaults','fMRI');

spm_jobman('initcfg');

%% Loop over subjects
%--------------------------------------------------------------------------
for i=1:length(subjects)
    
    clear matlabbatch f
    
    subject = subjects(i).ID;
    sessions = subjects(i).Runs;
    
    for j=1:length(sessions)
        f{j} = spm_select('FPList', fullfile(data_path, subject, 'func', sessions{j}), '^a.*\.nii$');
    end
    matlabbatch{1}.cfg_basicio.cfg_cd.dir = cellstr(fullfile(data_path, subject));
    for j = 1:length(sessions)
        session = sessions{j};
        matlabbatch{2}.spm.util.imcalc.input = f(j);
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
        save(fullfile(logdir, [subject, '_', session, '_', date, '_', 'Time', time1, '.', time2, '_mean.mat']),'matlabbatch');
        %spm_jobman('interactive',jobs);
        output = spm_jobman('run',matlabbatch);
    end
    
end