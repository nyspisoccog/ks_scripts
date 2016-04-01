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
 

standard_runs = {...
   'run1L1', 'run1L2', 'run1L3', 'run1L4','run1L5', 'run1L6',...
   'run2L1', 'run2L2', 'run2L3', 'run2L4','run2L5', 'run2L6' 
 };

standard_slices = {...
    34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34,...
    34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34,...
    };

Data.data_path = '/Volumes/LaCie/LaPrivate/soccog/preproc_data_new/';
Data.logdir = fullfile(Data.data_path, 'logdir') ;   

for i = 1:numel(subjects)
    Data.Subjects(i).ID = char(subjects(i));
    if strcmp(subjects(i), '7403')
        runs = standard_runs(1:7);
    elseif strcmp(subjects(i), '7659')
        runs =  standard_runs(1:6);
    elseif strcmp(subjects(i), '7719')
        runs =  standard_runs(1:6);
    elseif strcmp(subjects(i), '7726')
        runs = horzcat(standard_runs(1:6), standard_runs(8:12));
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


ks_4d23d_func(Data, Time)

fprintf(loghand, 'converted files to 3D\n');


fclose(loghand);






