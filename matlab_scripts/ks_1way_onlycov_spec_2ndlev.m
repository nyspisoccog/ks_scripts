function ks_1way_onlycov_spec_2ndlev(Data, Time)

spm('Defaults','fMRI');

spm_jobman('initcfg');

clear matlabbatch;

lrn_res_dir = Data.lrn_res_dir;
subjects = Data.Subjects;
log_dir = Data.log_dir
date = Time.date;
time1 = Time.time1;
time2 = Time.time2;

formatSpec = '%f';
delimiter = ',';
Scov_fname = fullfile(lrn_res_dir, 'Scovlist.csv');
Scov_fID = fopen(Scov_fname, 'r');
Scov_vec = textscan(Scov_fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
Ycov_fname = fullfile(lrn_res_dir, 'Ycovlist.csv');
Ycov_fID = fopen(Ycov_fname, 'r');
Ycov_vec = textscan(Ycov_fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
Ncov_fname = fullfile(lrn_res_dir, 'Ncovlist.csv');
Ncov_fID = fopen(Ncov_fname, 'r');
Ncov_vec = textscan(Ncov_fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
matlabbatch{1}.spm.stats.factorial_design.dir = {lrn_res_dir};

for i=1:numel(subjects)
    subject = subjects(i).ID;
    cond_fname = fullfile(lrn_res_dir, subject, 'oneruns.txt');
    cond_fID = fopen(cond_fname, 'r');
    cond_nums = textscan(cond_fID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false);
    matlabbatch{1}.spm.stats.factorial_design.des.anovaw.fsubject(i).scans = ...
        cellstr(spm_select('FPList', fullfile(lrn_res_dir, subject), '^con_.*\.img$'));
    matlabbatch{1}.spm.stats.factorial_design.des.anovaw.fsubject(i).conds = cond_nums{1}';
end
%%
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.ancova = 0;
%%
matlabbatch{1}.spm.stats.factorial_design.cov(1).c = Scov_vec{1};
matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'SRU';
matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(1).iCC = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(2).c = Ycov_vec{1};
matlabbatch{1}.spm.stats.factorial_design.cov(2).cname = 'YRU';
matlabbatch{1}.spm.stats.factorial_design.cov(2).iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(2).iCC = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(3).c = Ncov_vec{1};
matlabbatch{1}.spm.stats.factorial_design.cov(3).cname = 'NRU';
matlabbatch{1}.spm.stats.factorial_design.cov(3).iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(3).iCC = 1;
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
