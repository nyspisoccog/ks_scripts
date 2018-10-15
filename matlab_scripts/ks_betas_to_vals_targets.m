

function ks_betas_to_vals_targets()

dbstop if error

addpath(genpath('/Users/katherine/marsbar-0.44/'));
addpath('/Users/katherine/spm12');
   
marsbar('on')

subjects = {'7404', '7408', '7412', '7414', '7418', '7430', '7432',...
             '7436', '7443', '7453', '7458', '7474', '7477', '7478', '7480',...
             '7498', '7508', '7521', '7533', '7534', '7542', '7558', '7561',...
             '7562', '7575', '7580', '7607',  '7619', '7623', '7638',...
             '7645', '7648', '7649', '7659', '7714', '7719', '7726'};

onsdir = '/Volumes/LaCie/LaPrivate/soccog/onsets/fixmem-target/mem/';

for i = 1:length(subjects)
clear target_struct
clear targets
clear target_fID
subject = subjects{i}
rootdir = '/Volumes/LaCie/LaPrivate/soccog/results/feb2017memfirstlev/mem';
SPM = load(fullfile(rootdir, subject, 'SPM.mat'));
roi = load('/Volumes/LaCie/LaPrivate/soccog/results/feb2017memfirstlev/mem/robust0003/LBA47_roi.mat');
roi = maroi_pointlist(roi.roi, 'vox');



target_fname = fullfile(onsdir, subject, 'target_names.txt');
target_fID = fopen(target_fname,'r');
formatSpec = '%s';
targets = textscan(target_fID, formatSpec, 'Delimiter', '\n', 'ReturnOnError', false);
targets = targets{1};
fclose(target_fID);


target_names = {'Robin'; 'Sun'; 'Kelly'; 'Pat'; 'Tal'; 'Misha'; 'Sandy'; 'Chris'; 'Ronnie'; 'Terry'; 'Jan'; 'Sam'}
        
for j = 1:length(target_names)
    target_struct(j).name = target_names(j);
    target_struct(j).IT_array = {};
    target_struct(j).IU_array = {};
end
                
reg_names = SPM.SPM.xX.name;

for j = 1:numel(reg_names)
    reg_name = reg_names{j};
    open_paren = strfind(reg_name, '(') + 1;
    close_paren = strfind(reg_name, ')') - 1;
    sn_num = str2num(reg_name(open_paren:close_paren));
    curr_tar_name = targets{sn_num};
    
    for k = 1:length(target_names)
        if isempty(strfind(target_names{k},  curr_tar_name)) ~= 1
            curr_tar_ind = k;
        end
    end

    if isempty(strfind(reg_names{j}, 'MSIT*bf(1)')) ~= 1
       n = ceil(3-log10(j));
       beta_name = char(['beta_' repmat('0',1,n) int2str(j) '.nii']);
       target_struct(curr_tar_ind).IT_array = ...
        horzcat(target_struct(curr_tar_ind).IT_array, beta_name);
    elseif isempty(strfind(reg_names{j}, 'MSIU*bf(1)')) ~= 1
       n = ceil(3-log10(j));
       beta_name = char(['beta_' repmat('0',1,n) int2str(j) '.nii']);
       target_struct(curr_tar_ind).IU_array = ...
        horzcat(target_struct(curr_tar_ind).IU_array, beta_name);
    end

end

            
            
for j = 1:length(target_names)
    IT_array = target_struct(j).IT_array;
    IU_array = target_struct(j).IU_array;
    
    %what I need in this data structure is to find each of these betas
    %use MARSBAR to get their average for my ROI
    % and then write out a file
    % with subject, regressor, average
    % on each line
    
    %'7404' 'Sandy IT 'number'
    
    target_struct(j).IT_filenames = {};
    target_struct(j).IU_filenames = {};
    
    for k = 1:length(IT_array)
        fname = betaname_tofname(rootdir, subject, IT_array(k))
        target_struct(j).IT_filenames = ...
            horzcat(target_struct(j).IT_filenames, fname);
    end
    
    for k = 1:length(IU_array)
        fname = betaname_tofname(rootdir, subject, IU_array(k));
        target_struct(j).IU_filenames = ...
          horzcat(target_struct(j).IU_filenames, fname);
    end
    
    target_struct(j).IT_means = [];
    target_struct(j).IU_means = [];
    
    for k = 1:length(IT_array)
        Y = get_region_data(roi, target_struct(j).IT_filenames{k});
        target_struct(j).IT_means = horzcat(target_struct(j).IT_means, Y);
    end
    
     for k = 1:length(IU_array)
        Y = get_region_data(roi, target_struct(j).IU_filenames{k});
        target_struct(j).IU_means = horzcat(target_struct(j).IU_means, Y);
     end
    
    target_struct(j).IU_mean = mean(target_struct(j).IU_means);
    target_struct(j).IT_mean = mean(target_struct(j).IT_means);
   

end

sub_struct{i} = target_struct;

end

data = {};

for i = 1:length(subjects)
    subject = subjects{i};
    targets = sub_struct{i};
    for j = 1:length(targets)
        target = targets(j);
        if isempty(target.IT_means) ~= 1
        for k = 1:2
            if k == 1
                reg_type = 'MSIT';
                reg_mean = target.IT_mean;
            else
                reg_type = 'MSIU';
                reg_mean = target.IU_mean;
            end
            data = vertcat(data, {subject, target.name, reg_type, reg_mean}); 
        end
        end
    end
end

col_heads = {'subject', 'target', 'cond', 'activation_mean'};

T = cell2table(data, 'VariableNames', col_heads);
outfile = fullfile(rootdir, 'activation_means_by_target.csv');
writetable(T, outfile);


end

%cell 2 table.  want the first column to be subject.  want second column to
%be target name.  third column reg type. fourth column mean.




function [dir_list, label_list] = ks_betas_to_vals_corrected(ds, subjects, reg_names, root_dir, out_dir)

addpath('/Users/katherine/spm12');

%[subjects, reg_names, root_dir, out_dir, fname] = define_vals();

sz = size(ds);
len = sz(2);

dir_list = {};
label_list = {};
for i = 1:len
    mni_coords = num2str(get_mni_max(ds(i)));
    label = '';
    for j = 1:length(mni_coords);
        label = strcat(label, mni_coords(j));
    end
    new_out_dir = [out_dir '/' label];
    dir_list = [dir_list {new_out_dir}];
    label_list = [label_list {label}];
    if ~exist(out_dir, 'dir')
        mkdir(out_dir);
    end
    roi = make_roi(ds(i).XYZ, label, out_dir);
    fname = [label '.csv'];
    subjects_cell = {};
    for j = 1:length(subjects)
        subjects_cell{j} = subjects(j).ID;
    end
    write_table(subjects_cell, reg_names, root_dir, out_dir, fname, roi)
end

end



function [mni_max] = get_mni_max(row)
    for i = 1:length(row.XYZmm)
        if isequal(row.XYZmm(:, i), transpose(row.mm_center))
            mni_max = transpose(row.XYZ(:, i));
        end
    end   
end


function [subjects, reg_names, root_dir, out_dir, fname] = define_vals()

subjects = {'7404', '7408', '7412', '7414', '7418', '7430', '7432',...
             '7436', '7443', '7453', '7458', '7474', '7477', '7478', '7480',...
             '7498', '7508', '7521', '7533', '7534', '7542', '7558', '7561',...
             '7562', '7575', '7580', '7607',  '7619', '7623', '7638',...
             '7645', '7648', '7649', '7659', '7714', '7719', '7726'};
         
reg_names = {'MSRT*bf(1)', 'MSRU*bf(1)', 'MSIT*bf(1)', 'MSIU*bf(1)', ...
             'MYRT*bf(1)', 'MYRU*bf(1)', 'MYIT*bf(1)', 'MYIU*bf(1)', ...
             'MNRT*bf(1)', 'MNRU*bf(1)', 'MNIT*bf(1)', 'MNIU*bf(1)' };
         
         
reg_names = {'Robin_IT', 'Robin_IU', 'Sun', 'Kelly', 'Pat', 'Tal', 'Misha', 'Sandy', 'Chris', 'Ronnie', 'Terry', 'Jan', 'Sam'}

root_dir = '/Volumes/LaCie/LaPrivate/soccog/results/feb2017memfirstlev/mem';
out_dir = '/Volumes/LaCie/LaPrivate/soccog/results/feb2017memfirstlev/mem/robust0003';
fname = 'betadata_con3_corrected.csv';

end

function roi = make_roi(pointlist, label, con_dir)
    cd(con_dir)
    addpath('/Users/katherine/marsbar-0.44/');
    marsbar('on')
    spm('defaults', 'fmri');
    v = 'vox';
    sp = maroi('classdata', 'spacebase');
    o = maroi_pointlist(struct('XYZ', pointlist, 'mat', sp.mat), v);
    o = descrip(o, label);     
    fn = source(o);
    if isempty(fn) 
        fn = maroi('filename', mars_utils('str2fname', [label]));
    end
    roi_fname = maroi('filename', fn);
    try
        varargout = {saveroi(o, roi_fname)};
        mars_rois2img(roi_fname, [label '.nii'], [], 'i')
    catch
        warning([lasterr ' Error saving ROI to file ' roi_fname])
    end
    roi = o;
end

function beta_names = regname_tobetanames(reg_name, SPM)
    beta_names = {};
    j = 0;
    for i = 1:length(SPM.SPM.xX.name)
        name = SPM.SPM.xX.name(i);
        test = strfind(name, reg_name);
        if isempty(test{1}) ~= 1
            j = j + 1;
            n = ceil(3-log10(i));
            beta_name = char(['beta_' repmat('0',1,n) int2str(i) '.nii']);
            beta_names{j} = beta_name;
        end
    end
end

function fname = betaname_tofname(root_dir, subject, beta_name)
    fname = fullfile(root_dir, subject, beta_name);
end

function fnames = betanames_tofnames(root_dir, subject, beta_names)
    fnames = {};
    for i = 1:length(beta_names)
        fnames{i} = betaname_tofname(root_dir, subject, beta_names{i});
    end
    
end
  
function Y = get_region_data(roi, beta_fname)
    marsY = get_marsy(roi, beta_fname, 'mean', 'v');
    rno = marsbar('get_region', region_name(marsY));
    Y = region_data(marsY, rno);    
    Y = Y{1};
end    

function clusters_mean=get_clusters_mean(subject, roi, beta_files)
    cluster_vals = [];
    for i = 1:length(beta_files)
        cluster_vals(i) = mean(get_region_data(roi, beta_files{i}));
    end
    clusters_mean = mean(cluster_vals);
end

function avg_clust_val= get_data(subject, reg_name, root_dir, roi)
    SPM = load(fullfile(root_dir, subject, 'SPM.mat'));
    beta_names = regname_tobetanames(reg_name, SPM);
    beta_files = betanames_tofnames(root_dir, subject, beta_names);
    avg_clust_val = get_clusters_mean(subject, roi, beta_files);
end

function [data, col_heads] = populate_data_structure(subjects, reg_names, root_dir, roi)
    slen = length(subjects);
    rlen = length(reg_names);
    data = cell(slen, rlen);
    col_heads = cell(rlen+1, 1);
    col_heads{1} = 'subject';
    for i = 1:rlen
        col_heads{i+1} = reg_names{i}(1:4);
    end
    for i = 1:slen
        subject = subjects{i};
        data(i,1) = subjects(i);
        for j = 1:rlen
            reg_name = reg_names{j};
            data{i, j+1} = get_data(subject, reg_name, root_dir, roi);
        end
    end
end

function write_table(subjects, reg_names, root_dir, out_dir, fname, roi)
    [data, col_heads] = populate_data_structure(subjects, reg_names, root_dir, roi);
    T = cell2table(data, 'RowNames', subjects, 'VariableNames', col_heads);
    out_file = fullfile(out_dir, fname);
    writetable(T, out_file);
end


    
