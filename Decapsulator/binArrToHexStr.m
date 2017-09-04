function ret = binArrToHexStr(binArr)
    ret = '';

    for i = 1:4:length(binArr)
        if i+3 <= length(binArr)
            tempBinArr = binArr(i:i+3);
            tempDec = bi2de(tempBinArr, 'left-msb');
            tempHex = dec2hex(tempDec);
            ret = strcat(ret, tempHex);
        end
    end
end
