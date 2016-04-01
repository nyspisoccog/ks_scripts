clear Data

scriptDir = '/home/katie/scripts/ArtRepairScripts/alphascript/BatchDir';

addpath(scriptDir);

tstamp = clock;
time1 = num2str(tstamp(4));
time2 = num2str(tstamp(5));

Time.date = date;
Time.time1 = time1;
Time.time2 = time2;


subjects = {'7403', '7404', '7408', '7412', '7414', '7418', '7430', '7432',...
            '7436', '7443', '7453', '7458', '7474', '7477', '7478', '7480',...
            '7498', '7508', '7521', '7533', '7534', '7542', '7558', '7561',...
            '7562', '7575', '7580', '7607', '7613', '7619', '7623', '7638',...
            '7641', '7645', '7648', '7649', '7659', '7714', '7719', '7726'};
        
standard_runs = {...
  '/func/run1L1/', '/func/run1L2/', '/func/run1L3/', '/func/run1L4/',...
  '/func/run1L5/', '/func/run1L6/', '/func/run1M1/', '/func/run1M2/',...
  '/func/run1M3/', '/func/run1M4/', '/func/run1M5/', '/func/run1M6/',...
  '/func/run2L1/', '/func/run2L2/', '/func/run2L3/', '/func/run2L4/',...
  '/func/run2L5/', '/func/run2L6/', '/func/run2M1/', '/func/run2M2/',...
  '/func/run2M3/', '/func/run2M4/', '/func/run2M5/', '/func/run2M6/', ... 
};

standard_slices = {...
    34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34,...
    34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34,...
    };

Data.data_path = '/media/truecrypt1/SocCog/SocCog/preproc_data/';
Data.logdir = fullfile(Data.data_path, 'logdir') ;   

for i = 1:numel(subjects)
    Data.Subjects(i).ID = char(subjects(i));
    if strcmp(subjects(i), '7403')
        runs = standard_runs(1:19);
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


%logfile
mkdir(Data.logdir);
logdir = Data.logdir;

tstamp = clock;
filen = ['PreProcLog',date,'Time',num2str(tstamp(4)),num2str(tstamp(5)),'.txt'];
logname = fullfile(logdir, filen);
loghand = fopen(logname,'wt');
fprintf(loghand,filen);
fprintf(loghand,'\nCONFIGURATION');
fprintf(loghand,'\n Subjects');

for i = 1:numel(Data.Subjects)
    subject = Data.Subjects(i).ID;
	fprintf(loghand,'\n  %s', subject);
end

ks_slicetime_func(Data, Time)

fprintf(loghand, 'ks_slicetime_func\n');
fprintf(loghand, 'slicetiming completed\n');

ks_slicetime_func(Data_7562_1Ls_St, Time)
fprintf(loghand, 'ks_slicetime_func\n');
fprintf(loghand, 'slicetiming for 7562 1Ls completed\n');

for i = 1:numel(subjects)
    if strcmp(subjects(i) ,'7562')
        runs = standard_runs;
        Data.Subjects(i).Runs = runs;
    end
end

ks_realign_func(Data, Time)

fprintf(loghand, 'ks_realign_func\n');
fprintf(loghand, 'realignment completed\n');

ks_seg1_func(Data, Time)

fprintf(loghand, 'ks_seg1_func\n');
fprintf(loghand, 'segmenting original T1 completed\n');

ks_strip_func(Data, Time)

fprintf(loghand, 'ks_strip_func\n');
fprintf(loghand, 'skullstripping original T1 completed\n');

ks_coreg_func(Data, Time)

fprintf(loghand, 'ks_coreg_func\n');
fprintf(loghand, 'coreg of mean anatomical to skullstripped T1 completed\n');

ks_seg2_func(Data, Time)

fprintf(loghand, 'ks_seg2_func\n');
fprintf(loghand, 'segment/Dartel import of skullstripped T1 completed\n');

ks_rundartel_func(Data, Time)

fprintf(loghand, 'ks_rundartel_func\n');
fprintf(loghand, 'DARTEL completed');

ks_normalize_func(Data, Time)

fprintf(loghand, 'ks_normalize_func\n');
fprintf(loghand, 'normalization completed');

fclose(loghand);






