function binaryOut = dec8BitArrToBinArr( decArr )
%D Summary of this function goes here
%   Detailed explanation goes here
    binaryOut = [];
    for i=1:length(decArr)
        tempBin = de2bi(decArr(i),'left-msb');
        
        % Add padding
        if length(tempBin) < 8
            tempBin = [zeros(1, 8-length(tempBin)) tempBin];
        end
        binaryOut = [binaryOut tempBin];
    end

end

