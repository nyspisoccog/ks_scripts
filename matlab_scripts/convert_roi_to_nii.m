addpath('/Users/katherine/marsbar-0.44/');
marsbar('on')
spm('defaults', 'fmri');
    
root_dir = '/Volumes/LaCie/LaPrivate/soccog/results/feb2017memfirstlev/mem/robust0003/'

mars_rois2img([root_dir 'LBA47_roi.mat'], [root_dir 'LBA47_roi.nii'])