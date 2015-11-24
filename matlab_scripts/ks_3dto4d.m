function ks_3dto4d(Data, Time)


%% Subjects folders
data_path = data.data_path;
subjects = data.Subjects;
logdir = data.logdir; 


%% Time Info

date = time.date;
time1 = time.time1;
time2 = time.time2;

spm('Defaults','fMRI');

spm_jobman('initcfg');

%--------------------------------------------------------------------------


for i = 1:length(subjects)
    subject = subjects(i).ID;
    sessions = subjects(i).Runs;
    for j=1:length(sessions)
        clear matlabbatch
        files=spm_select('FPList', fullfile(data_path, subject, sessions{j}), '^f.*\.img$');
        matlabbatch{1}.spm.util.cat.vols = cellstr(files);
        matlabbatch{1}.spm.util.cat.name = '4D.nii';
        matlabbatch{1}.spm.util.cat.dtype = 4;
        save(fullfile(logdir, ['fourd', date, 'Time', time1, time2, subject, sessions{j} '_.mat']), 'matlabbatch');
        output = spm_jobman('run',matlabbatch);
    end 
end
    

