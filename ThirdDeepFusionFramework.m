clear all;close all; clear variables; clear global; clc; 

%% Inertial DATA FEATURE EXTRACTION

IMDS1 = imageDatastore('CompositeSignalImages\','IncludeSubfolders',true,....
      'FileExtensions','.jpg','LabelSource','foldernames');
  example_image = readimage(IMDS1,1);                      % read one example image
numChannels = size(example_image,3);                    % get color information
numImageCategories = size(categories(IMDS1.Labels),1);
[trainingDS1,validationDS1] = splitEachLabel(IMDS1,0.8,'randomize'); % generate training and validation set
LabelCnt = countEachLabel(IMDS1) ;
load('XONet_CompositeSignalImages.mat');
XONet1=XONet;
XONet1.Layers;
layer = 'fc_1';
featuresTrain1 = activations(XONet1,trainingDS1,layer,'OutputAs','rows');
featuresTest1 = activations(XONet1,validationDS1,layer,'OutputAs','rows');
size(featuresTrain1);
YTrain1 = trainingDS1.Labels;
YTest1 = validationDS1.Labels;

%% DEPTH DATA FEATURE EXTRACTION

numChannels =3;

  IMDS2 = imageDatastore('Depth_227x227x3\','IncludeSubfolders',true,....
      'FileExtensions','.jpg','LabelSource','foldernames');
  numImageCategories = size(categories(IMDS2.Labels),1);   % get category labels
[trainingDS2,validationDS2] = splitEachLabel(IMDS2,0.8,'randomize'); % generate training and validation set
LabelCnt = countEachLabel(IMDS2);
load('XONet_depth.mat');
XONet2=XONet;
XONet2.Layers;
layer = 'fc7';
featuresTrain2 = activations(XONet2,trainingDS2,layer,'OutputAs','rows');
featuresTest2= activations(XONet2,validationDS2,layer,'OutputAs','rows');
size(featuresTrain2);
YTrain2 = trainingDS2.Labels;
YTest2 = validationDS2.Labels;

%% FUSING THE features
 featuresTrain2 = imresize(featuresTrain2,size(featuresTrain1));
 featuresTest2 = imresize(featuresTest2,size(featuresTest1));

[featuresTrain,featuresTest] = Fusion(featuresTrain1,featuresTrain2, featuresTest1, featuresTest2,'sum');

YTrain=[YTrain1;YTrain2];
YTest=[YTest1;YTest2];

%% Fit Image Classifier

 %Fit a multiclass support vector machine (SVM) using fitcecoc (Statistics and Machine Learning Toolbox).

classifier = fitcecoc(featuresTrain,YTrain1);

%Classify Test Images

%Classify the test images using the trained SVM model the features extracted from the test images.

YPred = predict(classifier,featuresTest);
confMat = confusionmat(YTest1,YPred);
accuracy = mean(YPred == YTest1)
confMat = bsxfun(@rdivide,confMat,sum(confMat,2));
