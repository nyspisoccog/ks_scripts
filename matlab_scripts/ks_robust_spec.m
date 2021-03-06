function ks_robust_spec(Data, Time, Num)

spm('Defaults','fMRI');
spm_get_defaults('defaults.mask.thresh', 0);
spm_jobman('initcfg');
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

%loop through main contrasts
%fit and get results for contrasts
%for every main contrast with sig results, call function to generate ROIS, 
%make CSV files
%then loop through subdirectories we just made
%for every followup contrast
% specify follow up contrasts with smaller mask within sub directory
% cd into it to get results.




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



for i=1:Num
    clear confiles
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
    
    EXPT_CLUSTER.SNPM.P{i} = confiles;
    
    load(fullfile(mem_res_dir, '7404', 'derivboost', 'SPM.mat'));
    EXPT_CLUSTER.SNPM.connames{i} = SPM.xCon(i).name;
    EXPT_CLUSTER.SNPM.connums(i) = i;
end

EXPT_CLUSTER.SNPM.connames = char(EXPT_CLUSTER.SNPM.connames{:});

EXPT_WHOLE_BRAIN.SNPM.connames = char(EXPT_WHOLE_BRAIN.SNPM.connames{:});
EXPT_WHOLE_BRAIN.SNPM.mask = which('brainmask.nii');

cd(lrn_res_dir)
mask = which('brainmask.nii');
EXPT_WHOLE_BRAIN = robfit(EXPT_WHOLE_BRAIN, 1:length(EXPT_WHOLE_BRAIN.SNPM.connums), 0, mask);
save EXPT_WHOLE_BRAIN



for i = 1:4
    zeropad = '000';
    rob_dr = [mem_res_dir '/robust' zeropad int2str(i)];
    cd(rob_dr)
    addpath(genpath('/Users/katherine/MediationToolbox-master/'))
    [clpos, clneg, clpos_data, clneg_data] = mediation_brain_results('rob0', 'thresh', [.001], 'size', [5], 'prune');
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
    for j = 1:length(dir_list)
        if ~exist(dir_list{j}, 'dir')
            mkdir(dir_list{j})
        end
        cd(dir_list{j})
        mask = fullfile(rob_dr, [label_list{j} '.nii']);
        EXPT_CLUSTER_NEW = EXPT_CLUSTER;
        EXPT_CLUSTER_NEW.SNPM.mask = mask;
        EXPT_CLUSTER_NEW = robfit(EXPT_CLUSTER_NEW, 1:length(EXPT_CLUSTER.SNPM.connums), 0, mask);
        save EXPT_CLUSTER_NEW
        for k = 5:14
            if k < 10
                zeropad = '000';
            else
                zeropad = '00';
            end
            sub_dr = [dir_list{j} '/robust' zeropad int2str(k)];
            cd(sub_dr)
            [clpos, clneg, clpos_data, clneg_data] = mediation_brain_results('rob0', 'thresh', [.001], 'size', [5], 'prune');
        end
    end
end


logname = fullfile(mem_res_dir, 'robust_results.txt');
loghand = fopen(logname,'wt');


end

function add_canlab_paths()
    addpath(genpath('/Users/katherine/CanlabCore-master/'));
    addpath(genpath('/Users/katherine/RobustToolbox-master/'));
    addpath(genpath('/Users/katherine/MediationToolbox-master/'));
end

