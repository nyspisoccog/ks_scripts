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





EXPT.subjects = repmat(char(0),length(subjects), ...
    length(fullfile(mem_res_dir, subjects(1).ID)));

for nsub = 1:length(subjects)
    EXPT.subjects(nsub, :) = fullfile(mem_res_dir, subjects(nsub).ID);
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
    
    EXPT.SNPM.P{i} = confiles;
    
    load(fullfile(mem_res_dir, '7404', 'derivboost', 'SPM.mat'));
    EXPT.SNPM.connames{i} = SPM.xCon(i).name;
    EXPT.SNPM.connums(i) = i;
end


EXPT.SNPM.connames = char(EXPT.SNPM.connames{:});
EXPT_WHOLE_BRAIN = EXPT
EXPT_WHOLE_BRAIN.SNPM.mask = which('brainmask.nii');
EXPT_CLUSTER = EXPT
cd(lrn_res_dir)
mask = which('brainmask.nii');
EXPT_WHOLE_BRAIN = robfit(EXPT_WHOLE_BRAIN, 1:length(EXPT.SNPM.connums), 0, mask);
save EXPT_WHOLE_BRAIN
mask = fullfile(mem_res_dir, 'robust0003', 'LBA47_roi.nii');
cd(fullfile(mem_res_dir, 'lba47'))
EXPT_CLUSTER = robfit(EXPT_CLUSTER, 1:length(EXPT.SNPM.connums), 0, mask);
save EXPT_CLUSTER

logname = fullfile(mem_res_dir, 'robust_results.txt');
loghand = fopen(logname,'wt');


for i=1:Num
    if i < 10
        zeropad = '000';
    else
        zeropad = '00';
    end
    if i < 4
        dr = [lrn_res_dir '/robust' zeropad int2str(i)];
        cd(dr)
        addpath(genpath('/Users/katherine/MediationToolbox-master/'))
        [clpos, clneg, clpos_data, clneg_data] = mediation_brain_results('rob0', 'thresh', [.001], 'size', [5], 'prune');
        if ~isempty(clpos_data)
            fprintf(loghand, ['\n' 'pos ' dr]);
            write_roi(clpos_data, dr);
            make_masked_tmap(dr);
            ks_betas_to_vals(clpos_data, subjects, Data.reg_names, Data.mem_res_dir, dr);
            add_canlab_paths()
        elseif ~isempty(clneg_data)
            fprintf(loghand, ['\n' 'neg ' dr]);
            write_roi(clneg_data, dr);
            make_masked_tmap(dr)
            ks_betas_to_vals_corrected(clneg_data, subjects, Data.reg_names, Data.mem_res_dir, dr);
            add_canlab_paths()
        end
        save clpos
        save clneg
        save clpos_data;
        save clneg_data;
    end
    dr = [fullfile(mem_res_dir, 'lba47') '/robust' zeropad int2str(i)];
    cd(dr)
    [clpos, clneg, clpos_data, clneg_data] = mediation_brain_results('rob0', 'thresh', [.001], 'size', [5], 'prune');
    if ~isempty(clpos_data)
        fprintf(loghand, ['\n' 'pos ' dr]);
    elseif ~isempty(clneg_data)
        fprintf(loghand, ['\n' 'neg ' dr]);
    end
    save clpos
    save clneg
    save clpos_data
    save clneg_data
end




 
%%

%%
%%

end

function add_canlab_paths()
    addpath(genpath('/Users/katherine/CanlabCore-master/'));
    addpath(genpath('/Users/katherine/RobustToolbox-master/'));
    addpath(genpath('/Users/katherine/MediationToolbox-master/'));
end

