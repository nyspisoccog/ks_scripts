clear Data
dbstop if error

script_dir = '/Users/katherine/ks_scripts/matlab_scripts/';
addpath(script_dir);
addpath(genpath('/Users/katherine/spm12'));

tstamp = clock;
time1 = num2str(tstamp(4));
time2 = num2str(tstamp(5));

Time.date = date;
Time.time1 = time1;
Time.time2 = time2;


subjects = {'7404', '7408', '7412', '7414', '7418', '7430', '7432',...
             '7436', '7443', '7453', '7458', '7474', '7477', '7478', '7480',...
             '7498', '7508', '7521', '7533', '7534', '7542', '7558', '7561',...
             '7562', '7575', '7580', '7607',  '7619', '7623', '7638',...
             '7645', '7648', '7649', '7659', '7714', '7719', '7726'};
         





Data.res_dir = '/Volumes/LaCie/LaPrivate/soccog/results/feb2017memfirstlev'
Data.log_dir = [Data.res_dir '/logdir'];
Data.lrn_res_dir = fullfile(Data.res_dir, 'lrn');
Data.mem_res_dir = fullfile(Data.res_dir, 'mem');
Data.lrn_log_dir = fullfile(Data.log_dir, 'lrn'); 
Data.mem_log_dir = fullfile(Data.log_dir, 'mem');  

dir_list = {Data.res_dir, Data.log_dir, Data.mem_res_dir, Data.lrn_res_dir, Data.lrn_log_dir, Data.mem_log_dir};

for i=1:numel(dir_list)
    if ~exist(dir_list{i}, 'dir')
        mkdir(dir_list{i})
    end
end





functions(1).log = 'ks_main_3';
functions(2).log = 'ks_contrasts_multi_mem_followup';
functions(3).log = 'ks_followup_spec_deriv_2ndlev';
functions(4).log = 'ks_robust_spec';



for f=1:length(functions)
    src = fullfile(script_dir, [functions(f).log '.m']);
    dst = Data.res_dir;
    copyfile(src, dst);
end



 








dirs(1).log = ['data_dir=' Data.data_dir];
dirs(2).log = ['art_dir=' Data.art_dir];
dirs(3).log = ['res_dir=' Data.res_dir];


filen = ['Main',date,'Time',num2str(tstamp(4)),num2str(tstamp(5)),'.txt'];
logname = fullfile(Data.log_dir, filen);
loghand = fopen(logname,'wt');
fprintf(loghand,filen);
fprintf(loghand,'\nCONFIGURATION');
fprintf(loghand,'\n Subjects');

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

for j = 1:length(functions)
    fprintf(loghand, '%s\n', functions(j).log)
end

for j = 1:length(dirs)
    fprintf(loghand, '%s\n', dirs(j).log)
end

for l=1:numel(param_list)
    fprintf(loghand, '%s %s\n', [param_list{l}.name, param_list{l}.val]);
end

fclose('all')
