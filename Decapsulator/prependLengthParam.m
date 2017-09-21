function ret = prependLengthParam( packet )
%PREPENDLENGTHPARAM Summary of this function goes here
%   Detailed explanation goes here
    len = length(packet)/8 + 1; % length in bytes
    ret = [decToBinArr(len) packet];

end

