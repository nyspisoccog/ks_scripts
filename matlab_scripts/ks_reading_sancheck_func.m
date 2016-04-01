function ks_spec_params_wout_func(Data, Time, Parameters)

data_path = Data.data_path;
art_path = Data.art_dir;
lrn_res_dir = Data.lrn_res_dir;
mem_res_dir = Data.mem_res_dir;
bp_ons_dir = Data.bp_ons_dir;
lrn_ons_dir = Data.lrn_ons_dir;
mem_ons_dir = Data.mem_ons_dir;
lrn_log_dir = Data.lrn_log_dir; 
mem_log_dir = Data.mem_log_dir;
sess_type = {'lrn'};
subjects = Data.Subjects;

%%initialize defaults

spm('Defaults','fMRI');

spm_jobman('initcfg');

for i=1:numel(subjects)
    for lm = 1:numel(sess_type)
        clear files onsets matlabbatch rp events
        tally = 0;
        subject = subjects(i).ID;
        if strcmp(sess_type{lm}, 'lrn')
            sessions = subjects(i).lrn_runs;
            resdir = fullfile(lrn_res_dir, subject);
            consdir = lrn_ons_dir;
            logdir = lrn_log_dir;
        else
            sessions = subjects(i).mem_runs;
            resdir = fullfile(mem_res_dir, subject);
            consdir = mem_ons_dir;
            logdir = lrn_log_dir;
        end
        if ~exist(resdir, 'dir')
            mkdir(resdir);
        end
        matlabbatch{1}.cfg_basicio.cfg_cd.dir = {resdir};
        matlabbatch{2}.spm.stats.fmri_spec.dir = {resdir};
        matlabbatch{2}.spm.stats.fmri_spec.timing.units = 'secs';
        matlabbatch{2}.spm.stats.fmri_spec.timing.RT = 2.2;
        matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t = 34;
        matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t0 = 17;
    
        for j=1:numel(sessions)
        
            tally = tally + 1;
            
            func_run_str = fullfile(data_path, subject, 'func', sessions{j}, ...
                [subject sessions{j} '4D.nii']);
            scans = cell(56, 1);
            for scan = 1:56
                scans{scan, 1} = horzcat(func_run_str, ',', int2str(scan));
            end
            files{tally} = scans;
            rp{tally} = cellstr(spm_select('FPList', fullfile(data_path, subject, 'func', sessions{j}), '^art_regression_outliers_and_movement_scorr.*\.mat$'));
           
            delimiter = '\t';
        
            bp_fname = fullfile(bp_ons_dir, [subject sessions{j} '.txt']);
            bp_fID = fopen(bp_fname,'r');
            formatSpec = '%f';
            bp_dataArray = textscan(bp_fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
            events.bp.onsets(tally) = bp_dataArray;
            
            
            disp(subject)
            disp(sessions{j})
            
            con_fname = fullfile(consdir, subject, sessions{j}, 'conds.txt');
            disp(con_fname)
            con_fID = fopen(con_fname, 'r');
            formatSpec = '%s';
            con_dataArray = textscan(con_fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
            events.conditions.names(tally) = con_dataArray;
            fclose(con_fID);
        
            cond_list = events.conditions.names{tally};
            
            all_onsets = {};
            for k = 1:numel(cond_list)
                cond_ons_fname = fullfile(consdir, subject, sessions{j}, [cond_list{k} '.txt']);
                cond_ons_fID = fopen(cond_ons_fname, 'r');
                formatSpec = '%f';
                cond_ons_dataArray = textscan(cond_ons_fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
                events.conditions.sessions(tally).onsets(k) = cond_ons_dataArray;
                all_onsets = [all_onsets; cond_ons_dataArray];
                fclose(cond_ons_fID);
                
            end
        end
    
        
        matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n).name = 'sentence';
        matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n).onset = all_onsets;
        matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n).duration = ...
            repmat(4, length(all_onsets), 1);
        
    end
            
      
    matlabbatch{2}.spm.stats.fmri_spec.sess(m).multi = {''};
    matlabbatch{2}.spm.stats.fmri_spec.sess(m).regress = struct('name', {}, 'val', {});
    
    matlabbatch{2}.spm.stats.fmri_spec.sess(m).hpf = 1024;
    end

    matlabbatch{2}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
        
    derivs = [0 0];
    if strcmp(Parameters.timed.val, 'y')
        derivs(1) = 1;
    end
    if strcmp(Parameters.dispersed.val, 'y')
        derivs(2) = 1;
    end   

    matlabbatch{2}.spm.stats.fmri_spec.bases.hrf.derivs = derivs;
    matlabbatch{2}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{2}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{2}.spm.stats.fmri_spec.mthresh = 0;
    matlabbatch{2}.spm.stats.fmri_spec.mask = {'/Volumes/LaCie/LaPrivate/soccog/results/newpreprocsanitycheck/binarized_meanT1.nii,1'};

    matlabbatch{2}.spm.stats.fmri_spec.cvi = 'AR(1)';

    save(fullfile(logdir, [subject sess_type{lm} '_modelspec.mat']), 'matlabbatch');
    output = spm_jobman('run', matlabbatch);
    
    end

