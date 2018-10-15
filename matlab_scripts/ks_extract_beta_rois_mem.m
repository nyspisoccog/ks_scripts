
clear all
subjects = {'7404', '7408', '7412', '7414', '7418', '7430', '7432',...
            '7436', '7443', '7453', '7458', '7474', '7477', '7478', '7480',...
            '7498', '7508', '7521', '7533', '7534', '7542', '7558', '7561',...
            '7562', '7575', '7580', '7607', '7613', '7619', '7623', '7638',...
            '7641', '7645', '7648', '7649', '7659', '7714', '7719', '7726'};

%subjects = {'7404', '7408', '7412'}
resroot = '/Volumes/LaCie/LaPrivate/soccog/results/feb2017memfirstlev/mem';

con_dir = 'con3';
reg_names = {'MSRT*bf(1)';'MSRU*bf(1)';'MSIT*bf(1)';...
    'MSIU*bf(1)'; 'MYRT*bf(1)';'MYRU*bf(1)';'MYIT*bf(1)'; 'MYIU*bf(1)';...
    'MNRT*bf(1)';'MNRU*bf(1)';'MNIT*bf(1)'; 'MNIU*bf(1)'};
con_name = 'tpositive';


marsbar('on')
spm('defaults', 'fmri');

% Directory to store (and load) ROIs
model_dir = fullfile(resroot, con_dir);

% Get SPM model
model = mardo(fullfile(model_dir, 'SPM.mat'));

% Get activation cluster
clear clust_struct good_clust_struct
     
t_con = get_contrast_by_name(model, con_name);
if isempty(t_con)
    error(['Cannot find the contrast ' con_name ...
           ' in the design; has it been estimated?']);
end


t_con_fname = t_con.Vspm.fname;

        
% SPM5 designs can have full paths in their Vspm.fnames
t_pth = fileparts(t_con_fname);
if isempty(t_pth)
    t_con_fname = fullfile(model_dir, t_con_fname);
end
if ~exist(t_con_fname)
     error(['Cannot find t image ' t_con_fname '; has it been estimated?']);
end

 
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
            end
        end
        
    end
    for a = 1:length(clust)
        reg_names = con_struct(i).contrasts(j).reg_names;
        rlen = length(reg_names);
        data = cell(length(subjects), rlen);
        %f_name = [con_struct(i).con_dir con_struct(i).contrasts(j).con_name ...
                %'clustno' int2str(a) '.csv'];
        f_name = [con_struct(i).con_dir con_struct(i).contrasts(j).con_name ...
                'clustno' int2str(con_struct(i).contrasts(j).clust_struct(a).clust_no) '.csv'];   
        out_file = fullfile(resroot, con_struct(i).con_dir, f_name);
        regnames = cell(rlen+1, 1);
        regnames{1} = 'subject';
        for d = 1:rlen
             regnames{d+1} = reg_names{d}(1:4);
        end
        for b = 1:rlen
            for c = 1:length(subjects)
                data(c,1) = subjects(c);
                data(c, b+1) = {con_struct(i).contrasts(j).subjects(c).reg(b).beta_avg(a).mean};
            end
         end
        T = cell2table(data, 'RowNames', subjects, 'VariableNames', regnames);
        writetable(T, out_file);
        
        
        
        
    end
    
    end
end    




