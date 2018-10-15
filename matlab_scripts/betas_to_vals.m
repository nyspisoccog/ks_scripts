subjects = {'7404'};
reg_names = {'MSRT*bf(1)'};
root_dir = '/Volumes/LaCie/LaPrivate/soccog/results/feb2017memfirstlev/mem';
out_dir = '/Volumes/LaCie/LaPrivate/soccog/results/feb2017memfirstlev/mem/robust0003';
fname = 'betadata_con3.csv';



roi = ks_betas_to_vals>make_roi(clpos(4).XYZ, 'LBA47',...
    '/Volumes/LaCie/LaPrivate/soccog/results/feb2017memfirstlev/mem/robust0003');

ks_betas_to_vals>write_table(subjects, reg_names, root_dir, out_dir, fname, roi)