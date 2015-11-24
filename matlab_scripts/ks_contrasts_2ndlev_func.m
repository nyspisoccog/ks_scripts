function ks_contrasts_2ndlev_func(Data, Time, Num)

spm('Defaults','fMRI');

spm_jobman('initcfg');

clear matlabbatch;

lrn_res_dir = Data.lrn_res_dir;
mem_res_dir = Data.mem_res_dir;
lrn_log_dir = Data.lrn_log_dir; 
mem_log_dir = Data.mem_log_dir;
sess_type = {'lrn', 'mem'};
subjects = Data.Subjects;


for i=1:Num
    for lm = 1:numel(sess_type)
        if strcmp(sess_type{lm}, 'lrn')
            resdir = lrn_res_dir;
            logdir = lrn_log_dir;
            dir_name = fullfile(lrn_res_dir, ['con' int2str(i)])
            matfile = fullfile(dir_name, 'SPM.mat'); 
            matlabbatch{1}.cfg_basicio.cfg_cd.dir = cellstr(fullfile(dir_name));
            matlabbatch{2}.spm.stats.con.spmmat = cellstr(matfile);
            matlabbatch{2}.spm.stats.con.consess{1}.tcon.name = 'positivet';  
            matlabbatch{2}.spm.stats.con.consess{1}.tcon.convec = [1];
            matlabbatch{2}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
            matlabbatch{2}.spm.stats.con.consess{2}.tcon.name = 'negativet';  
            matlabbatch{2}.spm.stats.con.consess{2}.tcon.convec = [-1];
            matlabbatch{2}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
            matlabbatch{2}.spm.stats.con.delete = 1;
        end
        save(fullfile(logdir, 'seclev_con.mat'), 'matlabbatch');
        out = spm_jobman('run',matlabbatch);
    end
    clear matlabbatch out 
end
end
