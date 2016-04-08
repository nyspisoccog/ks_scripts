function ks_merge_res(Data)



addpath(genpath('/Users/katherine/spm12'));

data_path = Data.data_path;
res_dir = Data.lrn_res_dir;
logdir = Data.lrn_log_dir

sess_type = {'lrn'};
subjects = Data.Subjects;

 
for nsub=1:length(subjects)
    sessions = subjects(nsub).lrn_runs;
    subject = subjects(nsub);
    files = spm_select('FPList', fullfile(res_dir, subject.ID), '^Res_.*\.nii');
    newfile = fullfile(res_dir, subject.ID, [subject.ID 'concres.nii']);
    spm_file_merge(files,newfile);
end
end
