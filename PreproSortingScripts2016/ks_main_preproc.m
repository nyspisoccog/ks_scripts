clear Data

rmpath('/Users/katherine/spm8')
addpath('/Users/katherine/spm12')

tstamp = clock;
time1 = num2str(tstamp(4));
time2 = num2str(tstamp(5));

Time.date = date;
Time.time1 = time1;
Time.time2 = time2;


 subjects = {'7403', '7404', '7408', '7412', '7414', '7418', '7430', '7432',...
             '7436', '7443', '7453', '7458', '7474', '7477', '7478', '7480',...
             '7498', '7508', '7521', '7533', '7534', '7542', '7558', '7561',...
             '7562', '7575', '7580', '7607', '7619', '7623', '7638',...
             '7641', '7645', '7648', '7649', '7659', '7714', '7719', '7726'};
 

subjects = {'7645'};

standard_runs = {...
   'run1L1', 'run1L2', 'run1L3', 'run1L4',...
   'run1L5', 'run1L6', 'run1M1', 'run1M2',...
   'run1M3', 'run1M4', 'run1M5', 'run1M6',...
   'run2L1', 'run2L2', 'run2L3', 'run2L4',...
   'run2L5', 'run2L6', 'run2M1', 'run2M2',...
   'run2M3', 'run2M4', 'run2M5', 'run2M6', ... 
 };

standard_runs = {'run1L1', 'run1L2'}

standard_slices = {...
    34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34,...
    34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34,...
    };

Data.data_path = '/Volumes/LaCie/LaPrivate/soccog/preproc_data_test/preproc_data_new';
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
    else runs = standard_runs;
    end
    Data.Subjects(i).Runs = runs;
    
end


%logfile
if ~exist(Data.logdir, 'dir')
        mkdir(Data.logdir)
end

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

ks_realign_func(Data, Time)
fprintf(loghand, 'ks_realign_func\n');
fprintf(loghand, 'mean image of functional runs calculated');


ks_seg1_func(Data, Time)
fprintf(loghand, 'ks_seg1_func\n');
fprintf(loghand, 'segmenting original T1 completed\n');

ks_strip_func(Data, Time)
 
fprintf(loghand, 'ks_strip_func\n');
fprintf(loghand, 'skullstripping original T1 completed\n');
 
ks_coreg_func(Data, Time)
 
fprintf(loghand, 'ks_coreg_func\n');
fprintf(loghand, 'coreg of mean functional to skullstripped T1 completed\n');
 
ks_seg2_func(Data, Time)
 
fprintf(loghand, 'ks_seg2_func\n');
fprintf(loghand, 'segment/Dartel import of skullstripped T1 completed\n');

ks_smooth_func(Data, Time)

fprintf(loghand, 'ks_smooth_func\n');
fprintf(loghand, 'created smoothed non-normalized images for ART\n');
 
ks_rundartel_func(Data, Time)
 
fprintf(loghand, 'ks_rundartel_func\n');
fprintf(loghand, 'DARTEL completed');
 
ks_normalize_func(Data, Time)
 
fprintf(loghand, 'ks_normalize_func\n');
fprintf(loghand, 'normalization completed');

fclose(loghand);






