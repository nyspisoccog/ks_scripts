function ks_1way_cov_spec_2ndlev(Data, Time)

spm('Defaults','fMRI');

spm_jobman('initcfg');

clear matlabbatch;

lrn_res_dir = Data.lrn_res_dir;
subjects = Data.Subjects;
log_dir = Data.log_dir
date = Time.date;
time1 = Time.time1;
time2 = Time.time2;

cov_fname = fullfile(lrn_res_dir, 'covlist.csv');
cov_fID = fopen(cov_fname, 'r');
formatSpec = '%f';
delimiter = ',';
cov_vec = textscan(cov_fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
cov_vec = cov_vec{1}

T = readtable(fullfile(lrn_res_dir, 'con5', 'outliers.csv'));
omit_rows = T.num;
cov_vec(omit_rows) = [];

matlabbatch{1}.spm.stats.factorial_design.dir = {lrn_res_dir};

for i=1:length(subjects)
    subject = subjects{i}
    all_cons = spm_select('FPList', fullfile(lrn_res_dir, subject), '^con_.*\.img$');
    cons_to_remove = [];
    for j = 1:length(T.subj)
        if T.subj(j) == int32(str2num(subjects(i)))
            cons_to_remove = vertcat(cons_to_remove, j);
        end
    end
    index = true(1, size(all_cons, 1));
    index(cons_to_remove) = false;
    cons = all_cons(index, :);
    cons.to.keep(i).fnames = cons;
    cond_fname = fullfile(lrn_res_dir, subject, 'runs.txt');
    cond_fID = fopen(cond_fname, 'r');
    cond_nums = textscan(cond_fID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false);
    cond_nums = cond_nums(index, :);
    cons.to.keep(i).cond_nums = cond_nums;
end

for i=1:numel(subjects)
    subject = subjects(i).ID;
    matlabbatch{1}.spm.stats.factorial_design.des.anovaw.fsubject(i).scans = ...
        cellstr(cons.to.keep(i).fnames);
    matlabbatch{1}.spm.stats.factorial_design.des.anovaw.fsubject(i).conds = ...
        cellstr(cons.to.keep(i).cond_nums);
end
%%
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.ancova = 0;
%%
matlabbatch{1}.spm.stats.factorial_design.cov.c = cov_vec;
%%
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'RU';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 3;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

save(fullfile(log_dir, [date, '_', 'Time', time1, time2, '_speccov.mat']),'matlabbatch');
    %spm_jobman('interactive',jobs);
    output = spm_jobman('run',matlabbatch);
end
