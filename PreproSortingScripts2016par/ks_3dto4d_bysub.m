function ks_3dto4d_bysub(Data, Time)


%% Subjects folders
data_path = Data.data_path;
subjects = Data.Subjects;
logdir = Data.logdir; 


%% Time Info

date = Time.date;
time1 = Time.time1;
time2 = Time.time2;

spm('Defaults','fMRI');

spm_jobman('initcfg');

%--------------------------------------------------------------------------
subs = {};
ser_names = {};
msgs = {};

for i = 1:length(subjects)
    subject = subjects(i).ID;
    disp(subject)
    sessions = subjects(i).Runs;
    for j=1:length(sessions)
        clear matlabbatch
        files=spm_select('FPList', fullfile(data_path, subject, 'func', sessions{j}), '^s.*\.nii$');
        matlabbatch{1}.spm.util.cat.vols = cellstr(files);
        matlabbatch{1}.spm.util.cat.name = [subject sessions{j} '4D.nii'];
        matlabbatch{1}.spm.util.cat.dtype = 4;
        runname = sessions{j};
        save(fullfile(logdir, ['fourd_', date, 'Time', time1, time2, '_', subject, runname, '.mat']), 'matlabbatch');
        output = spm_jobman('run',matlabbatch);
        subs = vertcat(subs, subject);
        ser_names = vertcat(ser_names, sessions{j});
        msgs = vertcat(msgs, ['converted to 4D; ' subject sessions{j} '4D.nii created']);
    end 
    FourD = table(subs, ser_names, msgs);
    writetable(FourD, [data_path, subject, 'FourD.csv'])
end
    

end
