function ks_reorient(Data, Time)

%% Subjects folders
data_path = Data.data_path;
subjects = Data.Subjects;
logdir = Data.logdir; 
table_path = '/Volumes/LaCie/reorientdata.csv';
reo_tab = readtable(table_path);
subj_dir_path = '/Volumes/LaCie/subj-exam-dir-matching.csv';
subj_dir_tab = readtable(subj_dir_path)



%% Time Info

date = Time.date;
time1 = Time.time1;
time2 = Time.time2;

spm('Defaults','fMRI');

spm_jobman('initcfg');

for i = 1:length(subjects)
    subject = subjects(i).ID;
    clear rot1 rot2 reomat1 reomat2 halves best_anat best_anat_half
    halves = [0 0];
    for row=1:height(reo_tab)
        anat_file = reo_tab(row, 2);
        anat_file = anat_file{1, 1};
        anat_file = anat_file{1, 1};
        ind = strfind(anat_file, 'anat');
        if strcmp(anat_file(ind + 5), '1')
            rot1 = table2array([reo_tab(row, 3), reo_tab(row, 4), reo_tab(row, 5), ...
                reo_tab(row, 6), reo_tab(row, 7), reo_tab(row, 8)]);
            reomat1 = spm_matrix(rot1);
            halves(1) = 1;
        else
            rot2 = table2array([reo_tab(row, 3), reo_tab(row, 4), reo_tab(row, 5), ...
                reo_tab(row, 6), reo_tab(row, 7), reo_tab(row, 8)]);
            reomat2 = spm_matrix(rot2);
            halves(2) = 1;
        end
    end
    for row = 1:height(subj_dir_tab)
        b = table2array(subj_dir_tab(row, 6));
        b = b{1, 1};
        s = table2array(subj_dir_tab(row, 1));
        s = mat2str(s);
        if strcmp(s, subject)
            if strcmp(b, 'best')
                disp('true')
                best_anat = table2array(subj_dir_tab(row, 4));
                best_anat = best_anat{1, 1};
                ind = strfind(best_anat, 'anat');
                ind = ind + 5;
                best_anat_half = best_anat(ind);
            end
        end
    end
    anat_file = spm_select('FPList', fullfile(data_path, subject, 'anat'), '.*.nii');
    if best_anat_half == '1'
        anat_rotmat = reomat1;
    else
        anat_rotmat = reomat2;
    end
    sessions = subjects(i).Runs;
    first_funcs = {};
    sec_funcs = {};
    for j = 1:length(sessions)
        func_run = spm_select('FPList', fullfile(data_path, subject, 'func', ...
            sessions{j}), ['^' subject '.*.nii']);
        if sessions{j}(4) == '1'
            first_funcs = vertcat(first_funcs, cellstr(func_run));
        else
            sec_funcs = vertcat(sec_funcs, cellstr(func_run));
        end
    end   
    matlabbatch{1}.spm.util.reorient.srcfiles = cellstr(anat_file);
    matlabbatch{1}.spm.util.reorient.transform.transM = anat_rotmat;
    matlabbatch{1}.spm.util.reorient.prefix = 'r';
    matlabbatch{2}.spm.util.reorient.srcfiles = first_funcs;
    if halves(1) == 1
        matlabbatch{2}.spm.util.reorient.transform.transM = reomat1;
    else
        matlabbatch{2}.spm.util.reorient.transform.transM = reomat2;
    end
    matlabbatch{2}.spm.util.reorient.prefix = 'r';
    if halves(2) == 1
        matlabbatch{3}.spm.util.reorient.transform.transM = reomat2;
    else
        matlabbatch{3}.spm.util.reorient.transform.transM = reomat1;
    end
    matlabbatch{3}.spm.util.reorient.prefix = 'r';
    matlabbatch{3}.spm.util.reorient.srcfiles = sec_funcs;
    save(fullfile(logdir, ['reor_', date, 'Time', time1, time2, '_', subject, '.mat']), 'matlabbatch');
    output = spm_jobman('run',matlabbatch);    
        
    end
end

