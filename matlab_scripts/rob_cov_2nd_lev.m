clear all

src = '/media/truecrypt1/SocCog/results/noMV_noval_1stvs2nd_wbp_cov_new/lrn';

dest = '/media/truecrypt1/SocCog/results/rob_cov';

subjects = {'7404', '7408', '7412', '7414', '7418', '7430', '7432',...
            '7436', '7443', '7453', '7458', '7474', '7477', '7478', '7480',...
            '7498', '7508', '7521', '7533', '7534', '7542', '7558', '7561',...
            '7562', '7575', '7580', '7607', '7613', '7619', '7623', '7638',...
            '7641', '7645', '7648', '7649', '7659', '7714', '7719', '7726'};
        
formatSpec = '%f';

delimiter = '\n';

count = 0;
cov_mat = zeros(458, 45);
S_vec = zeros(458, 1);
Y_vec = zeros(458, 1);
N_vec = zeros(458, 1);
for i = 1:length(subjects)
    sub_vec = zeros(458, 1);
    cond_fname = fullfile(src, subjects{i}, 'runs.txt');
    cond_fID = fopen(cond_fname, 'r');
    cond_nums = textscan(cond_fID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false);
    nums = cond_nums{1};
    sub_vec(count+1:count+length(nums)) = repmat(1, 1, length(nums));
    cov_mat(:, 6 + i) = sub_vec;
    for num = 1:length(nums)
        count = count + 1;
        if num < 10
            con_str = 'con_000';
        else
            con_str = 'con_00';
        end
        dir_str = [subjects{i} con_str int2str(num)];
        dst_dir = fullfile(dest, dir_str); 
        if ~exist(dst_dir, 'dir')
            mkdir(dst_dir)
        end
        src_file1 = fullfile(src, subjects{i}, [con_str int2str(num) '.img']);
        src_file2 = fullfile(src, subjects{i}, [con_str int2str(num) '.hdr']);
        disp(src_file1)
        disp(dst_dir)
        %copyfile(src_file1, dst_dir)
        %copyfile(src_file2, dst_dir)
        EXPT.subjects{count} = dst_dir;
        filelist{count} = fullfile(dst_dir, [con_str int2str(num) '.img']);
        if nums(num) == 1
            S_vec(count) = 1;
        elseif nums(num) == 2
            Y_vec(count) = 1;
        elseif nums(num) == 3
            N_vec(count) = 1;
        end
    end
    
end
cov_mat(:, 1:3) = [S_vec, Y_vec, N_vec];

file_list = {'Scovlist.csv'; 'Ycovlist.csv'; 'Ncovlist.csv'};
for j = 1:length(file_list)
    cov_fname = fullfile(src, file_list{j});
    cov_fID = fopen(cov_fname, 'r');
    cov_nums = textscan(cov_fID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false);
    cov_mat(:, j + 3) = cov_nums{1};
end

EXPT.SNPM.P{1} = str2mat(filelist);
connames = {'rob_cov_2nd_lev'}'; connames = str2mat(connames);
EXPT.SNPM.connames = connames;
EXPT.SNPM.connums = 1;

EXPT.cov = cov_mat;

cd(dest)
save EXPT EXPT
EXPT = robfit(EXPT);

   