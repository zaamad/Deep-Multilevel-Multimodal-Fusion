clear all;close all; clear variables; clear global; clc; 

%% Inertial DATA FEATURE EXTRACTION

IMDS1 = imageDatastore('FullAugmentedSignalImages\','IncludeSubfolders',true,....
      'FileExtensions','.jpg','LabelSource','foldernames');
  example_image = readimage(IMDS1,1);                      % read one example image
numChannels = size(example_image,3);                    % get color information
numImageCategories = size(categories(IMDS1.Labels),1);
[trainingDS1,validationDS1] = splitEachLabel(IMDS1,0.8,'randomize'); % generate training and validation set
LabelCnt = countEachLabel(IMDS1) ;
load('XONet_FullAugmented.mat');
XONet1=XONet;
XONet1.Layers;
layer = 'fc';
featuresTrain1 = activations(XONet1,trainingDS1,layer,'OutputAs','rows');
featuresTest1 = activations(XONet1,validationDS1,layer,'OutputAs','rows');
size(featuresTrain1);
YTrain1 = trainingDS1.Labels;
YTest1 = validationDS1.Labels;

%% Prewitt images feature extraction


  IMDS2 = imageDatastore('Prewitt_SignalImages\','IncludeSubfolders',true,....
      'FileExtensions','.jpg','LabelSource','foldernames');
  numImageCategories = size(categories(IMDS2.Labels),1);   % get category labels
[trainingDS2,validationDS2] = splitEachLabel(IMDS2,0.8,'randomize'); % generate training and validation set
LabelCnt = countEachLabel(IMDS2);
load('XONet_Prewitt_Signal.mat');
XONet2=XONet;
XONet2.Layers;
layer = 'fc';
featuresTrain2 = activations(XONet2,trainingDS2,layer,'OutputAs','rows');
featuresTest2= activations(XONet2,validationDS2,layer,'OutputAs','rows');
size(featuresTrain2);
YTrain2 = trainingDS2.Labels;
YTest2 = validationDS2.Labels;

%% FUSING THE features by Concatenation

FeaturesTrain1=[featuresTrain1;featuresTrain2];
FeaturesTest1=[featuresTest1;featuresTest2];
YTrain=[YTrain1;YTrain2];
YTest=[YTest1;YTest2];



%% DEPTH DATA FEATURE EXTRACTION
numChannels =3;
IMDS3 = imageDatastore('Depth_227x227x3\','IncludeSubfolders',true,....
      'FileExtensions','.jpg','LabelSource','foldernames');
  example_image = readimage(IMDS3,1);                      % read one example image
numChannels = size(example_image,3);                    % get color information
numImageCategories = size(categories(IMDS3.Labels),1);
[trainingDS3,validationDS3] = splitEachLabel(IMDS3,0.8,'randomize'); % generate training and validation set
LabelCnt = countEachLabel(IMDS3) ;
load('XONet_depth.mat');
XONet3=XONet;
XONet3.Layers;
layer = 'fc8';
featuresTrain3 = activations(XONet3,trainingDS3,layer,'OutputAs','rows');
featuresTest3 = activations(XONet3,validationDS3,layer,'OutputAs','rows');
size(featuresTrain3);
YTrain3 = trainingDS3.Labels;
YTest3 = validationDS3.Labels;

%% Prewitt images feature extraction


  IMDS4 = imageDatastore('Depth_Prewitt\','IncludeSubfolders',true,....
      'FileExtensions','.jpg','LabelSource','foldernames');
  numImageCategories = size(categories(IMDS4.Labels),1);   % get category labels
[trainingDS4,validationDS4] = splitEachLabel(IMDS4,0.8,'randomize'); % generate training and validation set
LabelCnt = countEachLabel(IMDS4);
load('XONet_Prewitt_depth.mat');
XONet4=XONet;
XONet4.Layers;
layer = 'fc8';
featuresTrain4 = activations(XONet4,trainingDS4,layer,'OutputAs','rows');
featuresTest4= activations(XONet4,validationDS4,layer,'OutputAs','rows');
size(featuresTrain4);
YTrain4 = trainingDS4.Labels;
YTest4 = validationDS4.Labels;

%% FUSING THE features by Concatenation
FeaturesTrain2=[featuresTrain3;featuresTrain4];
FeaturesTest2=[featuresTest3;featuresTest4];
YYTrain=[YTrain3;YTrain4];
YYTest=[YTest3;YTest4];

%% Final CCA Fusion
FeaturesTrain2 = imresize(FeaturesTrain2,size(FeaturesTrain1));
FeaturesTest2 = imresize(FeaturesTest2,size(FeaturesTest1));
[FeatureTrain,FeatureTest] = Fusion(FeaturesTrain1,FeaturesTrain2, FeaturesTest1, FeaturesTest2,'sum');
YTrain=[YTrain1;YTrain2];
YTest=[YTest1;YTest2];




%% Fit Image Classifier

 %Fit a multiclass support vector machine (SVM) using fitcecoc (Statistics and Machine Learning Toolbox).

classifier = fitcecoc(FeatureTrain,YTrain);

%Classify Test Images

%Classify the test images using the trained SVM model the features extracted from the test images.

YPred = predict(classifier,FeatureTest);
confMat = confusionmat(YTest,YPred);
confMat = bsxfun(@rdivide,confMat,sum(confMat,2));
accuracy = mean(YPred == YTest)
