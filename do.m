function [ output ] = do( path, photo )

    %% Read and analyze image
    rawImg = imread(path);
    if(strcmp(photo,'Yes'))
        T = adaptthresh(rgb2gray(rawImg), 0.76);
        bin = imbinarize(rgb2gray((rawImg)), T);
        imshow(bin);
    else
        bin = imbinarize(rgb2gray((rawImg)));
        imshow(bin);
    end
    
    invert = imcomplement(bwareaopen(bin, 1000));
    CC = bwconncomp(bwareaopen(invert, 100),8);
    features = regionprops('struct', CC, 'Centroid', 'Eccentricity', 'Extent', 'Solidity');
    [m,n] = size(features);
    allNumbers = zeros(m-1,4);
    for a = 2:m
        vector = zeros(1,4);
        vector(1) = features(a).Extent;
        vector(2) = features(a).Solidity;
        vector(3) = features(a).Extent;
        vector(4) = features(a).Solidity;
        allNumbers(a,:) = vector;
    end
    size(allNumbers)
    
    %% Predict stuff
    %model = trainKnn('Data');
    load('knnClassifier', 'model')
    %load('cnbClassifier', 'model')
    
    predictions = zeros(1,m-1);
    
    for a = 2:m
        x = model.predict(allNumbers(a,:));
        predictions(1,a) = x;
    end
    
    predictions
    
    
    %% Label Image
    bb = regionprops('struct', CC, 'BoundingBox');
    ex = regionprops('struct', CC, 'Extrema');
    x = cell2mat(struct2cell(bb));
    hold on
    [m,n] = size(bb);
    size(predictions)
    m
    for a = 2:m
        t = predictions(a);
        rectangle('Position', bb(a).BoundingBox ,'EdgeColor','r', 'LineWidth', 2)
        text('position',[ex(a).Extrema(1),ex(a).Extrema(1,2)], 'fontsize',20,'string',num2str(t), 'Color', 'b') 
    end
    
    %% Matrix of Centroids
    
    output = ones(9,9) * -1;
    centroids = zeros(9,9,2);
    constantDistance = 55.5;
    for a = 1:9
        centroids(a,:,1) = linspace(27.75,472.25,9);
    end
    centroids(:,:,2) = centroids(:,:,1)';
    
    for a = 2:m
        xC = features(a).Centroid(1);
        yC = features(a).Centroid(2);
       for b = 1:9
            for c = 1:9
                distance = pdist2([xC,yC], [centroids(b,c,1), centroids(b,c,2)]);
                if(distance < 35)
                    output(b,c) = predictions(a);
                end
            end 
       end
    end
    
    figure 
    imshow(bin)
    saveas(gcf,'static/images/seen.png')
    
    
    %% Format Matrix
    
    %{
    output = ones(9,9) * -1;
    squares = bwconncomp(bwareaopen(bin, 1000),26);
    squaresF = regionprops('struct', squares, 'Extent');
    squaresF
    numsInserted = 1;
    figure
    imshow(bin)
    
    bb = regionprops('struct', squares, 'BoundingBox');
    ex = regionprops('struct', squares, 'Extrema');
    x = cell2mat(struct2cell(bb));
    hold on
    [m,n] = size(bb);
    for a = 1:m
        rectangle('Position', bb(a).BoundingBox ,'EdgeColor','r', 'LineWidth', 2)
    end
    
    
    for a = 1:squares.NumObjects
        if(squaresF(a).Extent < 0.95)
            output(a) = predictions(numsInserted+1);
            numsInserted = numsInserted + 1;
        end
    end
    
    numsInserted
    %}
    %close all
end

