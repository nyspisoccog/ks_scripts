function ks_betas_to_vals()

addpath('/Users/katherine/spm12');

[subjects, reg_names, root_dir, out_dir, fname] = define_vals();

ws = load('/Volumes/LaCie/LaPrivate/soccog/results/feb2017memfirstlev/mem/robust0003/workspacewithsigclusters.mat');

roi = make_roi(ws.clpos(4).XYZ, 'LBA47', out_dir);

write_table(subjects, reg_names, root_dir, out_dir, fname, roi)

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
fname = 'betadata_con3.csv';

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

function beta_name = regname_tobetafile(reg_name, SPM)
    for i = 1:length(SPM.SPM.xX.name)
        name = SPM.SPM.xX.name(i);
        test = strfind(name, reg_name);
        if isempty(test{1}) ~= 1 
            n = ceil(3-log10(i));
            beta_name = char(['beta_' repmat('0',1,n) int2str(i) '.nii']);
        end
    end
end

function fname = betaname_tofname(root_dir, subject, beta_name)
    fname = fullfile(root_dir, subject, beta_name);
end
  
function Y = get_region_data(roi, beta_fname)
    marsY = get_marsy(roi, beta_fname, 'mean', 'v');
    rno = marsbar('get_region', region_name(marsY));
    Y = region_data(marsY, rno);    
    Y = Y{1};
end    

function avg_clust_val= get_data(subject, reg_name, root_dir, roi)
    SPM = load(fullfile(root_dir, subject, 'SPM.mat'));
    beta_name = regname_tobetafile(reg_name, SPM);
    beta_file = betaname_tofname(root_dir, subject, beta_name);
    avg_clust_val = mean(get_region_data(roi, beta_file));
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


    
