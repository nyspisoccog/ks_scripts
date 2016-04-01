function ks_realign_func(data, time)


%% Subjects folders

data_path = data.data_path;
logdir = data.logdir; 
subjects = data.Subjects


%% Time Info

date = time.date;
time1 = time.time1;
time2 = time.time2;


%% Set Matlab path
%--------------------------------------------------------------------------
addpath('/home/katie/spm8');   % SPM path
addpath('/home/katie/spm8'); % path containing <editfilename.m>

%% Initialise SPM defaults
%--------------------------------------------------------------------------
spm('Defaults','fMRI');

spm_jobman('initcfg');

%% Loop over subjects
%--------------------------------------------------------------------------
for i=1:numel(subjects)
    
    clear matlabbatch a f
    
    subject = subjects(i).ID;
    sessions = subjects(i).Runs;
    
    for j=1:numel(sessions)
        f{j} = spm_select('FPList', fullfile(data_path, subject, sessions{j}), '^f.*\.img$');
    end
    a = spm_select('FPList', fullfile(data_path, subject,'anat'), '^s.*\.img$');
    
    fprintf('Preprocessing subject "%s" (%s)\n',subject,sprintf('%d ',cellfun(@(x) size(x,1),f)));
    
    %% CHANGE WORKING DIRECTORY (useful for .ps only)
    %----------------------------------------------------------------------
    matlabbatch{1}.cfg_basicio.cfg_cd.dir = cellstr(fullfile(data_path, subject));
    
   
    %% REALIGN: ESTIMATE AND RESLICE 
    %----------------------------------------------------------------------
    for j=1:numel(sessions)
        f{j} = spm_select('FPList', fullfile(data_path, subject, sessions{j}), '^af.*\.img$');
    end
    
    for j=1:numel(sessions)
        matlabbatch{2}.spm.spatial.realign.estwrite.data{j} = cellstr(f{j});
    end
    
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.sep = 4;
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.interp = 3;
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.weight = '';
    matlabbatch{2}.spm.spatial.realign.estwrite.roptions.which = [2 1];
    matlabbatch{2}.spm.spatial.realign.estwrite.roptions.interp = 4;
    matlabbatch{2}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{2}.spm.spatial.realign.estwrite.roptions.mask = 1;
    matlabbatch{2}.spm.spatial.realign.estwrite.roptions.prefix = 'r';

    
    %% SAVE AND RUN JOB
    %----------------------------------------------------------------------
    save(fullfile(logdir, [subject, '_', date, '_', 'Time', time1, time2, '_realign.mat']),'matlabbatch');
    %spm_jobman('interactive',jobs);
    output = spm_jobman('run',matlabbatch);
    
end


