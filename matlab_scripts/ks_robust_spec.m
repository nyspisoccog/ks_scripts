function ks_robust_spec(Data, Time, Num)

spm('Defaults','fMRI');
spm_get_defaults('defaults.mask.thresh', 0);
spm_jobman('initcfg');
addpath(genpath('/Users/katherine/CanlabCore-master/'));
addpath(genpath('/Users/katherine/RobustToolbox-master/'));


lrn_res_dir = Data.lrn_res_dir;
mem_res_dir = Data.mem_res_dir;
subjects = Data.Subjects;
log_dir = Data.log_dir;
date = Time.date;
time1 = Time.time1;
time2 = Time.time2;



mask = which('brainmask.nii');

EXPT.subjects = repmat(char(0),length(subjects), ...
    length(fullfile(mem_res_dir, subjects(1).ID)));

for nsub = 1:length(subjects)
    EXPT.subjects(nsub, :) = fullfile(mem_res_dir, subjects(nsub).ID);
end


for i=1:Num
    clear matlabbatch confiles
    matlabbatch{1}.spm.stats.factorial_design.dir = {mem_res_dir};
    if i < 10
        srch_str = ['^con_000' int2str(i) '.*\.nii$']; 
    else
        srch_str = ['^con_00' int2str(i) '.*\.nii$']; 
    end
    confiles = {};
    for j=1:numel(subjects)
        subject = subjects(j).ID;
        confiles = vertcat(confiles, (spm_select('FPList', fullfile(mem_res_dir, subject, 'derivboost'), srch_str)));
    end
    
    confiles = char(confiles);
    
    EXPT.SNPM.P{i} = confiles;
    
    load(fullfile(mem_res_dir, '7404', 'derivboost', 'SPM.mat'));
    EXPT.SNPM.connames{i} = SPM.xCon(i).name;
    EXPT.SNPM.connums(i) = i;
    EXPT.SNPM.mask = which('brainmask.nii');
end


EXPT.SNPM.connames = char(EXPT.SNPM.connames{:});
save EXPT
cd(mem_res_dir)
EXPT = robfit(EXPT, 1:length(EXPT.SNPM.connums), 0, mask);
%%

%%
%%

end
