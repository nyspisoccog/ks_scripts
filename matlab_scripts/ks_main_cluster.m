clear Data
dbstop if error

soccogroot = '/shared/persisted/for_cluster';
locroot = '/Volumes/LaCie/LaPrivate/soccog';
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
            '7562', '7575', '7580', '7607', '7619', '7623', '7638',...
            '7641', '7645', '7648', '7649', '7659', '7714', '7719', '7726'};

subjects = {'7404'};

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

Data.locroot = locroot;
Data.data_dir = fullfile(soccogroot, 'preproc_data_new');
Data.art_dir = fullfile(soccogroot, 'preproc_data_art');
Data.res_dir = fullfile(soccogroot, 'results/test_cluster');
Data.loc_dir = fullfile(locroot, 'results/test_cluster');

Data.log_dir = fullfile(Data.loc_dir, '/logdir');
Data.lrn_loc_dir = fullfile(Data.loc_dir, 'lrn');
Data.mem_loc_dir = fullfile(Data.loc_dir, 'mem');
Data.lrn_res_dir = fullfile(Data.res_dir, 'lrn');
Data.mem_res_dir = fullfile(Data.res_dir, 'mem');
Data.lrn_log_dir = fullfile(Data.log_dir, 'lrn'); 
Data.mem_log_dir = fullfile(Data.log_dir, 'mem');  
Data.bp_ons_dir = fullfile(soccogroot, 'onsets/fixmem/bp');
Data.lrn_ons_dir = fullfile(soccogroot, 'onsets/fixmem/lrn');
Data.mem_ons_dir = fullfile(soccogroot, 'onsets/fixmem/mem');
Data.sub_list = subjects;
Data.soccogroot=soccogroot;

dir_list = {Data.res_dir, Data.log_dir, Data.mem_res_dir, Data.lrn_res_dir, Data.lrn_log_dir, Data.mem_log_dir};


for i = 1:numel(subjects)
    Data.Subjects(i).ID = char(subjects(i));
    if strcmp(subjects(i), '7403')
        lrn_runs = st_lrn_runs;
        mem_runs = st_mem_runs(1:6);
    elseif strcmp(subjects(i), '7404')
        lrn_runs = st_lrn_runs(7:12);
        mem_runs = st_mem_runs;
    elseif strcmp(subjects(i), '7408')
        lrn_runs = st_lrn_runs;
        mem_runs = st_mem_runs(1:6);
    elseif strcmp(subjects(i), '7432')
        lrn_runs = horzcat(st_lrn_runs(1:2), st_lrn_runs(4:12));
        mem_runs = st_mem_runs;
    elseif strcmp(subjects(i), '7436')
        lrn_runs = st_lrn_runs(2:12);
        mem_runs = st_mem_runs;
    elseif strcmp(subjects(i), '7477')
        lrn_runs = st_lrn_runs;
        mem_runs = st_mem_runs(1:6);
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
   
end





functions(1).log = 'ks_main_3';
functions(2).log = 'ks_spec_params_wout_clust';
functions(3).log = 'ks_conds_estimate_clust';



Parameters.buttonpress.name = 'buttonpress';
Parameters.buttonpress.val = 'y';
Parameters.tmod.name = 'tmod';
Parameters.tmod.val = 'n';
Parameters.timed.name = 'timed';
Parameters.timed.val = 'y';
Parameters.dispersed.name = 'dispersed';
Parameters.dispersed.val = 'y';
Parameters.motion.name = 'motion';
Parameters.motion.val = 'y';
Parameters.ans.name = 'ans';
Parameters.ans.val = 'n';
Parameters.RT.name = 'RT';
Parameters.RT.val = 'n';
 
param_list = {Parameters.buttonpress, Parameters.tmod, Parameters.timed, ...
    Parameters.dispersed, Parameters.motion, Parameters.ans, Parameters.RT};
%

ks_spec_params_wout_clust(Data, Time, Parameters)
ks_conds_estimate_clust(Data, Time);



dirs(1).log = ['data_path=' Data.data_dir];
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
