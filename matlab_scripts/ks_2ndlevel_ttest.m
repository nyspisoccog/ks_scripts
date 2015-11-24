resdir = '/media/truecrypt1/SocCog/test/noMV_noval_tmod/lrn';

subjects = {'7404', '7408', '7412', '7414', '7418', '7430', '7432',...
            '7436', '7443', '7453', '7458', '7474', '7477', '7478', '7480',...
            '7498', '7508', '7521', '7533', '7534', '7542', '7558', '7561',...
            '7562', '7575', '7580', '7607', '7613', '7619', '7623', '7638',...
            '7641', '7645', '7648', '7649', '7659', '7714', '7719', '7726'};
for i = 1:10
    d = [resdir '/con' int2str(i)];
    if ~exist(d, 'dir')
        mkdir(d)
    end
    files = {};
    for j = 1:length(subjects)
        files = vertcat(files, spm_select('FPList', fullfile(resdir, subjects{i}), ['^con.*' int2str(i) '\.img$']));
    end
    matlabbatch{1}.spm.stats.factorial_design.dir = {d};
    matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = {files};
    matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
    matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
    matlabbatch{2}.spm.stats.fmri_est.spmmat = {fullfile(d, 'SPM.mat')};
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    
    save(fullfile(d, '2ndlevel.mat'), 'matlabbatch');
    output = spm_jobman('run', matlabbatch);
    
    clear matlabbatch files output;
end