function [] = finish_SPM(old_DYLD_LIBRARY_PATH, old_PATH)
% append to the DYLD_LIBRARY_PATH
disp('old_DYLD_LIBRARY_PATH is')
disp(old_DYLD_LIBRARY_PATH)
disp(' ')

disp('old_PATH is')
disp(old_PATH)
disp(' ')
setenv('DYLD_LIBRARY_PATH', old_DYLD_LIBRARY_PATH);
% add to the MATLAB path
addpath(old_PATH);