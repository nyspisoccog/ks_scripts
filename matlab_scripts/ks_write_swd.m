function ks_write_swd(Data, Time)

data_dir = Data.data_dir;
lrn_res_dir = Data.lrn_res_dir;
mem_res_dir = Data.mem_res_dir;
lrn_log_dir = Data.lrn_log_dir; 
mem_log_dir = Data.mem_log_dir;
lrn_loc_dir = Data.lrn_loc_dir;
mem_loc_dir = Data.mem_loc_dir;

sess_type = {'mem'};
subjects = Data.Subjects;

%%initialize defaults

spm('Defaults','fMRI');

spm_get_defaults('defaults.mask.thresh', 0);

spm_jobman('initcfg');

for i=1:numel(subjects)
    for lm = 1:numel(sess_type)
        clear files onsets matlabbatch r
        tally = 0;
        subject = subjects(i).ID;
        if strcmp(sess_type{lm}, 'lrn')
            sessions = subjects(i).lrn_runs;
            res_dir = fullfile(lrn_res_dir, subject);
            loc_dir = lrn_loc_dir;
            log_dir = lrn_log_dir;
        else
            sessions = subjects(i).mem_runs;
            res_dir = fullfile(mem_res_dir, subject);
            loc_dir = mem_loc_dir;
            log_dir = mem_log_dir;
        end
        load(fullfile(loc_dir, subject, 'SPM.mat'));
        SPM.swd = res_dir;
        save(fullfile(loc_dir, subject, 'SPM.mat'), 'SPM');
    end
end
        