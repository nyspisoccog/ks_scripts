function ks_merge_files(Data)



addpath(genpath('/Users/katherine/spm12'));

data_path = Data.data_path;
res_dir = Data.lrn_res_dir;
logdir = Data.lrn_log_dir

sess_type = {'lrn'};
subjects = Data.Subjects;

 
for nsub=1:length(subjects)
    sessions = subjects(nsub).lrn_runs;
    subject = subjects(nsub);
    files = [];
    for nsess=1:length(sessions)
        files(nsess,:) = spm_vol(fullfile(data_path, sess_type{1}, subject.ID, sessions{nsess}, ...
        ['swcorr_r' subject.ID sessions{nsess} '4D.nii']));
    end
    newfile = fullfile(res_dir, subject.ID, sessions{nsess},[subject.ID 'conc4D.nii']);
    spm_file_merge(files,newfile);
    end
    

end
