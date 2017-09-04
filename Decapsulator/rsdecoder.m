function ret = rsdecoder(pac)
%RSDECODER Summary of this function goes here
%   Detailed explanation goes here
    %% Reed-Solomon Decoder
    
    % Transform the bit array to an array of integers in GF(8)

    ints = binArrToDec8BitArr(pac);
    
    n=length(ints);
    k=n-32;
    
    decoded = rsdec(gf(ints, 8), n, k);
    decoded = decoded.x;
                                    
    ret = dec8BitArrToBinArr(decoded);
end

