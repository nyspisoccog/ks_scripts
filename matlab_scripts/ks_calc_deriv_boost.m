function ks_calc_deriv_boost(Data, Time, p)

spm('Defaults','fMRI');

spm_jobman('initcfg');

clear matlabbatch;

lrn_res_dir = Data.lrn_res_dir;
mem_res_dir = Data.mem_res_dir;
lrn_log_dir = Data.lrn_log_dir; 
mem_log_dir = Data.mem_log_dir;
sess_type = {'mem'};
subjects = Data.Subjects;


for i=1:numel(subjects)
    subject = subjects(i).ID;
    disp(subject)
    for lm = 1:numel(sess_type)
        if strcmp(sess_type{lm}, 'mem')
            logdir = mem_log_dir;
            logname = fullfile(logdir, 'derivboost.txt');
            loghand = fopen(logname,'wt');
            runs = subjects(i).mem_runs;
            resdir = mem_res_dir;
            derivdir = fullfile(resdir, subject, 'derivboost');
            if ~exist(derivdir, 'dir')
                mkdir(derivdir)
            end
            clear SPM
            load(fullfile(resdir, subject, 'SPM.mat'));
            SPM.swd = derivdir;
            save(fullfile(derivdir, 'SPM.mat'), 'SPM');
            copyfile(fullfile(resdir, subject, 'ResMS.nii'),derivdir);  
        end
        fprintf(loghand, [subject, '\n']);
        SPM = load(fullfile(resdir, subject, 'SPM.mat'));
        names = SPM.SPM.xX.name;
        numreg = 0;
        for numname = 1:length(names)
            pwr = floor(log10(numname));
            if isempty(strfind(names{numname}, 'bf(1)')) ~= 1
                numreg = numreg + 1;
                leadzeros1 = repmat('0',1, (3-pwr));
                if p>=2
                    leadzeros2 = repmat('0',1, (3-floor(log10(numname +1))));
                    betasets(numreg).bf1 = ['beta_' leadzeros1 int2str(numname) '.nii'];
                    betasets(numreg).bf2 = ['beta_' leadzeros2 int2str(numname + 1) '.nii'];
                end
                if p > 2
                    leadzeros3 = repmat('0',1, (3-floor(log10(numname + 2))));
                    betasets(numreg).bf3 = ['beta_' leadzeros3 int2str(numname + 2) '.nii'];
                end
            else
                leadzeros = repmat('0', 1, (3-floor(log10(numname))));
                beta_name = ['beta_' leadzeros int2str(numname) '.nii'];
                copyfile(fullfile(resdir, subject, beta_name), derivdir);
            end
        end
        
        for numcalc=1:numreg
            bf1_path = fullfile(resdir, subject, betasets(numcalc).bf1);
            bf2_path = fullfile(resdir,  subject, betasets(numcalc).bf2);
            copyfile(bf2_path, fullfile(derivdir, betasets(numcalc).bf2))
            if p==2
                input = {bf1_path, bf2_path};
                expression = 'sign(i1).*sqrt(i1.^2 + i2.^2)';
            end
            if p==3
                bf3_path = fullfile(resdir, subject, betasets(numcalc).bf3);
                input = {bf1_path; bf2_path; bf3_path};
                expression = 'sign(i1).*sqrt(i1.^2 + i2.^2 + i3.^2)';
                copyfile(bf3_path, fullfile(derivdir, betasets(numcalc).bf3))
            end
            matlabbatch{numcalc}.spm.util.imcalc.input = input;
            matlabbatch{numcalc}.spm.util.imcalc.output = betasets(numcalc).bf1;
            matlabbatch{numcalc}.spm.util.imcalc.outdir = {derivdir};
            matlabbatch{numcalc}.spm.util.imcalc.expression = expression;
            matlabbatch{numcalc}.spm.util.imcalc.var = struct('name', {}, 'value', {});
            matlabbatch{numcalc}.spm.util.imcalc.options.dmtx = 0;
            matlabbatch{numcalc}.spm.util.imcalc.options.mask = 0;
            matlabbatch{numcalc}.spm.util.imcalc.options.interp = 1;
            matlabbatch{numcalc}.spm.util.imcalc.options.dtype = 16;
        end

        save(fullfile(logdir, [subject 'derivboost.mat']), 'matlabbatch');
        out = spm_jobman('run',matlabbatch);
        end
        clear matlabbatch out 
    end
    clear subject
end
