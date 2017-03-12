function [  ] = trainCnb( path )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    trainVectors = loadTrainData(path);
    trainClasses = zeros(9,1016);
    for a = 1:10
        trainClasses(a,:) = ones(1,1016) * a-1;
    end
    model = doCnb(trainVectors, trainClasses);
    save('cnbClassifier', 'model')
end
