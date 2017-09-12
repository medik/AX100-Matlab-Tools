function ret = binArrToStr( binArr )
%BINARRTOSTR Summary of this function goes here
%   Detailed explanation goes here
    str = '';
    for i=1:length(binArr)
        str = strcat(str, num2str(binArr(i)));
    end
    
    ret = str;
end

