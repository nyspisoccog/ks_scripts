function ks_bpcontrast_func(Data, Time, Parameters)

spm('Defaults','fMRI');

spm_jobman('initcfg');

clear matlabbatch;

lrn_res_dir = Data.lrn_res_dir;
mem_res_dir = Data.mem_res_dir;
lrn_log_dir = Data.lrn_log_dir; 
mem_log_dir = Data.mem_log_dir;
sess_type = {'lrn', 'mem'};
subjects = Data.Subjects;

memlogname = fullfile(mem_log_dir, 'contrasts.csv');
memloghand = fopen(memlogname,'wt');

for i=1:numel(subjects)
    subject = subjects(i).ID;
    disp(subject)
    for lm = 1:numel(sess_type)
        if strcmp(sess_type{lm}, 'mem')
            loghand = memloghand;
            fprintf(loghand, [subject, '\n']);
            Ncount = 0; Ycount = 0; Scount = 0;
            resdir = mem_res_dir;
            logdir = mem_log_dir;
            sessions = subjects(i).mem_runs;
            load(fullfile(resdir, subject, 'SPM.mat'));
            disp(fullfile(resdir, subject, 'SPM.mat'))
            names = SPM.xX.name;
            
            convec = zeros(1, length(names));
            con_struct(1).contrasts(1).name = 'button_press*bf(1)';
            con_struct(1).contrasts(1).cnt = 1;
            con_struct(1).contrasts(1).con = 1;
         
            
            for j = 1:numel(names) 
                fprintf(loghand, [names{j} ','])
                for k = 1:numel(con_struct)
                    name = con_struct(k).contrasts(1).name;
                    con = con_struct(k).contrasts(1).con;
                    cnt = con_struct(k).contrasts(1).cnt;
                    if isempty(strfind(names{j}, name)) ~= 1
                        convec(j) = con/cnt;
                    end
                end
            end
            fprintf(loghand, '\n')
            for l=1:numel(convec)
                disp(convec(l))
                fprintf(loghand, '%f,', convec(l));
            end
            fprintf(loghand, '\n')
            matlabbatch{1}.cfg_basicio.cfg_cd.dir = cellstr(fullfile(resdir, subject));
            matlabbatch{2}.spm.stats.con.spmmat = cellstr(fullfile(resdir, subject, 'SPM.mat'));
            matlabbatch{2}.spm.stats.con.consess{1}.tcon.name = 'button_press';  
            matlabbatch{2}.spm.stats.con.consess{1}.tcon.convec = convec;
            matlabbatch{2}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
            matlabbatch{2}.spm.stats.con.consess{2}.fcon.name = 'button_press';  
            matlabbatch{2}.spm.stats.con.consess{2}.fcon.convec = {convec};
            matlabbatch{2}.spm.stats.con.consess{2}.fcon.sessrep = 'none';
            matlabbatch{2}.spm.stats.con.delete = 1;
            save(fullfile(logdir, [subject 'bp_contrast.mat']), 'matlabbatch');
            out = spm_jobman('run',matlabbatch);
        end
        clear matlabbatch out 
    end
    clear subject
end
