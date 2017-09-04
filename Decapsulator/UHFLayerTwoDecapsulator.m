%% UHFLayerTwoDecapsulate.m

clear
% Olof Sjödin <me@olofsjodin.se> 2017
% KTH Royal institute of Technology
% School of Electrical Engineering

% Input parameters
syncSeqHex = 'c985a8ef';

% Get dataStream from output file
fileID = fopen('output');
dataStreamInt = fread(fileID, 'ubit8');
dataStreamHexArr = dec2hex(dataStreamInt);

dataStreamHex = '';
for i=1:length(dataStreamHexArr)
    dataStreamHex = strcat(dataStreamHex, dataStreamHexArr(i,:));
end

dataStream = hexStrToBinArr(dataStreamHex);

fid_w = fopen('data.bin','w');

%packetsFound = containers.Map('KeyType','int32','ValueType','any')
extractedData = [];
EOF = 0;
while EOF ~= 1
    output = findSync(syncSeqHex, dataStream);
    if output('sync_index') ~= -1
        pac = output('packet');
        % TODO: What happens if the message is longer than 255 bytes while in RS?
        
        %% Reed-Solomon
        % Should we RS the length parameter as well? Maybe, let's assume it
        % first.
        packet = rsdecoder(pac);
        
        %% Payload stripping
        %len = pac(1:8);
        cspHeader = pac(1+8:32+8);
        
        priority = cspHeader(1:2);
        source = cspHeader(3:7);
        destination = cspHeader(8:12);
        destPort = cspHeader(13:18);
        sourcePort = cspHeader(19:24);
        reserved = cspHeader(25:28);
        hmac = cspHeader(29);
        xtea = cspHeader(30);
        rdp = cspHeader(31);
        crc = cspHeader(32);
        
        %packet = packet(33+8+1:end);
        
        %% Add packet to array
        fprintf(fid_w, strcat(strcat(binArrToHexStr(packet(1:end)),'\n')));
        extractedData = [extractedData packet];
        
        %% Update dataStream
        synclen = length(syncSeqHex)*4; % 4 bits per number
        len = output('length') * 8;
        
        newStartIndex = output('sync_index') + synclen + len; % maybe?
        
        dataStream = dataStream(newStartIndex:end);
    else
        EOF = 1;
    end
end
fclose(fid_w);