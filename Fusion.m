function [train_Z,test_Z] = Fusion(train_X, train_Y, test_X, test_Y, mode)

[n,p] = size(train_X);
if size(train_Y,1) ~= n
    error('trainX and trainY must have the same number of samples.');
elseif n == 1
    error('trainX and trainY must have more than one sample.');
end
q = size(train_Y,2);


if size(test_X,2) ~= p
    error('trainX and testX must have the same dimensions.');
end

if size(test_Y,2) ~= q
    error('trainY and testY must have the same dimensions.');
end

if size(test_X,1) ~= size(test_Y,1)
    error('testX and testY must have the same number of samples.');
end

if ~exist('mode', 'var')
    mode = 'sum';	
end

meanX = mean(train_X);
meanY = mean(train_Y);
train_X = bsxfun(@minus, train_X, meanX);
test_X  = bsxfun(@minus, test_X,  meanX);
train_Y = bsxfun(@minus, train_Y, meanY);
test_Y  = bsxfun(@minus, test_Y,  meanY);

[Wxcca,Wycca] = canoncorr(train_X,train_Y);

trainXcca = train_X * Wxcca;
trainYcca = train_Y * Wycca;
testXcca = test_X * Wxcca;
testYcca = test_Y * Wycca;

if strcmp(mode, 'concat')	
    train_Z = [trainXcca, trainYcca];
    test_Z  = [testXcca, testYcca];
else                       
    train_Z = trainXcca + trainYcca;
    test_Z  = testXcca + testYcca;
end
