function dicom_get_info_from_header(dcm_files,file_name)
% 
% Get some information from the DICOM header and write to an ASCII file
% 
% 
%USAGE
%-----
% dicom_get_info_from_header
% dicom_get_info_from_header(dcm_files)
% dicom_get_info_from_header(dcm_files,file_name)
% 
% 
%INPUT
%-----
% DICOM_GET_INFO_FROM_HEADER by itself will ask for the DICOM files 
% - DCM_FILES: list of DICOM files (cell array)
% - FILE_NAME: output file name. Default: 'dicom_hdr_info'
% 
% 
%OUTPUT
%------
% FILE_NAME with (if it is not given, 'dicom_hdr_info' in the same folder
% as the first DICOM file):
% - file directory
% - file name
% - file size (kB)
% - subject name
% - subject ID
% - gender
% - birthday
% - acquisition date
% - age (in years)
% - scan dimensions
% 
% 
% N.B.:
% - Tested with DICOM files from Philips Achieva 3T R2.6
% - Requires the Image Processing Toolbox

% Guilherme Coco Beltramini (guicoco@gmail.com)
% 2013-Feb-02, 03:29 pm


% Input
%==========================================================================

if nargin<1 % dcm_files were not given
    [dcm_files,fpath] = uigetfile('*.dcm','Add the files (DICOM)','','MultiSelect','on');
    if isequal(dcm_files,0) % clicked Cancel
        return
    end
end

if ischar(dcm_files)
    dcm_files = {dcm_files};
end
if ~iscellstr(dcm_files)
    error('DCM_FILES must be a cell array of strings')
end

if nargin<1 % dcm_files were not given
    if strcmp(fpath(end),filesep)
        fpath(end) = [];
    end
    dcm_files = strcat(fpath,filesep,dcm_files);
end

if nargin>0 % dcm_files were given
    fpath = fileparts(dcm_files{1});
    if isempty(fpath)
        fpath = pwd;
    end
end

if nargin<2 % file_name was not given
    file_name = fullfile(fpath,'dicom_hdr_info');
end


tmp = clock;
disp('-------------------------------------------------------------------')
fprintf('(%.2d:%.2d:%02.0f) Running %s.m...\n',...
    tmp(4),tmp(5),tmp(6),mfilename)


nfiles = size(dcm_files,2); % number of files
if nfiles>1
    fprintf('%d DICOM files\n',nfiles)
else % nfiles=1
    fprintf('%d DICOM file\n',nfiles)
end


% Create file and write header
%==========================================================================
fid = fopen(file_name,'wt');
if fid==-1
    error('Unable to create %s',file_name)
end
fprintf(fid,'Directory\tFile_name\tFile_size_(kB)\tSubj_name\tSubj_ID\tGender\tBirthday\tAcq_date\tAge\tScan_dimensions');


for ii = 1:nfiles % loop for all chosen DICOM files
    
    fprintf('  File %d... ',ii)
    
    % Read DICOM header
    %------------------
    if exist(dcm_files{ii},'file')~=2
        fprintf(' %s not found\n',dcm_files{ii})
        continue
    end
    try
        dinfo = dicominfo(dcm_files{ii});
    catch ME
        warning(ME.identifier,ME.message)
        fprintf(' Skipped\n')
        continue
    end
    
    % Get useful information
    %-----------------------
    [fdir,fname] = fileparts(dinfo.Filename);
    
    % File size
    fsize = dinfo.FileSize/1024;
    
    % Scan dimension
    try
        acqdim = [num2str(dinfo.Width) ',' num2str(dinfo.Height) ',' num2str(dinfo.Private_2001_1018)];
        % dinfo.Width = dinfo.Rows  &  dinfo.Height = dinfo.Columns (all "uint16")
        % dinfo.Private_2001_1018 is of class "int32"
    catch ME
        warning(ME.identifier,ME.message)
        acqdim = 'NaN';
    end
    
    % Acquisiton date
    try
        %acqdate = dinfo.AcquisitionDateTime(1:8); % not all headers have this
        acqdate = dinfo.InstanceCreationDate;
        acqdate = [acqdate(1:4) '-' acqdate(5:6) '-' acqdate(7:8)];
        %acqtime = dinfo.AcquisitionDateTime(9:end);
        %acqtime = [acqtime(1:2) ':' acqtime(3:4) ':' acqtime(5:6)];
    catch ME
        warning(ME.identifier,ME.message)
        acqdim = 'NaN';
    end
    
    % Subject name
    sbjname = dinfo.PatientName.FamilyName;
    
    % ID
    sbjID = dinfo.PatientID;
    
    % Date of birth
    sbjbirth = dinfo.PatientBirthDate;
    sbjbirth = [sbjbirth(1:4) '-' sbjbirth(5:6) '-' sbjbirth(7:8)];
    
    % Sex
    sbjsex = dinfo.PatientSex;
    
    % Age
    sbjage = etime([str2double(acqdate(1:4)) str2double(acqdate(6:7)) ...
        str2double(acqdate(9:10)) 0 0 0],[str2double(sbjbirth(1:4)) ...
        str2double(sbjbirth(6:7)) str2double(sbjbirth(9:10)) 0 0 0])/60/60/24/365.25;
    
    % Write data to file
    %-------------------
    fprintf(fid,'\n%s\t%s\t%.2f\t%s\t%s\t%s\t%s\t%s\t%.1f\t%s',...
        fdir    ,...
        fname   ,...
        fsize   ,...
        sbjname ,...
        sbjID   ,...
        sbjsex  ,...
        sbjbirth,...
        acqdate ,...
        sbjage  ,...
        acqdim);
    
    fprintf('Done!\n')
    
end


% Finish
%==========================================================================
fclose(fid);

tmp = clock;
fprintf('(%.2d:%.2d:%02.0f) %s.m done!\n',...
    tmp(4),tmp(5),tmp(6),mfilename)
disp('-------------------------------------------------------------------')