%% UHFLayer2Decapsulate.m

% Olof Sjödin <me@olofsjodin.se> 2017
% KTH Royal institute of Technology
% School of Electrical Engineering, SPP

% Input parameters
syncSeqHex = '930b51de';
dummyDataStream = '555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555930b51de89a8107000000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455000000955d34dc5d5e5f606162638599b3cf567a44c4bf2e79102e8c9eeb72ab8930b51de89a8107600000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f60616263ce4023cc1d5c13df767d8ea328ec9ab63f935e0af0bcf87eef7c2c1b6e8e4a35930b51de89a810770000010203930b51de89a8107600000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f60616263ce4023cc1d5c13df767d8ea328ec9ab63f935e0af0bcf87eef7c2c1b6e8e4a35930b51de89a810770000010203930b51de89a8107600000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f60616263ce4023cc1d5c13df767d8ea328ec9ab63f935e0af0bcf87eef7c2c1b6e8e4a35930b51de89a810770000010203930b51de89a8107600000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f60616263ce4023cc1d5c13df767d8ea328ec9ab63f935e0af0bcf87eef7c2c1b6e8e4a35930b51de89a810770000010203930b51de89a8107600000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f60616263ce4023cc1d5c13df767d8ea328ec9ab63f935e0af0bcf87eef7c2c1b6e8e4a35930b51de89a810770000010203930b51de89a8107600000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f60616263ce4023cc1d5c13df767d8ea328ec9ab63f935e0af0bcf87eef7c2c1b6e8e4a35930b51de89a810770000010203930b51de89a8107600000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f60616263ce4023cc1d5c13df767d8ea328ec9ab63f935e0af0bcf87eef7c2c1b6e8e4a35930b51de89a810770000010203930b51de89a8107600000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f60616263ce4023cc1d5c13df767d8ea328ec9ab63f935e0af0bcf87eef7c2c1b6e8e4a35930b51de89a810770000010203';

dataStream = [];

for i = 1:length(dummyDataStream)
    dec = hex2dec(dummyDataStream(i));
    bin = de2bi(dec);
    dataStream = [dataStream bin];
end

%dataStream = [0 0 0 0 0 0 1 0 1 0 1 0 1 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];

%% Generate the binary sync sequence
syncSeq = [];

for i = 1:length(syncSeqHex)
    dec = hex2dec(syncSeqHex(i));
    bin = de2bi(dec);
    if length(bin) < 8
        bin = [zeros(1,8-length(bin)) bin];
    end
    syncSeq = [syncSeq bin];
end








%% Extract the packet from the data stream with the length parameter

% We are assuming that the length parameter is the length of the packet plus the
% length parameter

thePacket = possiblePacket(lengthParamLocation:lengthDecimal*8);

function [syncIndex, packetLength] = findSync(syncHex, dataStream)
% FINDSYNC finding sync and packet length in a binary datastream
    foundSync = 0;
    maybeSync = 0;
    syncLocation = 0;
    k = 1;
    
    syncSeq = hexStrToBinArr(syncHex);
    % This sync search should do it with a certain confidence
    % so that if 28 bits of 32 match it will consider it as a match

    for i=1:length(dataStream)
        if maybeSync == 1
            k = k + 1;
        end

        if syncSeq(k) == dataStream(i)
            maybeSync = 1;
        else
            maybeSync = 0;
        end

        if k == length(syncSeq)
            foundSync = 1;
            syncLocation = i + 1 - length(syncSeq);
            break;
        end
    end
    
    %% Retrieve the length parameter

    possiblePacket = dataStream(syncLocation:end);

    % Retrieve the Length parameter from the data stream
    % the length parameter is 1 byte i.e. 8 bits

    % This is the position of the first bit
    lengthParamLocation = length(syncSeq) + 1;
    lengthBitVector = possiblePacket(lengthParamLocation:lengthParamLocation + 8);

    % Calculate the length in decimal
    lengthDecimal = 0;
    base = 2;
    baseSum = 1;

    flippedLenBitVector = fliplr(lengthBitVector);

    for i = 1:length(flippedLenBitVector)
        lengthDecimal = lengthDecimal + baseSum*flippedLenBitVector(i);
        baseSum = baseSum*base;
    end

    % The length parameter is in bytes
end

function ret = hexStrToBinArr(hexStr)
    ret = [];

    for i = 1:length(hexStr)
        dec = hex2dec(hexStr(i));
        bin = de2bi(dec);
        if length(bin) < 8
            bin = [zeros(1,8-length(bin)) bin];
        end
        ret = [syncSeq bin];
    end
end

function ret = binArrToHexStr(binArr)
    ret = '';

    for i = 1:8:length(thePacket)
        if i+8 < length(thePacket)
            binArr = thePacket(i:i+8);
            dec = bi2de(binArr);
            hex = dec2hex(dec);
            ret = strcat(ret, hex);
        end
    end
end

