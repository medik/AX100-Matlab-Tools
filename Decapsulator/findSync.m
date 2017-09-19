function ret = findSync(syncSeq, dataStream)
% FINDSYNC finding sync and packet length in a binary datastream
    foundSync = 0;
    maybeSync = 0;
    syncIndex = 0;
    k = 1;
    
    % Create dictionary
    ret = containers.Map;
    
    %syncSeq = hexStrToBinArr(syncHex);
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
            
            ret('sync_index') = syncIndex;
            break;
        end
    end
    if foundSync == 1
        %% Retrieve the length parameter

        possiblePacket = dataStream(syncIndex:end);

        offset = 1;
        lengthParamLocation = length(syncSeq) + offset; % this is the first bit of the length param

        %% Return packet

        % TODO: require that the the packet length is smaller than the array
        % TODO: handle if there aren't a sync in the packet stream
        
        firstBitIndex = lengthParamLocation;
        packetLength = ...
            hex2dec( ...
                binArrToHexStr( ...
                    possiblePacket(firstBitIndex:firstBitIndex+8) ...
                ) ...
            );
        ret('length') = packetLength; % The length parameter is in bytes
        
        packetLenBits = 8*packetLength;
        lastBitIndex = lengthParamLocation+packetLenBits;
        
        ret('packet') = possiblePacket(firstBitIndex:lastBitIndex);
    else
        ret('sync_index') = -1;
        %disp('No sync found');
    end
end