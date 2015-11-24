function ks_spec_bp_event_wrp_func(Data, Time)


data_path = Data.data_path;
results_folder = Data.results_folder;
onsets_folder = Data.onsets_folder;
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
    resdir = fullfile(results_folder, subject)
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
        name = [char(subject) char(sessions(j))];
        filename = fullfile(onsets_folder, name);
        delimiter = '\t';
        fID = fopen(filename,'r');
        formatSpec = '%f';
        dataArray = textscan(fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
        onsets(tally) = dataArray;
        fclose(fID);
    end
    
    for k = 1:tally
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).scans = files{k}
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).cond.name = 'button_press';
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).cond.onset = onsets{k};
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).cond.duration = 0;
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).cond.tmod = 0;
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).cond.pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).multi = {''};
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).regress = struct('name', {}, 'val', {});
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).multi_reg = rp{k};
        matlabbatch{2}.spm.stats.fmri_spec.sess(k).hpf = 128;
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