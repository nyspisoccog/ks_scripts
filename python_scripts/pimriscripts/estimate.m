spm('Defaults','fMRI');

spm_jobman('initcfg');

clear matlabbatch;

res_dir = <res_dir>;
log_dir = <log_dir>;
subjects = <subjects>;

for i=1:numel(subjects)
    subject = subjects{i};
    resdir = fullfile(res_dir, subject);
    matlabbatch{1}.spm.stats.fmri_est.spmmat = cellstr(fullfile(resdir, 'SPM.mat'));
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
    save(fullfile(log_dir, [subject 'estimate.mat']), 'matlabbatch');
    out = spm_jobman('run',matlabbatch)
end

clear matlabbatch subject out subjects

