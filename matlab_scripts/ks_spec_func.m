function ks_spec_func(Data, Time, Parameters)

data_path = Data.data_path;
lrn_res_dir = Data.lrn_res_dir;
mem_res_dir = Data.mem_res_dir;
bp_ons_dir = Data.bp_ons_dir;
lrn_ons_dir = Data.lrn_ons_dir;
mem_ons_dir = Data.mem_ons_dir;
lrn_log_dir = Data.lrn_log_dir; 
mem_log_dir = Data.mem_log_dir;
sess_type = {'lrn', 'mem'};
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
        matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t = 16;
        matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
    
        for j=1:numel(sessions)
        
            tally = tally + 1;
        
            files{tally} = cellstr(spm_select('FPList', fullfile(data_path, subject, 'func', sessions{j}), '^sw.*\.img$'));
            rp{tally} = cellstr(spm_select('FPList', fullfile(data_path, subject, 'func', sessions{j}), '^rp.*\.txt$'));
        
            delimiter = '\t';
        
            bp_fname = fullfile(bp_ons_dir, [subject sessions{j}]);
            bp_fID = fopen(bp_fname,'r');
            formatSpec = '%f';
            bp_dataArray = textscan(bp_fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
            events.bp.onsets(tally) = bp_dataArray;
        
            con_fname = fullfile(consdir, subject, sessions{j}, 'conds.txt');
            con_fID = fopen(con_fname, 'r');
            formatSpec = '%s';
            con_dataArray = textscan(con_fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
            events.conditions.names(tally) = con_dataArray;
            fclose(con_fID);
        
            cond_list = events.conditions.names{tally};
            
            for k = 1:numel(cond_list)
                cond_ons_fname = fullfile(consdir, subject, sessions{j}, [cond_list{k} '.txt']);
                cond_ons_fID = fopen(cond_ons_fname, 'r');
                formatSpec = '%f';
                cond_ons_dataArray = textscan(cond_ons_fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
                events.conditions.sessions(tally).onsets(k) = cond_ons_dataArray;
                fclose(cond_ons_fID);
            end
        end
    
        for m = 1:tally
            matlabbatch{2}.spm.stats.fmri_spec.sess(m).scans = files{m};
            sess_onsets = events.conditions.sessions(tally).onsets;
            cond_list = events.conditions.names{tally};
            nconds = numel(cond_list);
            
            for n = 1:nconds
                len = numel(sess_onsets{n});
                cond_onsets = sess_onsets{n};
                matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n).name = cond_list{n};
                matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n).onset = cond_onsets;
                matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n).duration = repmat([4], len, 1);
                matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n).tmod = 0;
                matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n).pmod = struct('name', {}, 'param', {}, 'poly', {});
            end
            
            if strcmp(Parameters.buttonpress , 'y')
                matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(nconds + 1).name = 'button_press';
                matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(nconds + 1).onset = events.bp.onsets{m};
                matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(nconds + 1).duration = 0;
                matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(nconds + 1).tmod = 0;
                matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(nconds + 1).pmod = struct('name', {}, 'param', {}, 'poly', {});
            end
            
            matlabbatch{2}.spm.stats.fmri_spec.sess(m).multi = {''};
            matlabbatch{2}.spm.stats.fmri_spec.sess(m).regress = struct('name', {}, 'val', {});
        
            if strcmp(Parameters.motion, 'y')
                matlabbatch{2}.spm.stats.fmri_spec.sess(m).multi_reg = rp{k};
            else
                matlabbatch{2}.spm.stats.fmri_spec.sess(m).multi_reg = {};
            end
        matlabbatch{2}.spm.stats.fmri_spec.sess(m).hpf = 128;
        end

        matlabbatch{2}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
        
        derivs = [0 0];
        if strcmp(Parameters.timed, 'y')
            derivs(1) = 1;
        end
        if strcmp(Parameters.dispersed, 'y')
            derivs(2) = 1;
        end   

        matlabbatch{2}.spm.stats.fmri_spec.bases.hrf.derivs = [1 0];
        matlabbatch{2}.spm.stats.fmri_spec.volt = 1;
        matlabbatch{2}.spm.stats.fmri_spec.global = 'None';
        matlabbatch{2}.spm.stats.fmri_spec.mask = {''};
        matlabbatch{2}.spm.stats.fmri_spec.cvi = 'AR(1)';

        save(fullfile(logdir, [subject sess_type{lm} '_modelspec.mat']), 'matlabbatch');
        output = spm_jobman('run', matlabbatch);
    
    end
end
end