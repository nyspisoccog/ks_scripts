

marsbar('on')

% Set up the SPM defaults
spm('defaults', 'fmri');

v = 'vox';
sp = maroi('classdata', 'spacebase');


voxels =  clpos(4).XYZ;

o = maroi_pointlist(struct('XYZ', voxels, 'mat', sp.mat), v);

lbl = ['contrast3_clustsize5_p001_LBA47'];
o = label(o, lbl);
o = descrip(o, lbl);
          
fn = source(o);
if isempty(fn) 
    fn = maroi('filename', mars_utils('str2fname', label(o)));
end
roi_fname = maroi('filename', fn);
try
   varargout = {saveroi(o, roi_fname)};
catch
   warning([lasterr ' Error saving ROI to file ' roi_fname])
end
        





