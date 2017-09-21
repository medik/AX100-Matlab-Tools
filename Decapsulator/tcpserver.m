% Listen to 4012 and wait for a connection
t = tcpip('0.0.0.0', 30000, 'NetworkRole', ...
    'server');

disp('Start TCP Server')
syncArr = [1 1 0 1 0 1 0 0 0 1 1 1 0 1 1 1 1 0];
while 1
    fopen(t);
    disp('Got a connection');
    disp('Waiting');
    while t.BytesAvailable == 0
        disp('...');
        pause(1);
    end

    dataStreamInt = [];
    while t.BytesAvailable > 0
        disp(int2str(t.BytesAvailable));
        temp = fread(t, t.BytesAvailable, 'uint8');
        dataStreamInt = [dataStreamInt; temp];
        pause(0.1);
    end

    resp = packetHandler('recieved-data.bin', dataStreamInt, ...
            syncArr, 0);
        
    if length(resp) >= 512*8
        sync = hexStrToBinArr('6cf8a828');
        resp = [sync resp];
        
        disp(...
            strcat('Sent:', ...
                binArrToHexStr(resp))...
            );
            
        towrite = binArrToDec8BitArr(resp);
        
        % Set buffer size to the outputs buffer size
        bufsize = t.OutputBufferSize;

        % Fill the buffer and update towrite
        buffer = towrite(1:bufsize);
        towrite = towrite(bufsize:end);

        while ~isempty(buffer)
          % Write the content of the buffer to socket
          fwrite(t, buffer);

          % Empty the buffer
          buffer = [];

          % Add new content to the buffer
          if length(towrite) < bufsize
              buffer = towrite(1:end);
              towrite = [];
          else
              buffer = towrite(1:bufsize);
              towrite = towrite(bufsize:end);
          end

          while t.BytesToOutput ~= 0
              pause(0.1);
              disp("..."),
          end
        end
        disp('Done handling data');
    end

    fclose(t);
end
fclose(t);