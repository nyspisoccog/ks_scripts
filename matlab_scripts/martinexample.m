%params for sim and fitting
TR = 2;   % repetition time (sec)
n = 200;  % time points measured (for simulation) must be multiple of 10
T = 30;   % duration of HRF to estimate (seconds)
nconds = 2; % num conditions
nevents = 8; % events per condition

% Create fake data
h = spm_hrf(TR);
y = zeros(n, 1);

% onsets - indicator
Condition = {};
for i = 1:nconds
    Condition{i} = zeros(n,1);
    wh = randperm(n);
    Condition{i}(wh(1:nevents)) = 1;

    ytmp{i} =  conv(Condition{i}, h);
    ytmp{i} = ytmp{i}(1:n);
end

y = sum(cat(2, ytmp{:}), 2);

dat = fmri_data('VMPFC_mask_neurosynth.img');  % AVAILABLE ON WIKI IN MASK GALLERY
dat = threshold(dat, [5 Inf], 'raw-between');

v = size(dat.dat, 1); % voxels in mask
dat.dat = repmat(y',v, 1) + .1 * randn(v, n);

% Fit data - estimate HRFs across the brain mask
[params_obj hrf_obj] = hrf_fit(dat,TR, Condition, T,'FIR', 1);

hrf = fmri_data('HRF_timecourse_cond0001.img');
hrf = remove_empty(hrf);
create_figure('hrfs', 1, 2); 
plot(hrf.dat');
title('Condition 1')
hrf = fmri_data('HRF_timecourse_cond0002.img');
hrf = remove_empty(hrf);
subplot(1, 2, 2);
plot(hrf.dat');
title('Condition 2')