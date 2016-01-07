function ks_reorient2(Data, Time)

%% Subjects folders
data_path = Data.data_path;
subjects = Data.Subjects;
logdir = Data.logdir; 
reo_path = '/Volumes/LaCie/LaPrivate/soccog/August2014snapshot/reoriented_data';
table_path = '/Volumes/LaCie/reorientdata.csv';
reo_tab = readtable(table_path);
subj_dir_path = '/Volumes/LaCie/ks_scripts/PreProSortingScripts2016/subj-exam-dir-matching.csv';
subj_dir_tab = readtable(subj_dir_path)



%% Time Inf

date = Time.date;
time1 = Time.time1;
time2 = Time.time2;

subs = {};
ser_names = {};
msgs = {};

spm('Defaults','fMRI');

spm_jobman('initcfg');

for i = 1:length(subjects)
    subject = subjects(i).ID;
    disp(subject)
    clear reomat1 reomat2 best_anat best_anat_half
    halves = [0 0];
    for row = 1:height(subj_dir_tab)
        b = table2array(subj_dir_tab(row, 6));
        b = b{1, 1};
        s = table2array(subj_dir_tab(row, 1));
        s = mat2str(s);
        sername = table2array(subj_dir_tab(row, 4));
        sername = sername{1, 1};
        if strcmp(s, subject)
            if strcmp(sername(1:4), 'anat')
                if strcmp(b, 'best')
                    orig_anat_dir = fullfile(data_path, subject, 'anat');
                    reo_anat_dir = fullfile(reo_path, subject, 'anat');
                    best_anat_half = sername(6);
                elseif isdir(fullfile(reo_path, subject, 'spare_anat', sername))
                    orig_anat_dir = fullfile(data_path, subject, 'spare_anat', sername)
                    reo_anat_dir = fullfile(reo_path, subject, 'spare_anat', sername)
                else
                    continue
                end
                orig_file = spm_select('FPList', orig_anat_dir, '.*.nii');
                orig_anat = spm_vol(orig_file)
                orig_mat = orig_anat.mat
                reo_file = spm_select('FPlist', reo_anat_dir, '.*.img');
                reo_anat = spm_vol(reo_file);
                new_mat = reo_anat.mat;
                reo_mat = new_mat*inv(orig_mat);
                half = sername(6);
                if strcmp(half, '1')
                    halves(1) = 1;
                    reomat1 = reo_mat;
                else strcmp(half, '2')
                    halves(2) = 1;
                    reomat2 = reo_mat;
                end
            end
        end
    end
    if best_anat_half == '1'
        anat_rotmat = reomat1;
    else
        anat_rotmat = reomat2;
    end
    orig_anat_dir = fullfile(data_path, subject, 'anat');
    orig_file = spm_select('FPList', orig_anat_dir, '.*.nii');
    matlabbatch{1}.spm.util.reorient.srcfiles = cellstr(orig_file);
    matlabbatch{1}.spm.util.reorient.transform.transM = anat_rotmat;
    matlabbatch{1}.spm.util.reorient.prefix = 'r';
    save(fullfile(logdir, ['reoranat_', date, 'Time', time1, time2, '_', subject, '.mat']), 'matlabbatch');
    output = spm_jobman('run',matlabbatch);
    subs = vertcat(subs, subject); ser_names = vertcat(ser_names, 'anat');
    msgs = vertcat(msgs, ['reoriented best anat file']);
    clear matlabbatch
    
    sessions = subjects(i).Runs;
    first_funcs = {};
    sec_funcs = {};
    for j = 1:length(sessions)
        func_run = spm_select('FPList', fullfile(data_path, subject, 'func', ...
            sessions{j}), ['^' subject '.*.nii']);
        matlabbatch{1}.spm.util.exp_frames.files = {[func_run ',1']};
        matlabbatch{1}.spm.util.exp_frames.frames = Inf;
        matlabbatch{2}.spm.util.reorient.srcfiles(1) = ... 
            cfg_dep('Expand image frames: Expanded filename list.',...
            substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}),...
            substruct('.','files'));
        if strcmp(sessions{j}(4), '1') 
            if halves(1) == 1
                matlabbatch{2}.spm.util.reorient.transform.transM = reomat1;
            else
                matlabbatch{2}.spm.util.reorient.transform.transM = reomat2;
            end
        else 
            if halves(2) == 1
                matlabbatch{2}.spm.util.reorient.transform.transM = reomat2;
            else
                matlabbatch{2}.spm.util.reorient.transform.transM = reomat1;
            end
        end
        matlabbatch{2}.spm.util.reorient.prefix = 'r';
        save(fullfile(logdir, ['reor_', sessions{j}  date, 'Time', time1, time2, '_', subject, '.mat']), 'matlabbatch');
        output = spm_jobman('run',matlabbatch); 
        subs = vertcat(subs, subject); ser_names = vertcat(ser_names, sessions{j});
        msgs = vertcat(msgs, ['reoriented func ' sessions{j}]);
        clear matlabbatch
          
    end    
        
end

reorient = table(subs, ser_names, msgs);
writetable(reorient, [data_path 'reorient.csv']);
end


