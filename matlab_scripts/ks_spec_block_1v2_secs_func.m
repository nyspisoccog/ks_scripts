function ks_spec_block_1v2_func(Data, Time, Parameters)


subjects = Data.Subjects;
data_path = Data.data_path;
lrn_res_dir = Data.lrn_res_dir;
mem_res_dir = Data.mem_res_dir;
bp_ons_dir = Data.bp_ons_dir;
lrn_ons_dir = Data.lrn_ons_dir;
mem_ons_dir = Data.mem_ons_dir;
lrn_log_dir = Data.lrn_log_dir;
mem_log_dir = Data.mem_log_dir;
sess_type = {'lrn'};

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
    matlabbatch{2}.spm.stats.fmri_spec.bases.hrf.derivs = [1, 1];
    for j=1:numel(sessions)
        tally = tally + 1;
        files{tally} = cellstr(spm_select('FPList', fullfile(data_path, subject, 'func', sessions{j}), '^sw.*\.img$'));
        rp{tally} = cellstr(spm_select('FPList', fullfile(data_path, subject, 'func', sessions{j}), '^rp.*\.txt$'));
        name = fullfile(bp_ons_dir, [subject sessions{j} '.txt']);
        delimiter = '\t';
        fID = fopen(name,'r');
        formatSpec = '%f';
        dataArray = textscan(fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
        onsets(tally) = dataArray;
        fclose(fID);
        con_fname = fullfile(consdir, subject, sessions{j}, 'conds.txt');
        con_fID = fopen(con_fname, 'r');
        formatSpec = '%s';
        con_dataArray = textscan(con_fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
        first_con = con_dataArray{1, 1};
        first_con = first_con{1};
        tt = first_con(2);
        targettypes{tally} = tt;
        fclose(con_fID);
    end
    
    for k = 1:tally
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).scans = files{k};
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).cond(1).name = [targettypes{k} '1'];
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).cond(1).onset = 0;
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).cond(1).duration = 23;
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).cond(1).tmod = 0;
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).cond(2).name = [targettypes{k} '2'];
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).cond(2).onset = 24;
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).cond(2).duration = 23;
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).cond(2).tmod = 0;
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).multi = {''};
         
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).regress = struct('name', {}, 'val', {});
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).multi_reg = rp{k};
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).hpf = 1024;
    end
    end
    save(fullfile(logdir, [subject '_block1v2_specify_.mat']), 'matlabbatch');
    output = spm_jobman('run', matlabbatch);
end
end
