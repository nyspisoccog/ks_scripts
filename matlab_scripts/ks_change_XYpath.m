function ks_change_XYpath(Data, Time)
spm('Defaults','fMRI');



spm_jobman('initcfg');


clear matlabbatch;

lrn_res_dir = Data.lrn_res_dir;
mem_res_dir = Data.mem_res_dir;
lrn_log_dir = Data.lrn_log_dir; 
mem_log_dir = Data.mem_log_dir;
lrn_loc_dir = Data.lrn_loc_dir;
mem_loc_dir = Data.mem_loc_dir;


sess_type = {'mem'};
subjects = Data.Subjects;

for i=1:numel(subjects)
    subject = subjects(i).ID;
    for lm = 1:numel(sess_type)
        if strcmp(sess_type{lm}, 'lrn')
            res_dir = lrn_res_dir;
            log_dir = lrn_log_dir;
            loc_dir = lrn_loc_dir
        else
            res_dir = mem_res_dir;
            log_dir = mem_log_dir;
            loc_dir = mem_loc_dir;
        end
        load(fullfile(loc_dir, subject, 'SPM.mat'));
        sz = size(SPM.xY.P);
        rows = sz(1);
        cols = length(strrep(SPM.xY.P(1, :), Data.locroot, Data.soccogroot));
        P = repmat(char(0), rows, cols);
        for numrow = 1:rows
            P(numrow, :) = strrep(SPM.xY.P(numrow, :), Data.locroot, Data.soccogroot);
        end
        
        SPM.xY.P = P;

      
        save(fullfile(loc_dir, subject, 'SPM.mat'), 'SPM');
       
    end
end

end