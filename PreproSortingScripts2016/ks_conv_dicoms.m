function ks_conv_dicoms(Data, Time)


%% Subjects folders
data_path = Data.data_path;
subjects = Data.Subjects;
logdir = Data.logdir; 


%% Time Info

date = Time.date;
time1 = Time.time1;
time2 = Time.time2;

spm('Defaults','fMRI');

spm_jobman('initcfg');

%--------------------------------------------------------------------------


for i = 1:length(subjects)
    subject = subjects(i).ID;
    sessions = subjects(i).Runs;
    clear matlabbatch
    dicom_dir = fullfile(data_path, subject, 'anat');
    files=spm_select('FPList', dicom_dir, '^i.*');
    matlabbatch{1}.spm.util.import.dicom.data = cellstr(files);     
    matlabbatch{1}.spm.util.import.dicom.root = 'flat';
    matlabbatch{1}.spm.util.import.dicom.outdir = cellstr(dicom_dir);
    matlabbatch{1}.spm.util.import.dicom.protfilter = '.*';
    matlabbatch{1}.spm.util.import.dicom.convopts.format = 'nii';
    matlabbatch{1}.spm.util.import.dicom.convopts.icedims = 0;
    save(fullfile(logdir, ['conv_anat_', date, 'Time', time1, time2, '_', subject, '.mat']), 'matlabbatch');
        output = spm_jobman('run',matlabbatch);
    spare_dir = fullfile(data_path, subject, 'spare_anat');
    dirlist = dir(spare_dir);
    for d=1:length(dirlist)
        name = dirlist(d).name
        if length(name) > 4 && strcmp(name(1:4), 'anat') 
            dicom_dir = fullfile(spare_dir, dirlist(d).name)
        if isdir(dicom_dir)
            files=spm_select('FPList', dicom_dir, '^i.*');
            clear matlabbatch
            matlabbatch{1}.spm.util.import.dicom.data = cellstr(files);     
            matlabbatch{1}.spm.util.import.dicom.root = 'flat';
            matlabbatch{1}.spm.util.import.dicom.outdir = cellstr(dicom_dir);
            matlabbatch{1}.spm.util.import.dicom.protfilter = '.*';
            matlabbatch{1}.spm.util.import.dicom.convopts.format = 'nii';
            matlabbatch{1}.spm.util.import.dicom.convopts.icedims = 0;
            save(fullfile(logdir, ['conv_spare_', name, '_', date, 'Time', time1, time2, '_', subject, '.mat']), 'matlabbatch');
            output = spm_jobman('run',matlabbatch);
        end
        end
    end
    for j=1:length(sessions)
        clear matlabbatch
        dicom_dir = fullfile(data_path, subject, 'func', sessions{j});
        files=spm_select('FPList', dicom_dir, '^i.*');
        matlabbatch{1}.spm.util.import.dicom.data = cellstr(files);     
        matlabbatch{1}.spm.util.import.dicom.root = 'flat';
        matlabbatch{1}.spm.util.import.dicom.outdir = cellstr(dicom_dir);
        matlabbatch{1}.spm.util.import.dicom.protfilter = '.*';
        matlabbatch{1}.spm.util.import.dicom.convopts.format = 'nii';
        matlabbatch{1}.spm.util.import.dicom.convopts.icedims = 0;
        runname = sessions{j};
        runname = runname(7:end);
        runname = runname(1:end-1);
        save(fullfile(logdir, ['conv_func_', date, 'Time', time1, time2, '_', subject, runname, '.mat']), 'matlabbatch');
        output = spm_jobman('run',matlabbatch);
    end 
end
    

