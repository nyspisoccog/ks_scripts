clear Data

scriptDir = '/media/truecrypt1/SocCog/test/bp_sanitycheck_wrp';

addpath(scriptDir);

tstamp = clock;
time1 = num2str(tstamp(4));
time2 = num2str(tstamp(5));

Time.date = date;
Time.time1 = time1;
Time.time2 = time2;


subjects = {'7404', '7408', '7412', '7414', '7418', '7430', '7432',...
            '7436', '7443', '7453', '7458', '7474', '7477', '7478', '7480',...
            '7498', '7508', '7521', '7533', '7534', '7542', '7558', '7561',...
            '7562', '7575', '7580', '7607', '7613', '7619', '7623', '7638',...
            '7641', '7645', '7648', '7649', '7659', '7714', '7719', '7726'};
        
        
standard_runs = {...
  'run1L1', 'run1L2', 'run1L3', 'run1L4',...
  'run1L5', 'run1L6', 'run1M1', 'run1M2',...
  'run1M3', 'run1M4', 'run1M5', 'run1M6',...
  'run2L1', 'run2L2', 'run2L3', 'run2L4',...
  'run2L5', 'run2L6', 'run2M1', 'run2M2',...
  'run2M3', 'run2M4', 'run2M5', 'run2M6' ... 
};


standard_slices = {...
    34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34,...
    34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34,...
    };

Data.data_path = '/media/truecrypt1/SocCog/SocCog/preproc_data/';
Data.results_folder = '/media/truecrypt1/SocCog/test/all_conds';
Data.logdir = fullfile(Data.results_folder, 'logdir');  
Data.bp_onsets_folder = '/media/truecrypt1/SocCog/SocCog/tmp1/';
Data.cond_onsets_folder = '/media/truecrypt1/SocCog/SocCog/tmp2/';

if ~exist(Data.results_folder, 'dir')
        mkdir(Data.results_folder);
end 

if ~exist(Data.logdir, 'dir')
    mkdir(Data.logdir);
end

for i = 1:numel(subjects)
    Data.Subjects(i).ID = char(subjects(i));
    if strcmp(subjects(i), '7403')
        runs = standard_runs(1:19);
     elseif strcmp(subjects(i), '7404')
        runs = standard_runs(7:24);
    elseif strcmp(subjects(i), '7458')
        runs =  standard_runs(1:23);
    elseif strcmp(subjects(i), '7561')
        runs = horzcat(standard_runs(1:7), standard_runs(9:24));
    elseif strcmp(subjects(i) ,'7726')
        runs = horzcat(standard_runs(1:12), standard_runs(14:24));
    elseif strcmp(subjects(i) ,'7562')
        runs = standard_runs(7:24);
    else runs = standard_runs;
    end
    Data.Subjects(i).Runs = runs;
    Data.Subjects(i).NSlices = 34;
    Data.Subjects(i).SliceOrd = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34];
   
end

Data_7562_1Ls_St.data_path = Data.data_path;
Data_7562_1Ls_St.logdir = Data.logdir;
Data_7562_1Ls_St.Subjects(1).ID = '7562';
Data_7562_1Ls_St.Subjects(1).Runs = standard_runs(1:6);
Data_7562_1Ls_St.Subjects(1).NSlices = 35;
Data_7562_1Ls_St.Subjects(1).SliceOrd = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34];

ks_spec_conds_event_wrp_func(Data, Time)

%ks_bp_estimate(Data, Time)

%ks_bp_contrast(Data, Time)
