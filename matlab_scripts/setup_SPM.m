function [old_DYLD_LIBRARY_PATH, old_PATH] = setup_SPM(dirroot)
% get the paths to all subfolders
new_path = genpath(dirroot);

disp('new_path is ')
disp(new_path)
disp(' ')

% get the current DYLD_LIBRARY_PATH
old_DYLD_LIBRARY_PATH = strtrim(getenv('DYLD_LIBRARY_PATH'));
disp('old_DYLD_LIBRARY_PATH is')
disp(old_DYLD_LIBRARY_PATH)
disp(' ')
old_PATH = path();
disp('old_PATH is')
disp(old_PATH)
disp(' ')
% construct the string to append to the LD_LIBRARY_PATH
suffix = strrep(new_path, ';', ':');
suffix(end) = [];
disp('suffix is')
disp(suffix)
disp(' ')
if ~isempty(old_DYLD_LIBRARY_PATH)
    suffix = [':' suffix];
    disp('~isempty is executing')
end
disp('suffix is')
disp(suffix)
disp(' ')
% append to the DYLD_LIBRARY_PATH
setenv('DYLD_LIBRARY_PATH', [old_DYLD_LIBRARY_PATH suffix]);
% add to the MATLAB path
disp('new_path is')
disp(new_path)
disp(' ')
addpath(new_path);