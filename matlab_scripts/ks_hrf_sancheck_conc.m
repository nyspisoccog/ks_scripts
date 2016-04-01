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
            bp_dir = Data.bp_ons_dir;
            sessions = subjects(nsub).lrn_runs;
        end
        TR = 2.2;
        T = 30;
    
    dr = fullfile(res_dir, subject.ID);
    if ~exist(dr, 'dir')
        mkdir(dr);
    end
    
   
    if strcmp(Parameters.bp.val, 'y')
        bp = {};
        for nsess = 1:length(sessions)
            fname = fullfile(bp_dir, [subject.ID sessions{nsess} '.txt']);
            bp_fID = fopen(fname, 'r');
            formatSpec = '%f';
            bp_array = textscan(bp_fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
            bp_array = bp_array{1, 1};
            bp_array = round(bp_array/TR) + 56*(nsess-1) + 1;
            bp = [bp; bp_array];
            fclose(bp_fID);
        end
        Run = zeros(56*length(sessions), 1);
        for nons = 1:length(bp)
           Run(bp{nons}) = 1;   
       end
       Runc{1} = Run;
    end
   
    
   
    cd(dr)
    
    dat =fmri_data(fullfile(data_path, sess_type{lm}, subject.ID, 'conn_denoise', 'results', ...
         'preprocessing', 'niftiDATA_Subject001_Condition000.nii'));
    
    if strcmp(Parameters.method.val, 'FIR')
        [params_obj, hrf_obj] = hrf_fit(dat,TR, Runc, T,'FIR', 1);
    end
    
    if strcmp(Parameters.method.val, 'IL')
        [params_obj, hrf_obj] = hrf_fit(dat,TR, Runc, T,'IL', 0);
    end
    
    if strcmp(Parameters.method.val, 'CHRF')
        [params_obj, hrf_obj] = hrf_fit(dat,TR, Runc, T,'CHRF', 2);
    end
    
end
end
end




