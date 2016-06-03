function ks_smooth_func(data, time)


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
addpath('/Users/katherine/spm12/matlabbatch');

%% Initialise SPM defaults
%--------------------------------------------------------------------------
spm('Defaults','fMRI');

spm_jobman('initcfg');

%--------------------------------------------------------------------------
for i=1:length(subjects)
clear matlabbatch f
    
subject = subjects(i).ID;
sessions = subjects(i).Runs;

d = {};

for j=1:length(sessions)
    f = spm_select('FPList', fullfile(data_path, subject, 'func', sessions{j}), '^corr.*\.nii$');
    sz = size(spm_vol(f));
    c = repmat({f}, sz);
    for k = 1:sz(1)
        c{k} = [c{k} ',' int2str(k)];
    end
    d = vertcat(d, c);
end   

matlabbatch{1}.spm.spatial.smooth.data = d;
matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
matlabbatch{1}.spm.spatial.smooth.dtype = 0;
matlabbatch{1}.spm.spatial.smooth.im = 0;
matlabbatch{1}.spm.spatial.smooth.prefix = 's';
save(fullfile(logdir, [subject, '_', date, '_', 'Time', time1, '.', time2, '_smooth.mat']),'matlabbatch');
        %spm_jobman('interactive',jobs);
disp(subject)
output = spm_jobman('run',matlabbatch);

end
end