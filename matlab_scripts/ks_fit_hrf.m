function ks_fit_hrf(Data, Time)

%import data

res_dir = '.'
onset_dir = '.'
subject = '7432'
numruns = 12;
sessions = {}

TR = 2.2;
T = 30;

for i=1:nconds
end

for j = 1:numruns
    
    newfile = fullfile(res_dir, subject, sessions{j},...
     [subject sessions{j} '4D.nii']);
    dat = fmri_data(newfile);
 
    con_fname = fullfile(onset_dir, subject, sessions{j}, 'conds.txt');
    con_fID = fopen(con_fname, 'r');
    formatSpec = '%s';
    con_array = textscan(con_fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
    fclose(con_fID);
            
    for k = 1:length(con_array)
        ons_fname = fullfile(consdir, subject, sessions{j}, [cond_list{k} '.txt']);
        ons_fID = fopen(ons_fname, 'r');
        formatSpec = '%f';
        ons_array = textscan(ons_fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
        ons_array = round(ons_array/TR);
        onsets(k) = ons_array;
        fclose(cond_ons_fID);
    end
    
    Condition = {};
    for i = 1:length(con_array)
        Condition{i} = zeros(56,1);
        ons = onsets{i};
        for j=1:length(ons)
            Condition{i}(j) = 1;
        end
    end
    cd(fullfile(resdir, subject, sessions{j}));
    [params_obj hrf_obj] = hrf_fit(dat,TR, Condition, T,'FIR', 1);

end




end