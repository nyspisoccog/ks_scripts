%ks_main_art is the main script you run. It has a bunch of directory set up
%that you'd obviously have to modify for your situation. Data.data_dir is 
%the directory where your preprocessed data are. Data.motion_dir is where 
%your realignment parameters are (which is probably the same directory).  
%Data.res_dir is the directory where your first levels are stored. All the 
%business about lrn and mem is something specific to my setup: I 
%essentially have two experiments in one, and lrn and mem separates them 
%out.  This script will write the outlier lists to data_dir (just like art 
%does normally) and will write all the diagnostics to the subject specific 
%folders in res_dir. Two of my subjects have 'a'and 'b' labels: that's
%because they had different numbers of slices in some runs and art doesn't
%like that.  So when I'm specifying which subjects have which runs (a lot
%had missing runs for one reason or another) for those subjects I also
%specify a portion variable as you see below -- if you ever need to run art
%for a subset of a subject's runs this will prevent the dialogue where it
%asks you which sessions to use. You'll also need to change the file
%selection lines in ks_art_batch.m, as well as some lines doing some more 
%directory path construction (lines 80-87 and 36-7). I tried to remember 
%to mark everything I changed in art.m (now ks_art.m) with a comment like 
%KS edited, KS added, KS commented out, although I should have done KRS, 
%because KS is als found in "brainmasks" and words like that.  There is a 
%little bit of messiness that I haven't fixed: I think I create a 
%configuration setting, 'subj', that I never wind up using (I use 'artID' 
%instead).  Also, there's one process that gets run twice because I both 
%explicitly call the function and make it so that another function calls 
%it.  I should fix this but I'm erring in favor of just sending this out to 
%you.  Finally you have to make a copy of art.fig in your art directory and 
%rename it ks_art.fig (or whatever is appropriate if you decide to rename 
%these scripts! Ok, that's all I can think of.  Hopefully this works for
%you.

clear Data
dbstop if error

scriptDir = '/Users/katherine/ks_scripts/matlab_scripts/';

addpath(scriptDir);

tstamp = clock;
time1 = num2str(tstamp(4));
time2 = num2str(tstamp(5));

Time.date = date;
Time.time1 = time1;
Time.time2 = time2;


subjects = {'7404', '7408', '7412', '7414', '7418', '7430', '7432',...
            '7436', '7443a', '7443b', '7453', '7458', '7474', '7477',...
            '7478', '7480', '7498', '7508', '7521', '7533', '7534',...
            '7542', '7558', '7561', '7562', '7562', '7575', '7580', '7607',...
            '7619', '7623', '7638','7641', '7645', '7648', '7649',...
            '7659', '7714', '7719', '7726'};

st_lrn_runs = {...
  'run1L1', 'run1L2', 'run1L3', 'run1L4', 'run1L5', 'run1L6',...
  'run2L1', 'run2L2', 'run2L3', 'run2L4','run2L5', 'run2L6'...
  };



st_mem_runs = {...
  'run1M1', 'run1M2', 'run1M3', 'run1M4', 'run1M5', 'run1M6',...
  'run2M1', 'run2M2', 'run2M3', 'run2M4','run2M5', 'run2M6'...
  };

standard_slices = {...
    34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34,...
    34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34,...
    };


Data.data_dir = '/Volumes/LaCie/LaPrivate/soccog/preproc_data_art';
Data.motion_dir = '/Volumes/LaCie/LaPrivate/soccog/preproc_data_art';
Data.res_dir = '/Volumes/LaCie/LaPrivate/soccog/results/mem_1stlev_forart';


Data.log_dir = [Data.res_dir '/logdir'];
Data.lrn_res_dir = fullfile(Data.res_dir, 'lrn');
Data.mem_res_dir = fullfile(Data.res_dir, 'mem');
Data.lrn_log_dir = fullfile(Data.log_dir, 'lrn'); 
Data.mem_log_dir = fullfile(Data.log_dir, 'mem');  
Data.sub_list = subjects;

dir_list = {Data.res_dir, Data.log_dir, Data.mem_res_dir, Data.lrn_res_dir, Data.lrn_log_dir, Data.mem_log_dir};

for i=1:numel(dir_list)
    if ~exist(dir_list{i}, 'dir')
        mkdir(dir_list{i})
    end
end

filen = ['ART',date,'Time',num2str(tstamp(4)),num2str(tstamp(5)),'.txt'];
logname = fullfile(Data.log_dir, filen);
loghand = fopen(logname,'wt');
fprintf(loghand,filen);
fprintf(loghand,'\n Subjects');




for i = 1:numel(subjects)
    Data.Subjects(i).ID = subjects{i}(1:4);
    Data.Subjects(i).artID = subjects{i};
    portion = [];
    if strcmp(subjects(i), '7403')
        lrn_runs = st_lrn_runs;
        mem_runs = st_mem_runs(1:6);
    elseif strcmp(subjects(i), '7404')
        lrn_runs = st_lrn_runs(7:12);
        mem_runs = st_mem_runs;
    elseif strcmp(subjects(i), '7408')
        lrn_runs = st_lrn_runs;
        mem_runs = st_mem_runs;
    elseif strcmp(subjects(i), '7432')
        lrn_runs = horzcat(st_lrn_runs(1:2), st_lrn_runs(4:12));
        mem_runs = st_mem_runs;
    elseif strcmp(subjects(i), '7436')
        lrn_runs = st_lrn_runs(2:12);
        mem_runs = st_mem_runs;
    elseif strcmp(subjects(i), '7443a')
        lrn_runs = st_lrn_runs;
        mem_runs = st_mem_runs;
        portion = [1:6];
    elseif strcmp(subjects(i), '7443b')
        lrn_runs = st_lrn_runs;
        mem_runs = st_mem_runs;
        portion = [7:12];
    elseif strcmp(subjects(i), '7641')
        lrn_runs = horzcat(st_lrn_runs(1:6), st_lrn_runs(8:12));
        mem_runs = st_mem_runs;
    elseif strcmp(subjects(i), '7458')
        lrn_runs = st_lrn_runs;
        mem_runs = st_mem_runs(1:11);
    elseif strcmp(subjects(i), '7561')
        lrn_runs = st_lrn_runs;
        mem_runs = horzcat(st_mem_runs(1), st_mem_runs(3:12));
    elseif strcmp(subjects(i) ,'7726')
        mem_runs = st_mem_runs;
        lrn_runs = horzcat(st_lrn_runs(1:6), st_lrn_runs(8:12));
    elseif strcmp(subjects(i), '7659')
        mem_runs = st_mem_runs(1:6);
        lrn_runs = st_lrn_runs(1:6);
    elseif strcmp(subjects(i), '7719')
        mem_runs = st_mem_runs(1:6);
        lrn_runs = st_lrn_runs(1:6);
    else
        lrn_runs = st_lrn_runs;
        mem_runs = st_mem_runs;
    end
    Data.Subjects(i).lrn_runs = lrn_runs;
    Data.Subjects(i).mem_runs = mem_runs;
    Data.Subjects(i).portion = portion;
   
end


for i = 1:numel(Data.Subjects)
    subject = Data.Subjects(i);
	fprintf(loghand,'\n  %s', subject.ID);
    for j = 1:numel(subject.lrn_runs)
        fprintf(loghand,'%s ', subject.lrn_runs{j});
    end
    fprintf(loghand,'\n');
    for k = 1:numel(subject.mem_runs)
        fprintf(loghand,'%s ', subject.mem_runs{k});
    end
    
end

functions(1).log = 'ks_main_art';
functions(2).log = 'ks_write_swd';
functions(2).log = 'ks_art_batch';


for f=1:length(functions)
    src = fullfile(scriptDir, [functions(f).log '.m']);
    dst = Data.res_dir;
    copyfile(src, dst);
end

dirs(1).log = 'data_dir=/Volumes/LaCie/LaPrivate/soccog/preproc_data_art';
dirs(2).log = 'motion_dir=/Volumes/LaCie/LaPrivate/soccog/preproc_data_art';
dirs(3).log = 'res_dir=/Volumes/LaCie/LaPrivate/soccog/results/mem_1stlev_forart';

for j = 1:length(dirs)
    fprintf(loghand, '%s\n', dirs(j).log)
end

%ks_write_swd(Data, Time)
ks_art_batch(Data, Time)
