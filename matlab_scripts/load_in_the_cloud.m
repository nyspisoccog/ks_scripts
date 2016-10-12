function Y=loading_in_cloud(i)
    load(['/shared/persisted/cloud_rand' num2str(i) '.mat'],'X');
    Y=X;
end