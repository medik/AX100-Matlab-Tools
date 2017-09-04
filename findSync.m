function [syncIndex, packetLength, packet] = findSync(syncHex, dataStream)
% FINDSYNC finding sync and packet length in a binary datastream
    foundSync = 0;
    maybeSync = 0;
    syncIndex = 0;
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
            % If it is not the sync, reset
            maybeSync = 0;
            k = 1;
        end

        if k == length(syncSeq)
            foundSync = 1;
            syncIndex = i + 1 - length(syncSeq);
            break;
        end
    end
    if foundSync == 1
        %% Retrieve the length parameter

        possiblePacket = dataStream(syncIndex:end);

        % Retrieve the Length parameter from the data stream
        % the length parameter is 1 byte i.e. 8 bits

        % This is the position of the first bit
        lengthParamLocation = length(syncSeq) + 1;
        lengthBitVector = possiblePacket(lengthParamLocation:lengthParamLocation + 8);

        % Calculate the length in decimal
        packetLength = 0;
        base = 2;
        baseSum = 1;

        flippedLenBitVector = fliplr(lengthBitVector);

        for i = 1:length(flippedLenBitVector)
            packetLength = packetLength + baseSum*flippedLenBitVector(i);
            baseSum = baseSum*base;
        end

        % The length parameter is in bytes

        %% Return packet

        % TODO: require that the the packet length is smaller than the array
        % TODO: handle if there aren't a sync in the packet stream
        lengthParamLocation
        packetLength
        size(possiblePacket)
        packet = possiblePacket(lengthParamLocation + 8:8*packetLength);
    else
        disp('No sync found');
    end
end