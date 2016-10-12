function ks_spec_bpsanitycheck_mem_func(Data, Time, Parameters)

subjects = Data.Subjects;
data_path = Data.data_dir;
lrn_res_dir = Data.lrn_res_dir;
mem_res_dir = Data.mem_res_dir;
bp_ons_dir = Data.bp_ons_dir;
lrn_ons_dir = Data.lrn_ons_dir;
mem_ons_dir = Data.mem_ons_dir;
lrn_log_dir = Data.lrn_log_dir;
mem_log_dir = Data.mem_log_dir;
art_dir = Data.art_dir;
sess_type = {'mem'};

%%initialize defaults

spm('Defaults','fMRI');
spm_get_defaults('defaults.mask.thresh', 0);

spm_jobman('initcfg');


for i=1:numel(subjects)
    for lm = 1:numel(sess_type)
    clear files onsets matlabbatch rp events
        tally = 0;
        subject = subjects(i).ID;
        if strcmp(sess_type{lm}, 'mem')
            sessions = subjects(i).mem_runs; 
            resdir = fullfile(mem_res_dir, subject);
            consdir = mem_ons_dir;
            logdir = mem_log_dir;
        else
            continue
        end
    if ~exist(resdir, 'dir')
        mkdir(resdir);
    end
    matlabbatch{1}.spm.util.cdir.directory  = {resdir};
    matlabbatch{2}.spm.stats.fmri_spec.dir = {resdir};
    matlabbatch{2}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{2}.spm.stats.fmri_spec.timing.RT = 2.2;
    matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t = 34;
    matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t0 = 17;
    for j=1:numel(sessions)
        tally = tally + 1;
        
        func_run_str = fullfile(data_path, subject, 'func', sessions{j}, ...
            ['swcorr_r' subject sessions{j} '4D.nii']);
        scans = cell(165, 1);
        for scan = 1:165
            scans{scan, 1} = horzcat(func_run_str, ',', int2str(scan));
        end
        files{tally} = scans;
        
        rp{tally} = cellstr(spm_select('FPList', fullfile(art_dir, subject, 'func', sessions{j}), '^art_regression_outliers_and_movement_scorr.*\.mat$'));
        name = fullfile(bp_ons_dir, [subject sessions{j} '.txt']);
        delimiter = '\t';
        fID = fopen(name,'r');
        formatSpec = '%f';
        dataArray = textscan(fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
        onsets(tally) = dataArray;
        fclose(fID);
    end
    
    for k = 1:tally
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).scans = files{k};
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).cond.name = 'button_press';
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).cond.onset = onsets{k};
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).cond.duration = 0;
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).cond.tmod = 0;
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).cond.pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).multi = {''};
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).regress = struct('name', {}, 'val', {});
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).multi_reg = rp{k};
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).hpf = 256;
  
    end

    matlabbatch{2}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{2}.spm.stats.fmri_spec.bases.hrf.derivs = [1 1];
    matlabbatch{2}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{2}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{2}.spm.stats.fmri_spec.mthresh = 0;
    matlabbatch{2}.spm.stats.fmri_spec.mask = {'/Volumes/LaCie/LaPrivate/soccog/results/newpreprocsanitycheck/binarized_meanT1.nii,1'};
    matlabbatch{2}.spm.stats.fmri_spec.cvi = 'AR(1)';

    save(fullfile(logdir, [subject '_buttonpress_specify_.mat']), 'matlabbatch');
    output = spm_jobman('run', matlabbatch);
    
end
end
end