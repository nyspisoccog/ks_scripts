

function ks_spec_mixedblockevent_(Data, Time, Parameters)

data_path = Data.data_path;
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

            func_run_str = fullfile(data_path, subject, sessions{j}, ...
                [subject sessions{j} '4D.nii']);
            scans = cell(56, 1);
            for scan = 1:56
                scans{scan, 1} = horzcat(func_run_str, ',', int2str(scan));
            end
            files{tally} = scans;
            rp{tally} = cellstr(spm_select('FPList', fullfile(data_path, subject, 'func', sessions{j}), '^r7.*\.txt$'));
            %files{tally} = cellstr(spm_select('FPList', fullfile(data_path, subject, 'func', sessions{j}), '^sw.*\.img$'));
            %rp{tally} = cellstr(spm_select('FPList', fullfile(data_path, subject, 'func', sessions{j}), '^rp.*\.txt$'));

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

            allonsets = [];
            for k = 1:length(cond_list)
                cond_ons_fname = fullfile(consdir, subject, sessions{j}, [cond_list{k} '.txt']);
                cond_ons_fID = fopen(cond_ons_fname, 'r');
                formatSpec = '%f';
                cond_ons_dataArray = textscan(cond_ons_fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
                allonsets = vertcat(allonsets, cond_ons_dataArray{1, 1});
                fclose(cond_ons_fID);
            end

            allonsets = sort(allonsets);


            for k = 1:numel(cond_list)
                cond_ons_fname = fullfile(consdir, subject, sessions{j}, [cond_list{k} '.txt']);
                cond_ons_fID = fopen(cond_ons_fname, 'r');
                formatSpec = '%f';
                cond_ons_dataArray = textscan(cond_ons_fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
                events.conditions.sessions(tally).onsets(k) = cond_ons_dataArray;

                fclose(cond_ons_fID);

                middle = ceil(length(allonsets)/2);
                events.conditions.sessions(tally).dur(1) = ...
                    allonsets(middle);
                events.conditions.sessions(tally).dur(2) = ...
                    allonsets(end) - allonsets(middle) + 3.999;
                events.conditions.sessions(tally).strt(1) = 0;
                events.conditions.sessions(tally).strt(2) = allonsets(middle);

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
                    ans_fID = fopen(ans_fname,'r');
                    formatSpec = '%f';
                    ans_dataArray = textscan(ans_fID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false);
                    events.conditions.sessions(tally).ans(k) = ans_dataArray;
                    fclose(ans_fID);

                end

            end
        end

        for m = 1:tally
            disp(['session is ' sessions{m}]);
            matlabbatch{2}.spm.stats.fmri_spec.sess(m).scans = files{m};
            sess_onsets = events.conditions.sessions(m).onsets;
            cond_list = events.conditions.names{m};
            nconds = length(cond_list);

            if strcmp(Parameters.ans.val, 'y') && lm == 2
                sess_ans = events.conditions.sessions(m).ans;
            end

            if strcmp(Parameters.RT.val, 'y')
                sess_RT = events.conditions.sessions(m).RT;
            end

            for n = 1:nconds
                cond_onsets = sess_onsets{n};
                len = numel(cond_onsets);
                matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n).name = cond_list{n};
                matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n).onset = cond_onsets;
                matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n).duration = repmat(4, len, 1);
                if strcmp(Parameters.tmod.val, 'y')
                    matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n).tmod = 1;
                else
                    matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n).tmod = 0;
                end

                pmod = 1;

                if strcmp(Parameters.ans.val, 'y') && lm == 2
                    cond_ans = sess_ans{n};
                    matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n).pmod(pmod) = struct('name', {'ans'}, 'param', {cond_ans}, 'poly', {1});
                    pmod = 2;
                end    

                if strcmp(Parameters.RT.val, 'y')
                    cond_RTs = sess_RT{n};
                    matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n).pmod(pmod) = struct('name', {'RT'}, 'param', {cond_RTs}, 'poly', {1});
                end


            end

            targettype = cond_list{1};
            targettype = cond_list{2};
            matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n+1).name = [targettype(2), '1'];
            matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n+1).onset = ...
                events.conditions.sessions(tally).strt(1);
            matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n+1).duration = ...
                events.conditions.sessions(tally).dur(1);
            matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n+2).name = [targettype(2), '2'];
            matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n+2).onset = ...
                events.conditions.sessions(tally).strt(2);
            matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n+2).duration = ...
                events.conditions.sessions(tally).strt(2);



            if strcmp(Parameters.buttonpress.val, 'y')
                matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(nconds + 3).name = 'button_press';
                matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(nconds + 3).onset = events.bp.onsets{m};
                matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(nconds + 3).duration = 0;
                matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(nconds + 3).tmod = 0;
                matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(nconds + 3).pmod = struct('name', {}, 'param', {}, 'poly', {});
            end

            matlabbatch{2}.spm.stats.fmri_spec.sess(m).multi = {''};
            matlabbatch{2}.spm.stats.fmri_spec.sess(m).regress = struct('name', {}, 'val', {});

            if strcmp(Parameters.motion.val, 'y')
                matlabbatch{2}.spm.stats.fmri_spec.sess(m).multi_reg = rp{k};
            else
                matlabbatch{2}.spm.stats.fmri_spec.sess(m).multi_reg = {};
            end


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
end
end