function ks_reorient2(Data, Time)

%% Subjects folders
data_path = Data.data_path;
subjects = Data.Subjects;
logdir = Data.logdir; 
reo_path = '/Volumes/LaCie/LaPrivate/soccog/August2014snapshot/reoriented_data';
subj_dir_path = '/Users/katherine/ks_scripts/PreProSortingScripts2016/subj-exam-dir-matching.csv';
subj_dir_tab = readtable(subj_dir_path);



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
    for row = 1:height(subj_dir_tab)
        b = table2array(subj_dir_tab(row, 6));
        b = b{1, 1};
        s = table2array(subj_dir_tab(row, 1));
        s = mat2str(s);
        sername = table2array(subj_dir_tab(row, 4));
        sername = sername{1, 1};
        if strcmp(s, subject)
            sparecount1 = 1;
            sparecount2 = 1;
            if strcmp(sername(1:4), 'anat')
                if strcmp(b, 'best')
                    anat.best.orig.dir = fullfile(data_path, subject, 'anat');
                    anat.best.reo.dir = fullfile(reo_path, subject, 'anat');
                    anat.best.half = sername(6);
                elseif strcmp(sername(6), '1')
                    anat.spare.first(sparecount1).orig.dir = ...
                        fullfile(data_path, subject, 'spare_anat', sername);
                    if isdir(fullfile(reo_path, subject, 'spare_anat', sername))
                        anat.spare.first(sparecount1).reo.dir = ...
                            fullfile(reo_path, subject, 'spare_anat', sername);
                    else 
                        anat.spare.second(sparecount2).reo.dir = '';
                    end
                    sparecount1 = sparecount1  + 1;
                elseif strcmp(sername(6), '2')  
                    anat.spare.second(sparecount2).orig.dir = ...
                        fullfile(data_path, subject, 'spare_anat', sername);
                    if isdir(fullfile(reo_path, subject, 'spare_anat', sername))
                        anat.spare.second(sparecount2).reo.dir = ...
                            fullfile(reo_path, subject, 'spare_anat', sername);
                    else 
                        anat.spare.second(sparecount2).reo.dir = '';
                    end
                    sparecount2 = sparecount2  + 1;
                end
                    
            end
        end
    end
    
    
    
   anat.best.orig.fname = ...
       spm_select('FPList', anat.best.orig.dir, '.*.nii');
   anat.best.orig.vol = spm_vol(anat.best.orig.fname);
   anat.best.orig.mat = anat.best.orig.vol.mat;
   anat.best.reo.fname = spm_select('FPlist', anat.best.reo.dir, '.*.img');
   anat.best.reo.vol = spm_vol(anat.best.reo.fname);
   anat.best.reo.mat = anat.best.reo.vol.mat;
   anat.best.trans.mat = anat.best.reo.mat*inv(anat.best.orig.mat);
   
   if strcmp(anat.best.half, '1')
       func(1) = anat.best;
       if exist('anat.spare.second(1).orig.dir') && ...
           length(anat.spare.second(1).orig.dir) > 1
           func(2).orig = anat.spare.second(1).orig;
           func(2).orig.fname = spm_select('FPlist', func(2).orig.dir, '.*.nii');
           func(2).orig.vol = spm_vol(func(2).orig.fname);
           func(2).orig.mat = func(2).orig.vol.mat;
           func(2).reo = anat.spare.second(1).reo;
           func(2).reo.fname = spm_select('FPlist', func(2).reo.dir, '.*.img');
           func(2).reo.vol = spm_vol(func(2).reo.fname);
           func(2).reo.mat = func(2).reo.vol.mat;
           func(2).trans.mat = func(2).reo.mat*inv(func(2).orig.mat);
       else
           func(2).trans.mat = func(1).trans.mat;
       end
   elseif strcmp(anat.best.half, '2') 
       func(2) = anat.best;
       if exist('anat.spare.first(1).orig.dir') && ...
           length(anat.spare.first(1).orig.dir) > 1
           func(1).orig = anat.spare.first(1).orig;
           func(1).orig.fname = spm_select('FPlist', func(1).orig.dir, '.*.nii');
           func(1).orig.vol = spm_vol(func(1).orig.fname);
           func(1).orig.mat = func(1).orig.vol.mat;
           func(1).reo = anat.spare.first(1).reo;
           func(1).reo.fname = spm_select('FPlist', func(1).reo.dir, '.*.img');
           func(1).reo.vol = spm_vol(func(1).reo.fname);
           func(1).reo.mat = func(1).reo.vol.mat;
           func(1).trans.mat = func(1).reo.mat*inv(func(2).orig.mat);
       else
           func(1).trans.mat = func(2).trans.mat;
       end
   end
  
   matlabbatch{1}.spm.util.reorient.srcfiles = cellstr(anat.best.orig.fname);
   matlabbatch{1}.spm.util.reorient.transform.transM = anat.best.trans.mat;
   matlabbatch{1}.spm.util.reorient.prefix = 'r';
   save(fullfile(logdir, ['reoranat_', subject, '_', date, 'Time', time1, time2, '.mat']), 'matlabbatch');
   output = spm_jobman('run',matlabbatch);
   subs = vertcat(subs, subject); ser_names = vertcat(ser_names, 'anat');
   msgs = vertcat(msgs, ['reoriented best anat file']);
   clear matlabbatch
    
   sessions = subjects(i).Runs;
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
            matlabbatch{2}.spm.util.reorient.transform.transM = func(1).trans.mat;
        else 
            matlabbatch{2}.spm.util.reorient.transform.transM = func(2).trans.mat;
        end
        matlabbatch{2}.spm.util.reorient.prefix = 'r';
        save(fullfile(logdir, ['reor_', 'subject', sessions{j}  date, 'Time', time1, time2, '.mat']), 'matlabbatch');
        output = spm_jobman('run',matlabbatch); 
        subs = vertcat(subs, subject); ser_names = vertcat(ser_names, sessions{j});
        msgs = vertcat(msgs, ['reoriented func ' sessions{j}]);
        clear matlabbatch
          
    end    
        
end

reorient = table(subs, ser_names, msgs);
writetable(reorient, [data_path 'reorient.csv']);
end


