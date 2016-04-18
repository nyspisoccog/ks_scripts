clear all

addpath(genpath('/Users/katherine/spm12'));

subjects = {'7404', '7408', '7412', '7414', '7418', '7430', '7432',...
            '7436', '7443', '7453', '7458', '7474', '7477', '7478', '7480',...
            '7498', '7508', '7521', '7533', '7534', '7542', '7558', '7561',...
            '7562', '7575', '7580', '7607', '7619', '7623', '7638',...
            '7641', '7645', '7648', '7649', '7659', '7714', '7719', '7726'};


resdir = '/Volumes/LaCie/LaPrivate/soccog/results/hrfsancheck_noconn/lrn';
logdir = '/Volumes/LaCie/LaPrivate/soccog/results/hrfsancheck/logdir/lrn';
roidir = '/Volumes/LaCie/LaPrivate/soccog/results/hrfsancheck/lrn';

% Set up the SPM defaults
spm('defaults', 'fmri');

for nsub=1:length(subjects)
    clear matlabbatch
    
    subject = subjects{nsub};
    for nTR = 1:14
        matlabbatch{1}.spm.util.imcalc.input = {
                                                '/Volumes/LaCie/LaPrivate/soccog/results/hrfsancheck/lrn/ROI_LBA4_MNI.img,1'
                                                fullfile(resdir, subject, ['HRF_timecourse_cond0001.img,' num2str(nTR)])
                                                };
        matlabbatch{1}.spm.util.imcalc.output = ['LBA4_activation' num2str(nTR)];
        matlabbatch{1}.spm.util.imcalc.outdir = {fullfile(resdir, subject)};
        matlabbatch{1}.spm.util.imcalc.expression = 'i2.*(i1>0)';
        matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
        matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
        matlabbatch{1}.spm.util.imcalc.options.mask = 0;
        matlabbatch{1}.spm.util.imcalc.options.interp = 1;
        matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
        
        save(fullfile(logdir, [subject '_LBA4mask' num2str(nTR) '.mat']), 'matlabbatch');
        out = spm_jobman('run',matlabbatch);
    end
    
    files = spm_select('FPList', fullfile(resdir, subject), '^LBA4_activation_.*\.nii');
    newfile = fullfile(resdir, subject, [subject 'LBA4timecourse.nii']);
    spm_file_merge(files,newfile);
end