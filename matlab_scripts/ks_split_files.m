function ks_split_files(Data)

addpath(genpath('/Users/katherine/spm12'));

data_path = Data.data_path;
res_dir = Data.lrn_res_dir;
logdir = Data.lrn_log_dir

sess_type = {'lrn'};
subjects = Data.Subjects;

 
for nsub=1:length(subjects)
    sessions = subjects(nsub).lrn_runs;
    subject = subjects(nsub);
    a=spm_vol(fullfile(data_path, sess_type{1}, subject.ID, 'conn_denoise', 'results', ...
    'preprocessing', 'niftiDATA_Subject001_Condition000.nii'));
    for nsess = 1:length(sessions)
        last = 56*nsess;
        first = 56*(nsess-1) + 1;
        if ~exist(fullfile(res_dir, subject.ID, sessions{nsess}))
            mkdir(fullfile(res_dir, subject.ID, sessions{nsess}));
        end
        newfile = fullfile(res_dir, subject.ID, sessions{nsess},...
         [subject.ID sessions{nsess} '4D.nii']);
        spm_file_merge(a(first:last),newfile);
    end
    

end
end