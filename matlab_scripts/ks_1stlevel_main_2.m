clear Data

%scriptDir = '/home/katie/ks_scripts/matlab_scripts/';
scriptDir = '/Volumes/LaCie/ks_scripts/matlab_scripts/';

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
            '7562', '7575', '7580', '7607', '7619', '7623', '7638',...
            '7641', '7645', '7648', '7649', '7659', '7714', '7719', '7726'};

%subjects = {'7659', '7719'};

%subjects = {'7474'};

%subjects = {'7542', '7558', '7561',...
            %'7562', '7575', '7580', '7607', '7619', '7623', '7638',...
            %'7641', '7645', '7648', '7649', '7659', '7714', '7719', '7726'};
        
%subjects = {'7641'}

%subjects = {'7645', '7648', '7649', '7659', '7714', '7719', '7726'}

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

%Data.data_path = '/media/truecrypt1/SocCog/preproc_data/';
Data.data_path = '/Volumes/LaCie/LaPrivate/soccog/preproc_data';
%Data.res_dir = ['/media/truecrypt1/SocCog/results/' date time1 time2]; 
%Data.res_dir = ['/media/truecrypt1/SocCog/test/all_conds/20-Nov-20141728']   %no first half that I ran on cluster
%Data.res_dir = ['/media/truecrypt1/SocCog/test/all_conds/30-Oct-20141358']; first group
%analysis w 1024 hpf
%Data.res_dir = ['/media/truecrypt1/SocCog/test/all_conds/10-Nov-20141711']% first groupanalysis
%Data.res_dir = ['/media/truecrypt1/SocCog/test/noMV_noval_1stvs2nd'];
%Data.res_dir = ['/media/truecrypt1/SocCog/test/noMV_noval_tmod'];
%Data.res_dir = ['/media/truecrypt1/SocCog/results/bp_noMV_noval_1stvs2nd'];
%Data.res_dir = ['/Volumes/Lacie/soccog/results/noMV_noval_1stvs2nd_wbp'];
%Data.res_dir = ['/media/truecrypt1/SocCog/results/bpsanitycheck'];
%Data.res_dir = ['/media/truecrypt1/SocCog/results/noMV_noval_1stvs2nd_wbp_fact'];
%Data.res_dir = ['/media/truecrypt1/SocCog/results/noMV_noval_1stvs2nd_wbp_cov']
%Data.res_dir = ['/media/truecrypt1/SocCog/results/noMV_noval_2nd_cov'];
%Data.res_dir = ['/media/truecrypt1/SocCog/results/noMV_noval_onlycov'];
%Data.res_dir = ['/media/truecrypt1/SocCog/results/poster_fllwupcons_1stv2nd_wbp'];
%Data.res_dir = ['/media/truecrypt1/SocCog/results/TEST'];
%Data.res_dir = ['/media/truecrypt1/SocCog/results/noMV_noval_1stvs2nd_wbp_cov_new'];
%Data.res_dir = ['/media/truecrypt1/SocCog/results/bp_stick_1stv2nd'];
%Data.res_dir = ['/Volumes/LaCie/LaPrivate/soccog/results/new2ndlevforSANS'];
%Data.res_dir = ['/Volumes/LaCie/LaPrivate/soccog/results/new1stlevforSANS'];
Data.res_dir = ['/Volumes/LaCie/LaPrivate/soccog/results/new1stlevtest12'];

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
    Data.Subjects(i).ID = char(subjects(i));
    if strcmp(subjects(i), '7403')
        lrn_runs = st_lrn_runs;
        mem_runs = st_mem_runs(1:6);
    elseif strcmp(subjects(i), '7404')
        lrn_runs = st_lrn_runs(7:12);
        mem_runs = st_mem_runs;
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

for l=1:numel(param_list)
    fprintf(loghand, '%s %s\n', [param_list{l}.name, param_list{l}.val]);
end


%ks_spec_params_func(Data, Time, Parameters);

%ks_conds_estimate_func(Data, Time);

%ks_contrasts_multi_1stvs2nd_func(Data, Time);

%ks_contrasts_multi_1stvs2nd_bpstick_func(Data, Time)

%ks_contrasts_multi_1stvs2nd_cov_func(Data, Time)

%ks_1way_cov_spec_2ndlev(Data, Time)
%ks_1way_onlycov_spec_2ndlev(Data, Time)
%ks_1way_cov_est_2ndlev(Data, Time)

%ks_contrasts_multi_2nd_cov_func(Data, Time)

%ks_contrasts_multi_1stvs2nd_followup_func(Data, Time)


ks_followup_spec_2ndlev(Data, Time, 7)
ks_contrasts_2ndlev_func(Data, Time, 7)
%ks_art_batch(Data,Time)