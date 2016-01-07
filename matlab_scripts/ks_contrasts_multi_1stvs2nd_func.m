function ks_contrasts_multi_1stvs2nd_func(Data, Time)

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
            NFcount = 0; YFcount = 0; SFcount = 0; NScount = 0; YScount = 0;  SScount = 0;
            resdir = lrn_res_dir;
            logdir = lrn_log_dir;
            sessions = subjects(i).lrn_runs;
            load(fullfile(resdir, subject, 'SPM.mat'));
            disp(fullfile(resdir, subject, 'SPM.mat'))
            names = SPM.xX.name;
            for j = 1:numel(names)
                if isempty(strfind(names{j}, 'LNIF*bf(1)')) ~= 1
                   NFcount = NFcount + 1;
                elseif isempty(strfind(names{j}, 'LSIF*bf(1)')) ~= 1 
                   SFcount = SFcount + 1;
                elseif isempty(strfind(names{j}, 'LYIF*bf(1)')) ~= 1
                   YFcount = YFcount + 1;
                elseif isempty(strfind(names{j}, 'LNIS*bf(1)')) ~= 1
                   NScount = NScount + 1;
                elseif isempty(strfind(names{j}, 'LSIS*bf(1)')) ~= 1
                   SScount = SScount + 1;
                elseif isempty(strfind(names{j}, 'LYIS*bf(1)')) ~= 1
                   YScount = YScount + 1;
                end
            end
            convec = zeros(1, length(names));
            con_struct(1).name = 'SvYsec';
            con_struct(1).contrasts(1).name = 'LSIS*bf(1)';
            con_struct(1).contrasts(1).cnt = SScount;
            con_struct(1).contrasts(1).con = -1;
            con_struct(1).contrasts(2).name = 'LSRS*bf(1)';
            con_struct(1).contrasts(2).cnt = SScount;
            con_struct(1).contrasts(2).con = 1;
            con_struct(1).contrasts(3).name = 'LYIS*bf(1)';
            con_struct(1).contrasts(3).cnt = YScount;
            con_struct(1).contrasts(3).con = 1;
            con_struct(1).contrasts(4).name = 'LYRS*bf(1)';
            con_struct(1).contrasts(4).cnt = YScount;
            con_struct(1).contrasts(4).con = -1;
            con_struct(1).convec = convec;
            con_struct(2).name = 'SvYNsec';
            con_struct(2).contrasts(1).name = 'LSIS*bf(1)';
            con_struct(2).contrasts(1).cnt = SScount;
            con_struct(2).contrasts(1).con = -1;
            con_struct(2).contrasts(2).name = 'LSRS*bf(1)';
            con_struct(2).contrasts(2).cnt = SScount;
            con_struct(2).contrasts(2).con = 1;
            con_struct(2).contrasts(3).name = 'LYIS*bf(1)';
            con_struct(2).contrasts(3).cnt = YScount;
            con_struct(2).contrasts(3).con = .5;
            con_struct(2).contrasts(4).name = 'LYRS*bf(1)';
            con_struct(2).contrasts(4).cnt = YScount;
            con_struct(2).contrasts(4).con = -.5;
            con_struct(2).contrasts(5).name = 'LNIS*bf(1)';
            con_struct(2).contrasts(5).cnt = NScount;
            con_struct(2).contrasts(5).con = .5;
            con_struct(2).contrasts(6).name = 'LNRS*bf(1)';
            con_struct(2).contrasts(6).cnt = NScount;
            con_struct(2).contrasts(6).con = -.5;
            con_struct(2).convec = convec
            con_struct(3).name = 'SvY1vSvY2';
            con_struct(3).contrasts(1).name = 'LSIS*bf(1)';
            con_struct(3).contrasts(1).cnt = SScount;
            con_struct(3).contrasts(1).con = -1;
            con_struct(3).contrasts(2).name = 'LSRS*bf(1)';
            con_struct(3).contrasts(2).cnt = SScount;
            con_struct(3).contrasts(2).con = 1;
            con_struct(3).contrasts(3).name = 'LYIS*bf(1)';
            con_struct(3).contrasts(3).cnt = YScount;
            con_struct(3).contrasts(3).con = 1;
            con_struct(3).contrasts(4).name = 'LYRS*bf(1)';
            con_struct(3).contrasts(4).cnt = YScount;
            con_struct(3).contrasts(4).con = -1;
            con_struct(3).contrasts(5).name = 'LSIF*bf(1)';
            con_struct(3).contrasts(5).cnt = SFcount;
            con_struct(3).contrasts(5).con = 1;
            con_struct(3).contrasts(6).name = 'LSRF*bf(1)';
            con_struct(3).contrasts(6).cnt = SFcount;
            con_struct(3).contrasts(6).con = -1;
            con_struct(3).contrasts(7).name = 'LYIF*bf(1)';
            con_struct(3).contrasts(7).cnt = YFcount;
            con_struct(3).contrasts(7).con = -1;
            con_struct(3).contrasts(8).name = 'LYRF*bf(1)';
            con_struct(3).contrasts(8).cnt = YFcount;
            con_struct(3).contrasts(8).con = 1;
            con_struct(3).convec = convec;
            con_struct(4).name = 'SvNsec';
            con_struct(4).contrasts(1).name = 'LSIS*bf(1)';
            con_struct(4).contrasts(1).cnt = SScount;
            con_struct(4).contrasts(1).con = -1;
            con_struct(4).contrasts(2).name = 'LSRS*bf(1)';
            con_struct(4).contrasts(2).cnt = SScount;
            con_struct(4).contrasts(2).con = 1;
            con_struct(4).contrasts(3).name = 'LNIS*bf(1)';
            con_struct(4).contrasts(3).cnt = YScount;
            con_struct(4).contrasts(3).con = 1;
            con_struct(4).contrasts(4).name = 'LNRS*bf(1)';
            con_struct(4).contrasts(4).cnt = YScount;
            con_struct(4).contrasts(4).con = -1;
            con_struct(4).convec = convec;
            con_struct(5).name = 'SvN1vSvN2';
            con_struct(5).contrasts(1).name = 'LSIS*bf(1)';
            con_struct(5).contrasts(1).cnt = SScount;
            con_struct(5).contrasts(1).con = -1;
            con_struct(5).contrasts(2).name = 'LSRS*bf(1)';
            con_struct(5).contrasts(2).cnt = SScount;
            con_struct(5).contrasts(2).con = 1;
            con_struct(5).contrasts(3).name = 'LNIS*bf(1)';
            con_struct(5).contrasts(3).cnt = YScount;
            con_struct(5).contrasts(3).con = 1;
            con_struct(5).contrasts(4).name = 'LNRS*bf(1)';
            con_struct(5).contrasts(4).cnt = YScount;
            con_struct(5).contrasts(4).con = -1;
            con_struct(5).contrasts(5).name = 'LSIF*bf(1)';
            con_struct(5).contrasts(5).cnt = SFcount;
            con_struct(5).contrasts(5).con = 1;
            con_struct(5).contrasts(6).name = 'LSRF*bf(1)';
            con_struct(5).contrasts(6).cnt = SFcount;
            con_struct(5).contrasts(6).con = -1;
            con_struct(5).contrasts(7).name = 'LNIF*bf(1)';
            con_struct(5).contrasts(7).cnt = YFcount;
            con_struct(5).contrasts(7).con = -1;
            con_struct(5).contrasts(8).name = 'LNRF*bf(1)';
            con_struct(5).contrasts(8).cnt = YFcount;
            con_struct(5).contrasts(8).con = 1;
            con_struct(5).convec = convec;
            con_struct(6).name = 'SvYN1vsSvYN2';
            con_struct(6).contrasts(1).name = 'LSIS*bf(1)';
            con_struct(6).contrasts(1).cnt = SScount;
            con_struct(6).contrasts(1).con = -1;
            con_struct(6).contrasts(2).name = 'LSRS*bf(1)';
            con_struct(6).contrasts(2).cnt = SScount;
            con_struct(6).contrasts(2).con = 1;
            con_struct(6).contrasts(3).name = 'LYIS*bf(1)';
            con_struct(6).contrasts(3).cnt = YScount;
            con_struct(6).contrasts(3).con = .5;
            con_struct(6).contrasts(4).name = 'LYRS*bf(1)';
            con_struct(6).contrasts(4).cnt = YScount;
            con_struct(6).contrasts(4).con = -.5;
            con_struct(6).contrasts(5).name = 'LNIS*bf(1)';
            con_struct(6).contrasts(5).cnt = NScount;
            con_struct(6).contrasts(5).con = .5;
            con_struct(6).contrasts(6).name = 'LNRS*bf(1)';
            con_struct(6).contrasts(6).cnt = NScount;
            con_struct(6).contrasts(6).con = -.5;
            con_struct(6).contrasts(7).name = 'LSIF*bf(1)';
            con_struct(6).contrasts(7).cnt = SFcount;
            con_struct(6).contrasts(7).con = 1;
            con_struct(6).contrasts(8).name = 'LSRF*bf(1)';
            con_struct(6).contrasts(8).cnt = SFcount;
            con_struct(6).contrasts(8).con = -1;
            con_struct(6).contrasts(9).name = 'LYIF*bf(1)';
            con_struct(6).contrasts(9).cnt = YFcount;
            con_struct(6).contrasts(9).con = -.5;
            con_struct(6).contrasts(10).name = 'LYRF*bf(1)';
            con_struct(6).contrasts(10).cnt = YFcount;
            con_struct(6).contrasts(10).con = .5;
            con_struct(6).contrasts(11).name = 'LNIF*bf(1)';
            con_struct(6).contrasts(11).cnt = NFcount;
            con_struct(6).contrasts(11).con = -.5;
            con_struct(6).contrasts(12).name = 'LNRF*bf(1)';
            con_struct(6).contrasts(12).cnt = NFcount;
            con_struct(6).contrasts(12).con = .5;
            con_struct(6).convec = convec;
            con_struct(7).name = 'button_press';
            con_struct(7).contrasts(1).name = 'button_press*bf(1)';
            con_struct(7).contrasts(1).cnt = 1;
            con_struct(7).contrasts(1).con = 1;
            con_struct(7).convec = convec;
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
            save(fullfile(logdir, [subject '_con.mat']), 'matlabbatch');
            out = spm_jobman('run',matlabbatch);
        end
        clear matlabbatch out 
    end
    clear subject
end
