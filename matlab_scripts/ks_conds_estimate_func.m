function ks_conds_estimate_func(Data, Time)
spm('Defaults','fMRI');



spm_get_defaults('defaults.mask.thresh', 0);

spm_jobman('initcfg');


clear matlabbatch;

lrn_res_dir = Data.lrn_res_dir;
mem_res_dir = Data.mem_res_dir;
lrn_log_dir = Data.lrn_log_dir; 
mem_log_dir = Data.mem_log_dir;
sess_type = {'mem'};
subjects = Data.Subjects;

for i=1:numel(subjects)
    subject = subjects(i).ID;
    for lm = 1:numel(sess_type)
        if strcmp(sess_type{lm}, 'lrn')
            resdir = fullfile(lrn_res_dir, subject);
            logdir = lrn_log_dir;
        else
            resdir = fullfile(mem_res_dir, subject);
            logdir = mem_log_dir;
        end
        subs(i).matlabbatch{1}.spm.stats.fmri_est.spmmat = cellstr(fullfile(resdir, 'SPM.mat'));
        subs(i).matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
        subs(i).matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
        matlabbatch = subs(i).matlabbatch;
        save(fullfile(logdir, [subject '_conds_estimate.mat']), 'matlabbatch');
    end
end
parfor nsub = 1:length(subjects)
    out = spm_jobman('run',subs(nsub).matlabbatch)
end
clear matlabbatch subject out subjects

end