function init(clneg_data)

    sz = size(clneg_data);
    len = sz(2);

    for i = 1:len
        fprintf(mni_max(clneg_data(i)));
    end
end



function [mni_max] = mni_max(ds_row)
    for i = 1:length(ds_row.XYZmm)
        if ds_row.XYZmm(i) == ds_row.mm_center
            mni_max = ds_row.XYZ(i);
        end
    end   
end