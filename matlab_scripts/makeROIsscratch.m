
marsbar('on')

% Set up the SPM defaults
spm('defaults', 'fmri');

v = 'vox'
sp = maroi('classdata', 'spacebase');
sumfunc = 'mean';
VY = fullfile(resroot,'7726', 'beta_0001.img');
for i=1:length(good_clust_struct)
   o = maroi_pointlist(struct('XYZ', good_clust_struct(i).cluster, 'mat', sp.mat), v); 
   %maybe I want to save this ROI and go back to SPM to get max point? Save
   %ROI as img, use imcalc to get overlap, then find the max of the spm_vol
   o = descrip(o, 'descrip');
   o = label(o, 'label');
   
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
   
   marsY = get_marsy(o, VY, sumfunc, 'v');
   %marsY = get_item_data(o); 
   rno = marsbar('get_region', region_name(marsY));
   Y = region_data(marsY, rno);
   Y = Y{1};
   disp(Y)
end

%make single voxel ROI
XYZ = [6 8 6];
if size(XYZ,1) == 1, XYZ = XYZ'; end
if size(XYZ,1) ~= 3, warning('Need 3xN or Nx3 matrix'); end
v = 'mm';
sp = maroi('classdata', 'spacebase');
o = maroi_pointlist(struct('XYZ', XYZ, 'mat', sp.mat), v);

o = descrip(o, 'descrip');
o = label(o, 'label');

fn = source(o);

%save ROI
if isempty(fn) 
  fn = maroi('filename', mars_utils('str2fname', label(o)));
end

roi_fname = maroi('filename', fn);
  try
    varargout = {saveroi(o, roi_fname)};
  catch
    warning([lasterr ' Error saving ROI to file ' roi_fname])
  end
 
  
%extract ROI data
sumfunc = 'mean';
VY = fullfile(resroot,'7726', 'beta_0001.img');
marsY = get_marsy(o, VY, sumfunc, 'v');
Y = summary_data(marsY);
