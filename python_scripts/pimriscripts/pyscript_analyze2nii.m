fprintf(1,'Executing %s at %s:\n',mfilename,datestr(now));
ver,
try,V = spm_vol('/media/truecrypt1/SocCog/tmp1/run1L2/f000001.img');
[Y, XYZ] = spm_read_vols(V);
V.fname = '/home/katie/ks_scripts/python_scripts/pimriscripts/f000001.nii';
spm_write_vol(V, Y);

,catch ME,
fprintf(2,'MATLAB code threw an exception:\n');
fprintf(2,'%s\n',ME.message);
if length(ME.stack) ~= 0, fprintf(2,'File:%s\nName:%s\nLine:%d\n',ME.stack.file,ME.stack.name,ME.stack.line);, end;
end;