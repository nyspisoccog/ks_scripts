
clear all
subjects = {'7404', '7408', '7412', '7414', '7418', '7430', '7432',...
            '7436', '7443', '7453', '7458', '7474', '7477', '7478', '7480',...
            '7498', '7508', '7521', '7533', '7534', '7542', '7558', '7561',...
            '7562', '7575', '7580', '7607', '7613', '7619', '7623', '7638',...
            '7641', '7645', '7648', '7649', '7659', '7714', '7719', '7726'};

%subjects = {'7404', '7408', '7412'}
resroot = '/media/truecrypt1/SocCog/results/noMV_noval_1stvs2nd_wbp/lrn';

con_struct(1).con_dir = resroot;
con_struct(1).contrasts(1).reg_names = {...
    'LSRS*bf(1)';'LSRF*bf(1)';'LSIS*bf(1)';'LSIF*bf(1)';...
    'LYRS*bf(1)';'LYRF*bf(1)';'LYIS*bf(1)';'LYIF*bf(1)';...
    'LNRS*bf(1)';'LNRF*bf(1)';'LNIS*bf(1)';'LNIF*bf(1)';...
    };

con_struct(1).contrasts(1).col_names = {...
    'LSRS1'; 'LSRS2'; 'LSRS3'; 'LSRS4'; 'LSRF1'; 'LSRF2'; 'LSRF3'; 'LSRF4';...
    'LSIS1'; 'LSIS2'; 'LSIS3'; 'LSIS4'; 'LSIF1'; 'LSIF2'; 'LSIF3'; 'LSIF4';...
    'LYRS1'; 'LYRS2'; 'LYRS3'; 'LYRS4'; 'LYRF1'; 'LYRF2'; 'LYRF3'; 'LYRF4';...
    'LYIS1'; 'LYIS2'; 'LYIS3'; 'LYIS4'; 'LYIF1'; 'LYIF2'; 'LYIF3'; 'LYIF4';...
    'LNRS1'; 'LNRS2'; 'LNRS3'; 'LNRS4'; 'LNRF1'; 'LNRF2'; 'LNRF3'; 'LNRF4';...
    'LNIS1'; 'LNIS2'; 'LNIS3'; 'LNIS4'; 'LNIF1'; 'LNIF2'; 'LNIF3'; 'LNIF4'...
    };

con_struct(1).con_dir = 'con1';
con_struct(1).contrasts(1).reg_names = {'LSIS*bf(1)';'LSRS*bf(1)';'LYIS*bf(1)';...
    'LYRS*bf(1)'};
con_struct(1).contrasts(1).con_name = 'tnegative';
con_struct(2).con_dir = 'con3';
con_struct(2).contrasts(1).reg_names = {'LSIS*bf(1)';'LSRS*bf(1)';'LYIS*bf(1)';...
    'LYRS*bf(1)';'LSIF*bf(1)';'LSRF*bf(1)';'LYIF*bf(1)';'LYRF*bf(1)'};
con_struct(2).contrasts(1).con_name = 'negativet';

marsbar('on')

% Set up the SPM defaults
spm('defaults', 'fmri');


for i=1:length(con_struct)
    % Directory to store (and load) ROIs
    
    model_dir = fullfile(resroot, con_struct(i).con_dir);
    % Get SPM model
    model = mardo(fullfile(model_dir, 'SPM.mat'));
    
   
    
    
    % Get activation cluster
    for j = 1:length(con_struct(i).contrasts)
        clear clust_struct good_clust_struct
        con_name = con_struct(i).contrasts(j).con_name;
        t_con = get_contrast_by_name(model, con_name);
        if isempty(t_con)
            error(['Cannot find the contrast ' con_name ...
            ' in the design; has it been estimated?']);
        end

        % SPM2 stores contrasts as vols, SPM99 as filenames
        if isstruct(t_con.Vspm)
            t_con_fname = t_con.Vspm.fname;
        else
            t_con_fname = t_con.Vspm;
        end
        

        % SPM5 designs can have full paths in their Vspm.fnames
        t_pth = fileparts(t_con_fname);
        if isempty(t_pth)
            t_con_fname = fullfile(model_dir, t_con_fname);
        end
        if ~exist(t_con_fname)
            error(['Cannot find t image ' t_con_fname ...
        '; has it been estimated?']);
        end
        con_struct(i).contrasts(j).t_con_fname = t_con_fname;
        %make ROI out of cluster

        % Get t threshold of uncorrected p < 0.001
        p_thresh = 0.001;
        erdf = error_df(model);
        t_thresh = spm_invTcdf(1-p_thresh, erdf);

        % get all voxels from t image above threshold
        V = spm_vol(t_con_fname);
        img1 = spm_read_vols(V);
        tmp = find(img1(:) > t_thresh);
        img2 = img1(tmp);
        XYZ = mars_utils('e2xyz', tmp, V.dim(1:3));

        % make into clusters
        cluster_nos = spm_clusters(XYZ);

        clusters = unique(cluster_nos);
        for k = 1:length(clusters)
            clust_struct(k).cluster = XYZ(:, cluster_nos == clusters(k));
            clust_struct(k).clust_no = clusters(k);
        end
        
        %check that cluster size is greater than 8 voxels
        l = 1;
        for m = 1:length(clust_struct)
            [x, y] = size(clust_struct(m).cluster);
            if y >= 8
                good_clust_struct(l).cluster = clust_struct(m).cluster;
                good_clust_struct(l).clust_no = clust_struct(m).clust_no;
                l = l + 1;
            end
        end
        
        
        v = 'vox';
        sp = maroi('classdata', 'spacebase');
        sumfunc = 'mean';
        for k=1:length(good_clust_struct)
            o = maroi_pointlist(struct('XYZ', good_clust_struct(k).cluster, 'mat', sp.mat), v);
            lbl = ['clust' int2str(good_clust_struct(k).clust_no)];
            o = label(o, lbl);
            o = descrip(o, lbl);
            %save ROI
            fn = source(o);
            if isempty(fn) 
                fn = maroi('filename', mars_utils('str2fname', label(o)));
            end
            roi_fname = maroi('filename', fn);
            try
                varargout = {saveroi(o, roi_fname)};
            catch
                warning([lasterr ' Error saving ROI to file ' roi_fname])
            end
            good_clust_struct(k).object = o;
            good_clust_struct(k).fname = roi_fname;
        end
    con_struct(i).contrasts(j).clust_struct = good_clust_struct;
    for k = 1:length(subjects)
        con_struct(i).contrasts(j).subjects(k).name = subjects(k);
        SPM = load(fullfile(resroot, subjects{k}, 'SPM.mat'));
        for l = 1:length(con_struct(i).contrasts(j).reg_names)
            reg_name = con_struct(i).contrasts(j).reg_names{l};
            p = 0;
                for m = 1:length(SPM.SPM.xX.name)
                    name = SPM.SPM.xX.name(m);
                    test = strfind(name, reg_name);
                    if isempty(test{1}) ~= 1 
                        p = p + 1;
                        n = ceil(3-log10(m));
                        beta_name = char(['beta_' repmat('0',1,n) int2str(m) '.img']);
                        con_struct(i).contrasts(j).subjects(k).reg(l).beta_no(p) = m;
                        con_struct(i).contrasts(j).subjects(k).reg(l).beta_file(p) = {beta_name};
                        con_struct(i).contrasts(j).subjects(k).reg(l).reg_name(p) = {name};
                end
            end
        end
        reg = con_struct(i).contrasts(j).subjects(k).reg;
        for l = 1:length(reg)
            for m = 1:length(reg(l).beta_file);
                beta_fname = fullfile(resroot, subjects(k), reg(l).beta_file(m));
                con_struct(i).contrasts(j).subjects(k).reg(l).beta_fname(m) = beta_fname;
                beta_fname = beta_fname{:};
                clust = con_struct(i).contrasts(j).clust_struct;
                for n = 1:length(clust)
                    roi = clust(n).object;
                    con_struct(i).contrasts(j).subjects(k).reg(l).beta_val(m).cluster(n).number = clust(n).clust_no;
                    if n == 12 && k == 2  %no data for cluster 12, subject 7408
                        szof12 = size(clust(12).cluster);
                        lnof12 = szof12(2);
                        con_struct(i).contrasts(j).subjects(k).reg(l).beta_val(m).cluster(n).data = NaN(1, lnof12);
                        con_struct(i).contrasts(j).subjects(k).reg(l).beta_val(m).cluster(n).mean = NaN(1);
                        continue
                    end
                    marsY = get_marsy(roi, beta_fname, sumfunc, 'v');
                    rno = marsbar('get_region', region_name(marsY));
                    Y = region_data(marsY, rno);    
                    Y = Y{1};
                    con_struct(i).contrasts(j).subjects(k).reg(l).beta_val(m).cluster(n).data = Y;
                   con_struct(i).contrasts(j).subjects(k).reg(l).beta_val(m).cluster(n).mean = mean(Y); 
                end
            end
        end
        %need to take average of beta vals
        reg = con_struct(i).contrasts(j).subjects(k).reg;
        for l = 1:length(reg)
            for m = 1:length(clust)
                beta_avg(m).vals = zeros(length(reg(l).beta_file), 1);
                for n= 1:length(beta_avg(m).vals)
                    beta_avg(m).vals(n) = reg(l).beta_val(n).cluster(m).mean;
                end
                beta_avg(m).mean = mean(beta_avg(m).vals);
            con_struct(i).contrasts(j).subjects(k).reg(l).beta_avg = beta_avg;
            clear beta_avg
            end
        end
        
    end
    for a = 1:length(clust)
        reg_names = con_struct(i).contrasts(j).reg_names;
        colcount = length(con_struct(i).contrasts(j).col_names);
        data = cell(length(subjects), colcount + 1);
        %f_name = [con_struct(i).con_dir con_struct(i).contrasts(j).con_name ...
                %'clustno' int2str(a) '.csv'];
        f_name = [con_struct(i).contrasts(j).con_name ...
                'clustno' int2str(con_struct(i).contrasts(j).clust_struct(a).clust_no) '.csv'];   
        out_file = fullfile(con_struct(i).con_dir, f_name);
        varnames = cell(1, 1);
        varnames{1} = 'subject';
        contrast = con_struct(i).contrasts(j);
        varnames = vertcat(varnames, contrast.col_names);
        for b = 1:length(contrast.subjects)
            data(b,1) = subjects(b);
            for c = 1:length(contrast.subjects(b).reg)
                reg_name = contrast.subjects(b).reg(c).reg_name;
                for d = 1:length(reg_name)
                    col_num = 1 + (c-1)*4 + d;
                    data(b, col_num) = ... 
                         {contrast.subjects(b).reg(c).beta_val(d).cluster(a).mean};
                end
                if length(reg_name) < 4
                    for e = 3:-1:length(reg_name)
                        col_num = 2 + (c-1)*4 + e;
                        data(b, col_num) = {''};   
                    end
                end
            end
        end
        T = cell2table(data, 'RowNames', subjects, 'VariableNames', varnames);
        writetable(T, out_file);
        
    end
    
    end
end    




