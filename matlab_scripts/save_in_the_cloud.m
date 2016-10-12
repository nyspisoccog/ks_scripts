function saving_in_cloud(X,i)
    save(['/shared/persisted/cloud_rand' num2str(i) '.mat'],'X');
end