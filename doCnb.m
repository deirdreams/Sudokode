function [ model ] = doCnb( t_f, t_c )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    [m,~,~] = size(t_f);
    tempTable = array2table(squeeze(t_f(1,:,:)));
    tempClasses = t_c(1,:);
    for a = 2:m
        tempTable = vertcat(tempTable, array2table(squeeze(t_f(a,:,:))));
    end
    counter = 0;
    val = 0;
    [~, classSize] = size(t_c);
    for a = 1:classSize*10
        tempClasses(1,a) = val;
        if(counter == 1016)
            val = val + 1;
            counter = 0;
        end
        counter = counter + 1;
    end
    size(tempClasses)
    size(tempTable)
    model = fitcnb(tempTable,tempClasses);

end