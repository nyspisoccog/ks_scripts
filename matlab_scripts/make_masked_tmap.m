function make_masked_tmap(dir)

  spm_jobman('initcfg');
  
  clear matlabbatch
  inputfiles = {[dir '/clustsize5_p001.nii']; [dir '/rob_tmap_0001.nii']};

  matlabbatch{1}.spm.util.imcalc.input = inputfiles;
  matlabbatch{1}.spm.util.imcalc.output = 'tmap_sigclusters';
  matlabbatch{1}.spm.util.imcalc.outdir = {dir};
  matlabbatch{1}.spm.util.imcalc.expression = 'i1.*i2';
  matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
  matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
  matlabbatch{1}.spm.util.imcalc.options.mask = 0;
  matlabbatch{1}.spm.util.imcalc.options.interp = 1;
  matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
  output = spm_jobman('run', matlabbatch);
       
end