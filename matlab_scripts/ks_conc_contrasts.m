
function ks_conc_contrasts(Data, Time)

addpath(genpath('/Users/katherine/CanlabCore-Master'));
addpath(genpath('/Users/katherine/spm12'));

data_path = Data.data_path;
res_dir = Data.lrn_res_dir;
logdir = Data.lrn_log_dir

sess_type = {'lrn'};
subjects = Data.Subjects;
delimiter = '\t';
 
for nsub=1:length(subjects)
    subject = subjects(nsub);
    clear Params
    fname = fullfile(res_dir, subject.ID, 'names.txt');
    fID = fopen(fname, 'r');
    formatSpec = '%s';
    names_array = textscan(fID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
    names_array = names_array{1, 1};
    for nnames = 1:length(names_array)
        if nnames < 10 leadzeros = '000'; else leadzeros = '00'; end;
        if strcmp(names_array{nnames}, 'LYIF') 
            Params.LYIF(1).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,1'];
            Params.LYIF(2).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,2'];
            Params.LYIF(3).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,3'];
        elseif strcmp(names_array(nnames), 'LYIS')
            Params.LYIS(1).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,1'];
            Params.LYIS(2).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,2'];
            Params.LYIS(3).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,3'];
        elseif strcmp(names_array(nnames), 'LSIF')
            Params.LSIF(1).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,1'];
            Params.LSIF(2).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,2'];
            Params.LSIF(3).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,3'];
        elseif strcmp(names_array(nnames), 'LSIS')
            Params.LSIS(1).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,1'];
            Params.LSIS(2).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,2'];
            Params.LSIS(3).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,3'];
        elseif strcmp(names_array(nnames), 'LNIF')
            Params.LNIF(1).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,1'];
            Params.LNIF(2).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,2'];
            Params.LNIF(3).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,3'];
        elseif strcmp(names_array(nnames), 'LNIS')
            Params.LNIS(1).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,1'];
            Params.LNIS(2).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,2'];
            Params.LNIS(3).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,3'];
        elseif strcmp(names_array(nnames), 'LYRF') 
            Params.LYRF(1).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,1'];
            Params.LYRF(2).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,2'];
            Params.LYRF(3).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,3'];
        elseif strcmp(names_array(nnames), 'LYRS')
            Params.LYRS(1).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,1'];
            Params.LYRS(2).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,2'];
            Params.LYRS(3).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,3'];
        elseif strcmp(names_array(nnames), 'LSRF')
            Params.LSRF(1).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,1'];
            Params.LSRF(2).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,2'];
            Params.LSRF(3).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,3'];
        elseif strcmp(names_array(nnames), 'LSRS')
            Params.LSRS(1).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,1'];
            Params.LSRS(2).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,2'];
            Params.LSRS(3).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,3'];
        elseif strcmp(names_array(nnames), 'LNRF')
            Params.LNRF(1).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,1'];
            Params.LNRF(2).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,2'];
            Params.LNRF(3).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,3'];
        elseif strcmp(names_array(nnames), 'LNRS')
            Params.LNRS(1).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,1'];
            Params.LNRS(2).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,2'];
            Params.LNRS(3).fname = ['HRF_params_cond' leadzeros num2str(nnames) '.img,3'];
        end 
    end
    
    matlabbatch{1}.spm.util.imcalc.input = {
                                        fullfile(res_dir, subject.ID, Params.LSRS(1).fname);
                                        fullfile(res_dir, subject.ID, Params.LSIS(1).fname);
                                        fullfile(res_dir, subject.ID, Params.LYRS(1).fname);
                                        fullfile(res_dir, subject.ID, Params.LYIS(1).fname);
                                        fullfile(res_dir, subject.ID, Params.LSRF(1).fname);
                                        fullfile(res_dir, subject.ID, Params.LSIF(1).fname);
                                        fullfile(res_dir, subject.ID, Params.LYRF(1).fname);
                                        fullfile(res_dir, subject.ID, Params.LYIF(1).fname);
                                        };
    matlabbatch{1}.spm.util.imcalc.output = 'SvY2-SvY1';
    matlabbatch{1}.spm.util.imcalc.outdir = {fullfile(res_dir, subject.ID)};
    matlabbatch{1}.spm.util.imcalc.expression = '((i1 - i2)-(i3 - i4))-((i5 - i6)-(i7 - i8))';
    matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.mask = 0;
    matlabbatch{1}.spm.util.imcalc.options.interp = 1;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
    matlabbatch{2}.spm.util.imcalc.input = {
                                        fullfile(res_dir, subject.ID, Params.LSRS(2).fname);
                                        fullfile(res_dir, subject.ID, Params.LSIS(2).fname);
                                        fullfile(res_dir, subject.ID, Params.LYRS(2).fname);
                                        fullfile(res_dir, subject.ID, Params.LYIS(2).fname);
                                        fullfile(res_dir, subject.ID, Params.LSRF(2).fname);
                                        fullfile(res_dir, subject.ID, Params.LSIF(2).fname);
                                        fullfile(res_dir, subject.ID, Params.LYRF(2).fname);
                                        fullfile(res_dir, subject.ID, Params.LYIF(2).fname);
                                        };
    matlabbatch{2}.spm.util.imcalc.output = 'SvY2-SvY1timetopeak';
    matlabbatch{2}.spm.util.imcalc.outdir = {fullfile(res_dir, subject.ID)};
    matlabbatch{2}.spm.util.imcalc.expression = '((i1 - i2)-(i3 - i4))-((i5 - i6)-(i7 - i8))';
    matlabbatch{2}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{2}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{2}.spm.util.imcalc.options.mask = 0;
    matlabbatch{2}.spm.util.imcalc.options.interp = 1;
    matlabbatch{2}.spm.util.imcalc.options.dtype = 4;  
    matlabbatch{3}.spm.util.imcalc.input = {
                                        fullfile(res_dir, subject.ID, Params.LSRS(3).fname);
                                        fullfile(res_dir, subject.ID, Params.LSIS(3).fname);
                                        fullfile(res_dir, subject.ID, Params.LYRS(3).fname);
                                        fullfile(res_dir, subject.ID, Params.LYIS(3).fname);
                                        fullfile(res_dir, subject.ID, Params.LSRF(3).fname);
                                        fullfile(res_dir, subject.ID, Params.LSIF(3).fname);
                                        fullfile(res_dir, subject.ID, Params.LYRF(3).fname);
                                        fullfile(res_dir, subject.ID, Params.LYIF(3).fname);
                                        };
    matlabbatch{3}.spm.util.imcalc.output = 'SvY2-SvY1width';
    matlabbatch{3}.spm.util.imcalc.outdir = {fullfile(res_dir, subject.ID)};
    matlabbatch{3}.spm.util.imcalc.expression = '((i1 - i2)-(i3 - i4))-((i5 - i6)-(i7 - i8))';
    matlabbatch{3}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{3}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{3}.spm.util.imcalc.options.mask = 0;
    matlabbatch{3}.spm.util.imcalc.options.interp = 1;
    matlabbatch{3}.spm.util.imcalc.options.dtype = 4; 
    matlabbatch{4}.spm.util.imcalc.input = {
                                        fullfile(res_dir, subject.ID, Params.LSRS(1).fname);
                                        fullfile(res_dir, subject.ID, Params.LSIS(1).fname);
                                        fullfile(res_dir, subject.ID, Params.LYRS(1).fname);
                                        fullfile(res_dir, subject.ID, Params.LYIS(1).fname);
                                        };
    matlabbatch{4}.spm.util.imcalc.output = 'SvYsecH';
    matlabbatch{4}.spm.util.imcalc.outdir = {fullfile(res_dir, subject.ID)};
    matlabbatch{4}.spm.util.imcalc.expression = '((i1 - i2)-(i3 - i4))';
    matlabbatch{4}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{4}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{4}.spm.util.imcalc.options.mask = 0;
    matlabbatch{4}.spm.util.imcalc.options.interp = 1;
    matlabbatch{4}.spm.util.imcalc.options.dtype = 4;
    matlabbatch{5}.spm.util.imcalc.input = {
        fullfile(res_dir, subject.ID, Params.LSRS(2).fname);
        fullfile(res_dir, subject.ID, Params.LSIS(2).fname);
        fullfile(res_dir, subject.ID, Params.LYRS(2).fname);
        fullfile(res_dir, subject.ID, Params.LYIS(2).fname);
    };
    matlabbatch{5}.spm.util.imcalc.output = 'SvYsecT';
    matlabbatch{5}.spm.util.imcalc.outdir = {fullfile(res_dir, subject.ID)};
    matlabbatch{5}.spm.util.imcalc.expression = '((i1 - i2)-(i3 - i4))';
    matlabbatch{5}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{5}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{5}.spm.util.imcalc.options.mask = 0;
    matlabbatch{5}.spm.util.imcalc.options.interp = 1;
    matlabbatch{5}.spm.util.imcalc.options.dtype = 4;
    matlabbatch{6}.spm.util.imcalc.input = {
        fullfile(res_dir, subject.ID, Params.LSRS(3).fname);
        fullfile(res_dir, subject.ID, Params.LSIS(3).fname);
        fullfile(res_dir, subject.ID, Params.LYRS(3).fname);
        fullfile(res_dir, subject.ID, Params.LYIS(3).fname);
    };
    matlabbatch{6}.spm.util.imcalc.output = 'SvYsecW';
    matlabbatch{6}.spm.util.imcalc.outdir = {fullfile(res_dir, subject.ID)};
    matlabbatch{6}.spm.util.imcalc.expression = '((i1 - i2)-(i3 - i4))';
    matlabbatch{6}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{6}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{6}.spm.util.imcalc.options.mask = 0;
    matlabbatch{6}.spm.util.imcalc.options.interp = 1;
    matlabbatch{6}.spm.util.imcalc.options.dtype = 4;
    matlabbatch{7}.spm.util.imcalc.input = {
        fullfile(res_dir, subject.ID, Params.LSRS(1).fname);
        fullfile(res_dir, subject.ID, Params.LSIS(1).fname);
        fullfile(res_dir, subject.ID, Params.LNRS(1).fname);
        fullfile(res_dir, subject.ID, Params.LNIS(1).fname);
    };
    matlabbatch{7}.spm.util.imcalc.output = 'SvNsecH';
    matlabbatch{7}.spm.util.imcalc.outdir = {fullfile(res_dir, subject.ID)};
    matlabbatch{7}.spm.util.imcalc.expression = '((i1 - i2)-(i3 - i4))';
    matlabbatch{7}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{7}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{7}.spm.util.imcalc.options.mask = 0;
    matlabbatch{7}.spm.util.imcalc.options.interp = 1;
    matlabbatch{7}.spm.util.imcalc.options.dtype = 4;
    matlabbatch{8}.spm.util.imcalc.input = {
        fullfile(res_dir, subject.ID, Params.LSRS(2).fname);
        fullfile(res_dir, subject.ID, Params.LSIS(2).fname);
        fullfile(res_dir, subject.ID, Params.LNRS(2).fname);
        fullfile(res_dir, subject.ID, Params.LNIS(2).fname);
    };
    matlabbatch{8}.spm.util.imcalc.output = 'SvNsecT';
    matlabbatch{8}.spm.util.imcalc.outdir = {fullfile(res_dir, subject.ID)};
    matlabbatch{8}.spm.util.imcalc.expression = '((i1 - i2)-(i3 - i4))';
    matlabbatch{8}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{8}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{8}.spm.util.imcalc.options.mask = 0;
    matlabbatch{8}.spm.util.imcalc.options.interp = 1;
    matlabbatch{8}.spm.util.imcalc.options.dtype = 4;
    matlabbatch{9}.spm.util.imcalc.input = {
        fullfile(res_dir, subject.ID, Params.LSRS(3).fname);
        fullfile(res_dir, subject.ID, Params.LSIS(3).fname);
        fullfile(res_dir, subject.ID, Params.LNRS(3).fname);
        fullfile(res_dir, subject.ID, Params.LNIS(3).fname);
    };
    matlabbatch{9}.spm.util.imcalc.output = 'SvNsecW';
    matlabbatch{9}.spm.util.imcalc.outdir = {fullfile(res_dir, subject.ID)};
    matlabbatch{9}.spm.util.imcalc.expression = '((i1 - i2)-(i3 - i4))';
    matlabbatch{9}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{9}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{9}.spm.util.imcalc.options.mask = 0;
    matlabbatch{9}.spm.util.imcalc.options.interp = 1;
    matlabbatch{9}.spm.util.imcalc.options.dtype = 4;
    matlabbatch{3}.spm.util.imcalc.input = {
        fullfile(res_dir, subject.ID, Params.LSRS(3).fname);
        fullfile(res_dir, subject.ID, Params.LSIS(3).fname);
        fullfile(res_dir, subject.ID, Params.LYRS(3).fname);
        fullfile(res_dir, subject.ID, Params.LYIS(3).fname);
        fullfile(res_dir, subject.ID, Params.LSRF(3).fname);
        fullfile(res_dir, subject.ID, Params.LSIF(3).fname);
        fullfile(res_dir, subject.ID, Params.LYRF(3).fname);
        fullfile(res_dir, subject.ID, Params.LYIF(3).fname);
    };
    matlabbatch{3}.spm.util.imcalc.output = 'SvY2-SvY1width';
    matlabbatch{3}.spm.util.imcalc.outdir = {fullfile(res_dir, subject.ID)};
    matlabbatch{3}.spm.util.imcalc.expression = '((i1 - i2)-(i3 - i4))-((i5 - i6)-(i7 - i8))';
    matlabbatch{3}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{3}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{3}.spm.util.imcalc.options.mask = 0;
    matlabbatch{3}.spm.util.imcalc.options.interp = 1;
    matlabbatch{3}.spm.util.imcalc.options.dtype = 4;
    save(fullfile(logdir, [subject.ID '_firstlevcontrast.mat']), 'matlabbatch');
    output = spm_jobman('run', matlabbatch);
    end
end
