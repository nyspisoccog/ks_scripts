function save_clusters_as_rois(name_list, data_structure)

marsbar('on')

% Set up the SPM defaults
spm('defaults', 'fmri');

v = 'vox';
sp = maroi('classdata', 'spacebase');
sz = size(data_structure);

for i = 1:sz(2)
    voxels =  data_structure(i).XYZ;
    o = maroi_pointlist(struct('XYZ', voxels, 'mat', sp.mat), v);
    lbl = name_list(i);
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

end
        
end