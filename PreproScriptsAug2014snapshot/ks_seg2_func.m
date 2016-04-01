function ks_seg2_func(data, time)

%% Subjects folders
data_path = data.data_path;
logdir = data.logdir; 
subjects = data.Subjects;


%% Time Info

date = time.date;
time1 = time.time1;
time2 = time.time2;


%--------------------------------------------------------------------------
addpath('/home/katie/spm8');   % SPM path
addpath('/home/katie/spm8'); % path containing <editfilename.m>
addpath('/home/katie/spm8/matlabbatch');

%% Initialise SPM defaults
%--------------------------------------------------------------------------
spm('Defaults','fMRI');

spm_jobman('initcfg');

%% Loop over subjects
%--------------------------------------------------------------------------
for i=1:numel(subjects)
    
    clear matlabbatch no
    
    subject = subjects(i).ID;
    
    matlabbatch{1}.cfg_basicio.cfg_cd.dir = cellstr(fullfile(data_path, subject));
    
    no = spm_select('FPList', fullfile(data_path, subject,'anat'), '^no.*\.img$');
    
    matlabbatch{2}.spm.tools.preproc8.channel.vols = cellstr(no);
    matlabbatch{2}.spm.tools.preproc8.channel.biasreg = 0.0001;
    matlabbatch{2}.spm.tools.preproc8.channel.biasfwhm = 60;
    matlabbatch{2}.spm.tools.preproc8.channel.write = [0 0];
    matlabbatch{2}.spm.tools.preproc8.tissue(1).tpm = {'/home/katie/spm8/toolbox/Seg/TPM.nii,1'};
    matlabbatch{2}.spm.tools.preproc8.tissue(1).ngaus = 2;
    matlabbatch{2}.spm.tools.preproc8.tissue(1).native = [1 1];
    matlabbatch{2}.spm.tools.preproc8.tissue(1).warped = [0 0];
    matlabbatch{2}.spm.tools.preproc8.tissue(2).tpm = {'/home/katie/spm8/toolbox/Seg/TPM.nii,2'};
    matlabbatch{2}.spm.tools.preproc8.tissue(2).ngaus = 2;
    matlabbatch{2}.spm.tools.preproc8.tissue(2).native = [1 1];
    matlabbatch{2}.spm.tools.preproc8.tissue(2).warped = [0 0];
    matlabbatch{2}.spm.tools.preproc8.tissue(3).tpm = {'/home/katie/spm8/toolbox/Seg/TPM.nii,3'};
    matlabbatch{2}.spm.tools.preproc8.tissue(3).ngaus = 2;
    matlabbatch{2}.spm.tools.preproc8.tissue(3).native = [1 1];
    matlabbatch{2}.spm.tools.preproc8.tissue(3).warped = [0 0];
    matlabbatch{2}.spm.tools.preproc8.tissue(4).tpm = {'/home/katie/spm8/toolbox/Seg/TPM.nii,4'};
    matlabbatch{2}.spm.tools.preproc8.tissue(4).ngaus = 3;
    matlabbatch{2}.spm.tools.preproc8.tissue(4).native = [1 0];
    matlabbatch{2}.spm.tools.preproc8.tissue(4).warped = [0 0];
    matlabbatch{2}.spm.tools.preproc8.tissue(5).tpm = {'/home/katie/spm8/toolbox/Seg/TPM.nii,5'};
    matlabbatch{2}.spm.tools.preproc8.tissue(5).ngaus = 4;
    matlabbatch{2}.spm.tools.preproc8.tissue(5).native = [1 0];
    matlabbatch{2}.spm.tools.preproc8.tissue(5).warped = [0 0];
    matlabbatch{2}.spm.tools.preproc8.tissue(6).tpm = {'/home/katie/spm8/toolbox/Seg/TPM.nii,6'};
    matlabbatch{2}.spm.tools.preproc8.tissue(6).ngaus = 2;
    matlabbatch{2}.spm.tools.preproc8.tissue(6).native = [0 0];
    matlabbatch{2}.spm.tools.preproc8.tissue(6).warped = [0 0];
    matlabbatch{2}.spm.tools.preproc8.warp.mrf = 0;
    matlabbatch{2}.spm.tools.preproc8.warp.reg = 4;
    matlabbatch{2}.spm.tools.preproc8.warp.affreg = 'mni';
    matlabbatch{2}.spm.tools.preproc8.warp.samp = 3;
    matlabbatch{2}.spm.tools.preproc8.warp.write = [0 0];
    
    %% SAVE AND RUN JOB
    %----------------------------------------------------------------------
    save(fullfile(logdir, [subject, '_', date, '_', 'Time', time1, time2, '_seg2.mat']),'matlabbatch');
    %spm_jobman('interactive',jobs);
    output = spm_jobman('run',matlabbatch);
    
end