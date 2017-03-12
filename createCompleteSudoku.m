function [ ] = createCompleteSudoku( complete )
%CREATECOMPLETESUDOKU Summary of this function goes here
%   Detailed explanation goes here
    centroids = zeros(9,9,2);
    for a = 1:9
        centroids(a,:,1) = linspace(27.75,472.25,9);
    end
    centroids(:,:,2) = centroids(:,:,1)';
    
    figure
    I = imread('empty.jpg');
    imshow(I)
    
    
    
    out=cell2mat(cellfun(@(x) cell2mat(x),complete,'un',0));
    
    [n,m] = size(centroids);
    size(out)
    count = 0;
    
    for a=1:9
        for b=1:9
            count = count + 1;
            temp = [centroids(a,b,1)-15,centroids(a,b,2)];
            text('position',temp, 'fontsize',20,'string',out(1,count), 'Color', 'b')
        end
    end
    
    saveas(gcf,'static/images/populated.png')
    
end

