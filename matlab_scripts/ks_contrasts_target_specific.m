function ks_contrasts_target_specific(Data, Time)

spm('Defaults','fMRI');

spm_jobman('initcfg');

clear matlabbatch;

lrn_res_dir = Data.lrn_res_dir;
mem_res_dir = Data.mem_res_dir;
lrn_ons_dir = Data.lrn_ons_dir;
mem_ons_dir = Data.mem_ons_dir;
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
            onsdir = mem_ons_dir;
            sessions = subjects(i).mem_runs;
            load(fullfile(resdir, subject, 'derivboost', 'SPM.mat'));
            disp(fullfile(resdir, subject, 'derivboost', 'SPM.mat'))
            
            target_fname = fullfile(onsdir, [subject 'target_names.txt']);
            target_fID = fopen(target_fname,'r');
            formatSpec = '%s';
            targets = textscan(target_fname, formatSpec, 'Delimiter', '\n', 'ReturnOnError', false);
            
            target_names = ['Robin', 'Sun', 'Kelly', 'Pat', 'Tal', 'Misha', 'Sandy', 'Chris', 'Ronnie', 'Terry', 'Jan', 'Sam']
        
            for j = 1:length(target_names)
                target_struct(j).name = target_names(j);
                target_struct(j).IT_array = [];
                target_struct(j).IU_array = [];
            end
            
            reg_names = SPM.xX.name;
           
            convec = zeros(1, length(reg_names));
            for j = 1:numel(reg_names)
                reg_name = reg_names{j};
                open_paren = strfind(reg_name, '(') + 1;
                close_paren = strfind(reg_name, ')') - 1;
                sn_num = str2num(reg_name(open_paren:close_paren))
                
              
                curr_tar_name = targets(sn_num);
                curr_tar_ind = find(target_names==curr_tar_name)
             
                
                if isempty(strfind(reg_names{j}, 'MNIT*bf(1)')) ~= 1
                   append(target_struct(curr_tar_ind).IT_array, j)
                elseif isempty(strfind(reg_names{j}, 'MNIU*bf(1)')) ~= 1
                   append(target_struct(cur_tar_ind).IU_array, j)
                end
                
            end
            
            
            for j = 1:length(target_names)
                IT_array = target_struct(j).IT_array;
                IU_array = target_struct(j).IU_array;
                IT_weight = 1/length(IT_array);
                IU_weight = -1/length(IU_array);
                
                convec = zeros(1, length(reg_names))
                for k = 1:length(IT_array) 
                    convec(IT_array(k)) = IT_weight;
                end
                for k = 1:length(IU_array) 
                    convec(IU_array(k)) = IU_weight;
                end
                
                con_struct(j).name = target_names(j);
                con_struct(j).convec = convec
                
            end
                
           
          
            fprintf(loghand, '\n')
            for m = 1:numel(con_struct)
                for n=1:numel(con_struct(m).convec)
                    fprintf(loghand, '%f,', con_struct(m).convec(n));
                end
                fprintf(loghand, '\n')
            end
            
            matlabbatch{1}.cfg_basicio.cfg_cd.dir = cellstr(fullfile(resdir, subject));
            matlabbatch{2}.spm.stats.con.spmmat = cellstr(fullfile(resdir, subject, 'derivboost', 'SPM.mat'));
            for p = 1:numel(contrasts) 
                matlabbatch{2}.spm.stats.con.consess{p}.tcon.name = con_struct(p).name;  
                matlabbatch{2}.spm.stats.con.consess{p}.tcon.convec = con_struct(p).convec;
                matlabbatch{2}.spm.stats.con.consess{p}.tcon.sessrep = 'none';
                matlabbatch{2}.spm.stats.con.delete = 1;
            end
            save(fullfile(logdir, [subject '_target.mat']), 'matlabbatch');
            out = spm_jobman('run',matlabbatch);
        end
        clear matlabbatch out 
    end
    clear subject
end
