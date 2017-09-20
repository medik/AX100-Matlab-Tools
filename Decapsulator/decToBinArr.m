function ret = decToBinArr(dec)
%DECTOBINARR Summary of this function goes here
%   Detailed explanation goes here
    ret = hexStrToBinArr(...
            dec2hex(dec)...
          );

end

