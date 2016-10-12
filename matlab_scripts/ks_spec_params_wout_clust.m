function ks_spec_params_wout_clust(Data, Time, Parameters)

data_dir = Data.data_dir;
art_path = Data.art_dir;
lrn_res_dir = Data.lrn_res_dir;
mem_res_dir = Data.mem_res_dir;
bp_ons_dir = Data.bp_ons_dir;
lrn_ons_dir = Data.lrn_ons_dir;
mem_ons_dir = Data.mem_ons_dir;
lrn_log_dir = Data.lrn_log_dir; 
mem_log_dir = Data.mem_log_dir;
sess_type = {'mem'};
subjects = Data.Subjects;

spmd
    [old_DYLD_LIBRARY_PATH, old_PATH] = setup_SPM('/shared/persisted/spm12');
end

%%initialize defaults

spmd
    
    spm('Defaults','fMRI');

    spm_get_defaults('defaults.mask.thresh', 0);

    spm_jobman('initcfg');

end

for i=1:numel(subjects)
    fclose all
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
            logdir = mem_log_dir;
        end
        
        end
        subs(i).matlabbatch{1}.cfg_basicio.cfg_cd.dir = {resdir};
        subs(i).matlabbatch{2}.spm.stats.fmri_spec.dir = {resdir};
        subs(i).matlabbatch{2}.spm.stats.fmri_spec.timing.units = 'secs';
        subs(i).matlabbatch{2}.spm.stats.fmri_spec.timing.RT = 2.2;
        subs(i).matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t = 34;
        subs(i).matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t0 = 17;
    
        for j=1:numel(sessions)
        
            tally = tally + 1;
            
            func_run_str = fullfile(data_dir, subject, 'func', sessions{j}, ...
                ['swcorr_r' subject sessions{j} '4D.nii']);
            scans = cell(165, 1);
            for scan = 1:165
                scans{scan, 1} = horzcat(func_run_str, ',', int2str(scan));
            end
            files{tally} = scans;
            
            spmd
                rp{tally} = cellstr(fullfile(fullfile(art_path, subject, 'func', sessions{j}),...
                    ['art_regression_outliers_and_movement_scorr_r' subject sessions{j} '4D_00001.mat']));
            end
        
            delimiter = '\t';
        
            bp_fname = fullfile(bp_ons_dir, [subject sessions{j} '.txt']);
            spmd
                bp_fID = fopen(bp_fname,'r');
            end
            formatSpec = '%f';
            spmd
                bp_dataArray = textscan(bp_fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
                events.bp.onsets(tally) = bp_dataArray;
            end
            
            
            
            disp(subject)
            disp(sessions{j})
            
            con_fname = fullfile(consdir, subject, sessions{j}, 'conds.txt');
            disp(con_fname)
            spmd
                con_fID = fopen(con_fname, 'r');
            end
            formatSpec = '%s';
            spmd
                con_dataArray = textscan(con_fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
                
                fclose(con_fID);
                
            end
            spmd
                events.conditions.names(tally) = con_dataArray;
                cond_list = events.conditions.names{tally};
            end
            
        
            
            
            for k = 1:numel(cond_list)
               
            spmd   
                cond_ons_fname = fullfile(consdir, subject, sessions{j}, [cond_list{k} '.txt']);
            end    
                spmd
                    cond_ons_fID = fopen(cond_ons_fname, 'r');
                    formatSpec = '%f';
                end
                spmd
                    cond_ons_dataArray = textscan(cond_ons_fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
                    events.conditions.sessions(tally).onsets(k) = cond_ons_dataArray;
                    fclose(cond_ons_fID);
                end
                
                
                if strcmp(Parameters.RT.val, 'y')
                    RT_fname = fullfile(consdir, subject, sessions{j}, [cond_list{k} '_RT.txt']);
                    RT_fID = fopen(RT_fname,  'r');
                    formatSpec = '%f';
                    RT_dataArray = textscan(RT_fID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false);
                    events.conditions.sessions(tally).RT(k) = RT_dataArray;
                    fclose(RT_fID);
                end
                
                if strcmp(Parameters.ans.val, 'y') && lm == 2
                    ans_fname = fullfile(consdir, subject, sessions{j}, [cond_list{k} '_ans.txt']);
                    spmd
                        ans_fID = fopen(ans_fname,'r');
                    end
                    formatSpec = '%f';
                    spmd
                        ans_dataArray = textscan(ans_fID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false);
                    end
                    events.conditions.sessions(tally).ans(k) = ans_dataArray;
                    spmd
                        fclose(ans_fID);
                    end
                    
                end
                
            end
        end
    
        for m = 1:tally
            disp(['session is ' sessions{m}]);
            subs(i).matlabbatch{2}.spm.stats.fmri_spec.sess(m).scans = files{m};
            sess_onsets = events.conditions.sessions(m).onsets;
            cond_list = events.conditions.names{m};
            nconds = numel(cond_list);
            
            if strcmp(Parameters.ans.val, 'y') && lm == 2
                sess_ans = events.conditions.sessions(m).ans;
            end
            
            if strcmp(Parameters.RT.val, 'y')
                sess_RT = events.conditions.sessions(m).RT;
            end
                
            for n = 1:nconds
                cond_onsets = sess_onsets{n};
                len = numel(cond_onsets);
                subs(i).matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n).name = cond_list{n};
                subs(i).matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n).onset = cond_onsets;
                subs(i).matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n).duration = repmat(4, len, 1);
                if strcmp(Parameters.tmod.val, 'y')
                    subs(i).matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n).tmod = 1;
                else
                    subs(i).matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n).tmod = 0;
                end
                
                pmod = 1;
                
                if strcmp(Parameters.ans.val, 'y') && lm == 2
                    cond_ans = sess_ans{n};
                    subs(i).matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n).pmod(pmod) = struct('name', {'ans'}, 'param', {cond_ans}, 'poly', {1});
                    pmod = 2;
                end    
                
                if strcmp(Parameters.RT.val, 'y')
                    cond_RTs = sess_RT{n};
                    subs(i).matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n).pmod(pmod) = struct('name', {'RT'}, 'param', {cond_RTs}, 'poly', {1});
                end
                
                   
            end
            
            if strcmp(Parameters.buttonpress.val, 'y')
                subs(i).matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(nconds + 1).name = 'button_press';
                subs(i).matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(nconds + 1).onset = events.bp.onsets{m};
                subs(i).matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(nconds + 1).duration = 0;
                subs(i).matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(nconds + 1).tmod = 0;
                subs(i).matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(nconds + 1).pmod = struct('name', {}, 'param', {}, 'poly', {});
            end
            
            subs(i).matlabbatch{2}.spm.stats.fmri_spec.sess(m).multi = {''};
            subs(i).matlabbatch{2}.spm.stats.fmri_spec.sess(m).regress = struct('name', {}, 'val', {});
        
            if strcmp(Parameters.motion.val, 'y')
                subs(i).matlabbatch{2}.spm.stats.fmri_spec.sess(m).multi_reg = rp{k};
            else
                subs(i).matlabbatch{2}.spm.stats.fmri_spec.sess(m).multi_reg = {};
            end
            
            
        subs(i).matlabbatch{2}.spm.stats.fmri_spec.sess(m).hpf = 256;
        end

        subs(i).matlabbatch{2}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
        
        derivs = [0 0];
        if strcmp(Parameters.timed.val, 'y')
            derivs(1) = 1;
        end
        if strcmp(Parameters.dispersed.val, 'y')
            derivs(2) = 1;
        end   

        subs(i).matlabbatch{2}.spm.stats.fmri_spec.bases.hrf.derivs = derivs;
        subs(i).matlabbatch{2}.spm.stats.fmri_spec.volt = 1;
        subs(i).matlabbatch{2}.spm.stats.fmri_spec.global = 'None';
        subs(i).matlabbatch{2}.spm.stats.fmri_spec.mthresh = 0;
        subs(i).matlabbatch{2}.spm.stats.fmri_spec.mask = {'/Volumes/LaCie/LaPrivate/soccog/results/newpreprocsanitycheck/binarized_meanT1.nii,1'};
        subs(i).matlabbatch{2}.spm.stats.fmri_spec.cvi = 'AR(1)';
        matlabbatch = subs(i).matlabbatch;
        save(fullfile(logdir, [subject sess_type{lm} '_modelspec.mat']), 'matlabbatch');
       
    
    end




spmd
    if ~exist(resdir)
        mkdir(resdir)
    end
end

parfor nsub = 1:length(subjects)
    spm_jobman('initcfg');
    out = spm_jobman('run',subs(nsub).matlabbatch)
end

spmd
    finish_SPM(old_DYLD_LIBRARY_PATH, old_PATH);
end
clear matlabbatch subject out subjects events
end