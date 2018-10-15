function ks_betas_to_vals_corrected(ds, subjects, reg_names, root_dir, out_dir)

addpath('/Users/katherine/spm12');

%[subjects, reg_names, root_dir, out_dir, fname] = define_vals();

sz = size(ds);
len = sz(2);

for i = 1:len
    mni_coords = get_mni_max(ds(i));
    label = get_label(mni_coords);
    roi = make_roi(ds(i).XYZ, label, out_dir);
    fname = [label '.csv'];
    subjects_cell = {}
    for j = 1:length(subjects)
        subjects_cell{j} = subjects(j).ID
    end
    write_table(subjects_cell, reg_names, root_dir, out_dir, fname, roi)
end

end

function [label] = get_label(mni_coords)
    addpath('/Users/katherine/xjview96/xjview');
    DB = load('TDdatabase');
    DB = DB.DB;
    [onelinestructure, cellarraystructure] = cuixuFindStructure(mni_coords, DB);
    label = onelinestructure{1};
    bad_chars = ['/', '(', ')'];
    for j = 1:length(bad_chars)
        label = strrep(label, bad_chars(j), '');
    end
    label = strtrim(label);
end

function [mni_max] = get_mni_max(row)
    for i = 1:length(row.XYZmm)
        if isequal(row.XYZmm(:, i), transpose(row.mm_center))
            mni_max = transpose(row.XYZ(:, i));
        end
    end   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% cuixuFindStructure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [onelinestructure, cellarraystructure] = cuixuFindStructure(mni, DB)

N = size(mni, 1);

% round the coordinates
mni = round(mni/2) * 2;

T = [...
     2     0     0   -92
     0     2     0  -128
     0     0     2   -74
     0     0     0     1];

index = mni2cor(mni, T);

cellarraystructure = cell(N, length(DB));
onelinestructure = cell(N, 1);

for ii=1:N
    for jj=1:length(DB)
        graylevel = DB{jj}.mnilist(index(ii, 1), index(ii, 2),index(ii, 3));
        if graylevel == 0
            thelabel = 'undefined';
        else
            if jj==length(DB); tmp = ' (aal)'; else tmp = ''; end
            thelabel = [DB{jj}.anatomy{graylevel} tmp];
        end
        cellarraystructure{ii, jj} = thelabel;
        onelinestructure{ii} = [ onelinestructure{ii} ' // ' thelabel ];
    end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% mni2cor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function coordinate = mni2cor(mni, T)
% function coordinate = mni2cor(mni, T)
% convert mni coordinate to matrix coordinate
%
% mni: a Nx3 matrix of mni coordinate
% T: (optional) transform matrix
% coordinate is the returned coordinate in matrix
%
% caution: if T is not specified, we use:
% T = ...
%     [-4     0     0    84;...
%      0     4     0  -116;...
%      0     0     4   -56;...
%      0     0     0     1];
%
% xu cui
% 2004-8-18
%

if isempty(mni)
    coordinate = [];
    return;
end

if nargin == 1
	T = ...
        [-4     0     0    84;...
         0     4     0  -116;...
         0     0     4   -56;...
         0     0     0     1];
end

coordinate = [mni(:,1) mni(:,2) mni(:,3) ones(size(mni,1),1)]*(inv(T))';
coordinate(:,4) = [];
coordinate = round(coordinate);
return;
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


    
