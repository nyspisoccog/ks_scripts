function ks_slicetime_func(data, time)

%% Subjects folders

logdir = data.logdir; 
data_path = data.data_path;
subjects = data.Subjects


%% Time Info

date = time.date;
time1 = time.time1;
time2 = time.time2;

%% Set Matlab path
%--------------------------------------------------------------------------
addpath('/Users/katherine/spm12');   % SPM path
 % path containing <editfilename.m>

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
    nslices = subjects(i).NSlices;
    sliceord = subjects(i).SliceOrd;
    
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
    
    %% CHANGE WORKING DIRECTORY (useful for .ps only)
    %----------------------------------------------------------------------
    matlabbatch{1}.cfg_basicio.cfg_cd.dir = cellstr(fullfile(data_path, subject));
    
    %% SLICE TIMING CORRECTION
    %----------------------------------------------------------------------
    for j=1:length(sessions)
        matlabbatch{2}.spm.temporal.st.scans{j} = g{1,1};
    end
    
        matlabbatch{2}.spm.temporal.st.nslices = nslices;
        matlabbatch{2}.spm.temporal.st.tr = 2.2;
        matlabbatch{2}.spm.temporal.st.ta = 2.2-(2.2/nslices);
        matlabbatch{2}.spm.temporal.st.so = sliceord;
        matlabbatch{2}.spm.temporal.st.refslice = 17;
        matlabbatch{2}.spm.temporal.st.prefix = 'a';
    
   
    
        %% SAVE AND RUN JOB
       
        save(fullfile(logdir, [subject,  '_', date, '_', 'Time', time1, time2, '_slicetime.mat']),'matlabbatch');
        %spm_jobman('interactive',jobs);
        output = spm_jobman('run',matlabbatch);
    
end


