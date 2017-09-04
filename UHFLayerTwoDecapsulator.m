%% UHFLayer2Decapsulate.m

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

[synci, packetL, pac] = findSync(syncSeqHex, dataStream);

% TODO: add the rest of the data stream on queue again
% TODO: What happens if the message is longer than 255 bytes while in RS?

%% Payload stripping

cspHeader = pac(1:32);
packet = pac(33+1:end);

% synci in this case is 97*4=388
%
%% Extract the packet from the data stream with the length parameter

% We are assuming that the length parameter is the length of the packet plus the
% length parameter

hexoutput = binArrToHexStr(packet);