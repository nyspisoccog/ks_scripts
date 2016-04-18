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
addpath('/Users/katherine/spm12');   % SPM path
addpath('/Users/katherine/spm12'); % path containing <editfilename.m>

%% Initialise SPM defaults
%--------------------------------------------------------------------------
spm('Defaults','fMRI');

spm_jobman('initcfg');

%% Loop over subjects
%--------------------------------------------------------------------------
for i=1:numel(subjects)
    
    
    
    clear matlabbatch f
    
    subject = subjects(i).ID;
    sessions = subjects(i).Runs;
    
    
    %% CHANGE WORKING DIRECTORY (useful for .ps only)
    %----------------------------------------------------------------------
    matlabbatch{1}.cfg_basicio.cfg_cd.dir = cellstr(fullfile(data_path, subject));
    
   
    %% REALIGN: ESTIMATE
    %----------------------------------------------------------------------
    for j=1:length(sessions)
        f{j} = spm_select('FPList', fullfile(data_path, subject, 'func', sessions{j}), '^r.*\.nii$');%remember to change backk to ^corr
    end
    
    for j = 1:length(sessions)
        sz = size(spm_vol(f{j}));
        c = repmat({f{j}}, sz);
        for k = 1:sz(1)
            c{k} = [c{k} ',' int2str(k)];
        end
        g{j} = c;
    end
    
    fprintf('Preprocessing subject "%s" (%s)\n',subject,sprintf('%d ',cellfun(@(x) size(x,1),f)));
    
 
    matlabbatch{2}.spm.spatial.realign.estimate.data = g;
    matlabbatch{2}.spm.spatial.realign.estimate.eoptions.quality = 0.9;
    matlabbatch{2}.spm.spatial.realign.estimate.eoptions.sep = 4;
    matlabbatch{2}.spm.spatial.realign.estimate.eoptions.fwhm = 5;
    matlabbatch{2}.spm.spatial.realign.estimate.eoptions.rtm = 1;
    matlabbatch{2}.spm.spatial.realign.estimate.eoptions.interp = 3;
    matlabbatch{2}.spm.spatial.realign.estimate.eoptions.wrap = [0 0 0];
    matlabbatch{2}.spm.spatial.realign.estimate.eoptions.weight = '';
    

    
    %% SAVE AND RUN JOB
    %----------------------------------------------------------------------
    save(fullfile(logdir, [subject, '_', date, '_', 'Time', time1, time2, '_realign.mat']),'matlabbatch');
    %spm_jobman('interactive',jobs);
    output = spm_jobman('run',matlabbatch);
    
end


