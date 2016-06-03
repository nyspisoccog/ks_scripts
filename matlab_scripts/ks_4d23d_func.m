function ks_4d23d_func(Data, Time)

spm('Defaults','fMRI');

spm_jobman('initcfg');

clear matlabbatch;

data_path = Data.data_path;
subjects = Data.Subjects;
log_dir = Data.logdir;

date = Time.date;
time1 = Time.time1;
time2 = Time.time2;

for i=1:length(subjects)
    subject = subjects(i).ID;
        sessions = subjects(i).Runs;
        
        for j = 1:length(sessions)
            if strfind(sessions{j}, 'M') ~= -1 %I only prerocessed the Ls
               disp(subject)
               disp(sessions{j})
               clear matlabbatch
               matlabbatch{1}.spm.util.split.vol = ...
                   cellstr(spm_select('FPList', fullfile(data_path, subject, 'func', sessions{j}), '^sc.*\.nii$'));
               matlabbatch{1}.spm.util.split.outdir = {''};
               save(fullfile(log_dir, [date, '_', 'Time', time1, time2, '_', subject, sessions{j}, '_', '3D.mat']),'matlabbatch');
           
               %spm_jobman('interactive',jobs);
               output = spm_jobman('run',matlabbatch);
            end
        end
        
    end
    
    
end
            


