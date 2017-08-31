function ret = hexStrToBinArr(hexStr)
    ret = [];

    for i = 1:length(hexStr)
        dec = hex2dec(hexStr(i));
        bin = de2bi(dec,'left-msb');
        if length(bin) < 4
            bin = [zeros(1,4-length(bin)) bin];
        end
        ret = [ret bin];
    end
end