function ret = binArrToDec8BitArr( binArr )
%BINARRTODECARR Summary of this function goes here
%   Detailed explanation goes here
    ret = [];
    numBitsPerInteger = 8;
    for i = 1:numBitsPerInteger:length(binArr)
        lastElementIndex = i+numBitsPerInteger-1;
        if lastElementIndex <= length(binArr)
            tempBinArr = binArr(i:lastElementIndex);
            tempDec = bi2de(tempBinArr, 'left-msb');
            ret = [ret tempDec];
        end
    end

end

