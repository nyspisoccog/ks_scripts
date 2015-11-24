function ks_spec_conds_event_wrp_experiment(Data, Time)


data_path = Data.data_path;
results_folder = Data.results_folder;
bp_onsets_folder = Data.bp_onsets_folder;
cond_onsets_folder = Data.cond_onsets_folder
logdir = Data.logdir ; 

subjects = Data.Subjects;

%%initialize defaults

spm('Defaults','fMRI');

spm_jobman('initcfg');

for i=1:numel(subjects)
    clear files onsets matlabbatch rp
    tally = 0
    subject = subjects(i).ID;
    sessions = subjects(i).Runs;
    resdir = fullfile(results_folder, subject);
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
        
        filename = fullfile(bp_onsets_folder, [subject sessions{j}]);
        fID1 = fopen(filename,'r');
        formatSpec = '%f';
        dataArray1 = textscan(fID1, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
        events.bp.onsets(tally) = dataArray1;
        
        
        cond_list_filename = fullfile(cond_onsets_folder, subject, sessions{j}, 'conds.txt');
        fID2 = fopen(cond_list_filename, 'r');
        formatSpec = '%s';
        dataArray2 = textscan(fID2, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
        events.conditions.names(tally) = dataArray2;
        fclose(fID2);
        
        cond_list = events.conditions.names{tally};
        for k = 1:numel(cond_list)
            cond_onsets_filename = fullfile(cond_onsets_folder, subject, sessions{j}, [cond_list{k} '.txt']);
            fID3 = fopen(cond_onsets_filename, 'r');
            dataArray3 = textscan(fID3, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
            events.conditions.sessions(tally).onsets(k) = dataArray3;
            fclose(fID3);
        end
        
    end
    
    for m = 1:tally
        matlabbatch{2}.spm.stats.fmri_spec.sess(m).scans = files{m};
        matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(1).name = 'button_press';
        matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(1).onset = events.bp.onsets{m};
        matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(1).duration = 0;
        matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(1).tmod = 0;
        matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
        
        sess_onsets = events.conditions.sessions(tally).onsets{1};
        for n = 1:numel(sess_onsets)
            len = numel(sess_onsets{n});
            cond_list = events.conditions.names{tally};
            cond_onsets = sess_onsets{n};
            matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond = [matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n+1)]    
            matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n+1).name = cond_list{n};
            matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n+1).onset = cond_onsets;
            matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n+1).duration = repmat([4], len, 1);
            matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n+1).tmod = 0;
            matlabbatch{2}.spm.stats.fmri_spec.sess(m).cond(n+1).pmod = struct('name', {}, 'param', {}, 'poly', {});
        end
        
        matlabbatch{2}.spm.stats.fmri_spec.sess(m).multi = {''};
        matlabbatch{2}.spm.stats.fmri_spec.sess(m).regress = struct('name', {}, 'val', {});
        matlabbatch{2}.spm.stats.fmri_spec.sess(m).multi_reg = rp{k};
        matlabbatch{2}.spm.stats.fmri_spec.sess(m).hpf = 128;
    end

    matlabbatch{2}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{2}.spm.stats.fmri_spec.bases.hrf.derivs = [1 0];
    matlabbatch{2}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{2}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{2}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{2}.spm.stats.fmri_spec.cvi = 'AR(1)';

    save(fullfile(logdir, [subject '_buttonpress_specify_.mat']), 'matlabbatch');
    output = spm_jobman('run', matlabbatch);
    
end

end