function ks_contrasts_multi_func(Data, Time)

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

for i=1:numel(subjects)
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
            for j = 1:numel(names)
                if isempty(strfind(names{j}, 'LNI*bf(1)')) ~= 1
                   Ncount = Ncount + 1;
                elseif isempty(strfind(names{j}, 'LSI*bf(1)')) ~= 1 
                   Scount = Scount + 1;
                elseif isempty(strfind(names{j}, 'LYI*bf(1)')) ~= 1
                   Ycount = Ycount + 1;
                end
            end
            convec = zeros(1, length(names));
            con_struct(1).name = 'SvY';
            con_struct(1).contrasts(1).name = 'LSI*bf(1)';
            con_struct(1).contrasts(1).cnt = Scount;
            con_struct(1).contrasts(1).con = -1;
            con_struct(1).contrasts(2).name = 'LSR*bf(1)';
            con_struct(1).contrasts(2).cnt = Scount;
            con_struct(1).contrasts(2).con = 1;
            con_struct(1).contrasts(3).name = 'LYI*bf(1)';
            con_struct(1).contrasts(3).cnt = Ycount;
            con_struct(1).contrasts(3).con = 1;
            con_struct(1).contrasts(4).name = 'LYR*bf(1)';
            con_struct(1).contrasts(4).cnt = Ycount;
            con_struct(1).contrasts(4).con = -1;
            con_struct(1).convec = convec;
            con_struct(2).name = 'SvYN';
            con_struct(2).contrasts(1).name = 'LSI*bf(1)';
            con_struct(2).contrasts(1).cnt = Scount;
            con_struct(2).contrasts(1).con = -1;
            con_struct(2).contrasts(2).name = 'LSR*bf(1)';
            con_struct(2).contrasts(2).cnt = Scount;
            con_struct(2).contrasts(2).con = 1;
            con_struct(2).contrasts(3).name = 'LYI*bf(1)';
            con_struct(2).contrasts(3).cnt = Ycount;
            con_struct(2).contrasts(3).con = .5;
            con_struct(2).contrasts(4).name = 'LYR*bf(1)';
            con_struct(2).contrasts(4).cnt = Ycount;
            con_struct(2).contrasts(4).con = -.5;
            con_struct(2).contrasts(5).name = 'LNI*bf(1)';
            con_struct(2).contrasts(5).cnt = Ncount;
            con_struct(2).contrasts(5).con = .5;
            con_struct(2).contrasts(6).name = 'LNR*bf(1)';
            con_struct(2).contrasts(6).cnt = Ncount;
            con_struct(2).contrasts(6).con = -.5;
            con_struct(2).convec = convec
            
            for j = 1:numel(names) 
                fprintf(loghand, [names{j} ','])
                for k = 1:numel(con_struct)
                    for l=1:numel(con_struct(k).contrasts)
                        name = con_struct(k).contrasts(l).name;
                        con = con_struct(k).contrasts(l).con;
                        cnt = con_struct(k).contrasts(l).cnt;
                        if isempty(strfind(names{j}, name)) ~= 1
                            con_struct(k).convec(j) = con/cnt;
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
            save(fullfile(logdir, [subject '_SvY.mat']), 'matlabbatch');
            out = spm_jobman('run',matlabbatch);
        end
        clear matlabbatch out 
    end
    clear subject
end
