function ks_fit_hrf_conc(Data, Parameters)

addpath(genpath('/Users/katherine/CanlabCore-Master'));
addpath(genpath('/Users/katherine/spm12'));

data_path = Data.data_path;
art_dir = Data.art_dir;
bp_ons_dir = Data.bp_ons_dir;

sess_type = {'lrn'};
subjects = Data.Subjects;
delimiter = '\t';
 
for nsub=1:length(subjects)
    subject = subjects(nsub);
    for lm = 1:length(sess_type)
        if strcmp(sess_type(lm), 'lrn')
            res_dir = Data.lrn_res_dir;
            ons_dir = Data.lrn_ons_dir;
            sessions = subjects(nsub).lrn_runs;
        end
        TR = 2.2;
        T = 30;

    names = {};

    for nsess = 1:length(sessions)
        con_fname = fullfile(ons_dir, subject.ID, sessions{nsess}, 'conds.txt');
        con_fID = fopen(con_fname, 'r');
        formatSpec = '%s';
        con_array = textscan(con_fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
        con_array = con_array{1, 1};
        for nconds = 1:length(con_array)
            if length(names) == 0
                names = horzcat(names, con_array(nconds));
            elseif ~ismember(con_array{nconds}, names)
                names = horzcat(names, con_array(nconds));
            end
        end
        fclose(con_fID);
    end
    
    dr = fullfile(res_dir, subject.ID);
    if ~exist(dr, 'dir')
        mkdir(dr);
    end
    filen = fullfile(res_dir, subject.ID, 'names.txt');
    fhand = fopen(filen,'wt');
    for nname = 1:length(names)
        fprintf(fhand,names{nname});
        fprintf(fhand, '\n');
    end
    fclose(fhand);
    
    for nconds = 1:length(names)
        onsets = {};
        for nsess = 1:length(sessions)
            ons_fname = fullfile(ons_dir, subject.ID, sessions{nsess}, [names{nconds} '.txt']);
            if exist(ons_fname, 'file')
                ons_fID = fopen(ons_fname, 'r');
                formatSpec = '%f';
                ons_array = textscan(ons_fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
                ons_array = ons_array{1, 1};
%                 for n = 1:length(ons_array)
%                     if mod(ons_array(n),2.2) > 1.6
%                         ons_array(n) = ons_array(n) + 2.2;
%                     end
%                 end
                 ons_array = round(ons_array/TR) + 56*(nsess-1) + 1;
%                 sec_array = ons_array + 1;
%                 new_array = sort([ons_array; sec_array]);
%                 onsets = [onsets; new_array];
                onsets= [onsets; ons_array];
                fclose(ons_fID);
            end
        end
       Run = zeros(56*length(sessions), 1);
       for nons = 1:length(onsets)
           Run(onsets{nons}) = 1;   
       end
       Runc{nconds} = Run;
    end
    
    if strcmp(Parameters.bp.val, 'y')
        bp = {};
        for nsess = 1:length(sessions)
            fname = fullfile(bp_onset_dir, [subject.ID sessions{nsess} '.txt']);
            bp_fID = fopen(fname, 'r');
            formatSpec = '%f';
            bp_array = textscan(bp_fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
            bp_array = round(bp_array/TR) + 56*(nsess-1) + 1;
            bp = [bp; bp_array];
            fclose(bp_ID);
        end
        Run = zeros(56*length(sessions), 1);
        for nons = 1:length(bp)
           Run(bp{nons}) = 1;   
       end
       Runc{length(names)+1} = Run;
    end
   
    
   
    cd(dr)
    
%     dat =fmri_data(fullfile(data_path, sess_type{lm}, subject.ID, 'conn_denoise', 'results', ...
%         'preprocessing', 'niftiDATA_Subject001_Condition000.nii'));
%     
%     if strcmp(Parameters.method.val, 'FIR')
%         [params_obj, hrf_obj] = hrf_fit(dat,TR, Runc, T,'FIR', 1);
%     end
%     
%     if strcmp(Parameters.method.val, 'IL')
%         [params_obj, hrf_obj] = hrf_fit(dat,TR, Runc, T,'IL', 0);
%     end
%     
%     if strcmp(Parameters.method.val, 'CHRF')
%         [params_obj, hrf_obj] = hrf_fit(dat,TR, Runc, T,'CHRF', 2);
%     end
    
end
end
end




