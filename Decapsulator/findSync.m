function syncIndex = findSync(syncSeq, dataStream)
% FINDSYNC finding sync and packet length in a binary datastream
    maybeSync = 0;
    syncIndex = -1;
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
            syncIndex = i + 1 - length(syncSeq);
            
            ret('sync_index') = syncIndex;
            break;
        end
    end

end