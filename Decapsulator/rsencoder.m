function ret = rsencoder(pac)
%RSENCODER Summary of this function goes here
%   Detailed explanation goes here
    ints = binArrToDec8BitArr(pac);
    
    k=length(ints); % length of the message
    n=k+32; % length of the message plus Reed-Solomon
    
    encoded = rsenc(gf(ints, 8), n, k);
    encoded = encoded.x;
                                    
    ret = dec8BitArrToBinArr(encoded);

end

