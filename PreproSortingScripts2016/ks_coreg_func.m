function ks_coreg_func(data, time)


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
addpath('/Users/katherine/spm12'); % path containing <editfilename.m>
addpath('/Users/katherine/spm12/matlabbatch');

%% Initialise SPM defaults
%--------------------------------------------------------------------------
spm('Defaults','fMRI');

spm_jobman('initcfg');

%% Loop over subjects
%--------------------------------------------------------------------------
for i=1:numel(subjects)
    
    clear matlabbatch r m output
    
    subject = subjects(i).ID;
    sessions = subjects(i).Runs;
    
    
    r = spm_select('FPList', fullfile(data_path, subject,'anat'), '^no.*\.nii$');
    m = spm_select('FPList', fullfile(data_path, subject, 'func', sessions{1}), '^mean.*\.nii$');

    output={};
    for y=1:numel(sessions)
        files=spm_select('FPList', fullfile(data_path, subject, 'func', sessions{y}), '^corr.*\.nii$');
        f_c=cellstr(files);
        output=vertcat(output,f_c);
    end 
    
    matlabbatch{1}.cfg_basicio.cfg_cd.dir = cellstr(fullfile(data_path, subject));
    matlabbatch{2}.spm.spatial.coreg.estimate.ref = cellstr(r);
    matlabbatch{2}.spm.spatial.coreg.estimate.source = cellstr(m);
    matlabbatch{2}.spm.spatial.coreg.estimate.other = output;                                                
    matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];   
    
    
    
    
    %% SAVE AND RUN JOB
    %----------------------------------------------------------------------
    save(fullfile(logdir, [subject, '_', date, '_', 'Time', time1, time2, '_coreg.mat']),'matlabbatch');
    %spm_jobman('interactive',jobs);
    output = spm_jobman('run',matlabbatch);
    
end