clear all;close all; clear variables; clear global; clc; 
doTraining = true;
IMDS = imageDatastore('Prewitt_SignalImages\','IncludeSubfolders',true,....
      'FileExtensions','.jpg','LabelSource','foldernames');
%   tbl = countEachLabel(IMDS);
% %Because imds above contains an unequal number of images per category, let's first adjust it,
% %so that the number of images in the training set is balanced.
% 
% minSetCount = 450; % determine the smallest amount of images in a category
% 
% % Use splitEachLabel method to trim the set.
% IMDS = splitEachLabel(IMDS, minSetCount, 'randomize');

% Notice that each set now has exactly the same number of images.
countEachLabel(IMDS)
  example_image = readimage(IMDS,1);                      % read one example image
numChannels = size(example_image,3);                    % get color information
numImageCategories = size(categories(IMDS.Labels),1)
[trainingDS,validationDS] = splitEachLabel(IMDS,0.8,'randomize'); % generate training and validation set
LabelCnt = countEachLabel(IMDS) 
filterSize = [5 5];
    numFilters = 50;

    inputLayer = imageInputLayer(size(example_image));  % input layer with no data augmentation

    middleLayers = [
        % The first convolutional layer has a bank of numFilters filters of size filterSize. A
        % symmetric padding of 4 pixels is added.
        convolution2dLayer(filterSize, numFilters, 'Padding', 0)
        % Next add the ReLU layer:
        reluLayer()
        % Follow it with a max pooling layer that has a 5x5 spatial pooling area
        % and a stride of 2 pixels. This down-samples the data dimensions.
        maxPooling2dLayer(2, 'Stride', 2)
        % % % Repeat the 3 core layers to complete the middle of the network.
        convolution2dLayer([5 5], numFilters*2, 'Padding', 0)
        reluLayer()
        maxPooling2dLayer(2, 'Stride',2)];

    finalLayers = [
        % % Add a fully connected layer with 2 output neurons.
        fullyConnectedLayer(100)
        fullyConnectedLayer(numImageCategories)
        % Add the softmax loss layer and classification layer. The final layers use
        % the output of the fully connected layer to compute the categorical
        % probability distribution over the image classes. During the training
        % process, all the network weights are tuned to minimize the loss over this
        % categorical distribution.
        softmaxLayer
        classificationLayer
        ];

    layers = [
        inputLayer
        middleLayers
        finalLayers
        ];


layers(2).Weights = 0.001 * randn([filterSize numChannels numFilters]);
opts = trainingOptions('sgdm', ...
        'Momentum', 0.9, ...
        'InitialLearnRate', 0.001, ...
        'LearnRateSchedule', 'piecewise', ...
        'LearnRateDropFactor', 0.5, ...
        'LearnRateDropPeriod', 10, ...
        'L2Regularization', 0.004, ...
        'ExecutionEnvironment','gpu',...
         'Plots','training-progress',...
        'MaxEpochs',100, ...
        'MiniBatchSize',64, ...
        'Verbose', true);
    % 'MiniBatchSize' reduced from 128 to 64 because GPU ran out of memory

    % Train a network.
    rng('default');
    rng(123); % random seed
    XONet = trainNetwork(trainingDS,layers,opts);
    save('XONet_newPrewitt_Signal.mat','XONet');
    
    load('XONet_newPrewitt_Signal.mat');
    [labels,~] = classify(XONet,validationDS, 'MiniBatchSize',64);
confMat = confusionmat(validationDS.Labels, labels);
confMat = bsxfun(@rdivide,confMat,sum(confMat,2));
fprintf('Accuracy on validation Data \t\t\t%.4f\n',mean(diag(confMat)))
A=[diag(confMat)];