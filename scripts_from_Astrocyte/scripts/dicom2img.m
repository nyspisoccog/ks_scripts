

dirtxt = fopen('/media/katie/SocCog/dirlist.txt');
dircel = textscan(dirtxt, '%s', 'delimiter', ',');
fclose(dirtxt);




for i = 1:length(dircel{1})
    if rem(i,2) == 0
        parent = dircel{1}{i};
        display(parent)
        files = spm_select('FPList', parent, '\.dcm');
        spm_defaults;
        hdr = spm_dicom_headers(files)
        cd(parent)
        spm_dicom_convert(hdr)
    end 
  
end


