function [ fullMatrix ] = loadTrainData( path )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    fullMatrix = zeros(9,1016,4);
    shorterStringThing = 'img00';
    for a=1:9
        stringThing = '0000';
        counter = 0;
        factor = 1;
        if(a == 9)
            shorterStringThing = shorterStringThing(1:end-1);
        end
        subPath = [path, '/', int2str(a)];
        for b=1:1016
            if(counter == 9*factor)
                stringThing = stringThing(1:end-1);
                counter = 0;
                factor = factor * 10;
            end
            vector = zeros(1,4);
            img = imread([subPath, '/', shorterStringThing, int2str(a+1), '-', stringThing, int2str(b), '.png']);
            bin = imcomplement(imbinarize(img));
            CC = bwconncomp(bin,8);
            %imshow(bin)
            features = regionprops('struct', CC(1), 'Eccentricity', 'EulerNumber', 'Extent', 'Solidity');
            vector(1) = features.Extent;
            vector(2) = features.Solidity;
            vector(3) = features.Extent;
            vector(4) = features.Solidity;
            fullMatrix(a+1,b,:) = vector;
            counter = counter + 1;
        end
    end
            
        

end

