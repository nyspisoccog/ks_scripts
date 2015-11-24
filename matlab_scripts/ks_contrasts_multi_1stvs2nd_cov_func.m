function ks_contrasts_multi_1stvs2nd_cov_func(Data, Time)

spm('Defaults','fMRI');

spm_jobman('initcfg');

clear matlabbatch;

lrn_res_dir = Data.lrn_res_dir;
mem_res_dir = Data.mem_res_dir;
lrn_log_dir = Data.lrn_log_dir; 
mem_log_dir = Data.mem_log_dir;
sess_type = {'lrn', 'mem'};
subjects = Data.Subjects;

lrnlogname = fullfile(lrn_log_dir, 'contrasts.csv');
lrnloghand = fopen(lrnlogname,'wt');

sess_tab = cell(length(subjects), 4);

for i=1:numel(subjects)
    clear con_struct
    subject = subjects(i).ID;
    disp(subject)
    for lm = 1:numel(sess_type)
        if strcmp(sess_type{lm}, 'lrn')
            loghand = lrnloghand;
            fprintf(loghand, [subject, '\n']);
            Ncount = 0; Ycount = 0; Scount = 0; 
            resdir = lrn_res_dir;
            logdir = lrn_log_dir;
            sessions = subjects(i).lrn_runs;
            load(fullfile(resdir, subject, 'SPM.mat'));
            disp(fullfile(resdir, subject, 'SPM.mat'))
            names = SPM.xX.name;
            Ynames = {}; Snames = {}; Nnames = {};
            for j = 1:numel(names)
                if isempty(strfind(names{j}, 'LNIF*bf(1)')) ~= 1
                   Ncount = Ncount + 1;
                   Nnames = horzcat(Nnames, names{j});
                elseif isempty(strfind(names{j}, 'LSIF*bf(1)')) ~= 1 
                   Scount = Scount + 1;
                   Snames = horzcat(Snames, names{j});
                elseif isempty(strfind(names{j}, 'LYIF*bf(1)')) ~= 1
                   Ycount = Ycount + 1;
                   Ynames = horzcat(Ynames, names{j});
                end
            end
            sess_tab(i, 1) = {subjects(i).ID};
            sess_tab(i, 2) = {Scount}; sess_tab(i, 3) = {Ycount}; sess_tab(i, 4) = {Ncount};
            convec = zeros(1, length(names));
            cncnt = 0;
            for k = 1:Scount
                cncnt = cncnt + 1;
                name = ['S' int2str(k) 'RelxHalf'];
                con_struct(cncnt).name = name;
                prefix = Snames{k};
                L = strfind(prefix, 'L');
                prefix = prefix(1:L-1);
                con_struct(cncnt).contrasts(1).name = [prefix 'LSRS*bf(1)'];
                con_struct(cncnt).contrasts(1).con = 1;
                con_struct(cncnt).contrasts(2).name = [prefix 'LSIS*bf(1)'];
                con_struct(cncnt).contrasts(2).con = -1;
                con_struct(cncnt).contrasts(3).name = [prefix 'LSRF*bf(1)'];
                con_struct(cncnt).contrasts(3).con = -1;
                con_struct(cncnt).contrasts(4).name = [prefix 'LSIF*bf(1)'];
                con_struct(cncnt).contrasts(4).con = 1;
                con_struct(cncnt).convec = convec;
            end
            for k = 1:Ycount
                cncnt = cncnt + 1;
                name = ['Y' int2str(k) 'RelxHalf'];
                con_struct(cncnt).name = name;
                prefix = Ynames{k};
                L = strfind(prefix, 'L');
                prefix = prefix(1:L-1);
                con_struct(cncnt).contrasts(1).name = [prefix 'LYRS*bf(1)'];
                con_struct(cncnt).contrasts(1).con = 1;
                con_struct(cncnt).contrasts(2).name = [prefix 'LYIS*bf(1)']
                con_struct(cncnt).contrasts(2).con = -1;
                con_struct(cncnt).contrasts(3).name = [prefix 'LYRF*bf(1)']
                con_struct(cncnt).contrasts(3).con = -1;
                con_struct(cncnt).contrasts(4).name = [prefix 'LYIF*bf(1)']
                con_struct(cncnt).contrasts(4).con = 1;
                con_struct(cncnt).convec = convec;
            end
            for k = 1:Ncount
                cncnt = cncnt + 1;
                name = ['N' int2str(k) 'RelxHalf'];
                con_struct(cncnt).name = name;
                prefix = Nnames{k};
                L = strfind(prefix, 'L');
                prefix = prefix(1:L-1);
                con_struct(cncnt).contrasts(1).name = [prefix 'LNRS*bf(1)'];
                con_struct(cncnt).contrasts(1).con = 1;
                con_struct(cncnt).contrasts(2).name = [prefix 'LNIS*bf(1)'];
                con_struct(cncnt).contrasts(2).con = -1;
                con_struct(cncnt).contrasts(3).name = [prefix 'LNRF*bf(1)'];
                con_struct(cncnt).contrasts(3).con = -1;
                con_struct(cncnt).contrasts(4).name = [prefix 'LNIF*bf(1)'];
                con_struct(cncnt).contrasts(4).con = 1;
                con_struct(cncnt).convec = convec;
            end
            for j = 1:numel(names) 
                fprintf(loghand, [names{j} ','])
                for k = 1:numel(con_struct)
                    for l=1:numel(con_struct(k).contrasts)
                        name = con_struct(k).contrasts(l).name;
                        con = con_struct(k).contrasts(l).con;
                        if isempty(strfind(names{j}, name)) ~= 1
                            con_struct(k).convec(j) = con;
                        end
                    end
                end
            end
            fprintf(loghand, '\n')
            for m = 1:numel(con_struct)
                for n=1:numel(con_struct(m).convec)
                    fprintf(loghand, '%f,', con_struct(m).convec(n));
                end
                fprintf(loghand, '\n')
            end
            
            matlabbatch{1}.cfg_basicio.cfg_cd.dir = cellstr(fullfile(resdir, subject));
            matlabbatch{2}.spm.stats.con.spmmat = cellstr(fullfile(resdir, subject, 'SPM.mat'));
            for p = 1:numel(con_struct) 
                matlabbatch{2}.spm.stats.con.consess{p}.tcon.name = con_struct(p).name;  
                matlabbatch{2}.spm.stats.con.consess{p}.tcon.convec = con_struct(p).convec;
                matlabbatch{2}.spm.stats.con.consess{p}.tcon.sessrep = 'none';
                matlabbatch{2}.spm.stats.con.delete = 1;
            end
            save(fullfile(logdir, [subject '_con.mat']), 'matlabbatch');
            out = spm_jobman('run',matlabbatch);
        end
        clear matlabbatch out 
    end
    clear subject
end
subs = cell(1, length(subjects));
for m = 1:length(subjects)
    subs(m) = {subjects(m).ID};
end

sub_list = Data.sub_list;
out_file = fullfile(lrn_res_dir, 'sessions.csv');
T = cell2table(sess_tab, 'RowNames', sub_list, 'VariableNames', {'sub', 'S', 'Y', 'N'});
        writetable(T, out_file);
