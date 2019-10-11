clear all;close all; clear variables; clear global; clc;              % clean desk
% A trained network is loaded from disk to save time when running the
% example. Set this flag to true to train the network.
doTraining = true;
numChannels =3;
% load the file data for training the CNN
   % use imageDatastore for loading the two image categories 
  IMDS = imageDatastore('Depth_227x227x3\','IncludeSubfolders',true,....
      'FileExtensions','.jpg','LabelSource','foldernames');
  numImageCategories = size(categories(IMDS.Labels),1)   % get category labels
[trainingDS,validationDS] = splitEachLabel(IMDS,0.5,'randomize'); % generate training and validation set
LabelCnt = countEachLabel(IMDS)  
net = alexnet;
net.Layers
layers = net.Layers(1:end);
layers(end-2) = fullyConnectedLayer(10, 'Name', 'fc8');
layers(end-0) = classificationLayer('Name','coutput');
net1=layers

% Set the network training options
    opts = trainingOptions('sgdm', ...
        'Momentum', 0.9, ...
        'InitialLearnRate', 0.005, ...
        'LearnRateSchedule', 'piecewise', ...
        'LearnRateDropFactor', 0.5, ...
        'LearnRateDropPeriod', 10, ...
        'L2Regularization', 0.004, ...
        'ExecutionEnvironment','gpu',...
         'Plots','training-progress',...
        'MaxEpochs',50, ...
        'MiniBatchSize',128, ...
        'Verbose', true);
    % 'MiniBatchSize' reduced from 128 to 64 because GPU ran out of memory

    % Train a network.
    rng('default');
    rng(123); % random seed
    XONet = trainNetwork(trainingDS,net1, opts);
    save('XONet_depth.mat','XONet');
     load('XONet_depth.mat');
    [labels,~] = classify(XONet,validationDS, 'MiniBatchSize',128)
confMat = confusionmat(validationDS.Labels, labels);
confMat = bsxfun(@rdivide,confMat,sum(confMat,2));
fprintf('Accuracy on validation Data \t\t\t%.4f\n',mean(diag(confMat)))
B_depth=[diag(confMat)];
