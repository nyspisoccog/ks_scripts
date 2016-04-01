function ks_conn_batch(Data)
% example batch process for DENOISING. Edit the fields below
% This example performs the following Denoising steps:
% removal of confounding effects based on White matter / CSF CompCor, 3
% dimensions each, with additional removal of one task condition (named "rest"),
% and estimated subject motion parameters (named "motion"), and band-pass
% filtering

%% BATCH INFORMATION (edit this section)
addpath(genpath('/Users/katherine/conn'));
rootfolder=Data.lrn_res_dir;


for n1=1:length(Data.Subjects)
    subject = Data.Subjects(n1).ID;
    clear batch;
    batch.filename=...                   % conn_* project file to be modified
        fullfile(rootfolder, subject, 'conn_denoise.mat');
    batch.Setup.spmfiles = fullfile(rootfolder, subject, 'SPM.mat');
    batch.Setup.outputfiles(1) = 1;
    batch.Setup.outputfiles(2) = 1;
    batch.Setup.done = 1;
    % names of temporal (first-level) covariates

%% DENOISING INFORMATION (edit this section to change the default values)
    batch.Denoising.filter=[.00391, 100];           % frequency filter (band-pass values, in Hz)
    batch.Denoising.confounds.names=...          % Effects to be included as confounds (cell array of effect names, effect names can be first-level covariate names, condition names, or noise ROI names)
    {'White Matter','CSF','SPM covariates', 'Effect of button_press'};

    batch.Denoising.done=1;
    batch.Denoising.overwrite='Yes';             % overwrite existing results if they exist (set to 'No' if you want to skip Denoising steps for subjects/ROIs already analyzed)    
    conn_batch(batch);
end
