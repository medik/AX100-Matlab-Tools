function ret = binArrToDec( binArr )
%BINARRTODEC Summary of this function goes here
%   Detailed explanation goes here

    if mod(length(binArr), 4) > 0
        padding = (4-mod(length(binArr), 4)); 
        for i=1:padding
            binArr = [0 binArr];
        end
    end
    
    ret = ...
        hex2dec(...
            binArrToHexStr(...
                binArr...
            )...
        );   

end

