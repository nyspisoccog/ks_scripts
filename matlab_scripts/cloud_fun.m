% script to demonstrate a workflow where files are saved in the cloud and
% then later loaded in the cloud.

% setup the client data structures
dataSz = 20;
iterationSz = 16;
input = zeros([dataSz, dataSz, iterationSz]);
output = input;

% generate and save the data on the cloud.
parfor i = 1:iterationSz
    X = rand(dataSz);
    input(:, :, i) = X;
    save_in_the_cloud(X, i);
end

% load the data on the cloud and perform some operation.
parfor i = 1:iterationSz
    Y = load_in_the_cloud(i);
    output(:, :, i) = Y .* 2;
end

% display the results on the client.
disp(input);
disp(output);
