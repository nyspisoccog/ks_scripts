
clear all
subjects = {'7404', '7408', '7412', '7414', '7418', '7430', '7432',...
            '7436', '7443', '7453', '7458', '7474', '7477', '7478', '7480',...
            '7498', '7508', '7521', '7533', '7534', '7542', '7558', '7561',...
            '7562', '7575', '7580', '7607', '7613', '7619', '7623', '7638',...
            '7641', '7645', '7648', '7649', '7659', '7714', '7719', '7726'};

%subjects = {'7404', '7408', '7412'}
resroot = '/media/truecrypt1/SocCog/results/noMV_noval_1stvs2nd_wbp/lrn';

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

resroot = '/media/truecrypt1/SocCog/results/noMV_noval_1stvs2nd_wbp/lrn';

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

        % Get t threshold of uncorrected p < 0.0001
        p_thresh = 0.0001;
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
            f_name = fullfile(resroot, con_struct(i).con_dir,mars_utils('str2fname', label(o)));
            roi_fname = maroi('filename', f_name);
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
        SPM_dir = fullfile(resroot, subjects{k});
        SPM_path = fullfile(SPM_dir, 'SPM.mat');
        SPM = load(SPM_path);
        VY = SPM.SPM.xY.VY;
        root = '/media/truecrypt1/SocCog/preproc_data';
        for f = 1:length(VY)
            oldname = VY(f).fname;
            C = strsplit(oldname, '/');
            newname = fullfile(root, C{8}, C{9}, C{10}, C{11});
            SPM.SPM.xY.VY(f).fname = newname;
        end
        D = mardo(SPM);
        D = autocorr(D, 'fmristat', 2);
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
        xCon = get_contrasts(D);
        clust = con_struct(i).contrasts(j).clust_struct;
        for clst = 1:length(clust)
            R = maroi(clust(clst).fname);
            Y = get_marsy(R, D, 'mean');
            E = estimate(D, Y);
            E = set_contrasts(E, xCon);
            %b = betas(E);
            marsS = compute_contrasts(E, 1:length(xCon));
            [e_specs, e_names] = event_specs(E);
            n_events = size(e_specs, 2);
            dur = 4;
            for e_s = 1:n_events
                if strcmp(e_names(e_s), 'button_press')
                     clust(clst).pct_ev(e_s) = event_signal(E, e_specs(:,e_s), 0); 
                else
                     clust(clst).pct_ev(e_s) = event_signal(E, e_specs(:,e_s), dur);
               end
            end
        end
        reg = con_struct(i).contrasts(j).subjects(k).reg;
        for l = 1:length(reg)
            for m = 1:length(reg(l).beta_file);
                beta_fname = fullfile(resroot, subjects(k), reg(l).beta_file(m));
                con_struct(i).contrasts(j).subjects(k).reg(l).beta_fname(m) = beta_fname;
                beta_fname = beta_fname{:};
         
              
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
            for p = 1:length(clust)
                 vals = [];
                    for nm = 1:length(e_names)
                        name = reg(l).reg_name{1};
                        name = name{1};
                        name = name(7:10);
                        if strcmp(e_names(nm), name)
                            vals = horzcat(vals, clust(p).pct_ev(nm));                      
                        end
                    end
                con_struct(i).contrasts(j).subjects(k).reg(l).pctcluster(p).pct_vals = vals;
                con_struct(i).contrasts(j).subjects(k).reg(l).pctcluster(p).pct_mean = mean(vals); 
            end
        end
        %need to take average of beta vals
        reg = con_struct(i).contrasts(j).subjects(k).reg;
        for l = 1:length(reg)
            clear beta_avg  %%very important!
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
        pct_f_name = [con_struct(i).con_dir con_struct(i).contrasts(j).con_name ...
                'pctclustno' int2str(con_struct(i).contrasts(j).clust_struct(a).clust_no) '.csv']; 
        pct_out = fullfile(resroot, con_struct(i).con_dir, pct_f_name);
        regnames = cell(rlen+1, 1);
        regnames{1} = 'subject';
        for d = 1:rlen
             regnames{d+1} = reg_names{d}(1:4);
        end
        for b = 1:rlen
            for c = 1:length(subjects)
                data(c,1) = subjects(c);
                pct_data(c, 1) = subjects(c);
                data(c, b+1) = {con_struct(i).contrasts(j).subjects(c).reg(b).beta_avg(a).mean};
                pct_data(c, b+1) = {con_struct(i).contrasts(j).subjects(c).reg(b).pctcluster(a).pct_mean};
            end
         end
        T = cell2table(data, 'RowNames', subjects, 'VariableNames', regnames);
        pct_T = cell2table(pct_data, 'RowNames', subjects, 'VariableNames', regnames);
        writetable(T, out_file);
        writetable(pct_T, pct_out); 
        
        
        
    end
    
    end
end    




