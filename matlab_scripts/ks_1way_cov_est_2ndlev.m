function ks_1way_cov_est_2ndlev(Data, Time)


spm('Defaults','fMRI');

spm_jobman('initcfg');

clear matlabbatch;

lrn_res_dir = Data.lrn_res_dir;
subjects = Data.Subjects;
log_dir = Data.log_dir
date = Time.date;
time1 = Time.time1;
time2 = Time.time2;

matlabbatch{1}.spm.stats.fmri_est.spmmat = {fullfile(lrn_res_dir, 'SPM.mat')};
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;

save(fullfile(log_dir, [date, '_', 'Time', time1, time2, '_estcov.mat']),'matlabbatch');
    %spm_jobman('interactive',jobs);
    output = spm_jobman('run',matlabbatch);


end

