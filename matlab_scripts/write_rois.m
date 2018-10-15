function roi = write_rois(data_struct, dir)
    
    addpath(genpath('/Users/katherine/marsbar-0.44/'));
   
    marsbar('on')

    % Set up the SPM defaults
    spm('defaults', 'fmri');

    v = 'vox';
    sp = maroi('classdata', 'spacebase');


    total_voxels = 0;

    for i = 1:length(data_struct)
        sz = size(data_struct(i).XYZ);
        total_voxels = total_voxels + sz(2);
    end

    voxels = zeros(3, 1);

    for i = 1:length(data_struct)
        voxels = horzcat(voxels, data_struct(i).XYZ);
    end

    voxels = voxels(:, 1:end);

    o = maroi_pointlist(struct('XYZ', voxels, 'mat', sp.mat), v);

    lbl = ['clustsize5_p001'];
    o = label(o, lbl);
    o = descrip(o, lbl);
          
    fn = source(o);
    if isempty(fn) 
        fn = maroi('filename', mars_utils('str2fname', label(o)));
    end
    roi_fname = maroi('filename', fn);
   
    try
        varargout = {saveroi(o, roi_fname)};
        mars_rois2img(roi_fname, 'clustsize5_p001.nii', [], 'i')
    catch
        warning([lasterr ' Error saving ROI to file ' roi_fname])
    end
end