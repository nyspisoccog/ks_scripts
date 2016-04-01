clear Data
dbstop if error

%scriptDir = '/home/katie/ks_scripts/matlab_scripts/';
%scriptDir = '/Volumes/LaCie/ks_scripts/matlab_scripts/';
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
            '7542', '7558', '7561', '7562a', '7562b', '7575', '7580', '7607',...
            '7619', '7623', '7638','7641', '7645', '7648', '7649',...
            '7659', '7714', '7719', '7726'};


st_lrn_runs = {...
  'run1L1', 'run1L2', 'run1L3', 'run1L4', 'run1L5', 'run1L6',...
  'run2L1', 'run2L2', 'run2L3', 'run2L4','run2L5', 'run2L6'...
  }



st_mem_runs = {...
  'run1M1', 'run1M2', 'run1M3', 'run1M4', 'run1M5', 'run1M6',...
  'run2M1', 'run2M2', 'run2M3', 'run2M4','run2M5', 'run2M6'...
  }

standard_slices = {...
    34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34,...
    34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34,...
    };


Data.data_path = '/Volumes/LaCie/LaPrivate/soccog/preproc_data_art';
Data.motion_dir = '/Volumes/LaCie/LaPrivate/soccog/preproc_data_art';

Data.res_dir = ['/Volumes/LaCie/LaPrivate/soccog/results/frstv2nd_fixmt_newpreproc'];
%Data.res_dir = ['/Volumes/LaCie/LaPrivate/soccog/results/newpp_fixmt_4thresh'];
%Data.res_dir = ['/Volumes/LaCie/LaPrivate/soccog/results/mixedblockevent'];

Data.log_dir = [Data.res_dir '/logdir'];
Data.lrn_res_dir = fullfile(Data.res_dir, 'lrn');
Data.mem_res_dir = fullfile(Data.res_dir, 'mem');
Data.lrn_log_dir = fullfile(Data.log_dir, 'lrn'); 
Data.mem_log_dir = fullfile(Data.log_dir, 'mem');  
Data.bp_ons_dir = '/Volumes/LaCie/LaPrivate/soccog/onsets/noMV_noval_1stv2nd_wbp/bp';
Data.lrn_ons_dir = '/Volumes/LaCie/LaPrivate/soccog/onsets/noMV_noval_1stv2nd_wbp/lrn';
Data.mem_ons_dir = '/Volumes/LaCie/LaPrivate/soccog/onsets/noMV_noval_1stv2nd_wbp/mem';
Data.sub_list = subjects;

dir_list = {Data.res_dir, Data.log_dir, Data.mem_res_dir, Data.lrn_res_dir, Data.lrn_log_dir, Data.mem_log_dir};

for i=1:numel(dir_list)
    if ~exist(dir_list{i}, 'dir')
        mkdir(dir_list{i})
    end
end

filen = ['FirstLev',date,'Time',num2str(tstamp(4)),num2str(tstamp(5)),'.txt'];
logname = fullfile(Data.log_dir, filen);
loghand = fopen(logname,'wt');
fprintf(loghand,filen);
fprintf(loghand,'\nCONFIGURATION');
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
    elseif strcmp(subjects(i), '7432')
        lrn_runs = horzcat(st_lrn_runs(1:2), st_lrn_runs(4:12));
        mem_runs = st_mem_runs;
    elseif strcmp(subjects(i), '7436')
        lrn_runs = st_lrn_runs(2:12);%nec. if you're doing first half v. second half analyses
        mem_runs = st_mem_runs;
    elseif strcmp(subjects(i), '7641')
        lrn_runs = horzcat(st_lrn_runs(1:6), st_lrn_runs(8:12));%only one trial recorded for 2L1
        mem_runs = st_mem_runs;
    elseif strcmp(subjects(i), '7458')
        lrn_runs = st_lrn_runs;
        mem_runs = st_mem_runs(1:11);
    elseif strcmp(subjects(i), '7443a')
        lrn_runs = st_lrn_runs;
        portion = [1:6];
    elseif strcmp(subjects(i), '7443b')
        lrn_runs = st_lrn_runs;
        portion = [7:12];
    elseif strcmp(subjects(i), '7562a')
        lrn_runs = st_lrn_runs;
        portion = [1:6];
    elseif strcmp(subjects(i), '7562b')
        lrn_runs = st_lrn_runs;
        portion = [7:12];
    elseif strcmp(subjects(i), '7561')
        lrn_runs = st_lrn_runs;
        mem_runs = horzcat(st_mem_runs(1), st_mem_runs(3:12));
    elseif strcmp(subjects(i) ,'7726')
        mem_runs = st_mem_runs;
        lrn_runs = horzcat(st_lrn_runs(1:6), st_lrn_runs(8:12));
    elseif strcmp(subjects(i), '7659')
        mem_runs = st_mem_runs;
        lrn_runs = st_lrn_runs(1:6);
    elseif strcmp(subjects(i), '7719')
        mem_runs = st_mem_runs;
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


functions(1).log = 'ks_art_batch';




dirs(1).log = 'data_path=/Volumes/LaCie/LaPrivate/soccog/preproc_data_art';
dirs(2).log = 'motion_dir=/Volumes/LaCie/LaPrivate/soccog/preproc_data_art';
dirs(3).log = 'res_dir=/Volumes/LaCie/LaPrivate/soccog/results/frstv2nd_fixmt_newpreproc';

for j = 1:length(dirs)
    fprintf(loghand, '%s\n', dirs(j).log)
end

ks_art_batch(Data, Time)
% 
% for j = 1:length(dirs)
%     fprintf(loghand, '%s\n', dirs(j).log)
% end
% 
% 
% for j = 1:length(functions)
%     fprintf(loghand, '%s\n', functions(j).log)
% end
% 
% 
% for i = 1:length(Data.Subjects)
%     if strcmp(Data.Subjects(i).ID, '7443')
%         Data.Subjects(i).lrn_runs = st_lrn_runs(7:12);
%         ind = i;
%     end
% end
% 
% dirs(3).log = 'res_dir=/Volumes/LaCie/LaPrivate/soccog/results/frstv2nd_fixmt_newpreproc/lrn/art_7443_partII/';
% 
% Data7443 = Data;
% Data7443.Subjects = Data.Subjects(ind);
% 
% ks_art_batch(Data7443, Time);
% 
% for j = 1:length(dirs)
%     fprintf(loghand, '%s\n', dirs(j).log)
% end
% 
% 
% for j = 1:length(functions)
%     fprintf(loghand, '%s\n', functions(j).log)
% end
% 
% 
% 
% for i = 1:length(Data.Subjects)
%     if strcmp(Data.Subjects(i).ID, '7562')
%         Data.Subjects(i).lrn_runs = st_lrn_runs(7:12);
%         ind = i;
%     end
% end
% 
% dirs(3).log = 'res_dir=/Volumes/LaCie/LaPrivate/soccog/results/frstv2nd_fixmt_newpreproc/lrn/art_7562_partII/';
% 
% Data7562 = Data;
% Data7562.Subjects = Data.Subjects(ind);
% 
% ks_art_batch(Data7562, Time);
% 
% for j = 1:length(dirs)
%     fprintf(loghand, '%s\n', dirs(j).log)
% end
% 
% 
% for j = 1:length(functions)
%     fprintf(loghand, '%s\n', functions(j).log)
% end