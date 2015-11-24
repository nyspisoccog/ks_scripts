function ks_followup_spec_2ndlev(Data, Time, Num)

spm('Defaults','fMRI');

spm_jobman('initcfg');

clear matlabbatch;

lrn_res_dir = Data.lrn_res_dir;
subjects = Data.Subjects;
log_dir = Data.log_dir
date = Time.date;
time1 = Time.time1;
time2 = Time.time2;




matlabbatch{1}.spm.stats.factorial_design.dir = {lrn_res_dir};
for i=1:Num
    clear matlabbatch confiles
    matlabbatch{1}.spm.stats.factorial_design.dir = {lrn_res_dir};
    if i < 10
        srch_str = ['^con_000' int2str(i) '.*\.img$']; 
    else
        srch_str = ['^con_00' int2str(i) '.*\.img$']; 
    end
    dir_name = fullfile(lrn_res_dir, ['con' int2str(i)]);
    if ~exist(dir_name, 'dir')
        mkdir(dir_name)
    end
    matlabbatch{1}.spm.stats.factorial_design.dir = {dir_name};
    confiles = {};
    matfile = fullfile(dir_name, 'SPM.mat');
    for i=1:numel(subjects)
        subject = subjects(i).ID;
        confiles = vertcat(confiles, cellstr(spm_select('FPList', fullfile(lrn_res_dir, subject), srch_str)));
    end
    matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = confiles;
    matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
    matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
    matlabbatch{2}.spm.stats.fmri_est.spmmat = {matfile};
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;


    save(fullfile(log_dir, [date, '_', 'Time', time1, time2, 'con', int2str(Num), '_followup.mat']),'matlabbatch');
    %spm_jobman('interactive',jobs);
    output = spm_jobman('run',matlabbatch);
end
%%

%%
%%

end
