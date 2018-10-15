function ks_robust_fdr_spec(Data, Time, Num)

spm('Defaults','fMRI');
spm_get_defaults('defaults.mask.thresh', 0);
%spm_jobman('initcfg');
addpath(genpath('/Users/katherine/CanlabCore-master/'));
addpath(genpath('/Users/katherine/RobustToolbox-master/'));
addpath(genpath('/Users/katherine/MediationToolbox-master/'));


lrn_res_dir = Data.lrn_res_dir;
mem_res_dir = Data.mem_res_dir;
subjects = Data.Subjects;
log_dir = Data.log_dir;
date = Time.date;
time1 = Time.time1;
time2 = Time.time2;


logname = fullfile(mem_res_dir, 'robust_results.txt');
loghand = fopen(logname,'wt');


EXPT.subjects = repmat(char(0),length(subjects), ...
    length(fullfile(mem_res_dir, subjects(1).ID)));

for nsub = 1:length(subjects)
    EXPT.subjects(nsub, :) = fullfile(mem_res_dir, subjects(nsub).ID);
end



for i=1:4
    clear confiles
    srch_str = ['^con_000' int2str(i) '.*\.nii$']; 

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
end


EXPT.mask = which('brainmask.nii');

cd(mem_res_dir)

EXPT = robfit(EXPT, 1:length(EXPT.SNPM.connums), 0, EXPT.mask);
save EXPT



for i = 1:4
    zeropad = '000';
    rob_dr = [mem_res_dir '/robust' zeropad int2str(i)];
    cd(rob_dr)
    addpath(genpath('/Users/katherine/MediationToolbox-master/'))
    [clpos, clneg, clpos_data, clneg_data] = mediation_brain_results('rob0', 'thresh', [.001], 'size', [5], 'fdrthresh', .05, 'prune');
    pos_dir_list = {};
    neg_dir_list = {};
    pos_label_list = {};
    neg_label_list = {};
    if ~isempty(clpos_data)
       fprintf(loghand, ['\n' 'pos ' rob_dr]);
       write_rois(clpos_data, rob_dr);
       make_masked_tmap(rob_dr);
       [pos_dir_list, pos_label_list] = ks_betas_to_vals_corrected(clpos_data, subjects, Data.reg_names, Data.mem_res_dir, rob_dr);
       add_canlab_paths()
    elseif ~isempty(clneg_data)
       fprintf(loghand, ['\n' 'neg ' rob_dr]);
       write_rois(clneg_data, rob_dr);
       make_masked_tmap(rob_dr)
       [neg_dir_list, neg_label_list] = ks_betas_to_vals_corrected(clneg_data, subjects, Data.reg_names, Data.mem_res_dir, rob_dr);
       add_canlab_paths()
    end
    save clpos
    save clneg
    dir_list = [pos_dir_list neg_dir_list];
    label_list = [pos_label_list neg_label_list];
end


logname = fullfile(mem_res_dir, 'robust_results.txt'); [clpos, clneg, clpos_data, clneg_data] = mediation_brain_results('rob0', 'thresh', [.001], 'size', [5], 'fdrthresh', .05, 'prune');
loghand = fopen(logname,'wt');


end

function add_canlab_paths()
    addpath(genpath('/Users/katherine/CanlabCore-master/'));
    addpath(genpath('/Users/katherine/RobustToolbox-master/'));
    addpath(genpath('/Users/katherine/MediationToolbox-master/'));
end

